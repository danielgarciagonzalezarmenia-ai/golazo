import '../core/app_constants.dart';
import '../core/storage.dart';
import '../models/question.dart';
import '../models/user_progress.dart';

class ProgressService {
  ProgressService._();
  static final ProgressService instance = ProgressService._();

  UserProgress _progreso = UserProgress.empty();
  bool _inicializado = false;

  Future<void> init() async {
    if (_inicializado) return;
    await GStorage.instance.init();
    final data = await GStorage.instance.loadProgress();
    if (data.isNotEmpty) {
      _progreso = UserProgress.fromJson(data);
    } else {
      await _guardar();
    }
    _revisarRacha();
    _regenerarVidas();
    _inicializado = true;
  }

  UserProgress get progreso => _progreso;

  Future<void> _guardar() async {
    await GStorage.instance.saveProgress(_progreso.toJson());
  }

  void _revisarRacha() {
    final ahora = DateTime.now();
    final ultimo = _progreso.ultimoJuego;
    final diferencia = ahora.difference(ultimo).inDays;

    if (diferencia >= 1) {
      final escudoValido = _progreso.escudoActivo &&
          _progreso.escudoExpira.isAfter(ahora);
      if (!escudoValido) {
        _progreso.rachaActual = 0;
        _progreso.escudoActivo = false;
      }
    }
  }

  void _regenerarVidas() {
    if (_progreso.vidas >= GConstants.vidasMax) return;
    final ahora = DateTime.now();
    final ultima = _progreso.ultimaVidaRegenerada;
    final minutos = ahora.difference(ultima).inMinutes;
    if (minutos >= GConstants.minutosRegeneracionVida) {
      final recuperar = (minutos ~/ GConstants.minutosRegeneracionVida);
      _progreso.vidas =
          (_progreso.vidas + recuperar).clamp(0, GConstants.vidasMax);
      _progreso.ultimaVidaRegenerada = ahora;
    }
  }

  int get vidasDisponibles => _progreso.vidas;

  bool get tieneVidas => _progreso.vidas > 0;

  Future<void> registrarJuegoHoy() async {
    _progreso.ultimoJuego = DateTime.now();
    _revisarRacha();
    await _guardar();
  }

  Future<void> aumentarRacha() async {
    final ahora = DateTime.now();
    final ayer = ahora.subtract(const Duration(days: 1));
    final continuo = _progreso.ultimoJuego.isAfter(ayer) ||
        _progreso.ultimoJuego.day == ahora.day &&
            _progreso.ultimoJuego.month == ahora.month &&
            _progreso.ultimoJuego.year == ahora.year;

    if (continuo || _progreso.rachaActual == 0) {
      _progreso.rachaActual += 1;
    } else {
      _progreso.rachaActual = 1;
    }

    if (_progreso.rachaActual > _progreso.rachaMaxima) {
      _progreso.rachaMaxima = _progreso.rachaActual;
    }

    _progreso.ultimoJuego = ahora;
    _progreso.escudoActivo = false;
    await _guardar();
  }

  Future<void> agregarXP(int cantidad) async {
    _progreso.xpTotal += cantidad;
    _subirNivel();
    await _guardar();
  }

  void _subirNivel() {
    final nuevoNivel = (_progreso.xpTotal ~/ 100) + 1;
    if (nuevoNivel > GConstants.totalNiveles) {
      _progreso.nivel = GConstants.totalNiveles;
    } else {
      _progreso.nivel = nuevoNivel;
    }
  }

  Future<void> perderVida() async {
    if (_progreso.vidas > 0) {
      _progreso.vidas--;
      await _guardar();
    }
  }

  Future<void> restaurarVida() async {
    if (_progreso.vidas < GConstants.vidasMax) {
      _progreso.vidas++;
      await _guardar();
    }
  }

  Future<void> registrarRespuesta(bool correcta, String questionId) async {
    final ahora = DateTime.now();
    if (correcta) {
      _progreso.respuestasCorrectas++;
      _progreso.preguntasFalladas.remove(questionId);
    } else {
      _progreso.respuestasIncorrectas++;
      if (!_progreso.preguntasFalladas.contains(questionId)) {
        _progreso.preguntasFalladas.add(questionId);
      }
    }
    _progreso.historialRespuestas.add(
      QuestionAnswer(
        questionId: questionId,
        correct: correcta,
        answeredAt: ahora,
      ),
    );
    await _guardar();
  }

  Future<void> completarLeccion(String leccionId, {int xp = 10, bool perfecto = false, int estrellas = 1}) async {
    _progreso.leccionesCompletadas++;
    _progreso.leccionesCompletadasMap[leccionId] =
        (_progreso.leccionesCompletadasMap[leccionId] ?? 0) + 1;
    await agregarXP(xp + (perfecto ? GConstants.xpLeccionSinErrores : 0));
    _progreso.estrellasTotales += estrellas;
    await _guardar();
  }

  bool escudoPuedeActivar() =>
      !_progreso.escudoActivo ||
      _progreso.escudoExpira.isBefore(DateTime.now());

  Future<void> activarEscudo() async {
    _progreso.escudoActivo = true;
    _progreso.escudoExpira = DateTime.now().add(const Duration(days: 1));
    await _guardar();
  }

  bool get escudoActivo => _progreso.escudoActivo;
  int get rachaActual => _progreso.rachaActual;
  int get rachaMaxima => _progreso.rachaMaxima;
  int get xpTotal => _progreso.xpTotal;
  int get nivel => _progreso.nivel;
  String get apodo => _progreso.apodo;

  Future<void> setApodo(String apodo) async {
    _progreso.apodo = apodo;
    await _guardar();
  }

  List<String> get preguntasFalladas => _progreso.preguntasFalladas;
}
