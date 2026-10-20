import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GStorage {
  GStorage._();
  static final GStorage instance = GStorage._();

  SharedPreferences? _prefs;
  Directory? _docDir;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _docDir = await getApplicationDocumentsDirectory();
  }

  SharedPreferences get prefs => _prefs!;

  Future<Directory> get docsDir async =>
      _docDir ??= await getApplicationDocumentsDirectory();

  Future<String> _progressPath() async {
    final dir = await docsDir;
    return '${dir.path}/progress.json';
  }

  Future<void> saveJson(String key, Map<String, dynamic> data) async {
    await prefs.setString(key, jsonEncode(data));
  }

  Map<String, dynamic>? readJson(String key) {
    final s = prefs.getString(key);
    if (s == null) return null;
    return jsonDecode(s) as Map<String, dynamic>;
  }

  Future<void> saveProgress(Map<String, dynamic> progress) async {
    final path = await _progressPath();
    final file = File(path);
    await file.writeAsString(jsonEncode(progress));
  }

  Future<Map<String, dynamic>> loadProgress() async {
    final path = await _progressPath();
    final file = File(path);
    if (!await file.exists()) return {};
    final s = await file.readAsString();
    return jsonDecode(s) as Map<String, dynamic>;
  }

  T? get<T>(String key) => prefs.get(key) as T?;
  Future<bool> set(String key, dynamic value) async {
    if (value is String) return await prefs.setString(key, value);
    if (value is int) return await prefs.setInt(key, value);
    if (value is double) return await prefs.setDouble(key, value);
    if (value is bool) return await prefs.setBool(key, value);
    return Future.value(false);
  }
}
