// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTAtivacaoSerialStruct extends BaseStruct {
  DTAtivacaoSerialStruct({
    String? registroId,
    String? nomeOrganizacao,
    String? nomeUtilizador,
    String? email,
    String? tipoPerfil,
    String? tabelaOrigem,
  })  : _registroId = registroId,
        _nomeOrganizacao = nomeOrganizacao,
        _nomeUtilizador = nomeUtilizador,
        _email = email,
        _tipoPerfil = tipoPerfil,
        _tabelaOrigem = tabelaOrigem;

  // "registroId" field.
  String? _registroId;
  String get registroId => _registroId ?? '';
  set registroId(String? val) => _registroId = val;

  bool hasRegistroId() => _registroId != null;

  // "nomeOrganizacao" field.
  String? _nomeOrganizacao;
  String get nomeOrganizacao => _nomeOrganizacao ?? '';
  set nomeOrganizacao(String? val) => _nomeOrganizacao = val;

  bool hasNomeOrganizacao() => _nomeOrganizacao != null;

  // "nomeUtilizador" field.
  String? _nomeUtilizador;
  String get nomeUtilizador => _nomeUtilizador ?? '';
  set nomeUtilizador(String? val) => _nomeUtilizador = val;

  bool hasNomeUtilizador() => _nomeUtilizador != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "tipoPerfil" field.
  String? _tipoPerfil;
  String get tipoPerfil => _tipoPerfil ?? '';
  set tipoPerfil(String? val) => _tipoPerfil = val;

  bool hasTipoPerfil() => _tipoPerfil != null;

  // "tabelaOrigem" field.
  String? _tabelaOrigem;
  String get tabelaOrigem => _tabelaOrigem ?? '';
  set tabelaOrigem(String? val) => _tabelaOrigem = val;

  bool hasTabelaOrigem() => _tabelaOrigem != null;

  static DTAtivacaoSerialStruct fromMap(Map<String, dynamic> data) =>
      DTAtivacaoSerialStruct(
        registroId: data['registroId'] as String?,
        nomeOrganizacao: data['nomeOrganizacao'] as String?,
        nomeUtilizador: data['nomeUtilizador'] as String?,
        email: data['email'] as String?,
        tipoPerfil: data['tipoPerfil'] as String?,
        tabelaOrigem: data['tabelaOrigem'] as String?,
      );

  static DTAtivacaoSerialStruct? maybeFromMap(dynamic data) => data is Map
      ? DTAtivacaoSerialStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'registroId': _registroId,
        'nomeOrganizacao': _nomeOrganizacao,
        'nomeUtilizador': _nomeUtilizador,
        'email': _email,
        'tipoPerfil': _tipoPerfil,
        'tabelaOrigem': _tabelaOrigem,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'registroId': serializeParam(
          _registroId,
          ParamType.String,
        ),
        'nomeOrganizacao': serializeParam(
          _nomeOrganizacao,
          ParamType.String,
        ),
        'nomeUtilizador': serializeParam(
          _nomeUtilizador,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'tipoPerfil': serializeParam(
          _tipoPerfil,
          ParamType.String,
        ),
        'tabelaOrigem': serializeParam(
          _tabelaOrigem,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTAtivacaoSerialStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTAtivacaoSerialStruct(
        registroId: deserializeParam(
          data['registroId'],
          ParamType.String,
          false,
        ),
        nomeOrganizacao: deserializeParam(
          data['nomeOrganizacao'],
          ParamType.String,
          false,
        ),
        nomeUtilizador: deserializeParam(
          data['nomeUtilizador'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        tipoPerfil: deserializeParam(
          data['tipoPerfil'],
          ParamType.String,
          false,
        ),
        tabelaOrigem: deserializeParam(
          data['tabelaOrigem'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTAtivacaoSerialStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTAtivacaoSerialStruct &&
        registroId == other.registroId &&
        nomeOrganizacao == other.nomeOrganizacao &&
        nomeUtilizador == other.nomeUtilizador &&
        email == other.email &&
        tipoPerfil == other.tipoPerfil &&
        tabelaOrigem == other.tabelaOrigem;
  }

  @override
  int get hashCode => const ListEquality().hash([
        registroId,
        nomeOrganizacao,
        nomeUtilizador,
        email,
        tipoPerfil,
        tabelaOrigem
      ]);
}

DTAtivacaoSerialStruct createDTAtivacaoSerialStruct({
  String? registroId,
  String? nomeOrganizacao,
  String? nomeUtilizador,
  String? email,
  String? tipoPerfil,
  String? tabelaOrigem,
}) =>
    DTAtivacaoSerialStruct(
      registroId: registroId,
      nomeOrganizacao: nomeOrganizacao,
      nomeUtilizador: nomeUtilizador,
      email: email,
      tipoPerfil: tipoPerfil,
      tabelaOrigem: tabelaOrigem,
    );
