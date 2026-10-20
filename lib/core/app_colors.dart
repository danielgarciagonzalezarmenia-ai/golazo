import 'package:flutter/material.dart';

class GColors {
  GColors._();

  // Light
  static const Color primarioLight = Color(0xFF1FB155);
  static const Color primarioOscuroLight = Color(0xFF168A41);
  static const Color fondoLight = Color(0xFFF6FBF7);
  static const Color superficieLight = Color(0xFFFFFFFF);
  static const Color textoPrincipalLight = Color(0xFF0B1F3A);
  static const Color textoSecundarioLight = Color(0xFF5B6B7A);
  static const Color acentoDoradoLight = Color(0xFFFFC83D);
  static const Color naranjaRachaLight = Color(0xFFFF8A1F);
  static const Color correctoLight = Color(0xFF3DDC84);
  static const Color errorLight = Color(0xFFE5484D);
  static const Color avisoLight = Color(0xFFFFD60A);
  static const Color azulInfoLight = Color(0xFF2D7FF9);

  // Dark
  static const Color primarioDark = Color(0xFF2BD16B);
  static const Color primarioOscuroDark = Color(0xFF1A9A4D);
  static const Color fondoDark = Color(0xFF0B1410);
  static const Color superficieDark = Color(0xFF15221B);
  static const Color textoPrincipalDark = Color(0xFFF2F7F4);
  static const Color textoSecundarioDark = Color(0xFF9DB0A5);
  static const Color acentoDoradoDark = Color(0xFFFFD561);
  static const Color naranjaRachaDark = Color(0xFFFF9D45);
  static const Color correctoDark = Color(0xFF3DDC84);
  static const Color errorDark = Color(0xFFFF6369);
  static const Color avisoDark = Color(0xFFFFD60A);
  static const Color azulInfoDark = Color(0xFF5A9BFF);

  static Color primario(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? primarioDark
          : primarioLight;
  static Color primarioOscuro(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? primarioOscuroDark
          : primarioOscuroLight;
  static Color fondo(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? fondoDark
          : fondoLight;
  static Color superficie(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? superficieDark
          : superficieLight;
  static Color textoPrincipal(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? textoPrincipalDark
          : textoPrincipalLight;
  static Color textoSecundario(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? textoSecundarioDark
          : textoSecundarioLight;
  static Color acentoDorado(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? acentoDoradoDark
          : acentoDoradoLight;
  static Color naranjaRacha(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? naranjaRachaDark
          : naranjaRachaLight;
  static Color correcto(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? correctoDark
          : correctoLight;
  static Color error(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? errorDark
          : errorLight;
  static Color aviso(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? avisoDark
          : avisoLight;
  static Color azulInfo(BuildContext context) =>
      Brightness.dark == MediaQuery.of(context).platformBrightness
          ? azulInfoDark
          : azulInfoLight;
}
