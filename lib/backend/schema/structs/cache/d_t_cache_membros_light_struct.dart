// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTCacheMembrosLightStruct extends BaseStruct {
  DTCacheMembrosLightStruct({
    String? id,
    String? nomeCompleto,
    String? cpf,
    String? email,
    String? telefone,
    bool? ativo,
  })  : _id = id,
        _nomeCompleto = nomeCompleto,
        _cpf = cpf,
        _email = email,
        _telefone = telefone,
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

  // "cpf" field.
  String? _cpf;
  String get cpf => _cpf ?? '';
  set cpf(String? val) => _cpf = val;

  bool hasCpf() => _cpf != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "telefone" field.
  String? _telefone;
  String get telefone => _telefone ?? '';
  set telefone(String? val) => _telefone = val;

  bool hasTelefone() => _telefone != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? false;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  static DTCacheMembrosLightStruct fromMap(Map<String, dynamic> data) =>
      DTCacheMembrosLightStruct(
        id: data['id'] as String?,
        nomeCompleto: data['nomeCompleto'] as String?,
        cpf: data['cpf'] as String?,
        email: data['email'] as String?,
        telefone: data['telefone'] as String?,
        ativo: data['ativo'] as bool?,
      );

  static DTCacheMembrosLightStruct? maybeFromMap(dynamic data) => data is Map
      ? DTCacheMembrosLightStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nomeCompleto': _nomeCompleto,
        'cpf': _cpf,
        'email': _email,
        'telefone': _telefone,
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
        'cpf': serializeParam(
          _cpf,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'telefone': serializeParam(
          _telefone,
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
        cpf: deserializeParam(
          data['cpf'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        telefone: deserializeParam(
          data['telefone'],
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
        cpf == other.cpf &&
        email == other.email &&
        telefone == other.telefone &&
        ativo == other.ativo;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, nomeCompleto, cpf, email, telefone, ativo]);
}

DTCacheMembrosLightStruct createDTCacheMembrosLightStruct({
  String? id,
  String? nomeCompleto,
  String? cpf,
  String? email,
  String? telefone,
  bool? ativo,
}) =>
    DTCacheMembrosLightStruct(
      id: id,
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      email: email,
      telefone: telefone,
      ativo: ativo,
    );
