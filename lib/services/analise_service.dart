import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, dynamic>>> buscarAbrigosAgrupados() async {
  final url = Uri.parse('https://dados.semob.df.gov.br/pontos/novos/pontos');
  final resp = await http.get(url);

  if (resp.statusCode != 200) {
    throw Exception('Erro ${resp.statusCode} ao buscar dados');
  }

  final List<dynamic> jsonList = json.decode(resp.body) as List<dynamic>;

  // Agrupa por abrigo_nome
  final Map<String, int> contagem = {};
  for (final item in jsonList) {
    final tipo = (item as Map<String, dynamic>)['abrigo_nome'] as String? ??
        'Desconhecido';
    contagem[tipo] = (contagem[tipo] ?? 0) + 1;
  }

  // Converte para o formato (“Interactive Bar Chart” espera uma lista de maps)
  return contagem.entries
      .map((e) => {
            'tipo': e.key, // eixo X
            'quantidade': e.value, // eixo Y
          })
      .toList()
    // opcional: ordena desc
    ..sort((a, b) => (b['quantidade'] as int) - (a['quantidade'] as int));
}