// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Mantenha os imports padrões do FlutterFlow que já estão no topo e adicione este:
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<String> extrairTextoPDF(FFUploadedFile arquivoPdf) async {
  if (arquivoPdf.bytes == null || arquivoPdf.bytes!.isEmpty) {
    return "ERRO_VAZIO";
  }

  try {
    final PdfDocument document = PdfDocument(inputBytes: arquivoPdf.bytes);
    String textoExtraido = PdfTextExtractor(document).extractText();
    document.dispose();

    if (textoExtraido.trim().length < 50) {
      return "ERRO_IMAGEM";
    }

    // --- A BLINDAGEM DE TITÂNIO ---
    // A Regex abaixo caça e destrói QUALQUER caractere de controle invisível
    // (Tabs, Quebras de Página, Sinos, etc) e troca por um espaço seguro.
    String textoSeguro = textoExtraido
        .replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ' ')
        .replaceAll('"', "'")
        .replaceAll('\\', ' ');

    return textoSeguro;
  } catch (e) {
    return "ERRO_PROCESSAMENTO";
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
