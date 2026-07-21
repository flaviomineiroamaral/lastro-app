// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTDetalheDreCategoriaStruct extends BaseStruct {
  DTDetalheDreCategoriaStruct({
    String? transacaoId,
    String? descricao,
    double? valor,
    double? valorMovimento,
    String? tipoOperacao,
    String? status,
    DateTime? dataReferenciaDre,
    DateTime? dataVencimento,
    DateTime? dataPagamento,
    String? contaNome,
    String? tipoConta,
    String? centroCustoNome,
  })  : _transacaoId = transacaoId,
        _descricao = descricao,
        _valor = valor,
        _valorMovimento = valorMovimento,
        _tipoOperacao = tipoOperacao,
        _status = status,
        _dataReferenciaDre = dataReferenciaDre,
        _dataVencimento = dataVencimento,
        _dataPagamento = dataPagamento,
        _contaNome = contaNome,
        _tipoConta = tipoConta,
        _centroCustoNome = centroCustoNome;

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

  // "valorMovimento" field.
  double? _valorMovimento;
  double get valorMovimento => _valorMovimento ?? 0.0;
  set valorMovimento(double? val) => _valorMovimento = val;

  void incrementValorMovimento(double amount) =>
      valorMovimento = valorMovimento + amount;

  bool hasValorMovimento() => _valorMovimento != null;

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

  // "dataReferenciaDre" field.
  DateTime? _dataReferenciaDre;
  DateTime? get dataReferenciaDre => _dataReferenciaDre;
  set dataReferenciaDre(DateTime? val) => _dataReferenciaDre = val;

  bool hasDataReferenciaDre() => _dataReferenciaDre != null;

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

  // "centroCustoNome" field.
  String? _centroCustoNome;
  String get centroCustoNome => _centroCustoNome ?? '';
  set centroCustoNome(String? val) => _centroCustoNome = val;

  bool hasCentroCustoNome() => _centroCustoNome != null;

  static DTDetalheDreCategoriaStruct fromMap(Map<String, dynamic> data) =>
      DTDetalheDreCategoriaStruct(
        transacaoId: data['transacaoId'] as String?,
        descricao: data['descricao'] as String?,
        valor: castToType<double>(data['valor']),
        valorMovimento: castToType<double>(data['valorMovimento']),
        tipoOperacao: data['tipoOperacao'] as String?,
        status: data['status'] as String?,
        dataReferenciaDre: data['dataReferenciaDre'] as DateTime?,
        dataVencimento: data['dataVencimento'] as DateTime?,
        dataPagamento: data['dataPagamento'] as DateTime?,
        contaNome: data['contaNome'] as String?,
        tipoConta: data['tipo_conta'] as String?,
        centroCustoNome: data['centroCustoNome'] as String?,
      );

  static DTDetalheDreCategoriaStruct? maybeFromMap(dynamic data) => data is Map
      ? DTDetalheDreCategoriaStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'transacaoId': _transacaoId,
        'descricao': _descricao,
        'valor': _valor,
        'valorMovimento': _valorMovimento,
        'tipoOperacao': _tipoOperacao,
        'status': _status,
        'dataReferenciaDre': _dataReferenciaDre,
        'dataVencimento': _dataVencimento,
        'dataPagamento': _dataPagamento,
        'contaNome': _contaNome,
        'tipo_conta': _tipoConta,
        'centroCustoNome': _centroCustoNome,
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
        'valorMovimento': serializeParam(
          _valorMovimento,
          ParamType.double,
        ),
        'tipoOperacao': serializeParam(
          _tipoOperacao,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'dataReferenciaDre': serializeParam(
          _dataReferenciaDre,
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
        'centroCustoNome': serializeParam(
          _centroCustoNome,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTDetalheDreCategoriaStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTDetalheDreCategoriaStruct(
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
        valorMovimento: deserializeParam(
          data['valorMovimento'],
          ParamType.double,
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
        dataReferenciaDre: deserializeParam(
          data['dataReferenciaDre'],
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
        centroCustoNome: deserializeParam(
          data['centroCustoNome'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTDetalheDreCategoriaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTDetalheDreCategoriaStruct &&
        transacaoId == other.transacaoId &&
        descricao == other.descricao &&
        valor == other.valor &&
        valorMovimento == other.valorMovimento &&
        tipoOperacao == other.tipoOperacao &&
        status == other.status &&
        dataReferenciaDre == other.dataReferenciaDre &&
        dataVencimento == other.dataVencimento &&
        dataPagamento == other.dataPagamento &&
        contaNome == other.contaNome &&
        tipoConta == other.tipoConta &&
        centroCustoNome == other.centroCustoNome;
  }

  @override
  int get hashCode => const ListEquality().hash([
        transacaoId,
        descricao,
        valor,
        valorMovimento,
        tipoOperacao,
        status,
        dataReferenciaDre,
        dataVencimento,
        dataPagamento,
        contaNome,
        tipoConta,
        centroCustoNome
      ]);
}

DTDetalheDreCategoriaStruct createDTDetalheDreCategoriaStruct({
  String? transacaoId,
  String? descricao,
  double? valor,
  double? valorMovimento,
  String? tipoOperacao,
  String? status,
  DateTime? dataReferenciaDre,
  DateTime? dataVencimento,
  DateTime? dataPagamento,
  String? contaNome,
  String? tipoConta,
  String? centroCustoNome,
}) =>
    DTDetalheDreCategoriaStruct(
      transacaoId: transacaoId,
      descricao: descricao,
      valor: valor,
      valorMovimento: valorMovimento,
      tipoOperacao: tipoOperacao,
      status: status,
      dataReferenciaDre: dataReferenciaDre,
      dataVencimento: dataVencimento,
      dataPagamento: dataPagamento,
      contaNome: contaNome,
      tipoConta: tipoConta,
      centroCustoNome: centroCustoNome,
    );
