import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  Future<void> _entrar() async {
    setState(() => _carregando = true);
    try {
      final credenciais =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      final usuario = credenciais.user;

      if (usuario != null) {
        await FirebaseFirestore.instance
            .collection("usuarios")
            .doc(usuario.uid)
            .set({
          "uid": usuario.uid,
          "email": usuario.email,
          "ultimoLogin": FieldValue.serverTimestamp(),
          "perfil": "admin",
        }, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao autenticar: ${e.message}")),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(245, 245, 245, 245),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Login Administrativo',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _senhaController,
                  decoration: const InputDecoration(labelText: "Senha"),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                _carregando
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _entrar,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text("Entrar",
                            style: TextStyle(color: Colors.white)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
