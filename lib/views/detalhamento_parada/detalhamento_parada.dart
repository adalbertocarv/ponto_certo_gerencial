import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/widgets/centered_view/centered_view.dart';

class DetalhamentoParada extends StatefulWidget {
  const DetalhamentoParada({super.key});

  @override
  State<DetalhamentoParada> createState() => _DetalhamentoParadaState();
}

class _DetalhamentoParadaState extends State<DetalhamentoParada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredView(child: ListView(
      children: [
        
      ],
      )),
    );
  }
}
