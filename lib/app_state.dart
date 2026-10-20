import 'package:flutter/material.dart'
    show ChangeNotifier, Color, Colors, VoidCallback;
import '/backend/schema/structs/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
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
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _currentOrganizationId =
          await secureStorage.getString('ff_currentOrganizationId') ??
              _currentOrganizationId;
    });
    await _safeInitAsync(() async {
      _currentOrganizationType =
          await secureStorage.getString('ff_currentOrganizationType') ??
              _currentOrganizationType;
    });
    await _safeInitAsync(() async {
      _currentOrganizationName =
          await secureStorage.getString('ff_currentOrganizationName') ??
              _currentOrganizationName;
    });
    await _safeInitAsync(() async {
      _currentUser =
          await secureStorage.getString('ff_currentUser') ?? _currentUser;
    });
    await _safeInitAsync(() async {
      _currentFunction = await secureStorage.getString('ff_currentFunction') ??
          _currentFunction;
    });
    await _safeInitAsync(() async {
      _currentPlanName = await secureStorage.getString('ff_currentPlanName') ??
          _currentPlanName;
    });
    await _safeInitAsync(() async {
      _currentOrganizationFone =
          await secureStorage.getString('ff_currentOrganizationFone') ??
              _currentOrganizationFone;
    });
    await _safeInitAsync(() async {
      _limitecrsplano =
          await secureStorage.getInt('ff_limitecrsplano') ?? _limitecrsplano;
    });
    await _safeInitAsync(() async {
      _limitecrsatual =
          await secureStorage.getInt('ff_limitecrsatual') ?? _limitecrsatual;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

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
    secureStorage.setString('ff_currentOrganizationId', value);
  }

  void deleteCurrentOrganizationId() {
    secureStorage.delete(key: 'ff_currentOrganizationId');
  }

  String _currentOrganizationType = '';
  String get currentOrganizationType => _currentOrganizationType;
  set currentOrganizationType(String value) {
    _currentOrganizationType = value;
    secureStorage.setString('ff_currentOrganizationType', value);
  }

  void deleteCurrentOrganizationType() {
    secureStorage.delete(key: 'ff_currentOrganizationType');
  }

  String _currentOrganizationName = '';
  String get currentOrganizationName => _currentOrganizationName;
  set currentOrganizationName(String value) {
    _currentOrganizationName = value;
    secureStorage.setString('ff_currentOrganizationName', value);
  }

  void deleteCurrentOrganizationName() {
    secureStorage.delete(key: 'ff_currentOrganizationName');
  }

  String _currentUser = '';
  String get currentUser => _currentUser;
  set currentUser(String value) {
    _currentUser = value;
    secureStorage.setString('ff_currentUser', value);
  }

  void deleteCurrentUser() {
    secureStorage.delete(key: 'ff_currentUser');
  }

  String _currentFunction = '';
  String get currentFunction => _currentFunction;
  set currentFunction(String value) {
    _currentFunction = value;
    secureStorage.setString('ff_currentFunction', value);
  }

  void deleteCurrentFunction() {
    secureStorage.delete(key: 'ff_currentFunction');
  }

  String _currentPlanName = '';
  String get currentPlanName => _currentPlanName;
  set currentPlanName(String value) {
    _currentPlanName = value;
    secureStorage.setString('ff_currentPlanName', value);
  }

  void deleteCurrentPlanName() {
    secureStorage.delete(key: 'ff_currentPlanName');
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
    secureStorage.setString('ff_currentOrganizationFone', value);
  }

  void deleteCurrentOrganizationFone() {
    secureStorage.delete(key: 'ff_currentOrganizationFone');
  }

  int _limitecrsplano = 0;
  int get limitecrsplano => _limitecrsplano;
  set limitecrsplano(int value) {
    _limitecrsplano = value;
    secureStorage.setInt('ff_limitecrsplano', value);
  }

  void deleteLimitecrsplano() {
    secureStorage.delete(key: 'ff_limitecrsplano');
  }

  int _limitecrsatual = 0;
  int get limitecrsatual => _limitecrsatual;
  set limitecrsatual(int value) {
    _limitecrsatual = value;
    secureStorage.setInt('ff_limitecrsatual', value);
  }

  void deleteLimitecrsatual() {
    secureStorage.delete(key: 'ff_limitecrsatual');
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

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async {
    final value = await read(key: key);
    return value == null ? null : value == 'true';
  }

  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        // Lists are stored as JSON. Older versions stored CSV, which never
        // starts with `["` because CSV quotes any field containing a quote.
        if (result == '[]' || result.startsWith('["')) {
          return (jsonDecode(result) as List).map((e) => e.toString()).toList();
        }
        return const CsvToListConverter(shouldParseNumbers: false)
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: jsonEncode(value));
}
