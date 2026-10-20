import 'question.dart';

class UserProgress {
  String apodo;
  int nivel;
  int xpTotal;
  int rachaActual;
  int rachaMaxima;
  int vidas;
  DateTime ultimaVidaRegenerada;
  DateTime ultimoJuego;
  int leccionesCompletadas;
  int respuestasCorrectas;
  int respuestasIncorrectas;
  List<String> preguntasFalladas;
  Map<String, int> unidadesCompletadas;
  Map<String, int> leccionesCompletadasMap;
  List<QuestionAnswer> historialRespuestas;
  int estrellasTotales;
  bool escudoActivo;
  DateTime escudoExpira;

  UserProgress({
    this.apodo = '',
    this.nivel = 1,
    this.xpTotal = 0,
    this.rachaActual = 0,
    this.rachaMaxima = 0,
    this.vidas = 5,
    required this.ultimaVidaRegenerada,
    required this.ultimoJuego,
    this.leccionesCompletadas = 0,
    this.respuestasCorrectas = 0,
    this.respuestasIncorrectas = 0,
    this.preguntasFalladas = const [],
    this.unidadesCompletadas = const {},
    this.leccionesCompletadasMap = const {},
    this.historialRespuestas = const [],
    this.estrellasTotales = 0,
    this.escudoActivo = false,
    required this.escudoExpira,
  });

  factory UserProgress.empty() {
    final ahora = DateTime.now();
    return UserProgress(
      ultimaVidaRegenerada: ahora,
      ultimoJuego: ahora,
      escudoExpira: ahora,
    );
  }

  Map<String, dynamic> toJson() => {
    'apodo': apodo,
    'nivel': nivel,
    'xpTotal': xpTotal,
    'rachaActual': rachaActual,
    'rachaMaxima': rachaMaxima,
    'vidas': vidas,
    'ultimaVidaRegenerada': ultimaVidaRegenerada.toIso8601String(),
    'ultimoJuego': ultimoJuego.toIso8601String(),
    'leccionesCompletadas': leccionesCompletadas,
    'respuestasCorrectas': respuestasCorrectas,
    'respuestasIncorrectas': respuestasIncorrectas,
    'preguntasFalladas': preguntasFalladas,
    'unidadesCompletadas': unidadesCompletadas,
    'leccionesCompletadasMap': leccionesCompletadasMap,
    'historialRespuestas':
        historialRespuestas.map((e) => e.toJson()).toList(),
    'estrellasTotales': estrellasTotales,
    'escudoActivo': escudoActivo,
    'escudoExpira': escudoExpira.toIso8601String(),
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
    apodo: json['apodo'] as String? ?? '',
    nivel: json['nivel'] as int? ?? 1,
    xpTotal: json['xpTotal'] as int? ?? 0,
    rachaActual: json['rachaActual'] as int? ?? 0,
    rachaMaxima: json['rachaMaxima'] as int? ?? 0,
    vidas: json['vidas'] as int? ?? 5,
    ultimaVidaRegenerada: DateTime.parse(
      json['ultimaVidaRegenerada'] as String? ?? DateTime.now().toIso8601String(),
    ),
    ultimoJuego: DateTime.parse(
      json['ultimoJuego'] as String? ?? DateTime.now().toIso8601String(),
    ),
    leccionesCompletadas: json['leccionesCompletadas'] as int? ?? 0,
    respuestasCorrectas: json['respuestasCorrectas'] as int? ?? 0,
    respuestasIncorrectas: json['respuestasIncorrectas'] as int? ?? 0,
    preguntasFalladas: (json['preguntasFalladas'] as List? ?? [])
        .cast<String>(),
    unidadesCompletadas: (json['unidadesCompletadas'] as Map? ?? {})
        .map((k, v) => MapEntry(k as String, v as int)),
    leccionesCompletadasMap: (json['leccionesCompletadasMap'] as Map? ?? {})
        .map((k, v) => MapEntry(k as String, v as int)),
    historialRespuestas: (json['historialRespuestas'] as List? ?? [])
        .map((e) => QuestionAnswer.fromJson(e as Map<String, dynamic>))
        .toList(),
    estrellasTotales: json['estrellasTotales'] as int? ?? 0,
    escudoActivo: json['escudoActivo'] as bool? ?? false,
    escudoExpira: DateTime.parse(
      json['escudoExpira'] as String? ?? DateTime.now().toIso8601String(),
    ),
  );
}
