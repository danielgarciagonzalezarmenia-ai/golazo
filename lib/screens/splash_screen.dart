import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../core/app_theme.dart';
import '../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onTerminado;

  const SplashScreen({super.key, required this.onTerminado});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _chispaX;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scale = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _chispaX = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    Timer(const Duration(seconds: 2), widget.onTerminado);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: GColors.fondo(context),
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fade.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(_chispaX.value, 0),
                      child: ChispaWidget(
                        estado: ChispaEstado.feliz,
                        size: 120,
                        animarIdle: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'GOLAZO',
                      style: GTheme.titleStyle(context, size: 48),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      GConstants.eslogan,
                      style: GTheme.bodyStyle(context, size: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
