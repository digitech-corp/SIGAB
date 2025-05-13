import 'package:balanced_foods/screens/modulo_pedidos/new_order_screen.dart';
import 'package:flutter/material.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  int selectedIndex = 0;

  List<Catalogo> catalogos = [
    Catalogo(nombre: 'AVES', imagenUrl: 'assets/images/bird.png'),
    Catalogo(nombre: 'CERDOS', imagenUrl: 'assets/images/pig.png'),
    Catalogo(nombre: 'VACAS', imagenUrl: 'assets/images/cow.png'),
    Catalogo(nombre: 'CUY', imagenUrl: 'assets/images/guinea_pig.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFFF6600),
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => NewOrderScreen()),
                    );
                  },
                ),
                const SizedBox(width: 1),
                const Text(
                  'Catálogo de Productos',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecciona los productos requeridos',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 36,
            width: double.infinity,
            child: Center(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: catalogos.length,
                itemBuilder: (context, index) {
                  final item = catalogos[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected 
                          ? const Color(0xFFBDBDBD) 
                          : Color(0xFFBDBDBD),
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            item.imagenUrl,
                            width: 20,
                            height: 20,
                            color: isSelected ? const Color(0xFFFF6600) : Colors.black,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.nombre,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              color: isSelected ? const Color(0xFFFF6600) : Colors.black54,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 0, thickness: 1),
          Expanded(
            child: _buildContent(catalogos[selectedIndex].nombre),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6600),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
              child: Text(
                'GUARDAR SELECCIÓN',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildContent(String tipo) {
    List<Map<String, String>> productos = _productosPorTipo(tipo);

    return ListView.separated(
      padding: const EdgeInsets.all(18),
      itemCount: productos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final producto = productos[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.chevron_right, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(producto['nombre']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('Tipo: ${producto['tipo']} - Precio: ${producto['precio']}'),
                  ],
                ),
              ),
              Checkbox(value: false, onChanged: (val) {}),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, String>> _productosPorTipo(String tipo) {
    switch (tipo) {
      case 'AVES':
        return [
          {'nombre': 'ADV/Aves Crecimiento', 'tipo': 'H', 'precio': '120.90'},
          {'nombre': 'ADV/Aves Engorde', 'tipo': 'H', 'precio': '98.90'},
          {'nombre': 'ADV/Aves Postura', 'tipo': 'H', 'precio': '98.90'},
        ];
      case 'CERDOS':
        return [
          {'nombre': 'Cerdo Lechón', 'tipo': 'H', 'precio': '110.50'},
          {'nombre': 'Cerdo Engorde', 'tipo': 'H', 'precio': '115.00'},
        ];
      case 'VACAS':
        return [
          {'nombre': 'Vaca Lechera', 'tipo': 'H', 'precio': '150.75'},
          {'nombre': 'Vaca Recría', 'tipo': 'H', 'precio': '142.30'},
        ];
      case 'CUY':
        return [
          {'nombre': 'Cuy Engorde', 'tipo': 'H', 'precio': '70.00'},
          {'nombre': 'Cuy Maternidad', 'tipo': 'H', 'precio': '75.00'},
        ];
      default:
        return [];
    }
  }
}


// MODELO DE DATOS
class Catalogo {
  final String nombre;
  final String imagenUrl;

  Catalogo({
    required this.nombre,
    required this.imagenUrl,
  });
}