// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTDreSinteticoStruct extends BaseStruct {
  DTDreSinteticoStruct({
    double? totalReceitas,
    double? totalDespesas,
    double? resultadoLiquido,
    double? margemLucro,
    double? somaDespesasOperacionais,
    double? somaDespesasFinanceiras,
    double? resultadoOperacional,
  })  : _totalReceitas = totalReceitas,
        _totalDespesas = totalDespesas,
        _resultadoLiquido = resultadoLiquido,
        _margemLucro = margemLucro,
        _somaDespesasOperacionais = somaDespesasOperacionais,
        _somaDespesasFinanceiras = somaDespesasFinanceiras,
        _resultadoOperacional = resultadoOperacional;

  // "totalReceitas" field.
  double? _totalReceitas;
  double get totalReceitas => _totalReceitas ?? 0.0;
  set totalReceitas(double? val) => _totalReceitas = val;

  void incrementTotalReceitas(double amount) =>
      totalReceitas = totalReceitas + amount;

  bool hasTotalReceitas() => _totalReceitas != null;

  // "totalDespesas" field.
  double? _totalDespesas;
  double get totalDespesas => _totalDespesas ?? 0.0;
  set totalDespesas(double? val) => _totalDespesas = val;

  void incrementTotalDespesas(double amount) =>
      totalDespesas = totalDespesas + amount;

  bool hasTotalDespesas() => _totalDespesas != null;

  // "resultadoLiquido" field.
  double? _resultadoLiquido;
  double get resultadoLiquido => _resultadoLiquido ?? 0.0;
  set resultadoLiquido(double? val) => _resultadoLiquido = val;

  void incrementResultadoLiquido(double amount) =>
      resultadoLiquido = resultadoLiquido + amount;

  bool hasResultadoLiquido() => _resultadoLiquido != null;

  // "margemLucro" field.
  double? _margemLucro;
  double get margemLucro => _margemLucro ?? 0.0;
  set margemLucro(double? val) => _margemLucro = val;

  void incrementMargemLucro(double amount) =>
      margemLucro = margemLucro + amount;

  bool hasMargemLucro() => _margemLucro != null;

  // "somaDespesasOperacionais" field.
  double? _somaDespesasOperacionais;
  double get somaDespesasOperacionais => _somaDespesasOperacionais ?? 0.0;
  set somaDespesasOperacionais(double? val) => _somaDespesasOperacionais = val;

  void incrementSomaDespesasOperacionais(double amount) =>
      somaDespesasOperacionais = somaDespesasOperacionais + amount;

  bool hasSomaDespesasOperacionais() => _somaDespesasOperacionais != null;

  // "somaDespesasFinanceiras" field.
  double? _somaDespesasFinanceiras;
  double get somaDespesasFinanceiras => _somaDespesasFinanceiras ?? 0.0;
  set somaDespesasFinanceiras(double? val) => _somaDespesasFinanceiras = val;

  void incrementSomaDespesasFinanceiras(double amount) =>
      somaDespesasFinanceiras = somaDespesasFinanceiras + amount;

  bool hasSomaDespesasFinanceiras() => _somaDespesasFinanceiras != null;

  // "resultadoOperacional" field.
  double? _resultadoOperacional;
  double get resultadoOperacional => _resultadoOperacional ?? 0.0;
  set resultadoOperacional(double? val) => _resultadoOperacional = val;

  void incrementResultadoOperacional(double amount) =>
      resultadoOperacional = resultadoOperacional + amount;

  bool hasResultadoOperacional() => _resultadoOperacional != null;

  static DTDreSinteticoStruct fromMap(Map<String, dynamic> data) =>
      DTDreSinteticoStruct(
        totalReceitas: castToType<double>(data['totalReceitas']),
        totalDespesas: castToType<double>(data['totalDespesas']),
        resultadoLiquido: castToType<double>(data['resultadoLiquido']),
        margemLucro: castToType<double>(data['margemLucro']),
        somaDespesasOperacionais:
            castToType<double>(data['somaDespesasOperacionais']),
        somaDespesasFinanceiras:
            castToType<double>(data['somaDespesasFinanceiras']),
        resultadoOperacional: castToType<double>(data['resultadoOperacional']),
      );

  static DTDreSinteticoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTDreSinteticoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalReceitas': _totalReceitas,
        'totalDespesas': _totalDespesas,
        'resultadoLiquido': _resultadoLiquido,
        'margemLucro': _margemLucro,
        'somaDespesasOperacionais': _somaDespesasOperacionais,
        'somaDespesasFinanceiras': _somaDespesasFinanceiras,
        'resultadoOperacional': _resultadoOperacional,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalReceitas': serializeParam(
          _totalReceitas,
          ParamType.double,
        ),
        'totalDespesas': serializeParam(
          _totalDespesas,
          ParamType.double,
        ),
        'resultadoLiquido': serializeParam(
          _resultadoLiquido,
          ParamType.double,
        ),
        'margemLucro': serializeParam(
          _margemLucro,
          ParamType.double,
        ),
        'somaDespesasOperacionais': serializeParam(
          _somaDespesasOperacionais,
          ParamType.double,
        ),
        'somaDespesasFinanceiras': serializeParam(
          _somaDespesasFinanceiras,
          ParamType.double,
        ),
        'resultadoOperacional': serializeParam(
          _resultadoOperacional,
          ParamType.double,
        ),
      }.withoutNulls;

  static DTDreSinteticoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTDreSinteticoStruct(
        totalReceitas: deserializeParam(
          data['totalReceitas'],
          ParamType.double,
          false,
        ),
        totalDespesas: deserializeParam(
          data['totalDespesas'],
          ParamType.double,
          false,
        ),
        resultadoLiquido: deserializeParam(
          data['resultadoLiquido'],
          ParamType.double,
          false,
        ),
        margemLucro: deserializeParam(
          data['margemLucro'],
          ParamType.double,
          false,
        ),
        somaDespesasOperacionais: deserializeParam(
          data['somaDespesasOperacionais'],
          ParamType.double,
          false,
        ),
        somaDespesasFinanceiras: deserializeParam(
          data['somaDespesasFinanceiras'],
          ParamType.double,
          false,
        ),
        resultadoOperacional: deserializeParam(
          data['resultadoOperacional'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DTDreSinteticoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTDreSinteticoStruct &&
        totalReceitas == other.totalReceitas &&
        totalDespesas == other.totalDespesas &&
        resultadoLiquido == other.resultadoLiquido &&
        margemLucro == other.margemLucro &&
        somaDespesasOperacionais == other.somaDespesasOperacionais &&
        somaDespesasFinanceiras == other.somaDespesasFinanceiras &&
        resultadoOperacional == other.resultadoOperacional;
  }

  @override
  int get hashCode => const ListEquality().hash([
        totalReceitas,
        totalDespesas,
        resultadoLiquido,
        margemLucro,
        somaDespesasOperacionais,
        somaDespesasFinanceiras,
        resultadoOperacional
      ]);
}

DTDreSinteticoStruct createDTDreSinteticoStruct({
  double? totalReceitas,
  double? totalDespesas,
  double? resultadoLiquido,
  double? margemLucro,
  double? somaDespesasOperacionais,
  double? somaDespesasFinanceiras,
  double? resultadoOperacional,
}) =>
    DTDreSinteticoStruct(
      totalReceitas: totalReceitas,
      totalDespesas: totalDespesas,
      resultadoLiquido: resultadoLiquido,
      margemLucro: margemLucro,
      somaDespesasOperacionais: somaDespesasOperacionais,
      somaDespesasFinanceiras: somaDespesasFinanceiras,
      resultadoOperacional: resultadoOperacional,
    );
