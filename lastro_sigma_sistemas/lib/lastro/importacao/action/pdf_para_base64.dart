// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

Future<String> pdfParaBase64(FFUploadedFile arquivoPdf) async {
  if (arquivoPdf.bytes == null || arquivoPdf.bytes!.isEmpty) {
    return "";
  }
  // Transforma o PDF físico num código de texto gigante (Base64)
  return base64Encode(arquivoPdf.bytes!);
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
