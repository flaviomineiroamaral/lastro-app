// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTResumoContasAPagarReceberStruct extends BaseStruct {
  DTResumoContasAPagarReceberStruct({
    double? totalPagar,
    double? totalPagarAtrasado,
    double? totalPagarHoje,
    double? totalPagarVencer,
    double? totalReceber,
    double? totalReceberAtrasado,
    double? totalReceberHoje,
    double? totalReceberVencer,
  })  : _totalPagar = totalPagar,
        _totalPagarAtrasado = totalPagarAtrasado,
        _totalPagarHoje = totalPagarHoje,
        _totalPagarVencer = totalPagarVencer,
        _totalReceber = totalReceber,
        _totalReceberAtrasado = totalReceberAtrasado,
        _totalReceberHoje = totalReceberHoje,
        _totalReceberVencer = totalReceberVencer;

  // "totalPagar" field.
  double? _totalPagar;
  double get totalPagar => _totalPagar ?? 0.0;
  set totalPagar(double? val) => _totalPagar = val;

  void incrementTotalPagar(double amount) => totalPagar = totalPagar + amount;

  bool hasTotalPagar() => _totalPagar != null;

  // "totalPagarAtrasado" field.
  double? _totalPagarAtrasado;
  double get totalPagarAtrasado => _totalPagarAtrasado ?? 0.0;
  set totalPagarAtrasado(double? val) => _totalPagarAtrasado = val;

  void incrementTotalPagarAtrasado(double amount) =>
      totalPagarAtrasado = totalPagarAtrasado + amount;

  bool hasTotalPagarAtrasado() => _totalPagarAtrasado != null;

  // "totalPagarHoje" field.
  double? _totalPagarHoje;
  double get totalPagarHoje => _totalPagarHoje ?? 0.0;
  set totalPagarHoje(double? val) => _totalPagarHoje = val;

  void incrementTotalPagarHoje(double amount) =>
      totalPagarHoje = totalPagarHoje + amount;

  bool hasTotalPagarHoje() => _totalPagarHoje != null;

  // "totalPagarVencer" field.
  double? _totalPagarVencer;
  double get totalPagarVencer => _totalPagarVencer ?? 0.0;
  set totalPagarVencer(double? val) => _totalPagarVencer = val;

  void incrementTotalPagarVencer(double amount) =>
      totalPagarVencer = totalPagarVencer + amount;

  bool hasTotalPagarVencer() => _totalPagarVencer != null;

  // "totalReceber" field.
  double? _totalReceber;
  double get totalReceber => _totalReceber ?? 0.0;
  set totalReceber(double? val) => _totalReceber = val;

  void incrementTotalReceber(double amount) =>
      totalReceber = totalReceber + amount;

  bool hasTotalReceber() => _totalReceber != null;

  // "totalReceberAtrasado" field.
  double? _totalReceberAtrasado;
  double get totalReceberAtrasado => _totalReceberAtrasado ?? 0.0;
  set totalReceberAtrasado(double? val) => _totalReceberAtrasado = val;

  void incrementTotalReceberAtrasado(double amount) =>
      totalReceberAtrasado = totalReceberAtrasado + amount;

  bool hasTotalReceberAtrasado() => _totalReceberAtrasado != null;

  // "totalReceberHoje" field.
  double? _totalReceberHoje;
  double get totalReceberHoje => _totalReceberHoje ?? 0.0;
  set totalReceberHoje(double? val) => _totalReceberHoje = val;

  void incrementTotalReceberHoje(double amount) =>
      totalReceberHoje = totalReceberHoje + amount;

  bool hasTotalReceberHoje() => _totalReceberHoje != null;

  // "totalReceberVencer" field.
  double? _totalReceberVencer;
  double get totalReceberVencer => _totalReceberVencer ?? 0.0;
  set totalReceberVencer(double? val) => _totalReceberVencer = val;

  void incrementTotalReceberVencer(double amount) =>
      totalReceberVencer = totalReceberVencer + amount;

  bool hasTotalReceberVencer() => _totalReceberVencer != null;

  static DTResumoContasAPagarReceberStruct fromMap(Map<String, dynamic> data) =>
      DTResumoContasAPagarReceberStruct(
        totalPagar: castToType<double>(data['totalPagar']),
        totalPagarAtrasado: castToType<double>(data['totalPagarAtrasado']),
        totalPagarHoje: castToType<double>(data['totalPagarHoje']),
        totalPagarVencer: castToType<double>(data['totalPagarVencer']),
        totalReceber: castToType<double>(data['totalReceber']),
        totalReceberAtrasado: castToType<double>(data['totalReceberAtrasado']),
        totalReceberHoje: castToType<double>(data['totalReceberHoje']),
        totalReceberVencer: castToType<double>(data['totalReceberVencer']),
      );

  static DTResumoContasAPagarReceberStruct? maybeFromMap(dynamic data) => data
          is Map
      ? DTResumoContasAPagarReceberStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalPagar': _totalPagar,
        'totalPagarAtrasado': _totalPagarAtrasado,
        'totalPagarHoje': _totalPagarHoje,
        'totalPagarVencer': _totalPagarVencer,
        'totalReceber': _totalReceber,
        'totalReceberAtrasado': _totalReceberAtrasado,
        'totalReceberHoje': _totalReceberHoje,
        'totalReceberVencer': _totalReceberVencer,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalPagar': serializeParam(
          _totalPagar,
          ParamType.double,
        ),
        'totalPagarAtrasado': serializeParam(
          _totalPagarAtrasado,
          ParamType.double,
        ),
        'totalPagarHoje': serializeParam(
          _totalPagarHoje,
          ParamType.double,
        ),
        'totalPagarVencer': serializeParam(
          _totalPagarVencer,
          ParamType.double,
        ),
        'totalReceber': serializeParam(
          _totalReceber,
          ParamType.double,
        ),
        'totalReceberAtrasado': serializeParam(
          _totalReceberAtrasado,
          ParamType.double,
        ),
        'totalReceberHoje': serializeParam(
          _totalReceberHoje,
          ParamType.double,
        ),
        'totalReceberVencer': serializeParam(
          _totalReceberVencer,
          ParamType.double,
        ),
      }.withoutNulls;

  static DTResumoContasAPagarReceberStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DTResumoContasAPagarReceberStruct(
        totalPagar: deserializeParam(
          data['totalPagar'],
          ParamType.double,
          false,
        ),
        totalPagarAtrasado: deserializeParam(
          data['totalPagarAtrasado'],
          ParamType.double,
          false,
        ),
        totalPagarHoje: deserializeParam(
          data['totalPagarHoje'],
          ParamType.double,
          false,
        ),
        totalPagarVencer: deserializeParam(
          data['totalPagarVencer'],
          ParamType.double,
          false,
        ),
        totalReceber: deserializeParam(
          data['totalReceber'],
          ParamType.double,
          false,
        ),
        totalReceberAtrasado: deserializeParam(
          data['totalReceberAtrasado'],
          ParamType.double,
          false,
        ),
        totalReceberHoje: deserializeParam(
          data['totalReceberHoje'],
          ParamType.double,
          false,
        ),
        totalReceberVencer: deserializeParam(
          data['totalReceberVencer'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DTResumoContasAPagarReceberStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTResumoContasAPagarReceberStruct &&
        totalPagar == other.totalPagar &&
        totalPagarAtrasado == other.totalPagarAtrasado &&
        totalPagarHoje == other.totalPagarHoje &&
        totalPagarVencer == other.totalPagarVencer &&
        totalReceber == other.totalReceber &&
        totalReceberAtrasado == other.totalReceberAtrasado &&
        totalReceberHoje == other.totalReceberHoje &&
        totalReceberVencer == other.totalReceberVencer;
  }

  @override
  int get hashCode => const ListEquality().hash([
        totalPagar,
        totalPagarAtrasado,
        totalPagarHoje,
        totalPagarVencer,
        totalReceber,
        totalReceberAtrasado,
        totalReceberHoje,
        totalReceberVencer
      ]);
}

DTResumoContasAPagarReceberStruct createDTResumoContasAPagarReceberStruct({
  double? totalPagar,
  double? totalPagarAtrasado,
  double? totalPagarHoje,
  double? totalPagarVencer,
  double? totalReceber,
  double? totalReceberAtrasado,
  double? totalReceberHoje,
  double? totalReceberVencer,
}) =>
    DTResumoContasAPagarReceberStruct(
      totalPagar: totalPagar,
      totalPagarAtrasado: totalPagarAtrasado,
      totalPagarHoje: totalPagarHoje,
      totalPagarVencer: totalPagarVencer,
      totalReceber: totalReceber,
      totalReceberAtrasado: totalReceberAtrasado,
      totalReceberHoje: totalReceberHoje,
      totalReceberVencer: totalReceberVencer,
    );
