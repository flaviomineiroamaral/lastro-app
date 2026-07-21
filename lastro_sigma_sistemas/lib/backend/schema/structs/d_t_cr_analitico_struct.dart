// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTCrAnaliticoStruct extends BaseStruct {
  DTCrAnaliticoStruct({
    String? crId,
    String? crNome,
    String? corHex,
    bool? permiteAcumulo,
    double? despesaRealizada,
    double? receitaPropria,
    double? subsidioRecebido,
    double? subsidioConcedido,
    double? saldoCaixa,
    double? autossuficiencia,
    bool? isFundo,
    bool? isPadrao,
    bool? isAtivo,
  })  : _crId = crId,
        _crNome = crNome,
        _corHex = corHex,
        _permiteAcumulo = permiteAcumulo,
        _despesaRealizada = despesaRealizada,
        _receitaPropria = receitaPropria,
        _subsidioRecebido = subsidioRecebido,
        _subsidioConcedido = subsidioConcedido,
        _saldoCaixa = saldoCaixa,
        _autossuficiencia = autossuficiencia,
        _isFundo = isFundo,
        _isPadrao = isPadrao,
        _isAtivo = isAtivo;

  // "crId" field.
  String? _crId;
  String get crId => _crId ?? '';
  set crId(String? val) => _crId = val;

  bool hasCrId() => _crId != null;

  // "crNome" field.
  String? _crNome;
  String get crNome => _crNome ?? '';
  set crNome(String? val) => _crNome = val;

  bool hasCrNome() => _crNome != null;

  // "cor_hex" field.
  String? _corHex;
  String get corHex => _corHex ?? '';
  set corHex(String? val) => _corHex = val;

  bool hasCorHex() => _corHex != null;

  // "permite_acumulo" field.
  bool? _permiteAcumulo;
  bool get permiteAcumulo => _permiteAcumulo ?? false;
  set permiteAcumulo(bool? val) => _permiteAcumulo = val;

  bool hasPermiteAcumulo() => _permiteAcumulo != null;

  // "despesaRealizada" field.
  double? _despesaRealizada;
  double get despesaRealizada => _despesaRealizada ?? 0.0;
  set despesaRealizada(double? val) => _despesaRealizada = val;

  void incrementDespesaRealizada(double amount) =>
      despesaRealizada = despesaRealizada + amount;

  bool hasDespesaRealizada() => _despesaRealizada != null;

  // "receitaPropria" field.
  double? _receitaPropria;
  double get receitaPropria => _receitaPropria ?? 0.0;
  set receitaPropria(double? val) => _receitaPropria = val;

  void incrementReceitaPropria(double amount) =>
      receitaPropria = receitaPropria + amount;

  bool hasReceitaPropria() => _receitaPropria != null;

  // "subsidioRecebido" field.
  double? _subsidioRecebido;
  double get subsidioRecebido => _subsidioRecebido ?? 0.0;
  set subsidioRecebido(double? val) => _subsidioRecebido = val;

  void incrementSubsidioRecebido(double amount) =>
      subsidioRecebido = subsidioRecebido + amount;

  bool hasSubsidioRecebido() => _subsidioRecebido != null;

  // "subsidioConcedido" field.
  double? _subsidioConcedido;
  double get subsidioConcedido => _subsidioConcedido ?? 0.0;
  set subsidioConcedido(double? val) => _subsidioConcedido = val;

  void incrementSubsidioConcedido(double amount) =>
      subsidioConcedido = subsidioConcedido + amount;

  bool hasSubsidioConcedido() => _subsidioConcedido != null;

  // "saldoCaixa" field.
  double? _saldoCaixa;
  double get saldoCaixa => _saldoCaixa ?? 0.0;
  set saldoCaixa(double? val) => _saldoCaixa = val;

  void incrementSaldoCaixa(double amount) => saldoCaixa = saldoCaixa + amount;

  bool hasSaldoCaixa() => _saldoCaixa != null;

  // "autossuficiencia" field.
  double? _autossuficiencia;
  double get autossuficiencia => _autossuficiencia ?? 0.0;
  set autossuficiencia(double? val) => _autossuficiencia = val;

  void incrementAutossuficiencia(double amount) =>
      autossuficiencia = autossuficiencia + amount;

  bool hasAutossuficiencia() => _autossuficiencia != null;

  // "isFundo" field.
  bool? _isFundo;
  bool get isFundo => _isFundo ?? false;
  set isFundo(bool? val) => _isFundo = val;

  bool hasIsFundo() => _isFundo != null;

  // "isPadrao" field.
  bool? _isPadrao;
  bool get isPadrao => _isPadrao ?? false;
  set isPadrao(bool? val) => _isPadrao = val;

  bool hasIsPadrao() => _isPadrao != null;

  // "isAtivo" field.
  bool? _isAtivo;
  bool get isAtivo => _isAtivo ?? false;
  set isAtivo(bool? val) => _isAtivo = val;

  bool hasIsAtivo() => _isAtivo != null;

  static DTCrAnaliticoStruct fromMap(Map<String, dynamic> data) =>
      DTCrAnaliticoStruct(
        crId: data['crId'] as String?,
        crNome: data['crNome'] as String?,
        corHex: data['cor_hex'] as String?,
        permiteAcumulo: data['permite_acumulo'] as bool?,
        despesaRealizada: castToType<double>(data['despesaRealizada']),
        receitaPropria: castToType<double>(data['receitaPropria']),
        subsidioRecebido: castToType<double>(data['subsidioRecebido']),
        subsidioConcedido: castToType<double>(data['subsidioConcedido']),
        saldoCaixa: castToType<double>(data['saldoCaixa']),
        autossuficiencia: castToType<double>(data['autossuficiencia']),
        isFundo: data['isFundo'] as bool?,
        isPadrao: data['isPadrao'] as bool?,
        isAtivo: data['isAtivo'] as bool?,
      );

  static DTCrAnaliticoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTCrAnaliticoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'crId': _crId,
        'crNome': _crNome,
        'cor_hex': _corHex,
        'permite_acumulo': _permiteAcumulo,
        'despesaRealizada': _despesaRealizada,
        'receitaPropria': _receitaPropria,
        'subsidioRecebido': _subsidioRecebido,
        'subsidioConcedido': _subsidioConcedido,
        'saldoCaixa': _saldoCaixa,
        'autossuficiencia': _autossuficiencia,
        'isFundo': _isFundo,
        'isPadrao': _isPadrao,
        'isAtivo': _isAtivo,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'crId': serializeParam(
          _crId,
          ParamType.String,
        ),
        'crNome': serializeParam(
          _crNome,
          ParamType.String,
        ),
        'cor_hex': serializeParam(
          _corHex,
          ParamType.String,
        ),
        'permite_acumulo': serializeParam(
          _permiteAcumulo,
          ParamType.bool,
        ),
        'despesaRealizada': serializeParam(
          _despesaRealizada,
          ParamType.double,
        ),
        'receitaPropria': serializeParam(
          _receitaPropria,
          ParamType.double,
        ),
        'subsidioRecebido': serializeParam(
          _subsidioRecebido,
          ParamType.double,
        ),
        'subsidioConcedido': serializeParam(
          _subsidioConcedido,
          ParamType.double,
        ),
        'saldoCaixa': serializeParam(
          _saldoCaixa,
          ParamType.double,
        ),
        'autossuficiencia': serializeParam(
          _autossuficiencia,
          ParamType.double,
        ),
        'isFundo': serializeParam(
          _isFundo,
          ParamType.bool,
        ),
        'isPadrao': serializeParam(
          _isPadrao,
          ParamType.bool,
        ),
        'isAtivo': serializeParam(
          _isAtivo,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DTCrAnaliticoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTCrAnaliticoStruct(
        crId: deserializeParam(
          data['crId'],
          ParamType.String,
          false,
        ),
        crNome: deserializeParam(
          data['crNome'],
          ParamType.String,
          false,
        ),
        corHex: deserializeParam(
          data['cor_hex'],
          ParamType.String,
          false,
        ),
        permiteAcumulo: deserializeParam(
          data['permite_acumulo'],
          ParamType.bool,
          false,
        ),
        despesaRealizada: deserializeParam(
          data['despesaRealizada'],
          ParamType.double,
          false,
        ),
        receitaPropria: deserializeParam(
          data['receitaPropria'],
          ParamType.double,
          false,
        ),
        subsidioRecebido: deserializeParam(
          data['subsidioRecebido'],
          ParamType.double,
          false,
        ),
        subsidioConcedido: deserializeParam(
          data['subsidioConcedido'],
          ParamType.double,
          false,
        ),
        saldoCaixa: deserializeParam(
          data['saldoCaixa'],
          ParamType.double,
          false,
        ),
        autossuficiencia: deserializeParam(
          data['autossuficiencia'],
          ParamType.double,
          false,
        ),
        isFundo: deserializeParam(
          data['isFundo'],
          ParamType.bool,
          false,
        ),
        isPadrao: deserializeParam(
          data['isPadrao'],
          ParamType.bool,
          false,
        ),
        isAtivo: deserializeParam(
          data['isAtivo'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DTCrAnaliticoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTCrAnaliticoStruct &&
        crId == other.crId &&
        crNome == other.crNome &&
        corHex == other.corHex &&
        permiteAcumulo == other.permiteAcumulo &&
        despesaRealizada == other.despesaRealizada &&
        receitaPropria == other.receitaPropria &&
        subsidioRecebido == other.subsidioRecebido &&
        subsidioConcedido == other.subsidioConcedido &&
        saldoCaixa == other.saldoCaixa &&
        autossuficiencia == other.autossuficiencia &&
        isFundo == other.isFundo &&
        isPadrao == other.isPadrao &&
        isAtivo == other.isAtivo;
  }

  @override
  int get hashCode => const ListEquality().hash([
        crId,
        crNome,
        corHex,
        permiteAcumulo,
        despesaRealizada,
        receitaPropria,
        subsidioRecebido,
        subsidioConcedido,
        saldoCaixa,
        autossuficiencia,
        isFundo,
        isPadrao,
        isAtivo
      ]);
}

DTCrAnaliticoStruct createDTCrAnaliticoStruct({
  String? crId,
  String? crNome,
  String? corHex,
  bool? permiteAcumulo,
  double? despesaRealizada,
  double? receitaPropria,
  double? subsidioRecebido,
  double? subsidioConcedido,
  double? saldoCaixa,
  double? autossuficiencia,
  bool? isFundo,
  bool? isPadrao,
  bool? isAtivo,
}) =>
    DTCrAnaliticoStruct(
      crId: crId,
      crNome: crNome,
      corHex: corHex,
      permiteAcumulo: permiteAcumulo,
      despesaRealizada: despesaRealizada,
      receitaPropria: receitaPropria,
      subsidioRecebido: subsidioRecebido,
      subsidioConcedido: subsidioConcedido,
      saldoCaixa: saldoCaixa,
      autossuficiencia: autossuficiencia,
      isFundo: isFundo,
      isPadrao: isPadrao,
      isAtivo: isAtivo,
    );
