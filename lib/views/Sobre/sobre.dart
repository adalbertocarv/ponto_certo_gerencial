import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/views/widgets/centered_view/centered_view.dart';
import '../widgets/navigation_bar/navigation_bar.dart';
import '../home/home_page.dart';

class Sobre extends StatelessWidget {
  const Sobre({super.key});

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;
    final telaLarga = larguraTela >= 1300;
    final isMobile = larguraTela < 768; // <-- mobile

    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 245),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: isMobile
                ? _buildMobileLayout(context, telaLarga) // context passado
                : _buildDesktopLayout(context, telaLarga), // idem
          ),
        ),
      ),
    );
  }

  // ----------- MOBILE -----------
  Widget _buildMobileLayout(BuildContext context, bool telaLarga) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                ),
                child: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                ),
                child: NavBarItem('Voltar'),
              ),
            ],
          ),
          _buildContent(telaLarga),
        ],
      ),
    );
  }

  // ----------- DESKTOP ----------
  Widget _buildDesktopLayout(BuildContext context, bool telaLarga) {
    return CenteredView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                ),
                child: const Icon(Icons.arrow_back_ios),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                ),
                child: NavBarItem('Voltar'),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(child: _buildContent(telaLarga)),
        ],
      ),
    );
  }

  // ----------- CONTEÚDO ----------
  Widget _buildContent(bool telaLarga) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        telaLarga
            ? const Text(
                'SOBRE O APLICATIVO\nPONTO CERTO.',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w800,
                  height: 0.9,
                ),
              )
            : AutoSizeText(
                'SOBRE O APLICATIVO\nPONTO CERTO.',
                maxLines: 2,
                minFontSize: 30,
                style: const TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.w800,
                  height: 0.9,
                ),
              ),
        const SizedBox(height: 24),
        _paragraph(
          'O Ponto Certo é um aplicativo desenvolvido para auxiliar a Secretaria de Transporte '
          'e Mobilidade (SEMOB/SUTER) no mapeamento e cadastro de pontos de parada de ônibus no '
          'Distrito Federal...',
        ),
        const SizedBox(height: 12),
        _bulletPoints([
          'Localização GPS da parada',
          'Identificação da via relacionada',
          'Existência de abrigo no ponto',
          'Condições de acessibilidade',
          'Inserção de imagens',
          'Visualização em mapa com camadas de satélite',
        ]),
        const SizedBox(height: 24),
        _sectionTitle('Equipe Demandante/Organizacional'),
        const SizedBox(height: 16),
        _bulletPoints([
          'Ana Carolina Pereira de Araújo',
          'Gerson Antônio Silva Soares Ferreira',
        ]),
        const SizedBox(height: 24),
        _sectionTitle('Equipe de Desenvolvimento'),
        const SizedBox(height: 16),
        _bulletPoints([
          'Adalberto Carvalho Santos Júnior',
          'Ednardo de Oliveira Ferreira',
          'Gabriel Pedro Veras',
          'Lucas Bezerra da Cruz',
        ]),
        const SizedBox(height: 32),
      ],
    );
  }

  // ----------- WIDGETS AUXILIARES ----------
  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );

  Widget _paragraph(String text) => Text(
        text,
        style:
            const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
      );

  Widget _bulletPoints(List<String> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
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
              ),
            )
            .toList(),
      );
}
