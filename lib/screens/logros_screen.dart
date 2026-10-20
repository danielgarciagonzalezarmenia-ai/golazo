import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../models/medalla.dart';
import '../services/services.dart';

class LogrosScreen extends StatefulWidget {
  const LogrosScreen({super.key});

  @override
  State<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends State<LogrosScreen> {
  final List<Medalla> _medallas = [
    Medalla(id: 'primera', nombre: 'Primer gol', descripcion: 'Completa tu primera lección', icono: Icons.sports_soccer, desbloqueada: true),
    Medalla(id: 'racha3', nombre: 'Hat-trick', descripcion: '3 días de racha', icono: Icons.local_fire_department, desbloqueada: false),
    Medalla(id: 'semana', nombre: 'Semana perfecta', descripcion: '7 días seguidos', icono: Icons.calendar_today, desbloqueada: false),
    Medalla(id: 'cien', nombre: 'Centésimo acierto', descripcion: '100 respuestas correctas', icono: Icons.star, desbloqueada: false),
    Medalla(id: 'nivel4', nombre: 'Estratega', descripcion: 'Completa el nivel 4', icono: Icons.flag, desbloqueada: false),
    Medalla(id: 'nivel6', nombre: 'Leyenda', descripcion: 'Completa el nivel 6', icono: Icons.emoji_events, desbloqueada: false),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: GColors.fondo(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: GColors.fondo(context).withValues(alpha: 0.9),
        border: null,
        middle: Text('Ligas / Logros', style: GTheme.cardTitleStyle(context)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _estadistica('Racha actual', '${ProgressService.instance.rachaActual} días', Icons.local_fire_department, const Color(0xFFFF8A1F)),
            _estadistica('XP total', '${ProgressService.instance.xpTotal}', Icons.star, const Color(0xFFFFC83D)),
            _estadistica('Lecciones', '${ProgressService.instance.progreso.leccionesCompletadas}', Icons.school, GColors.primario(context)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _medallas.length,
                itemBuilder: (_, i) => _medalla(_medallas[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadistica(String label, String valor, IconData icono, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icono, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: GTheme.bodyStyle(context))),
          Text(valor, style: GTheme.buttonStyle(context, size: 16)),
        ],
      ),
    );
  }

  Widget _medalla(Medalla m) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: m.desbloqueada ? GColors.primario(context) : Colors.grey.shade700,
              shape: BoxShape.circle,
            ),
            child: Icon(m.icono, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.nombre, style: GTheme.cardTitleStyle(context, size: 16)),
                Text(m.descripcion, style: GTheme.captionStyle(context)),
              ],
            ),
          ),
          if (m.desbloqueada) const Icon(Icons.check_circle, color: Color(0xFF3DDC84)),
        ],
      ),
    );
  }
}
