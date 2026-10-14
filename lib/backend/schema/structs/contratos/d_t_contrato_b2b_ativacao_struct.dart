// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTContratoB2bAtivacaoStruct extends BaseStruct {
  DTContratoB2bAtivacaoStruct({
    String? contratoId,
    String? tipoPerfil,
    String? razaoSocial,
    String? responsavel,
    String? email,
  })  : _contratoId = contratoId,
        _tipoPerfil = tipoPerfil,
        _razaoSocial = razaoSocial,
        _responsavel = responsavel,
        _email = email;

  // "contratoId" field.
  String? _contratoId;
  String get contratoId => _contratoId ?? '';
  set contratoId(String? val) => _contratoId = val;

  bool hasContratoId() => _contratoId != null;

  // "tipoPerfil" field.
  String? _tipoPerfil;
  String get tipoPerfil => _tipoPerfil ?? '';
  set tipoPerfil(String? val) => _tipoPerfil = val;

  bool hasTipoPerfil() => _tipoPerfil != null;

  // "razaoSocial" field.
  String? _razaoSocial;
  String get razaoSocial => _razaoSocial ?? '';
  set razaoSocial(String? val) => _razaoSocial = val;

  bool hasRazaoSocial() => _razaoSocial != null;

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

  static DTContratoB2bAtivacaoStruct fromMap(Map<String, dynamic> data) =>
      DTContratoB2bAtivacaoStruct(
        contratoId: data['contratoId'] as String?,
        tipoPerfil: data['tipoPerfil'] as String?,
        razaoSocial: data['razaoSocial'] as String?,
        responsavel: data['responsavel'] as String?,
        email: data['email'] as String?,
      );

  static DTContratoB2bAtivacaoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTContratoB2bAtivacaoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'contratoId': _contratoId,
        'tipoPerfil': _tipoPerfil,
        'razaoSocial': _razaoSocial,
        'responsavel': _responsavel,
        'email': _email,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'contratoId': serializeParam(
          _contratoId,
          ParamType.String,
        ),
        'tipoPerfil': serializeParam(
          _tipoPerfil,
          ParamType.String,
        ),
        'razaoSocial': serializeParam(
          _razaoSocial,
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

  static DTContratoB2bAtivacaoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTContratoB2bAtivacaoStruct(
        contratoId: deserializeParam(
          data['contratoId'],
          ParamType.String,
          false,
        ),
        tipoPerfil: deserializeParam(
          data['tipoPerfil'],
          ParamType.String,
          false,
        ),
        razaoSocial: deserializeParam(
          data['razaoSocial'],
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
  String toString() => 'DTContratoB2bAtivacaoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTContratoB2bAtivacaoStruct &&
        contratoId == other.contratoId &&
        tipoPerfil == other.tipoPerfil &&
        razaoSocial == other.razaoSocial &&
        responsavel == other.responsavel &&
        email == other.email;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([contratoId, tipoPerfil, razaoSocial, responsavel, email]);
}

DTContratoB2bAtivacaoStruct createDTContratoB2bAtivacaoStruct({
  String? contratoId,
  String? tipoPerfil,
  String? razaoSocial,
  String? responsavel,
  String? email,
}) =>
    DTContratoB2bAtivacaoStruct(
      contratoId: contratoId,
      tipoPerfil: tipoPerfil,
      razaoSocial: razaoSocial,
      responsavel: responsavel,
      email: email,
    );
