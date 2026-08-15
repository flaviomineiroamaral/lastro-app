// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async'; // Necessário para gerenciar a assinatura do Stream

class PulseListener extends StatefulWidget {
  const PulseListener({
    Key? key,
    this.width,
    this.height,
    required this.orgId,
    required this.onDataChange,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String orgId;
  final Future Function() onDataChange;

  @override
  _PulseListenerState createState() => _PulseListenerState();
}

class _PulseListenerState extends State<PulseListener> {
  // Usamos StreamSubscription para tipagem segura e para podermos cancelar depois
  StreamSubscription<List<Map<String, dynamic>>>? _pulseSubscription;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _iniciarEscuta();
  }

  void _iniciarEscuta() {
    // 1. Constrói a query com o filtro
    final query = Supabase.instance.client.from('org_pulse').stream(
        primaryKey: ['organization_id']).eq('organization_id', widget.orgId);

    // 2. Assina o Stream com o tipo genérico correto
    _pulseSubscription = query.listen((List<Map<String, dynamic>> data) {
      if (_isFirstLoad) {
        // Ignora a primeira leitura que ocorre quando a tela abre
        _isFirstLoad = false;
        return;
      }

      // O banco piscou! Dispara a ação no FlutterFlow
      widget.onDataChange();
    }, onError: (error) {
      print('Erro no PulseListener: $error');
    });
  }

  @override
  void dispose() {
    // Boa prática de engenharia: sempre cancele Streams quando o widget for destruído
    // Isso evita vazamento de memória (memory leaks) se o usuário sair da tela do Dashboard
    _pulseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget invisível
    return SizedBox(
      width: widget.width ?? 1.0,
      height: widget.height ?? 1.0,
    );
  }
}
