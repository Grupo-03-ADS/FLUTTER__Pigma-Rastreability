import 'package:flutter/material.dart';
import 'package:pigma/backend/schema/structs/positions_struct.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';


class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      if (prefs.containsKey('ff_RouteSelected')) {
        try {
          final serializedData = prefs.getString('ff_RouteSelected') ?? '{}';
          _routeSelected =
              RouteStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_viagemDisponivel')) {
        try {
          final serializedData = prefs.getString('ff_viagemDisponivel') ?? '{}';
          _viagemDisponivel =
              RouteStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_stopInProgress')) {
        try {
          final serializedData = prefs.getString('ff_stopInProgress') ?? '{}';
          _stopInProgress =
              StopStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _positionAtual = latLngFromString(prefs.getString('ff_positionAtual')) ??
          _positionAtual;
    });
    _safeInit(() {
      _cpf = prefs.getString('ff_CPF') ?? _cpf;
    });
    _safeInit(() {
      _acceptedTermsAndPrivacy = prefs.getBool('ff__acceptedTermsAndPrivacy') ?? _acceptedTermsAndPrivacy;
    });
    _safeInit(() {
      _keepLoggedIn = prefs.getBool('ff__keepLoggedIn') ?? _keepLoggedIn;
    });
    _safeInit(() {
      _fromRefresh = prefs.getBool('ff__fromRefresh') ?? _fromRefresh;
    });
    _safeInit(() {
      _latLngDriver =
          latLngFromString(prefs.getString('ff_LatLngDriver')) ?? _latLngDriver;
    });
    _safeInit(() {
      _positions = prefs
              .getStringList('ff_positions')
              ?.map((x) {
                try {
                  return PositionsStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _positions;
    });
    _safeInit(() {
      _viagemFinalizada =
          prefs.getBool('ff_viagemFinalizada') ?? _viagemFinalizada;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _routeDistance = '';
  String get routeDistance => _routeDistance;
  set routeDistance(String value) {
    _routeDistance = value;
  }

  String _routeDuration = '';
  String get routeDuration => _routeDuration;
  set routeDuration(String value) {
    _routeDuration = value;
  }

  LatLng? _inicio = const LatLng(-24.7227436, -53.7408209);
  LatLng? get inicio => _inicio;
  set inicio(LatLng? value) {
    _inicio = value;
  }

  LatLng? _fim = const LatLng(-23.5557714, -46.6395571);
  LatLng? get fim => _fim;
  set fim(LatLng? value) {
    _fim = value;
  }

  RouteStruct _routeSelected = RouteStruct();
  RouteStruct get routeSelected => _routeSelected;
  set routeSelected(RouteStruct value) {
    _routeSelected = value;
    prefs.setString('ff_RouteSelected', value.serialize());
  }

  void updateRouteSelectedStruct(Function(RouteStruct) updateFn) {
    updateFn(_routeSelected);
    prefs.setString('ff_RouteSelected', _routeSelected.serialize());
  }

  RouteStruct _viagemDisponivel = RouteStruct();
  RouteStruct get viagemDisponivel => _viagemDisponivel;
  set viagemDisponivel(RouteStruct value) {
    _viagemDisponivel = value;
    prefs.setString('ff_viagemDisponivel', value.serialize());
  }

  void updateViagemDisponivelStruct(Function(RouteStruct) updateFn) {
    updateFn(_viagemDisponivel);
    prefs.setString('ff_viagemDisponivel', _viagemDisponivel.serialize());
  }

  StopStruct _stopInProgress = StopStruct();
  StopStruct get stopInProgress => _stopInProgress;
  set stopInProgress(StopStruct value) {
    _stopInProgress = value;
    prefs.setString('ff_stopInProgress', value.serialize());
  }

  void updateStopInProgressStruct(Function(StopStruct) updateFn) {
    updateFn(_stopInProgress);
    prefs.setString('ff_stopInProgress', _stopInProgress.serialize());
  }

  LatLng? _positionAtual;
  LatLng? get positionAtual => _positionAtual;
  set positionAtual(LatLng? value) {
    _positionAtual = value;
    value != null
        ? prefs.setString('ff_positionAtual', value.serialize())
        : prefs.remove('ff_positionAtual');
  }

  String _cpf = '';
  String get cpf => _cpf;
  set cpf(String value) {
    _cpf = value;
    prefs.setString('ff_CPF', value);
  }

  bool _acceptedTermsAndPrivacy = false;
  bool get acceptedTermsAndPrivacy => _acceptedTermsAndPrivacy;
  set acceptedTermsAndPrivacy(bool value) {
    _acceptedTermsAndPrivacy = value;
    prefs.setBool('ff__acceptedTermsAndPrivacy', value);
  }

  bool _keepLoggedIn = false;
  bool get keepLoggedIn => _keepLoggedIn;
  set keepLoggedIn(bool value) {
    _keepLoggedIn = value;
    prefs.setBool('ff__keepLoggedIn', value);
  }

  bool _fromRefresh = false;
  bool get fromRefresh => _fromRefresh;
  set fromRefresh(bool value) {
    _fromRefresh = value;
    prefs.setBool('ff__fromRefresh', value);
  }

  LatLng? _latLngDriver;
  LatLng? get latLngDriver => _latLngDriver;
  set latLngDriver(LatLng? value) {
    _latLngDriver = value;
    value != null
        ? prefs.setString('ff_LatLngDriver', value.serialize())
        : prefs.remove('ff_LatLngDriver');
  }

  List<PositionsStruct> _positions = [];
  List<PositionsStruct> get positions => _positions;
  set positions(List<PositionsStruct> value) {
    _positions = value;
    prefs.setStringList(
        'ff_positions', value.map((x) => x.serialize()).toList());
  }

  void addToPositions(PositionsStruct value) {
    _positions.add(value);
    prefs.setStringList(
        'ff_positions', _positions.map((x) => x.serialize()).toList());
  }

  void removeFromPositions(PositionsStruct value) {
    _positions.remove(value);
    prefs.setStringList(
        'ff_positions', _positions.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromPositions(int index) {
    _positions.removeAt(index);
    prefs.setStringList(
        'ff_positions', _positions.map((x) => x.serialize()).toList());
  }

  void updatePositionsAtIndex(
    int index,
    PositionsStruct Function(PositionsStruct) updateFn,
  ) {
    _positions[index] = updateFn(_positions[index]);
    prefs.setStringList(
        'ff_positions', _positions.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInPositions(int index, PositionsStruct value) {
    _positions.insert(index, value);
    prefs.setStringList(
        'ff_positions', _positions.map((x) => x.serialize()).toList());
  }
  bool _viagemFinalizada = false;
  bool get viagemFinalizada => _viagemFinalizada;
  set viagemFinalizada(bool value) {
    _viagemFinalizada = value;
    prefs.setBool('ff_viagemFinalizada', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}