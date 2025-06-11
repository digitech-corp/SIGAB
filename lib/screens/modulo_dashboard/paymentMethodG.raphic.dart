import 'package:flutter/material.dart';

class BarraDivididaConTooltip extends StatefulWidget {
  final int contado;
  final int credito;

  const BarraDivididaConTooltip({
    super.key,
    required this.contado,
    required this.credito,
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

  @override
  Widget build(BuildContext context) {
    final int total = widget.contado + widget.credito;
    final double porcentajeContado = total > 0 ? widget.contado / total : 0;
    final double porcentajeCredito = total > 0 ? widget.credito / total : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ventas al Contado y Crédito',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.
            w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total de ventas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                'Total de Ventas: ${widget.contado + widget.credito}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            // Leyenda de colores
            Row(
              children: const [
                _Leyenda(color: Color(0xFFFF8C33), texto: 'Contado'),
                SizedBox(width: 12),
                _Leyenda(color: Color(0xFF707070), texto: 'Crédito'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(
                flex: (porcentajeContado * 1000).toInt(),
                child: GestureDetector(
                  key: _keyContado,
                  onTap: () => _showTooltip(context, _keyContado, '${widget.contado} ventas al contado'),
                  child: Container(
                    height: 30,
                    color: const Color(0xFFFF8C33),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "${widget.contado}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: (porcentajeCredito * 1000).toInt(),
                child: GestureDetector(
                  key: _keyCredito,
                  onTap: () => _showTooltip(context, _keyCredito, '${widget.credito} ventas a crédito'),
                  child: Container(
                    height: 30,
                    color: const Color(0xFF707070),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "${widget.credito}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
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