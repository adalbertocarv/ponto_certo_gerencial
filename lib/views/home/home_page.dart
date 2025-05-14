import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/views/widgets/botao_acesso/botao_acesso_pagina.dart';
import 'package:ponto_certo_gerencial/views/widgets/centered_view/centered_view.dart';
import 'package:ponto_certo_gerencial/views/widgets/detalhe_pagina/detalhe_pagina.dart';
import '../widgets/navigation_bar/navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    // Chave global para acessar o Scaffold
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey, // Adicionando a chave ao Scaffold
      backgroundColor: const Color.fromARGB(245, 245, 245, 245),
      // Adicionando o drawer aqui
      drawer: DrawerMenu(),
      body: Scrollbar(
        controller: scrollController,
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
                  // Passando a scaffoldKey para o NavigatorBar personalizado
                  CustomNavigatorBar(scaffoldKey: scaffoldKey),
                  const SizedBox(
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