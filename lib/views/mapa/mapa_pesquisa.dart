import 'package:flutter/material.dart';
import './mapa_paradas.dart';
import './form.dart';

class MapaPesquisa extends StatelessWidget {
  const MapaPesquisa({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: screenWidth > 950
          ? Row(
              children: [
                Container(
                  width: 380,
                  color: Colors.grey[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                        'SECRETARIA DE TRANSPORTE E MOBILIDADE'),
                                    Text(
                                      'SEMOB',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
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
                      Formulario(),
                    ],
                  ),
                ),
                Expanded(child: MapaParadas()),
              ],
            )
          : Stack(
              children: [
                MapaParadas(),
                DraggableScrollableSheet(
                  initialChildSize: 0.15,
                  minChildSize: 0.1,
                  maxChildSize: 0.75,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'SECRETARIA DE TRANSPORTE E MOBILIDADE\nSEMOB',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Formulario(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
