import 'package:flutter/material.dart';
import 'views/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ponto Certo - Gerencial',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor:
              Colors.white, // Define o branco como cor de fundo do Scaffold
          colorScheme: ColorScheme.fromSwatch().copyWith(
            surface: Colors.white, // Define o branco como cor de fundo geral
          ),
          textTheme:
              Theme.of(context).textTheme.apply(fontFamily: 'Open Sans')),
      home: HomePage(),
    );
  }
}
