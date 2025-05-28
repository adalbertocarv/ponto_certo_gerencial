import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class StatCard extends StatelessWidget {
  final String title;
  final int value;
  final String assetPath;
  final double height;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.assetPath,
    this.height = 140,
    this.color = const Color(0xFF0069B4), // azul SEMOB
  });

  @override
  Widget build(BuildContext context) {
    // formata 3610 → 3.610 (pt-BR)
    final valorStr = NumberFormat.decimalPattern('pt_BR').format(value);

    return Container(
      height: height,
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
            width: height - 32,          // mantém proporção dentro do card
            fit: BoxFit.contain,
          ),
          const Spacer(),
          // ─── textos ───
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
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
