import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ParadaModel {
  final String criadoPor;
  final String criadoEm;
  final String visitadoEm;
  final String endereco;
  final String abrigoNome;
  final String abrigoImg;
  final double latitude;
  final double longitude;
  final String dscNome; // Nome da RA
  final String dscBacia;
  final bool linhaEscolar;
  final bool linhaStpc;

  ParadaModel({
    required this.criadoPor,
    required this.criadoEm,
    required this.visitadoEm,
    required this.endereco,
    required this.abrigoNome,
    required this.abrigoImg,
    required this.latitude,
    required this.longitude,
    required this.dscNome,
    required this.dscBacia,
    required this.linhaEscolar,
    required this.linhaStpc,
  });

  factory ParadaModel.fromJson(Map<String, dynamic> json) {
    return ParadaModel(
      criadoPor: json['criado_por'] ?? '',
      criadoEm: json['criado_em'] ?? '',
      visitadoEm: json['visitado_em'] ?? '',
      endereco: json['endereco'] ?? '',
      abrigoNome: json['abrigo_nome'] ?? '',
      abrigoImg: json['abrigo_img'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      dscNome: json['dsc_nome'] ?? '',
      dscBacia: json['dsc_bacia'] ?? '',
      linhaEscolar: json['linha_escolar'] ?? false,
      linhaStpc: json['linha_stpc'] ?? false,
    );
  }

  static ParadaModel empty() {
    return ParadaModel(
      criadoPor: '',
      criadoEm: '',
      visitadoEm: '',
      endereco: '',
      abrigoNome: '',
      abrigoImg: '',
      latitude: 0.0,
      longitude: 0.0,
      dscNome: '',
      dscBacia: '',
      linhaEscolar: false,
      linhaStpc: false,
    );
  }
}


// popup
class PontoParada {
  final String criadoPor;
  final DateTime criadoEm;
  final DateTime visitadoEm;
  final String endereco;
  final String abrigoNome;
  final String abrigoImg;
  final double latitude;
  final double longitude;
  final bool linhaEscolar;
  final bool linhaStpc;

  PontoParada({
    required this.criadoPor,
    required this.criadoEm,
    required this.visitadoEm,
    required this.endereco,
    required this.abrigoNome,
    required this.abrigoImg,
    required this.latitude,
    required this.longitude,
    required this.linhaEscolar,
    required this.linhaStpc,
  });

  factory PontoParada.fromParadaModel(ParadaModel model) {
    return PontoParada(
      criadoPor: model.criadoPor,
      criadoEm: DateTime.tryParse(model.criadoEm) ?? DateTime.now(),
      visitadoEm: DateTime.tryParse(model.visitadoEm) ?? DateTime.now(),
      endereco: model.endereco,
      abrigoNome: model.abrigoNome,
      abrigoImg: model.abrigoImg,
      latitude: model.latitude,
      longitude: model.longitude,
      linhaEscolar: model.linhaEscolar,
      linhaStpc: model.linhaStpc,
    );
  }


}
class PopupMarker extends Marker {
  final PontoParada pontoParada;

  PopupMarker({
    required this.pontoParada,
  }) : super(
    point: LatLng(pontoParada.latitude, pontoParada.longitude),
    width: 40,
    height: 40,
    child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
  );
  static ParadaModel empty() {
    return ParadaModel(
      criadoPor: '',
      criadoEm: '',
      visitadoEm: '',
      endereco: '',
      abrigoNome: '',
      abrigoImg: '',
      dscNome: '',
      dscBacia: '',
      latitude: 0.0,
      longitude: 0.0,
      linhaEscolar: false,
      linhaStpc: false,
    );
  }

}