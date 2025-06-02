import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class ProductCatalogScreen extends StatefulWidget {
  final int idCustomer;
  const ProductCatalogScreen({Key? key, required this.idCustomer}) : super(key: key);

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
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

      ordersProvider.fetchOrders().then((_) {
        productsProvider.loadPriceHistory(widget.idCustomer, ordersProvider);
      });

      productsProvider.fetchProducts();
      productsProvider.setCurrentCustomer(widget.idCustomer);
    });
  }

  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    final selectionMap = provider.selectionMap;
    final selectedTipo = catalogos[selectedIndex].nombre;
    final productosFiltrados = provider.products
      .where((p) => p.animalType.toUpperCase() == selectedTipo.toUpperCase())
      .toList();

    selections = productosFiltrados.map((product) {
      return selectionMap[product.idProduct] ?? ProductSelection(product: product);
    }).toList();

    final ordersProvider = Provider.of<OrdersProvider>(context);
    final customerOrders = ordersProvider.orders
        .where((order) => order.idCustomer == widget.idCustomer)
        .toList();

    final Map<int, List<Map<String, dynamic>>> productHistory = {};

    for (var order in customerOrders) {
      for (var detail in order.details) {
        productHistory.putIfAbsent(detail.idProducto, () => []);
        productHistory[detail.idProducto]!.add({
          'unitPrice': detail.unitPrice,
          'dateCreated': order.dateCreated,
        });
      }
    }
    
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
                    Navigator.pop(context);
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
    final provider = Provider.of<ProductsProvider>(context);
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
                          controller: selection.controller,
                          enabled: selection.isSelected,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
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
                                provider.toggleSelection(
                                  selection.product,
                                  isSelected: selection.isSelected,
                                  quantity: selection.quantity,
                                );
                              });
                            }
                          }
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
                        child: InkWell(
                          onTap: () async {
                            final history = provider.getPriceHistory(product.idProduct);
                            final selectedPrice = await _buildPriceHistoryModal(context, history);

                            if (selectedPrice != null) {
                              provider.updatePrice(product.idProduct, selectedPrice);
                            }
                          },
                          child: Text(
                            '${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.none,
                            ),
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
                            onChanged: (widget.idCustomer != null && widget.idCustomer! >= 1)
                                ? (val) {
                                    setState(() {
                                      selection.isSelected = val ?? false;
                                      if (!selection.isSelected) {
                                        selection.quantity = 0;
                                        selection.controller.text = '';
                                      }
                                      provider.toggleSelection(
                                        selection.product,
                                        isSelected: selection.isSelected,
                                        quantity: selection.quantity,
                                      );
                                    });
                                  }
                                : null, // deshabilita si el cliente no está seleccionado
                            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.grey.shade300; // gris si está deshabilitado
                              }
                              return selection.isSelected ? const Color(0xFF333333) : Colors.white;
                            }),
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

  Future<double?> _buildPriceHistoryModal(BuildContext context, List<Map<String, dynamic>> history) async {
    double? selectedPrice;

    return await showModalBottomSheet<double>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Historial de Precios',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (history.isEmpty)
                    const Text('No hay historial disponible.')
                  else
                    ...history.map((item) {
                      final price = item['unitPrice'] as double;
                      final date = item['dateCreated'];
                      final formattedDate = date is String
                          ? date
                          : DateFormat('dd/MM/yyyy').format(date as DateTime);
                      return RadioListTile<double>(
                        value: price,
                        groupValue: selectedPrice,
                        title: Text('S/ ${price.toStringAsFixed(2)}'),
                        subtitle: Text('Fecha: $formattedDate'),
                        onChanged: (val) {
                          setState(() {
                            selectedPrice = val;
                          });
                        },
                      );
                    }).toList(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, selectedPrice);
                    },
                    child: const Text('Usar este precio'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGuardarButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          try {
            final provider = Provider.of<ProductsProvider>(context, listen: false);
            final selected = provider.selectedProducts;


            if (selected.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecciona al menos un producto con cantidad')),
              );
              return;
            }
            
            Navigator.pop(context);

          } catch (e, stack) {
            print('Error al guardar selección: $e');
            print(stack);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ocurrió un error inesperado.')),
            );
          }
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
  TextEditingController controller;

  ProductSelection({
    required this.product,
    this.isSelected = false,
    this.quantity = 0,
  }): controller = TextEditingController(text: '');
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