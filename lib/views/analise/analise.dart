import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import '../../services/analise_service.dart';
import '../home/home_page.dart';
import '../widgets/KPI/stat_card.dart';
import '../widgets/centered_view/centered_view.dart';
import '../widgets/navigation_bar/navigation_bar.dart';
import 'dart:math' show pi;

class Analise extends StatelessWidget {
  const Analise({super.key});

  static const _alturaBarra = 20.0; // 20 px barra + 4 px respiro
  static const _margemEixos = 60.0; // espaço p/ eixo X + títulos

// Função utilitária (deixe em um utils.dart, por exemplo)
  String wrapLabel(String text, {int max = 12}) {
    final words = text.split(' ');
    final buffer = StringBuffer();
    var lineLen = 0;

    for (final w in words) {
      if (lineLen + w.length > max) {
        buffer.write('\n'); // quebra de linha
        lineLen = 0;
      } else if (buffer.isNotEmpty) {
        buffer.write(' ');
        lineLen += 1;
      }
      buffer.write(w);
      lineLen += w.length;
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 245),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    builder: (_) => const HomePage()),
                              ),
                              child: const Icon(Icons.arrow_back_ios),
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomePage()),
                              ),
                              child: NavBarItem('Voltar'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'Ponto Certo Gerencial - ANÁLISE',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 80),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: buscarAbrigosAgrupados(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final dados = snap.data!;

                      // 1) Soma total de abrigos
                      final total = dados.fold<int>(
                        0,
                        (soma, item) => soma + (item['quantidade'] as int),
                      );

                      //PELO AMOR DE DEUS!!! LEMBRAR DE
                      //ALTERAR ISSO AQUI QUANDO FIZER O ENDPOINT
                      //NUMERO APENAS FICTICIO
                      final total2 = total * 1.097;

                      // 2) Altura dinâmica do gráfico
                      final alturaChart =
                          (_alturaBarra * dados.length).clamp(200.0, 600.0) +
                              _margemEixos;

                      return SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ─── Texto com a contagem total - KPI ───
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          350, // largura fixa para o StatCard
                                      child: StatCard(
                                        titulo: 'Total de paradas',
                                        valor: total,
                                        assetPath: 'assets/bus_stop.png',
                                      ),
                                    ),
                                    SizedBox(),
                                    SizedBox(
                                      width:
                                          350, // largura fixa para o StatCard
                                      child: StatCard(
                                        titulo: 'Total de abrigos',
                                        valor: total2.round(),
                                        assetPath: 'assets/amico.png',
                                      ),
                                    ),
                                    SizedBox(),
                                    SizedBox(
                                      width:
                                          350, // largura fixa para o StatCard
                                      child: StatCard(
                                        titulo: "RA's Mapeadas",
                                        //valor ficticio fxo
                                        valor: 29,
                                        assetPath: 'assets/map.png',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // ─── Container do gráfico ───
                                Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: alturaChart,
                                  child: Chart(
                                    data: dados,
                                    variables: {
                                      // 2. Usa o wrap no accessor
                                      'tipo': Variable(
                                        accessor: (Map map) =>
                                            map['tipo'] as String,
                                        scale: OrdinalScale(
                                          // ⇣ aqui sim existe ‘formatter’
                                          formatter: (v) =>
                                              wrapLabel(v, max: 12),
                                        ),
                                      ),
                                      'quantidade': Variable(
                                        accessor: (Map map) =>
                                            map['quantidade'] as num,
                                      ),
                                    },
                                    marks: [
                                      IntervalMark(
                                        // largura fixa da barra (px) — já com seu ajuste
                                        size: SizeEncode(value: 40),
                                        label: LabelEncode(
                                          encoder: (t) =>
                                              Label(t['quantidade'].toString()),
                                        ),
                                        elevation: ElevationEncode(
                                            value: 0,
                                            updaters: {
                                              'tap': {true: (_) => 5}
                                            }),
                                        color: ColorEncode(
                                          value: Defaults.primaryColor,
                                          updaters: {
                                            'tap': {
                                              false: (c) => c.withAlpha(100)
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                    axes: [
                                      Defaults.horizontalAxis
                                        ..label = LabelStyle(
                                          rotation: -pi / 2,
                                          // –90°  ➜  texto “de cima para baixo”
                                          align: Alignment
                                              .centerRight, // ancora à direita da barra
                                          textStyle: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                          offset: const Offset(
                                              0, 50), // afasta do eixo
                                        ),
                                      Defaults.verticalAxis,
                                    ],
                                    selections: {
                                      'tap': PointSelection(dim: Dim.x)
                                    },
                                    tooltip: TooltipGuide(),
                                    crosshair: CrosshairGuide(),
                                  ),
                                ),

                                Container()
                              ],
                            ),
                          ),
                        ),
                      );
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
