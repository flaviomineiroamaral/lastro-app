// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTDfcSinteticoStruct extends BaseStruct {
  DTDfcSinteticoStruct({
    double? saldoInicial,
    double? totalEntradas,
    double? totalSaidas,
    double? geracaoCaixa,
    double? saldoFinal,
  })  : _saldoInicial = saldoInicial,
        _totalEntradas = totalEntradas,
        _totalSaidas = totalSaidas,
        _geracaoCaixa = geracaoCaixa,
        _saldoFinal = saldoFinal;

  // "saldoInicial" field.
  double? _saldoInicial;
  double get saldoInicial => _saldoInicial ?? 0.0;
  set saldoInicial(double? val) => _saldoInicial = val;

  void incrementSaldoInicial(double amount) =>
      saldoInicial = saldoInicial + amount;

  bool hasSaldoInicial() => _saldoInicial != null;

  // "totalEntradas" field.
  double? _totalEntradas;
  double get totalEntradas => _totalEntradas ?? 0.0;
  set totalEntradas(double? val) => _totalEntradas = val;

  void incrementTotalEntradas(double amount) =>
      totalEntradas = totalEntradas + amount;

  bool hasTotalEntradas() => _totalEntradas != null;

  // "totalSaidas" field.
  double? _totalSaidas;
  double get totalSaidas => _totalSaidas ?? 0.0;
  set totalSaidas(double? val) => _totalSaidas = val;

  void incrementTotalSaidas(double amount) =>
      totalSaidas = totalSaidas + amount;

  bool hasTotalSaidas() => _totalSaidas != null;

  // "geracaoCaixa" field.
  double? _geracaoCaixa;
  double get geracaoCaixa => _geracaoCaixa ?? 0.0;
  set geracaoCaixa(double? val) => _geracaoCaixa = val;

  void incrementGeracaoCaixa(double amount) =>
      geracaoCaixa = geracaoCaixa + amount;

  bool hasGeracaoCaixa() => _geracaoCaixa != null;

  // "saldoFinal" field.
  double? _saldoFinal;
  double get saldoFinal => _saldoFinal ?? 0.0;
  set saldoFinal(double? val) => _saldoFinal = val;

  void incrementSaldoFinal(double amount) => saldoFinal = saldoFinal + amount;

  bool hasSaldoFinal() => _saldoFinal != null;

  static DTDfcSinteticoStruct fromMap(Map<String, dynamic> data) =>
      DTDfcSinteticoStruct(
        saldoInicial: castToType<double>(data['saldoInicial']),
        totalEntradas: castToType<double>(data['totalEntradas']),
        totalSaidas: castToType<double>(data['totalSaidas']),
        geracaoCaixa: castToType<double>(data['geracaoCaixa']),
        saldoFinal: castToType<double>(data['saldoFinal']),
      );

  static DTDfcSinteticoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTDfcSinteticoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'saldoInicial': _saldoInicial,
        'totalEntradas': _totalEntradas,
        'totalSaidas': _totalSaidas,
        'geracaoCaixa': _geracaoCaixa,
        'saldoFinal': _saldoFinal,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'saldoInicial': serializeParam(
          _saldoInicial,
          ParamType.double,
        ),
        'totalEntradas': serializeParam(
          _totalEntradas,
          ParamType.double,
        ),
        'totalSaidas': serializeParam(
          _totalSaidas,
          ParamType.double,
        ),
        'geracaoCaixa': serializeParam(
          _geracaoCaixa,
          ParamType.double,
        ),
        'saldoFinal': serializeParam(
          _saldoFinal,
          ParamType.double,
        ),
      }.withoutNulls;

  static DTDfcSinteticoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTDfcSinteticoStruct(
        saldoInicial: deserializeParam(
          data['saldoInicial'],
          ParamType.double,
          false,
        ),
        totalEntradas: deserializeParam(
          data['totalEntradas'],
          ParamType.double,
          false,
        ),
        totalSaidas: deserializeParam(
          data['totalSaidas'],
          ParamType.double,
          false,
        ),
        geracaoCaixa: deserializeParam(
          data['geracaoCaixa'],
          ParamType.double,
          false,
        ),
        saldoFinal: deserializeParam(
          data['saldoFinal'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DTDfcSinteticoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTDfcSinteticoStruct &&
        saldoInicial == other.saldoInicial &&
        totalEntradas == other.totalEntradas &&
        totalSaidas == other.totalSaidas &&
        geracaoCaixa == other.geracaoCaixa &&
        saldoFinal == other.saldoFinal;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [saldoInicial, totalEntradas, totalSaidas, geracaoCaixa, saldoFinal]);
}

DTDfcSinteticoStruct createDTDfcSinteticoStruct({
  double? saldoInicial,
  double? totalEntradas,
  double? totalSaidas,
  double? geracaoCaixa,
  double? saldoFinal,
}) =>
    DTDfcSinteticoStruct(
      saldoInicial: saldoInicial,
      totalEntradas: totalEntradas,
      totalSaidas: totalSaidas,
      geracaoCaixa: geracaoCaixa,
      saldoFinal: saldoFinal,
    );
