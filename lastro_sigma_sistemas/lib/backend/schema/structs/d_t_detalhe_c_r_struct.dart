// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTDetalheCRStruct extends BaseStruct {
  DTDetalheCRStruct({
    String? transacaoId,
    String? descricao,
    double? valor,
    String? tipoOperacao,
    DateTime? dataCompetencia,
    DateTime? dataVencimento,
    DateTime? dataPagamento,
    String? contaNome,
    String? tipoConta,
    String? categoriaNome,
  })  : _transacaoId = transacaoId,
        _descricao = descricao,
        _valor = valor,
        _tipoOperacao = tipoOperacao,
        _dataCompetencia = dataCompetencia,
        _dataVencimento = dataVencimento,
        _dataPagamento = dataPagamento,
        _contaNome = contaNome,
        _tipoConta = tipoConta,
        _categoriaNome = categoriaNome;

  // "transacaoId" field.
  String? _transacaoId;
  String get transacaoId => _transacaoId ?? '';
  set transacaoId(String? val) => _transacaoId = val;

  bool hasTransacaoId() => _transacaoId != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "tipoOperacao" field.
  String? _tipoOperacao;
  String get tipoOperacao => _tipoOperacao ?? '';
  set tipoOperacao(String? val) => _tipoOperacao = val;

  bool hasTipoOperacao() => _tipoOperacao != null;

  // "dataCompetencia" field.
  DateTime? _dataCompetencia;
  DateTime? get dataCompetencia => _dataCompetencia;
  set dataCompetencia(DateTime? val) => _dataCompetencia = val;

  bool hasDataCompetencia() => _dataCompetencia != null;

  // "dataVencimento" field.
  DateTime? _dataVencimento;
  DateTime? get dataVencimento => _dataVencimento;
  set dataVencimento(DateTime? val) => _dataVencimento = val;

  bool hasDataVencimento() => _dataVencimento != null;

  // "dataPagamento" field.
  DateTime? _dataPagamento;
  DateTime? get dataPagamento => _dataPagamento;
  set dataPagamento(DateTime? val) => _dataPagamento = val;

  bool hasDataPagamento() => _dataPagamento != null;

  // "contaNome" field.
  String? _contaNome;
  String get contaNome => _contaNome ?? '';
  set contaNome(String? val) => _contaNome = val;

  bool hasContaNome() => _contaNome != null;

  // "tipo_conta" field.
  String? _tipoConta;
  String get tipoConta => _tipoConta ?? '';
  set tipoConta(String? val) => _tipoConta = val;

  bool hasTipoConta() => _tipoConta != null;

  // "categoriaNome" field.
  String? _categoriaNome;
  String get categoriaNome => _categoriaNome ?? '';
  set categoriaNome(String? val) => _categoriaNome = val;

  bool hasCategoriaNome() => _categoriaNome != null;

  static DTDetalheCRStruct fromMap(Map<String, dynamic> data) =>
      DTDetalheCRStruct(
        transacaoId: data['transacaoId'] as String?,
        descricao: data['descricao'] as String?,
        valor: castToType<double>(data['valor']),
        tipoOperacao: data['tipoOperacao'] as String?,
        dataCompetencia: data['dataCompetencia'] as DateTime?,
        dataVencimento: data['dataVencimento'] as DateTime?,
        dataPagamento: data['dataPagamento'] as DateTime?,
        contaNome: data['contaNome'] as String?,
        tipoConta: data['tipo_conta'] as String?,
        categoriaNome: data['categoriaNome'] as String?,
      );

  static DTDetalheCRStruct? maybeFromMap(dynamic data) => data is Map
      ? DTDetalheCRStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'transacaoId': _transacaoId,
        'descricao': _descricao,
        'valor': _valor,
        'tipoOperacao': _tipoOperacao,
        'dataCompetencia': _dataCompetencia,
        'dataVencimento': _dataVencimento,
        'dataPagamento': _dataPagamento,
        'contaNome': _contaNome,
        'tipo_conta': _tipoConta,
        'categoriaNome': _categoriaNome,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'transacaoId': serializeParam(
          _transacaoId,
          ParamType.String,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'tipoOperacao': serializeParam(
          _tipoOperacao,
          ParamType.String,
        ),
        'dataCompetencia': serializeParam(
          _dataCompetencia,
          ParamType.DateTime,
        ),
        'dataVencimento': serializeParam(
          _dataVencimento,
          ParamType.DateTime,
        ),
        'dataPagamento': serializeParam(
          _dataPagamento,
          ParamType.DateTime,
        ),
        'contaNome': serializeParam(
          _contaNome,
          ParamType.String,
        ),
        'tipo_conta': serializeParam(
          _tipoConta,
          ParamType.String,
        ),
        'categoriaNome': serializeParam(
          _categoriaNome,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTDetalheCRStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTDetalheCRStruct(
        transacaoId: deserializeParam(
          data['transacaoId'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
          false,
        ),
        tipoOperacao: deserializeParam(
          data['tipoOperacao'],
          ParamType.String,
          false,
        ),
        dataCompetencia: deserializeParam(
          data['dataCompetencia'],
          ParamType.DateTime,
          false,
        ),
        dataVencimento: deserializeParam(
          data['dataVencimento'],
          ParamType.DateTime,
          false,
        ),
        dataPagamento: deserializeParam(
          data['dataPagamento'],
          ParamType.DateTime,
          false,
        ),
        contaNome: deserializeParam(
          data['contaNome'],
          ParamType.String,
          false,
        ),
        tipoConta: deserializeParam(
          data['tipo_conta'],
          ParamType.String,
          false,
        ),
        categoriaNome: deserializeParam(
          data['categoriaNome'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTDetalheCRStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTDetalheCRStruct &&
        transacaoId == other.transacaoId &&
        descricao == other.descricao &&
        valor == other.valor &&
        tipoOperacao == other.tipoOperacao &&
        dataCompetencia == other.dataCompetencia &&
        dataVencimento == other.dataVencimento &&
        dataPagamento == other.dataPagamento &&
        contaNome == other.contaNome &&
        tipoConta == other.tipoConta &&
        categoriaNome == other.categoriaNome;
  }

  @override
  int get hashCode => const ListEquality().hash([
        transacaoId,
        descricao,
        valor,
        tipoOperacao,
        dataCompetencia,
        dataVencimento,
        dataPagamento,
        contaNome,
        tipoConta,
        categoriaNome
      ]);
}

DTDetalheCRStruct createDTDetalheCRStruct({
  String? transacaoId,
  String? descricao,
  double? valor,
  String? tipoOperacao,
  DateTime? dataCompetencia,
  DateTime? dataVencimento,
  DateTime? dataPagamento,
  String? contaNome,
  String? tipoConta,
  String? categoriaNome,
}) =>
    DTDetalheCRStruct(
      transacaoId: transacaoId,
      descricao: descricao,
      valor: valor,
      tipoOperacao: tipoOperacao,
      dataCompetencia: dataCompetencia,
      dataVencimento: dataVencimento,
      dataPagamento: dataPagamento,
      contaNome: contaNome,
      tipoConta: tipoConta,
      categoriaNome: categoriaNome,
    );
