import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/views/Sobre/sobre.dart';
import 'package:ponto_certo_gerencial/views/cadastro/cadastro_usuario.dart';
import 'package:ponto_certo_gerencial/views/analise/analise.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/login_page.dart';

class CustomNavigatorBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomNavigatorBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 950) {
        // Para telas menores, mostrar logo e botão de menu
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Abrindo o drawer usando a chave do Scaffold
                scaffoldKey.currentState!.openDrawer();
              },
            ),
            Image.asset('assets/gdf.png', height: 60),
          ],
        );
      } else {
        // Para telas maiores, mostrar o menu na horizontal
        final menuItems = DrawerMenu()._getMenuItems(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/gdf.png', height: 60),
            Row(
              children: menuItems
                  .map((item) => _navButton(context, item.title, item.onTap))
                  .toList(),
            ),
          ],
        );
      }
    });
  }

  Widget _navButton(BuildContext context, String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(title, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

class MenuItemData {
  final String title;
  final VoidCallback onTap;

  MenuItemData({required this.title, required this.onTap});
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = _getMenuItems(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[900]),
            child: const Text('Menu', style: TextStyle(color: Colors.white)),
          ),
          ...menuItems.map((item) => ListTile(
                title: Text(item.title),
                onTap: () {
                  // Fechando o drawer antes de navegar
                  Navigator.of(context).pop();
                  item.onTap();
                },
              )),
        ],
      ),
    );
  }

  List<MenuItemData> _getMenuItems(BuildContext context) {
    return [
      MenuItemData(
        title: 'Análise',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Analise()));
        },
      ),
      MenuItemData(
        title: 'Cadastrar usuário',
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => CadastroTrabalhadorScreen()));
        },
      ),
      MenuItemData(
        title: 'Sobre',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Sobre()));
        },
      ),
      MenuItemData(
        title: 'Sair',
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
      ),
    ];
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  const NavBarItem(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
      ),
    );
  }
}
