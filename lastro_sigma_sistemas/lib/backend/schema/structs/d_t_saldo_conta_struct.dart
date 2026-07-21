// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTSaldoContaStruct extends BaseStruct {
  DTSaldoContaStruct({
    String? contaId,
    String? nomeConta,
    String? tipoConta,
    double? saldoInicial,
    double? totalEntradas,
    double? totalSaidas,
    double? saldoAtual,
    int? diaFechamento,
    int? diaVencimento,
  })  : _contaId = contaId,
        _nomeConta = nomeConta,
        _tipoConta = tipoConta,
        _saldoInicial = saldoInicial,
        _totalEntradas = totalEntradas,
        _totalSaidas = totalSaidas,
        _saldoAtual = saldoAtual,
        _diaFechamento = diaFechamento,
        _diaVencimento = diaVencimento;

  // "contaId" field.
  String? _contaId;
  String get contaId => _contaId ?? '';
  set contaId(String? val) => _contaId = val;

  bool hasContaId() => _contaId != null;

  // "nomeConta" field.
  String? _nomeConta;
  String get nomeConta => _nomeConta ?? '';
  set nomeConta(String? val) => _nomeConta = val;

  bool hasNomeConta() => _nomeConta != null;

  // "tipoConta" field.
  String? _tipoConta;
  String get tipoConta => _tipoConta ?? '';
  set tipoConta(String? val) => _tipoConta = val;

  bool hasTipoConta() => _tipoConta != null;

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

  // "saldoAtual" field.
  double? _saldoAtual;
  double get saldoAtual => _saldoAtual ?? 0.0;
  set saldoAtual(double? val) => _saldoAtual = val;

  void incrementSaldoAtual(double amount) => saldoAtual = saldoAtual + amount;

  bool hasSaldoAtual() => _saldoAtual != null;

  // "diaFechamento" field.
  int? _diaFechamento;
  int get diaFechamento => _diaFechamento ?? 0;
  set diaFechamento(int? val) => _diaFechamento = val;

  void incrementDiaFechamento(int amount) =>
      diaFechamento = diaFechamento + amount;

  bool hasDiaFechamento() => _diaFechamento != null;

  // "diaVencimento" field.
  int? _diaVencimento;
  int get diaVencimento => _diaVencimento ?? 0;
  set diaVencimento(int? val) => _diaVencimento = val;

  void incrementDiaVencimento(int amount) =>
      diaVencimento = diaVencimento + amount;

  bool hasDiaVencimento() => _diaVencimento != null;

  static DTSaldoContaStruct fromMap(Map<String, dynamic> data) =>
      DTSaldoContaStruct(
        contaId: data['contaId'] as String?,
        nomeConta: data['nomeConta'] as String?,
        tipoConta: data['tipoConta'] as String?,
        saldoInicial: castToType<double>(data['saldoInicial']),
        totalEntradas: castToType<double>(data['totalEntradas']),
        totalSaidas: castToType<double>(data['totalSaidas']),
        saldoAtual: castToType<double>(data['saldoAtual']),
        diaFechamento: castToType<int>(data['diaFechamento']),
        diaVencimento: castToType<int>(data['diaVencimento']),
      );

  static DTSaldoContaStruct? maybeFromMap(dynamic data) => data is Map
      ? DTSaldoContaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'contaId': _contaId,
        'nomeConta': _nomeConta,
        'tipoConta': _tipoConta,
        'saldoInicial': _saldoInicial,
        'totalEntradas': _totalEntradas,
        'totalSaidas': _totalSaidas,
        'saldoAtual': _saldoAtual,
        'diaFechamento': _diaFechamento,
        'diaVencimento': _diaVencimento,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'contaId': serializeParam(
          _contaId,
          ParamType.String,
        ),
        'nomeConta': serializeParam(
          _nomeConta,
          ParamType.String,
        ),
        'tipoConta': serializeParam(
          _tipoConta,
          ParamType.String,
        ),
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
        'saldoAtual': serializeParam(
          _saldoAtual,
          ParamType.double,
        ),
        'diaFechamento': serializeParam(
          _diaFechamento,
          ParamType.int,
        ),
        'diaVencimento': serializeParam(
          _diaVencimento,
          ParamType.int,
        ),
      }.withoutNulls;

  static DTSaldoContaStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTSaldoContaStruct(
        contaId: deserializeParam(
          data['contaId'],
          ParamType.String,
          false,
        ),
        nomeConta: deserializeParam(
          data['nomeConta'],
          ParamType.String,
          false,
        ),
        tipoConta: deserializeParam(
          data['tipoConta'],
          ParamType.String,
          false,
        ),
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
        saldoAtual: deserializeParam(
          data['saldoAtual'],
          ParamType.double,
          false,
        ),
        diaFechamento: deserializeParam(
          data['diaFechamento'],
          ParamType.int,
          false,
        ),
        diaVencimento: deserializeParam(
          data['diaVencimento'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DTSaldoContaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTSaldoContaStruct &&
        contaId == other.contaId &&
        nomeConta == other.nomeConta &&
        tipoConta == other.tipoConta &&
        saldoInicial == other.saldoInicial &&
        totalEntradas == other.totalEntradas &&
        totalSaidas == other.totalSaidas &&
        saldoAtual == other.saldoAtual &&
        diaFechamento == other.diaFechamento &&
        diaVencimento == other.diaVencimento;
  }

  @override
  int get hashCode => const ListEquality().hash([
        contaId,
        nomeConta,
        tipoConta,
        saldoInicial,
        totalEntradas,
        totalSaidas,
        saldoAtual,
        diaFechamento,
        diaVencimento
      ]);
}

DTSaldoContaStruct createDTSaldoContaStruct({
  String? contaId,
  String? nomeConta,
  String? tipoConta,
  double? saldoInicial,
  double? totalEntradas,
  double? totalSaidas,
  double? saldoAtual,
  int? diaFechamento,
  int? diaVencimento,
}) =>
    DTSaldoContaStruct(
      contaId: contaId,
      nomeConta: nomeConta,
      tipoConta: tipoConta,
      saldoInicial: saldoInicial,
      totalEntradas: totalEntradas,
      totalSaidas: totalSaidas,
      saldoAtual: saldoAtual,
      diaFechamento: diaFechamento,
      diaVencimento: diaVencimento,
    );
