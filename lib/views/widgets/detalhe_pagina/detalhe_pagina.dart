import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// Bloco de texto responsivo do “hero” da home.
/// – Em telas ≥ 1300 px mostra o título completo em uma linha quebrada.
/// – Em telas menores divide o título em duas linhas e reduz as fontes.
class DetalhePagina extends StatelessWidget {
  const DetalhePagina({super.key});

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;
    final telaLarga = larguraTela >= 1300;

    // Largura máxima de leitura: 600 px ou 90 % da tela, o que for menor.
    final double maxWidth = larguraTela < 650 ? larguraTela * 0.9 : 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---------- TÍTULO ----------
            telaLarga
                ? const Text(
                    'PONTO CERTO.\nMAPEAMENTO DE PARADAS',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w800,
                      height: 0.9,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      AutoSizeText(
                        'PONTO CERTO.',
                        maxLines: 1,
                        minFontSize: 28,
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w800,
                          height: 0.9,
                        ),
                      ),
                      SizedBox(height: 4),
                      AutoSizeText(
                        'MAPEAMENTO DE PARADAS',
                        maxLines: 1,
                        minFontSize: 20,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          height: 0.9,
                        ),
                      ),
                    ],
                  ),

            const SizedBox(height: 30),

            // ---------- DESCRIÇÃO ----------
            const Text(
              'Plataforma para cadastro, envio, edição e exclusão de '
              'pontos de parada (ônibus). Desenvolvido para a GEMOB/SUTER/SEMOB '
              '(Secretaria de Transporte e Mobilidade), focando em '
              'acessibilidade, rastreabilidade e eficiência.',
              style: TextStyle(fontSize: 20, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
