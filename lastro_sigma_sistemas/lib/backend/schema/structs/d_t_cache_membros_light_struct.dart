// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTCacheMembrosLightStruct extends BaseStruct {
  DTCacheMembrosLightStruct({
    String? id,
    String? nomeCompleto,
    bool? ativo,
  })  : _id = id,
        _nomeCompleto = nomeCompleto,
        _ativo = ativo;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "nomeCompleto" field.
  String? _nomeCompleto;
  String get nomeCompleto => _nomeCompleto ?? '';
  set nomeCompleto(String? val) => _nomeCompleto = val;

  bool hasNomeCompleto() => _nomeCompleto != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? false;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  static DTCacheMembrosLightStruct fromMap(Map<String, dynamic> data) =>
      DTCacheMembrosLightStruct(
        id: data['id'] as String?,
        nomeCompleto: data['nomeCompleto'] as String?,
        ativo: data['ativo'] as bool?,
      );

  static DTCacheMembrosLightStruct? maybeFromMap(dynamic data) => data is Map
      ? DTCacheMembrosLightStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nomeCompleto': _nomeCompleto,
        'ativo': _ativo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'nomeCompleto': serializeParam(
          _nomeCompleto,
          ParamType.String,
        ),
        'ativo': serializeParam(
          _ativo,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DTCacheMembrosLightStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTCacheMembrosLightStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        nomeCompleto: deserializeParam(
          data['nomeCompleto'],
          ParamType.String,
          false,
        ),
        ativo: deserializeParam(
          data['ativo'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DTCacheMembrosLightStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTCacheMembrosLightStruct &&
        id == other.id &&
        nomeCompleto == other.nomeCompleto &&
        ativo == other.ativo;
  }

  @override
  int get hashCode => const ListEquality().hash([id, nomeCompleto, ativo]);
}

DTCacheMembrosLightStruct createDTCacheMembrosLightStruct({
  String? id,
  String? nomeCompleto,
  bool? ativo,
}) =>
    DTCacheMembrosLightStruct(
      id: id,
      nomeCompleto: nomeCompleto,
      ativo: ativo,
    );
