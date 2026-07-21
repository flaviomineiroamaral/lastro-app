// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTCartaoResumoStruct extends BaseStruct {
  DTCartaoResumoStruct({
    String? idCartao,
    String? nome,
    double? limiteTotal,
    double? limiteRestante,
    DateTime? melhorDiaCompra,
  })  : _idCartao = idCartao,
        _nome = nome,
        _limiteTotal = limiteTotal,
        _limiteRestante = limiteRestante,
        _melhorDiaCompra = melhorDiaCompra;

  // "idCartao" field.
  String? _idCartao;
  String get idCartao => _idCartao ?? '';
  set idCartao(String? val) => _idCartao = val;

  bool hasIdCartao() => _idCartao != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "limiteTotal" field.
  double? _limiteTotal;
  double get limiteTotal => _limiteTotal ?? 0.0;
  set limiteTotal(double? val) => _limiteTotal = val;

  void incrementLimiteTotal(double amount) =>
      limiteTotal = limiteTotal + amount;

  bool hasLimiteTotal() => _limiteTotal != null;

  // "limiteRestante" field.
  double? _limiteRestante;
  double get limiteRestante => _limiteRestante ?? 0.0;
  set limiteRestante(double? val) => _limiteRestante = val;

  void incrementLimiteRestante(double amount) =>
      limiteRestante = limiteRestante + amount;

  bool hasLimiteRestante() => _limiteRestante != null;

  // "melhorDiaCompra" field.
  DateTime? _melhorDiaCompra;
  DateTime? get melhorDiaCompra => _melhorDiaCompra;
  set melhorDiaCompra(DateTime? val) => _melhorDiaCompra = val;

  bool hasMelhorDiaCompra() => _melhorDiaCompra != null;

  static DTCartaoResumoStruct fromMap(Map<String, dynamic> data) =>
      DTCartaoResumoStruct(
        idCartao: data['idCartao'] as String?,
        nome: data['nome'] as String?,
        limiteTotal: castToType<double>(data['limiteTotal']),
        limiteRestante: castToType<double>(data['limiteRestante']),
        melhorDiaCompra: data['melhorDiaCompra'] as DateTime?,
      );

  static DTCartaoResumoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTCartaoResumoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'idCartao': _idCartao,
        'nome': _nome,
        'limiteTotal': _limiteTotal,
        'limiteRestante': _limiteRestante,
        'melhorDiaCompra': _melhorDiaCompra,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'idCartao': serializeParam(
          _idCartao,
          ParamType.String,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'limiteTotal': serializeParam(
          _limiteTotal,
          ParamType.double,
        ),
        'limiteRestante': serializeParam(
          _limiteRestante,
          ParamType.double,
        ),
        'melhorDiaCompra': serializeParam(
          _melhorDiaCompra,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static DTCartaoResumoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTCartaoResumoStruct(
        idCartao: deserializeParam(
          data['idCartao'],
          ParamType.String,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        limiteTotal: deserializeParam(
          data['limiteTotal'],
          ParamType.double,
          false,
        ),
        limiteRestante: deserializeParam(
          data['limiteRestante'],
          ParamType.double,
          false,
        ),
        melhorDiaCompra: deserializeParam(
          data['melhorDiaCompra'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'DTCartaoResumoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTCartaoResumoStruct &&
        idCartao == other.idCartao &&
        nome == other.nome &&
        limiteTotal == other.limiteTotal &&
        limiteRestante == other.limiteRestante &&
        melhorDiaCompra == other.melhorDiaCompra;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([idCartao, nome, limiteTotal, limiteRestante, melhorDiaCompra]);
}

DTCartaoResumoStruct createDTCartaoResumoStruct({
  String? idCartao,
  String? nome,
  double? limiteTotal,
  double? limiteRestante,
  DateTime? melhorDiaCompra,
}) =>
    DTCartaoResumoStruct(
      idCartao: idCartao,
      nome: nome,
      limiteTotal: limiteTotal,
      limiteRestante: limiteRestante,
      melhorDiaCompra: melhorDiaCompra,
    );
