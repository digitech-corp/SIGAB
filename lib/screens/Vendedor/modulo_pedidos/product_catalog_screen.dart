import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/part_order.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userProvider = Provider.of<UsersProvider>(context, listen: false);
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      final token = userProvider.token;

      productsProvider.fetchProducts(token!);
      await ordersProvider.fetchPedidosClienteCompletos(token, widget.idCustomer).then((_) {
        productsProvider.loadPriceHistory(widget.idCustomer, ordersProvider);
      });
      productsProvider.setCurrentCustomer(widget.idCustomer);
    });
  }

  List<Catalogo> catalogos = [
    Catalogo(nombre: 'AVES', imagenUrl: 'assets/images/bird.png'),
    Catalogo(nombre: 'CERDOS', imagenUrl: 'assets/images/pig.png'),
    Catalogo(nombre: 'VACUNOS', imagenUrl: 'assets/images/cow.png'),
    Catalogo(nombre: 'CUYES', imagenUrl: 'assets/images/guinea_pig.png'),
  ];

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
            backgroundColor: AppColors.orange,
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
                Text('Catálogo de Productos', style: AppTextStyles.title),
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
                    Text('Selecciona los productos requeridos', style: AppTextStyles.subtitle),
                  ],
                ),
              ),
              _buildAnimalSelector(),
              const Divider(height: 0, thickness: 1),
              const SizedBox(height: 15),
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: SizedBox(
      height: 36,
      width: double.infinity,
      child: Row(
        children: List.generate(catalogos.length, (index) {
          final item = catalogos[index];
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.orange : AppColors.lightGris,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      item.imagenUrl,
                      width: 18,
                      height: 18,
                      color: isSelected ? AppColors.orange : Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        item.nombre,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.itemSelect(isSelected)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: Text('Cant.', style: AppTextStyles.tableHead)),
              const SizedBox(width: 5),
              Expanded(flex: 7, child: Text('Nombre del Producto', style: AppTextStyles.tableHead, textAlign: TextAlign.left)),
              Expanded(flex: 2, child: Text('Stock', style: AppTextStyles.tableHead, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('Tipo', style: AppTextStyles.tableHead, textAlign: TextAlign.center)),
              Expanded(flex: 3, child: Text('Precio', style: AppTextStyles.tableHead, textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('Selec', style: AppTextStyles.tableHead)),
            ],
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
                String tipo = product.productType.toUpperCase();
                String letraType = tipo.isNotEmpty ? tipo[0] : '';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: selection.controller,
                          enabled: selection.isSelected,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}(\.\d{0,2})?')),
                          ],
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                            border: UnderlineInputBorder(),
                          ),
                          style: AppTextStyles.cant,
                          onChanged: (val) {
                            final parsed = double.tryParse(val.replaceAll(',', '.'));
                            provider.toggleSelection(
                              selection.product,
                              isSelected: selection.isSelected,
                              quantity: parsed ?? 0.0,
                              shouldUpdateController: false,
                            );
                          }
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 7,
                        child: Text(product.productName, style: AppTextStyles.tableData),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${product.stockActualEmpresa}', style: AppTextStyles.tableData, textAlign: TextAlign.right),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(letraType, style: AppTextStyles.tableData, textAlign: TextAlign.center),
                      ),
                      buildCompactPriceEditor(
                        context: context,
                        selection: selection,
                        provider: provider,
                        idCustomer: widget.idCustomer,
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: 28,
                          child: Checkbox(
                            value: selection.isSelected,
                            onChanged: (widget.idCustomer >= 1)
                                ? (val) {
                                    setState(() {
                                      selection.isSelected = val ?? false;
                                      if (!selection.isSelected) {
                                        selection.quantity = 0.0;
                                        selection.controller.text = '';
                                      }
                                      Provider.of<ProductsProvider>(context, listen: false)
                                          .toggleSelection(selection.product,
                                              isSelected: selection.isSelected,
                                              quantity: selection.quantity);
                                    });
                                  }
                                : null,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                              if (states.contains(WidgetState.disabled)) {
                                return Colors.grey.shade300;
                              }
                              return selection.isSelected ? AppColors.gris : Colors.white;
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

  Widget _buildGuardarButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          try {
            final provider = Provider.of<ProductsProvider>(context, listen: false);
            final selected = provider.selectedProducts;
            for (var sel in provider.selectedProducts) {
              // cantidad
              final text = sel.controller.text.replaceAll(',', '.');
              sel.quantity = double.tryParse(text) ?? 0.0;

              // precio
              final priceText = sel.priceController.text.replaceAll(',', '.');
              sel.currentPrice = double.tryParse(priceText) ?? sel.product.price;
            }


            if (selected.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecciona al menos un producto con cantidad')),
              );
              return;
            }

            if (selected.any((sel) => sel.quantity <= 0)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cada producto necesita una cantidad válida')),
              );
              return;
            }

            if (selected.any((sel) => sel.currentPrice == null)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Revisa los precios de los productos seleccionados')),
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
          backgroundColor: AppColors.orange,
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
  double quantity;
  double? initialPrice;
  double? currentPrice;
  late TextEditingController controller;
  late TextEditingController priceController;

  ProductSelection({
    required this.product,
    this.isSelected = false,
    this.quantity = 0.0,
    this.initialPrice,
    this.currentPrice,
  }) {
    controller = TextEditingController(
      text: quantity > 0 ? quantity.toString() : '',
    );
    priceController = TextEditingController(
      text: (currentPrice ?? initialPrice ?? product.price).toStringAsFixed(2),
    );
  }

  void updatePrice(double newPrice) {
    currentPrice = newPrice;
    priceController.text = newPrice.toStringAsFixed(2);
  }

  void updateQuantity(double newQuantity) {
    quantity = newQuantity;
    controller.text = newQuantity > 0 ? newQuantity.toString() : '';
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

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 11,
    color: AppColors.gris
  );
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final subtitle = base.copyWith(fontSize: 12, color: Colors.black,);
  static final tableHead = base.copyWith(fontWeight: FontWeight.w500);
  static final cant = base.copyWith(fontSize: 10);
  static final tableData = base.copyWith(fontSize: 10);
  static final historyTitle = base.copyWith(fontSize: 16, fontWeight: FontWeight.w500);
  static final historyHead = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final priceData = base.copyWith(fontSize: 13, fontWeight: FontWeight.w300);
  static final btnPrice = base.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.orange);
  static TextStyle itemSelect(bool isSelected) {
    return base.copyWith(
      fontSize: 12, fontWeight: FontWeight.w300, color: isSelected ? AppColors.orange : AppColors.lightGris
    );
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const lightGris = Color(0xFFBDBDBD);
}