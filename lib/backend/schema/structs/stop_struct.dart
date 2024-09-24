// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StopStruct extends FFFirebaseStruct {
  StopStruct({
    int? stopId,
    int? stopOrder,
    String? stopName,
    String? stopType,
    double? latitude,
    double? longitude,
    bool? isComplete,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _stopId = stopId,
        _stopOrder = stopOrder,
        _stopName = stopName,
        _stopType = stopType,
        _latitude = latitude,
        _longitude = longitude,
        _isComplete = isComplete,
        super(firestoreUtilData);

  // "stopId" field.
  int? _stopId;
  int get stopId => _stopId ?? 0;
  set stopId(int? val) => _stopId = val;
  void incrementStopId(int amount) => _stopId = stopId + amount;
  bool hasStopId() => _stopId != null;

  // "stopOrder" field.
  int? _stopOrder;
  int get stopOrder => _stopOrder ?? 0;
  set stopOrder(int? val) => _stopOrder = val;
  void incrementStopOrder(int amount) => _stopOrder = stopOrder + amount;
  bool hasStopOrder() => _stopOrder != null;

  // "stopName" field.
  String? _stopName;
  String get stopName => _stopName ?? '';
  set stopName(String? val) => _stopName = val;
  bool hasStopName() => _stopName != null;

  // "stopType" field.
  String? _stopType;
  String get stopType => _stopType ?? '';
  set stopType(String? val) => _stopType = val;
  bool hasStopType() => _stopType != null;

  // "latitude" field.
  double? _latitude;
  double get latitude => _latitude ?? 0.0;
  set latitude(double? val) => _latitude = val;
  void incrementLatitude(double amount) => _latitude = latitude + amount;
  bool hasLatitude() => _latitude != null;

  // "longitude" field.
  double? _longitude;
  double get longitude => _longitude ?? 0.0;
  set longitude(double? val) => _longitude = val;
  void incrementLongitude(double amount) => _longitude = longitude + amount;
  bool hasLongitude() => _longitude != null;

  // "isComplete" field.
  bool? _isComplete;
  bool get isComplete => _isComplete ?? false;
  set isComplete(bool? val) => _isComplete = val;
  bool hasIsComplete() => _isComplete != null;

  static StopStruct fromMap(Map<String, dynamic> data) => StopStruct(
        stopId: castToType<int>(data['stopId']),
        stopOrder: castToType<int>(data['stopOrder']),
        stopName: data['stopName'] as String?,
        stopType: data['stopType'] as String?,
        latitude: castToType<double>(data['latitude']),
        longitude: castToType<double>(data['longitude']),
        isComplete: data['isComplete'] as bool?,
      );

  static StopStruct? maybeFromMap(dynamic data) =>
      data is Map ? StopStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'stopId': _stopId,
        'stopOrder': _stopOrder,
        'stopName': _stopName,
        'stopType': _stopType,
        'latitude': _latitude,
        'longitude': _longitude,
        'isComplete': _isComplete,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'stopId': serializeParam(
          _stopId,
          ParamType.int,
        ),
        'stopOrder': serializeParam(
          _stopOrder,
          ParamType.int,
        ),
        'stopName': serializeParam(
          _stopName,
          ParamType.String,
        ),
        'stopType': serializeParam(
          _stopType,
          ParamType.String,
        ),
        'latitude': serializeParam(
          _latitude,
          ParamType.double,
        ),
        'longitude': serializeParam(
          _longitude,
          ParamType.double,
        ),
        'isComplete': serializeParam(
          _isComplete,
          ParamType.bool,
        ),
      }.withoutNulls;

  static StopStruct fromSerializableMap(Map<String, dynamic> data) =>
      StopStruct(
        stopId: deserializeParam(
          data['stopId'],
          ParamType.int,
          false,
        ),
        stopOrder: deserializeParam(
          data['stopOrder'],
          ParamType.int,
          false,
        ),
        stopName: deserializeParam(
          data['stopName'],
          ParamType.String,
          false,
        ),
        stopType: deserializeParam(
          data['stopType'],
          ParamType.String,
          false,
        ),
        latitude: deserializeParam(
          data['latitude'],
          ParamType.double,
          false,
        ),
        longitude: deserializeParam(
          data['longitude'],
          ParamType.double,
          false,
        ),
        isComplete: deserializeParam(
          data['isComplete'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'StopStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StopStruct &&
        stopId == other.stopId &&
        stopOrder == other.stopOrder &&
        stopName == other.stopName &&
        stopType == other.stopType &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        isComplete == other.isComplete;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [stopId, stopOrder, stopName, stopType, latitude, longitude, isComplete]);
}

StopStruct createStopStruct({
  int? stopId,
  int? stopOrder,
  String? stopName,
  String? stopType,
  double? latitude,
  double? longitude,
  bool? isComplete,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    StopStruct(
      stopId: stopId,
      stopOrder: stopOrder,
      stopName: stopName,
      stopType: stopType,
      latitude: latitude,
      longitude: longitude,
      isComplete: isComplete,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

StopStruct? updateStopStruct(
  StopStruct? stop, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    stop
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addStopStructData(
  Map<String, dynamic> firestoreData,
  StopStruct? stop,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (stop == null) {
    return;
  }
  if (stop.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && stop.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final stopData = getStopFirestoreData(stop, forFieldValue);
  final nestedData = stopData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = stop.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getStopFirestoreData(
  StopStruct? stop, [
  bool forFieldValue = false,
]) {
  if (stop == null) {
    return {};
  }
  final firestoreData = mapToFirestore(stop.toMap());

  // Add any Firestore field values
  stop.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getStopListFirestoreData(
  List<StopStruct>? stops,
) =>
    stops?.map((e) => getStopFirestoreData(e, true)).toList() ?? [];
