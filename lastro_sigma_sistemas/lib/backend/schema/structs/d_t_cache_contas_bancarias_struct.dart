// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTCacheContasBancariasStruct extends BaseStruct {
  DTCacheContasBancariasStruct({
    String? id,
    String? nome,
    String? tipo,
    String? bancoCodigo,
    String? agenciaConta,
    double? saldoInicial,
    bool? ativo,
    double? limiteCredito,
    int? diaVencimento,
    int? diaFechamento,
  })  : _id = id,
        _nome = nome,
        _tipo = tipo,
        _bancoCodigo = bancoCodigo,
        _agenciaConta = agenciaConta,
        _saldoInicial = saldoInicial,
        _ativo = ativo,
        _limiteCredito = limiteCredito,
        _diaVencimento = diaVencimento,
        _diaFechamento = diaFechamento;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "tipo" field.
  String? _tipo;
  String get tipo => _tipo ?? '';
  set tipo(String? val) => _tipo = val;

  bool hasTipo() => _tipo != null;

  // "bancoCodigo" field.
  String? _bancoCodigo;
  String get bancoCodigo => _bancoCodigo ?? '';
  set bancoCodigo(String? val) => _bancoCodigo = val;

  bool hasBancoCodigo() => _bancoCodigo != null;

  // "agenciaConta" field.
  String? _agenciaConta;
  String get agenciaConta => _agenciaConta ?? '';
  set agenciaConta(String? val) => _agenciaConta = val;

  bool hasAgenciaConta() => _agenciaConta != null;

  // "saldoInicial" field.
  double? _saldoInicial;
  double get saldoInicial => _saldoInicial ?? 0.0;
  set saldoInicial(double? val) => _saldoInicial = val;

  void incrementSaldoInicial(double amount) =>
      saldoInicial = saldoInicial + amount;

  bool hasSaldoInicial() => _saldoInicial != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? false;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  // "limiteCredito" field.
  double? _limiteCredito;
  double get limiteCredito => _limiteCredito ?? 0.0;
  set limiteCredito(double? val) => _limiteCredito = val;

  void incrementLimiteCredito(double amount) =>
      limiteCredito = limiteCredito + amount;

  bool hasLimiteCredito() => _limiteCredito != null;

  // "diaVencimento" field.
  int? _diaVencimento;
  int get diaVencimento => _diaVencimento ?? 0;
  set diaVencimento(int? val) => _diaVencimento = val;

  void incrementDiaVencimento(int amount) =>
      diaVencimento = diaVencimento + amount;

  bool hasDiaVencimento() => _diaVencimento != null;

  // "diaFechamento" field.
  int? _diaFechamento;
  int get diaFechamento => _diaFechamento ?? 0;
  set diaFechamento(int? val) => _diaFechamento = val;

  void incrementDiaFechamento(int amount) =>
      diaFechamento = diaFechamento + amount;

  bool hasDiaFechamento() => _diaFechamento != null;

  static DTCacheContasBancariasStruct fromMap(Map<String, dynamic> data) =>
      DTCacheContasBancariasStruct(
        id: data['id'] as String?,
        nome: data['nome'] as String?,
        tipo: data['tipo'] as String?,
        bancoCodigo: data['bancoCodigo'] as String?,
        agenciaConta: data['agenciaConta'] as String?,
        saldoInicial: castToType<double>(data['saldoInicial']),
        ativo: data['ativo'] as bool?,
        limiteCredito: castToType<double>(data['limiteCredito']),
        diaVencimento: castToType<int>(data['diaVencimento']),
        diaFechamento: castToType<int>(data['diaFechamento']),
      );

  static DTCacheContasBancariasStruct? maybeFromMap(dynamic data) => data is Map
      ? DTCacheContasBancariasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nome': _nome,
        'tipo': _tipo,
        'bancoCodigo': _bancoCodigo,
        'agenciaConta': _agenciaConta,
        'saldoInicial': _saldoInicial,
        'ativo': _ativo,
        'limiteCredito': _limiteCredito,
        'diaVencimento': _diaVencimento,
        'diaFechamento': _diaFechamento,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'tipo': serializeParam(
          _tipo,
          ParamType.String,
        ),
        'bancoCodigo': serializeParam(
          _bancoCodigo,
          ParamType.String,
        ),
        'agenciaConta': serializeParam(
          _agenciaConta,
          ParamType.String,
        ),
        'saldoInicial': serializeParam(
          _saldoInicial,
          ParamType.double,
        ),
        'ativo': serializeParam(
          _ativo,
          ParamType.bool,
        ),
        'limiteCredito': serializeParam(
          _limiteCredito,
          ParamType.double,
        ),
        'diaVencimento': serializeParam(
          _diaVencimento,
          ParamType.int,
        ),
        'diaFechamento': serializeParam(
          _diaFechamento,
          ParamType.int,
        ),
      }.withoutNulls;

  static DTCacheContasBancariasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTCacheContasBancariasStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        tipo: deserializeParam(
          data['tipo'],
          ParamType.String,
          false,
        ),
        bancoCodigo: deserializeParam(
          data['bancoCodigo'],
          ParamType.String,
          false,
        ),
        agenciaConta: deserializeParam(
          data['agenciaConta'],
          ParamType.String,
          false,
        ),
        saldoInicial: deserializeParam(
          data['saldoInicial'],
          ParamType.double,
          false,
        ),
        ativo: deserializeParam(
          data['ativo'],
          ParamType.bool,
          false,
        ),
        limiteCredito: deserializeParam(
          data['limiteCredito'],
          ParamType.double,
          false,
        ),
        diaVencimento: deserializeParam(
          data['diaVencimento'],
          ParamType.int,
          false,
        ),
        diaFechamento: deserializeParam(
          data['diaFechamento'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DTCacheContasBancariasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTCacheContasBancariasStruct &&
        id == other.id &&
        nome == other.nome &&
        tipo == other.tipo &&
        bancoCodigo == other.bancoCodigo &&
        agenciaConta == other.agenciaConta &&
        saldoInicial == other.saldoInicial &&
        ativo == other.ativo &&
        limiteCredito == other.limiteCredito &&
        diaVencimento == other.diaVencimento &&
        diaFechamento == other.diaFechamento;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        nome,
        tipo,
        bancoCodigo,
        agenciaConta,
        saldoInicial,
        ativo,
        limiteCredito,
        diaVencimento,
        diaFechamento
      ]);
}

DTCacheContasBancariasStruct createDTCacheContasBancariasStruct({
  String? id,
  String? nome,
  String? tipo,
  String? bancoCodigo,
  String? agenciaConta,
  double? saldoInicial,
  bool? ativo,
  double? limiteCredito,
  int? diaVencimento,
  int? diaFechamento,
}) =>
    DTCacheContasBancariasStruct(
      id: id,
      nome: nome,
      tipo: tipo,
      bancoCodigo: bancoCodigo,
      agenciaConta: agenciaConta,
      saldoInicial: saldoInicial,
      ativo: ativo,
      limiteCredito: limiteCredito,
      diaVencimento: diaVencimento,
      diaFechamento: diaFechamento,
    );
