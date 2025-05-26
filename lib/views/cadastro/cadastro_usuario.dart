import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ponto_certo_gerencial/models/usuario.dart';
import 'package:ponto_certo_gerencial/views/widgets/centered_view/centered_view.dart';
import '../../services/usuario.dart';
import '../home/home_page.dart';
import '../widgets/navigation_bar/navigation_bar.dart';

class CadastroTrabalhadorScreen extends StatefulWidget {
  const CadastroTrabalhadorScreen({super.key});

  @override
  State<CadastroTrabalhadorScreen> createState() =>
      _CadastroTrabalhadorScreenState();
}

class _CadastroTrabalhadorScreenState extends State<CadastroTrabalhadorScreen> {
  final _nomeController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _emailController = TextEditingController();
  final _filtroController = TextEditingController();
  List<UsuarioModel> _usuarios = [];
  List<UsuarioModel> _usuariosFiltrados = [];

  bool _carregandoUsuarios = true;

  final _matriculaFormatter = MaskTextInputFormatter(
    mask: '###.###-#',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Cadastrar usuario
  void _salvarCadastro() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final novoUsuario = UsuarioModel(
      id: 0,
      nome: _nomeController.text.trim(),
      matricula: _matriculaFormatter.getUnmaskedText(),
      email: _emailController.text.trim(),
      criadoEm: DateTime.now(),
    );

    try {
      await UsuarioService.criarUsuario(novoUsuario);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      _nomeController.clear();
      _matriculaController.clear();
      _emailController.clear();
      await _carregarUsuarios();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar usuário: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isSaving = false;
    });
  }

  // Método PUT
  void _mostrarDialogoEdicao(UsuarioModel usuario) {
    final nomeController = TextEditingController(text: usuario.nome);
    final matriculaController = TextEditingController(text: usuario.matricula);
    final emailController = TextEditingController(text: usuario.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Usuário'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: matriculaController,
                decoration: const InputDecoration(labelText: 'Matrícula'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final novoUsuario = UsuarioModel(
                  id: usuario.id,
                  nome: nomeController.text.trim(),
                  matricula: matriculaController.text.trim(),
                  email: emailController.text.trim(),
                  criadoEm: usuario.criadoEm,
                );
                await UsuarioService.atualizarUsuario(novoUsuario);
                Navigator.pop(context);
                _carregarUsuarios();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      validator: validator,
    );
  }

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  // Método GET
  Future<void> _carregarUsuarios() async {
    try {
      final usuarios = await UsuarioService.buscarUsuarios();
      setState(() {
        _usuarios = usuarios;
        _usuariosFiltrados = usuarios;
        _carregandoUsuarios = false;
      });
    } catch (e) {
      setState(() => _carregandoUsuarios = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao carregar usuários: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  // Filtrar
  void _filtrarUsuarios(String texto) {
    final textoLower = texto.toLowerCase();
    setState(() {
      _usuariosFiltrados = _usuarios.where((u) {
        return u.nome.toLowerCase().contains(textoLower) ||
            (u.matricula ?? '').toLowerCase().contains(textoLower) ||
            (u.email ?? '').toLowerCase().contains(textoLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 245),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: CenteredView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botão Voltar
              if (screenWidth > 950)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        ),
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        ),
                        child: NavBarItem('Voltar'),
                      ),
                    ),
                  ],
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Voltar',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Formulário de Cadastro
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 550 : screenWidth * 0.9,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Cadastrar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),
                          _buildTextField(
                            'Nome completo',
                            _nomeController,
                            validator: (value) =>
                                value!.isEmpty ? 'Informe o nome' : null,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            'Matrícula',
                            _matriculaController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [_matriculaFormatter],
                            validator: (value) =>
                                value!.isEmpty ? 'Informe a matrícula' : null,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            'E-mail',
                            _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Informe o e-mail';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              return emailRegex.hasMatch(value)
                                  ? null
                                  : 'E-mail inválido';
                            },
                          ),
                          const SizedBox(height: 30),
                          _isSaving
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _salvarCadastro,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Text(
                                    'Salvar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Seção de Usuários Cadastrados
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 800 : screenWidth * 0.95,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Usuários Cadastrados',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text('Total de usuários: ${_usuarios.length}'),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _filtroController,
                        onChanged: _filtrarUsuarios,
                        decoration: const InputDecoration(
                          labelText: 'Buscar usuário...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Lista de Usuários
                      _carregandoUsuarios
                          ? const Center(child: CircularProgressIndicator())
                          : _usuarios.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text('Nenhum usuário cadastrado.'),
                                  ),
                                )
                              : Column(
                                  children: _usuariosFiltrados
                                      .map((usuario) => Card(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: ListTile(
                                              title: Text(usuario.nome),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Matrícula: ${usuario.matricula}'),
                                                  Text(
                                                      'Email: ${usuario.email}'),
                                                  Text(
                                                    'Criado em: ${usuario.criadoEm.toLocal().toString().split(' ')[0]}',
                                                  ),
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.blue),
                                                onPressed: () {
                                                  _mostrarDialogoEdicao(
                                                      usuario);
                                                },
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30), // Espaço no final
            ],
          ),
        ),
      ),
    );
  }
}
