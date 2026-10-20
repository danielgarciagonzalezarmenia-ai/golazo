import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import 'chispa_painter.dart';

class ChispaWidget extends StatefulWidget {
  final ChispaEstado estado;
  final double size;
  final Color colorCamiseta;
  final VoidCallback? onTap;
  final bool animarIdle;

  const ChispaWidget({
    super.key,
    this.estado = ChispaEstado.feliz,
    this.size = 120,
    this.colorCamiseta = const Color(0xFF1FB155),
    this.onTap,
    this.animarIdle = false,
  });

  @override
  State<ChispaWidget> createState() => _ChispaWidgetState();
}

class _ChispaWidgetState extends State<ChispaWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnim;
  late Animation<double> _flameAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _flameAnim = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anim = widget.animarIdle ? _floatAnim.value : 0.0;
    final flame = widget.animarIdle ? _flameAnim.value : 0.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Transform.translate(
            offset: Offset(0, anim),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: ChispaPainter(
                estado: widget.estado,
                colorCamiseta: widget.colorCamiseta,
                flameOffset: flame,
              ),
            ),
          ),
        );
      },
    );
  }
}

class Boton3D extends StatefulWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color color;
  final bool activo;
  final double ancho;
  final double alto;

  const Boton3D({
    super.key,
    required this.texto,
    required this.onPressed,
    this.color = const Color(0xFF1FB155),
    this.activo = true,
    this.ancho = double.infinity,
    this.alto = 56,
  });

  @override
  State<Boton3D> createState() => _Boton3DState();
}

class _Boton3DState extends State<Boton3D> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    final colorOscuro = _tonoOscuro(color);
    final escala = _presionado ? 0.96 : 1.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) => setState(() => _presionado = false),
      onTapCancel: () => setState(() => _presionado = false),
      onTap: widget.activo ? widget.onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.diagonal3Values(escala, escala, 1),
        width: widget.ancho,
        height: widget.alto,
        decoration: BoxDecoration(
          color: widget.activo ? color : color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.activo ? colorOscuro.withOpacity(0.9) : Colors.black12,
              offset: Offset(0, _presionado ? 1 : 4),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.texto.toUpperCase(),
          style: TextStyle(
            fontFamily: 'SF Pro Rounded',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Color _tonoOscuro(Color c) {
    return Color.fromARGB(
      c.alpha,
      (c.red * 0.7).round(),
      (c.green * 0.7).round(),
      (c.blue * 0.7).round(),
    );
  }
}

class ChipPestana extends StatelessWidget {
  final String texto;
  final IconData icono;
  final bool activo;
  final VoidCallback onTap;

  const ChipPestana({
    super.key,
    required this.texto,
    required this.icono,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: activo
              ? GColors.primario(context).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              size: 20,
              color: activo ? GColors.primario(context) : GColors.textoSecundario(context),
            ),
            const SizedBox(width: 8),
            Text(
              texto,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: activo ? GColors.primario(context) : GColors.textoSecundario(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TarjetaOpcion extends StatefulWidget {
  final String texto;
  final bool seleccionada;
  final bool correcta;
  final bool incorrecta;
  final VoidCallback? onTap;

  const TarjetaOpcion({
    super.key,
    required this.texto,
    this.seleccionada = false,
    this.correcta = false,
    this.incorrecta = false,
    required this.onTap,
  });

  @override
  State<TarjetaOpcion> createState() => _TarjetaOpcionState();
}

class _TarjetaOpcionState extends State<TarjetaOpcion> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final escala = _presionado ? 0.97 : 1.0;
    Color colorFondo;
    Color colorBorde;

    if (widget.correcta) {
      colorFondo = GColors.correcto(context).withOpacity(0.15);
      colorBorde = GColors.correcto(context);
    } else if (widget.incorrecta) {
      colorFondo = GColors.error(context).withOpacity(0.15);
      colorBorde = GColors.error(context);
    } else if (widget.seleccionada) {
      colorFondo = GColors.primario(context).withOpacity(0.1);
      colorBorde = GColors.primario(context);
    } else {
      colorFondo = GColors.superficie(context);
      colorBorde = Colors.black12;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _presionado = true),
      onTapUp: (_) => setState(() => _presionado = false),
      onTapCancel: () => setState(() => _presionado = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.diagonal3Values(escala, escala, 1),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorBorde, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.texto,
            style: TextStyle(
              fontFamily: 'SF Pro Rounded',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: widget.correcta || widget.incorrecta || widget.seleccionada
                  ? colorBorde
                  : GColors.textoPrincipal(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
