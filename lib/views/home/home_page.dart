import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/widgets/botao_acesso/botao_acesso_pagina.dart';
import 'package:ponto_certo_gerencial/widgets/centered_view/centered_view.dart';
import 'package:ponto_certo_gerencial/widgets/detalhe_pagina/detalhe_pagina.dart';
import '../../widgets/navigation_bar/navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(245, 245, 245, 245),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), //animação suave do scroll
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: CenteredView(
              child: Column(
                children: [
                  NavigatorBar(),
                  SizedBox(
                    height: 200,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 950) {
                        return Column(
                          children: [
                            DetalhePagina(),
                            Center(
                              child: CallToAction('Paradas de Ônibus'),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            DetalhePagina(),
                            Expanded(
                              child: Center(
                                child: CallToAction('Paradas de Ônibus'),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
