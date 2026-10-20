import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/app_constants.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _sonido = true;
  bool _haptica = true;
  bool _oscuro = false;

  @override
  Widget build(BuildContext context) {
    final svc = ProgressService.instance;
    return CupertinoPageScaffold(
      backgroundColor: GColors.fondo(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: GColors.fondo(context).withValues(alpha: 0.9),
        border: null,
        middle: Text('Perfil', style: GTheme.cardTitleStyle(context)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ChispaWidget(estado: ChispaEstado.feliz, size: 100, animarIdle: true),
              const SizedBox(height: 16),
              Text(
                svc.apodo.isEmpty ? 'Jugador' : svc.apodo,
                style: GTheme.titleStyle(context, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                'Nivel ${svc.nivel} · ${GConstants.totalNiveles - svc.nivel} niveles por desbloquear',
                style: GTheme.bodyStyle(context),
              ),
              const SizedBox(height: 24),
              _filaPerfil('Racha actual', '${svc.rachaActual} días', Icons.local_fire_department, const Color(0xFFFF8A1F)),
              _filaPerfil('Racha máxima', '${svc.rachaMaxima} días', Icons.calendar_today, GColors.primario(context)),
              _filaPerfil('XP total', '${svc.xpTotal}', Icons.star, const Color(0xFFFFC83D)),
              _filaPerfil('Vidas', '${svc.vidasDisponibles}/5', Icons.sports_soccer, GColors.primario(context)),
              const SizedBox(height: 24),
              Text('Ajustes', style: GTheme.cardTitleStyle(context, size: 20)),
              const SizedBox(height: 12),
              _ajuste('Sonido', _sonido, (v) => setState(() => _sonido = v)),
              _ajuste('Háptica', _haptica, (v) => setState(() => _haptica = v)),
              _ajusteModoOscuro(),
              const SizedBox(height: 24),
              Boton3D(
                texto: 'REINICIAR PROGRESO',
                color: GColors.error(context),
                onPressed: _confirmarReset,
                ancho: 260,
              ),
              const SizedBox(height: 24),
              Text('GOLAZO 1.0.0 · Offline · Sin anuncios', style: GTheme.captionStyle(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filaPerfil(String label, String valor, IconData icono, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _ajuste(String label, bool valor, ValueChanged<bool> onCambio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(label, style: GTheme.bodyStyle(context)),
          const Spacer(),
          CupertinoSwitch(value: valor, onChanged: onCambio),
        ],
      ),
    );
  }

  Widget _ajusteModoOscuro() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text('Modo oscuro', style: GTheme.bodyStyle(context)),
          const Spacer(),
          CupertinoSegmentedControl<bool>(
            children: {
              false: const Icon(Icons.light_mode, size: 22),
              true: const Icon(Icons.dark_mode, size: 22),
            },
            groupValue: _oscuro,
            onValueChanged: (v) => setState(() => _oscuro = v),
          ),
        ],
      ),
    );
  }

  void _confirmarReset() {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('¿Reiniciar progreso?'),
        content: const Text('Se borrará todo tu avance. No se puede deshacer.'),
        actions: [
          CupertinoDialogAction(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Reiniciar'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
