import 'package:flutter/material.dart'
    show ChangeNotifier, Color, Colors, VoidCallback;
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      _currentOrganizationId =
          prefs.getString('ff_currentOrganizationId') ?? _currentOrganizationId;
    });
    _safeInit(() {
      _currentOrganizationType =
          prefs.getString('ff_currentOrganizationType') ??
              _currentOrganizationType;
    });
    _safeInit(() {
      _currentOrganizationName =
          prefs.getString('ff_currentOrganizationName') ??
              _currentOrganizationName;
    });
    _safeInit(() {
      _currentUser = prefs.getString('ff_currentUser') ?? _currentUser;
    });
    _safeInit(() {
      _currentFunction =
          prefs.getString('ff_currentFunction') ?? _currentFunction;
    });
    _safeInit(() {
      _currentPlanName =
          prefs.getString('ff_currentPlanName') ?? _currentPlanName;
    });
    _safeInit(() {
      _currentOrganizationFone =
          prefs.getString('ff_currentOrganizationFone') ??
              _currentOrganizationFone;
    });
    _safeInit(() {
      _limitecrsplano = prefs.getInt('ff_limitecrsplano') ?? _limitecrsplano;
    });
    _safeInit(() {
      _limitecrsatual = prefs.getInt('ff_limitecrsatual') ?? _limitecrsatual;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<OfxTransactionStruct> _tempImportacaoOFX = [];
  List<OfxTransactionStruct> get tempImportacaoOFX => _tempImportacaoOFX;
  set tempImportacaoOFX(List<OfxTransactionStruct> value) {
    _tempImportacaoOFX = value;
  }

  void addToTempImportacaoOFX(OfxTransactionStruct value) {
    tempImportacaoOFX.add(value);
  }

  void removeFromTempImportacaoOFX(OfxTransactionStruct value) {
    tempImportacaoOFX.remove(value);
  }

  void removeAtIndexFromTempImportacaoOFX(int index) {
    tempImportacaoOFX.removeAt(index);
  }

  void updateTempImportacaoOFXAtIndex(
    int index,
    OfxTransactionStruct Function(OfxTransactionStruct) updateFn,
  ) {
    tempImportacaoOFX[index] = updateFn(_tempImportacaoOFX[index]);
  }

  void insertAtIndexInTempImportacaoOFX(int index, OfxTransactionStruct value) {
    tempImportacaoOFX.insert(index, value);
  }

  String _currentOrganizationId = '';
  String get currentOrganizationId => _currentOrganizationId;
  set currentOrganizationId(String value) {
    _currentOrganizationId = value;
    prefs.setString('ff_currentOrganizationId', value);
  }

  String _currentOrganizationType = '';
  String get currentOrganizationType => _currentOrganizationType;
  set currentOrganizationType(String value) {
    _currentOrganizationType = value;
    prefs.setString('ff_currentOrganizationType', value);
  }

  String _currentOrganizationName = '';
  String get currentOrganizationName => _currentOrganizationName;
  set currentOrganizationName(String value) {
    _currentOrganizationName = value;
    prefs.setString('ff_currentOrganizationName', value);
  }

  String _currentUser = '';
  String get currentUser => _currentUser;
  set currentUser(String value) {
    _currentUser = value;
    prefs.setString('ff_currentUser', value);
  }

  String _currentFunction = '';
  String get currentFunction => _currentFunction;
  set currentFunction(String value) {
    _currentFunction = value;
    prefs.setString('ff_currentFunction', value);
  }

  String _currentPlanName = '';
  String get currentPlanName => _currentPlanName;
  set currentPlanName(String value) {
    _currentPlanName = value;
    prefs.setString('ff_currentPlanName', value);
  }

  String _currentOrganizationDoc = '';
  String get currentOrganizationDoc => _currentOrganizationDoc;
  set currentOrganizationDoc(String value) {
    _currentOrganizationDoc = value;
  }

  String _currentOrganizationFone = '';
  String get currentOrganizationFone => _currentOrganizationFone;
  set currentOrganizationFone(String value) {
    _currentOrganizationFone = value;
    prefs.setString('ff_currentOrganizationFone', value);
  }

  int _limitecrsplano = 0;
  int get limitecrsplano => _limitecrsplano;
  set limitecrsplano(int value) {
    _limitecrsplano = value;
    prefs.setInt('ff_limitecrsplano', value);
  }

  int _limitecrsatual = 0;
  int get limitecrsatual => _limitecrsatual;
  set limitecrsatual(int value) {
    _limitecrsatual = value;
    prefs.setInt('ff_limitecrsatual', value);
  }

  bool _isbloqueadofinanceiro = false;
  bool get isbloqueadofinanceiro => _isbloqueadofinanceiro;
  set isbloqueadofinanceiro(bool value) {
    _isbloqueadofinanceiro = value;
  }

  DateTime? _dataInicioGlob;
  DateTime? get dataInicioGlob => _dataInicioGlob;
  set dataInicioGlob(DateTime? value) {
    _dataInicioGlob = value;
  }

  DateTime? _dataFimGlob;
  DateTime? get dataFimGlob => _dataFimGlob;
  set dataFimGlob(DateTime? value) {
    _dataFimGlob = value;
  }

  List<DTCachePlanoContasStruct> _cachePlanoContas = [];
  List<DTCachePlanoContasStruct> get cachePlanoContas => _cachePlanoContas;
  set cachePlanoContas(List<DTCachePlanoContasStruct> value) {
    _cachePlanoContas = value;
  }

  void addToCachePlanoContas(DTCachePlanoContasStruct value) {
    cachePlanoContas.add(value);
  }

  void removeFromCachePlanoContas(DTCachePlanoContasStruct value) {
    cachePlanoContas.remove(value);
  }

  void removeAtIndexFromCachePlanoContas(int index) {
    cachePlanoContas.removeAt(index);
  }

  void updateCachePlanoContasAtIndex(
    int index,
    DTCachePlanoContasStruct Function(DTCachePlanoContasStruct) updateFn,
  ) {
    cachePlanoContas[index] = updateFn(_cachePlanoContas[index]);
  }

  void insertAtIndexInCachePlanoContas(
      int index, DTCachePlanoContasStruct value) {
    cachePlanoContas.insert(index, value);
  }

  List<DTCacheContasBancariasStruct> _cacheContasBancarias = [];
  List<DTCacheContasBancariasStruct> get cacheContasBancarias =>
      _cacheContasBancarias;
  set cacheContasBancarias(List<DTCacheContasBancariasStruct> value) {
    _cacheContasBancarias = value;
  }

  void addToCacheContasBancarias(DTCacheContasBancariasStruct value) {
    cacheContasBancarias.add(value);
  }

  void removeFromCacheContasBancarias(DTCacheContasBancariasStruct value) {
    cacheContasBancarias.remove(value);
  }

  void removeAtIndexFromCacheContasBancarias(int index) {
    cacheContasBancarias.removeAt(index);
  }

  void updateCacheContasBancariasAtIndex(
    int index,
    DTCacheContasBancariasStruct Function(DTCacheContasBancariasStruct)
        updateFn,
  ) {
    cacheContasBancarias[index] = updateFn(_cacheContasBancarias[index]);
  }

  void insertAtIndexInCacheContasBancarias(
      int index, DTCacheContasBancariasStruct value) {
    cacheContasBancarias.insert(index, value);
  }

  List<DTCacheCentrosDeResultadoStruct> _cacheCentrosDeResultado = [];
  List<DTCacheCentrosDeResultadoStruct> get cacheCentrosDeResultado =>
      _cacheCentrosDeResultado;
  set cacheCentrosDeResultado(List<DTCacheCentrosDeResultadoStruct> value) {
    _cacheCentrosDeResultado = value;
  }

  void addToCacheCentrosDeResultado(DTCacheCentrosDeResultadoStruct value) {
    cacheCentrosDeResultado.add(value);
  }

  void removeFromCacheCentrosDeResultado(
      DTCacheCentrosDeResultadoStruct value) {
    cacheCentrosDeResultado.remove(value);
  }

  void removeAtIndexFromCacheCentrosDeResultado(int index) {
    cacheCentrosDeResultado.removeAt(index);
  }

  void updateCacheCentrosDeResultadoAtIndex(
    int index,
    DTCacheCentrosDeResultadoStruct Function(DTCacheCentrosDeResultadoStruct)
        updateFn,
  ) {
    cacheCentrosDeResultado[index] = updateFn(_cacheCentrosDeResultado[index]);
  }

  void insertAtIndexInCacheCentrosDeResultado(
      int index, DTCacheCentrosDeResultadoStruct value) {
    cacheCentrosDeResultado.insert(index, value);
  }

  List<DTCacheMembrosLightStruct> _cacheMembros = [];
  List<DTCacheMembrosLightStruct> get cacheMembros => _cacheMembros;
  set cacheMembros(List<DTCacheMembrosLightStruct> value) {
    _cacheMembros = value;
  }

  void addToCacheMembros(DTCacheMembrosLightStruct value) {
    cacheMembros.add(value);
  }

  void removeFromCacheMembros(DTCacheMembrosLightStruct value) {
    cacheMembros.remove(value);
  }

  void removeAtIndexFromCacheMembros(int index) {
    cacheMembros.removeAt(index);
  }

  void updateCacheMembrosAtIndex(
    int index,
    DTCacheMembrosLightStruct Function(DTCacheMembrosLightStruct) updateFn,
  ) {
    cacheMembros[index] = updateFn(_cacheMembros[index]);
  }

  void insertAtIndexInCacheMembros(int index, DTCacheMembrosLightStruct value) {
    cacheMembros.insert(index, value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
