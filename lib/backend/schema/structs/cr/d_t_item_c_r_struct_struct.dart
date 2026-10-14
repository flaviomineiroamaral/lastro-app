// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTItemCRStructStruct extends BaseStruct {
  DTItemCRStructStruct({
    String? nome,
    double? saldo,
    String? listaOfensores,
  })  : _nome = nome,
        _saldo = saldo,
        _listaOfensores = listaOfensores;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "saldo" field.
  double? _saldo;
  double get saldo => _saldo ?? 0.0;
  set saldo(double? val) => _saldo = val;

  void incrementSaldo(double amount) => saldo = saldo + amount;

  bool hasSaldo() => _saldo != null;

  // "lista_ofensores" field.
  String? _listaOfensores;
  String get listaOfensores => _listaOfensores ?? '';
  set listaOfensores(String? val) => _listaOfensores = val;

  bool hasListaOfensores() => _listaOfensores != null;

  static DTItemCRStructStruct fromMap(Map<String, dynamic> data) =>
      DTItemCRStructStruct(
        nome: data['nome'] as String?,
        saldo: castToType<double>(data['saldo']),
        listaOfensores: data['lista_ofensores'] as String?,
      );

  static DTItemCRStructStruct? maybeFromMap(dynamic data) => data is Map
      ? DTItemCRStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'nome': _nome,
        'saldo': _saldo,
        'lista_ofensores': _listaOfensores,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'saldo': serializeParam(
          _saldo,
          ParamType.double,
        ),
        'lista_ofensores': serializeParam(
          _listaOfensores,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTItemCRStructStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTItemCRStructStruct(
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        saldo: deserializeParam(
          data['saldo'],
          ParamType.double,
          false,
        ),
        listaOfensores: deserializeParam(
          data['lista_ofensores'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTItemCRStructStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTItemCRStructStruct &&
        nome == other.nome &&
        saldo == other.saldo &&
        listaOfensores == other.listaOfensores;
  }

  @override
  int get hashCode => const ListEquality().hash([nome, saldo, listaOfensores]);
}

DTItemCRStructStruct createDTItemCRStructStruct({
  String? nome,
  double? saldo,
  String? listaOfensores,
}) =>
    DTItemCRStructStruct(
      nome: nome,
      saldo: saldo,
      listaOfensores: listaOfensores,
    );
