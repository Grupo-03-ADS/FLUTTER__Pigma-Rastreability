import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'codigo_acesso_widget.dart' show CodigoAcessoWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CodigoAcessoModel extends FlutterFlowModel<CodigoAcessoWidget> {
  ///  State fields for stateful widgets in this page.
  /// 
  // State field(s) for TextField widget.
   final formKey = GlobalKey<FormState>();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
   final textFieldMask = MaskTextInputFormatter(mask: '###.###.###-##');
  String? Function(BuildContext, String?)? textControllerValidator;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo obrigatório';
    }

    if (val.length < 14) {
      return 'CPF é inválido';
    }
    if (val.length > 14) {
      return 'CPF é inválido';
    }

    return null;
  }
  // Stores action output result for [Backend Call - API (Check CPF)] action in Button widget.
  ApiCallResponse? checkCPF10;
  // Stores action output result for [Backend Call - API (GET Current Route)] action in Button widget.
  ApiCallResponse? getCurrentRoute;
  // Stores action output result for [Backend Call - API (Get Next Route)] action in Button widget.
  ApiCallResponse? getNextRoute;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    textControllerValidator = _textControllerValidator;
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
