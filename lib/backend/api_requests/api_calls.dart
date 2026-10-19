import 'dart:convert';

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
          "text": "Você é um extrator de dados financeiros sênior. Vou fornecer o texto de uma fatura. Extraia APENAS as compras confirmadas e devolva EXCLUSIVAMENTE um array JSON. REGRAS RÍGIDAS: 1. 'date': Data exata da COMPRA. ATENÇÃO: Se a fatura mostrar apenas dia/mês (ex: 12/01), deduza o ano usando o vencimento da fatura. É PROIBIDO usar a data de vencimento como data da compra. Formato 'AAAA-MM-DDT00:00:00.000Z'. 2. 'dueDate': Data de VENCIMENTO DA FATURA. Se não achar, null. Formato 'AAAA-MM-DDT00:00:00.000Z'. 3. 'description': Nome do estabelecimento. 4. 'amount': Valor decimal usando ponto (Ex: 150.50). 5. IGNORE: pagamentos, simulações, juros, saldos. 6. Devolva apenas o [ { ... } ]. TEXTO DA FATURA AQUI: ${textoFatura}"
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
          'https://fierce-gorge-10603-4854bc8b7c1f.herokuapp.com/https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AQ.Ab8RN6KR3gPw-YuZFQQ68_RKSUJLcRnbfzCzd7xGxG4uWXE6BA',
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

  static dynamic resultadoExtraido(dynamic response) => getJsonField(
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
          "text": "Você é um extrator de dados financeiros sênior. Vou fornecer um arquivo PDF. Leia visualmente. Extraia APENAS as compras confirmadas e devolva EXCLUSIVAMENTE um array JSON. REGRAS RÍGIDAS: 1. 'date': Data exata da COMPRA. ATENÇÃO: Se a fatura mostrar apenas dia/mês (ex: 12/01), deduza o ano usando o vencimento da fatura. É PROIBIDO usar a data de vencimento como data da compra. Formato 'AAAA-MM-DDT00:00:00.000Z'. 2. 'dueDate': Data de VENCIMENTO DA FATURA. Se não achar, null. Formato 'AAAA-MM-DDT00:00:00.000Z'. 3. 'description': Nome do estabelecimento. 4. 'amount': Valor decimal usando ponto (Ex: 150.50). 5. IGNORE: pagamentos, simulações, juros, saldos. 6. Devolva apenas o [ { ... } ]."
        },
        {
          "inlineData": {
            "mimeType": "application/pdf",
            "data": ${pdfBase64 == null ? 'null' : '"${pdfBase64}"'}
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
          'https://fierce-gorge-10603-4854bc8b7c1f.herokuapp.com/https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=AQ.Ab8RN6KR3gPw-YuZFQQ68_RKSUJLcRnbfzCzd7xGxG4uWXE6BA',
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

  static dynamic resultadoExtraido(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class CriarInstanciaPareamentoCall {
  static Future<ApiCallResponse> call({
    String? cnpj = '',
    String? telefone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "documento_cnpj": ${cnpj == null ? 'null' : '"${escapeStringForJson(cnpj)}"'},
  "telefone": ${telefone == null ? 'null' : '"${escapeStringForJson(telefone)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CriarInstanciaPareamento',
      apiUrl:
          'https://n8n-aciv.srv1965950.hstgr.cloud/webhook/criar-instancia-pareamento',
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
}

class DispararCobrancaWhatsAppCall {
  static Future<ApiCallResponse> call({
    String? cnpjEmpresa = '',
    String? nomeCliente = '',
    String? valorCobranca = '',
    String? dataVencimento = '',
    String? telefoneCliente = '',
  }) async {
    final ffApiRequestBody = '''
{
  "cnpj_empresa": ${cnpjEmpresa == null ? 'null' : '"${escapeStringForJson(cnpjEmpresa)}"'},
  "telefone_cliente": ${telefoneCliente == null ? 'null' : '"${escapeStringForJson(telefoneCliente)}"'},
  "nome_cliente": ${nomeCliente == null ? 'null' : '"${escapeStringForJson(nomeCliente)}"'},
  "valor": ${valorCobranca == null ? 'null' : '"${escapeStringForJson(valorCobranca)}"'},
  "data_vencimento": ${dataVencimento == null ? 'null' : '"${escapeStringForJson(dataVencimento)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'DispararCobrancaWhatsApp',
      apiUrl:
          'https://n8n-aciv.srv1965950.hstgr.cloud/webhook/enviar-cobranca-manual',
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
  final encoded = jsonEncode(input);
  return encoded.substring(1, encoded.length - 1);
}
