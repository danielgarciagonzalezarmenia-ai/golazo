import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onCompletado;

  const OnboardingScreen({super.key, required this.onCompletado});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _page = PageController();
  int _paso = 0;
  final TextEditingController _apodoCtrl = TextEditingController();
  int _nivel = 1;
  int _meta = 2;
  bool _notificaciones = false;

  @override
  void dispose() {
    _page.dispose();
    _apodoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: GColors.fondo(context),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paso ${_paso + 1} de 5',
                    style: GTheme.captionStyle(context),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_paso + 1) / 5,
                      backgroundColor: GColors.textoSecundario(context).withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation(GColors.primario(context)),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _page,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _pasoSaludo(),
                  _pasoApodo(),
                  _pasoNivel(),
                  _pasoMeta(),
                  _pasoNotificaciones(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Boton3D(
                texto: _paso < 4 ? 'SIGUIENTE' : 'EMPEZAR',
                onPressed: _siguiente,
                activo: _paso < 4 || _apodoCtrl.text.isNotEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pasoSaludo() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChispaWidget(estado: ChispaEstado.feliz, size: 140, animarIdle: true),
          const SizedBox(height: 32),
          Text(
            '¡Hola! Soy Chispa.\nTe enseñaré fútbol de cero a experto.',
            style: GTheme.questionStyle(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _pasoApodo() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¿Cómo te llamas?',
            style: GTheme.questionStyle(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: GColors.superficie(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: CupertinoTextField(
              controller: _apodoCtrl,
              placeholder: 'Tu apodo',
              style: GTheme.bodyStyle(context),
              placeholderStyle: TextStyle(color: GColors.textoSecundario(context)),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pasoNivel() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¿Cuánto sabes de fútbol?',
            style: GTheme.questionStyle(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...[
            {'label': 'Nada', 'nivel': 1},
            {'label': 'Algo', 'nivel': 2},
            {'label': 'Bastante', 'nivel': 3},
          ].map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Boton3D(
                texto: e['label'] as String,
                color: _nivel == (e['nivel'] as int)
                    ? GColors.primario(context)
                    : GColors.primario(context).withValues(alpha: 0.5),
                onPressed: () => setState(() => _nivel = e['nivel'] as int),
                ancho: 260,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _pasoMeta() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Meta diaria de lecciones',
            style: GTheme.questionStyle(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...[
            {'label': 'Casual (1)', 'meta': 1},
            {'label': 'Normal (2)', 'meta': 2},
            {'label': 'Serio (3)', 'meta': 3},
            {'label': 'Pro (5)', 'meta': 5},
          ].map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Boton3D(
                texto: e['label'] as String,
                color: _meta == (e['meta'] as int)
                    ? GColors.primario(context)
                    : GColors.primario(context).withValues(alpha: 0.5),
                onPressed: () => setState(() => _meta = e['meta'] as int),
                ancho: 260,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _pasoNotificaciones() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¿Activas los recordatorios de Chispa?',
            style: GTheme.questionStyle(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CupertinoSwitch(
            value: _notificaciones,
            onChanged: (v) => setState(() => _notificaciones = v),
          ),
          const SizedBox(height: 16),
          Text(
            'Chispa te recordará practicar cada día.',
            style: GTheme.bodyStyle(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _siguiente() {
    if (_paso < 4) {
      setState(() => _paso++);
      _page.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finalizar();
    }
  }

  Future<void> _finalizar() async {
    final svc = ProgressService.instance;
    await svc.setApodo(_apodoCtrl.text.trim());
    await svc.registrarJuegoHoy();
    await svc.aumentarRacha();
    if (_notificaciones) {
      await NotificationService.instance.solicitarPermisos();
      await NotificationService.instance.programarRecordatorioDiario(20, 0);
    }
    widget.onCompletado();
  }
}
