import 'package:flutter/material.dart';
import './mapa_paradas.dart';
import './form.dart';

class MapaPesquisa extends StatelessWidget {
  const MapaPesquisa({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Painel lateral esquerdo
        Container(
          width: 380,
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com título e logo
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('SECRETARIA DE TRANSPORTE E MOBILIDADE'),
                            Text(
                              'SEMOB',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.5),
                      child: const Image(
                        image: AssetImage('assets/gdf.png'),
                        height: 70,
                      ),
                    ),
                  ],
                ),
              ),

              //formulário abaixo do título
              Formulario(),
            ],
          ),
        ),

        // Mapa do lado direito
        Expanded(
          child: Stack(
            children: [
              MapaParadas(),
            ],
          ),
        ),
      ],
    );
  }
}
