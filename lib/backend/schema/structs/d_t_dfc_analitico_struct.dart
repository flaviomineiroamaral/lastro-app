// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTDfcAnaliticoStruct extends BaseStruct {
  DTDfcAnaliticoStruct({
    int? ordem,
    String? tipoLinha,
    String? descricao,
    double? entradas,
    double? saidas,
    double? saldo,
    String? contaId,
    String? contaCodigo,
    String? contaNome,
    String? contaTipo,
  })  : _ordem = ordem,
        _tipoLinha = tipoLinha,
        _descricao = descricao,
        _entradas = entradas,
        _saidas = saidas,
        _saldo = saldo,
        _contaId = contaId,
        _contaCodigo = contaCodigo,
        _contaNome = contaNome,
        _contaTipo = contaTipo;

  // "ordem" field.
  int? _ordem;
  int get ordem => _ordem ?? 0;
  set ordem(int? val) => _ordem = val;

  void incrementOrdem(int amount) => ordem = ordem + amount;

  bool hasOrdem() => _ordem != null;

  // "tipoLinha" field.
  String? _tipoLinha;
  String get tipoLinha => _tipoLinha ?? '';
  set tipoLinha(String? val) => _tipoLinha = val;

  bool hasTipoLinha() => _tipoLinha != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "entradas" field.
  double? _entradas;
  double get entradas => _entradas ?? 0.0;
  set entradas(double? val) => _entradas = val;

  void incrementEntradas(double amount) => entradas = entradas + amount;

  bool hasEntradas() => _entradas != null;

  // "saidas" field.
  double? _saidas;
  double get saidas => _saidas ?? 0.0;
  set saidas(double? val) => _saidas = val;

  void incrementSaidas(double amount) => saidas = saidas + amount;

  bool hasSaidas() => _saidas != null;

  // "saldo" field.
  double? _saldo;
  double get saldo => _saldo ?? 0.0;
  set saldo(double? val) => _saldo = val;

  void incrementSaldo(double amount) => saldo = saldo + amount;

  bool hasSaldo() => _saldo != null;

  // "contaId" field.
  String? _contaId;
  String get contaId => _contaId ?? '';
  set contaId(String? val) => _contaId = val;

  bool hasContaId() => _contaId != null;

  // "contaCodigo" field.
  String? _contaCodigo;
  String get contaCodigo => _contaCodigo ?? '';
  set contaCodigo(String? val) => _contaCodigo = val;

  bool hasContaCodigo() => _contaCodigo != null;

  // "contaNome" field.
  String? _contaNome;
  String get contaNome => _contaNome ?? '';
  set contaNome(String? val) => _contaNome = val;

  bool hasContaNome() => _contaNome != null;

  // "contaTipo" field.
  String? _contaTipo;
  String get contaTipo => _contaTipo ?? '';
  set contaTipo(String? val) => _contaTipo = val;

  bool hasContaTipo() => _contaTipo != null;

  static DTDfcAnaliticoStruct fromMap(Map<String, dynamic> data) =>
      DTDfcAnaliticoStruct(
        ordem: castToType<int>(data['ordem']),
        tipoLinha: data['tipoLinha'] as String?,
        descricao: data['descricao'] as String?,
        entradas: castToType<double>(data['entradas']),
        saidas: castToType<double>(data['saidas']),
        saldo: castToType<double>(data['saldo']),
        contaId: data['contaId'] as String?,
        contaCodigo: data['contaCodigo'] as String?,
        contaNome: data['contaNome'] as String?,
        contaTipo: data['contaTipo'] as String?,
      );

  static DTDfcAnaliticoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTDfcAnaliticoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'ordem': _ordem,
        'tipoLinha': _tipoLinha,
        'descricao': _descricao,
        'entradas': _entradas,
        'saidas': _saidas,
        'saldo': _saldo,
        'contaId': _contaId,
        'contaCodigo': _contaCodigo,
        'contaNome': _contaNome,
        'contaTipo': _contaTipo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ordem': serializeParam(
          _ordem,
          ParamType.int,
        ),
        'tipoLinha': serializeParam(
          _tipoLinha,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'entradas': serializeParam(
          _entradas,
          ParamType.double,
        ),
        'saidas': serializeParam(
          _saidas,
          ParamType.double,
        ),
        'saldo': serializeParam(
          _saldo,
          ParamType.double,
        ),
        'contaId': serializeParam(
          _contaId,
          ParamType.String,
        ),
        'contaCodigo': serializeParam(
          _contaCodigo,
          ParamType.String,
        ),
        'contaNome': serializeParam(
          _contaNome,
          ParamType.String,
        ),
        'contaTipo': serializeParam(
          _contaTipo,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTDfcAnaliticoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTDfcAnaliticoStruct(
        ordem: deserializeParam(
          data['ordem'],
          ParamType.int,
          false,
        ),
        tipoLinha: deserializeParam(
          data['tipoLinha'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        entradas: deserializeParam(
          data['entradas'],
          ParamType.double,
          false,
        ),
        saidas: deserializeParam(
          data['saidas'],
          ParamType.double,
          false,
        ),
        saldo: deserializeParam(
          data['saldo'],
          ParamType.double,
          false,
        ),
        contaId: deserializeParam(
          data['contaId'],
          ParamType.String,
          false,
        ),
        contaCodigo: deserializeParam(
          data['contaCodigo'],
          ParamType.String,
          false,
        ),
        contaNome: deserializeParam(
          data['contaNome'],
          ParamType.String,
          false,
        ),
        contaTipo: deserializeParam(
          data['contaTipo'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTDfcAnaliticoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTDfcAnaliticoStruct &&
        ordem == other.ordem &&
        tipoLinha == other.tipoLinha &&
        descricao == other.descricao &&
        entradas == other.entradas &&
        saidas == other.saidas &&
        saldo == other.saldo &&
        contaId == other.contaId &&
        contaCodigo == other.contaCodigo &&
        contaNome == other.contaNome &&
        contaTipo == other.contaTipo;
  }

  @override
  int get hashCode => const ListEquality().hash([
        ordem,
        tipoLinha,
        descricao,
        entradas,
        saidas,
        saldo,
        contaId,
        contaCodigo,
        contaNome,
        contaTipo
      ]);
}

DTDfcAnaliticoStruct createDTDfcAnaliticoStruct({
  int? ordem,
  String? tipoLinha,
  String? descricao,
  double? entradas,
  double? saidas,
  double? saldo,
  String? contaId,
  String? contaCodigo,
  String? contaNome,
  String? contaTipo,
}) =>
    DTDfcAnaliticoStruct(
      ordem: ordem,
      tipoLinha: tipoLinha,
      descricao: descricao,
      entradas: entradas,
      saidas: saidas,
      saldo: saldo,
      contaId: contaId,
      contaCodigo: contaCodigo,
      contaNome: contaNome,
      contaTipo: contaTipo,
    );
