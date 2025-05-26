import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/base_url.dart';
import '../../models/pontos_paradas.dart';

class PontoParadaRemoteService {
  static Future<List<ParadaModel>> buscarPontos() async {
    //final url = Uri.parse('${CaminhoBackend.baseUrl}/pontos/novos/pontos');
    final url = Uri.parse('http://10.233.144.111:8080/pontos/novos/pontos');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(response.body);
        return dados.map((json) => ParadaModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Erro ao buscar pontos. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na requisição: $e');
    }
  }
}
