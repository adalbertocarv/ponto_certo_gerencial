import 'package:flutter/material.dart';
import 'package:ponto_certo_gerencial/views/Sobre/sobre.dart';
import 'package:ponto_certo_gerencial/views/cadastro/cadastro_usuario.dart';
import 'package:ponto_certo_gerencial/views/listas/listas_paradas.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/login_page.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ponto Certo'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        flexibleSpace: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NavigatorBar(),
        ),
      ),
      drawer: const DrawerMenu(),
      body: const Center(
        child: Text('Conteúdo principal'),
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
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu', style: TextStyle(color: Colors.white)),
          ),
          ...menuItems.map((item) => ListTile(
                title: Text(item.title),
                onTap: item.onTap,
              )),
        ],
      ),
    );
  }

  List<MenuItemData> _getMenuItems(BuildContext context) {
    return [
      MenuItemData(
        title: 'Listagem de paradas',
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ListasParadas()));
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

class NavigatorBar extends StatelessWidget {
  const NavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 950) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/gdf.png', height: 60),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ],
        );
      } else {
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

class NavBarItem extends StatelessWidget {
  final String title;
  const NavBarItem(this.title, {super.key});

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
