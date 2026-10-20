import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

class GTheme {
  GTheme._();

  static CupertinoThemeData lightTheme() {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFF1FB155),
      barBackgroundColor: Color(0xFFF6FBF7),
      scaffoldBackgroundColor: Color(0xFFF6FBF7),
    );
  }

  static CupertinoThemeData darkTheme() {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFF2BD16B),
      barBackgroundColor: Color(0xFF0B1410),
      scaffoldBackgroundColor: Color(0xFF0B1410),
    );
  }

  static TextStyle titleStyle(BuildContext context,
      {double size = 34, FontWeight weight = FontWeight.w900}) {
    return TextStyle(
      fontFamily: 'BarlowCondensed',
      fontSize: size,
      fontWeight: weight,
      fontStyle: FontStyle.italic,
      color: GColors.textoPrincipal(context),
      letterSpacing: 0.5,
    );
  }

  static TextStyle cardTitleStyle(BuildContext context,
      {double size = 22}) {
    return TextStyle(
      fontFamily: 'SF Pro Rounded',
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: GColors.textoPrincipal(context),
    );
  }

  static TextStyle questionStyle(BuildContext context,
      {double size = 24}) {
    return TextStyle(
      fontFamily: 'SF Pro Rounded',
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: GColors.textoPrincipal(context),
      height: 1.25,
    );
  }

  static TextStyle answerStyle(BuildContext context,
      {double size = 18}) {
    return TextStyle(
      fontFamily: 'SF Pro Rounded',
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: GColors.textoPrincipal(context),
    );
  }

  static TextStyle bodyStyle(BuildContext context, {double size = 16}) {
    return TextStyle(
      fontFamily: 'SF Pro Rounded',
      fontSize: size,
      fontWeight: FontWeight.normal,
      color: GColors.textoSecundario(context),
      height: 1.4,
    );
  }

  static TextStyle captionStyle(BuildContext context, {double size = 13}) {
    return TextStyle(
      fontFamily: 'SF Pro Rounded',
      fontSize: size,
      fontWeight: FontWeight.normal,
      color: GColors.textoSecundario(context),
    );
  }

  static TextStyle buttonStyle(BuildContext context, {double size = 16}) {
    return TextStyle(
      fontFamily: 'SF Pro Rounded',
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 0.5,
    );
  }
}
