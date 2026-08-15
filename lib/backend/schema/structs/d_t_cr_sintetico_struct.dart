// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTCrSinteticoStruct extends BaseStruct {
  DTCrSinteticoStruct({
    double? totalArrecadado,
    double? subsidiosRecebidos,
    double? subsidiosConcedidos,
    double? subsidiosAlocados,
    double? despesasProprias,
    double? saldoDisponivel,
    double? saudeOrcamentaria,
  })  : _totalArrecadado = totalArrecadado,
        _subsidiosRecebidos = subsidiosRecebidos,
        _subsidiosConcedidos = subsidiosConcedidos,
        _subsidiosAlocados = subsidiosAlocados,
        _despesasProprias = despesasProprias,
        _saldoDisponivel = saldoDisponivel,
        _saudeOrcamentaria = saudeOrcamentaria;

  // "totalArrecadado" field.
  double? _totalArrecadado;
  double get totalArrecadado => _totalArrecadado ?? 0.0;
  set totalArrecadado(double? val) => _totalArrecadado = val;

  void incrementTotalArrecadado(double amount) =>
      totalArrecadado = totalArrecadado + amount;

  bool hasTotalArrecadado() => _totalArrecadado != null;

  // "subsidiosRecebidos" field.
  double? _subsidiosRecebidos;
  double get subsidiosRecebidos => _subsidiosRecebidos ?? 0.0;
  set subsidiosRecebidos(double? val) => _subsidiosRecebidos = val;

  void incrementSubsidiosRecebidos(double amount) =>
      subsidiosRecebidos = subsidiosRecebidos + amount;

  bool hasSubsidiosRecebidos() => _subsidiosRecebidos != null;

  // "subsidiosConcedidos" field.
  double? _subsidiosConcedidos;
  double get subsidiosConcedidos => _subsidiosConcedidos ?? 0.0;
  set subsidiosConcedidos(double? val) => _subsidiosConcedidos = val;

  void incrementSubsidiosConcedidos(double amount) =>
      subsidiosConcedidos = subsidiosConcedidos + amount;

  bool hasSubsidiosConcedidos() => _subsidiosConcedidos != null;

  // "subsidiosAlocados" field.
  double? _subsidiosAlocados;
  double get subsidiosAlocados => _subsidiosAlocados ?? 0.0;
  set subsidiosAlocados(double? val) => _subsidiosAlocados = val;

  void incrementSubsidiosAlocados(double amount) =>
      subsidiosAlocados = subsidiosAlocados + amount;

  bool hasSubsidiosAlocados() => _subsidiosAlocados != null;

  // "despesasProprias" field.
  double? _despesasProprias;
  double get despesasProprias => _despesasProprias ?? 0.0;
  set despesasProprias(double? val) => _despesasProprias = val;

  void incrementDespesasProprias(double amount) =>
      despesasProprias = despesasProprias + amount;

  bool hasDespesasProprias() => _despesasProprias != null;

  // "saldoDisponivel" field.
  double? _saldoDisponivel;
  double get saldoDisponivel => _saldoDisponivel ?? 0.0;
  set saldoDisponivel(double? val) => _saldoDisponivel = val;

  void incrementSaldoDisponivel(double amount) =>
      saldoDisponivel = saldoDisponivel + amount;

  bool hasSaldoDisponivel() => _saldoDisponivel != null;

  // "saudeOrcamentaria" field.
  double? _saudeOrcamentaria;
  double get saudeOrcamentaria => _saudeOrcamentaria ?? 0.0;
  set saudeOrcamentaria(double? val) => _saudeOrcamentaria = val;

  void incrementSaudeOrcamentaria(double amount) =>
      saudeOrcamentaria = saudeOrcamentaria + amount;

  bool hasSaudeOrcamentaria() => _saudeOrcamentaria != null;

  static DTCrSinteticoStruct fromMap(Map<String, dynamic> data) =>
      DTCrSinteticoStruct(
        totalArrecadado: castToType<double>(data['totalArrecadado']),
        subsidiosRecebidos: castToType<double>(data['subsidiosRecebidos']),
        subsidiosConcedidos: castToType<double>(data['subsidiosConcedidos']),
        subsidiosAlocados: castToType<double>(data['subsidiosAlocados']),
        despesasProprias: castToType<double>(data['despesasProprias']),
        saldoDisponivel: castToType<double>(data['saldoDisponivel']),
        saudeOrcamentaria: castToType<double>(data['saudeOrcamentaria']),
      );

  static DTCrSinteticoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTCrSinteticoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalArrecadado': _totalArrecadado,
        'subsidiosRecebidos': _subsidiosRecebidos,
        'subsidiosConcedidos': _subsidiosConcedidos,
        'subsidiosAlocados': _subsidiosAlocados,
        'despesasProprias': _despesasProprias,
        'saldoDisponivel': _saldoDisponivel,
        'saudeOrcamentaria': _saudeOrcamentaria,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalArrecadado': serializeParam(
          _totalArrecadado,
          ParamType.double,
        ),
        'subsidiosRecebidos': serializeParam(
          _subsidiosRecebidos,
          ParamType.double,
        ),
        'subsidiosConcedidos': serializeParam(
          _subsidiosConcedidos,
          ParamType.double,
        ),
        'subsidiosAlocados': serializeParam(
          _subsidiosAlocados,
          ParamType.double,
        ),
        'despesasProprias': serializeParam(
          _despesasProprias,
          ParamType.double,
        ),
        'saldoDisponivel': serializeParam(
          _saldoDisponivel,
          ParamType.double,
        ),
        'saudeOrcamentaria': serializeParam(
          _saudeOrcamentaria,
          ParamType.double,
        ),
      }.withoutNulls;

  static DTCrSinteticoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTCrSinteticoStruct(
        totalArrecadado: deserializeParam(
          data['totalArrecadado'],
          ParamType.double,
          false,
        ),
        subsidiosRecebidos: deserializeParam(
          data['subsidiosRecebidos'],
          ParamType.double,
          false,
        ),
        subsidiosConcedidos: deserializeParam(
          data['subsidiosConcedidos'],
          ParamType.double,
          false,
        ),
        subsidiosAlocados: deserializeParam(
          data['subsidiosAlocados'],
          ParamType.double,
          false,
        ),
        despesasProprias: deserializeParam(
          data['despesasProprias'],
          ParamType.double,
          false,
        ),
        saldoDisponivel: deserializeParam(
          data['saldoDisponivel'],
          ParamType.double,
          false,
        ),
        saudeOrcamentaria: deserializeParam(
          data['saudeOrcamentaria'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DTCrSinteticoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTCrSinteticoStruct &&
        totalArrecadado == other.totalArrecadado &&
        subsidiosRecebidos == other.subsidiosRecebidos &&
        subsidiosConcedidos == other.subsidiosConcedidos &&
        subsidiosAlocados == other.subsidiosAlocados &&
        despesasProprias == other.despesasProprias &&
        saldoDisponivel == other.saldoDisponivel &&
        saudeOrcamentaria == other.saudeOrcamentaria;
  }

  @override
  int get hashCode => const ListEquality().hash([
        totalArrecadado,
        subsidiosRecebidos,
        subsidiosConcedidos,
        subsidiosAlocados,
        despesasProprias,
        saldoDisponivel,
        saudeOrcamentaria
      ]);
}

DTCrSinteticoStruct createDTCrSinteticoStruct({
  double? totalArrecadado,
  double? subsidiosRecebidos,
  double? subsidiosConcedidos,
  double? subsidiosAlocados,
  double? despesasProprias,
  double? saldoDisponivel,
  double? saudeOrcamentaria,
}) =>
    DTCrSinteticoStruct(
      totalArrecadado: totalArrecadado,
      subsidiosRecebidos: subsidiosRecebidos,
      subsidiosConcedidos: subsidiosConcedidos,
      subsidiosAlocados: subsidiosAlocados,
      despesasProprias: despesasProprias,
      saldoDisponivel: saldoDisponivel,
      saudeOrcamentaria: saudeOrcamentaria,
    );
