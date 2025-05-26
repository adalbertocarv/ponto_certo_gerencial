import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import 'package:ponto_certo_gerencial/services/dados_espaciais/pontos_paradas.dart';
import '../../models/pontos_paradas.dart';
import '../widgets/markers/popup_ponto_parada.dart';

class MapaParadas extends StatefulWidget {
  const MapaParadas({
    super.key,
    required this.filtro, // ⬅️ novo atributo
  });

  final String filtro; // ⬅️ guarda o texto

  @override
  State<MapaParadas> createState() => _MapaParadasState();
}

class _MapaParadasState extends State<MapaParadas> {
  // -------------------- Constantes de tunagem --------------------
  static const int _clusterRadius = 120;
  static const Size _clusterSize = Size(40, 40); // widget do círculo
  static const EdgeInsets _clusterPadding = EdgeInsets.all(80);

  final _popupController = PopupController();
  final _mapController = MapController();

  bool _carregando = true;
  LatLng? _localizacaoUsuario;

  List<ParadaModel> _pontos = []; // todos
  List<ParadaModel> _pontosFiltrados = []; // visíveis

  String _filtro = '';

  // -------------------- Ciclo de vida --------------------
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final dados = await PontoParadaRemoteService.buscarPontos();
    if (!mounted) return;
    setState(() {
      _pontos = dados;
    });
    _aplicarFiltro(widget.filtro);
  }

//-------------------------------filtros
  void _aplicarFiltro(String texto) {
    setState(() {
      _filtro = texto.trim().toLowerCase();

      _pontosFiltrados = _pontos.where((p) {
        if (_filtro.isEmpty) return true;

        bool contem(String? s) => s?.toLowerCase().contains(_filtro) ?? false;

        return contem(p.criadoPor) ||
            contem(p.criadoEm) || // se for DateTime → formate
            contem(p.visitadoEm) || // idem
            contem(p.endereco) ||
            contem(p.abrigoNome) ||
            contem(p.dscNome);
      }).toList();
    });
  }

  // -------------------- Build --------------------
  @override
  Widget build(BuildContext context) {
    // if (_carregando) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    /// Converte ParadaModel → Marker (chave = próprio objeto)
    final markers = _pontosFiltrados
        .map((p) => Marker(
              key: ValueKey(p),
              point: LatLng(p.latitude, p.longitude),
              width: 35,
              height: 35,
              child:
                  const Icon(Icons.location_pin, color: Colors.red, size: 35),
            ))
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          PopupScope(
            // ⬅️ ADICIONADO
            popupController: _popupController,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    _localizacaoUsuario ?? const LatLng(-15.7942, -47.8822),
                initialZoom: 12,
                onTap: (_, __) => _popupController.hideAllPopups(),
              ),
              children: [
                // --------- camada de azulejos OSM ---------
                TileLayer(
                  tileProvider: CancellableNetworkTileProvider(),
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),

                // --------- camada de CLUSTER + POPUP ---------
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    markers: markers,
                    maxClusterRadius: _clusterRadius,
                    size: _clusterSize,
                    padding: _clusterPadding,
                    disableClusteringAtZoom: 17, // mostra pontos individuais
                    // ---- ação no toque do cluster (zoom) ----
                    onClusterTap: (cluster) {
                      // inicia a caixa com o primeiro marcador
                      final bounds = LatLngBounds(
                        cluster.markers.first.point,
                        cluster.markers.first.point,
                      );

                      // estende para os demais
                      for (final m in cluster.markers) {
                        bounds.extend(m.point);
                      }

                      _mapController.fitBounds(
                        bounds,
                        options: const FitBoundsOptions(
                          padding: EdgeInsets.all(100),
                          maxZoom: 17,
                        ),
                      );
                    },

                    // ---- estilo visual do circle-cluster ----
                    builder: (context, clusterMarkers) => Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${clusterMarkers.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // ---- popups integrados ----
                    popupOptions: PopupOptions(
                      popupController: _popupController,
                      popupSnap: PopupSnap.markerTop, // mantém o snap no topo
                      popupBuilder: (ctx, marker) {
                        final parada =
                            (marker.key as ValueKey).value as ParadaModel;
                        return PopupPontoParada(
                          pontoParada: parada,
                          popupController: _popupController,
                        );
                      },
                    ),
                  ),
                ),

                const SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                ),
              ],
            ),
          ),
          // -------- botão voltar --------
          Positioned(
            top: 30,
            left: 40,
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
