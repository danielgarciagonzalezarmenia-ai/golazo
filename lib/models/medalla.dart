import 'package:flutter/material.dart';

class Medalla {
  final String id;
  final String nombre;
  final String descripcion;
  final IconData icono;
  final bool desbloqueada;
  final DateTime? fechaDesbloqueo;

  Medalla({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    this.desbloqueada = false,
    this.fechaDesbloqueo,
  });

  Medalla copyWith({bool? desbloqueada, DateTime? fechaDesbloqueo}) =>
      Medalla(
        id: id,
        nombre: nombre,
        descripcion: descripcion,
        icono: icono,
        desbloqueada: desbloqueada ?? this.desbloqueada,
        fechaDesbloqueo: fechaDesbloqueo ?? this.fechaDesbloqueo,
      );
}
