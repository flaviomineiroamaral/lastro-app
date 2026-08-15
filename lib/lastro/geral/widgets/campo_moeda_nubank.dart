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

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CampoMoedaNubank extends StatefulWidget {
  const CampoMoedaNubank({
    Key? key,
    this.width,
    this.height,
    this.tamanhoFonte,
    this.corTexto,
    this.corFundo,
    this.corBorda,
    this.arredondamento,
    this.centralizarTexto,
    this.espacamentoHorizontal,
    this.espacamentoVertical,
    this.valorInicial,
    this.acaoAoMudar,
  }) : super(key: key);

  final double? width;
  final double? height;
  final double? tamanhoFonte;
  final Color? corTexto;
  final Color? corFundo;
  final Color? corBorda;
  final double? arredondamento;
  final bool? centralizarTexto;
  final double? espacamentoHorizontal;
  final double? espacamentoVertical;
  final double? valorInicial;
  final Future Function(double valorDigitado)? acaoAoMudar;

  @override
  _CampoMoedaNubankState createState() => _CampoMoedaNubankState();
}

class _CampoMoedaNubankState extends State<CampoMoedaNubank> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    double valorStart = widget.valorInicial ?? 0.0;

    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2);
    String textoFormatado = formatter.format(valorStart);
    _controller = TextEditingController(text: textoFormatado);
  }

  // ==========================================
  // O MOTOR DE ATUALIZAÇÃO REATIVA (A CORREÇÃO)
  // ==========================================
  @override
  void didUpdateWidget(CampoMoedaNubank oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Se o valorInicial que vem do FlutterFlow (Supabase) mudou em relação ao que tínhamos...
    if (widget.valorInicial != oldWidget.valorInicial) {
      double novoValor = widget.valorInicial ?? 0.0;
      final formatter = NumberFormat.currency(
          locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2);
      String textoFormatado = formatter.format(novoValor);

      // Atualiza o texto visual sem destruir a posição do cursor
      if (_controller.text != textoFormatado) {
        _controller.text = textoFormatado;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height ?? 60.0,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: widget.espacamentoHorizontal ?? 16.0,
        vertical: widget.espacamentoVertical ?? 0.0,
      ),
      decoration: BoxDecoration(
        color:
            widget.corFundo ?? FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(widget.arredondamento ?? 8.0),
        border: Border.all(
          color: widget.corBorda ?? FlutterFlowTheme.of(context).alternate,
          width: 2,
        ),
      ),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textAlign: (widget.centralizarTexto ?? false)
            ? TextAlign.center
            : TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        style: FlutterFlowTheme.of(context).bodyLarge.override(
              fontFamily: 'Inter',
              fontSize: widget.tamanhoFonte ?? 28.0,
              color:
                  widget.corTexto ?? FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.bold,
            ),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: false,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _CurrencyInputFormatter(
            onValueChange: (double valorReal) {
              if (widget.acaoAoMudar != null) {
                widget.acaoAoMudar!(valorReal);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  final Function(double) onValueChange;

  _CurrencyInputFormatter({required this.onValueChange});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String numbers = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.isEmpty) {
      onValueChange(0.0);
      return TextEditingValue(
        text: 'R\$ 0,00',
        selection: TextSelection.collapsed(offset: 8),
      );
    }

    double value = double.parse(numbers) / 100;
    onValueChange(value);

    final formatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2);
    String newText = formatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
