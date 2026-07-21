// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTCachePlanoContasStruct extends BaseStruct {
  DTCachePlanoContasStruct({
    String? id,
    String? codigoContabil,
    String? nome,
    String? tipo,
    String? nomeExibicao,
    String? naturezaFluxo,
    bool? permiteLancamento,
    String? instrucaoUso,
  })  : _id = id,
        _codigoContabil = codigoContabil,
        _nome = nome,
        _tipo = tipo,
        _nomeExibicao = nomeExibicao,
        _naturezaFluxo = naturezaFluxo,
        _permiteLancamento = permiteLancamento,
        _instrucaoUso = instrucaoUso;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "codigoContabil" field.
  String? _codigoContabil;
  String get codigoContabil => _codigoContabil ?? '';
  set codigoContabil(String? val) => _codigoContabil = val;

  bool hasCodigoContabil() => _codigoContabil != null;

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

  // "nomeExibicao" field.
  String? _nomeExibicao;
  String get nomeExibicao => _nomeExibicao ?? '';
  set nomeExibicao(String? val) => _nomeExibicao = val;

  bool hasNomeExibicao() => _nomeExibicao != null;

  // "naturezaFluxo" field.
  String? _naturezaFluxo;
  String get naturezaFluxo => _naturezaFluxo ?? '';
  set naturezaFluxo(String? val) => _naturezaFluxo = val;

  bool hasNaturezaFluxo() => _naturezaFluxo != null;

  // "permiteLancamento" field.
  bool? _permiteLancamento;
  bool get permiteLancamento => _permiteLancamento ?? false;
  set permiteLancamento(bool? val) => _permiteLancamento = val;

  bool hasPermiteLancamento() => _permiteLancamento != null;

  // "instrucaoUso" field.
  String? _instrucaoUso;
  String get instrucaoUso => _instrucaoUso ?? '';
  set instrucaoUso(String? val) => _instrucaoUso = val;

  bool hasInstrucaoUso() => _instrucaoUso != null;

  static DTCachePlanoContasStruct fromMap(Map<String, dynamic> data) =>
      DTCachePlanoContasStruct(
        id: data['id'] as String?,
        codigoContabil: data['codigoContabil'] as String?,
        nome: data['nome'] as String?,
        tipo: data['tipo'] as String?,
        nomeExibicao: data['nomeExibicao'] as String?,
        naturezaFluxo: data['naturezaFluxo'] as String?,
        permiteLancamento: data['permiteLancamento'] as bool?,
        instrucaoUso: data['instrucaoUso'] as String?,
      );

  static DTCachePlanoContasStruct? maybeFromMap(dynamic data) => data is Map
      ? DTCachePlanoContasStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'codigoContabil': _codigoContabil,
        'nome': _nome,
        'tipo': _tipo,
        'nomeExibicao': _nomeExibicao,
        'naturezaFluxo': _naturezaFluxo,
        'permiteLancamento': _permiteLancamento,
        'instrucaoUso': _instrucaoUso,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'codigoContabil': serializeParam(
          _codigoContabil,
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
        'nomeExibicao': serializeParam(
          _nomeExibicao,
          ParamType.String,
        ),
        'naturezaFluxo': serializeParam(
          _naturezaFluxo,
          ParamType.String,
        ),
        'permiteLancamento': serializeParam(
          _permiteLancamento,
          ParamType.bool,
        ),
        'instrucaoUso': serializeParam(
          _instrucaoUso,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTCachePlanoContasStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTCachePlanoContasStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        codigoContabil: deserializeParam(
          data['codigoContabil'],
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
        nomeExibicao: deserializeParam(
          data['nomeExibicao'],
          ParamType.String,
          false,
        ),
        naturezaFluxo: deserializeParam(
          data['naturezaFluxo'],
          ParamType.String,
          false,
        ),
        permiteLancamento: deserializeParam(
          data['permiteLancamento'],
          ParamType.bool,
          false,
        ),
        instrucaoUso: deserializeParam(
          data['instrucaoUso'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTCachePlanoContasStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTCachePlanoContasStruct &&
        id == other.id &&
        codigoContabil == other.codigoContabil &&
        nome == other.nome &&
        tipo == other.tipo &&
        nomeExibicao == other.nomeExibicao &&
        naturezaFluxo == other.naturezaFluxo &&
        permiteLancamento == other.permiteLancamento &&
        instrucaoUso == other.instrucaoUso;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        codigoContabil,
        nome,
        tipo,
        nomeExibicao,
        naturezaFluxo,
        permiteLancamento,
        instrucaoUso
      ]);
}

DTCachePlanoContasStruct createDTCachePlanoContasStruct({
  String? id,
  String? codigoContabil,
  String? nome,
  String? tipo,
  String? nomeExibicao,
  String? naturezaFluxo,
  bool? permiteLancamento,
  String? instrucaoUso,
}) =>
    DTCachePlanoContasStruct(
      id: id,
      codigoContabil: codigoContabil,
      nome: nome,
      tipo: tipo,
      nomeExibicao: nomeExibicao,
      naturezaFluxo: naturezaFluxo,
      permiteLancamento: permiteLancamento,
      instrucaoUso: instrucaoUso,
    );
