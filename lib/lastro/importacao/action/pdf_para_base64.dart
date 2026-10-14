// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> pdfParaBase64(FFUploadedFile arquivoPdf, String? senha) async {
  if (arquivoPdf.bytes == null || arquivoPdf.bytes!.isEmpty) {
    return "";
  }

  List<int> bytesFinais = arquivoPdf.bytes!;

  // Se tem senha, precisamos descriptografar o PDF antes de mandar para a IA
  if (senha != null && senha.isNotEmpty) {
    try {
      final PdfDocument document =
          PdfDocument(inputBytes: arquivoPdf.bytes, password: senha);

      // Remove as senhas para gerar um PDF aberto
      document.security.userPassword = '';
      document.security.ownerPassword = '';
      // document.security.algorithm = PdfEncryptionAlgorithm.none; // Opcional

      bytesFinais = document.saveSync();
      document.dispose();
    } catch (e) {
      debugPrint("Erro ao descriptografar PDF para IA Visual: $e");
      // Se falhar, tenta mandar o original mesmo
    }
  }

  // Transforma o PDF (aberto) num código de texto gigante (Base64)
  return base64Encode(bytesFinais);
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
