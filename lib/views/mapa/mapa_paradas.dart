import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ponto_certo_gerencial/services/dados_espaciais/pontos_paradas.dart';
import '../../models/pontos_paradas.dart';
import '../../widgets/markers/popup_ponto_parada.dart';

class MapaParadas extends StatefulWidget {
  const MapaParadas({super.key});

  @override
  State<MapaParadas> createState() => _MapaParadasState();
}

class _MapaParadasState extends State<MapaParadas> {
  final PopupController popupController = PopupController();
  List<ParadaModel> pontosRemotos = [];
  bool _carregando = true;
  LatLng? _localizacaoUsuario;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    // await _localizarUsuario();
    try {
      final dados = await PontoParadaRemoteService.buscarPontos();
      if (mounted) {
        setState(() {
          pontosRemotos = dados;
          _carregando = false;
        });
      }
    } catch (_) {
      setState(() {
        _carregando = false;
      });
    }
  }

/*
  Future<void> _localizarUsuario() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) return;
      Position position = await Geolocator.getCurrentPosition();
      _localizacaoUsuario = LatLng(position.latitude, position.longitude);
    } catch (_) {}
  }*/

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final markersRemotos = pontosRemotos.map((ponto) {
      return Marker(
        point: LatLng(ponto.latitude, ponto.longitude),
        width: 35,
        height: 35,
        child: const Icon(Icons.location_pin, color: Colors.red, size: 35),
      );
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _localizacaoUsuario ?? LatLng(-15.7942, -47.8822),
              initialZoom: 12.0,
              onTap: (_, __) => popupController.hideAllPopups(),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
                  markers: markersRemotos,
                  popupController: popupController,
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (BuildContext context, Marker marker) {
                      final ponto = pontosRemotos.firstWhere(
                        (p) =>
                            p.latitude == marker.point.latitude &&
                            p.longitude == marker.point.longitude,
                        orElse: () => ParadaModel.empty(),
                      );

                      return PopupPontoParada(
                        pontoParada: ponto,
                        popupController: popupController,
                      );
                    },
                  ),
                ),
              ),
              SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 40,
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
