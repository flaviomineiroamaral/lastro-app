// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/index.dart';
import '/custom_code/actions/index.dart' as actions;

// Canal MethodChannel para comunicação com o código nativo (Android/iOS)
const _kShareChannel = MethodChannel('lastro.financas/share_intent');

/// Inicializa o listener de arquivos compartilhados pelo sistema operacional.
/// Deve ser chamado uma vez no initState da ImportarWidget.
void inicializarShareListener(BuildContext context) {
  // 1. Listener ativo: recebe arquivos quando o app já está em foreground
  _kShareChannel.setMethodCallHandler((MethodCall call) async {
    if (call.method == 'onSharedFile' && context.mounted) {
      final Map<dynamic, dynamic>? args = call.arguments as Map?;
      if (args != null && args['path'] != null) {
        await _processarArquivoRecebido(
          path: args['path'] as String,
          name: args['name'] as String? ?? '',
          context: context,
        );
      }
    }
  });

  // 2. Verificação no startup: arquivo pendente de cold start ou onNewIntent
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      final Map? result =
          await _kShareChannel.invokeMethod<Map>('getSharedFile');
      if (result != null && result['path'] != null && context.mounted) {
        await _processarArquivoRecebido(
          path: result['path'] as String,
          name: result['name'] as String? ?? '',
          context: context,
        );
      }
    } catch (e) {
      debugPrint('[Lastro Share] Erro ao verificar arquivo pendente: $e');
    }
  });
}

Future<void> _processarArquivoRecebido({
  required String path,
  required String name,
  required BuildContext context,
}) async {
  if (!context.mounted) return;

  Uint8List bytes;
  try {
    bytes = await File(path).readAsBytes();
  } catch (e) {
    debugPrint('[Lastro Share] Erro ao ler arquivo: $e');
    return;
  }

  final String nomeArquivo = name.isNotEmpty ? name : path.split(Platform.pathSeparator).last;
  final String extensao = nomeArquivo.split('.').last.toLowerCase();

  final FFUploadedFile ffFile = FFUploadedFile(
    name: nomeArquivo,
    bytes: bytes,
  );

  List<OfxTransactionStruct> transacoes = [];
  String? formatoDetectado;

  // Detecção primária por extensão
  if (extensao == 'ofx' || extensao == 'qfx') {
    formatoDetectado = 'OFX';
  } else if (extensao == 'csv') {
    formatoDetectado = 'CSV';
  } else if (extensao == 'pdf') {
    formatoDetectado = 'PDF';
  } else {
    // Extensão desconhecida: perguntar ao usuário (decisão confirmada)
    if (!context.mounted) return;
    formatoDetectado = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Formato do arquivo'),
        content: Text(
          'Não foi possível identificar o formato de "$nomeArquivo".\nQual formato deseja tentar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'OFX'),
            child: const Text('OFX / QFX'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'CSV'),
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
    if (formatoDetectado == null) return;
  }

  // Processamento conforme formato detectado
  try {
    if (formatoDetectado == 'OFX') {
      transacoes = await actions.parseOfxFile(ffFile);
    } else if (formatoDetectado == 'CSV') {
      transacoes = actions.processarCSV(ffFile, null);
    } else if (formatoDetectado == 'PDF') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'PDF recebido! Use a opção "Importar PDF" na tela de importação para processar.',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
      return;
    }
  } catch (e) {
    debugPrint('[Lastro Share] Erro ao processar $formatoDetectado: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao processar o arquivo. Verifique se é um $formatoDetectado válido.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    return;
  }

  if (transacoes.isEmpty) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma transação encontrada no arquivo recebido.'),
        ),
      );
    }
    return;
  }

  // Carrega no estado global e navega direto para a tela de seleção/conciliação
  FFAppState().tempImportacaoOFX = transacoes.cast<OfxTransactionStruct>();

  if (context.mounted) {
    context.pushNamed(SelecionarTransacoesWidget.routeName);
  }
}
