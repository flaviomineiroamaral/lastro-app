// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTResumoSaudeCRStruct extends BaseStruct {
  DTResumoSaudeCRStruct({
    int? qtdVerde,
    int? qtdAmarelo,
    int? qtdVermelho,
  })  : _qtdVerde = qtdVerde,
        _qtdAmarelo = qtdAmarelo,
        _qtdVermelho = qtdVermelho;

  // "qtdVerde" field.
  int? _qtdVerde;
  int get qtdVerde => _qtdVerde ?? 0;
  set qtdVerde(int? val) => _qtdVerde = val;

  void incrementQtdVerde(int amount) => qtdVerde = qtdVerde + amount;

  bool hasQtdVerde() => _qtdVerde != null;

  // "qtdAmarelo" field.
  int? _qtdAmarelo;
  int get qtdAmarelo => _qtdAmarelo ?? 0;
  set qtdAmarelo(int? val) => _qtdAmarelo = val;

  void incrementQtdAmarelo(int amount) => qtdAmarelo = qtdAmarelo + amount;

  bool hasQtdAmarelo() => _qtdAmarelo != null;

  // "qtdVermelho" field.
  int? _qtdVermelho;
  int get qtdVermelho => _qtdVermelho ?? 0;
  set qtdVermelho(int? val) => _qtdVermelho = val;

  void incrementQtdVermelho(int amount) => qtdVermelho = qtdVermelho + amount;

  bool hasQtdVermelho() => _qtdVermelho != null;

  static DTResumoSaudeCRStruct fromMap(Map<String, dynamic> data) =>
      DTResumoSaudeCRStruct(
        qtdVerde: castToType<int>(data['qtdVerde']),
        qtdAmarelo: castToType<int>(data['qtdAmarelo']),
        qtdVermelho: castToType<int>(data['qtdVermelho']),
      );

  static DTResumoSaudeCRStruct? maybeFromMap(dynamic data) => data is Map
      ? DTResumoSaudeCRStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'qtdVerde': _qtdVerde,
        'qtdAmarelo': _qtdAmarelo,
        'qtdVermelho': _qtdVermelho,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'qtdVerde': serializeParam(
          _qtdVerde,
          ParamType.int,
        ),
        'qtdAmarelo': serializeParam(
          _qtdAmarelo,
          ParamType.int,
        ),
        'qtdVermelho': serializeParam(
          _qtdVermelho,
          ParamType.int,
        ),
      }.withoutNulls;

  static DTResumoSaudeCRStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTResumoSaudeCRStruct(
        qtdVerde: deserializeParam(
          data['qtdVerde'],
          ParamType.int,
          false,
        ),
        qtdAmarelo: deserializeParam(
          data['qtdAmarelo'],
          ParamType.int,
          false,
        ),
        qtdVermelho: deserializeParam(
          data['qtdVermelho'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'DTResumoSaudeCRStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTResumoSaudeCRStruct &&
        qtdVerde == other.qtdVerde &&
        qtdAmarelo == other.qtdAmarelo &&
        qtdVermelho == other.qtdVermelho;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([qtdVerde, qtdAmarelo, qtdVermelho]);
}

DTResumoSaudeCRStruct createDTResumoSaudeCRStruct({
  int? qtdVerde,
  int? qtdAmarelo,
  int? qtdVermelho,
}) =>
    DTResumoSaudeCRStruct(
      qtdVerde: qtdVerde,
      qtdAmarelo: qtdAmarelo,
      qtdVermelho: qtdVermelho,
    );
