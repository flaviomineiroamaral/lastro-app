// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTObrigacaoRecorrenteStruct extends BaseStruct {
  DTObrigacaoRecorrenteStruct({
    String? id,
    String? descricao,
    String? categoriaId,
    String? categoriaNome,
    String? centroCustoId,
    String? centroCustoNome,
    String? contaBancariaId,
    String? contaBancariaNome,
    String? periodicidade,
    int? diaVencimento,
    int? mesVencimento,
    int? diasAntecedencia,
    double? valorEstimado,
    bool? ativo,
  })  : _id = id,
        _descricao = descricao,
        _categoriaId = categoriaId,
        _categoriaNome = categoriaNome,
        _centroCustoId = centroCustoId,
        _centroCustoNome = centroCustoNome,
        _contaBancariaId = contaBancariaId,
        _contaBancariaNome = contaBancariaNome,
        _periodicidade = periodicidade,
        _diaVencimento = diaVencimento,
        _mesVencimento = mesVencimento,
        _diasAntecedencia = diasAntecedencia,
        _valorEstimado = valorEstimado,
        _ativo = ativo;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "categoriaId" field.
  String? _categoriaId;
  String get categoriaId => _categoriaId ?? '';
  set categoriaId(String? val) => _categoriaId = val;

  bool hasCategoriaId() => _categoriaId != null;

  // "categoriaNome" field.
  String? _categoriaNome;
  String get categoriaNome => _categoriaNome ?? '';
  set categoriaNome(String? val) => _categoriaNome = val;

  bool hasCategoriaNome() => _categoriaNome != null;

  // "centroCustoId" field.
  String? _centroCustoId;
  String get centroCustoId => _centroCustoId ?? '';
  set centroCustoId(String? val) => _centroCustoId = val;

  bool hasCentroCustoId() => _centroCustoId != null;

  // "centroCustoNome" field.
  String? _centroCustoNome;
  String get centroCustoNome => _centroCustoNome ?? '';
  set centroCustoNome(String? val) => _centroCustoNome = val;

  bool hasCentroCustoNome() => _centroCustoNome != null;

  // "contaBancariaId" field.
  String? _contaBancariaId;
  String get contaBancariaId => _contaBancariaId ?? '';
  set contaBancariaId(String? val) => _contaBancariaId = val;

  bool hasContaBancariaId() => _contaBancariaId != null;

  // "contaBancariaNome" field.
  String? _contaBancariaNome;
  String get contaBancariaNome => _contaBancariaNome ?? '';
  set contaBancariaNome(String? val) => _contaBancariaNome = val;

  bool hasContaBancariaNome() => _contaBancariaNome != null;

  // "periodicidade" field.
  String? _periodicidade;
  String get periodicidade => _periodicidade ?? 'MENSAL';
  set periodicidade(String? val) => _periodicidade = val;

  bool hasPeriodicidade() => _periodicidade != null;

  // "diaVencimento" field.
  int? _diaVencimento;
  int get diaVencimento => _diaVencimento ?? 1;
  set diaVencimento(int? val) => _diaVencimento = val;

  void incrementDiaVencimento(int amount) =>
      diaVencimento = diaVencimento + amount;

  bool hasDiaVencimento() => _diaVencimento != null;

  // "mesVencimento" field.
  int? _mesVencimento;
  int get mesVencimento => _mesVencimento ?? 0;
  set mesVencimento(int? val) => _mesVencimento = val;

  void incrementMesVencimento(int amount) =>
      mesVencimento = mesVencimento + amount;

  bool hasMesVencimento() => _mesVencimento != null;

  // "diasAntecedencia" field.
  int? _diasAntecedencia;
  int get diasAntecedencia => _diasAntecedencia ?? 20;
  set diasAntecedencia(int? val) => _diasAntecedencia = val;

  void incrementDiasAntecedencia(int amount) =>
      diasAntecedencia = diasAntecedencia + amount;

  bool hasDiasAntecedencia() => _diasAntecedencia != null;

  // "valorEstimado" field.
  double? _valorEstimado;
  double get valorEstimado => _valorEstimado ?? 0.0;
  set valorEstimado(double? val) => _valorEstimado = val;

  void incrementValorEstimado(double amount) =>
      valorEstimado = valorEstimado + amount;

  bool hasValorEstimado() => _valorEstimado != null;

  // "ativo" field.
  bool? _ativo;
  bool get ativo => _ativo ?? true;
  set ativo(bool? val) => _ativo = val;

  bool hasAtivo() => _ativo != null;

  static DTObrigacaoRecorrenteStruct fromMap(Map<String, dynamic> data) =>
      DTObrigacaoRecorrenteStruct(
        id: data['id'] as String?,
        descricao: data['descricao'] as String?,
        categoriaId: data['categoriaId'] as String?,
        categoriaNome: data['categoriaNome'] as String?,
        centroCustoId: data['centroCustoId'] as String?,
        centroCustoNome: data['centroCustoNome'] as String?,
        contaBancariaId: data['contaBancariaId'] as String?,
        contaBancariaNome: data['contaBancariaNome'] as String?,
        periodicidade: data['periodicidade'] as String?,
        diaVencimento: castToType<int>(data['diaVencimento']),
        mesVencimento: castToType<int>(data['mesVencimento']),
        diasAntecedencia: castToType<int>(data['diasAntecedencia']),
        valorEstimado: castToType<double>(data['valorEstimado']),
        ativo: data['ativo'] as bool?,
      );

  static DTObrigacaoRecorrenteStruct? maybeFromMap(dynamic data) => data is Map
      ? DTObrigacaoRecorrenteStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'descricao': _descricao,
        'categoriaId': _categoriaId,
        'categoriaNome': _categoriaNome,
        'centroCustoId': _centroCustoId,
        'centroCustoNome': _centroCustoNome,
        'contaBancariaId': _contaBancariaId,
        'contaBancariaNome': _contaBancariaNome,
        'periodicidade': _periodicidade,
        'diaVencimento': _diaVencimento,
        'mesVencimento': _mesVencimento,
        'diasAntecedencia': _diasAntecedencia,
        'valorEstimado': _valorEstimado,
        'ativo': _ativo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'categoriaId': serializeParam(
          _categoriaId,
          ParamType.String,
        ),
        'categoriaNome': serializeParam(
          _categoriaNome,
          ParamType.String,
        ),
        'centroCustoId': serializeParam(
          _centroCustoId,
          ParamType.String,
        ),
        'centroCustoNome': serializeParam(
          _centroCustoNome,
          ParamType.String,
        ),
        'contaBancariaId': serializeParam(
          _contaBancariaId,
          ParamType.String,
        ),
        'contaBancariaNome': serializeParam(
          _contaBancariaNome,
          ParamType.String,
        ),
        'periodicidade': serializeParam(
          _periodicidade,
          ParamType.String,
        ),
        'diaVencimento': serializeParam(
          _diaVencimento,
          ParamType.int,
        ),
        'mesVencimento': serializeParam(
          _mesVencimento,
          ParamType.int,
        ),
        'diasAntecedencia': serializeParam(
          _diasAntecedencia,
          ParamType.int,
        ),
        'valorEstimado': serializeParam(
          _valorEstimado,
          ParamType.double,
        ),
        'ativo': serializeParam(
          _ativo,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DTObrigacaoRecorrenteStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTObrigacaoRecorrenteStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        categoriaId: deserializeParam(
          data['categoriaId'],
          ParamType.String,
          false,
        ),
        categoriaNome: deserializeParam(
          data['categoriaNome'],
          ParamType.String,
          false,
        ),
        centroCustoId: deserializeParam(
          data['centroCustoId'],
          ParamType.String,
          false,
        ),
        centroCustoNome: deserializeParam(
          data['centroCustoNome'],
          ParamType.String,
          false,
        ),
        contaBancariaId: deserializeParam(
          data['contaBancariaId'],
          ParamType.String,
          false,
        ),
        contaBancariaNome: deserializeParam(
          data['contaBancariaNome'],
          ParamType.String,
          false,
        ),
        periodicidade: deserializeParam(
          data['periodicidade'],
          ParamType.String,
          false,
        ),
        diaVencimento: deserializeParam(
          data['diaVencimento'],
          ParamType.int,
          false,
        ),
        mesVencimento: deserializeParam(
          data['mesVencimento'],
          ParamType.int,
          false,
        ),
        diasAntecedencia: deserializeParam(
          data['diasAntecedencia'],
          ParamType.int,
          false,
        ),
        valorEstimado: deserializeParam(
          data['valorEstimado'],
          ParamType.double,
          false,
        ),
        ativo: deserializeParam(
          data['ativo'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DTObrigacaoRecorrenteStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTObrigacaoRecorrenteStruct &&
        id == other.id &&
        descricao == other.descricao &&
        categoriaId == other.categoriaId &&
        categoriaNome == other.categoriaNome &&
        centroCustoId == other.centroCustoId &&
        centroCustoNome == other.centroCustoNome &&
        contaBancariaId == other.contaBancariaId &&
        contaBancariaNome == other.contaBancariaNome &&
        periodicidade == other.periodicidade &&
        diaVencimento == other.diaVencimento &&
        mesVencimento == other.mesVencimento &&
        diasAntecedencia == other.diasAntecedencia &&
        valorEstimado == other.valorEstimado &&
        ativo == other.ativo;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        descricao,
        categoriaId,
        categoriaNome,
        centroCustoId,
        centroCustoNome,
        contaBancariaId,
        contaBancariaNome,
        periodicidade,
        diaVencimento,
        mesVencimento,
        diasAntecedencia,
        valorEstimado,
        ativo
      ]);
}

DTObrigacaoRecorrenteStruct createDTObrigacaoRecorrenteStruct({
  String? id,
  String? descricao,
  String? categoriaId,
  String? categoriaNome,
  String? centroCustoId,
  String? centroCustoNome,
  String? contaBancariaId,
  String? contaBancariaNome,
  String? periodicidade,
  int? diaVencimento,
  int? mesVencimento,
  int? diasAntecedencia,
  double? valorEstimado,
  bool? ativo,
}) =>
    DTObrigacaoRecorrenteStruct(
      id: id,
      descricao: descricao,
      categoriaId: categoriaId,
      categoriaNome: categoriaNome,
      centroCustoId: centroCustoId,
      centroCustoNome: centroCustoNome,
      contaBancariaId: contaBancariaId,
      contaBancariaNome: contaBancariaNome,
      periodicidade: periodicidade,
      diaVencimento: diaVencimento,
      mesVencimento: mesVencimento,
      diasAntecedencia: diasAntecedencia,
      valorEstimado: valorEstimado,
      ativo: ativo,
    );
