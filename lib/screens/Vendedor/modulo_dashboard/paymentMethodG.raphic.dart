import 'package:balanced_foods/models/order.dart';
import 'package:flutter/material.dart';

class BarraDivididaConTooltip extends StatefulWidget {
  final contado;
  final credito;
  final double montoContado;
  final double montoCredito;

  const BarraDivididaConTooltip({
    super.key,
    required this.contado,
    required this.credito,
    required this.montoContado,
    required this.montoCredito,
  });

  @override
  State<BarraDivididaConTooltip> createState() => _BarraDivididaConTooltipState();
}

class _BarraDivididaConTooltipState extends State<BarraDivididaConTooltip> {
  final GlobalKey _keyContado = GlobalKey();
  final GlobalKey _keyCredito = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showTooltip(BuildContext context, GlobalKey key, String texto) {
    _overlayEntry?.remove();

    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;

    const double tooltipPadding = 0;
    const double tooltipWidthEstimate = 180;

    double leftPosition = offset.dx;
    if (offset.dx + tooltipWidthEstimate > screenWidth - tooltipPadding) {
      leftPosition = screenWidth - tooltipWidthEstimate - tooltipPadding;
      if (leftPosition < tooltipPadding) leftPosition = tooltipPadding;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy - 40,
        left: leftPosition,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 6),
              ],
            ),
            child: Text(
              texto,
              style: const TextStyle(color: Color(0xFF333333), fontSize: 14),
              softWrap: true,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 2), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  int contadoCantidad = 0;
    int creditoCantidad = 0;

    int sumarCantidadProductos(List<Order> orders) {
      return orders.fold<int>(0, (total, order) {
        return total + (order.details?.fold<int>(0, (sum, detail) {
          return sum + detail.quantity.toInt();
        }) ?? 0);
      });
    }

  @override
  Widget build(BuildContext context) {
    final int total = widget.contado.length + widget.credito.length;
    final double porcentajeContado = total > 0 ? widget.contado.length / total : 0;
    final double porcentajeCredito = total > 0 ? widget.credito.length / total : 0;
    final double totalSoles = widget.montoContado + widget.montoCredito;
    
    final ordersContado = widget.contado;
    final ordersCredito = widget.credito;
    
    final contadoCantidad = sumarCantidadProductos(ordersContado);
    final creditoCantidad = sumarCantidadProductos(ordersCredito);

    final totalSacos = contadoCantidad + creditoCantidad;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ventas al Contado y Crédito', style: AppTextStyles.base),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                'Total de Ventas: ${widget.contado.length + widget.credito.length}',
                style: AppTextStyles.total,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Text(
                'S/ ${totalSoles.toStringAsFixed(2)}',
                style: AppTextStyles.total,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(
                flex: (porcentajeContado * 1000).toInt(),
                child: GestureDetector(
                  key: _keyContado,
                  onTap: () => _showTooltip(context, _keyContado,
                    'Contado: ${widget.contado.length} ventas\nPrecio: S/ ${widget.montoContado.toStringAsFixed(2)}\nSacos: S/ $contadoCantidad'),
                  child: Container(
                    height: 30,
                    color: AppColors.orangeLight,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "${widget.contado.length}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: (porcentajeCredito * 1000).toInt(),
                child: GestureDetector(
                  key: _keyCredito,
                  onTap: () => _showTooltip(context, _keyCredito,
                      'Crédito: ${widget.credito.length} ventas\nPrecio: S/ ${widget.montoCredito.toStringAsFixed(2)}\nSacos: S/ $creditoCantidad'),
                  child: Container(
                    height: 30,
                    color: AppColors.grisLight,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "${widget.credito.length}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Leyenda de colores separada
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                'Total de Sacos: $totalSacos',
                style: AppTextStyles.total,
              ),
            ),
            const Spacer(),
            const _Leyenda(color: AppColors.orangeLight, texto: 'Contado'),
            const SizedBox(width: 12),
            const _Leyenda(color: AppColors.grisLight, texto: 'Crédito'),
          ],
        ),
      ],
    );
  }
}

class _Leyenda extends StatelessWidget {
  final Color color;
  final String texto;

  const _Leyenda({required this.color, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          texto,
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.gris
  );
  static final total = base.copyWith(fontWeight: FontWeight.w600);
}

class AppColors {
  static const gris = Color(0xFF333333);
  static const grisLight = Color(0xFF707070);
  static const orangeLight = Color(0xFFFF8C33);
}