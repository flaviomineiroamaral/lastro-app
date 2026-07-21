// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTAlertasResumoStruct extends BaseStruct {
  DTAlertasResumoStruct({
    int? qtdVencidas,
    double? valorVencidas,
    int? qtdHoje,
    double? valorHoje,
    int? qtdFaturasCartao,
    double? valorFaturasCartao,
    int? qtdCartoesVencidos,
    double? valorCartoesVencidos,
    int? qtdCartoesHoje,
    double? valorCartoesHoje,
    int? qtdCartoesAVencer,
    double? valorCartoesAVencer,
    DateTime? proximoMelhorDiaCompra,
    double? limiteRestanteTotal,
    List<DTCartaoResumoStruct>? listaCartoes,
  })  : _qtdVencidas = qtdVencidas,
        _valorVencidas = valorVencidas,
        _qtdHoje = qtdHoje,
        _valorHoje = valorHoje,
        _qtdFaturasCartao = qtdFaturasCartao,
        _valorFaturasCartao = valorFaturasCartao,
        _qtdCartoesVencidos = qtdCartoesVencidos,
        _valorCartoesVencidos = valorCartoesVencidos,
        _qtdCartoesHoje = qtdCartoesHoje,
        _valorCartoesHoje = valorCartoesHoje,
        _qtdCartoesAVencer = qtdCartoesAVencer,
        _valorCartoesAVencer = valorCartoesAVencer,
        _proximoMelhorDiaCompra = proximoMelhorDiaCompra,
        _limiteRestanteTotal = limiteRestanteTotal,
        _listaCartoes = listaCartoes;

  // "qtdVencidas" field.
  int? _qtdVencidas;
  int get qtdVencidas => _qtdVencidas ?? 0;
  set qtdVencidas(int? val) => _qtdVencidas = val;

  void incrementQtdVencidas(int amount) => qtdVencidas = qtdVencidas + amount;

  bool hasQtdVencidas() => _qtdVencidas != null;

  // "valorVencidas" field.
  double? _valorVencidas;
  double get valorVencidas => _valorVencidas ?? 0.0;
  set valorVencidas(double? val) => _valorVencidas = val;

  void incrementValorVencidas(double amount) =>
      valorVencidas = valorVencidas + amount;

  bool hasValorVencidas() => _valorVencidas != null;

  // "qtdHoje" field.
  int? _qtdHoje;
  int get qtdHoje => _qtdHoje ?? 0;
  set qtdHoje(int? val) => _qtdHoje = val;

  void incrementQtdHoje(int amount) => qtdHoje = qtdHoje + amount;

  bool hasQtdHoje() => _qtdHoje != null;

  // "valorHoje" field.
  double? _valorHoje;
  double get valorHoje => _valorHoje ?? 0.0;
  set valorHoje(double? val) => _valorHoje = val;

  void incrementValorHoje(double amount) => valorHoje = valorHoje + amount;

  bool hasValorHoje() => _valorHoje != null;

  // "qtdFaturasCartao" field.
  int? _qtdFaturasCartao;
  int get qtdFaturasCartao => _qtdFaturasCartao ?? 0;
  set qtdFaturasCartao(int? val) => _qtdFaturasCartao = val;

  void incrementQtdFaturasCartao(int amount) =>
      qtdFaturasCartao = qtdFaturasCartao + amount;

  bool hasQtdFaturasCartao() => _qtdFaturasCartao != null;

  // "valorFaturasCartao" field.
  double? _valorFaturasCartao;
  double get valorFaturasCartao => _valorFaturasCartao ?? 0.0;
  set valorFaturasCartao(double? val) => _valorFaturasCartao = val;

  void incrementValorFaturasCartao(double amount) =>
      valorFaturasCartao = valorFaturasCartao + amount;

  bool hasValorFaturasCartao() => _valorFaturasCartao != null;

  // "qtdCartoesVencidos" field.
  int? _qtdCartoesVencidos;
  int get qtdCartoesVencidos => _qtdCartoesVencidos ?? 0;
  set qtdCartoesVencidos(int? val) => _qtdCartoesVencidos = val;

  void incrementQtdCartoesVencidos(int amount) =>
      qtdCartoesVencidos = qtdCartoesVencidos + amount;

  bool hasQtdCartoesVencidos() => _qtdCartoesVencidos != null;

  // "valorCartoesVencidos" field.
  double? _valorCartoesVencidos;
  double get valorCartoesVencidos => _valorCartoesVencidos ?? 0.0;
  set valorCartoesVencidos(double? val) => _valorCartoesVencidos = val;

  void incrementValorCartoesVencidos(double amount) =>
      valorCartoesVencidos = valorCartoesVencidos + amount;

  bool hasValorCartoesVencidos() => _valorCartoesVencidos != null;

  // "qtdCartoesHoje" field.
  int? _qtdCartoesHoje;
  int get qtdCartoesHoje => _qtdCartoesHoje ?? 0;
  set qtdCartoesHoje(int? val) => _qtdCartoesHoje = val;

  void incrementQtdCartoesHoje(int amount) =>
      qtdCartoesHoje = qtdCartoesHoje + amount;

  bool hasQtdCartoesHoje() => _qtdCartoesHoje != null;

  // "valorCartoesHoje" field.
  double? _valorCartoesHoje;
  double get valorCartoesHoje => _valorCartoesHoje ?? 0.0;
  set valorCartoesHoje(double? val) => _valorCartoesHoje = val;

  void incrementValorCartoesHoje(double amount) =>
      valorCartoesHoje = valorCartoesHoje + amount;

  bool hasValorCartoesHoje() => _valorCartoesHoje != null;

  // "qtdCartoesAVencer" field.
  int? _qtdCartoesAVencer;
  int get qtdCartoesAVencer => _qtdCartoesAVencer ?? 0;
  set qtdCartoesAVencer(int? val) => _qtdCartoesAVencer = val;

  void incrementQtdCartoesAVencer(int amount) =>
      qtdCartoesAVencer = qtdCartoesAVencer + amount;

  bool hasQtdCartoesAVencer() => _qtdCartoesAVencer != null;

  // "valorCartoesAVencer" field.
  double? _valorCartoesAVencer;
  double get valorCartoesAVencer => _valorCartoesAVencer ?? 0.0;
  set valorCartoesAVencer(double? val) => _valorCartoesAVencer = val;

  void incrementValorCartoesAVencer(double amount) =>
      valorCartoesAVencer = valorCartoesAVencer + amount;

  bool hasValorCartoesAVencer() => _valorCartoesAVencer != null;

  // "proximoMelhorDiaCompra" field.
  DateTime? _proximoMelhorDiaCompra;
  DateTime? get proximoMelhorDiaCompra => _proximoMelhorDiaCompra;
  set proximoMelhorDiaCompra(DateTime? val) => _proximoMelhorDiaCompra = val;

  bool hasProximoMelhorDiaCompra() => _proximoMelhorDiaCompra != null;

  // "limiteRestanteTotal" field.
  double? _limiteRestanteTotal;
  double get limiteRestanteTotal => _limiteRestanteTotal ?? 0.0;
  set limiteRestanteTotal(double? val) => _limiteRestanteTotal = val;

  void incrementLimiteRestanteTotal(double amount) =>
      limiteRestanteTotal = limiteRestanteTotal + amount;

  bool hasLimiteRestanteTotal() => _limiteRestanteTotal != null;

  // "listaCartoes" field.
  List<DTCartaoResumoStruct>? _listaCartoes;
  List<DTCartaoResumoStruct> get listaCartoes => _listaCartoes ?? const [];
  set listaCartoes(List<DTCartaoResumoStruct>? val) => _listaCartoes = val;

  void updateListaCartoes(Function(List<DTCartaoResumoStruct>) updateFn) {
    updateFn(_listaCartoes ??= []);
  }

  bool hasListaCartoes() => _listaCartoes != null;

  static DTAlertasResumoStruct fromMap(Map<String, dynamic> data) =>
      DTAlertasResumoStruct(
        qtdVencidas: castToType<int>(data['qtdVencidas']),
        valorVencidas: castToType<double>(data['valorVencidas']),
        qtdHoje: castToType<int>(data['qtdHoje']),
        valorHoje: castToType<double>(data['valorHoje']),
        qtdFaturasCartao: castToType<int>(data['qtdFaturasCartao']),
        valorFaturasCartao: castToType<double>(data['valorFaturasCartao']),
        qtdCartoesVencidos: castToType<int>(data['qtdCartoesVencidos']),
        valorCartoesVencidos: castToType<double>(data['valorCartoesVencidos']),
        qtdCartoesHoje: castToType<int>(data['qtdCartoesHoje']),
        valorCartoesHoje: castToType<double>(data['valorCartoesHoje']),
        qtdCartoesAVencer: castToType<int>(data['qtdCartoesAVencer']),
        valorCartoesAVencer: castToType<double>(data['valorCartoesAVencer']),
        proximoMelhorDiaCompra: data['proximoMelhorDiaCompra'] as DateTime?,
        limiteRestanteTotal: castToType<double>(data['limiteRestanteTotal']),
        listaCartoes: getStructList(
          data['listaCartoes'],
          DTCartaoResumoStruct.fromMap,
        ),
      );

  static DTAlertasResumoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTAlertasResumoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'qtdVencidas': _qtdVencidas,
        'valorVencidas': _valorVencidas,
        'qtdHoje': _qtdHoje,
        'valorHoje': _valorHoje,
        'qtdFaturasCartao': _qtdFaturasCartao,
        'valorFaturasCartao': _valorFaturasCartao,
        'qtdCartoesVencidos': _qtdCartoesVencidos,
        'valorCartoesVencidos': _valorCartoesVencidos,
        'qtdCartoesHoje': _qtdCartoesHoje,
        'valorCartoesHoje': _valorCartoesHoje,
        'qtdCartoesAVencer': _qtdCartoesAVencer,
        'valorCartoesAVencer': _valorCartoesAVencer,
        'proximoMelhorDiaCompra': _proximoMelhorDiaCompra,
        'limiteRestanteTotal': _limiteRestanteTotal,
        'listaCartoes': _listaCartoes?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'qtdVencidas': serializeParam(
          _qtdVencidas,
          ParamType.int,
        ),
        'valorVencidas': serializeParam(
          _valorVencidas,
          ParamType.double,
        ),
        'qtdHoje': serializeParam(
          _qtdHoje,
          ParamType.int,
        ),
        'valorHoje': serializeParam(
          _valorHoje,
          ParamType.double,
        ),
        'qtdFaturasCartao': serializeParam(
          _qtdFaturasCartao,
          ParamType.int,
        ),
        'valorFaturasCartao': serializeParam(
          _valorFaturasCartao,
          ParamType.double,
        ),
        'qtdCartoesVencidos': serializeParam(
          _qtdCartoesVencidos,
          ParamType.int,
        ),
        'valorCartoesVencidos': serializeParam(
          _valorCartoesVencidos,
          ParamType.double,
        ),
        'qtdCartoesHoje': serializeParam(
          _qtdCartoesHoje,
          ParamType.int,
        ),
        'valorCartoesHoje': serializeParam(
          _valorCartoesHoje,
          ParamType.double,
        ),
        'qtdCartoesAVencer': serializeParam(
          _qtdCartoesAVencer,
          ParamType.int,
        ),
        'valorCartoesAVencer': serializeParam(
          _valorCartoesAVencer,
          ParamType.double,
        ),
        'proximoMelhorDiaCompra': serializeParam(
          _proximoMelhorDiaCompra,
          ParamType.DateTime,
        ),
        'limiteRestanteTotal': serializeParam(
          _limiteRestanteTotal,
          ParamType.double,
        ),
        'listaCartoes': serializeParam(
          _listaCartoes,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static DTAlertasResumoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTAlertasResumoStruct(
        qtdVencidas: deserializeParam(
          data['qtdVencidas'],
          ParamType.int,
          false,
        ),
        valorVencidas: deserializeParam(
          data['valorVencidas'],
          ParamType.double,
          false,
        ),
        qtdHoje: deserializeParam(
          data['qtdHoje'],
          ParamType.int,
          false,
        ),
        valorHoje: deserializeParam(
          data['valorHoje'],
          ParamType.double,
          false,
        ),
        qtdFaturasCartao: deserializeParam(
          data['qtdFaturasCartao'],
          ParamType.int,
          false,
        ),
        valorFaturasCartao: deserializeParam(
          data['valorFaturasCartao'],
          ParamType.double,
          false,
        ),
        qtdCartoesVencidos: deserializeParam(
          data['qtdCartoesVencidos'],
          ParamType.int,
          false,
        ),
        valorCartoesVencidos: deserializeParam(
          data['valorCartoesVencidos'],
          ParamType.double,
          false,
        ),
        qtdCartoesHoje: deserializeParam(
          data['qtdCartoesHoje'],
          ParamType.int,
          false,
        ),
        valorCartoesHoje: deserializeParam(
          data['valorCartoesHoje'],
          ParamType.double,
          false,
        ),
        qtdCartoesAVencer: deserializeParam(
          data['qtdCartoesAVencer'],
          ParamType.int,
          false,
        ),
        valorCartoesAVencer: deserializeParam(
          data['valorCartoesAVencer'],
          ParamType.double,
          false,
        ),
        proximoMelhorDiaCompra: deserializeParam(
          data['proximoMelhorDiaCompra'],
          ParamType.DateTime,
          false,
        ),
        limiteRestanteTotal: deserializeParam(
          data['limiteRestanteTotal'],
          ParamType.double,
          false,
        ),
        listaCartoes: deserializeStructParam<DTCartaoResumoStruct>(
          data['listaCartoes'],
          ParamType.DataStruct,
          true,
          structBuilder: DTCartaoResumoStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'DTAlertasResumoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is DTAlertasResumoStruct &&
        qtdVencidas == other.qtdVencidas &&
        valorVencidas == other.valorVencidas &&
        qtdHoje == other.qtdHoje &&
        valorHoje == other.valorHoje &&
        qtdFaturasCartao == other.qtdFaturasCartao &&
        valorFaturasCartao == other.valorFaturasCartao &&
        qtdCartoesVencidos == other.qtdCartoesVencidos &&
        valorCartoesVencidos == other.valorCartoesVencidos &&
        qtdCartoesHoje == other.qtdCartoesHoje &&
        valorCartoesHoje == other.valorCartoesHoje &&
        qtdCartoesAVencer == other.qtdCartoesAVencer &&
        valorCartoesAVencer == other.valorCartoesAVencer &&
        proximoMelhorDiaCompra == other.proximoMelhorDiaCompra &&
        limiteRestanteTotal == other.limiteRestanteTotal &&
        listEquality.equals(listaCartoes, other.listaCartoes);
  }

  @override
  int get hashCode => const ListEquality().hash([
        qtdVencidas,
        valorVencidas,
        qtdHoje,
        valorHoje,
        qtdFaturasCartao,
        valorFaturasCartao,
        qtdCartoesVencidos,
        valorCartoesVencidos,
        qtdCartoesHoje,
        valorCartoesHoje,
        qtdCartoesAVencer,
        valorCartoesAVencer,
        proximoMelhorDiaCompra,
        limiteRestanteTotal,
        listaCartoes
      ]);
}

DTAlertasResumoStruct createDTAlertasResumoStruct({
  int? qtdVencidas,
  double? valorVencidas,
  int? qtdHoje,
  double? valorHoje,
  int? qtdFaturasCartao,
  double? valorFaturasCartao,
  int? qtdCartoesVencidos,
  double? valorCartoesVencidos,
  int? qtdCartoesHoje,
  double? valorCartoesHoje,
  int? qtdCartoesAVencer,
  double? valorCartoesAVencer,
  DateTime? proximoMelhorDiaCompra,
  double? limiteRestanteTotal,
}) =>
    DTAlertasResumoStruct(
      qtdVencidas: qtdVencidas,
      valorVencidas: valorVencidas,
      qtdHoje: qtdHoje,
      valorHoje: valorHoje,
      qtdFaturasCartao: qtdFaturasCartao,
      valorFaturasCartao: valorFaturasCartao,
      qtdCartoesVencidos: qtdCartoesVencidos,
      valorCartoesVencidos: valorCartoesVencidos,
      qtdCartoesHoje: qtdCartoesHoje,
      valorCartoesHoje: valorCartoesHoje,
      qtdCartoesAVencer: qtdCartoesAVencer,
      valorCartoesAVencer: valorCartoesAVencer,
      proximoMelhorDiaCompra: proximoMelhorDiaCompra,
      limiteRestanteTotal: limiteRestanteTotal,
    );
