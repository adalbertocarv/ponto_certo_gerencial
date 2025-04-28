import 'package:flutter/material.dart';

class DetalhePagina extends StatelessWidget {
  const DetalhePagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'PONTO CERTO.\n MAPEAMENTO DE PARADAS',
            style: TextStyle(
                fontSize: 80, fontWeight: FontWeight.w800, height: 0.9),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Aplicativo Flutter para mapeamento, cadastro e envio de pontos de parada (ônibus) com funcionalidades offline. Desenvolvido para a SEMOB (Secretaria de Transporte e Mobilidade), focando em acessibilidade, rastreabilidade e eficiência.',
            style: TextStyle(fontSize: 21, height: 1.7),
          ),
        ],
      ),
    );
  }
}
