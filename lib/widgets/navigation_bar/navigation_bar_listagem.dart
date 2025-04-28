import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/views/home/home_page.dart';
import 'package:ponto_certo_gerencial/widgets/navigation_bar/navigation_bar.dart';

class NavigationBarListagem extends StatelessWidget {
  const NavigationBarListagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: NavBarItem('Paradas'),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage())),
                ),
              ),
              SizedBox(
                width: 60,
              ),
              MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage())),
                      child: NavBarItem('Abrigos'))),
            ],
          )
        ],
      ),
    );
  }
}
