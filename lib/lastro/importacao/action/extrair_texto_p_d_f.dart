// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> extrairTextoPDF(FFUploadedFile arquivoPdf, String? senha) async {
  if (arquivoPdf.bytes == null || arquivoPdf.bytes!.isEmpty) {
    return "ERRO_VAZIO";
  }
  try {
    // Agora o motor tenta abrir com a senha (se fornecida pelo usuário no modal)
    final PdfDocument document =
        PdfDocument(inputBytes: arquivoPdf.bytes, password: senha);
    String textoExtraido = PdfTextExtractor(document).extractText();
    document.dispose();
    if (textoExtraido.trim().length < 50) {
      return "ERRO_IMAGEM";
    }
    // --- BLINDAGEM CORRIGIDA ---
    // Remove caracteres de controle EXCETO o \n (\x0A), que é necessário
    // para o Regex funcionar. Remove também o \r (\x0D) que quebra JSON.
    String textoSeguro = textoExtraido
        .replaceAll('\r\n', '\n') // Normaliza quebra de linha Windows
        .replaceAll('\r', '\n') // Normaliza \r solto em \n
        .replaceAll(RegExp(r'[\x00-\x09\x0B-\x1F\x7F-\x9F]'),
            ' ') // Remove controles, preserva \n (\x0A)
        .replaceAll('"', "'")
        .replaceAll('\\', ' ');
    return textoSeguro;
  } catch (e) {
    // Detecta se o erro foi de senha protegida
    if (e.toString().toLowerCase().contains('password') ||
        e.toString().toLowerCase().contains('senha') ||
        e.toString().toLowerCase().contains('encrypted')) {
      return "ERRO_SENHA";
    }
    return "ERRO_PROCESSAMENTO";
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
