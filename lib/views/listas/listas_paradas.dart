import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/widgets/centered_view/centered_view.dart';
import 'package:ponto_certo_gerencial/widgets/navigation_bar/navigation_bar_listagem.dart';

class ListasParadas extends StatefulWidget {
  const ListasParadas({super.key});

  @override
  State<ListasParadas> createState() => _ListasParadasState();
}

class _ListasParadasState extends State<ListasParadas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
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
                  NavigationBarListagem(),
                  SizedBox(
                    height: 80,
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
