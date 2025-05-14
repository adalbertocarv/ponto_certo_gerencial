import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/views/mapa/mapa_pesquisa.dart';

class CallToAction extends StatelessWidget {
  final String title;
  const CallToAction(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        //  onTap: () => print('clicado'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapaPesquisa()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.blue.shade900,
            borderRadius: BorderRadius.circular(5),
          ),
          child: AutoSizeText(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
