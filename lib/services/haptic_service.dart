import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HapticService {
  HapticService._();
  static final HapticService instance = HapticService._();

  bool _activado = true;

  void setActivado(bool valor) => _activado = valor;
  bool get activado => _activado;

  void light() {
    if (!_activado) return;
    HapticFeedback.lightImpact();
  }

  void selection() {
    if (!_activado) return;
    HapticFeedback.selectionClick();
  }

  void success() {
    if (!_activado) return;
    HapticFeedback.heavyImpact();
  }

  void error() {
    if (!_activado) return;
    HapticFeedback.mediumImpact();
  }

  void heavy() {
    if (!_activado) return;
    HapticFeedback.heavyImpact();
  }

  void medium() {
    if (!_activado) return;
    HapticFeedback.mediumImpact();
  }
}
