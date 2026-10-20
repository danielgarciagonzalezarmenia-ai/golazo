import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../services/services.dart';
import '../screens/lesson_screen.dart';
import '../widgets/widgets.dart';

class CaminoScreen extends StatefulWidget {
  const CaminoScreen({super.key});

  @override
  State<CaminoScreen> createState() => _CaminoScreenState();
}

class _CaminoScreenState extends State<CaminoScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _abrirLeccion(String leccionId, int nivel) async {
    final servicio = ContentService.instance;
    await servicio.cargarPreguntas();
    final todas = servicio.preguntasDeNivel(nivel);
    if (todas.isEmpty) return;
    final seleccion = todas.take(8).toList();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => LessonScreen(leccionId: leccionId, preguntas: seleccion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: GColors.fondo(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: GColors.fondo(context).withOpacity(0.9),
        border: null,
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _indicadorTop(Icons.local_fire_department, '${ProgressService.instance.rachaActual}'),
            const SizedBox(width: 16),
            _indicadorTop(Icons.star, '${ProgressService.instance.xpTotal}'),
            const SizedBox(width: 16),
            _indicadorTop(Icons.sports_soccer, '${ProgressService.instance.vidasDisponibles}/5'),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            ChispaWidget(
              estado: ProgressService.instance.rachaActual > 0
                  ? ChispaEstado.feliz
                  : ChispaEstado.dormido,
              size: 70,
              animarIdle: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scroll,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ...List.generate(6, (nivel) {
                      return UnidadCamino(
                        nivel: nivel + 1,
                        desbloqueado: nivel + 1 <= ProgressService.instance.nivel,
                        onNodo: (leccionId) => _abrirLeccion(leccionId, nivel + 1),
                      );
                    }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _indicadorTop(IconData icono, String texto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 20, color: GColors.acentoDorado(context)),
        const SizedBox(width: 6),
        Text(
          texto,
          style: GTheme.buttonStyle(context, size: 15),
        ),
      ],
    );
  }
}

class UnidadCamino extends StatelessWidget {
  final int nivel;
  final bool desbloqueado;
  final ValueChanged<String> onNodo;

  const UnidadCamino({
    super.key,
    required this.nivel,
    required this.desbloqueado,
    required this.onNodo,
  });

  @override
  Widget build(BuildContext context) {
    final colores = [
      const Color(0xFF3DDC84),
      const Color(0xFF2D7FF9),
      const Color(0xFFFF8A1F),
      const Color(0xFF9B5DE5),
      const Color(0xFFE5484D),
      const Color(0xFFFFC83D),
    ];
    final color = colores[(nivel - 1) % colores.length];
    final nombres = [
      'Unidad 1: Las reglas básicas',
      'Unidad 2: Posiciones y formaciones',
      'Unidad 3: Torneos y formatos',
      'Unidad 4: Tácticas avanzadas',
      'Unidad 5: Historia y récords',
      'Unidad 6: Análisis experto',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: GColors.superficie(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), offset: const Offset(0, 4), blurRadius: 12),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 10),
                Text(
                  nombres[nivel - 1],
                  style: GTheme.cardTitleStyle(context, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(4, (i) {
            final leccionId = 'n${nivel}_u${i + 1}';
            return NodoCamino(
              leccionId: leccionId,
              desbloqueado: desbloqueado,
              completado: i == 0,
              estrellas: 3,
              onTap: () => onNodo(leccionId),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class NodoCamino extends StatelessWidget {
  final String leccionId;
  final bool desbloqueado;
  final bool completado;
  final int estrellas;
  final VoidCallback onTap;

  const NodoCamino({
    super.key,
    required this.leccionId,
    required this.desbloqueado,
    required this.completado,
    required this.estrellas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icono;
    if (completado) {
      color = const Color(0xFFFFC83D);
      icono = Icons.star;
    } else if (desbloqueado) {
      color = const Color(0xFF1FB155);
      icono = Icons.play_circle;
    } else {
      color = Colors.grey.shade500;
      icono = Icons.lock;
    }

    return GestureDetector(
      onTap: desbloqueado ? onTap : null,
      child: Container(
        width: 72,
        height: 72,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Icon(icono, color: Colors.white, size: 32),
      ),
    );
  }
}
