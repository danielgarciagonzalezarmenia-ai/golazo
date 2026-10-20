import 'dart:math';

import 'package:flutter/material.dart';

enum ChispaEstado { feliz, celebrando, triste, pensando, dormido }

class ChispaPainter extends CustomPainter {
  final ChispaEstado estado;
  final Color colorCamiseta;
  final double flameOffset;

  ChispaPainter({
    required this.estado,
    this.colorCamiseta = const Color(0xFF1FB155),
    this.flameOffset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 8;
    final radio = size.width * 0.38;

    // Sombra
    final sombra = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy + radio * 0.5),
        width: radio * 1.4,
        height: radio * 0.35,
      ),
      sombra,
    );

    // Cuerpo del balón
    final balon = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final balonBorde = Paint()
      ..color = const Color(0xFF0B1F3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(Offset(cx, cy), radio, balon);
    canvas.drawCircle(Offset(cx, cy), radio, balonBorde);

    // Pentágono central
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: radio * 0.45,
        height: radio * 0.45,
      ),
      balonBorde,
    );

    // Líneas del balón
    final linea = Paint()
      ..color = const Color(0xFF0B1F3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    for (var angulo = 0; angulo < 360; angulo += 45) {
      final rad = angulo * pi / 180;
      final x1 = cx + (radio * 0.35) * cos(rad);
      final y1 = cy + (radio * 0.35) * sin(rad);
      final x2 = cx + (radio * 0.62) * cos(rad);
      final y2 = cy + (radio * 0.62) * sin(rad);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linea);
    }

    // Camiseta
    if (colorCamiseta != Colors.transparent) {
      final camiseta = Paint()
        ..color = colorCamiseta
        ..style = PaintingStyle.fill;
      final rectCamiseta = Rect.fromCenter(
        center: Offset(cx, cy + radio * 0.15),
        width: radio * 0.55,
        height: radio * 0.28,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rectCamiseta, const Radius.circular(8)),
        camiseta,
      );
    }

    // Llama
    final llama = Paint()
      ..color = const Color(0xFFFFC83D)
      ..style = PaintingStyle.fill;
    final llamaPath = Path();
    final ly = cy - radio + flameOffset - 4;
    llamaPath.moveTo(cx - 14, ly);
    llamaPath.quadraticBezierTo(cx - 8, ly - 22, cx, ly - 10);
    llamaPath.quadraticBezierTo(cx + 8, ly - 22, cx + 14, ly);
    llamaPath.quadraticBezierTo(cx + 6, ly - 8, cx, ly - 4);
    llamaPath.quadraticBezierTo(cx - 6, ly - 8, cx - 14, ly);
    canvas.drawPath(llamaPath, llama);

    // Destello llama
    final destello = Paint()
      ..color = const Color(0xFFFFE57A)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, ly - 6), width: 6, height: 6),
      destello,
    );

    // Ojos
    final ojoIzq = Offset(cx - radio * 0.28, cy - radio * 0.18);
    final ojoDer = Offset(cx + radio * 0.28, cy - radio * 0.18);
    final ojoRadio = radio * 0.16;

    _dibujarOjo(canvas, ojoIzq, ojoRadio, estado);
    _dibujarOjo(canvas, ojoDer, ojoRadio, estado);

    // Boca
    _dibujarBoca(canvas, cx, cy + radio * 0.12, radio, estado);
  }

  void _dibujarOjo(
      Canvas canvas, Offset centro, double radio, ChispaEstado estado) {
    final blanco = Paint()..color = Colors.white;
    final iris = Paint()..color = const Color(0xFF0B1F3A);
    final brillo = Paint()..color = Colors.white.withValues(alpha: 0.9);

    if (estado == ChispaEstado.dormido) {
      final cerrado = Paint()
        ..color = const Color(0xFF0B1F3A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCenter(
          center: centro,
          width: radio * 2,
          height: radio * 0.6,
        ),
        0,
        pi,
        false,
        cerrado,
      );
      return;
    }

    if (estado == ChispaEstado.triste) {
      canvas.drawCircle(centro, radio, blanco);
      final parpado = Paint()..color = Colors.white;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(centro.dx, centro.dy - radio * 0.3),
          width: radio * 2.2,
          height: radio * 0.9,
        ),
        parpado,
      );
      canvas.drawCircle(centro, radio * 0.55, iris);
      canvas.drawCircle(
        Offset(centro.dx + radio * 0.25, centro.dy - radio * 0.25),
        radio * 0.18,
        brillo,
      );
      return;
    }

    canvas.drawCircle(centro, radio, blanco);
    final irisRadio = estado == ChispaEstado.pensando
        ? Offset(centro.dx, centro.dy - radio * 0.35)
        : centro;
    canvas.drawCircle(irisRadio, radio * 0.6, iris);
    final brilloPos = estado == ChispaEstado.pensando
        ? Offset(centro.dx + radio * 0.28, centro.dy - radio * 0.6)
        : Offset(centro.dx + radio * 0.28, centro.dy - radio * 0.28);
    canvas.drawCircle(brilloPos, radio * 0.22, brillo);
  }

  void _dibujarBoca(
      Canvas canvas, double cx, double cy, double radio, ChispaEstado estado) {
    final boca = Paint()
      ..color = const Color(0xFF0B1F3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if (estado == ChispaEstado.triste) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(cx, cy + 4),
          width: radio * 0.5,
          height: radio * 0.5,
        ),
        0.2,
        2.7,
        false,
        boca,
      );
    } else if (estado == ChispaEstado.celebrando) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(cx, cy),
          width: radio * 0.45,
          height: radio * 0.45,
        ),
        0.15,
        2.9,
        false,
        boca,
      );
      final lengua = Paint()..color = const Color(0xFFFF6B6B);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, cy + radio * 0.18),
          width: radio * 0.18,
          height: radio * 0.12,
        ),
        lengua,
      );
    } else {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(cx, cy + 2),
          width: radio * 0.5,
          height: radio * 0.5,
        ),
        0.2,
        2.7,
        false,
        boca,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ChispaPainter old) =>
      old.estado != estado ||
      old.colorCamiseta != colorCamiseta ||
      old.flameOffset != flameOffset;
}
