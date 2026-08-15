// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTCacheCentrosDeResultadoStruct extends BaseStruct {
  DTCacheCentrosDeResultadoStruct({
    String? id,
    String? nome,
    String? descricao,
    bool? ativo,
    bool? isPadrao,
    bool? isFundo,
    String? corHex,
    bool? permiteAcumulo,
  })  : _id = id,
        _nome = nome,
        _descricao = descricao,
        _ativo = ativo,
        _isPadrao = isPadrao,
        _isFundo = isFundo,
        _corHex = corHex,
        _permiteAcumulo = permiteAcumulo;

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

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? false;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  // "isPadrao" field.
  bool? _isPadrao;
  bool get isPadrao => _isPadrao ?? false;
  set isPadrao(bool? val) => _isPadrao = val;

  bool hasIsPadrao() => _isPadrao != null;

  // "isFundo" field.
  bool? _isFundo;
  bool get isFundo => _isFundo ?? false;
  set isFundo(bool? val) => _isFundo = val;

  bool hasIsFundo() => _isFundo != null;

  // "corHex" field.
  String? _corHex;
  String get corHex => _corHex ?? '';
  set corHex(String? val) => _corHex = val;

  bool hasCorHex() => _corHex != null;

  // "permite_acumulo" field.
  bool? _permiteAcumulo;
  bool get permiteAcumulo => _permiteAcumulo ?? false;
  set permiteAcumulo(bool? val) => _permiteAcumulo = val;

  bool hasPermiteAcumulo() => _permiteAcumulo != null;

  static DTCacheCentrosDeResultadoStruct fromMap(Map<String, dynamic> data) =>
      DTCacheCentrosDeResultadoStruct(
        id: data['id'] as String?,
        nome: data['nome'] as String?,
        descricao: data['descricao'] as String?,
        ativo: data['ativo'] as bool?,
        isPadrao: data['isPadrao'] as bool?,
        isFundo: data['isFundo'] as bool?,
        corHex: data['corHex'] as String?,
        permiteAcumulo: data['permite_acumulo'] as bool?,
      );

  static DTCacheCentrosDeResultadoStruct? maybeFromMap(dynamic data) => data
          is Map
      ? DTCacheCentrosDeResultadoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nome': _nome,
        'descricao': _descricao,
        'ativo': _ativo,
        'isPadrao': _isPadrao,
        'isFundo': _isFundo,
        'corHex': _corHex,
        'permite_acumulo': _permiteAcumulo,
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
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'ativo': serializeParam(
          _ativo,
          ParamType.bool,
        ),
        'isPadrao': serializeParam(
          _isPadrao,
          ParamType.bool,
        ),
        'isFundo': serializeParam(
          _isFundo,
          ParamType.bool,
        ),
        'corHex': serializeParam(
          _corHex,
          ParamType.String,
        ),
        'permite_acumulo': serializeParam(
          _permiteAcumulo,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DTCacheCentrosDeResultadoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTCacheCentrosDeResultadoStruct(
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
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        ativo: deserializeParam(
          data['ativo'],
          ParamType.bool,
          false,
        ),
        isPadrao: deserializeParam(
          data['isPadrao'],
          ParamType.bool,
          false,
        ),
        isFundo: deserializeParam(
          data['isFundo'],
          ParamType.bool,
          false,
        ),
        corHex: deserializeParam(
          data['corHex'],
          ParamType.String,
          false,
        ),
        permiteAcumulo: deserializeParam(
          data['permite_acumulo'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DTCacheCentrosDeResultadoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTCacheCentrosDeResultadoStruct &&
        id == other.id &&
        nome == other.nome &&
        descricao == other.descricao &&
        ativo == other.ativo &&
        isPadrao == other.isPadrao &&
        isFundo == other.isFundo &&
        corHex == other.corHex &&
        permiteAcumulo == other.permiteAcumulo;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [id, nome, descricao, ativo, isPadrao, isFundo, corHex, permiteAcumulo]);
}

DTCacheCentrosDeResultadoStruct createDTCacheCentrosDeResultadoStruct({
  String? id,
  String? nome,
  String? descricao,
  bool? ativo,
  bool? isPadrao,
  bool? isFundo,
  String? corHex,
  bool? permiteAcumulo,
}) =>
    DTCacheCentrosDeResultadoStruct(
      id: id,
      nome: nome,
      descricao: descricao,
      ativo: ativo,
      isPadrao: isPadrao,
      isFundo: isFundo,
      corHex: corHex,
      permiteAcumulo: permiteAcumulo,
    );
