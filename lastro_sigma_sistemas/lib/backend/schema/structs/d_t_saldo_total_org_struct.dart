// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTSaldoTotalOrgStruct extends BaseStruct {
  DTSaldoTotalOrgStruct({
    double? totalSaldoInicial,
    double? totalEntradas,
    double? totalSaidas,
    double? saldoLiquidoGeral,
    double? saldoDisponivelReal,
    double? totalFaturasCartao,
    double? totalAReceber,
    double? totalAPagar,
    double? resumoAtivoPassivo,
    double? burnRate,
    bool? isAlavancado,
    String? msgAlertaAlavancagem,
    String? msgAlivioCaixa,
    bool? isCaixaComprometido,
    String? msgAlertaRetencao,

    /// Exibe o título do Cenário no App.
    String? statusSolvencia,

    /// Exibe a orientação estratégica detalhada.
    String? msgSolvencia,

    /// Pode ser usado para colorir todo o cartão de vermelho
    bool? isInsolvente,
  })  : _totalSaldoInicial = totalSaldoInicial,
        _totalEntradas = totalEntradas,
        _totalSaidas = totalSaidas,
        _saldoLiquidoGeral = saldoLiquidoGeral,
        _saldoDisponivelReal = saldoDisponivelReal,
        _totalFaturasCartao = totalFaturasCartao,
        _totalAReceber = totalAReceber,
        _totalAPagar = totalAPagar,
        _resumoAtivoPassivo = resumoAtivoPassivo,
        _burnRate = burnRate,
        _isAlavancado = isAlavancado,
        _msgAlertaAlavancagem = msgAlertaAlavancagem,
        _msgAlivioCaixa = msgAlivioCaixa,
        _isCaixaComprometido = isCaixaComprometido,
        _msgAlertaRetencao = msgAlertaRetencao,
        _statusSolvencia = statusSolvencia,
        _msgSolvencia = msgSolvencia,
        _isInsolvente = isInsolvente;

  // "totalSaldoInicial" field.
  double? _totalSaldoInicial;
  double get totalSaldoInicial => _totalSaldoInicial ?? 0.0;
  set totalSaldoInicial(double? val) => _totalSaldoInicial = val;

  void incrementTotalSaldoInicial(double amount) =>
      totalSaldoInicial = totalSaldoInicial + amount;

  bool hasTotalSaldoInicial() => _totalSaldoInicial != null;

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

  // "saldoLiquidoGeral" field.
  double? _saldoLiquidoGeral;
  double get saldoLiquidoGeral => _saldoLiquidoGeral ?? 0.0;
  set saldoLiquidoGeral(double? val) => _saldoLiquidoGeral = val;

  void incrementSaldoLiquidoGeral(double amount) =>
      saldoLiquidoGeral = saldoLiquidoGeral + amount;

  bool hasSaldoLiquidoGeral() => _saldoLiquidoGeral != null;

  // "saldoDisponivelReal" field.
  double? _saldoDisponivelReal;
  double get saldoDisponivelReal => _saldoDisponivelReal ?? 0.0;
  set saldoDisponivelReal(double? val) => _saldoDisponivelReal = val;

  void incrementSaldoDisponivelReal(double amount) =>
      saldoDisponivelReal = saldoDisponivelReal + amount;

  bool hasSaldoDisponivelReal() => _saldoDisponivelReal != null;

  // "totalFaturasCartao" field.
  double? _totalFaturasCartao;
  double get totalFaturasCartao => _totalFaturasCartao ?? 0.0;
  set totalFaturasCartao(double? val) => _totalFaturasCartao = val;

  void incrementTotalFaturasCartao(double amount) =>
      totalFaturasCartao = totalFaturasCartao + amount;

  bool hasTotalFaturasCartao() => _totalFaturasCartao != null;

  // "totalAReceber" field.
  double? _totalAReceber;
  double get totalAReceber => _totalAReceber ?? 0.0;
  set totalAReceber(double? val) => _totalAReceber = val;

  void incrementTotalAReceber(double amount) =>
      totalAReceber = totalAReceber + amount;

  bool hasTotalAReceber() => _totalAReceber != null;

  // "totalAPagar" field.
  double? _totalAPagar;
  double get totalAPagar => _totalAPagar ?? 0.0;
  set totalAPagar(double? val) => _totalAPagar = val;

  void incrementTotalAPagar(double amount) =>
      totalAPagar = totalAPagar + amount;

  bool hasTotalAPagar() => _totalAPagar != null;

  // "resumoAtivoPassivo" field.
  double? _resumoAtivoPassivo;
  double get resumoAtivoPassivo => _resumoAtivoPassivo ?? 0.0;
  set resumoAtivoPassivo(double? val) => _resumoAtivoPassivo = val;

  void incrementResumoAtivoPassivo(double amount) =>
      resumoAtivoPassivo = resumoAtivoPassivo + amount;

  bool hasResumoAtivoPassivo() => _resumoAtivoPassivo != null;

  // "burnRate" field.
  double? _burnRate;
  double get burnRate => _burnRate ?? 0.0;
  set burnRate(double? val) => _burnRate = val;

  void incrementBurnRate(double amount) => burnRate = burnRate + amount;

  bool hasBurnRate() => _burnRate != null;

  // "isAlavancado" field.
  bool? _isAlavancado;
  bool get isAlavancado => _isAlavancado ?? false;
  set isAlavancado(bool? val) => _isAlavancado = val;

  bool hasIsAlavancado() => _isAlavancado != null;

  // "msgAlertaAlavancagem" field.
  String? _msgAlertaAlavancagem;
  String get msgAlertaAlavancagem => _msgAlertaAlavancagem ?? '';
  set msgAlertaAlavancagem(String? val) => _msgAlertaAlavancagem = val;

  bool hasMsgAlertaAlavancagem() => _msgAlertaAlavancagem != null;

  // "msgAlivioCaixa" field.
  String? _msgAlivioCaixa;
  String get msgAlivioCaixa => _msgAlivioCaixa ?? '';
  set msgAlivioCaixa(String? val) => _msgAlivioCaixa = val;

  bool hasMsgAlivioCaixa() => _msgAlivioCaixa != null;

  // "isCaixaComprometido" field.
  bool? _isCaixaComprometido;
  bool get isCaixaComprometido => _isCaixaComprometido ?? false;
  set isCaixaComprometido(bool? val) => _isCaixaComprometido = val;

  bool hasIsCaixaComprometido() => _isCaixaComprometido != null;

  // "msgAlertaRetencao" field.
  String? _msgAlertaRetencao;
  String get msgAlertaRetencao => _msgAlertaRetencao ?? '';
  set msgAlertaRetencao(String? val) => _msgAlertaRetencao = val;

  bool hasMsgAlertaRetencao() => _msgAlertaRetencao != null;

  // "statusSolvencia" field.
  String? _statusSolvencia;
  String get statusSolvencia => _statusSolvencia ?? '';
  set statusSolvencia(String? val) => _statusSolvencia = val;

  bool hasStatusSolvencia() => _statusSolvencia != null;

  // "msgSolvencia" field.
  String? _msgSolvencia;
  String get msgSolvencia => _msgSolvencia ?? '';
  set msgSolvencia(String? val) => _msgSolvencia = val;

  bool hasMsgSolvencia() => _msgSolvencia != null;

  // "isInsolvente" field.
  bool? _isInsolvente;
  bool get isInsolvente => _isInsolvente ?? false;
  set isInsolvente(bool? val) => _isInsolvente = val;

  bool hasIsInsolvente() => _isInsolvente != null;

  static DTSaldoTotalOrgStruct fromMap(Map<String, dynamic> data) =>
      DTSaldoTotalOrgStruct(
        totalSaldoInicial: castToType<double>(data['totalSaldoInicial']),
        totalEntradas: castToType<double>(data['totalEntradas']),
        totalSaidas: castToType<double>(data['totalSaidas']),
        saldoLiquidoGeral: castToType<double>(data['saldoLiquidoGeral']),
        saldoDisponivelReal: castToType<double>(data['saldoDisponivelReal']),
        totalFaturasCartao: castToType<double>(data['totalFaturasCartao']),
        totalAReceber: castToType<double>(data['totalAReceber']),
        totalAPagar: castToType<double>(data['totalAPagar']),
        resumoAtivoPassivo: castToType<double>(data['resumoAtivoPassivo']),
        burnRate: castToType<double>(data['burnRate']),
        isAlavancado: data['isAlavancado'] as bool?,
        msgAlertaAlavancagem: data['msgAlertaAlavancagem'] as String?,
        msgAlivioCaixa: data['msgAlivioCaixa'] as String?,
        isCaixaComprometido: data['isCaixaComprometido'] as bool?,
        msgAlertaRetencao: data['msgAlertaRetencao'] as String?,
        statusSolvencia: data['statusSolvencia'] as String?,
        msgSolvencia: data['msgSolvencia'] as String?,
        isInsolvente: data['isInsolvente'] as bool?,
      );

  static DTSaldoTotalOrgStruct? maybeFromMap(dynamic data) => data is Map
      ? DTSaldoTotalOrgStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalSaldoInicial': _totalSaldoInicial,
        'totalEntradas': _totalEntradas,
        'totalSaidas': _totalSaidas,
        'saldoLiquidoGeral': _saldoLiquidoGeral,
        'saldoDisponivelReal': _saldoDisponivelReal,
        'totalFaturasCartao': _totalFaturasCartao,
        'totalAReceber': _totalAReceber,
        'totalAPagar': _totalAPagar,
        'resumoAtivoPassivo': _resumoAtivoPassivo,
        'burnRate': _burnRate,
        'isAlavancado': _isAlavancado,
        'msgAlertaAlavancagem': _msgAlertaAlavancagem,
        'msgAlivioCaixa': _msgAlivioCaixa,
        'isCaixaComprometido': _isCaixaComprometido,
        'msgAlertaRetencao': _msgAlertaRetencao,
        'statusSolvencia': _statusSolvencia,
        'msgSolvencia': _msgSolvencia,
        'isInsolvente': _isInsolvente,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalSaldoInicial': serializeParam(
          _totalSaldoInicial,
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
        'saldoLiquidoGeral': serializeParam(
          _saldoLiquidoGeral,
          ParamType.double,
        ),
        'saldoDisponivelReal': serializeParam(
          _saldoDisponivelReal,
          ParamType.double,
        ),
        'totalFaturasCartao': serializeParam(
          _totalFaturasCartao,
          ParamType.double,
        ),
        'totalAReceber': serializeParam(
          _totalAReceber,
          ParamType.double,
        ),
        'totalAPagar': serializeParam(
          _totalAPagar,
          ParamType.double,
        ),
        'resumoAtivoPassivo': serializeParam(
          _resumoAtivoPassivo,
          ParamType.double,
        ),
        'burnRate': serializeParam(
          _burnRate,
          ParamType.double,
        ),
        'isAlavancado': serializeParam(
          _isAlavancado,
          ParamType.bool,
        ),
        'msgAlertaAlavancagem': serializeParam(
          _msgAlertaAlavancagem,
          ParamType.String,
        ),
        'msgAlivioCaixa': serializeParam(
          _msgAlivioCaixa,
          ParamType.String,
        ),
        'isCaixaComprometido': serializeParam(
          _isCaixaComprometido,
          ParamType.bool,
        ),
        'msgAlertaRetencao': serializeParam(
          _msgAlertaRetencao,
          ParamType.String,
        ),
        'statusSolvencia': serializeParam(
          _statusSolvencia,
          ParamType.String,
        ),
        'msgSolvencia': serializeParam(
          _msgSolvencia,
          ParamType.String,
        ),
        'isInsolvente': serializeParam(
          _isInsolvente,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DTSaldoTotalOrgStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTSaldoTotalOrgStruct(
        totalSaldoInicial: deserializeParam(
          data['totalSaldoInicial'],
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
        saldoLiquidoGeral: deserializeParam(
          data['saldoLiquidoGeral'],
          ParamType.double,
          false,
        ),
        saldoDisponivelReal: deserializeParam(
          data['saldoDisponivelReal'],
          ParamType.double,
          false,
        ),
        totalFaturasCartao: deserializeParam(
          data['totalFaturasCartao'],
          ParamType.double,
          false,
        ),
        totalAReceber: deserializeParam(
          data['totalAReceber'],
          ParamType.double,
          false,
        ),
        totalAPagar: deserializeParam(
          data['totalAPagar'],
          ParamType.double,
          false,
        ),
        resumoAtivoPassivo: deserializeParam(
          data['resumoAtivoPassivo'],
          ParamType.double,
          false,
        ),
        burnRate: deserializeParam(
          data['burnRate'],
          ParamType.double,
          false,
        ),
        isAlavancado: deserializeParam(
          data['isAlavancado'],
          ParamType.bool,
          false,
        ),
        msgAlertaAlavancagem: deserializeParam(
          data['msgAlertaAlavancagem'],
          ParamType.String,
          false,
        ),
        msgAlivioCaixa: deserializeParam(
          data['msgAlivioCaixa'],
          ParamType.String,
          false,
        ),
        isCaixaComprometido: deserializeParam(
          data['isCaixaComprometido'],
          ParamType.bool,
          false,
        ),
        msgAlertaRetencao: deserializeParam(
          data['msgAlertaRetencao'],
          ParamType.String,
          false,
        ),
        statusSolvencia: deserializeParam(
          data['statusSolvencia'],
          ParamType.String,
          false,
        ),
        msgSolvencia: deserializeParam(
          data['msgSolvencia'],
          ParamType.String,
          false,
        ),
        isInsolvente: deserializeParam(
          data['isInsolvente'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DTSaldoTotalOrgStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTSaldoTotalOrgStruct &&
        totalSaldoInicial == other.totalSaldoInicial &&
        totalEntradas == other.totalEntradas &&
        totalSaidas == other.totalSaidas &&
        saldoLiquidoGeral == other.saldoLiquidoGeral &&
        saldoDisponivelReal == other.saldoDisponivelReal &&
        totalFaturasCartao == other.totalFaturasCartao &&
        totalAReceber == other.totalAReceber &&
        totalAPagar == other.totalAPagar &&
        resumoAtivoPassivo == other.resumoAtivoPassivo &&
        burnRate == other.burnRate &&
        isAlavancado == other.isAlavancado &&
        msgAlertaAlavancagem == other.msgAlertaAlavancagem &&
        msgAlivioCaixa == other.msgAlivioCaixa &&
        isCaixaComprometido == other.isCaixaComprometido &&
        msgAlertaRetencao == other.msgAlertaRetencao &&
        statusSolvencia == other.statusSolvencia &&
        msgSolvencia == other.msgSolvencia &&
        isInsolvente == other.isInsolvente;
  }

  @override
  int get hashCode => const ListEquality().hash([
        totalSaldoInicial,
        totalEntradas,
        totalSaidas,
        saldoLiquidoGeral,
        saldoDisponivelReal,
        totalFaturasCartao,
        totalAReceber,
        totalAPagar,
        resumoAtivoPassivo,
        burnRate,
        isAlavancado,
        msgAlertaAlavancagem,
        msgAlivioCaixa,
        isCaixaComprometido,
        msgAlertaRetencao,
        statusSolvencia,
        msgSolvencia,
        isInsolvente
      ]);
}

DTSaldoTotalOrgStruct createDTSaldoTotalOrgStruct({
  double? totalSaldoInicial,
  double? totalEntradas,
  double? totalSaidas,
  double? saldoLiquidoGeral,
  double? saldoDisponivelReal,
  double? totalFaturasCartao,
  double? totalAReceber,
  double? totalAPagar,
  double? resumoAtivoPassivo,
  double? burnRate,
  bool? isAlavancado,
  String? msgAlertaAlavancagem,
  String? msgAlivioCaixa,
  bool? isCaixaComprometido,
  String? msgAlertaRetencao,
  String? statusSolvencia,
  String? msgSolvencia,
  bool? isInsolvente,
}) =>
    DTSaldoTotalOrgStruct(
      totalSaldoInicial: totalSaldoInicial,
      totalEntradas: totalEntradas,
      totalSaidas: totalSaidas,
      saldoLiquidoGeral: saldoLiquidoGeral,
      saldoDisponivelReal: saldoDisponivelReal,
      totalFaturasCartao: totalFaturasCartao,
      totalAReceber: totalAReceber,
      totalAPagar: totalAPagar,
      resumoAtivoPassivo: resumoAtivoPassivo,
      burnRate: burnRate,
      isAlavancado: isAlavancado,
      msgAlertaAlavancagem: msgAlertaAlavancagem,
      msgAlivioCaixa: msgAlivioCaixa,
      isCaixaComprometido: isCaixaComprometido,
      msgAlertaRetencao: msgAlertaRetencao,
      statusSolvencia: statusSolvencia,
      msgSolvencia: msgSolvencia,
      isInsolvente: isInsolvente,
    );
