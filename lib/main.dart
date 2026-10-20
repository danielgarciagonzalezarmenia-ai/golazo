import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../services/services.dart';
import '../screens/camino_screen.dart';
import '../screens/logros_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/vestuario_screen.dart';

void main() {
  runApp(const GApp());
}

class GApp extends StatefulWidget {
  const GApp({super.key});

  @override
  State<GApp> createState() => _GAppState();
}

class _GAppState extends State<GApp> {
  bool _mostrarSplash = true;
  bool _mostrarOnboarding = false;

  final List<Widget> _paginas = [
    const CaminoScreen(),
    const VestuarioScreen(),
    const LogrosScreen(),
    const PerfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    await ProgressService.instance.init();
    await InventoryService.instance.init();
    await NotificationService.instance.init();
    final yaOnboard = ProgressService.instance.apodo.isNotEmpty;
    if (!yaOnboard) {
      setState(() {
        _mostrarSplash = false;
        _mostrarOnboarding = true;
      });
    } else {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _mostrarSplash = false);
    }
  }

  void _completarOnboarding() {
    setState(() => _mostrarOnboarding = false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: GConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: _mostrarOnboarding
          ? OnboardingScreen(onCompletado: _completarOnboarding)
          : (_mostrarSplash
              ? SplashScreen(
                  onTerminado: () => setState(() => _mostrarSplash = false),
                )
              : _tabScaffold()),
    );
  }

  Widget _tabScaffold() {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: GColors.fondo(context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Camino'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Vestuario'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Logros'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      tabBuilder: (_, i) => _paginas[i],
    );
  }
}
