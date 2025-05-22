import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/screens/modulo_pedidos/new_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  int selectedIndex = 0;
  List<ProductSelection> selections = [];

  List<Catalogo> catalogos = [
    Catalogo(nombre: 'AVES', imagenUrl: 'assets/images/bird.png'),
    Catalogo(nombre: 'CERDOS', imagenUrl: 'assets/images/pig.png'),
    Catalogo(nombre: 'VACAS', imagenUrl: 'assets/images/cow.png'),
    Catalogo(nombre: 'CUY', imagenUrl: 'assets/images/guinea_pig.png'),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<ProductsProvider>(context, listen: false);
      provider.fetchProducts();
    });
  }

  Map<int, ProductSelection> selectionMap = {};
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    final selectedTipo = catalogos[selectedIndex].nombre;
    final productosFiltrados = provider.products
      .where((p) => p.animalType.toUpperCase() == selectedTipo.toUpperCase())
      .toList();

    final selections = productosFiltrados.map((product) {
      if (selectionMap.containsKey(product.idProduct)) {
        return selectionMap[product.idProduct]!;
      } else {
        final newSelection = ProductSelection(product: product);
        selectionMap[product.idProduct] = newSelection;
        return newSelection;
      }
    }).toList();
    
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

      body: provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
              _buildAnimalSelector(),
              const Divider(height: 0, thickness: 1),
              const SizedBox(height: 5),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildContent(
                      selections
                    ),
              ),
              _buildGuardarButton(),
            ],
          ),
    );
  }

  Widget _buildAnimalSelector() {
    return SizedBox(
      height: 36,
      width: double.infinity,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: catalogos.length,
          itemBuilder: (context, index) {
            final item = catalogos[index];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: isSelected ? const Color(0xFFFF6600) : Color(0xffBDBDBD)),
                ),
                child: Row(
                  children: [
                    Image.asset(item.imagenUrl, width: 20, height: 20, color: isSelected ? const Color(0xFFFF6600) : Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      item.nombre,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: isSelected ? const Color(0xFFFF6600) : const Color(0xffBDBDBD)
                      ),
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

  Widget _buildContent(List<ProductSelection> selections) {
    if (selections.isEmpty) {
      return const Center(child: Text('No hay productos disponibles.'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 2),
            child: Row(
              children: const [
                SizedBox(width: 40, child: Text('Cant.', style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xff333333)))),
                SizedBox(width: 200, child: Text('Nombre del Producto', style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xff333333)))),
                SizedBox(width: 30, child: Text('Tipo', style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xff333333)))),
                SizedBox(width: 50, child: Text('Precio', style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xff333333)))),
                SizedBox(width: 30, child: Text('Selec', style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w400, color: Color(0xff333333)))),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: selections.length,
              itemBuilder: (context, index) {
                final selection = selections[index];
                final product = selection.product;
                return SizedBox(
                  height: 25,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: TextFormField(
                          initialValue: selection.quantity == 0 ? '' : selection.quantity.toString(),
                          enabled: selection.isSelected,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                            border: UnderlineInputBorder()
                          ),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.w400
                          ),
                          onChanged: (val) {
                            final parsed = int.tryParse(val);
                            if (parsed != null) {
                              setState(() {
                                selection.quantity = parsed;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 200,
                        child: Text(
                          product.productName,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(
                          product.productType,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            checkboxTheme: CheckboxThemeData(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          child: Checkbox(
                            value: selection.isSelected,
                            onChanged: (val) {
                              setState(() {
                                selection.isSelected = val ?? false;
                                product.state = val ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuardarButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final selected = selections.where((s) => s.isSelected).toList();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewOrderScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6600),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        ),
        child: const Text('GUARDAR SELECCIÓN'),
      ),
    );
  }
}

class ProductSelection {
  final Product product;
  bool isSelected;
  int quantity;

  ProductSelection({
    required this.product,
    this.isSelected = false,
    this.quantity = 0,
  });
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