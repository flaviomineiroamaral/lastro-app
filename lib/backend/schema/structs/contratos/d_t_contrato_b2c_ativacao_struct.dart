// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTContratoB2cAtivacaoStruct extends BaseStruct {
  DTContratoB2cAtivacaoStruct({
    String? contratoId,
    String? responsavel,
    String? email,
  })  : _contratoId = contratoId,
        _responsavel = responsavel,
        _email = email;

  // "contratoId" field.
  String? _contratoId;
  String get contratoId => _contratoId ?? '';
  set contratoId(String? val) => _contratoId = val;

  bool hasContratoId() => _contratoId != null;

  // "responsavel" field.
  String? _responsavel;
  String get responsavel => _responsavel ?? '';
  set responsavel(String? val) => _responsavel = val;

  bool hasResponsavel() => _responsavel != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  static DTContratoB2cAtivacaoStruct fromMap(Map<String, dynamic> data) =>
      DTContratoB2cAtivacaoStruct(
        contratoId: data['contratoId'] as String?,
        responsavel: data['responsavel'] as String?,
        email: data['email'] as String?,
      );

  static DTContratoB2cAtivacaoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTContratoB2cAtivacaoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'contratoId': _contratoId,
        'responsavel': _responsavel,
        'email': _email,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'contratoId': serializeParam(
          _contratoId,
          ParamType.String,
        ),
        'responsavel': serializeParam(
          _responsavel,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTContratoB2cAtivacaoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTContratoB2cAtivacaoStruct(
        contratoId: deserializeParam(
          data['contratoId'],
          ParamType.String,
          false,
        ),
        responsavel: deserializeParam(
          data['responsavel'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTContratoB2cAtivacaoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTContratoB2cAtivacaoStruct &&
        contratoId == other.contratoId &&
        responsavel == other.responsavel &&
        email == other.email;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([contratoId, responsavel, email]);
}

DTContratoB2cAtivacaoStruct createDTContratoB2cAtivacaoStruct({
  String? contratoId,
  String? responsavel,
  String? email,
}) =>
    DTContratoB2cAtivacaoStruct(
      contratoId: contratoId,
      responsavel: responsavel,
      email: email,
    );
