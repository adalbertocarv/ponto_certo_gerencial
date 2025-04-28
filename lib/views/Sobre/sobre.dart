import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/widgets/centered_view/centered_view.dart';
import '../../widgets/navigation_bar/navigation_bar.dart';
import '../home/home_page.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Importante alinhar no topo
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                ),
                                child: Icon(Icons.arrow_back_ios),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                ),
                                child: NavBarItem('Voltar'),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          // Importante adicionar Expanded aqui!
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              Text(
                                'SOBRE O APLICATIVO\nPONTO CERTO.',
                                style: const TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w800,
                                  height: 0.9,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _paragraph(
                                'O Ponto Certo é um aplicativo desenvolvido para auxiliar a Secretaria de Transporte e Mobilidade (SEMOB/SUTER) '
                                'no mapeamento e cadastro de pontos de parada de ônibus no Distrito Federal...',
                              ),
                              const SizedBox(height: 12),
                              _bulletPoints([
                                'Localização GPS da parada',
                                'Identificação da via relacionada',
                                'Existência de abrigo no ponto',
                                'Condições de acessibilidade',
                                'Inserção de imagens',
                              ]),
                              const SizedBox(height: 12),
                              _paragraph(
                                'Com funcionalidades como visualização em mapa com camadas de satélite...',
                              ),
                              const SizedBox(height: 24),
                              _sectionTitle('Equipe de Desenvolvimento'),
                              const SizedBox(height: 24),
                              _bulletPoints([
                                'Adalberto Carvalho Santos Júnior',
                                'Ednardo de Oliveira Ferreira',
                                'Gabriel Pedro Veras'
                              ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            )));
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _paragraph(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
    );
  }

  Widget _bulletPoints(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
