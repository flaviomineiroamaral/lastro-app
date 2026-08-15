// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTDetalheTransacaoStruct extends BaseStruct {
  DTDetalheTransacaoStruct({
    String? transacaoId,
    DateTime? dataPagamento,
    DateTime? dataVencimento,
    DateTime? dataCompetencia,
    String? descricao,
    String? tipoOperacao,
    String? status,
    double? valor,
    String? contaOrigemId,
    String? contaOrigemNome,
    String? contaDestinoId,
    String? contaDestinoNome,
    String? categoriaId,
    String? categoriaNome,
    String? centroCustoId,
    String? centroCustoNome,
    String? membroId,
    String? membroNome,
    String? observacoes,
    String? comprovativoUrl,
  })  : _transacaoId = transacaoId,
        _dataPagamento = dataPagamento,
        _dataVencimento = dataVencimento,
        _dataCompetencia = dataCompetencia,
        _descricao = descricao,
        _tipoOperacao = tipoOperacao,
        _status = status,
        _valor = valor,
        _contaOrigemId = contaOrigemId,
        _contaOrigemNome = contaOrigemNome,
        _contaDestinoId = contaDestinoId,
        _contaDestinoNome = contaDestinoNome,
        _categoriaId = categoriaId,
        _categoriaNome = categoriaNome,
        _centroCustoId = centroCustoId,
        _centroCustoNome = centroCustoNome,
        _membroId = membroId,
        _membroNome = membroNome,
        _observacoes = observacoes,
        _comprovativoUrl = comprovativoUrl;

  // "transacaoId" field.
  String? _transacaoId;
  String get transacaoId => _transacaoId ?? '';
  set transacaoId(String? val) => _transacaoId = val;

  bool hasTransacaoId() => _transacaoId != null;

  // "dataPagamento" field.
  DateTime? _dataPagamento;
  DateTime? get dataPagamento => _dataPagamento;
  set dataPagamento(DateTime? val) => _dataPagamento = val;

  bool hasDataPagamento() => _dataPagamento != null;

  // "dataVencimento" field.
  DateTime? _dataVencimento;
  DateTime? get dataVencimento => _dataVencimento;
  set dataVencimento(DateTime? val) => _dataVencimento = val;

  bool hasDataVencimento() => _dataVencimento != null;

  // "dataCompetencia" field.
  DateTime? _dataCompetencia;
  DateTime? get dataCompetencia => _dataCompetencia;
  set dataCompetencia(DateTime? val) => _dataCompetencia = val;

  bool hasDataCompetencia() => _dataCompetencia != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "tipoOperacao" field.
  String? _tipoOperacao;
  String get tipoOperacao => _tipoOperacao ?? '';
  set tipoOperacao(String? val) => _tipoOperacao = val;

  bool hasTipoOperacao() => _tipoOperacao != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "contaOrigemId" field.
  String? _contaOrigemId;
  String get contaOrigemId => _contaOrigemId ?? '';
  set contaOrigemId(String? val) => _contaOrigemId = val;

  bool hasContaOrigemId() => _contaOrigemId != null;

  // "contaOrigemNome" field.
  String? _contaOrigemNome;
  String get contaOrigemNome => _contaOrigemNome ?? '';
  set contaOrigemNome(String? val) => _contaOrigemNome = val;

  bool hasContaOrigemNome() => _contaOrigemNome != null;

  // "contaDestinoId" field.
  String? _contaDestinoId;
  String get contaDestinoId => _contaDestinoId ?? '';
  set contaDestinoId(String? val) => _contaDestinoId = val;

  bool hasContaDestinoId() => _contaDestinoId != null;

  // "contaDestinoNome" field.
  String? _contaDestinoNome;
  String get contaDestinoNome => _contaDestinoNome ?? '';
  set contaDestinoNome(String? val) => _contaDestinoNome = val;

  bool hasContaDestinoNome() => _contaDestinoNome != null;

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

  // "membroId" field.
  String? _membroId;
  String get membroId => _membroId ?? '';
  set membroId(String? val) => _membroId = val;

  bool hasMembroId() => _membroId != null;

  // "membroNome" field.
  String? _membroNome;
  String get membroNome => _membroNome ?? '';
  set membroNome(String? val) => _membroNome = val;

  bool hasMembroNome() => _membroNome != null;

  // "observacoes" field.
  String? _observacoes;
  String get observacoes => _observacoes ?? '';
  set observacoes(String? val) => _observacoes = val;

  bool hasObservacoes() => _observacoes != null;

  // "comprovativoUrl" field.
  String? _comprovativoUrl;
  String get comprovativoUrl => _comprovativoUrl ?? '';
  set comprovativoUrl(String? val) => _comprovativoUrl = val;

  bool hasComprovativoUrl() => _comprovativoUrl != null;

  static DTDetalheTransacaoStruct fromMap(Map<String, dynamic> data) =>
      DTDetalheTransacaoStruct(
        transacaoId: data['transacaoId'] as String?,
        dataPagamento: data['dataPagamento'] as DateTime?,
        dataVencimento: data['dataVencimento'] as DateTime?,
        dataCompetencia: data['dataCompetencia'] as DateTime?,
        descricao: data['descricao'] as String?,
        tipoOperacao: data['tipoOperacao'] as String?,
        status: data['status'] as String?,
        valor: castToType<double>(data['valor']),
        contaOrigemId: data['contaOrigemId'] as String?,
        contaOrigemNome: data['contaOrigemNome'] as String?,
        contaDestinoId: data['contaDestinoId'] as String?,
        contaDestinoNome: data['contaDestinoNome'] as String?,
        categoriaId: data['categoriaId'] as String?,
        categoriaNome: data['categoriaNome'] as String?,
        centroCustoId: data['centroCustoId'] as String?,
        centroCustoNome: data['centroCustoNome'] as String?,
        membroId: data['membroId'] as String?,
        membroNome: data['membroNome'] as String?,
        observacoes: data['observacoes'] as String?,
        comprovativoUrl: data['comprovativoUrl'] as String?,
      );

  static DTDetalheTransacaoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTDetalheTransacaoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'transacaoId': _transacaoId,
        'dataPagamento': _dataPagamento,
        'dataVencimento': _dataVencimento,
        'dataCompetencia': _dataCompetencia,
        'descricao': _descricao,
        'tipoOperacao': _tipoOperacao,
        'status': _status,
        'valor': _valor,
        'contaOrigemId': _contaOrigemId,
        'contaOrigemNome': _contaOrigemNome,
        'contaDestinoId': _contaDestinoId,
        'contaDestinoNome': _contaDestinoNome,
        'categoriaId': _categoriaId,
        'categoriaNome': _categoriaNome,
        'centroCustoId': _centroCustoId,
        'centroCustoNome': _centroCustoNome,
        'membroId': _membroId,
        'membroNome': _membroNome,
        'observacoes': _observacoes,
        'comprovativoUrl': _comprovativoUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'transacaoId': serializeParam(
          _transacaoId,
          ParamType.String,
        ),
        'dataPagamento': serializeParam(
          _dataPagamento,
          ParamType.DateTime,
        ),
        'dataVencimento': serializeParam(
          _dataVencimento,
          ParamType.DateTime,
        ),
        'dataCompetencia': serializeParam(
          _dataCompetencia,
          ParamType.DateTime,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'tipoOperacao': serializeParam(
          _tipoOperacao,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'contaOrigemId': serializeParam(
          _contaOrigemId,
          ParamType.String,
        ),
        'contaOrigemNome': serializeParam(
          _contaOrigemNome,
          ParamType.String,
        ),
        'contaDestinoId': serializeParam(
          _contaDestinoId,
          ParamType.String,
        ),
        'contaDestinoNome': serializeParam(
          _contaDestinoNome,
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
        'membroId': serializeParam(
          _membroId,
          ParamType.String,
        ),
        'membroNome': serializeParam(
          _membroNome,
          ParamType.String,
        ),
        'observacoes': serializeParam(
          _observacoes,
          ParamType.String,
        ),
        'comprovativoUrl': serializeParam(
          _comprovativoUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTDetalheTransacaoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTDetalheTransacaoStruct(
        transacaoId: deserializeParam(
          data['transacaoId'],
          ParamType.String,
          false,
        ),
        dataPagamento: deserializeParam(
          data['dataPagamento'],
          ParamType.DateTime,
          false,
        ),
        dataVencimento: deserializeParam(
          data['dataVencimento'],
          ParamType.DateTime,
          false,
        ),
        dataCompetencia: deserializeParam(
          data['dataCompetencia'],
          ParamType.DateTime,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        tipoOperacao: deserializeParam(
          data['tipoOperacao'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        valor: deserializeParam(
          data['valor'],
          ParamType.double,
          false,
        ),
        contaOrigemId: deserializeParam(
          data['contaOrigemId'],
          ParamType.String,
          false,
        ),
        contaOrigemNome: deserializeParam(
          data['contaOrigemNome'],
          ParamType.String,
          false,
        ),
        contaDestinoId: deserializeParam(
          data['contaDestinoId'],
          ParamType.String,
          false,
        ),
        contaDestinoNome: deserializeParam(
          data['contaDestinoNome'],
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
        membroId: deserializeParam(
          data['membroId'],
          ParamType.String,
          false,
        ),
        membroNome: deserializeParam(
          data['membroNome'],
          ParamType.String,
          false,
        ),
        observacoes: deserializeParam(
          data['observacoes'],
          ParamType.String,
          false,
        ),
        comprovativoUrl: deserializeParam(
          data['comprovativoUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTDetalheTransacaoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTDetalheTransacaoStruct &&
        transacaoId == other.transacaoId &&
        dataPagamento == other.dataPagamento &&
        dataVencimento == other.dataVencimento &&
        dataCompetencia == other.dataCompetencia &&
        descricao == other.descricao &&
        tipoOperacao == other.tipoOperacao &&
        status == other.status &&
        valor == other.valor &&
        contaOrigemId == other.contaOrigemId &&
        contaOrigemNome == other.contaOrigemNome &&
        contaDestinoId == other.contaDestinoId &&
        contaDestinoNome == other.contaDestinoNome &&
        categoriaId == other.categoriaId &&
        categoriaNome == other.categoriaNome &&
        centroCustoId == other.centroCustoId &&
        centroCustoNome == other.centroCustoNome &&
        membroId == other.membroId &&
        membroNome == other.membroNome &&
        observacoes == other.observacoes &&
        comprovativoUrl == other.comprovativoUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([
        transacaoId,
        dataPagamento,
        dataVencimento,
        dataCompetencia,
        descricao,
        tipoOperacao,
        status,
        valor,
        contaOrigemId,
        contaOrigemNome,
        contaDestinoId,
        contaDestinoNome,
        categoriaId,
        categoriaNome,
        centroCustoId,
        centroCustoNome,
        membroId,
        membroNome,
        observacoes,
        comprovativoUrl
      ]);
}

DTDetalheTransacaoStruct createDTDetalheTransacaoStruct({
  String? transacaoId,
  DateTime? dataPagamento,
  DateTime? dataVencimento,
  DateTime? dataCompetencia,
  String? descricao,
  String? tipoOperacao,
  String? status,
  double? valor,
  String? contaOrigemId,
  String? contaOrigemNome,
  String? contaDestinoId,
  String? contaDestinoNome,
  String? categoriaId,
  String? categoriaNome,
  String? centroCustoId,
  String? centroCustoNome,
  String? membroId,
  String? membroNome,
  String? observacoes,
  String? comprovativoUrl,
}) =>
    DTDetalheTransacaoStruct(
      transacaoId: transacaoId,
      dataPagamento: dataPagamento,
      dataVencimento: dataVencimento,
      dataCompetencia: dataCompetencia,
      descricao: descricao,
      tipoOperacao: tipoOperacao,
      status: status,
      valor: valor,
      contaOrigemId: contaOrigemId,
      contaOrigemNome: contaOrigemNome,
      contaDestinoId: contaDestinoId,
      contaDestinoNome: contaDestinoNome,
      categoriaId: categoriaId,
      categoriaNome: categoriaNome,
      centroCustoId: centroCustoId,
      centroCustoNome: centroCustoNome,
      membroId: membroId,
      membroNome: membroNome,
      observacoes: observacoes,
      comprovativoUrl: comprovativoUrl,
    );
