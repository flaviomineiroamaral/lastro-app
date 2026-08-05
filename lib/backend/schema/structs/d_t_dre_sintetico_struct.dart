// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTDreSinteticoStruct extends BaseStruct {
  DTDreSinteticoStruct({
    double? totalReceitas,
    double? totalDespesas,
    double? resultadoLiquido,
    double? margemLucro,
  })  : _totalReceitas = totalReceitas,
        _totalDespesas = totalDespesas,
        _resultadoLiquido = resultadoLiquido,
        _margemLucro = margemLucro;

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

  static DTDreSinteticoStruct fromMap(Map<String, dynamic> data) =>
      DTDreSinteticoStruct(
        totalReceitas: castToType<double>(data['totalReceitas']),
        totalDespesas: castToType<double>(data['totalDespesas']),
        resultadoLiquido: castToType<double>(data['resultadoLiquido']),
        margemLucro: castToType<double>(data['margemLucro']),
      );

  static DTDreSinteticoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTDreSinteticoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalReceitas': _totalReceitas,
        'totalDespesas': _totalDespesas,
        'resultadoLiquido': _resultadoLiquido,
        'margemLucro': _margemLucro,
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
      );

  @override
  String toString() => 'DTDreSinteticoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTDreSinteticoStruct &&
        totalReceitas == other.totalReceitas &&
        totalDespesas == other.totalDespesas &&
        resultadoLiquido == other.resultadoLiquido &&
        margemLucro == other.margemLucro;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([totalReceitas, totalDespesas, resultadoLiquido, margemLucro]);
}

DTDreSinteticoStruct createDTDreSinteticoStruct({
  double? totalReceitas,
  double? totalDespesas,
  double? resultadoLiquido,
  double? margemLucro,
}) =>
    DTDreSinteticoStruct(
      totalReceitas: totalReceitas,
      totalDespesas: totalDespesas,
      resultadoLiquido: resultadoLiquido,
      margemLucro: margemLucro,
    );
