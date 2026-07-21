// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTExtratoPeriodoStruct extends BaseStruct {
  DTExtratoPeriodoStruct({
    String? transacaoId,
    DateTime? dataLinhaTempo,
    String? descricao,
    String? categoriaNome,
    double? valorMovimento,
    double? saldoProgressivo,
    String? tipoOperacao,
    String? status,
    DateTime? dataCompetencia,
    String? comprovativoUrl,
  })  : _transacaoId = transacaoId,
        _dataLinhaTempo = dataLinhaTempo,
        _descricao = descricao,
        _categoriaNome = categoriaNome,
        _valorMovimento = valorMovimento,
        _saldoProgressivo = saldoProgressivo,
        _tipoOperacao = tipoOperacao,
        _status = status,
        _dataCompetencia = dataCompetencia,
        _comprovativoUrl = comprovativoUrl;

  // "transacaoId" field.
  String? _transacaoId;
  String get transacaoId => _transacaoId ?? '';
  set transacaoId(String? val) => _transacaoId = val;

  bool hasTransacaoId() => _transacaoId != null;

  // "dataLinhaTempo" field.
  DateTime? _dataLinhaTempo;
  DateTime? get dataLinhaTempo => _dataLinhaTempo;
  set dataLinhaTempo(DateTime? val) => _dataLinhaTempo = val;

  bool hasDataLinhaTempo() => _dataLinhaTempo != null;

  // "descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "categoriaNome" field.
  String? _categoriaNome;
  String get categoriaNome => _categoriaNome ?? '';
  set categoriaNome(String? val) => _categoriaNome = val;

  bool hasCategoriaNome() => _categoriaNome != null;

  // "valorMovimento" field.
  double? _valorMovimento;
  double get valorMovimento => _valorMovimento ?? 0.0;
  set valorMovimento(double? val) => _valorMovimento = val;

  void incrementValorMovimento(double amount) =>
      valorMovimento = valorMovimento + amount;

  bool hasValorMovimento() => _valorMovimento != null;

  // "saldoProgressivo" field.
  double? _saldoProgressivo;
  double get saldoProgressivo => _saldoProgressivo ?? 0.0;
  set saldoProgressivo(double? val) => _saldoProgressivo = val;

  void incrementSaldoProgressivo(double amount) =>
      saldoProgressivo = saldoProgressivo + amount;

  bool hasSaldoProgressivo() => _saldoProgressivo != null;

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

  // "dataCompetencia" field.
  DateTime? _dataCompetencia;
  DateTime? get dataCompetencia => _dataCompetencia;
  set dataCompetencia(DateTime? val) => _dataCompetencia = val;

  bool hasDataCompetencia() => _dataCompetencia != null;

  // "comprovativoUrl" field.
  String? _comprovativoUrl;
  String get comprovativoUrl => _comprovativoUrl ?? '';
  set comprovativoUrl(String? val) => _comprovativoUrl = val;

  bool hasComprovativoUrl() => _comprovativoUrl != null;

  static DTExtratoPeriodoStruct fromMap(Map<String, dynamic> data) =>
      DTExtratoPeriodoStruct(
        transacaoId: data['transacaoId'] as String?,
        dataLinhaTempo: data['dataLinhaTempo'] as DateTime?,
        descricao: data['descricao'] as String?,
        categoriaNome: data['categoriaNome'] as String?,
        valorMovimento: castToType<double>(data['valorMovimento']),
        saldoProgressivo: castToType<double>(data['saldoProgressivo']),
        tipoOperacao: data['tipoOperacao'] as String?,
        status: data['status'] as String?,
        dataCompetencia: data['dataCompetencia'] as DateTime?,
        comprovativoUrl: data['comprovativoUrl'] as String?,
      );

  static DTExtratoPeriodoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTExtratoPeriodoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'transacaoId': _transacaoId,
        'dataLinhaTempo': _dataLinhaTempo,
        'descricao': _descricao,
        'categoriaNome': _categoriaNome,
        'valorMovimento': _valorMovimento,
        'saldoProgressivo': _saldoProgressivo,
        'tipoOperacao': _tipoOperacao,
        'status': _status,
        'dataCompetencia': _dataCompetencia,
        'comprovativoUrl': _comprovativoUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'transacaoId': serializeParam(
          _transacaoId,
          ParamType.String,
        ),
        'dataLinhaTempo': serializeParam(
          _dataLinhaTempo,
          ParamType.DateTime,
        ),
        'descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'categoriaNome': serializeParam(
          _categoriaNome,
          ParamType.String,
        ),
        'valorMovimento': serializeParam(
          _valorMovimento,
          ParamType.double,
        ),
        'saldoProgressivo': serializeParam(
          _saldoProgressivo,
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
        'dataCompetencia': serializeParam(
          _dataCompetencia,
          ParamType.DateTime,
        ),
        'comprovativoUrl': serializeParam(
          _comprovativoUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTExtratoPeriodoStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTExtratoPeriodoStruct(
        transacaoId: deserializeParam(
          data['transacaoId'],
          ParamType.String,
          false,
        ),
        dataLinhaTempo: deserializeParam(
          data['dataLinhaTempo'],
          ParamType.DateTime,
          false,
        ),
        descricao: deserializeParam(
          data['descricao'],
          ParamType.String,
          false,
        ),
        categoriaNome: deserializeParam(
          data['categoriaNome'],
          ParamType.String,
          false,
        ),
        valorMovimento: deserializeParam(
          data['valorMovimento'],
          ParamType.double,
          false,
        ),
        saldoProgressivo: deserializeParam(
          data['saldoProgressivo'],
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
        dataCompetencia: deserializeParam(
          data['dataCompetencia'],
          ParamType.DateTime,
          false,
        ),
        comprovativoUrl: deserializeParam(
          data['comprovativoUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTExtratoPeriodoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTExtratoPeriodoStruct &&
        transacaoId == other.transacaoId &&
        dataLinhaTempo == other.dataLinhaTempo &&
        descricao == other.descricao &&
        categoriaNome == other.categoriaNome &&
        valorMovimento == other.valorMovimento &&
        saldoProgressivo == other.saldoProgressivo &&
        tipoOperacao == other.tipoOperacao &&
        status == other.status &&
        dataCompetencia == other.dataCompetencia &&
        comprovativoUrl == other.comprovativoUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([
        transacaoId,
        dataLinhaTempo,
        descricao,
        categoriaNome,
        valorMovimento,
        saldoProgressivo,
        tipoOperacao,
        status,
        dataCompetencia,
        comprovativoUrl
      ]);
}

DTExtratoPeriodoStruct createDTExtratoPeriodoStruct({
  String? transacaoId,
  DateTime? dataLinhaTempo,
  String? descricao,
  String? categoriaNome,
  double? valorMovimento,
  double? saldoProgressivo,
  String? tipoOperacao,
  String? status,
  DateTime? dataCompetencia,
  String? comprovativoUrl,
}) =>
    DTExtratoPeriodoStruct(
      transacaoId: transacaoId,
      dataLinhaTempo: dataLinhaTempo,
      descricao: descricao,
      categoriaNome: categoriaNome,
      valorMovimento: valorMovimento,
      saldoProgressivo: saldoProgressivo,
      tipoOperacao: tipoOperacao,
      status: status,
      dataCompetencia: dataCompetencia,
      comprovativoUrl: comprovativoUrl,
    );
