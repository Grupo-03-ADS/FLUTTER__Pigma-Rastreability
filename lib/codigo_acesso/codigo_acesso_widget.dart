import 'package:location/location.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'codigo_acesso_model.dart';
export 'codigo_acesso_model.dart';

class CodigoAcessoWidget extends StatefulWidget {
  const CodigoAcessoWidget({super.key});

  @override
  State<CodigoAcessoWidget> createState() => _CodigoAcessoWidgetState();
}

class _CodigoAcessoWidgetState extends State<CodigoAcessoWidget> {
  late SnackBar locationIssuesSnackBar;

  late CodigoAcessoModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;
  bool hasLocationIssues = false;
  bool localFromRefresh = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CodigoAcessoModel());

    localFromRefresh = FFAppState().fromRefresh;

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

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    () async {
      await _getLocation().whenComplete( () => currentUserLocationValue = FFAppState().latLngDriver );
      setState(() {});
    } ();

    () async {
      if(FFAppState().fromRefresh || (FFAppState().keepLoggedIn && FFAppState().cpf != '' && FFAppState().cpf != '00000000000') ) {
        // FFAppState().update(() {
        //   FFAppState().routeSelected = RouteStruct();
        //   FFAppState().stopInProgress = StopStruct();
        // });

        setState(() {
          FFAppState().routeSelected = RouteStruct();
          FFAppState().stopInProgress = StopStruct();
          FFAppState().fromRefresh = false;
        });

        if (FFAppState().viagemFinalizada && FFAppState().positions.isNotEmpty) {
          context.pushReplacementNamed('viagemConcluida');
        }
        
        else {
          FFAppState().viagemFinalizada = false;

          _model.getCurrentRoute = await APIsPigmanGroup.gETCurrentRouteCall.call(
            cpf: FFAppState().cpf,
          );

          if ((_model.getCurrentRoute?.succeeded ?? true)) {
            setState(() {
              FFAppState().routeSelected = APIsPigmanGroup.gETCurrentRouteCall.route(
                (_model.getCurrentRoute?.jsonBody ?? ''),
              )!;
            });
            
            if (FFAppState().routeSelected.stops
                .where((e) => !e.isComplete).toList().isNotEmpty) {

              setState(() {
                FFAppState().stopInProgress = FFAppState()
                    .routeSelected
                    .stops
                    .where((e) => !e.isComplete)
                    .toList()
                    .first;
              });
            }
            
            else {
              setState(() {
                FFAppState().stopInProgress = FFAppState().routeSelected.stops.last;
              });
            }

            context.pushReplacementNamed('home');
          } 
          
          else {
            _model.getNextRoute = await APIsPigmanGroup.getNextRouteCall.call(
              cpf: FFAppState().cpf,
            );

            if ((_model.getNextRoute?.succeeded ?? true)) {
              setState(() {
                FFAppState().routeSelected = APIsPigmanGroup.getNextRouteCall.rota(
                  (_model.getNextRoute?.jsonBody ?? ''),
                )!;
              });

              setState(() {
                FFAppState().latLngDriver = currentUserLocationValue;
              });
            }
            
            context.pushReplacementNamed('home');
          }
        } 
      
        setState(() {});
      }
    } ();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _getLocation() async {
    final location = Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();

      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        
        if (!serviceEnabled) {
          hasLocationIssues = true;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();

      if (permissionGranted == PermissionStatus.denied) {   
        permissionGranted = await location.requestPermission();

        if (permissionGranted != PermissionStatus.granted) {
          hasLocationIssues = true;
        }
      }

      if(!hasLocationIssues)
      {
        var currentLocation = await location.getLocation();
    
        setState(() {
          FFAppState().latLngDriver = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    } 
    
    catch (e) {
      print("Erro ao obter a localização: $e");
      hasLocationIssues = true;
    }

    if(hasLocationIssues) {
      ScaffoldMessenger.of(context).showSnackBar(locationIssuesSnackBar);
      hasLocationIssues = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    
    if(localFromRefresh || (FFAppState().keepLoggedIn && FFAppState().cpf != '' && FFAppState().cpf != '00000000000') ) {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF2D2D6B),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ), // Optional loading indicator
        ),
      );
    }

    // else {
      return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFF2D2D6B),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Container(
                  width: 320.0,
                  height: 320.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/image_4.png',
                            width: 132.0,
                            height: 82.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: const AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding:
                            const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'CPF',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _model.formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0, 8.0, 20.0, 0.0),
                          child: TextFormField(
                            controller: _model.textController,
                            keyboardType: TextInputType.number,
                            focusNode: _model.textFieldFocusNode,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              hintStyle: FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0x00000000),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).error,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFECECEC),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: _model.textControllerValidator
                                .asValidator(context),
                            inputFormatters: [_model.textFieldMask],
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      CheckboxListTile(
                        title: const Text("Mantenha-me conectado!"),
                        value: FFAppState().keepLoggedIn,
                        onChanged: (newValue) {
                          setState(() {
                            FFAppState().keepLoggedIn = newValue ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      ),
                      const Spacer(flex: 2),
                      FFButtonWidget(
                        onPressed: () async {
                          await _getLocation().whenComplete( () => currentUserLocationValue = FFAppState().latLngDriver );

                          if (_model.formKey.currentState == null || !_model.formKey.currentState!.validate()) {
                            return;
                          }

                          FFAppState().update(() {
                            FFAppState().routeSelected = RouteStruct();
                            FFAppState().stopInProgress = StopStruct();
                          });

                          _model.checkCPF10 = await APIsPigmanGroup.checkCPFCall.call(
                            cpf: _model.textController.text,
                          );

                          var cpf = _model.checkCPF10?.jsonBody['cpf'] ?? '00000000000';
                          var termsAccepted = _model.checkCPF10?.jsonBody['termsAccepted'] ?? false;
    
                          if (cpf != '00000000000') {
                            setState(() {
                              FFAppState().cpf = _model.textController.text;
                              FFAppState().acceptedTermsAndPrivacy = termsAccepted;
                            });

                            if (FFAppState().viagemFinalizada) {
                              context.pushReplacementNamed('viagemConcluida');
                            } 
                            
                            else {
                              _model.getCurrentRoute = await APIsPigmanGroup.gETCurrentRouteCall.call(
                                cpf: FFAppState().cpf,
                              );

                              if ((_model.getCurrentRoute?.succeeded ?? true)) {
                                setState(() {
                                  FFAppState().routeSelected = APIsPigmanGroup.gETCurrentRouteCall.route(
                                    (_model.getCurrentRoute?.jsonBody ?? ''),
                                  )!;
                                });
                                
                                if (FFAppState().routeSelected.stops
                                    .where((e) => !e.isComplete).toList().isNotEmpty) {

                                  setState(() {
                                    FFAppState().stopInProgress = FFAppState()
                                        .routeSelected
                                        .stops
                                        .where((e) => !e.isComplete)
                                        .toList()
                                        .first;
                                  });

                                  // setState(() {
                                  //   FFAppState().latLngDriver = currentUserLocationValue;
                                  // });
                                }
                                
                                else {
                                  setState(() {
                                    FFAppState().stopInProgress = FFAppState().routeSelected.stops.last;
                                  });
                                }
                                
                                context.pushReplacementNamed('home');
                              } 
                              
                              else {
                                _model.getNextRoute = await APIsPigmanGroup.getNextRouteCall.call(
                                  cpf: FFAppState().cpf,
                                );

                                if ((_model.getNextRoute?.succeeded ?? true)) {
                                  setState(() {
                                    FFAppState().routeSelected =
                                        APIsPigmanGroup.getNextRouteCall.rota(
                                      (_model.getNextRoute?.jsonBody ?? ''),
                                    )!;
                                  });

                                  setState(() {
                                    FFAppState().latLngDriver = currentUserLocationValue;
                                  });
                                }
                                
                                context.pushReplacementNamed('home');
                              }
                            }
                          } 
                          
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Erro de autenticação, seu cpf não está cadastrado na nossa base de dados.',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                duration: const Duration(milliseconds: 4000),
                                backgroundColor: FlutterFlowTheme.of(context).error,
                              ),
                            );
                          }
                          setState(() {});
                        },
                        text: 'Entrar',
                        options: FFButtonOptions(
                          width: 280.0,
                          height: 48.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: const Color(0xFF2D2D6B),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
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
                      const Text(
                        "v2.0.1", // Version Code
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    // }
  }
}
