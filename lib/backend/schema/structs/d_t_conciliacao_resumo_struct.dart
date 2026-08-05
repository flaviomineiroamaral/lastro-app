// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTConciliacaoResumoStruct extends BaseStruct {
  DTConciliacaoResumoStruct({
    double? saldoInicialHistorico,
    double? resultadoOperacional,
    double? disponibilidadeReal,
  })  : _saldoInicialHistorico = saldoInicialHistorico,
        _resultadoOperacional = resultadoOperacional,
        _disponibilidadeReal = disponibilidadeReal;

  // "saldoInicialHistorico" field.
  double? _saldoInicialHistorico;
  double get saldoInicialHistorico => _saldoInicialHistorico ?? 0.0;
  set saldoInicialHistorico(double? val) => _saldoInicialHistorico = val;

  void incrementSaldoInicialHistorico(double amount) =>
      saldoInicialHistorico = saldoInicialHistorico + amount;

  bool hasSaldoInicialHistorico() => _saldoInicialHistorico != null;

  // "resultadoOperacional" field.
  double? _resultadoOperacional;
  double get resultadoOperacional => _resultadoOperacional ?? 0.0;
  set resultadoOperacional(double? val) => _resultadoOperacional = val;

  void incrementResultadoOperacional(double amount) =>
      resultadoOperacional = resultadoOperacional + amount;

  bool hasResultadoOperacional() => _resultadoOperacional != null;

  // "disponibilidadeReal" field.
  double? _disponibilidadeReal;
  double get disponibilidadeReal => _disponibilidadeReal ?? 0.0;
  set disponibilidadeReal(double? val) => _disponibilidadeReal = val;

  void incrementDisponibilidadeReal(double amount) =>
      disponibilidadeReal = disponibilidadeReal + amount;

  bool hasDisponibilidadeReal() => _disponibilidadeReal != null;

  static DTConciliacaoResumoStruct fromMap(Map<String, dynamic> data) =>
      DTConciliacaoResumoStruct(
        saldoInicialHistorico:
            castToType<double>(data['saldoInicialHistorico']),
        resultadoOperacional: castToType<double>(data['resultadoOperacional']),
        disponibilidadeReal: castToType<double>(data['disponibilidadeReal']),
      );

  static DTConciliacaoResumoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTConciliacaoResumoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'saldoInicialHistorico': _saldoInicialHistorico,
        'resultadoOperacional': _resultadoOperacional,
        'disponibilidadeReal': _disponibilidadeReal,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'saldoInicialHistorico': serializeParam(
          _saldoInicialHistorico,
          ParamType.double,
        ),
        'resultadoOperacional': serializeParam(
          _resultadoOperacional,
          ParamType.double,
        ),
        'disponibilidadeReal': serializeParam(
          _disponibilidadeReal,
          ParamType.double,
        ),
      }.withoutNulls;

  static DTConciliacaoResumoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTConciliacaoResumoStruct(
        saldoInicialHistorico: deserializeParam(
          data['saldoInicialHistorico'],
          ParamType.double,
          false,
        ),
        resultadoOperacional: deserializeParam(
          data['resultadoOperacional'],
          ParamType.double,
          false,
        ),
        disponibilidadeReal: deserializeParam(
          data['disponibilidadeReal'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DTConciliacaoResumoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTConciliacaoResumoStruct &&
        saldoInicialHistorico == other.saldoInicialHistorico &&
        resultadoOperacional == other.resultadoOperacional &&
        disponibilidadeReal == other.disponibilidadeReal;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([saldoInicialHistorico, resultadoOperacional, disponibilidadeReal]);
}

DTConciliacaoResumoStruct createDTConciliacaoResumoStruct({
  double? saldoInicialHistorico,
  double? resultadoOperacional,
  double? disponibilidadeReal,
}) =>
    DTConciliacaoResumoStruct(
      saldoInicialHistorico: saldoInicialHistorico,
      resultadoOperacional: resultadoOperacional,
      disponibilidadeReal: disponibilidadeReal,
    );
