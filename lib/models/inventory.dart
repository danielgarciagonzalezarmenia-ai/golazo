enum ItemType {
  potenciador,
  camiseta,
  balon,
  estadio,
  titulo,
  celebracion,
}

enum Rareza {
  comun,
  rara,
  epica,
  legendaria,
}

class InventoryItem {
  final String id;
  final String nombre;
  final String descripcion;
  final ItemType tipo;
  final Rareza rareza;
  int cantidad;
  final bool equipado;
  final String? comoConseguir;
  final String? iconoNombre;

  InventoryItem({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.tipo,
    required this.rareza,
    this.cantidad = 0,
    this.equipado = false,
    this.comoConseguir,
    this.iconoNombre,
  });

  InventoryItem copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    ItemType? tipo,
    Rareza? rareza,
    int? cantidad,
    bool? equipado,
    String? comoConseguir,
    String? iconoNombre,
  }) =>
      InventoryItem(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
        tipo: tipo ?? this.tipo,
        rareza: rareza ?? this.rareza,
        cantidad: cantidad ?? this.cantidad,
        equipado: equipado ?? this.equipado,
        comoConseguir: comoConseguir ?? this.comoConseguir,
        iconoNombre: iconoNombre ?? this.iconoNombre,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'tipo': tipo.index,
    'rareza': rareza.index,
    'cantidad': cantidad,
    'equipado': equipado,
    'comoConseguir': comoConseguir,
    'iconoNombre': iconoNombre,
  };

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
    id: json['id'] as String,
    nombre: json['nombre'] as String,
    descripcion: json['descripcion'] as String,
    tipo: ItemType.values[json['tipo'] as int],
    rareza: Rareza.values[json['rareza'] as int],
    cantidad: json['cantidad'] as int? ?? 0,
    equipado: json['equipado'] as bool? ?? false,
    comoConseguir: json['comoConseguir'] as String?,
    iconoNombre: json['iconoNombre'] as String?,
  );
}
