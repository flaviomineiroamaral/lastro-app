import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/uploaded_file.dart';
import '/flutter_flow/nav/nav.dart';
import '/custom_code/actions/index.dart' as actions;
import '/lastro/importacao/function/json_to_ofx.dart';
import '/index.dart';

class ShareIntentService {
  static bool _initialized = false;
  static GoRouter? _router;
  static AppStateNotifier? _appStateNotifier;

  static void init(GoRouter router, AppStateNotifier appStateNotifier) {
    _router = router;
    _appStateNotifier = appStateNotifier;

    if (_initialized) return;
    _initialized = true;

    // Escuta novos compartilhamentos recebidos em segundo plano (app já aberto)
    ReceiveSharingIntent.instance.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          debugPrint("ShareIntentService: Media recebida via Stream (${value.length} arquivos)");
          _processSharedFiles(value);
        }
      },
      onError: (err) {
        debugPrint("Erro no Share Intent Stream: $err");
      },
    );

    // Processa o compartilhamento inicial que acionou a abertura do app
    ReceiveSharingIntent.instance.getInitialMedia().then(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          debugPrint("ShareIntentService: Media recebida via InitialMedia (${value.length} arquivos)");
          _processSharedFiles(value);
        }
      },
      onError: (err) {
        debugPrint("Erro no Initial Share Intent: $err");
      },
    );
  }

  static bool _isOfxContent(String text) {
    final upper = text.toUpperCase();
    return upper.contains('OFXHEADER') ||
        upper.contains('<OFX>') ||
        upper.contains('<STMTTRN>') ||
        upper.contains('<BANKTRANLIST>');
  }

  static bool _isPdfBytes(List<int> bytes) {
    return bytes.length >= 4 &&
        bytes[0] == 0x25 && // %
        bytes[1] == 0x50 && // P
        bytes[2] == 0x44 && // D
        bytes[3] == 0x46; // F
  }

  static Future<void> _processSharedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;

    try {
      final sharedFile = files.first;
      final filePath = sharedFile.path;
      debugPrint("ShareIntentService: Processando arquivo compartilhado -> $filePath");
      if (filePath.isEmpty) return;

      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint("ShareIntentService: Arquivo não existe no caminho: $filePath");
        return;
      }

      final bytes = await file.readAsBytes();
      final fileName = filePath.split('/').last.split('\\').last;

      final uploadedFile = FFUploadedFile(
        name: fileName,
        bytes: bytes,
        originalFilename: fileName,
      );

      List<OfxTransactionStruct> transacoes = [];

      String textContent = '';
      try {
        textContent = utf8.decode(bytes);
      } catch (_) {
        textContent = latin1.decode(bytes);
      }

      final lowerName = fileName.toLowerCase();
      final mime = sharedFile.mimeType?.toLowerCase() ?? '';

      if (lowerName.endsWith('.ofx') ||
          lowerName.endsWith('.ofc') ||
          lowerName.endsWith('.qfx') ||
          mime.contains('ofx') ||
          _isOfxContent(textContent)) {
        debugPrint("ShareIntentService: Identificado como OFX");
        transacoes = await actions.parseOfxFile(uploadedFile);
      } else if (lowerName.endsWith('.pdf') ||
          mime.contains('pdf') ||
          _isPdfBytes(bytes)) {
        debugPrint("ShareIntentService: Identificado como PDF");
        final textoBruto = await actions.extrairTextoPDF(uploadedFile);
        if (textoBruto == "ERRO_IMAGEM") {
          debugPrint("ShareIntentService: PDF escaneado/imagem detectado, chamando Gemini Visual...");
          final base64Pdf = await actions.pdfParaBase64(uploadedFile);
          final respostaVisual = await LerFaturaGeminiVisualCall.call(pdfBase64: base64Pdf);
          if ((respostaVisual.statusCode ?? 200) == 200 && (respostaVisual.succeeded ?? true)) {
            final jsonText = getJsonField(
              (respostaVisual.jsonBody ?? ''),
              r'''$.candidates[0].content.parts[0].text''',
            ).toString();
            transacoes = jsonToOfx(jsonText);
          }
        } else if (textoBruto != "ERRO_VAZIO" &&
            textoBruto != "ERRO_PROCESSAMENTO") {
          debugPrint("ShareIntentService: Texto PDF extraído (${textoBruto.length} caracteres), chamando Gemini Text...");
          final resposta = await LerFaturaGeminiCall.call(textoFatura: textoBruto);
          debugPrint("ShareIntentService: Status Code: ${resposta.statusCode}");
          debugPrint("ShareIntentService: Body: ${resposta.jsonBody}");
          if ((resposta.statusCode ?? 200) == 200 && (resposta.succeeded ?? true)) {
            final jsonText = getJsonField(
              (resposta.jsonBody ?? ''),
              r'''$.candidates[0].content.parts[0].text''',
            ).toString();
            transacoes = jsonToOfx(jsonText);
          } else {
             debugPrint("ShareIntentService: Erro na API do Gemini.");
          }
        }
      } else if (lowerName.endsWith('.csv') ||
          mime.contains('csv') ||
          mime.contains('comma') ||
          textContent.contains(';') ||
          textContent.contains(',')) {
        debugPrint("ShareIntentService: Identificado como CSV");
        transacoes = actions.processarCSV(uploadedFile, DateTime.now());
      } else {
        debugPrint("ShareIntentService: Tipo desconhecido, tentando OFX e depois CSV");
        transacoes = await actions.parseOfxFile(uploadedFile);
        if (transacoes.isEmpty) {
          transacoes = actions.processarCSV(uploadedFile, DateTime.now());
        }
      }

      // Reseta o intent para evitar reprocessamento
      ReceiveSharingIntent.instance.reset();

      debugPrint("ShareIntentService: ${transacoes.length} transações extraídas com sucesso");

      if (transacoes.isNotEmpty) {
        FFAppState().tempImportacaoOFX = transacoes;
        _navigateToSelection();
      } else {
        debugPrint("ShareIntentService: Nenhuma transação foi identificada no arquivo");
        _exibirAvisoIncompativel(
            "Formato não suportado ou sem transações válidas. Por favor, envie um extrato ou fatura nos formatos OFX, PDF ou CSV.");
      }
    } catch (e, stack) {
      debugPrint("ShareIntentService: Erro ao processar arquivo: $e\n$stack");
      _exibirAvisoIncompativel(
          "Ocorreu um erro ao processar o arquivo compartilhado. Tente novamente ou selecione outro arquivo.");
    }
  }

  static void _navigateToSelection() async {
    int retries = 0;
    while (retries < 25) {
      if (_appStateNotifier != null && !_appStateNotifier!.loading && _router != null) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 150));
      retries++;
    }

    if (_appStateNotifier != null && _appStateNotifier!.showSplashImage) {
      _appStateNotifier!.stopShowingSplashImage();
    }

    if (_router != null) {
      debugPrint("ShareIntentService: Redirecionando para SelecionarTransacoesWidget");
      _router!.goNamed(SelecionarTransacoesWidget.routeName);
    }
  }

  static void _exibirAvisoIncompativel(String mensagem) async {
    int retries = 0;
    while (retries < 25) {
      if (_appStateNotifier != null && !_appStateNotifier!.loading && _router != null) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 150));
      retries++;
    }

    if (_appStateNotifier != null && _appStateNotifier!.showSplashImage) {
      _appStateNotifier!.stopShowingSplashImage();
    }

    final context = _router?.configuration.navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  mensagem,
                  style: const TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFD32F2F),
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );
    }
  }
}
