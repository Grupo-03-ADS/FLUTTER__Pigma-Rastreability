// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PositionsStruct extends FFFirebaseStruct {
  PositionsStruct({
    String? cpf,
    int? routeId,
    double? latitude,
    double? longitude,
    DateTime? date,
    bool? finish,
    bool? finishViagem,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _cpf = cpf,
        _routeId = routeId,
        _latitude = latitude,
        _longitude = longitude,
        _date = date,
        _finish = finish,
        _finishViagem = finishViagem,
        super(firestoreUtilData);

  // "cpf" field.
  String? _cpf;
  String get cpf => _cpf ?? '';
  set cpf(String? val) => _cpf = val;
  bool hasCpf() => _cpf != null;

  // "routeId" field.
  int? _routeId;
  int get routeId => _routeId ?? 0;
  set routeId(int? val) => _routeId = val;
  void incrementRouteId(int amount) => _routeId = routeId + amount;
  bool hasRouteId() => _routeId != null;

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

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? val) => _date = val;
  bool hasDate() => _date != null;

  // "finish" field.
  bool? _finish;
  bool get finish => _finish ?? false;
  set finish(bool? val) => _finish = val;
  bool hasFinish() => _finish != null;

  // "finishViagem" field.
  bool? _finishViagem;
  bool get finishViagem => _finishViagem ?? false;
  set finishViagem(bool? val) => _finishViagem = val;
  bool hasFinishViagem() => _finishViagem != null;

  static PositionsStruct fromMap(Map<String, dynamic> data) => PositionsStruct(
        cpf: data['cpf'] as String?,
        routeId: castToType<int>(data['routeId']),
        latitude: castToType<double>(data['latitude']),
        longitude: castToType<double>(data['longitude']),
        date: data['date'] as DateTime?,
        finish: data['finish'] as bool?,
        finishViagem: data['finishViagem'] as bool?,
      );

  static PositionsStruct? maybeFromMap(dynamic data) => data is Map
      ? PositionsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'cpf': _cpf,
        'routeId': _routeId,
        'latitude': _latitude,
        'longitude': _longitude,
        'date': _date,
        'finish': _finish,
        'finishViagem': _finishViagem,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'cpf': serializeParam(
          _cpf,
          ParamType.String,
        ),
        'routeId': serializeParam(
          _routeId,
          ParamType.int,
        ),
        'latitude': serializeParam(
          _latitude,
          ParamType.double,
        ),
        'longitude': serializeParam(
          _longitude,
          ParamType.double,
        ),
        'date': serializeParam(
          _date,
          ParamType.DateTime,
        ),
        'finish': serializeParam(
          _finish,
          ParamType.bool,
        ),
        'finishViagem': serializeParam(
          _finishViagem,
          ParamType.bool,
        ),
      }.withoutNulls;

  static PositionsStruct fromSerializableMap(Map<String, dynamic> data) =>
      PositionsStruct(
        cpf: deserializeParam(
          data['cpf'],
          ParamType.String,
          false,
        ),
        routeId: deserializeParam(
          data['routeId'],
          ParamType.int,
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
        date: deserializeParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
        finish: deserializeParam(
          data['finish'],
          ParamType.bool,
          false,
        ),
        finishViagem: deserializeParam(
          data['finishViagem'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'PositionsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PositionsStruct &&
        cpf == other.cpf &&
        routeId == other.routeId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        date == other.date &&
        finish == other.finish &&
        finishViagem == other.finishViagem;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([cpf, routeId, latitude, longitude, date, finish, finishViagem]);
}

PositionsStruct createPositionsStruct({
  String? cpf,
  int? routeId,
  double? latitude,
  double? longitude,
  DateTime? date,
  bool? finish,
  bool? finishViagem,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PositionsStruct(
      cpf: cpf,
      routeId: routeId,
      latitude: latitude,
      longitude: longitude,
      date: date,
      finish: finish,
      finishViagem: finishViagem,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PositionsStruct? updatePositionsStruct(
  PositionsStruct? positions, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    positions
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPositionsStructData(
  Map<String, dynamic> firestoreData,
  PositionsStruct? positions,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (positions == null) {
    return;
  }
  if (positions.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && positions.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final positionsData = getPositionsFirestoreData(positions, forFieldValue);
  final nestedData = positionsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = positions.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPositionsFirestoreData(
  PositionsStruct? positions, [
  bool forFieldValue = false,
]) {
  if (positions == null) {
    return {};
  }
  final firestoreData = mapToFirestore(positions.toMap());

  // Add any Firestore field values
  positions.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPositionsListFirestoreData(
  List<PositionsStruct>? positionss,
) =>
    positionss?.map((e) => getPositionsFirestoreData(e, true)).toList() ?? [];
