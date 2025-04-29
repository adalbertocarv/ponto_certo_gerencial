import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Formulario extends StatelessWidget {
  const Formulario({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          DefaultTextStyle(
              style: TextStyle(fontSize: 18),
              child: Text(
                "Parada de ônibus:",
              )),
          Material(
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Endereço, ID da parada, Tipo do abrigo',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[300],
                prefixIcon: Icon(
                  Icons.directions_bus_filled,
                  color: const Color(0xFF448AFF),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent[200],
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: Icon(
              Icons.loupe,
              color: Colors.white,
            ),
            label: Text(
              'Buscar Parada',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
