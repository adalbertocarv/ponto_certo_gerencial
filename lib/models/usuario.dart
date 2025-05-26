class UsuarioModel {
  final int id;
  final String nome;
  final String? matricula;
  final String? email;
  final DateTime criadoEm;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.matricula,
    required this.email,
    required this.criadoEm,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['IdUsuario'],
      nome: json['NomeUsuario'] ?? '',
      matricula: json['MatriculaUsuario'],
      email: json['EmailUsuario'],
      criadoEm: DateTime.parse(json['CreatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NomeUsuario': nome,
      'MatriculaUsuario': matricula,
      'EmailUsuario': email,
    };
  }

  UsuarioModel copyWith({
    int? id,
    String? nome,
    String? matricula,
    String? email,
    DateTime? criadoEm,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      matricula: matricula ?? this.matricula,
      email: email ?? this.email,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
