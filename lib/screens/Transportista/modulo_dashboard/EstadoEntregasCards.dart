import 'package:flutter/material.dart';
class EstadoEntregasCards extends StatefulWidget {
  final entregados;
  final noEntregados;
  const EstadoEntregasCards({super.key, required this.entregados, required this.noEntregados});

  @override
  State<EstadoEntregasCards> createState() => _EstadoEntregasCardsState();
}

class _EstadoEntregasCardsState extends State<EstadoEntregasCards> {
  @override
  Widget build(BuildContext context) {
    final entregado = widget.entregados;
    final noEntregado = widget.noEntregados;
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            title: "Entregado",
            value: entregado,
            color: Colors.green,
            icon: Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCard(
            title: "No Entregado",
            value: noEntregado,
            color: Colors.red,
            icon: Icons.cancel_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required int value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withValues(),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$value pedidos",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
