import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class LerFaturaGeminiCall {
  static Future<ApiCallResponse> call({
    String? textoFatura = '',
  }) async {
    final ffApiRequestBody = '''
{
  "contents": [
    {
      "parts": [
        {
          "text": "Você é um extrator de dados financeiros sênior. Vou fornecer os dados da fatura em texto bruto. Extraia APENAS as compras confirmadas e devolva EXCLUSIVAMENTE um array JSON. REGRAS RÍGIDAS: 1. 'date': Data exata da COMPRA. ATENÇÃO: Se a fatura mostrar apenas dia/mês (ex: 12/01), deduza o ano usando o vencimento da fatura. É PROIBIDO usar a data de vencimento como data da compra. Formato 'AAAA-MM-DDT00:00:00.000Z'. 2. 'dueDate': Data de VENCIMENTO DA FATURA. Se não achar, null. Formato 'AAAA-MM-DDT00:00:00.000Z'. 3. 'description': Nome do estabelecimento. 4. 'amount': Valor decimal usando ponto (Ex: 150.50). 5. IGNORE: pagamentos, simulações, juros, saldos. 6. Devolva apenas o [ { ... } ]. 7. 'categoria_sugerida': Infira uma categoria genérica (Ex: Alimentação, Transporte, Saúde, Serviços) baseada na descrição.\\n\\nCONTEÚDO DA FATURA:\\n${escapeStringForJson(textoFatura)}"
        }
      ]
    }
  ],
  "generationConfig": {
    "responseMimeType": "application/json"
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'LerFaturaGemini',
      apiUrl:
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyAq1Jk05mwvVbOtBnlqaviKbYkNb9B0ss0',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic? resultadoExtraido(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class LerFaturaGeminiVisualCall {
  static Future<ApiCallResponse> call({
    String? pdfBase64 = '',
  }) async {
    final ffApiRequestBody = '''
{
  "contents": [
    {
      "parts": [
        {
          "text": "Você é um extrator de dados financeiros sênior. Vou fornecer um arquivo PDF. Leia visualmente. Extraia APENAS as compras confirmadas e devolva EXCLUSIVAMENTE um array JSON. REGRAS RÍGIDAS: 1. 'date': Data exata da COMPRA. ATENÇÃO: Se a fatura mostrar apenas dia/mês (ex: 12/01), deduza o ano usando o vencimento da fatura. É PROIBIDO usar a data de vencimento como data da compra. Formato 'AAAA-MM-DDT00:00:00.000Z'. 2. 'dueDate': Data de VENCIMENTO DA FATURA. Se não achar, null. Formato 'AAAA-MM-DDT00:00:00.000Z'. 3. 'description': Nome do estabelecimento. 4. 'amount': Valor decimal usando ponto (Ex: 150.50). 5. IGNORE: pagamentos, simulações, juros, saldos. 6. Devolva apenas o [ { ... } ]. 7. 'categoria_sugerida': Infira uma categoria genérica (Ex: Alimentação, Transporte, Saúde, Serviços) baseada na descrição."
        },
        {
          "inlineData": {
            "mimeType": "application/pdf",
            "data": "${escapeStringForJson(pdfBase64)}"
          }
        }
      ]
    }
  ],
  "generationConfig": {
    "responseMimeType": "application/json"
  }
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'LerFaturaGeminiVisual',
      apiUrl:
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyAq1Jk05mwvVbOtBnlqaviKbYkNb9B0ss0',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic? resultadoExtraido(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
