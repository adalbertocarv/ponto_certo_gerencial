// services/usuario_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class UsuarioService {
  static const String _baseUrl = 'https://dados.semob.df.gov.br/usuarios';

  static Future<List<UsuarioModel>> buscarUsuarios() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => UsuarioModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar usuários');
    }
  }

  static Future<void> criarUsuario(UsuarioModel usuario) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'NomeUsuario': usuario.nome,
        'MatriculaUsuario': usuario.matricula,
        'EmailUsuario': usuario.email,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao criar usuário');
    }
  }

  static Future<void> atualizarUsuario(UsuarioModel usuario) async {
    final url = Uri.parse('$_baseUrl/${usuario.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'NomeUsuario': usuario.nome,
        'MatriculaUsuario': usuario.matricula,
        'EmailUsuario': usuario.email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
  }
}
