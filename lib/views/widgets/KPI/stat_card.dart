import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatCard extends StatelessWidget {
  final String titulo;
  final int valor;
  final String assetPath;
  final double altura;
  final Color color;

  const StatCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.assetPath,
    this.altura = 140,
    this.color = const Color(0xFF0069B4), // azul SEMOB
  });

  @override
  Widget build(BuildContext context) {
    // formata 3610 → 3.610 (pt-BR)
    final valorStr = NumberFormat.decimalPattern('pt_BR').format(valor);

    return Container(
      height: altura,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // ─── imagem ───
          Image.asset(
            assetPath,
            width: altura - 32, // mantém proporção dentro do card
            fit: BoxFit.contain,
          ),
          const Spacer(),
          // ─── textos ───
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valorStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
