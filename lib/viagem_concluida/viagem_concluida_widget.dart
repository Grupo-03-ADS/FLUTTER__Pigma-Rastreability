import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pigma/backend/api_requests/api_calls.dart';
import 'package:pigma/backend/backend.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'viagem_concluida_model.dart';
export 'viagem_concluida_model.dart';

class ViagemConcluidaWidget extends StatefulWidget {
  const ViagemConcluidaWidget({super.key});

  @override
  State<ViagemConcluidaWidget> createState() => _ViagemConcluidaWidgetState();
}

class _ViagemConcluidaWidgetState extends State<ViagemConcluidaWidget> {
  late ViagemConcluidaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViagemConcluidaModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'VIAGEM CONCLUÍDA ',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Mais uma viagem concluída com sucesso, mas antes de iniciar uma nova viagem',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            const TextSpan(
                              text: ' conecte-se com internet ',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'e sincronize os dados da sua última viagem.',
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                              ),
                            )
                          ],
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/Design_sem_nome-32.png',
                    height: 400.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 30.0),
              child: Text(
                'Dados não sincronizados: ${FFAppState().positions.length.toString()}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
              child: FFButtonWidget(
                onPressed: () async {
                  
                  bool finish = false;

                  while (_model.index < FFAppState().positions.length) {
                    var connectivityResult = await Connectivity().checkConnectivity();

                    if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {
                      _model.enviarLocalizacaoFinal1 = await APIsPigmanGroup.postPositionCall.call(
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

                      if(_model.enviarLocalizacaoFinal1?.statusCode == 404) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Viagem removida ou finalizada manualmente. Dados serão desconsiderados',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );

                        setState(() {
                          FFAppState().positions = FFAppState().positions.where((p) => p.routeId != FFAppState().positions.first.routeId).toList();
                        });

                        if(FFAppState().positions.isEmpty)
                        {
                          finish = true;

                          setState(() {
                            FFAppState().positions = [];
                            FFAppState().stopInProgress = StopStruct();
                            FFAppState().routeSelected = RouteStruct();
                          });

                          _model.pegarNovaRota1 = await APIsPigmanGroup.getNextRouteCall.call(
                            cpf: FFAppState().cpf,
                          );

                          if ((_model.pegarNovaRota1?.succeeded ?? true)) {
                            setState(() {
                              FFAppState().routeSelected = APIsPigmanGroup.getNextRouteCall.rota(
                                (_model.pegarNovaRota1?.jsonBody ?? ''),)!;
                            });
                          }
                        }
                      }
                      
                      else if ((_model.enviarLocalizacaoFinal1?.succeeded ?? true)) {
                        if ((_model.enviarLocalizacaoFinal1?.jsonBody ?? '')) {
                          finish = true;

                          setState(() {
                            FFAppState().positions = [];
                            FFAppState().stopInProgress = StopStruct();
                            FFAppState().routeSelected = RouteStruct();
                          });

                          _model.pegarNovaRota1 =
                              await APIsPigmanGroup.getNextRouteCall.call(
                            cpf: FFAppState().cpf,
                          );
                          
                          if ((_model.pegarNovaRota1?.succeeded ?? true)) {
                            setState(() {
                              FFAppState().routeSelected =
                                  APIsPigmanGroup.getNextRouteCall.rota(
                                (_model.pegarNovaRota1?.jsonBody ?? ''),
                              )!;
                            });
                          }
                        }
                        
                        else {
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
                     
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Conecte-se a internet para concluir a sincronização',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          duration: const Duration(milliseconds: 4000),
                          backgroundColor: FlutterFlowTheme.of(context).error,
                        ),
                      );
                      break;
                    }
                  }

                  if(FFAppState().positions.isEmpty){
                    finish = true;
                  }

                  setState(() {});

                  if(finish) {
                    setState(() {
                      FFAppState().viagemFinalizada = false;
                    });
                    
                    context.pushReplacementNamed(
                      'home',
                      extra: <String, dynamic>{
                        kTransitionInfoKey: const TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                        ),
                      },
                    );
                  }
                },
                text: FFAppState().positions.isEmpty ? 'Voltar para Home' : 'Sincronizar dados',
                icon: const Icon(
                  Icons.upload,
                  size: 16.0,
                ),
                options: FFButtonOptions(
                  height: 48.0,
                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).tertiary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
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
    );
  }
}
