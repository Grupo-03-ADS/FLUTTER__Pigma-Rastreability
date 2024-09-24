// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RouteStruct extends FFFirebaseStruct {
  RouteStruct({
    int? routeId,
    String? expectedArrivalDt,
    bool? isAccepted,
    List<StopStruct>? stops,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _routeId = routeId,
        _expectedArrivalDt = expectedArrivalDt,
        _isAccepted = isAccepted,
        _stops = stops,
        super(firestoreUtilData);

  // "routeId" field.
  int? _routeId;
  int get routeId => _routeId ?? 0;
  set routeId(int? val) => _routeId = val;
  void incrementRouteId(int amount) => _routeId = routeId + amount;
  bool hasRouteId() => _routeId != null;

  // "expectedArrivalDt" field.
  String? _expectedArrivalDt;
  String get expectedArrivalDt => _expectedArrivalDt ?? '';
  set expectedArrivalDt(String? val) => _expectedArrivalDt = val;
  bool hasExpectedArrivalDt() => _expectedArrivalDt != null;

  // "isAccepted" field.
  bool? _isAccepted;
  bool get isAccepted => _isAccepted ?? false;
  set isAccepted(bool? val) => _isAccepted = val;
  bool hasIsAccepted() => _isAccepted != null;

  // "stops" field.
  List<StopStruct>? _stops;
  List<StopStruct> get stops => _stops ?? const [];
  set stops(List<StopStruct>? val) => _stops = val;
  void updateStops(Function(List<StopStruct>) updateFn) =>
      updateFn(_stops ??= []);
  bool hasStops() => _stops != null;

  static RouteStruct fromMap(Map<String, dynamic> data) => RouteStruct(
        routeId: castToType<int>(data['routeId']),
        expectedArrivalDt: data['expectedArrivalDt'] as String?,
        isAccepted: data['isAccepted'] as bool?,
        stops: getStructList(
          data['stops'],
          StopStruct.fromMap,
        ),
      );

  static RouteStruct? maybeFromMap(dynamic data) =>
      data is Map ? RouteStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'routeId': _routeId,
        'expectedArrivalDt': _expectedArrivalDt,
        'isAccepted': _isAccepted,
        'stops': _stops?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'routeId': serializeParam(
          _routeId,
          ParamType.int,
        ),
        'expectedArrivalDt': serializeParam(
          _expectedArrivalDt,
          ParamType.String,
        ),
        'isAccepted': serializeParam(
          _isAccepted,
          ParamType.bool,
        ),
        'stops': serializeParam(
          _stops,
          ParamType.DataStruct,
          true,
        ),
      }.withoutNulls;

  static RouteStruct fromSerializableMap(Map<String, dynamic> data) =>
      RouteStruct(
        routeId: deserializeParam(
          data['routeId'],
          ParamType.int,
          false,
        ),
        expectedArrivalDt: deserializeParam(
          data['expectedArrivalDt'],
          ParamType.String,
          false,
        ),
        isAccepted: deserializeParam(
          data['isAccepted'],
          ParamType.bool,
          false,
        ),
        stops: deserializeStructParam<StopStruct>(
          data['stops'],
          ParamType.DataStruct,
          true,
          structBuilder: StopStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'RouteStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RouteStruct &&
        routeId == other.routeId &&
        expectedArrivalDt == other.expectedArrivalDt &&
        isAccepted == other.isAccepted &&
        listEquality.equals(stops, other.stops);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([routeId, expectedArrivalDt, isAccepted, stops]);
}

RouteStruct createRouteStruct({
  int? routeId,
  String? expectedArrivalDt,
  bool? isAccepted,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RouteStruct(
      routeId: routeId,
      expectedArrivalDt: expectedArrivalDt,
      isAccepted: isAccepted,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RouteStruct? updateRouteStruct(
  RouteStruct? route, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    route
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRouteStructData(
  Map<String, dynamic> firestoreData,
  RouteStruct? route,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (route == null) {
    return;
  }
  if (route.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && route.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final routeData = getRouteFirestoreData(route, forFieldValue);
  final nestedData = routeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = route.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRouteFirestoreData(
  RouteStruct? route, [
  bool forFieldValue = false,
]) {
  if (route == null) {
    return {};
  }
  final firestoreData = mapToFirestore(route.toMap());

  // Add any Firestore field values
  route.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRouteListFirestoreData(
  List<RouteStruct>? routes,
) =>
    routes?.map((e) => getRouteFirestoreData(e, true)).toList() ?? [];
