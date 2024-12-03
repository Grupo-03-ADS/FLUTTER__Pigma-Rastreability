import '../schema/structs/index.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';
import 'package:pigma/api_key.dart';

export 'api_manager.dart' show ApiCallResponse;

// const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start APIs Pigman Group Code

class APIsPigmanGroup {
  static String baseUrl =
      'https://lakre.pigmadesenvolvimentos.com.br:10529/apis';
  static Map<String, String> headers = {
    'User-Agent': packageName,
    'Authorization': apiKey,
  };
  static CheckCPFCall checkCPFCall = CheckCPFCall();
  static GetOpemRoutesCall getOpemRoutesCall = GetOpemRoutesCall();
  static AcceptRouteCall acceptRouteCall = AcceptRouteCall();
  static CompleteRouteStopCall completeRouteStopCall = CompleteRouteStopCall();
  static PostPositionCall postPositionCall = PostPositionCall();
  static GETCurrentRouteCall gETCurrentRouteCall = GETCurrentRouteCall();
  static GetNextRouteCall getNextRouteCall = GetNextRouteCall();
  static SetTermsAcceptanceCall setTermsAcceptanceCall =
      SetTermsAcceptanceCall();
}

class CheckCPFCall {
  Future<ApiCallResponse> call({
    String? cpf = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Check CPF',
      apiUrl: '${APIsPigmanGroup.baseUrl}/CheckCpf?cpf=$cpf',
      callType: ApiCallType.GET,
      params: {},
      headers: APIsPigmanGroup.headers,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  dynamic cpf(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class SetTermsAcceptanceCall {
  Future<ApiCallResponse> call({
    String? cpf = '',
    bool termsAccepted = false,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Set Terms Acceptance',
      apiUrl: '${APIsPigmanGroup.baseUrl}/SetTermsAcceptance',
      callType: ApiCallType.POST,
      params: {
        'cpf': cpf,
        'termsAccepted': termsAccepted,
      },
      headers: APIsPigmanGroup.headers,
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  dynamic cpf(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class GetOpemRoutesCall {
  Future<ApiCallResponse> call({
    String? cpf = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Get opem routes',
      apiUrl: '${APIsPigmanGroup.baseUrl}/GetOpenRoutes',
      callType: ApiCallType.GET,
      params: {
        'cpf': cpf,
      },
      headers: APIsPigmanGroup.headers,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  String? data(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[0].expectedArrivalDt''',
      ));
  List? listaParadas(dynamic response) => getJsonField(
        response,
        r'''$[0].stops''',
        true,
      ) as List?;
  List<double>? listaParadasLat(dynamic response) => (getJsonField(
        response,
        r'''$[0].stops[:].latitude''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<double>(x))
          .withoutNulls
          .toList();
  List<double>? listaParadasLong(dynamic response) => (getJsonField(
        response,
        r'''$[0].stops[:].longitude''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<double>(x))
          .withoutNulls
          .toList();
}

class AcceptRouteCall {
  Future<ApiCallResponse> call({
    String? cpf = '',
    int? routeId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Accept Route',
      apiUrl: '${APIsPigmanGroup.baseUrl}/AcceptRoute',
      callType: ApiCallType.POST,
      params: {
        'cpf': cpf,
        'routeId': routeId,
      },
      headers: APIsPigmanGroup.headers,
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class CompleteRouteStopCall {
  Future<ApiCallResponse> call({
    String? cpf = '',
    int? stopId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Complete Route Stop',
      apiUrl: '${APIsPigmanGroup.baseUrl}/CompleteRouteStop',
      callType: ApiCallType.POST,
      params: {
        'cpf': cpf,
        'stopId': stopId,
      },
      headers: APIsPigmanGroup.headers,
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  dynamic resposta(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class PostPositionCall {
  Future<ApiCallResponse> call({
    String? cpf = '',
    int? routeId,
    double? latitude,
    double? longitude,
    bool? isFinished,
    String? infoDt = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Post Position',
      apiUrl: '${APIsPigmanGroup.baseUrl}/PostPosition',
      callType: ApiCallType.POST,
      params: {
        'cpf': cpf,
        'routeId': routeId,
        'latitude': latitude,
        'longitude': longitude,
        'infoDt': infoDt,
        'isFinished': isFinished,
      },
      headers: APIsPigmanGroup.headers,
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GETCurrentRouteCall {
  Future<ApiCallResponse> call({
    String? cpf = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'GET Current Route',
      apiUrl: '${APIsPigmanGroup.baseUrl}/GetCurrentRoute',
      callType: ApiCallType.GET,
      params: {
        'cpf': cpf,
      },
      headers: APIsPigmanGroup.headers,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  RouteStruct? route(dynamic response) => RouteStruct.maybeFromMap(getJsonField(
        response,
        r'''$''',
      ));
}

class GetNextRouteCall {
  Future<ApiCallResponse> call({
    String? cpf = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Get Next Route',
      apiUrl: '${APIsPigmanGroup.baseUrl}/GetNextRoute',
      callType: ApiCallType.GET,
      params: {
        'cpf': cpf,
      },
      headers: APIsPigmanGroup.headers,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  RouteStruct? rota(dynamic response) => RouteStruct.maybeFromMap(getJsonField(
        response,
        r'''$''',
      ));
}

/// End APIs Pigman Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

// String _serializeList(List? list) {
//   list ??= <String>[];
//   try {
//     return json.encode(list);
//   } catch (_) {
//     return '[]';
//   }
// }

// String _serializeJson(dynamic jsonVar, [bool isList = false]) {
//   jsonVar ??= (isList ? [] : {});
//   try {
//     return json.encode(jsonVar);
//   } catch (_) {
//     return isList ? '[]' : '{}';
//   }
// }
