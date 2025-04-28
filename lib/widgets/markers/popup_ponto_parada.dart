import 'package:flutter/material.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:ponto_certo_gerencial/models/pontos_paradas.dart';

class PopupPontoParada extends StatelessWidget {
  final ParadaModel pontoParada;
  final PopupController popupController;

  const PopupPontoParada({
    Key? key,
    required this.pontoParada,
    required this.popupController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 250,
              constraints: const BoxConstraints(
                maxHeight: 400,
              ),
              padding: const EdgeInsets.all(12),
              color: Colors.black.withOpacity(0.85),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pontoParada.abrigoNome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => popupController.hideAllPopups(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Endereço: ${pontoParada.endereco}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    //Imagem sem carregar até solução do backend
                    // const SizedBox(height: 8),
                    // Image.network(
                    //   pontoParada.abrigoImg,
                    //   width: double.infinity,
                    //   height: 200,
                    //   fit: BoxFit.cover,
                    //   errorBuilder: (context, error, stackTrace) {
                    //     return const Icon(Icons.image_not_supported, color: Colors.white);
                    //   },
                    // ),
                    const SizedBox(height: 8),
                    Text(
                      'Criado por: ${pontoParada.criadoPor}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Criado em: ${pontoParada.criadoEm}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Visitado em: ${pontoParada.visitadoEm}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        pontoParada.linhaEscolar
                            ? const Icon(Icons.directions_bus, color: Colors.green)
                            : const Icon(Icons.directions_bus, color: Colors.red),
                        const SizedBox(width: 4),
                        const Text(
                          'Linha Escolar',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        pontoParada.linhaStpc
                            ? const Icon(Icons.directions_transit, color: Colors.green)
                            : const Icon(Icons.directions_transit, color: Colors.red),
                        const SizedBox(width: 4),
                        const Text(
                          'Linha STPC',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: CustomPaint(
            size: const Size(20, 10),
            painter: TrianglePainter(),
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}