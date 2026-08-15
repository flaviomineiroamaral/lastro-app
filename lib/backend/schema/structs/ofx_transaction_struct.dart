// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OfxTransactionStruct extends BaseStruct {
  OfxTransactionStruct({
    double? amount,
    String? description,
    DateTime? date,
    DateTime? dueDate,

    /// CREDITO ou DEBITO
    String? type,

    /// ID unico
    String? fitid,
    bool? selecionado,
  })  : _amount = amount,
        _description = description,
        _date = date,
        _dueDate = dueDate,
        _type = type,
        _fitid = fitid,
        _selecionado = selecionado;

  // "amount" field.
  double? _amount;
  double get amount => _amount ?? 0.0;
  set amount(double? val) => _amount = val;

  void incrementAmount(double amount) => amount = amount + amount;

  bool hasAmount() => _amount != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? val) => _date = val;

  bool hasDate() => _date != null;

  // "dueDate" field.
  DateTime? _dueDate;
  DateTime? get dueDate => _dueDate;
  set dueDate(DateTime? val) => _dueDate = val;

  bool hasDueDate() => _dueDate != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "fitid" field.
  String? _fitid;
  String get fitid => _fitid ?? '';
  set fitid(String? val) => _fitid = val;

  bool hasFitid() => _fitid != null;

  // "selecionado" field.
  bool? _selecionado;
  bool get selecionado => _selecionado ?? false;
  set selecionado(bool? val) => _selecionado = val;

  bool hasSelecionado() => _selecionado != null;

  static OfxTransactionStruct fromMap(Map<String, dynamic> data) =>
      OfxTransactionStruct(
        amount: castToType<double>(data['amount']),
        description: data['description'] as String?,
        date: data['date'] as DateTime?,
        dueDate: data['dueDate'] as DateTime?,
        type: data['type'] as String?,
        fitid: data['fitid'] as String?,
        selecionado: data['selecionado'] as bool?,
      );

  static OfxTransactionStruct? maybeFromMap(dynamic data) => data is Map
      ? OfxTransactionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'amount': _amount,
        'description': _description,
        'date': _date,
        'dueDate': _dueDate,
        'type': _type,
        'fitid': _fitid,
        'selecionado': _selecionado,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'amount': serializeParam(
          _amount,
          ParamType.double,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'date': serializeParam(
          _date,
          ParamType.DateTime,
        ),
        'dueDate': serializeParam(
          _dueDate,
          ParamType.DateTime,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'fitid': serializeParam(
          _fitid,
          ParamType.String,
        ),
        'selecionado': serializeParam(
          _selecionado,
          ParamType.bool,
        ),
      }.withoutNulls;

  static OfxTransactionStruct fromSerializableMap(Map<String, dynamic> data) =>
      OfxTransactionStruct(
        amount: deserializeParam(
          data['amount'],
          ParamType.double,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
        dueDate: deserializeParam(
          data['dueDate'],
          ParamType.DateTime,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        fitid: deserializeParam(
          data['fitid'],
          ParamType.String,
          false,
        ),
        selecionado: deserializeParam(
          data['selecionado'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'OfxTransactionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OfxTransactionStruct &&
        amount == other.amount &&
        description == other.description &&
        date == other.date &&
        dueDate == other.dueDate &&
        type == other.type &&
        fitid == other.fitid &&
        selecionado == other.selecionado;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([amount, description, date, dueDate, type, fitid, selecionado]);
}

OfxTransactionStruct createOfxTransactionStruct({
  double? amount,
  String? description,
  DateTime? date,
  DateTime? dueDate,
  String? type,
  String? fitid,
  bool? selecionado,
}) =>
    OfxTransactionStruct(
      amount: amount,
      description: description,
      date: date,
      dueDate: dueDate,
      type: type,
      fitid: fitid,
      selecionado: selecionado,
    );
