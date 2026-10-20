import '../core/storage.dart';
import '../models/inventory.dart';

class InventoryService {
  InventoryService._();
  static final InventoryService instance = InventoryService._();

  final Map<String, InventoryItem> _catalogo = {};
  final List<InventoryItem> _inventario = [];

  Future<void> init() async {
    await GStorage.instance.init();
    _cargarCatalogo();
    _cargarInventario();
  }

  void _cargarCatalogo() {
    _catalogo.clear();
    _catalogo['pista'] = InventoryItem(
      id: 'pista',
      nombre: 'Pista (Silbato)',
      descripcion: 'Elimina 2 respuestas incorrectas en una pregunta.',
      tipo: ItemType.potenciador,
      rareza: Rareza.comun,
      iconoNombre: 'pista',
      comoConseguir: 'Racha día 1',
    );
    _catalogo['segunda_oportunidad'] = InventoryItem(
      id: 'segunda_oportunidad',
      nombre: 'Segunda oportunidad',
      descripcion: 'Restaura 1 balón de vida.',
      tipo: ItemType.potenciador,
      rareza: Rareza.comun,
      iconoNombre: 'segunda_oportunidad',
      comoConseguir: 'Racha día 2',
    );
    _catalogo['escudo'] = InventoryItem(
      id: 'escudo',
      nombre: 'Escudo de racha',
      descripcion: 'Protege la racha 1 día si no juegas.',
      tipo: ItemType.potenciador,
      rareza: Rareza.rara,
      iconoNombre: 'escudo',
      comoConseguir: 'Racha día 3',
    );
    _catalogo['doble_xp'] = InventoryItem(
      id: 'doble_xp',
      nombre: 'Doble XP',
      descripcion: 'XP x2 por 30 minutos.',
      tipo: ItemType.potenciador,
      rareza: Rareza.rara,
      iconoNombre: 'doble_xp',
      comoConseguir: 'Racha día 4',
    );
    _catalogo['camiseta_rayas'] = InventoryItem(
      id: 'camiseta_rayas',
      nombre: 'Camiseta Rayas',
      descripcion: 'Camiseta de rayas para Chispa.',
      tipo: ItemType.camiseta,
      rareza: Rareza.comun,
      iconoNombre: 'camiseta_rayas',
      comoConseguir: 'Racha día 5',
    );
    _catalogo['balon_dorado'] = InventoryItem(
      id: 'balon_dorado',
      nombre: 'Balón Dorado',
      descripcion: 'Balón cosmético dorado.',
      tipo: ItemType.balon,
      rareza: Rareza.rara,
      iconoNombre: 'balon_dorado',
      comoConseguir: 'Racha día 10',
    );
    _catalogo['estadio_nocturno'] = InventoryItem(
      id: 'estadio_nocturno',
      nombre: 'Estadio Nocturno',
      descripcion: 'Fondo de estadio iluminado.',
      tipo: ItemType.estadio,
      rareza: Rareza.epica,
      iconoNombre: 'estadio_nocturno',
      comoConseguir: 'Racha día 21',
    );
  }

  void _cargarInventario() {
    _inventario.clear();
    final data = GStorage.instance.readJson('inventario');
    if (data != null) {
      for (final entry in data.entries) {
        final item = InventoryItem.fromJson(
          Map<String, dynamic>.from(entry.value as Map),
        );
        _inventario.add(item);
        if (item.equipado) {
          // marcar como equipado en catalogo si existe
          final cat = _catalogo[item.id];
          if (cat != null) {
            // no mutamos catalogo, solo referencia
          }
        }
      }
    } else {
      _inventario.addAll(_catalogo.values.where((i) => i.cantidad > 0));
    }
  }

  List<InventoryItem> get catalogo => _catalogo.values.toList();
  List<InventoryItem> get inventario => _inventario;

  bool tieneItem(String id) =>
      _inventario.any((i) => i.id == id && i.cantidad > 0);

  InventoryItem? itemPorId(String id) =>
      _inventario.firstWhereOrNull((i) => i.id == id);

  Future<void> agregarItem(String id, {int cantidad = 1}) async {
    final existente = _inventario.firstWhereOrNull((i) => i.id == id);
    if (existente != null) {
      existente.cantidad += cantidad;
    } else {
      final cat = _catalogo[id];
      if (cat != null) {
        _inventario.add(cat.copyWith(cantidad: cantidad));
      }
    }
    await _guardar();
  }

  Future<void> consumirItem(String id) async {
    final idx = _inventario.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    _inventario[idx].cantidad--;
    if (_inventario[idx].cantidad <= 0) {
      _inventario.removeAt(idx);
    }
    await _guardar();
  }

  Future<void> equiparCosmetico(String id) async {
    for (final item in _inventario) {
      final index = _inventario.indexOf(item);
      if (item.tipo == ItemType.camiseta ||
          item.tipo == ItemType.balon ||
          item.tipo == ItemType.estadio ||
          item.tipo == ItemType.titulo ||
          item.tipo == ItemType.celebracion) {
        if (item.id == id) {
          _inventario[index] = item.copyWith(equipado: true);
        } else if (
          item.tipo == ItemType.camiseta ||
          item.tipo == ItemType.balon ||
          item.tipo == ItemType.estadio ||
          item.tipo == ItemType.titulo ||
          item.tipo == ItemType.celebracion) {
          _inventario[index] = item.copyWith(equipado: false);
        }
      }
    }
    await _guardar();
  }

  InventoryItem? getCosmeticoEquipado(ItemType tipo) =>
      _inventario.firstWhereOrNull((i) => i.tipo == tipo && i.equipado);

  Future<void> _guardar() async {
    final mapa = <String, dynamic>{};
    for (final item in _inventario) {
      mapa[item.id] = item.toJson();
    }
    await GStorage.instance.saveJson('inventario', mapa);
  }
}

extension FirstWhereOrNullInv<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
