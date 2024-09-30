import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sem_viagem_model.dart';
export 'sem_viagem_model.dart';

class SemViagemWidget extends StatefulWidget {
  const SemViagemWidget({super.key});

  @override
  State<SemViagemWidget> createState() => _SemViagemWidgetState();
}

class _SemViagemWidgetState extends State<SemViagemWidget> {
  late SemViagemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SemViagemModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      color: const Color(0xFF28456F),
      child: Align(
        alignment: const AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
          child: Container(
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 45.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAECC55), // Cor de fundo
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    'VIAGEM CONCLUÍDA \nCOM SUCESSO!',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inria Sans',
                          color: const Color(0xFF28456F), // Cor do texto
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/Design_sem_nome-21_1.png',
                    // width: 360.0,
                    // height: 300.0,
                    width: 240.0,
                    height: 166.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 25.0),
                Text(
                  'Sem viagens disponíveis. Solicite ao seu gestor uma nova viagem ou atualize a página para verificar se há novas viagens.',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inria Sans',
                        color: const Color(0xFFFFFFFF),
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
