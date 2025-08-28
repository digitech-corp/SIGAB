import 'package:balanced_foods/models/cuota.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/opcionCatalogo.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/orderDetail.dart';
import 'package:balanced_foods/models/pagoMixto.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/product_catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class partOrder extends StatelessWidget {
  final int idCustomer;
  const partOrder({Key? key, required this.idCustomer}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Selección de Productos', style: AppTextStyles.subtitle),
              ], 
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductCatalogScreen(idCustomer: idCustomer)),
                    );
                  },
                  child: Text('Ver Catálogo', style: AppTextStyles.catalog),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SearchProduct extends StatefulWidget {
  final int? idCustomer;
  final List<ProductSelection>? initialSelections;
  const SearchProduct({super.key, required this.idCustomer, this.initialSelections});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
   final TextEditingController _searchController = TextEditingController();
    String _searchText = '';

    Product _mergeWithProviderProduct(ProductsProvider provider, Product base) {
      final fromProvider = provider.products.firstWhere(
        (p) => p.idProduct == base.idProduct,
        orElse: () => base,
      );

      if (identical(fromProvider, base)) {
        return base;
      }

      return fromProvider.copyWith(
        productName: (base.productName.isNotEmpty) ? base.productName : null,
        unidadMedida: (base.unidadMedida.isNotEmpty) ? base.unidadMedida : null,
        productType: (base.productType.isNotEmpty) ? base.productType : null,
        animalType: base.animalType,
        price: base.price > 0 ? base.price : null,
        stockActualEmpresa: fromProvider.stockActualEmpresa,
      );
    }

    @override
    void initState() {
      super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<ProductsProvider>(context, listen: false);

        if (widget.idCustomer != null) {
          provider.setCurrentCustomer(widget.idCustomer!);
        }

        if (widget.initialSelections != null) {
          for (final selection in widget.initialSelections!) {
            final mergedProduct = _mergeWithProviderProduct(provider, selection.product);

            provider.toggleSelection(
              mergedProduct,
              isSelected: true,
              quantity: selection.quantity,
              shouldUpdateController: true,
            );
          }
        }
      });

      _searchController.addListener(() {
        setState(() {
          _searchText = _searchController.text.toLowerCase();
        });
      });
    }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    final allProducts = provider.products;
    final selectionMap = provider.selectionMap;
    
    final filteredSelections = allProducts.where((product) {
      return product.productName.toLowerCase().contains(_searchText.toLowerCase()) ||
            product.idProduct.toString().contains(_searchText);
    }).map((product) {
      return selectionMap[product.idProduct] ??
          ProductSelection(product: product);
    }).toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 25,
                child: TextField(
                  controller: _searchController,
                  enabled: widget.idCustomer != null && widget.idCustomer! > 0,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    hintText: 'Buscar Producto/Código',
                    hintStyle: AppTextStyles.searchproduct,
                    filled: true,
                    fillColor: AppColors.backgris,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 15,
                    ),
                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 12, color: Colors.black),
                            onPressed: () {
                              _searchController.clear();
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  style: AppTextStyles.searchproduct
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_searchText.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: filteredSelections.length,
              itemBuilder: (context, index) {
                final selection = filteredSelections[index];
                final product = selection.product;

                return SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: selection.controller,
                          enabled: selection.isSelected,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,5}(\.\d{0,2})?')),
                          ],
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                            border: UnderlineInputBorder(),
                          ),
                          style: AppTextStyles.searchproduct,
                          onChanged: (val) {
                            final parsed = double.tryParse(val);
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
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 6,
                        child: Text(product.productName, style: AppTextStyles.productinfo),
                      ),
                       Expanded(
                        flex: 1,
                        child: Text('${product.stockActualEmpresa}', style: AppTextStyles.productinfo, textAlign: TextAlign.end),
                      ),
                      buildCompactPriceEditor(
                        context: context,
                        selection: selection,
                        provider: provider,
                        idCustomer: widget.idCustomer!,
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 28,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              checkboxTheme: CheckboxThemeData(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            child: Checkbox(
                              value: selection.isSelected,
                              onChanged: (val) {
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
                              },
                              fillColor: WidgetStateProperty.all<Color>(
                                selection.isSelected ? AppColors.gris : Colors.white,
                              ),
                            ),
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
    );
  }
}

Future<double?> _buildPriceHistoryModal(BuildContext context, List<Map<String, dynamic>> history) async {
  int? selectedIndex;

  return await showModalBottomSheet<double>(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Historial de Precios', style: AppTextStyles.historyTitle),
                  Divider(height: 2, thickness: 1, color: Colors.grey.shade300),
                  Row(
                    children: [
                      Expanded(flex: 4, child: Text('Precio', style: AppTextStyles.historyHead)),
                      Expanded(flex: 4, child: Text('Comprobante', style: AppTextStyles.historyHead)),
                      Expanded(flex: 2, child: Text('Fecha', style: AppTextStyles.historyHead)),
                    ],
                  ),
                  Divider(height: 2, thickness: 1, color: Colors.grey.shade300),
                  const SizedBox(height: 10),
                  if (history.isEmpty)
                    const Text('No hay historial disponible.')
                  else
                    ListTileTheme(
                      dense: true,
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      child: Column(
                        children: List.generate(history.length, (index) {
                          final item = history[index];
                          final price = item['unitPrice'] as double;
                          final comprobante = item['comprobante'] ?? 'N/A';
                          final date = item['date'];
                          final formattedDate = date is String
                              ? date
                              : DateFormat('dd/MM/yyyy').format(date as DateTime);
              
                          return RadioListTile<int>(
                            value: index,
                            groupValue: selectedIndex,
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('S/ ${price.toStringAsFixed(2)}', style: AppTextStyles.priceData),
                                Text('$comprobante', style: AppTextStyles.priceData),
                                Text(formattedDate, style: AppTextStyles.priceData),
                              ],
                            ),
                            onChanged: (val) {
                              setState(() {
                                selectedIndex = val;
                              });
                            },
                            activeColor: AppColors.orange,
                          );
                        }),
                      ),
                    ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedIndex != null) {
                        Navigator.pop(context, history[selectedIndex!]['unitPrice'] as double);
                      } else {
                        Navigator.pop(context, null);
                      }
                    },
                    child: Text('Usar este precio', style: AppTextStyles.btnPrice),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget buildCompactPriceEditor({
  required BuildContext context,
  required ProductSelection selection,
  required ProductsProvider provider,
  required int idCustomer,
}) {
  final controller = selection.priceController;
  final product = selection.product;

  return Expanded(
    flex: 3,
    child: GestureDetector(
      onDoubleTap: () async {
        final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
        await provider.loadPriceHistory(idCustomer, ordersProvider);
        final history = provider.getPriceHistory(product.idProduct);
        final selectedPrice = await _buildPriceHistoryModal(context, history);
        if (selectedPrice != null) {
          selection.currentPrice = selectedPrice;
          provider.updatePrice(product.idProduct, selectedPrice, notify: true);
          selection.priceController.text = selectedPrice.toStringAsFixed(2);
        }
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _iconButton(Icons.remove, () {
              final newPrice = selection.currentPrice! - 1;
              provider.updatePrice(product.idProduct, newPrice, notify: true);
              selection.priceController.text = newPrice.toStringAsFixed(2);
            }),
            Flexible(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d{0,2})?$')),
                ],
                textAlign: TextAlign.center,
                style: AppTextStyles.tableData,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                ),
                onChanged: (val) {
                  final parsed = double.tryParse(val.replaceAll(',', '.'));
                  if (parsed != null) {
                    selection.currentPrice = parsed;
                    provider.updatePrice(product.idProduct, parsed, notify: true);
                  }
                },
                onFieldSubmitted: (val) {
                  final parsed = double.tryParse(val.replaceAll(',', '.'));
                  if (parsed != null) {
                    selection.currentPrice = parsed;
                    provider.updatePrice(product.idProduct, parsed, notify: true); 
                    controller.text = parsed.toStringAsFixed(2);
                  }
                },
              ),
            ),
            _iconButton(Icons.add, () {
              final newPrice = selection.currentPrice! + 1;
              provider.updatePrice(product.idProduct, newPrice, notify: true);
              selection.priceController.text = newPrice.toStringAsFixed(2);
            }),
          ],
        ),
      ),
    ),
  );
}

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 15,
      child: IconButton(
        icon: Icon(icon, size: 10),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }

class ResumeProduct extends StatelessWidget {
  final List<ProductSelection> selectedProducts;

  const ResumeProduct({
    super.key,
    required this.selectedProducts,
  });

  @override
  Widget build(BuildContext context) {
    double total = selectedProducts.fold(
      0.0,
      (total, item) => total + (
        (item.currentPrice ?? item.product.price) * item.quantity
      ),
    );

    double subtotal = total / 1.18;
    double igv = total - subtotal;

    if (selectedProducts.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildHeader(),
            const Divider(color: Colors.black, thickness: 1, height: 5),
            _buildProductList(),
            SizedBox(width: 100, child: const Divider(color: Colors.black, thickness: 0.5, height: 6)),
            _buildTotalSection(subtotal, igv, total),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: Text('Cant.', style: AppTextStyles.tableHead)),
        Expanded(flex: 3, child: Text('Nombre del Producto', style: AppTextStyles.tableHead)),
        Expanded(flex: 1, child: Text('Pres', style: AppTextStyles.tableHead)),
        Expanded(flex: 1, child: Text('Tipo', style: AppTextStyles.tableHead)),
        Expanded(flex: 1, child: Text('Precio', style: AppTextStyles.tableHead, textAlign: TextAlign.right)),
        Expanded(flex: 1, child: Text('Parcial', style: AppTextStyles.tableHead, textAlign: TextAlign.right)),
      ],
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: selectedProducts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final selection = selectedProducts[index];
        
        String Umedida = selection.product.unidadMedida;
        List<String> medida = Umedida.split('|');

        String nombreUm = medida.isNotEmpty ? medida[0] : '';
        String primeraLetra = nombreUm.isNotEmpty ? nombreUm[0] : '';

        String cantidadStr = medida.length > 1 ? medida[1].replaceAll('.', '') : '0';
        String primerosNumerosStr = cantidadStr.length >= 2 ? cantidadStr.substring(0, 2) : cantidadStr;
        int primerosNumeros = int.tryParse(primerosNumerosStr) ?? 0;

        String pres = "$primeraLetra$primerosNumeros";
        String tipo = selection.product.productType.toUpperCase();
        String letraType = tipo.isNotEmpty ? tipo[0] : '';
        final double unitPrice = selection.currentPrice ?? selection.product.price;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: Text('${selection.quantity.toString().padLeft(2, '0')}', style: AppTextStyles.tableData)),
            Expanded(flex: 3, child: Text(selection.product.productName, style: AppTextStyles.tableData)),
            Expanded(flex: 1, child: Text(pres, style: AppTextStyles.tableData)),
            Expanded(flex: 1, child: Text(letraType, style: AppTextStyles.tableData)),
            Expanded(flex: 1, child: Text('${unitPrice.toStringAsFixed(2)}', style: AppTextStyles.tableData, textAlign: TextAlign.right)),
            Expanded(flex: 1, child: Text('${(unitPrice * selection.quantity).toStringAsFixed(2)}', style: AppTextStyles.tableData, textAlign: TextAlign.right)),
          ],
        );
      },
    );
  }

  Widget _buildTotalSection(double subtotal, double igv, double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('SubTotal', style: AppTextStyles.tableData),
            Text('I.G.V.', style: AppTextStyles.tableData),
            Text('TOTAL', style: AppTextStyles.tableTotal),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(subtotal.toStringAsFixed(2), style: AppTextStyles.tableData),
            Text(igv.toStringAsFixed(2), style: AppTextStyles.tableData),
            Text(total.toStringAsFixed(2), style: AppTextStyles.tableTotal),
          ],
        ),
      ],
    );
  }
}

class receiptType extends StatefulWidget {
  final List<OpcionCatalogo> tiposComprobante;
  final int? initialSelectedId;
  final bool readOnly;

  const receiptType({
    required this.tiposComprobante,
    super.key,
    this.initialSelectedId,
    this.readOnly = false,
  });

  @override
  State<receiptType> createState() => ReceiptTypeState();
}

class ReceiptTypeState extends State<receiptType> {
  int? selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.initialSelectedId;
  }

  int? get selectedReceiptId => selectedId;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: widget.tiposComprobante.map((opcion) {
        final isSelected = selectedId == opcion.id;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: isSelected,
                  activeColor: AppColors.gris,
                  checkColor: Colors.white,
                  onChanged: widget.readOnly
                      ? null
                      : (value) {
                          setState(() {
                            selectedId = value! ? opcion.id : null;
                          });
                        },
                ),
              ),
            ),
            Text(opcion.nombre, style: AppTextStyles.vars),
          ],
        );
      }).toList(),
    );
  }
}


class paymentMethod extends StatefulWidget {
  final List<OpcionCatalogo> tiposPago;
  final int? initialPaymentId;
  final double? initialImport;
  final List<Cuota>? initialCuotas;

  const paymentMethod({
    required this.tiposPago,
    super.key,
    this.initialPaymentId,
    this.initialImport,
    this.initialCuotas,
  });

  @override
  State<paymentMethod> createState() => PaymentMethodState();
}

class PaymentMethodState extends State<paymentMethod> {
  bool _contado = false;
  bool _credito = false;
  int? idselectedPayment;

  double? _importeGuardado;
  double? _saldoGuardado;

  List<Cuota> _cuotasCredito = [];
  List<PagoMixto> _pagosMixto = [];

  @override
  void initState() {
    super.initState();
    idselectedPayment = widget.initialPaymentId;

    if (idselectedPayment == 195) { 
      _contado = true;
      _credito = false;
      _importeGuardado = widget.initialImport;
    } else if (idselectedPayment == 17) { 
      _credito = true;
      _contado = false;
      _cuotasCredito = widget.initialCuotas ?? [];
    }
  }

  List<Cuota> get cuotasCredito => _cuotasCredito;
  List<PagoMixto> get pagosMixtos => _pagosMixto;

  int get selectedPaymentId {
    if (_contado) return 195;
    if (_credito) return 17;
    return 0;
  }

  Map<String, dynamic> getPaymentData() {
    return {
      'cuotas': _cuotasCredito,
      'pagosMixtos': _pagosMixto,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, products, _) {
        final selectedProducts = products.selectedProducts;

        double total = selectedProducts.fold(
          0.0,
          (total, item) => total + (
            (item.currentPrice ?? item.product.price) * item.quantity
          ),
        );

        final bool haySeleccion = _credito || _contado;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text('Modalidad de Pago', style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contado
                _buildOptionCheckbox('CONTADO', _contado, (value) {
                  setState(() {
                    _contado = value!;
                    if (_contado) _credito = false;
                  });
                }),
                SizedBox(height: 10),

                // Crédito
                _buildOptionCheckbox('CRÉDITO', _credito, (value) {
                  setState(() {
                    _credito = value!;
                    if (_credito) _contado = false;
                  });
                }),
                const SizedBox(height: 15),

                // Botón Registrar Pago
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: haySeleccion
                            ? () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    if (_contado) {
                                      _cuotasCredito = [];
                                      return RegistrarPagoContado(
                                        importeInicial: _importeGuardado,
                                        saldoInicial: _saldoGuardado,
                                        total: total,
                                        onGuardar: (importe, saldo) {
                                          setState(() {
                                            _importeGuardado = importe;
                                            _saldoGuardado = saldo;
                                            _pagosMixto = [
                                              PagoMixto(
                                                id: 195,
                                                monto: importe,
                                                numeroOperacion: '0000-0000',
                                              ),
                                            ];
                                          });
                                        },
                                      );
                                    }

                                    if (_credito) {
                                      _pagosMixto = [];
                                      return RegistrarPagoCredito(
                                        total: total,
                                        initialCuotas: _cuotasCredito,
                                        onGuardar: (cuotasList) {
                                          setState(() {
                                            _cuotasCredito = cuotasList;
                                          });
                                        },
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: haySeleccion
                              ? AppColors.orange
                              : Colors.white,
                          foregroundColor: haySeleccion
                              ? Colors.white
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40),
                        ),
                        child: Text(
                          'Registrar Pago',
                          style: AppTextStyles.btnPayment(haySeleccion),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _buildOptionCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return SizedBox(
      height: 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.vars),
          Transform.scale(
            scale: 0.9,
            child: Checkbox(
              visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
              activeColor: AppColors.gris,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrarPagoContado extends StatefulWidget {
  final void Function(double importe, double saldo) onGuardar;
  final double? importeInicial;
  final double? saldoInicial;
  final double total;

  const RegistrarPagoContado({
    super.key,
    required this.onGuardar,
    this.importeInicial,
    this.saldoInicial,
    required this.total,
  });

  @override
  State<RegistrarPagoContado> createState() => _RegistrarPagoContadoState();
}

class _RegistrarPagoContadoState extends State<RegistrarPagoContado> {
  late final TextEditingController _importeController;
  late final TextEditingController _saldoController;
  
  @override
  void initState() {
    super.initState();
    _importeController = TextEditingController(
      text: widget.importeInicial != null ? widget.importeInicial.toString() : ''
    );
    _saldoController = TextEditingController();

    _importeController.addListener(_updateSaldo);
    _updateSaldo();
  }

  void _updateSaldo() {
    final importe = double.tryParse(_importeController.text) ?? 0.0;
    final saldo = widget.total - importe;
    _saldoController.text = saldo.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _importeController.removeListener(_updateSaldo);
    _importeController.dispose();
    _saldoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Registro de Pago', style: AppTextStyles.titlePayment),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Importe:', style: AppTextStyles.vars),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _importeController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightGris,
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                    style: AppTextStyles.controllers,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Saldo:', style: AppTextStyles.vars),
                const SizedBox(width: 26),
                Expanded(
                  child: TextField(
                    controller: _saldoController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightGris,
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                    style: AppTextStyles.controllers,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: AppColors.gris),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    final importeText = _importeController.text.trim();
                    final saldoText = _saldoController.text.trim();

                    if (importeText.isEmpty || saldoText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, completa todos los campos.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    widget.onGuardar( 
                      double.tryParse(_importeController.text) ?? 0.0,
                      double.tryParse(_saldoController.text) ?? 0.0,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Guardar', style: AppTextStyles.btnSave),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
}

class RegistrarPagoCredito extends StatefulWidget {
  final void Function(List<Cuota> cuotas) onGuardar;
  final double total;

  final List<Cuota>? initialCuotas;

  const RegistrarPagoCredito({
    super.key,
    required this.onGuardar,
    required this.total,
    this.initialCuotas,
  });

  @override
  State<RegistrarPagoCredito> createState() => _RegistrarPagoCreditoState();
}

class _RegistrarPagoCreditoState extends State<RegistrarPagoCredito> {
  late TextEditingController _cuotasController;
  final List<TextEditingController> _montosControllers = [];
  final List<DateTime?> _fechas = [];

  double _montoRestante = 0.0;

  @override
  void initState() {
    super.initState();
    _cuotasController = TextEditingController(
      text: widget.initialCuotas?.toString() ?? '',
    );

    if (widget.initialCuotas != null && widget.initialCuotas!.isNotEmpty) {
      _cuotasController = TextEditingController(
        text: widget.initialCuotas!.length.toString(),
      );

      for (final cuota in widget.initialCuotas!) {
        final controller = TextEditingController(
          text: cuota.monto?.toStringAsFixed(2) ?? '',
        );
        controller.addListener(_recalcularMontoRestante);
        _montosControllers.add(controller);
        _fechas.add(cuota.fecha);
      }
    } else {
      _cuotasController = TextEditingController();
    }

    _recalcularMontoRestante();
  }

  void _recalcularMontoRestante() {
    final suma = _montosControllers.fold<double>(
      0.0,
      (prev, ctrl) => prev + (double.tryParse(ctrl.text.trim()) ?? 0.0),
    );
    setState(() {
      _montoRestante = widget.total - suma;
    });
  }

  void _actualizarCantidadCuotas(String value) {
    final cantidad = int.tryParse(value) ?? 0;

    setState(() {
      _montosControllers
        ..clear()
        ..addAll(List.generate(cantidad, (_) {
          final controller = TextEditingController();
          controller.addListener(_recalcularMontoRestante);
          return controller;
      }));
      _fechas
        ..clear()
        ..addAll(List.generate(cantidad, (_) => null));
    });
  }

  Future<void> _seleccionarFecha(int index) async {
    final seleccion = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (seleccion != null) {
      setState(() {
        _fechas[index] = seleccion;
      });
    }
  }

  @override
  void dispose() {
    _cuotasController.dispose();
    for (var c in _montosControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Registro de Cuotas', style: AppTextStyles.titlePayment),
              const SizedBox(height: 20),
              TextField(
                controller: _cuotasController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de Cuotas',
                  labelStyle: AppTextStyles.controllers,
                  filled: true,
                  fillColor: AppColors.lightGris,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _actualizarCantidadCuotas,
                style: AppTextStyles.base,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _montosControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _montosControllers[index],
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Monto cuota ${index + 1}',
                              labelStyle: AppTextStyles.controllers,
                              filled: true,
                              fillColor: AppColors.lightGris,
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                            style: AppTextStyles.base,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () => _seleccionarFecha(index),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Fecha',
                                labelStyle: AppTextStyles.base,
                                filled: true,
                                fillColor: AppColors.lightGris,
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              child: Text(
                                _fechas[index] != null
                                    ? DateFormat('dd/MM/yyyy').format(_fechas[index]!)
                                    : 'Seleccionar',
                                style: AppTextStyles.controllers,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total del pedido: S/ ${widget.total.toStringAsFixed(2)}',
                    style: AppTextStyles.controllers,
                  ),
                  Text(
                    'Monto asignado: S/ ${(widget.total - _montoRestante).toStringAsFixed(2)}',
                    style: AppTextStyles.controllers,
                  ),
                  Text(
                    'Restante: S/ ${_montoRestante.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: _montoRestante == 0.0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: AppColors.gris),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      final cuotas = <Cuota>[];
                      for (int i = 0; i < _montosControllers.length; i++) {
                        final monto = double.tryParse(_montosControllers[i].text.trim());
                        final fecha = _fechas[i];
                        if (monto == null || fecha == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Completa todos los campos de cuotas'),
                              backgroundColor: Colors.black,
                            ),
                          );
                          return;
                        }
                        cuotas.add(Cuota(monto: monto, fecha: fecha));
                      }

                      if (cuotas.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Debes ingresar al menos una cuota para crédito'),
                            backgroundColor: AppColors.gris,
                          ),
                        );
                        return;
                      }

                      widget.onGuardar(cuotas);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text('Guardar', style: AppTextStyles.btnSave),
                  ),
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}


class observations extends StatefulWidget  {
  final String? initialDeliveryLocation;
  final DateTime? initialDeliveryDate;
  final TimeOfDay? initialDeliveryTime;
  final String? initialAdditionalInformation;
  final bool? habilitar;
  
  const observations({super.key, this.initialDeliveryLocation, this.initialDeliveryDate, this.initialDeliveryTime, this.initialAdditionalInformation, this.habilitar = true});

  @override
  State<observations> createState() => ObservationsState();
}

class ObservationsState extends State<observations> {
  final deliveryLocation = TextEditingController();
  final _deliveryDate = TextEditingController();
  final _deliveryTime = TextEditingController();
  final _additionalInfo = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialDeliveryTime != null) {
      final hour = widget.initialDeliveryTime!.hour.toString().padLeft(2, '0');
      final minute = widget.initialDeliveryTime!.minute.toString().padLeft(2, '0');
      _deliveryTime.text = "$hour:$minute";
    } else {
      _deliveryTime.text = "";
    }

    deliveryLocation.text = widget.initialDeliveryLocation ?? "";
    if (widget.initialDeliveryDate != null) {
      _deliveryDate.text = DateFormat('yyyy-MM-dd').format(widget.initialDeliveryDate!);
    } else {
      _deliveryDate.text = "";
    }
    _additionalInfo.text = widget.initialAdditionalInformation ?? "";
  }
  
  @override
  void dispose() {
    deliveryLocation.dispose();
    _deliveryDate.dispose();
    _deliveryTime.dispose();
    _additionalInfo.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      _deliveryDate.text = formattedDate;
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // final String formattedTime = picked.format(context); // Devuelve '4:00 PM'
      
      // Formato 24 horas (04:00, 17:30):
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      _deliveryTime.text = '$hour:$minute';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('OBSERVACIONES', style: AppTextStyles.obs),
        const SizedBox(height: 20),
        Container(
          width: double.infinity, 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: AppColors.backgris,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Lugar de Entrega:', style: AppTextStyles.vars),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: deliveryLocation,
                        decoration: InputDecoration(
                          isDense: true,
                          enabled: widget.habilitar!,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGris),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGris, width: 2),
                          ),
                        ),
                        style: AppTextStyles.controllers
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Fecha de Entrega:', style: AppTextStyles.vars),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: _deliveryDate,
                        enabled: widget.habilitar,
                        onTap: _selectDate,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGris),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGris, width: 2),
                          ),
                        ),
                        style: AppTextStyles.controllers
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Hora de Entrega:', style: AppTextStyles.vars),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: _deliveryTime,
                        enabled: widget.habilitar,
                        onTap: _selectTime,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGris),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGris, width: 2),
                          ),
                        ),
                        style: AppTextStyles.controllers
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Información Adicional:', style: AppTextStyles.vars),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: _additionalInfo,
                        maxLines: 2,
                        minLines: 2,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabled: widget.habilitar!,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGris),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGris, width: 2),
                          ),
                        ),
                        style: AppTextStyles.controllers
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  Map<String, String> getObservations() {
    return {
      "place": deliveryLocation.text,
      "date": _deliveryDate.text,
      "time": _deliveryTime.text,
      "info": _additionalInfo.text,
    };
  }
}

class buttonRegisterOrder extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEdit;

  const buttonRegisterOrder({
    required this.onPressed,
    this.isEdit = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isEdit ? 'ACTUALIZAR PEDIDO' : 'REGISTRAR PEDIDO',
              style: AppTextStyles.btnSave,
            ),
          ),
        ),
      ],
    );
  }
}

Future<bool> registerOrder({
  bool? editOrder,
  int? idOrder,
  required BuildContext context,
  int? idCustomer,
  required GlobalKey<ObservationsState> observationsKey,
  required GlobalKey<PaymentMethodState> paymentKey,
  required GlobalKey<ReceiptTypeState> receiptKey,
  required VoidCallback resetForm,
}) async {
  final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
  final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
  final token = Provider.of<UsersProvider>(context, listen: false).token;
  final customersProvider = Provider.of<CustomersProvider>(context, listen: false);

  final selectedProducts = productsProvider.selectedProducts;
  final obs = observationsKey.currentState!.getObservations();
  final payment = paymentKey.currentState!.selectedPaymentId;
  final receipt = receiptKey.currentState!.selectedReceiptId;
  final cuotas = paymentKey.currentState?.cuotasCredito ?? [];
  final pagosMixtos = paymentKey.currentState?.pagosMixtos ?? [];

  double total = 0.0;
  double subtotal = 0.0;
  double igv = 0.0;

  for (var item in selectedProducts) {
    final qtyText = item.controller.text.replaceAll(',', '.');
    item.quantity = double.tryParse(qtyText) ?? 0.0;

    final priceText = item.priceController.text.replaceAll(',', '.');
    item.currentPrice = double.tryParse(priceText) ?? item.product.price;
  }

  final details = selectedProducts.map((item) {
    final double unitPrice = item.currentPrice ?? item.product.price;
    final double itemTotalPrice = unitPrice * item.quantity;

    double baseImponible = (item.product.igvType == 14)
        ? itemTotalPrice / 1.18
        : itemTotalPrice;
    double impuesto = itemTotalPrice - baseImponible;

    igv += impuesto;
    subtotal += itemTotalPrice - impuesto;
    total += itemTotalPrice;

    return OrderDetail(
      idProduct: item.product.idProduct,
      descripcionItem: item.product.productName,
      unitPrice: unitPrice,
      quantity: item.quantity,
      importeNeto: itemTotalPrice,
      tipoIgv: item.product.igvType == 14 ? 1 : 0,
      detalleItem: "",
      idUnidadMedida: 1,
    );
  }).toList();

  DateTime? _tryParseDate(dynamic date) {
    if (date is String && date.isNotEmpty) {
      try {
        return DateTime.parse(date);
      } catch (_) {
        print('Formato de fecha inválido: $date');
      }
    }
    return null;
  }

  TimeOfDay? _tryParseTimeOfDay(dynamic time) {
    if (time is String && time.contains(":")) {
      try {
        final parts = time.split(":");
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (_) {
        print('Formato de hora inválido: $time');
      }
    }
    return null;
  }

  final List<Customer> customers = customersProvider.customers;
  final cliente = customers.firstWhere(
    (c) => c.idCliente == idCustomer,
    orElse: () => Customer(
      idCliente: 0, nombres: 'Desconocido', apellidos: '', idDocumento: 0,
      nroDocumento: '', fechaNacimiento: '', nombreTipoDoc: '', idListaPrecio: 0,
      nombreListaPrecio: '', estado: 0, fechaCreado: '', fotoPerfil: '', label: '',
      value: 0, idDatosPersona: 0, correo: '', numero: '', ubigeo: '', direccion: '',
      idCorreo: 0, idDireccion: 0, idTelefono: 0, idDatoGeneral: 0,
      rucAfiliada: '', razonSocialAfiliada: '', direccionAfiliada: ''
    ),
  );
  
  final order = Order(
    idOrder: idOrder ?? null,
    idTipoDocumento: receipt,
    idMoneda: 12,
    idPaymentMethod: payment,
    idTipoVenta: 142,
    fechaEmision: DateTime.now(),
    fechaRegistro: DateTime.now(),
    idCustomer: idCustomer!,
    idSucursal: 1,
    idMotivoNota: 70,
    idMotivoNotaDebito: 197,
    nroOperacion: "",
    serieModifica: "",
    nroModifica: "",
    dateModifica: null,
    baseImponible: double.parse(subtotal.toStringAsFixed(2)),
    totalExonerado: 0,
    totalIgv: double.parse(igv.toStringAsFixed(2)),
    total: double.parse(total.toStringAsFixed(2)),
    detraccion: "",
    idTipoDetraccion: 122,
    porcentajeDetraccion: 0.0,
    totalDetraccion: 0,
    idTipoRetencion: 137,
    totalRetencion: 0,
    state: 2,
    direccionClienteVenta: cliente.direccion,
    tipoCambio: 1,
    observaciones: "",
    deliveryLocation: obs['place'] ?? '',
    deliveryDate: _tryParseDate(obs['date']),
    deliveryTime: _tryParseTimeOfDay(obs['time']),
    additionalInformation: obs['info'] ?? '',
    details: details,
    cliente: cliente.nombres,
    cuotas: cuotas,
    pagosMixtos: pagosMixtos,
  );

  final confirm = await showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        editOrder == true ? "Confirmar actualización" : "Confirmar pedido",
        style: AppTextStyles.historyTitle,
      ),
      content: Text(
        editOrder == true
            ? "¿Estás seguro de que deseas actualizar este pedido?"
            : "¿Estás seguro de que deseas registrar este pedido?",
        style: AppTextStyles.priceData,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancelar", style: AppTextStyles.btnCancelar),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            editOrder == true ? "Actualizar" : "Registrar",
            style: AppTextStyles.btnSave,
          ),
        ),
      ],
    ),
  );

  if (confirm != true) return false;

  try {
    if (editOrder == true) {
      await ordersProvider.updateOrder(order, token!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pedido actualizado correctamente")),
        );
      }
    } else {
      await ordersProvider.registerOrder(order, token!);
      resetForm();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pedido registrado correctamente")),
        );
      }
    }
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(editOrder == true
              ? "Error al actualizar pedido"
              : "Error al registrar pedido"),
        ),
      );
    }
    return false;
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 11,
    color: AppColors.gris
  );
  static final subtitle = base.copyWith(fontSize: 12, color: Colors.black);
  static final catalog = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);
  static final searchproduct = base.copyWith(fontSize: 10, fontWeight: FontWeight.w300);
  static final productinfo = base.copyWith();
  static final tableHead = base.copyWith();
  static final tableData = base.copyWith(fontWeight: FontWeight.w300);
  static final tableTotal = base.copyWith(fontWeight: FontWeight.w500,);
  static final vars = base.copyWith(fontSize: 12, fontWeight: FontWeight.w300);
  static final titlePayment = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final btnSave = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white);
  static final controllers = base.copyWith(fontSize: 12, fontWeight: FontWeight.w300);
  static final obs = base.copyWith(fontSize: 16, color: Colors.black);
  static final historyTitle = base.copyWith(fontSize: 16, fontWeight: FontWeight.w500);
  static final historyHead = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final priceData = base.copyWith(fontSize: 13, fontWeight: FontWeight.w300);
  static final btnCancelar = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.orange);
  static final btnPrice = base.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.orange);
  static TextStyle btnPayment(bool haySeleccion) {
    return base.copyWith(
      fontSize: 14, fontWeight: FontWeight.w300, color: haySeleccion ? Colors.white : Color(0xFFFF6600),
    );
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const grisMessage = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
  static const lightGris = Color(0xFFBDBDBD);
}