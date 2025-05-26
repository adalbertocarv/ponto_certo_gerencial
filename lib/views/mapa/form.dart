import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Formulario extends StatefulWidget {
  const Formulario({
    super.key,
    required this.onFiltroMudou,
  });

  /// Callback que devolve o filtro digitado ou pesquisado.
  final ValueChanged<String> onFiltroMudou;

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _controller = TextEditingController();

  void _enviarFiltro() => widget.onFiltroMudou(_controller.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // mantém altura compacta
        children: [
          const SizedBox(height: 12),
          const Text(
            'Parada de ônibus:',
            style: TextStyle(fontSize: 18),
          ),
          Material(
            child: TextFormField(
              controller: _controller,
              onChanged: widget.onFiltroMudou,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Endereço, ID da parada, Tipo do abrigo',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[300],
                prefixIcon: const Icon(Icons.directions_bus_filled,
                    color: Color(0xFF448AFF)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              ),
              onFieldSubmitted: (_) => _enviarFiltro(),
            ),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: _enviarFiltro, // 🔑 botão usa o mesmo callback
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent[200],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.loupe, color: Colors.white),
            label: Text(
              'Buscar Parada',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
