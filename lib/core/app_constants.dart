class GConstants {
  GConstants._();

  static const String appName = 'GOLAZO';
  static const String eslogan = 'Aprende fútbol. Una racha a la vez.';
  static const String bundleId = 'com.daniel.golazo';
  static const String version = '1.0.0';

  // Niveles
  static const int totalNiveles = 6;
  static const int vidasMax = 5;
  static const int minutosRegeneracionVida = 30;
  static const int xpLeccionBase = 10;
  static const int xpLeccionSinErrores = 5;
  static const int xpExamenAprobado = 15;
  static const int examenMinimoPorcentaje = 80;
  static const int examenPreguntas = 15;

  // Horarios de racha (hora local)
  static const int rachaPeligroHora = 20;

  // Rarezas
  static const String rarezaComun = 'Común';
  static const String rarezaRara = 'Rara';
  static const String rarezaEpica = 'Épica';
  static const String rarezaLegendaria = 'Legendaria';

  // Rutas de assets
  static const String contentPath = 'assets/content';
  static const String preguntasPath = 'assets/content/preguntas.json';
}
