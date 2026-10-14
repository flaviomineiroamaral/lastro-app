
abstract class FFAppConstants {
  static const int LarguraMaxima = 500;
  static const List<String> PerfilAcesso = [
    'Dono',
    'Administrador',
    'Operador',
    'Leitor'
  ];
  static const List<String> PlanoUsoLastro = [
    'Governança Básica',
    'Governança Intermediária',
    'Governança Plena',
    'Governança Familiar (B2C)'
  ];
  static const List<String> NaturezaFluxo = ['ENTRDA', 'SAIDA'];

  /// Project URL do SUPABASE local
  static const String ApiUrlProjectSupabase = 'http://127.0.0.1:54321';

  /// Authentication Keys Publishable
  static const String AnonKey =
      'sb_publishable_ACJWlzQHLZjBrEguHvfOxg_3BJgxAaH';
  static const List<String> statusAssinatura = [
    'pendente',
    'ativa',
    'atrasada',
    'cancelada'
  ];
  static const List<String> statusPagamentoSetup = [
    'pendente',
    'pago',
    'expirado',
    'cancelado'
  ];
  static const List<String> statusContrato = [
    'lead_recebido',
    'pendente_geracao',
    'aguardando_permissao_wa',
    'link_enviado',
    'assinado',
    'aceite_manual_pendente',
    'cancelado'
  ];
  static const List<String> tipoPerfil = [
    'Igreja',
    'OSC/ONG',
    'Família',
    'Negócio',
    'Indústria'
  ];
  static const List<String> tipoPermissao = [
    'dono',
    'administrador',
    'operador',
    'leitor'
  ];
}
