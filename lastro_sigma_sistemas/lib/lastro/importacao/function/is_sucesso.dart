

bool isSucesso(dynamic jsonDados) {
  if (jsonDados == null) {
    return false;
  }
  return jsonDados['sucesso'] == true;
}
