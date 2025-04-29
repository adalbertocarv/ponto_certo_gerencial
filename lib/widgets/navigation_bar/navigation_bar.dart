import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/views/Sobre/sobre.dart';
import 'package:ponto_certo_gerencial/views/listas/listas_paradas.dart';

class NavigatorBar extends StatelessWidget {
  const NavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            child: Image.asset('assets/gdf.png'),
          ),
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 950) {
              return Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              );
            } else {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      child: NavBarItem('Listagem de paradas'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListasParadas())),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Sobre())),
                      child: NavBarItem('Sobre'),
                    ),
                  ),
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  const NavBarItem(
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
      ),
    );
  }
}
