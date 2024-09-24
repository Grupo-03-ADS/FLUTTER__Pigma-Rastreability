import 'package:flutter/gestures.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pigma/backend/schema/structs/positions_struct.dart';
import 'package:url_launcher/url_launcher.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '/components/sem_viagem_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'home_model.dart';
export 'home_model.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:location/location.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
    this.localizacao,
  });
  final LatLng? localizacao;
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late SnackBar locationIssuesSnackBar;                                                      

  final location = Location();
  
  double? latitude;
  double? longitude;
  DateTime? savedTime;

  final bool _isMultipleStop = false;
  MapBoxNavigationViewController? _controller;
  late MapBoxOptions _navigationOption;
  final MapBoxNavigation _mapboxNavigation = MapBoxNavigation();
  List<WayPoint> wayPoints = [];
  late HomeModel _model;
  int distance = 0;
  String unit = "";
  bool hasLocationIssues = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      loop: true,
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: const Offset(0.0, -22.0),
          end: const Offset(0.0, 22.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  bool showMap = true;
  late List<ConnectivityResult> connectivityResult;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
    
    location.enableBackgroundMode(enable: true);

    if(FFAppState().latLngDriver != null)
    {
      latitude = FFAppState().latLngDriver!.latitude;
      longitude = FFAppState().latLngDriver!.longitude;
    }

    locationIssuesSnackBar = SnackBar( 
      content: const Text(
        'Não foi possível obter a localização do dispositivo. Verifique se o GPS encontra-se ativo e se a permissão de acesso foi concedida.',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      duration: const Duration(milliseconds: 4000),
      backgroundColor: FlutterFlowTheme.of(context).error,
    );

    () async {
      await _getLocation().whenComplete( () => currentUserLocationValue = FFAppState().latLngDriver );
      setState(() {});
    } ();

    savedTime = DateTime.now();

    MapBoxNavigation.instance.setDefaultOptions(MapBoxOptions(
      //_navigationOption.simulateRoute = true;
      mode: MapBoxNavigationMode.driving,
      language: "pt-BR",
      initialLatitude: FFAppState().latLngDriver?.latitude,
      initialLongitude: FFAppState().latLngDriver?.longitude,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      units: VoiceUnits.metric,
      showEndOfRouteFeedback: false,
      showReportFeedbackButton: false,
      longPressDestinationEnabled: false,
    ));

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _mapboxNavigation.setDefaultOptions(_navigationOption);
    _mapboxNavigation.registerRouteEventListener(_onEmbeddedRouteEvent);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if(!FFAppState().acceptedTermsAndPrivacy) {
        showConfirmConsentDialog(context);
      }

      int differenceInMinutes = 0;
      int differenceInSeconds = 0;

      while (FFAppState().routeSelected.hasRouteId()) {
        _getLocation();

        DateTime currentTime = DateTime.now();

        Duration diff = currentTime.difference(savedTime!);
        differenceInMinutes = diff.inMinutes;
        differenceInSeconds = diff.inSeconds;

        if (differenceInMinutes >= 5) {

          if((latitude != null && longitude != null) && (latitude!.truncate() != 0 && longitude!.truncate() != 0))
          {
            savedTime = DateTime.now();

            setState(() {
              FFAppState().addToPositions(PositionsStruct(
                cpf: FFAppState().cpf,
                routeId: FFAppState().routeSelected.routeId,
                latitude: FFAppState().latLngDriver?.latitude,
                longitude: FFAppState().latLngDriver?.longitude,
                date: DateTime.now().subtract(DateTime.now().timeZoneOffset).subtract(const Duration(hours: 3)),
                finish: false,
              ));
            });
          }

          // else {
          //   await Future.delayed(const Duration(milliseconds: 10000));
          // }
        }

        if ((differenceInSeconds % 60) == 0) {
          //Verificar se está com rede para realizar chamada para API
          postRoute(false);
          setState(() {});
        }

        else if((differenceInSeconds % 10) == 0)
        {
          connectivityResult = await Connectivity().checkConnectivity();
        }
        
        await Future.delayed(const Duration(milliseconds: 1000));
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();

    _model.dispose();

    super.dispose();
  }

  Future<void> _getLocation() async {

    try {
      // bool serviceEnabled = await location.serviceEnabled();

      // if (!serviceEnabled) {
      //   serviceEnabled = await location.requestService();
        
      //   if (!serviceEnabled) {
      //     hasLocationIssues = true;
      //   }
      // }

      // PermissionStatus permissionGranted = await location.hasPermission();

      // if (permissionGranted == PermissionStatus.denied) {   
      //   permissionGranted = await location.requestPermission();

      //   if (permissionGranted != PermissionStatus.granted) {
      //     hasLocationIssues = true;
      //   }
      // }

      // if(!hasLocationIssues)
      // {
        var currentLocation = await location.getLocation();
    
        setState(() {
          latitude = currentLocation.latitude;
          longitude = currentLocation.longitude;
          FFAppState().latLngDriver = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      // }
    } 
    catch (e) {
      hasLocationIssues = true;
    }

    if(hasLocationIssues) {
      ScaffoldMessenger.of(context).showSnackBar(locationIssuesSnackBar);
      hasLocationIssues = false;
    }
  }

  bool calculateDistanceInMostReadableUnit(LatLng coord1, double lat, double long,) {
    var distanceInMeters = functions.calculateDistanceInMeters(coord1, lat, long);

    if(distanceInMeters > 9999) {
      distance = distanceInMeters ~/ 1000;
      unit = "Km";
    }

    else {
      distance = distanceInMeters;
      unit = "Metros";
    }

    return true;
}

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus ? FocusScope.of(context).requestFocus(_model.unfocusNode) : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: 60.0,
                  decoration: BoxDecoration( 
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: [ BoxShadow(
                      color: FlutterFlowTheme.of(context).accent2,
                      blurRadius: 0.1,
                      blurStyle: BlurStyle.solid,
                      )],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/image_4.png',
                              width: 64.0,
                              height: 40.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    showRemoveConsentDialog(context);
                                  },
                                  child: const Icon(
                                    Icons.description_outlined,
                                    color: Color(0xFF2D2D6B),
                                    size: 28.0,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await launchURL('https://wa.me/5545999943008?text=Ol%C3%A1%2C%20preciso%20de%20ajuda%20com%20meu%20aplicativo%20Lakre');
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    color: FlutterFlowTheme.of(context).tertiary,
                                    size: 28.0,
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _model.botaoRota = true;
                                  setState(() {
                                    FFAppState().viagemDisponivel = RouteStruct();
                                    FFAppState().cpf = '';
                                    FFAppState().routeSelected = RouteStruct();
                                  });

                                  context.pushReplacementNamed('codigoAcesso');
                                },
                                child: const Icon(
                                  Icons.logout_rounded,
                                  color: Color(0xFF2D2D6B),
                                  size: 28.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      if (!FFAppState().routeSelected.hasRouteId())
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              wrapWithModel(
                                model: _model.semViagemModel,
                                updateCallback: () => setState(() {}),
                                child: const SemViagemWidget(),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 50.0, 20.0, 50.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FFButtonWidget(
                                      onPressed: () async {
                                        await launchURL('https://wa.me/5545999943008?text=Ol%C3%A1%2C%20preciso%20de%20ajuda%20com%20meu%20aplicativo%20Lakre');
                                      },
                                      text: 'Contatar gestor',
                                      icon: const FaIcon(
                                        FontAwesomeIcons.whatsapp,
                                      ),
                                      options: FFButtonOptions(
                                        width: 175.0,
                                        height: 50.0,
                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: const Color(0xFF28B446),
                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                              fontFamily: 'Inter',
                                              color: Colors.white,
                                            ),
                                        elevation: 3.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    FFButtonWidget(
                                      onPressed: () async {
                                        setState(() {
                                          FFAppState().fromRefresh = true;
                                        });
                                        context.pushReplacementNamed('codigoAcesso');
                                      },
                                      text: 'Atualizar',
                                      icon: const FaIcon(
                                        FontAwesomeIcons.arrowsRotate,
                                      ),
                                      options: FFButtonOptions(
                                        width: 175.0,
                                        height: 50.0,
                                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: const Color(0xFF4646B4),
                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                        ),
                                        elevation: 3.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ]
                                )
                              )
                            ],
                          )
                        )
                      else
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.grey,
                                    child: MapBoxNavigationView(
                                      options: _navigationOption,
                                      key: const Key("mapStatic"),
                                      onCreated: (MapBoxNavigationViewController controller) async {
                                        // _controller = controller;
                                        _model.menu = true;

                                        // await _getLocation();

                                        var index = 1;

                                        wayPoints.add(WayPoint(name: "Inicio", latitude: FFAppState().latLngDriver?.latitude, longitude: FFAppState().latLngDriver?.longitude, isSilent: false));
                                        
                                        for (var element in FFAppState().routeSelected.stops) {
                                          if (!element.isComplete) {
                                            wayPoints.add(WayPoint(name: "Destino $index", latitude: element.latitude, longitude: element.longitude, isSilent: false));
                                          }
                                          index++;
                                        }

                                        _controller?.buildRoute(wayPoints: wayPoints, options: _navigationOption);
                                      },
                                      onRouteEvent: _onEmbeddedRouteEvent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (FFAppState().stopInProgress.hasStopId() && _model.menu)
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                                                      child: Container(
                                                        height: 100.0,
                                                        decoration: BoxDecoration(
                                                          color: FlutterFlowTheme.of(context).accent3,
                                                          borderRadius: BorderRadius.circular(8.0),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Expanded(
                                                                child: Stack(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 12.0, 0.0, 0.0),
                                                                      child: Container(
                                                                        width: 2.0,
                                                                        height: 68.0,
                                                                        decoration: const BoxDecoration(
                                                                          color: Color(0x5B757575),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                                      child: Container(
                                                                        width: 2.0,
                                                                        height: 50.0,
                                                                        decoration: BoxDecoration( color: FlutterFlowTheme.of(context).primary, ),
                                                                      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                  child: Container(
                                                                                    width: 20.0,
                                                                                    height: 20.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      borderRadius: BorderRadius.circular(24.0),
                                                                                    ),
                                                                                    child: const Icon(
                                                                                      Icons.pin_drop,
                                                                                      color: Colors.white,
                                                                                      size: 16.0,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  'Você',
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                                  child: Container(
                                                                                    width: 20.0,
                                                                                    height: 20.0,
                                                                                    decoration: BoxDecoration(
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      borderRadius: BorderRadius.circular(24.0),
                                                                                    ),
                                                                                    child: const Align(
                                                                                      alignment: AlignmentDirectional(0.0, 0.0),
                                                                                      child: FaIcon(
                                                                                        FontAwesomeIcons.flagCheckered,
                                                                                        color: Colors.white,
                                                                                        size: 12.0,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  FFAppState().stopInProgress.stopName,
                                                                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 160.0,
                                            decoration: BoxDecoration(
                                              color: functions.calculateDistanceInMeters(LatLng(latitude!, longitude!), FFAppState().stopInProgress.latitude, FFAppState().stopInProgress.longitude) 
                                                  < 500 ? FlutterFlowTheme.of(context).tertiary : FlutterFlowTheme.of(context).alternate,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                                                    child: Text(
                                                      'Distância em Raio',
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Poppins',
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                          ),
                                                    ),
                                                  ),
                                                  Text(
                                                      calculateDistanceInMostReadableUnit(LatLng(latitude!, longitude!), FFAppState().stopInProgress.latitude, FFAppState().stopInProgress.longitude)
                                                      ? distance.toString() : "",

                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontSize: 40.0,
                                                          lineHeight: 1.0,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                                                    child: Text(
                                                      unit,
                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            fontFamily: 'Poppins',
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            if ((FFAppState().routeSelected.stops.where((e) => !e.isComplete).toList().length > 1))
                                              Expanded(
                                                child: FFButtonWidget(
                                                  text: 'Finalizar Parada',
                                                  onPressed: () async {
                                                    // await _getLocation();

                                                    setState(() {
                                                      FFAppState().addToPositions(PositionsStruct(
                                                        cpf: FFAppState().cpf,
                                                        routeId: FFAppState().routeSelected.routeId,
                                                        latitude: FFAppState().latLngDriver?.latitude,
                                                        longitude: FFAppState().latLngDriver?.longitude,
                                                        date: DateTime.now().subtract(DateTime.now().timeZoneOffset).subtract(const Duration(hours: 3)),
                                                        finish: true,
                                                      ));

                                                      FFAppState().updateRouteSelectedStruct((e) => e..updateStops(
                                                        (e) => e[FFAppState().stopInProgress.stopOrder - 1]..isComplete = true,),
                                                      );

                                                      FFAppState().update(() {
                                                        FFAppState().stopInProgress = FFAppState().routeSelected.stops.where((e) => !e.isComplete).toList().first;
                                                      });
                                                    });

                                                    bool isFirstWhile = true;

                                                    while (_model.index < FFAppState().positions.length) {
                                                      connectivityResult = await Connectivity().checkConnectivity();
                                                      if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {
                                                     
                                                        if(isFirstWhile)
                                                        {
                                                          var index = 1;
                                                          isFirstWhile = false;

                                                          wayPoints.clear();
                                                          
                                                          wayPoints.add( WayPoint(
                                                            name: "Início", 
                                                            latitude: FFAppState().latLngDriver?.latitude, 
                                                            longitude: FFAppState().latLngDriver?.longitude, 
                                                            isSilent: false)
                                                          );
                                                          
                                                          for (var element in FFAppState().routeSelected.stops) {
                                                            if (!element.isComplete) {
                                                              wayPoints.add( WayPoint(
                                                                name: "Destino $index", 
                                                                latitude: element.latitude, 
                                                                longitude: element.longitude, 
                                                                isSilent: false));
                                                            }
                                                            index++;
                                                          }

                                                          _controller?.buildRoute(wayPoints: wayPoints, options: _navigationOption);
                                                        }

                                                        _model.enviarLocalizacao1 = await APIsPigmanGroup.postPositionCall.call(
                                                          cpf: FFAppState().cpf,
                                                          routeId: FFAppState().positions.first.routeId,
                                                          latitude: FFAppState().positions.first.latitude,
                                                          longitude: FFAppState().positions.first.longitude,
                                                          isFinished: FFAppState().positions.first.finish,
                                                          infoDt: dateTimeFormat(
                                                            'yyyy-MM-dd HH:mm:ss',
                                                            FFAppState().positions.first.date,
                                                            locale: FFLocalizations.of(context).languageCode,
                                                          ),
                                                        );

                                                        if ((_model.enviarLocalizacao1?.succeeded ?? true)) {
                                                          setState(() {
                                                            FFAppState().removeAtIndexFromPositions(0);
                                                          });
                                                        } 
                                                        
                                                        else {
                                                          setState(() {
                                                            _model.index = _model.index + 1;
                                                          });
                                                        }
                                                      } else {
                                                        break;
                                                      }
                                                    }
                                                    setState(() {});
                                                  },
                                                  icon: const FaIcon(
                                                    FontAwesomeIcons.flagCheckered,
                                                    size: 16.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 48.0,
                                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                    color: FlutterFlowTheme.of(context).tertiary,
                                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                ),
                                              ),


                                            if ((FFAppState().routeSelected.stops.where((e) => !e.isComplete).toList().length == 1))
                                              Expanded(
                                                child: FFButtonWidget(
                                                  text: 'Finalizar Viagem',
                                                  onPressed: () async {
                                                  //  await _getLocation();

                                                    // Adicionar posição no array
                                                    setState(() {
                                                      FFAppState().addToPositions(PositionsStruct(
                                                        cpf: FFAppState().cpf,
                                                        routeId: FFAppState().routeSelected.routeId,
                                                        latitude: FFAppState().latLngDriver?.latitude,
                                                        longitude: FFAppState().latLngDriver?.longitude,
                                                        date: DateTime.now().subtract(DateTime.now().timeZoneOffset).subtract(const Duration(hours: 3)),
                                                        finish: true,
                                                        finishViagem: true,
                                                      ));
                                                    });

                                                    FFAppState().viagemFinalizada = true;

                                                    while (_model.index < FFAppState().positions.length) {
                                                      connectivityResult = await Connectivity().checkConnectivity();
                                                      if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {
                                                        _model.enviarLocalizacaoFinal = await APIsPigmanGroup.postPositionCall.call(
                                                          cpf: FFAppState().cpf,
                                                          routeId: FFAppState().positions.first.routeId,
                                                          latitude: FFAppState().positions.first.latitude,
                                                          longitude: FFAppState().positions.first.longitude,
                                                          isFinished: FFAppState().positions.first.finish,
                                                          infoDt: dateTimeFormat(
                                                            'yyyy-MM-dd HH:mm:ss',
                                                            FFAppState().positions.first.date,
                                                            locale: FFLocalizations.of(context).languageCode,
                                                          ),
                                                        );

                                                        if ((_model.enviarLocalizacaoFinal?.succeeded ?? true)) {
                                                          if ((_model.enviarLocalizacaoFinal?.jsonBody ?? '')) {
                                                            setState(() {
                                                              FFAppState().positions = [];
                                                              FFAppState().stopInProgress = StopStruct();
                                                              FFAppState().routeSelected = RouteStruct();
                                                            });
                                                            _model.pegarNovaRota = await APIsPigmanGroup.getNextRouteCall.call(
                                                              cpf: FFAppState().cpf,
                                                            );
                                                            if ((_model.pegarNovaRota?.succeeded ?? true)) {
                                                              setState(() {
                                                                FFAppState().routeSelected = APIsPigmanGroup.getNextRouteCall.rota(
                                                                  (_model.pegarNovaRota?.jsonBody ?? ''),
                                                                )!;
                                                              });
                                                            }
                                                          } 
                                                          else {
                                                            setState(() {
                                                              FFAppState().removeAtIndexFromPositions(0);
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            _model.index = _model.index + 1;
                                                          });
                                                        }
                                                      }
                                                    }

                                                    setState(() {});
                                                    if (FFAppState().positions.isEmpty) {
                                                      context.pushReplacementNamed('home');
                                                    } else {
                                                      context.pushReplacementNamed('viagemConcluida');
                                                    }
                                                  },
                                                  icon: const FaIcon(
                                                    FontAwesomeIcons.flagCheckered,
                                                    size: 16.0,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 48.0,
                                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                    color: FlutterFlowTheme.of(context).tertiary,
                                                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Poppins',
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                        ),
                                                    elevation: 3.0,
                                                    borderSide: const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                ),
                                              ),

                                            if (_model.botaoRota)
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                                                  child: FFButtonWidget(
                                                    text: 'Iniciar navegação',
                                                    onPressed: () async {
                                                      // await _getLocation();

                                                      connectivityResult = await Connectivity().checkConnectivity();
                                                      if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {
                                                        setState(() {
                                                          FFAppState().addToPositions(PositionsStruct(
                                                            cpf: FFAppState().cpf,
                                                            routeId: FFAppState().routeSelected.routeId,
                                                            latitude: FFAppState().latLngDriver?.latitude,
                                                            longitude: FFAppState().latLngDriver?.longitude,
                                                            date: DateTime.now().subtract(DateTime.now().timeZoneOffset).subtract(const Duration(hours: 3)),
                                                            finish: false,
                                                          ));
                                                        });

                                                        postRoute(false);
                                                        wayPoints.clear();
                                                        var index = 1;

                                                        wayPoints.add(WayPoint(name: "Inicio", latitude: latitude, longitude: longitude, isSilent: false));

                                                        for (var element in FFAppState().routeSelected.stops) {
                                                          if (!element.isComplete) {
                                                            wayPoints.add(WayPoint(name: "Destino $index", latitude: element.latitude, longitude: element.longitude, isSilent: false));
                                                          }
                                                          index++;
                                                        }

                                                        _controller?.buildRoute(wayPoints: wayPoints, options: _navigationOption);
                                                      } 
     
                                                      _model.botaoRota = false;
                                                      _model.menu = false;

                                                      await MapBoxNavigation.instance.startNavigation(wayPoints: wayPoints, options: _navigationOption);

                                                      setState(() {});
                                                    },
                                                    icon: const Icon(
                                                      Icons.map_outlined,
                                                      size: 12.0,
                                                    ),
                                                    options: FFButtonOptions(
                                                      height: 48.0,
                                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                      color: Colors.transparent,
                                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                            fontFamily: 'Poppins',
                                                            color: FlutterFlowTheme.of(context).primary,
                                                            fontSize: 10.0,
                                                          ),
                                                      elevation: 0.0,
                                                      borderSide: BorderSide(
                                                        color: FlutterFlowTheme.of(context).primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!FFAppState().stopInProgress.hasStopId())
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                constraints: const BoxConstraints(
                                  maxHeight: 220.0,
                                ),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 160.0,
                                                    decoration: const BoxDecoration(),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Uma viagem disponível',
                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                    fontFamily: 'Poppins',
                                                                    fontSize: 18.0,
                                                                  ),
                                                            ),
                                                            Column(
                                                              mainAxisSize: MainAxisSize.max,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                                  child: Text(
                                                                    valueOrDefault<String>(
                                                                      functions.formatDateString(FFAppState().routeSelected.expectedArrivalDt),
                                                                      '-',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                          fontFamily: 'Poppins',
                                                                          color: FlutterFlowTheme.of(context).accent1,
                                                                          fontSize: 20.0,
                                                                        ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Previsão de chegada às ${functions.formatDateTimeString(FFAppState().routeSelected.expectedArrivalDt)}',
                                                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                        fontFamily: 'Poppins',
                                                                        color: FlutterFlowTheme.of(context).accent1,
                                                                        fontSize: 8.0,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        if (FFAppState().routeSelected.stops.where((e) => e.isComplete).toList().isEmpty)
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 0.0),
                                                            child: FFButtonWidget(
                                                              text: 'Iniciar viagem',
                                                              onPressed: () async {                 
                                                                _model.apiResult7s3 = await APIsPigmanGroup.acceptRouteCall.call(
                                                                  cpf: FFAppState().cpf,
                                                                  routeId: FFAppState().routeSelected.routeId,
                                                                );

                                                                if ((_model.apiResult7s3?.succeeded ?? true)) {
                                                                  FFAppState().update(() {
                                                                    FFAppState().stopInProgress = FFAppState().routeSelected.stops.first;
                                                                  }); 

                                                                  setState(() {
                                                                    FFAppState().addToPositions(PositionsStruct(
                                                                      cpf: FFAppState().cpf,
                                                                      routeId: FFAppState().routeSelected.routeId,
                                                                      latitude: FFAppState().latLngDriver?.latitude,
                                                                      longitude: FFAppState().latLngDriver?.longitude,
                                                                      date: DateTime.now().subtract(DateTime.now().timeZoneOffset).subtract(const Duration(hours: 3)),
                                                                      finish: false,
                                                                    ));
                                                                  });

                                                                  postRoute(false);
                                                                } 
                                                                
                                                                else {
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(
                                                                      content: const Text(
                                                                        'Não foi possível iniciar a viagem, verifique sua conexão com internet e tente novamente.',
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                      duration: const Duration(milliseconds: 4000),
                                                                      backgroundColor: FlutterFlowTheme.of(context).error,
                                                                    ),
                                                                  );
                                                                }
                                                                _model.menu = true;
                                                                setState(() {});
                                                              },
                                                              options: FFButtonOptions(
                                                                height: 48.0,
                                                                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                                iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                color: FlutterFlowTheme.of(context).primary,
                                                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                      fontFamily: 'Poppins',
                                                                      color: Colors.white,
                                                                    ),
                                                                elevation: 3.0,
                                                                borderSide: const BorderSide(
                                                                  color: Colors.transparent,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius: BorderRadius.circular(8.0),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 160.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).accent3,
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                      child: Text(
                                                        'Paradas',
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              fontFamily: 'Poppins',
                                                              color: FlutterFlowTheme.of(context).secondary,
                                                              fontSize: 14.0,
                                                            ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                                            child: Container(
                                                              width: 2.0,
                                                              height: double.infinity,
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context).accent1,
                                                              ),
                                                            ),
                                                          ),
                                                          Builder(
                                                            builder: (context) {
                                                              final stops = FFAppState().routeSelected.stops.toList();
                                                              return ListView.builder(
                                                                padding: EdgeInsets.zero,
                                                                shrinkWrap: true,
                                                                scrollDirection: Axis.vertical,
                                                                itemCount: stops.length,
                                                                itemBuilder: (context, stopsIndex) {
                                                                  final stopsItem = stops[stopsIndex];
                                                                  return Padding(
                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                                    child: Row(
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                                                                          child: Container(
                                                                            width: 20.0,
                                                                            height: 20.0,
                                                                            decoration: BoxDecoration(
                                                                              color: FlutterFlowTheme.of(context).accent1,
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                if (stopsItem.isComplete)
                                                                                  Icon(
                                                                                    Icons.check_circle_rounded,
                                                                                    color: FlutterFlowTheme.of(context).tertiary,
                                                                                    size: 20.0,
                                                                                  ),
                                                                                if (!stopsItem.isComplete)
                                                                                  Icon(
                                                                                    Icons.watch_later_sharp,
                                                                                    color: FlutterFlowTheme.of(context).accent3,
                                                                                    size: 20.0,
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          stopsItem.stopName,
                                                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (FFAppState().stopInProgress.hasStopId() && _model.menu)
                                    Align(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            setState(() {
                                              _model.menu = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 32.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (FFAppState().stopInProgress.hasStopId() && !_model.menu)
                                    Align(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            setState(() {
                                              _model.menu = true;
                                            });
                                          },
                                          child: Icon(
                                            Icons.keyboard_arrow_up_rounded,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 32.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Dados não sincronizados: ${FFAppState().positions.length.toString()}',
                                        style: FlutterFlowTheme.of(context).bodyMedium,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> postRoute(bool finish) async {
    if (FFAppState().positions.isNotEmpty ? !FFAppState().positions.last.finishViagem : true) {
      while (_model.index < FFAppState().positions.length) {

        connectivityResult = await Connectivity().checkConnectivity();

        if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {      
          if (FFAppState().positions.isNotEmpty) {
            _model.enviarLocalizacao1 = await APIsPigmanGroup.postPositionCall.call(
              cpf: FFAppState().cpf,
              routeId: FFAppState().positions.first.routeId,
              latitude: FFAppState().positions.first.latitude,
              longitude: FFAppState().positions.first.longitude,
              isFinished: FFAppState().positions.first.finish,
              infoDt: dateTimeFormat(
                'yyyy-MM-dd HH:mm:ss',
                FFAppState().positions.first.date,
                locale: FFLocalizations.of(context).languageCode,
              ),
            );
            
            if ((_model.enviarLocalizacao1?.succeeded ?? true)) {
              if (FFAppState().positions.isNotEmpty) {
                setState(() {
                  FFAppState().removeAtIndexFromPositions(0);
                });
              }
            } 
            
            else {
              setState(() {
                _model.index = _model.index + 1;
              });
            }
          }
        } else {
          break;
        }
      }
    }
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        _model.menu = true;
        _model.botaoRota = true;

        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
        }
        break;

      case MapBoxEvent.route_building:
        break;

      case MapBoxEvent.route_built:
        setState(() {
        });
        break;

      case MapBoxEvent.route_build_failed:
        setState(() {
        });
        break;

      case MapBoxEvent.navigation_running:
        setState(() {
        });
        break;

      case MapBoxEvent.on_arrival: //Chegou ao destino
        _model.botaoRota = true;
        _model.menu = true;

        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
        }
        break;

      case MapBoxEvent.navigation_finished:
        _model.botaoRota = true;
        _model.menu = true;

        setState(() {});
        break;

      case MapBoxEvent.navigation_cancelled: //Viagem cancelada
        _model.botaoRota = true;
        _model.menu = true;
        _controller?.clearRoute();
        _controller?.finishNavigation();
        break;

      default:
        break;
    }
    setState(() {});
  }

  void showConfirmConsentDialog(BuildContext bcontext)
  {
    showDialog(
      context: bcontext,
      barrierDismissible: false, // Prevents dialog from closing on tap outside
      builder: (bcontext) {
        return PopScope(
          canPop: false, 
          child: AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Para continuar utilizando este aplicativo, é necessário aceitar nossos',
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),

                        TextSpan(
                        text: ' Termos de Uso ',
                        style: const TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () { launchUrl(Uri(scheme: 'https', host: '1drv.ms', path: 'w/s!Ag-lHaRe-G-gguV-TkfoOYCqnIsSGw'));},
                        ),

                        const TextSpan(
                          text: 'e nossa',
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),

                        TextSpan(
                        text: ' Política de Privacidade',
                        style: const TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () { launchUrl(Uri(scheme: 'https', host: '1drv.ms', path: 'w/s!Ag-lHaRe-G-gguZJMYQcMsih2pBJ8A'));},
                        ),

                        const TextSpan(
                          text: '. \n\nConfirme que você leu e concorda com as condições acima.',
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ]
                    )
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FFButtonWidget(
                    onPressed: () {
                      setState(() {
                        FFAppState().acceptedTermsAndPrivacy = false;
                        FFAppState().viagemDisponivel = RouteStruct();
                        FFAppState().cpf = '';
                        FFAppState().routeSelected = RouteStruct();
                      });

                      Navigator.of(context).pop(); // Close the dialog
                      context.pushReplacementNamed('codigoAcesso'); // Close the dialog
                    },
                    text: 'Discordo',
                    options: FFButtonOptions(
                      width: 125.0,
                      height: 50.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).alternate,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                      elevation: 0.0,
                      borderSide: const BorderSide(
                        color: Color(0xFFBF3139),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      var termsAcceptance = await APIsPigmanGroup.setTermsAcceptanceCall.call(
                        cpf: FFAppState().cpf,
                        termsAccepted: true,
                      );

                      if(!termsAcceptance.succeeded)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar( 
                            content: const Text(
                              'Houve um erro durante esta requisição. Tente novamente.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          )
                        );

                        setState(() {
                          FFAppState().acceptedTermsAndPrivacy = false;
                          FFAppState().viagemDisponivel = RouteStruct();
                          FFAppState().cpf = '';
                          FFAppState().routeSelected = RouteStruct();
                        });

                        Navigator.of(context).pop(); // Close the dialog
                        context.pushReplacementNamed('codigoAcesso'); // Close the dialog
                      }

                      else {
                        setState(() {
                          FFAppState().acceptedTermsAndPrivacy = true;
                        });

                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                    text: 'Li e concordo',
                    options: FFButtonOptions(
                      width: 125.0,
                      height: 50.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).tertiary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                      elevation: 0.0,
                      borderSide: const BorderSide(
                        color:  Color(0xFF298032),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ]
              ),
            ],
          ),
        );
      },
    );
  }

  void showRemoveConsentDialog(BuildContext bcontext)
  {
    showDialog(
      context: bcontext,
      builder: (bcontext) {
        return AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.of(bcontext).pop();
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFF2D2D6B),
                  size: 28.0,
                ),
              ),]
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Ao remover a concordância com os',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),

                      TextSpan(
                      text: ' Termos de Uso ',
                      style: const TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () { launchUrl(Uri(scheme: 'https', host: '1drv.ms', path: 'w/s!Ag-lHaRe-G-gguV-TkfoOYCqnIsSGw'));},
                      ),

                      const TextSpan(
                        text: 'e com a',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),

                      TextSpan(
                      text: ' Política de Privacidade ',
                      style: const TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () { launchUrl(Uri(scheme: 'https', host: '1drv.ms', path: 'w/s!Ag-lHaRe-G-gguZJMYQcMsih2pBJ8A'));},
                      ),

                      const TextSpan(
                        text: 'você não poderá continuar utilizando este aplicativo. \n\nDeseja remover a concordância com as condições acima?',
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ]
                  )
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      var termsAcceptance = await APIsPigmanGroup.setTermsAcceptanceCall.call(
                        cpf: FFAppState().cpf,
                        termsAccepted: false,
                      );

                      if(!termsAcceptance.succeeded)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar( 
                            content: const Text(
                              'Houve um erro durante esta requisição. Tente novamente.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          )
                        );
                      }

                      else {
                        setState(() {
                          FFAppState().acceptedTermsAndPrivacy = false;
                          FFAppState().viagemDisponivel = RouteStruct();
                          FFAppState().cpf = '';
                          FFAppState().routeSelected = RouteStruct();
                        });

                        Navigator.of(context).pop(); // Close the dialog
                        context.pushReplacementNamed('codigoAcesso'); // Close the dialog
                      }
                    },
                    text: 'Remover concordância',
                    options: FFButtonOptions(
                      width: 250.0,
                      height: 50.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).alternate,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                      elevation: 0.0,
                      borderSide: const BorderSide(
                        color: Color(0xFFBF3139),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                )
              ]
            ),
          ],
        );
      },
    );
  }
}
