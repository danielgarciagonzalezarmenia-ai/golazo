import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/question.dart';

class ContentService {
  ContentService._();
  static final ContentService instance = ContentService._();

  List<Question> _todas = [];

  Future<List<Question>> cargarPreguntas() async {
    if (_todas.isNotEmpty) return _todas;
    final raw = await rootBundle.loadString('assets/content/preguntas.json');
    final List<dynamic> datos = jsonDecode(raw);
    _todas = datos.map((e) => Question.fromJson(e)).toList();
    return _todas;
  }

  List<Question> preguntasDeNivel(int nivel) =>
      _todas.where((p) => p.level == nivel).toList();

  List<Question> preguntasFalladas(List<String> ids) =>
      _todas.where((p) => ids.contains(p.id)).toList();

  Question? porId(String id) =>
      _todas.firstWhereOrNull((p) => p.id == id);
}

extension FirstWhereOrNull<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final elemento in this) {
      if (test(elemento)) return elemento;
    }
    return null;
  }
}
