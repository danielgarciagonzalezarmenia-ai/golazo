import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../models/inventory.dart';
import '../models/medalla.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class VestuarioScreen extends StatefulWidget {
  const VestuarioScreen({super.key});

  @override
  State<VestuarioScreen> createState() => _VestuarioScreenState();
}

class _VestuarioScreenState extends State<VestuarioScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final inv = InventoryService.instance;
    return CupertinoPageScaffold(
      backgroundColor: GColors.fondo(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: GColors.fondo(context).withOpacity(0.9),
        border: null,
        middle: Text('Vestuario', style: GTheme.cardTitleStyle(context)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _tabs(),
            Expanded(child: _contenidoTab(inv)),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return CupertinoSegmentedControl<int>(
      children: {
        0: _chipTab('Potenciadores', Icons.flash_on),
        1: _chipTab('Camisetas', Icons.checkroom),
        2: _chipTab('Balones', Icons.sports_soccer),
        3: _chipTab('Estadios', Icons.stadium),
        4: _chipTab('Títulos', Icons.emoji_events),
      },
      groupValue: _tab,
      onValueChanged: (v) => setState(() => _tab = v),
      borderColor: Colors.transparent,
      unselectedColor: GColors.textoSecundario(context),
      selectedColor: GColors.primario(context),
    );
  }

  Widget _chipTab(String texto, IconData icono) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 20),
        const SizedBox(width: 6),
        Text(texto),
      ],
    );
  }

  Widget _contenidoTab(InventoryService inv) {
    late final List<InventoryItem> items;
    switch (_tab) {
      case 0:
        items = inv.inventario.where((i) => i.tipo == ItemType.potenciador).toList();
        break;
      case 1:
        items = inv.inventario.where((i) => i.tipo == ItemType.camiseta).toList();
        break;
      case 2:
        items = inv.inventario.where((i) => i.tipo == ItemType.balon).toList();
        break;
      case 3:
        items = inv.inventario.where((i) => i.tipo == ItemType.estadio).toList();
        break;
      case 4:
        items = inv.inventario.where((i) => i.tipo == ItemType.titulo).toList();
        break;
      default:
        items = [];
    }
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text('Aún no tienes ítems aquí.', style: GTheme.bodyStyle(context)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _tarjetaItem(items[i]),
    );
  }

  Widget _tarjetaItem(InventoryItem item) {
    final obtenido = item.cantidad > 0;
    final raroColor = _colorRareza(item.rareza);
    return GestureDetector(
      onTap: () {
        if (item.tipo != ItemType.potenciador) {
          InventoryService.instance.equiparCosmetico(item.id);
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: GColors.superficie(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: obtenido ? raroColor : Colors.grey.shade700,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  _iconoItem(item.tipo),
                  size: 48,
                  color: obtenido ? raroColor : Colors.grey.shade500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    item.nombre,
                    style: GTheme.cardTitleStyle(context, size: 15),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (obtenido)
                    Text('x${item.cantidad}', style: GTheme.captionStyle(context))
                  else
                    Text('???', style: GTheme.captionStyle(context)),
                  if (!obtenido && item.comoConseguir != null)
                    Text(
                      item.comoConseguir ?? '',
                      style: GTheme.captionStyle(context),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorRareza(Rareza r) {
    switch (r) {
      case Rareza.comun: return Colors.grey.shade500;
      case Rareza.rara: return const Color(0xFF2D7FF9);
      case Rareza.epica: return const Color(0xFF9B5DE5);
      case Rareza.legendaria: return const Color(0xFFFFC83D);
    }
  }

  IconData _iconoItem(ItemType t) {
    switch (t) {
      case ItemType.potenciador: return Icons.flash_on;
      case ItemType.camiseta: return Icons.checkroom;
      case ItemType.balon: return Icons.sports_soccer;
      case ItemType.estadio: return Icons.stadium;
      case ItemType.titulo: return Icons.emoji_events;
      case ItemType.celebracion: return Icons.celebration;
    }
  }
}
