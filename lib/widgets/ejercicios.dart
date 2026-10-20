import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/question.dart';
import 'chispa_widget.dart';

abstract class EjercicioBase extends StatefulWidget {
  final Question pregunta;
  final ValueChanged<bool> onResultado;
  final VoidCallback onComprobar;
  final bool respondido;

  const EjercicioBase({
    super.key,
    required this.pregunta,
    required this.onResultado,
    required this.onComprobar,
    this.respondido = false,
  });
}

class MultipleChoiceExercise extends EjercicioBase {
  const MultipleChoiceExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<EjercicioBase> {
  int? _seleccion;
  bool _mostrado = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.pregunta.options.length, (i) {
        final seleccionado = _seleccion == i;
        final respondido = widget.respondido || _mostrado;
        bool? correcta;
        Color? incorrectaColor;
        if (respondido) {
          correcta = i == widget.pregunta.answer;
          incorrectaColor = seleccionado && !correcta! ? GColors.error(context) : null;
        }
        return TarjetaOpcion(
          texto: widget.pregunta.options[i],
          seleccionada: seleccionado,
          correcta: correcta == true,
          incorrecta: incorrectaColor != null,
          onTap: respondido ? null : () => setState(() => _seleccion = i),
        );
      }),
    );
  }
}

class TrueFalseExercise extends EjercicioBase {
  const TrueFalseExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _TrueFalseState();
}

class _TrueFalseState extends State<EjercicioBase> {
  int? _seleccion;

  @override
  Widget build(BuildContext context) {
    final respondido = widget.respondido || _seleccion != null;
    return Row(
      children: [
        Expanded(
          child: _botonVAR('✅ Válido', 0, respondido),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _botonVAR('❌ Anulado', 1, respondido),
        ),
      ],
    );
  }

  Widget _botonVAR(String texto, int indice, bool respondido) {
    final seleccionado = _seleccion == indice;
    bool? correcta;
    if (respondido) {
      correcta = indice == widget.pregunta.answer;
    }
    return TarjetaOpcion(
      texto: texto,
      seleccionada: seleccionado,
      correcta: correcta == true,
      incorrecta: respondido && seleccionado && correcta == false,
      onTap: respondido ? null : () => setState(() => _seleccion = indice),
    );
  }
}

class FieldPositionExercise extends EjercicioBase {
  const FieldPositionExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _FieldPositionState();
}

class _FieldPositionState extends State<EjercicioBase> {
  Offset? _toque;
  bool _acertado = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTapUp: (det) {
              if (widget.respondido || _acertado) return;
              setState(() {
                _toque = det.localPosition;
                _acertado = true;
              });
              widget.onResultado(true);
            },
            child: Container(
              decoration: BoxDecoration(
                color: GColors.fondo(context),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomPaint(
                painter: _CampoTacticoPainter(
                  toque: _toque,
                  acertado: _acertado,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CampoTacticoPainter extends CustomPainter {
  final Offset? toque;
  final bool acertado;

  _CampoTacticoPainter({this.toque, this.acertado = false});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.35;

    // Césped
    final cespado = Paint()..color = const Color(0xFF1FB155);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), cespado);

    // Líneas blancas
    final linea = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRect(Rect.fromLTWH(20, 20, size.width - 40, size.height - 40), linea);
    canvas.drawLine(Offset(cx, 20), Offset(cx, size.height - 20), linea);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: 100, height: 100), linea);

    // Área
    canvas.drawRect(Rect.fromLTWH(20, cy - 90, 110, 180), linea);
    canvas.drawRect(Rect.fromLTWH(size.width - 130, cy - 90, 110, 180), linea);

    // Toque
    if (toque != null) {
      final toquePaint = Paint()
        ..color = acertado ? const Color(0xFF3DDC84) : const Color(0xFFE5484D)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(toque!, 24, toquePaint);
      final borde = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(toque!, 24, borde);
    }
  }

  @override
  bool shouldRepaint(covariant _CampoTacticoPainter old) =>
      old.toque != toque || old.acertado != acertado;
}

class OrderPlayExercise extends EjercicioBase {
  const OrderPlayExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _OrderPlayState();
}

class _OrderPlayState extends State<EjercicioBase> {
  late List<String> _items;
  late List<int> _orden;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.pregunta.options);
    _orden = List.generate(_items.length, (i) => i);
    _orden.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _orden.asMap().entries.map((e) {
        final idx = e.key;
        final itemIdx = e.value;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ReorderableItem(
            texto: '${idx + 1}. ${_items[itemIdx]}',
            indice: itemIdx,
            pos: idx,
            onMove: (ant, act) {
              setState(() {
                final movido = _orden.removeAt(ant);
                _orden.insert(act, movido);
              });
            },
          ),
        );
      }).toList(),
    );
  }
}

class ReorderableItem extends StatelessWidget {
  final String texto;
  final int indice;
  final int pos;
  final void Function(int, int) onMove;

  const ReorderableItem({
    super.key,
    required this.texto,
    required this.indice,
    required this.pos,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: indice,
      child: Card(
        key: ValueKey(indice),
        child: ListTile(
          title: Text(texto),
          trailing: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}

class MatchPairsExercise extends EjercicioBase {
  const MatchPairsExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _MatchPairsState();
}

class _MatchPairsState extends State<EjercicioBase> {
  int? _seleccionado;
  final Set<int> _emparejados = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(widget.pregunta.options.length, (i) {
        final ya = _emparejados.contains(i);
        return TarjetaOpcion(
          texto: widget.pregunta.options[i],
          seleccionada: _seleccionado == i && !ya,
          correcta: ya,
          incorrecta: false,
          onTap: ya || widget.respondido
              ? null
              : () {
                  if (_seleccionado == null) {
                    setState(() => _seleccionado = i);
                  } else {
                    setState(() {
                      _emparejados.add(_seleccionado!);
                      _emparejados.add(i);
                      _seleccionado = null;
                    });
                    widget.onResultado(true);
                  }
                },
        );
      }),
    );
  }
}

class FillBlankExercise extends EjercicioBase {
  const FillBlankExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _FillBlankState();
}

class _FillBlankState extends State<EjercicioBase> {
  int? _seleccion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        ...List.generate(widget.pregunta.options.length, (i) {
          return TarjetaOpcion(
            texto: widget.pregunta.options[i],
            seleccionada: _seleccion == i,
            correcta: widget.respondido && i == widget.pregunta.answer,
            incorrecta: widget.respondido &&
                _seleccion == i &&
                i != widget.pregunta.answer,
            onTap: widget.respondido ? null : () => setState(() => _seleccion = i),
          );
        }),
      ],
    );
  }
}

class TacticalScenarioExercise extends EjercicioBase {
  const TacticalScenarioExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _TacticalScenarioState();
}

class _TacticalScenarioState extends State<EjercicioBase> {
  int? _seleccion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _TacticoPainter(),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(widget.pregunta.options.length, (i) {
          return TarjetaOpcion(
            texto: widget.pregunta.options[i],
            seleccionada: _seleccion == i,
            correcta: widget.respondido && i == widget.pregunta.answer,
            incorrecta: widget.respondido &&
                _seleccion == i &&
                i != widget.pregunta.answer,
            onTap: widget.respondido ? null : () => setState(() => _seleccion = i),
          );
        }),
      ],
    );
  }
}

class _TacticoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.3;

    final cespado = Paint()..color = const Color(0xFF1FB155);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), cespado);

    final linea = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(Rect.fromLTWH(20, 20, size.width - 40, size.height - 40), linea);
    canvas.drawLine(Offset(cx, 20), Offset(cx, size.height - 20), linea);

    // Jugadores azules
    final azul = Paint()..color = const Color(0xFF2D7FF9);
    final rojo = Paint()..color = const Color(0xFFE5484D);
    final posAzul = [
      Offset(cx - 70, cy - 60),
      Offset(cx - 30, cy - 40),
      Offset(cx + 10, cy - 60),
      Offset(cx - 50, cy + 40),
      Offset(cx + 30, cy + 40),
    ];
    final posRojo = [
      Offset(cx - 30, cy - 110),
      Offset(cx + 40, cy - 110),
      Offset(cx - 60, cy - 10),
      Offset(cx + 60, cy - 10),
      Offset(cx, cy + 90),
    ];
    for (final p in posAzul) {
      canvas.drawCircle(p, 16, azul);
      canvas.drawCircle(p, 16, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    for (final p in posRojo) {
      canvas.drawCircle(p, 16, rojo);
      canvas.drawCircle(p, 16, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    // Flecha
    final flecha = Paint()
      ..color = const Color(0xFFFFC83D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawLine(Offset(cx - 40, cy - 20), Offset(cx + 30, cy - 80), flecha);
  }

  @override
  bool shouldRepaint(covariant _TacticoPainter old) => false;
}

class FormationExercise extends EjercicioBase {
  const FormationExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _FormationState();
}

class _FormationState extends State<EjercicioBase> {
  int? _seleccion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _FormacionPainter(),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(widget.pregunta.options.length, (i) {
          return TarjetaOpcion(
            texto: widget.pregunta.options[i],
            seleccionada: _seleccion == i,
            correcta: widget.respondido && i == widget.pregunta.answer,
            incorrecta: widget.respondido &&
                _seleccion == i &&
                i != widget.pregunta.answer,
            onTap: widget.respondido ? null : () => setState(() => _seleccion = i),
          );
        }),
      ],
    );
  }
}

class _FormacionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final cespado = Paint()..color = const Color(0xFF1FB155);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), cespado);

    final linea = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(Rect.fromLTWH(20, 20, size.width - 40, size.height - 40), linea);
    canvas.drawLine(Offset(cx, 20), Offset(cx, size.height - 20), linea);

    final punto = Paint()..color = const Color(0xFF0B1F3A);
    // 4-4-2
    final porteros = [Offset(cx, cy + 130)];
    final defensas = [
      Offset(cx - 90, cy + 70),
      Offset(cx - 30, cy + 70),
      Offset(cx + 30, cy + 70),
      Offset(cx + 90, cy + 70),
    ];
    final medios = [
      Offset(cx - 70, cy + 0),
      Offset(cx - 20, cy + 0),
      Offset(cx + 20, cy + 0),
      Offset(cx + 70, cy + 0),
    ];
    final delanteres = [Offset(cx - 40, cy - 80), Offset(cx + 40, cy - 80)];
    for (final p in [...porteros, ...defensas, ...medios, ...delanteres]) {
      canvas.drawCircle(p, 14, punto);
    }
  }

  @override
  bool shouldRepaint(covariant _FormacionPainter old) => false;
}

class RefereeDecisionExercise extends EjercicioBase {
  const RefereeDecisionExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _RefereeDecisionState();
}

class _RefereeDecisionState extends State<EjercicioBase> {
  int? _seleccion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.pregunta.options.length, (i) {
          return TarjetaOpcion(
            texto: widget.pregunta.options[i],
            seleccionada: _seleccion == i,
            correcta: widget.respondido && i == widget.pregunta.answer,
            incorrecta: widget.respondido &&
                _seleccion == i &&
                i != widget.pregunta.answer,
            onTap: widget.respondido ? null : () => setState(() => _seleccion = i),
          );
        }),
      ],
    );
  }
}

class TimedExercise extends EjercicioBase {
  const TimedExercise({
    super.key,
    required super.pregunta,
    required super.onResultado,
    required super.onComprobar,
    super.respondido,
  });

  @override
  State<EjercicioBase> createState() => _TimedState();
}

class _TimedState extends State<EjercicioBase> {
  int? _seleccion;
  int _segundos = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !widget.respondido && _seleccion == null) {
        setState(() => _segundos--);
        if (_segundos <= 0) {
          widget.onResultado(false);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: double.infinity * (_segundos / 10),
              decoration: BoxDecoration(
                color: _segundos > 3 ? GColors.primario(context) : GColors.error(context),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '$_segundos',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: GColors.textoPrincipal(context),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...List.generate(widget.pregunta.options.length, (i) {
          return TarjetaOpcion(
            texto: widget.pregunta.options[i],
            seleccionada: _seleccion == i,
            correcta: widget.respondido && i == widget.pregunta.answer,
            incorrecta: widget.respondido &&
                _seleccion == i &&
                i != widget.pregunta.answer,
            onTap: widget.respondido || _seleccion != null || _segundos <= 0
                ? null
                : () => setState(() => _seleccion = i),
          );
        }),
      ],
    );
  }
}

Widget ejercicioPorTipo(QuestionType type, {
  required Question pregunta,
  required ValueChanged<bool> onResultado,
  required VoidCallback onComprobar,
  bool respondido = false,
}) {
  switch (type) {
    case QuestionType.multipleChoice:
      return MultipleChoiceExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.trueFalse:
      return TrueFalseExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.fieldPosition:
      return FieldPositionExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.orderPlay:
      return OrderPlayExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.matchPairs:
      return MatchPairsExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.fillBlank:
      return FillBlankExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.tacticalScenario:
      return TacticalScenarioExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.formation:
      return FormationExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.refereeDecision:
      return RefereeDecisionExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
    case QuestionType.timed:
      return TimedExercise(
        pregunta: pregunta,
        onResultado: onResultado,
        onComprobar: onComprobar,
        respondido: respondido,
      );
  }
  throw UnsupportedError('Tipo de ejercicio no implementado: $type');
}
