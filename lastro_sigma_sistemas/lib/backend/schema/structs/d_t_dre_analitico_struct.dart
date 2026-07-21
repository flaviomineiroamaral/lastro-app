// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTDreAnaliticoStruct extends BaseStruct {
  DTDreAnaliticoStruct({
    String? idConta,
    String? codigo,
    String? nome,
    String? tipo,
    bool? isSintetica,
    int? nivel,
    double? valorTotal,
    double? analiseVertical,
  })  : _idConta = idConta,
        _codigo = codigo,
        _nome = nome,
        _tipo = tipo,
        _isSintetica = isSintetica,
        _nivel = nivel,
        _valorTotal = valorTotal,
        _analiseVertical = analiseVertical;

  // "idConta" field.
  String? _idConta;
  String get idConta => _idConta ?? '';
  set idConta(String? val) => _idConta = val;

  bool hasIdConta() => _idConta != null;

  // "codigo" field.
  String? _codigo;
  String get codigo => _codigo ?? '';
  set codigo(String? val) => _codigo = val;

  bool hasCodigo() => _codigo != null;

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

  // "isSintetica" field.
  bool? _isSintetica;
  bool get isSintetica => _isSintetica ?? false;
  set isSintetica(bool? val) => _isSintetica = val;

  bool hasIsSintetica() => _isSintetica != null;

  // "nivel" field.
  int? _nivel;
  int get nivel => _nivel ?? 0;
  set nivel(int? val) => _nivel = val;

  void incrementNivel(int amount) => nivel = nivel + amount;

  bool hasNivel() => _nivel != null;

  // "valorTotal" field.
  double? _valorTotal;
  double get valorTotal => _valorTotal ?? 0.0;
  set valorTotal(double? val) => _valorTotal = val;

  void incrementValorTotal(double amount) => valorTotal = valorTotal + amount;

  bool hasValorTotal() => _valorTotal != null;

  // "analiseVertical" field.
  double? _analiseVertical;
  double get analiseVertical => _analiseVertical ?? 0.0;
  set analiseVertical(double? val) => _analiseVertical = val;

  void incrementAnaliseVertical(double amount) =>
      analiseVertical = analiseVertical + amount;

  bool hasAnaliseVertical() => _analiseVertical != null;

  static DTDreAnaliticoStruct fromMap(Map<String, dynamic> data) =>
      DTDreAnaliticoStruct(
        idConta: data['idConta'] as String?,
        codigo: data['codigo'] as String?,
        nome: data['nome'] as String?,
        tipo: data['tipo'] as String?,
        isSintetica: data['isSintetica'] as bool?,
        nivel: castToType<int>(data['nivel']),
        valorTotal: castToType<double>(data['valorTotal']),
        analiseVertical: castToType<double>(data['analiseVertical']),
      );

  static DTDreAnaliticoStruct? maybeFromMap(dynamic data) => data is Map
      ? DTDreAnaliticoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'idConta': _idConta,
        'codigo': _codigo,
        'nome': _nome,
        'tipo': _tipo,
        'isSintetica': _isSintetica,
        'nivel': _nivel,
        'valorTotal': _valorTotal,
        'analiseVertical': _analiseVertical,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'idConta': serializeParam(
          _idConta,
          ParamType.String,
        ),
        'codigo': serializeParam(
          _codigo,
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
        'isSintetica': serializeParam(
          _isSintetica,
          ParamType.bool,
        ),
        'nivel': serializeParam(
          _nivel,
          ParamType.int,
        ),
        'valorTotal': serializeParam(
          _valorTotal,
          ParamType.double,
        ),
        'analiseVertical': serializeParam(
          _analiseVertical,
          ParamType.double,
        ),
      }.withoutNulls;

  static DTDreAnaliticoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTDreAnaliticoStruct(
        idConta: deserializeParam(
          data['idConta'],
          ParamType.String,
          false,
        ),
        codigo: deserializeParam(
          data['codigo'],
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
        isSintetica: deserializeParam(
          data['isSintetica'],
          ParamType.bool,
          false,
        ),
        nivel: deserializeParam(
          data['nivel'],
          ParamType.int,
          false,
        ),
        valorTotal: deserializeParam(
          data['valorTotal'],
          ParamType.double,
          false,
        ),
        analiseVertical: deserializeParam(
          data['analiseVertical'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'DTDreAnaliticoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTDreAnaliticoStruct &&
        idConta == other.idConta &&
        codigo == other.codigo &&
        nome == other.nome &&
        tipo == other.tipo &&
        isSintetica == other.isSintetica &&
        nivel == other.nivel &&
        valorTotal == other.valorTotal &&
        analiseVertical == other.analiseVertical;
  }

  @override
  int get hashCode => const ListEquality().hash([
        idConta,
        codigo,
        nome,
        tipo,
        isSintetica,
        nivel,
        valorTotal,
        analiseVertical
      ]);
}

DTDreAnaliticoStruct createDTDreAnaliticoStruct({
  String? idConta,
  String? codigo,
  String? nome,
  String? tipo,
  bool? isSintetica,
  int? nivel,
  double? valorTotal,
  double? analiseVertical,
}) =>
    DTDreAnaliticoStruct(
      idConta: idConta,
      codigo: codigo,
      nome: nome,
      tipo: tipo,
      isSintetica: isSintetica,
      nivel: nivel,
      valorTotal: valorTotal,
      analiseVertical: analiseVertical,
    );
