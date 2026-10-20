import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../models/question.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class LessonScreen extends StatefulWidget {
  final String leccionId;
  final List<Question> preguntas;

  const LessonScreen({
    super.key,
    required this.leccionId,
    required this.preguntas,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final PageController _page = PageController();
  int _indice = 0;
  int _aciertos = 0;
  int _errores = 0;
  int _vidas;
  int _combo = 0;
  bool _respondido = false;
  bool _correcto = false;
  bool _leccionTerminada = false;
  int _estrellas = 1;

  _LessonScreenState() : _vidas = ProgressService.instance.vidasDisponibles;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  Question get _actual => widget.preguntas[_indice];

  @override
  Widget build(BuildContext context) {
    if (_leccionTerminada) {
      return _pantallaResumen();
    }

    return CupertinoPageScaffold(
      backgroundColor: GColors.fondo(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: GColors.fondo(context).withValues(alpha: 0.9),
        border: null,
        leading: GestureDetector(
          onTap: _salir,
          child: const Icon(Icons.close, size: 26),
        ),
        middle: Text(
          'Lección ${_indice + 1}/${widget.preguntas.length}',
          style: GTheme.cardTitleStyle(context, size: 17),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _barraProgreso(),
            const SizedBox(height: 12),
            _vidasBar(),
            Expanded(
              child: PageView.builder(
                controller: _page,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.preguntas.length,
                itemBuilder: (_, i) => _tarjetaPregunta(widget.preguntas[i]),
              ),
            ),
            if (!_respondido)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Boton3D(
                  texto: 'COMPROBAR',
                  onPressed: _comprobar,
                  ancho: double.infinity,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _barraProgreso() {
    final progreso = (_indice + ( _respondido ? 1 : 0 )) / widget.preguntas.length;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso',
              style: GTheme.captionStyle(context),
            ),
            Text(
              '${(_indice + 1)}/${widget.preguntas.length}',
              style: GTheme.captionStyle(context),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progreso.clamp(0, 1),
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation(
              _combo >= 3 ? const Color(0xFFFFC83D) : GColors.primario(context),
            ),
            minHeight: 8,
          ),
        ),
        if (_combo >= 3)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '🔥 RACHA x$_combo',
              style: TextStyle(
                color: const Color(0xFFFF8A1F),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _vidasBar() {
    return Row(
        mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            i < _vidas ? Icons.sports_soccer : Icons.sports_soccer,
            color: i < _vidas ? GColors.primario(context) : Colors.grey.shade400,
            size: 24,
          ),
        );
      }),
    );
  }

  Widget _tarjetaPregunta(Question pregunta) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                ChispaWidget(
                  estado: _respondido ? ChispaEstado.celebrando : ChispaEstado.pensando,
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  pregunta.question,
                  style: GTheme.questionStyle(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ejercicioPorTipo(
                  pregunta.type,
                  pregunta: pregunta,
                  onResultado: _resultado,
                  onComprobar: _comprobar,
                  respondido: _respondido,
                ),
              ],
            ),
          ),
        ),
        if (_respondido && !_leccionTerminada)
          _panelResultado(),
      ],
    );
  }

  Widget _panelResultado() {
    final color = _correcto ? GColors.correcto(context) : GColors.error(context);
    final icono = _correcto ? Icons.check_circle : Icons.cancel;
    final texto = _correcto ? '¡GOLAZO!' : 'Fallaste';
    final explicacion = _actual.explanation;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  texto,
                  style: GTheme.cardTitleStyle(context, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(explicacion, style: GTheme.bodyStyle(context), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Boton3D(
            texto: _leccionUltima ? 'RESUMEN' : 'CONTINUAR',
            onPressed: _leccionUltima ? _finalizarLeccion : _siguientePregunta,
            color: color,
            ancho: double.infinity,
          ),
        ],
      ),
    );
  }

  bool get _leccionUltima => _indice == widget.preguntas.length - 1;

  void _comprobar() {
    // El ejercicio ya maneja la respuesta interna; aquí se simplifica
    setState(() => _respondido = true);
  }

  void _resultado(bool correcto) {
    setState(() {
      _respondido = true;
      _correcto = correcto;
    });
    ProgressService.instance.registrarRespuesta(correcto, _actual.id);
    if (correcto) {
      _aciertos++;
      _combo++;
      HapticService.instance.success();
    } else {
      _errores++;
      _combo = 0;
      _vidas = (_vidas - 1).clamp(0, 5);
      ProgressService.instance.perderVida();
      HapticService.instance.error();
    }
  }

  void _siguientePregunta() {
    if (_indice < widget.preguntas.length - 1) {
      setState(() {
        _indice++;
        _respondido = false;
        _correcto = false;
      });
      _page.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finalizarLeccion() {
    final xp = GConstants.xpLeccionBase +
        (_errores == 0 ? GConstants.xpLeccionSinErrores : 0);
    _estrellas = _errores == 0 ? 3 : (_aciertos > _errores ? 2 : 1);
    setState(() => _leccionTerminada = true);
    ProgressService.instance.completarLeccion(
      widget.leccionId,
      xp: xp,
      perfecto: _errores == 0,
      estrellas: _estrellas,
    );
    ProgressService.instance.aumentarRacha();
    HapticService.instance.success();
  }

  void _salir() {
    Navigator.of(context).pop();
  }

  Widget _pantallaResumen() {
    final xp = GConstants.xpLeccionBase +
        (_errores == 0 ? GConstants.xpLeccionSinErrores : 0);
    return CupertinoPageScaffold(
      backgroundColor: GColors.fondo(context),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ChispaWidget(
              estado: _errores == 0 ? ChispaEstado.celebrando : ChispaEstado.feliz,
              size: 120,
              animarIdle: false,
            ),
            const SizedBox(height: 24),
            Text(
              'Lección completada',
              style: GTheme.titleStyle(context, size: 30),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _resumenItem('Aciertos', '$_aciertos', Icons.check_circle, GColors.correcto(context)),
            _resumenItem('Errores', '$_errores', Icons.cancel, GColors.error(context)),
            _resumenItem('XP ganada', '+$xp', Icons.star, const Color(0xFFFFC83D)),
            const SizedBox(height: 24),
            Boton3D(
              texto: 'VOLVER AL CAMINO',
              onPressed: () => Navigator.of(context).pop(),
              ancho: 260,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _resumenItem(String label, String valor, IconData icono, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 24),
              const SizedBox(width: 10),
              Text(label, style: GTheme.bodyStyle(context)),
            ],
          ),
          Text(valor, style: GTheme.buttonStyle(context, size: 18)),
        ],
      ),
    );
  }
}
