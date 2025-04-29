import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DetalhePagina extends StatelessWidget {
  const DetalhePagina({super.key});

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;
    final telaLarga = larguraTela >= 1300;

    return Container(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          telaLarga
              ? const Text(
                  'PONTO CERTO.\n MAPEAMENTO DE PARADAS',
                  style: TextStyle(
                      fontSize: 80, fontWeight: FontWeight.w800, height: 0.9),
                )
              : AutoSizeText(
                  'PONTO CERTO.\nMAPEAMENTO DE PARADAS',
                  maxLines: 2,
                  minFontSize: 20,
                  style: TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.w800,
                    height: 0.9,
                  ),
                ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Plataforma para cadastro, envio, edição e exclusão de pontos de parada (ônibus). Desenvolvido para a GEMOB/SUTER/SEMOB (Secretaria de Transporte e Mobilidade), focando em acessibilidade, rastreabilidade e eficiência.',
            style: TextStyle(fontSize: 21, height: 1.7),
          ),
        ],
      ),
    );
  }
}
