import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/sem_viagem_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  Local state fields for this page.

  bool semViagem = false;
  int index = 0;
  bool menu = true;
  bool botaoRota = true;
  RouteStruct? selectRoute;
  void updateSelectRouteStruct(Function(RouteStruct) updateFn) =>
      updateFn(selectRoute ??= RouteStruct());

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (Get Next Route)] action in home widget.
  late SemViagemModel semViagemModel;
  ApiCallResponse? enviarLocalizacao1;
  // Stores action output result for [Backend Call - API (Complete Route Stop)] action in Button widget.
  ApiCallResponse? encerrarRota1;
  // Stores action output result for [Backend Call - API (Post Position)] action in Button widget.
  ApiCallResponse? enviarLocalizacaoFinal;
  // Stores action output result for [Backend Call - API (Complete Route Stop)] action in Button widget.
  ApiCallResponse? encerrarRota;
  // Stores action output result for [Backend Call - API (Get Next Route)] action in Button widget.
  ApiCallResponse? pegarNovaRota;
  // Stores action output result for [Backend Call - API (Accept Route)] action in Button widget.
  ApiCallResponse? apiResult7s3;

  ApiCallResponse? apiResultha7;
  // Stores action output result for [Backend Call - API (Complete Route Stop)] action in rota widget.
  ApiCallResponse? apiResult92k;
  // Stores action output result for [Backend Call - API (Complete Route Stop)] action in Button widget.
  ApiCallResponse? apiResultg02;
  // Stores action output result for [Backend Call - API (GET Current Route)] action in Button widget.
  ApiCallResponse? getCurrentRoute;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    semViagemModel = createModel(context, () => SemViagemModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    semViagemModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
