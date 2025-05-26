import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import '../../models/pontos_paradas.dart';
import '../../services/dados_espaciais/pontos_paradas.dart';
import '../widgets/markers/popup_ponto_parada.dart';

class MapaParadasPesquisa extends StatefulWidget {
  const MapaParadasPesquisa({super.key});

  @override
  State<MapaParadasPesquisa> createState() => _MapaParadasPesquisaState();
}

class _MapaParadasPesquisaState extends State<MapaParadasPesquisa> {
  // -------------------- cluster tuning --------------------
  static const int _clusterRadius = 120;
  static const Size _clusterSize = Size(40, 40);
  static const EdgeInsets _clusterPadding = EdgeInsets.all(80);

  final _mapController = MapController();
  final _popupController = PopupController();
  final _buscaController = TextEditingController();

  List<ParadaModel> _todos = [];
  List<ParadaModel> _visiveis = [];

  bool _carregando = true;

  // -------------------- ciclo de vida --------------------
  @override
  void initState() {
    super.initState();
    _carregarDados();
    _buscaController.addListener(() => _aplicarFiltro(_buscaController.text));
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  // -------------------- carregar pontos --------------------
  Future<void> _carregarDados() async {
    final dados = await PontoParadaRemoteService.buscarPontos();
    if (!mounted) return;
    setState(() {
      _todos = dados;
      _visiveis = dados;
      _carregando = false;
    });
  }

  // -------------------- filtro --------------------
  void _aplicarFiltro(String texto) {
    final termo = texto.trim().toLowerCase();

    setState(() {
      if (termo.isEmpty) {
        _visiveis = _todos;
        return;
      }

      bool contem(String? s) => s?.toLowerCase().contains(termo) ?? false;

      _visiveis = _todos.where((p) {
        // Correção: verificar se os campos são DateTime antes de fazer casting
        String criado = '';
        String visitado = '';

        if (p.criadoEm != null) {
          try {
            if (p.criadoEm is DateTime) {
              criado = DateFormat('dd/MM/yyyy').format(p.criadoEm as DateTime);
            } else if (p.criadoEm is String) {
              criado = p.criadoEm as String;
            }
          } catch (e) {
            // Se houver erro na conversão, usar string vazia
            criado = '';
          }
        }

        if (p.visitadoEm != null) {
          try {
            if (p.visitadoEm is DateTime) {
              visitado =
                  DateFormat('dd/MM/yyyy').format(p.visitadoEm as DateTime);
            } else if (p.visitadoEm is String) {
              visitado = p.visitadoEm as String;
            }
          } catch (e) {
            // Se houver erro na conversão, usar string vazia
            visitado = '';
          }
        }

        return contem(p.criadoPor) ||
            contem(criado) ||
            contem(visitado) ||
            contem(p.endereco) ||
            contem(p.abrigoNome) ||
            contem(p.dscNome);
      }).toList();
    });
  }

  // -------------------- build --------------------
  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDesktop = MediaQuery.of(context).size.width > 950;
    final mapa = _buildFlutterMap();

    return Scaffold(
      body: isDesktop ? _buildDesktopLayout(mapa) : _buildMobileLayout(mapa),
    );
  }

  // -------------------------------------------------------------------------
  // -------------------- WIDGETS AUXILIARES ---------------------------------
  // -------------------------------------------------------------------------

  Widget _buildFlutterMap() {
    // Correção: usar uma key única baseada nos IDs ou coordenadas
    final markers = _visiveis
        .map(
          (p) => Marker(
            key: ValueKey('${p.latitude}_${p.longitude}_${p.hashCode}'),
            point: LatLng(p.latitude, p.longitude),
            width: 35,
            height: 35,
            child: const Icon(Icons.location_pin, color: Colors.red, size: 35),
          ),
        )
        .toList();

    return PopupScope(
      popupController: _popupController,
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(-15.7942, -47.8822),
          initialZoom: 12,
          onTap: (_, __) => _popupController.hideAllPopups(),
        ),
        children: [
          TileLayer(
            tileProvider: CancellableNetworkTileProvider(),
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerClusterLayerWidget(
            // Correção: key mais específica para forçar rebuild quando a lista muda
            key: ValueKey('cluster_${_visiveis.length}_${_visiveis.hashCode}'),
            options: MarkerClusterLayerOptions(
              markers: markers,
              maxClusterRadius: _clusterRadius,
              size: _clusterSize,
              padding: _clusterPadding,
              disableClusteringAtZoom: 17,
              builder: (_, clusterMarkers) => Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${clusterMarkers.length}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              popupOptions: PopupOptions(
                popupController: _popupController,
                popupSnap: PopupSnap.markerTop,
                popupBuilder: (_, marker) {
                  // Correção: encontrar a parada baseada na posição do marker
                  final markerPoint = marker.point;
                  final parada = _visiveis.firstWhere(
                    (p) =>
                        p.latitude == markerPoint.latitude &&
                        p.longitude == markerPoint.longitude,
                  );
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
    );
  }

  // ------------ DESKTOP ----------------
  Widget _buildDesktopLayout(Widget mapa) {
    return Row(
      children: [
        Container(
          width: 380,
          color: Colors.grey[100],
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCampoBusca(),
              ),
              // Contador de resultados
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Mostrando ${_visiveis.length} de ${_todos.length} paradas',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              // Lista de cards com scroll
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _visiveis.length,
                  itemBuilder: (context, index) {
                    final parada = _visiveis[index];
                    return _buildCardParada(parada);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(child: mapa),
      ],
    );
  }

  // ------------ MOBILE -----------------
  Widget _buildMobileLayout(Widget mapa) {
    return Stack(
      children: [
        mapa,
        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: _buildCampoBusca(),
        ),
        // -------- botão voltar --------
        Positioned(
          top: 120,
          left: 16,
          child: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
        ),
        // Adicionar contador de resultados para mobile (opcional)
        Positioned(
          bottom: 20,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_visiveis.length}/${_todos.length} paradas',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------ HEADER COM LOGO ------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          // Botão de voltar
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 18,
                color: Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('SECRETARIA DE TRANSPORTE E MOBILIDADE'),
                  Text(
                    'SEMOB',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(3.5),
            child: const Image(
              image: AssetImage('assets/gdf.png'),
              height: 70,
            ),
          ),
        ],
      ),
    );
  }

  // ------------ CAMPO DE BUSCA ------------
  Widget _buildCampoBusca() {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(15),
      child: TextField(
        controller: _buscaController,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Endereço, ID da parada, tipo de abrigo…',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, color: Color(0xFF448AFF)),
          suffixIcon: _buscaController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _buscaController.clear();
                    _aplicarFiltro('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
      ),
    );
  }

  // ------------ CARD DA PARADA ------------
  Widget _buildCardParada(ParadaModel parada) {
    // Formatação das datas
    String formatarData(dynamic data) {
      if (data == null) return 'Não informado';
      try {
        if (data is DateTime) {
          return DateFormat('dd/MM/yyyy HH:mm').format(data);
        } else if (data is String) {
          final date = DateTime.parse(data);
          return DateFormat('dd/MM/yyyy HH:mm').format(date);
        }
      } catch (e) {
        return 'Data inválida';
      }
      return 'Não informado';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Centralizar no mapa
            _mapController.move(
              LatLng(parada.latitude, parada.longitude),
              16,
            );

            // Mostrar popup
            final marker = Marker(
              point: LatLng(parada.latitude, parada.longitude),
              width: 35,
              height: 35,
              child:
                  const Icon(Icons.location_pin, color: Colors.red, size: 35),
            );
            _popupController.showPopupsOnlyFor([marker]);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do card com abrigo
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF448AFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        parada.abrigoNome ?? 'Sem abrigo',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF448AFF),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (parada.linhaEscolar == true)
                      const Icon(
                        Icons.school,
                        size: 16,
                        color: Colors.orange,
                      ),
                    if (parada.linhaStpc == true)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.directions_bus,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Endereço
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        parada.endereco ?? 'Endereço não informado',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Criado por
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        parada.criadoPor ?? 'Não informado',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Datas
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Criado: ${formatarData(parada.criadoEm)}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Visitado: ${formatarData(parada.visitadoEm)}',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Coordenadas
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Lat: ${parada.latitude.toStringAsFixed(6)}, Lng: ${parada.longitude.toStringAsFixed(6)}',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
