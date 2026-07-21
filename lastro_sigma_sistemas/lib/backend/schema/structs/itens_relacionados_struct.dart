// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ItensRelacionadosStruct extends BaseStruct {
  ItensRelacionadosStruct({
    String? id,
    String? descricao,
    DateTime? dataVencimento,
    double? valor,
    bool? selecionado,
  })  : _id = id,
        _descricao = descricao,
        _dataVencimento = dataVencimento,
        _valor = valor,
        _selecionado = selecionado;

  // "Id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "Descricao" field.
  String? _descricao;
  String get descricao => _descricao ?? '';
  set descricao(String? val) => _descricao = val;

  bool hasDescricao() => _descricao != null;

  // "DataVencimento" field.
  DateTime? _dataVencimento;
  DateTime? get dataVencimento => _dataVencimento;
  set dataVencimento(DateTime? val) => _dataVencimento = val;

  bool hasDataVencimento() => _dataVencimento != null;

  // "Valor" field.
  double? _valor;
  double get valor => _valor ?? 0.0;
  set valor(double? val) => _valor = val;

  void incrementValor(double amount) => valor = valor + amount;

  bool hasValor() => _valor != null;

  // "Selecionado" field.
  bool? _selecionado;
  bool get selecionado => _selecionado ?? false;
  set selecionado(bool? val) => _selecionado = val;

  bool hasSelecionado() => _selecionado != null;

  static ItensRelacionadosStruct fromMap(Map<String, dynamic> data) =>
      ItensRelacionadosStruct(
        id: data['Id'] as String?,
        descricao: data['Descricao'] as String?,
        dataVencimento: data['DataVencimento'] as DateTime?,
        valor: castToType<double>(data['Valor']),
        selecionado: data['Selecionado'] as bool?,
      );

  static ItensRelacionadosStruct? maybeFromMap(dynamic data) => data is Map
      ? ItensRelacionadosStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Id': _id,
        'Descricao': _descricao,
        'DataVencimento': _dataVencimento,
        'Valor': _valor,
        'Selecionado': _selecionado,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Id': serializeParam(
          _id,
          ParamType.String,
        ),
        'Descricao': serializeParam(
          _descricao,
          ParamType.String,
        ),
        'DataVencimento': serializeParam(
          _dataVencimento,
          ParamType.DateTime,
        ),
        'Valor': serializeParam(
          _valor,
          ParamType.double,
        ),
        'Selecionado': serializeParam(
          _selecionado,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ItensRelacionadosStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ItensRelacionadosStruct(
        id: deserializeParam(
          data['Id'],
          ParamType.String,
          false,
        ),
        descricao: deserializeParam(
          data['Descricao'],
          ParamType.String,
          false,
        ),
        dataVencimento: deserializeParam(
          data['DataVencimento'],
          ParamType.DateTime,
          false,
        ),
        valor: deserializeParam(
          data['Valor'],
          ParamType.double,
          false,
        ),
        selecionado: deserializeParam(
          data['Selecionado'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ItensRelacionadosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ItensRelacionadosStruct &&
        id == other.id &&
        descricao == other.descricao &&
        dataVencimento == other.dataVencimento &&
        valor == other.valor &&
        selecionado == other.selecionado;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, descricao, dataVencimento, valor, selecionado]);
}

ItensRelacionadosStruct createItensRelacionadosStruct({
  String? id,
  String? descricao,
  DateTime? dataVencimento,
  double? valor,
  bool? selecionado,
}) =>
    ItensRelacionadosStruct(
      id: id,
      descricao: descricao,
      dataVencimento: dataVencimento,
      valor: valor,
      selecionado: selecionado,
    );
