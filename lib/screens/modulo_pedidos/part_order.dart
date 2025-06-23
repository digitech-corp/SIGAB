import 'package:balanced_foods/models/cuota.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/orderDetail.dart';
import 'package:balanced_foods/models/paymentInfo.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/screens/modulo_pedidos/product_catalog_screen.dart';
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
  const SearchProduct({super.key, required this.idCustomer});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
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
                  height: 25,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: TextFormField(
                          controller: selection.controller,
                          enabled: selection.isSelected,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                            border: UnderlineInputBorder(),
                          ),
                          style: AppTextStyles.searchproduct,
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
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 200,
                        child: Text(product.productName, style: AppTextStyles.productinfo),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text('${product.price.toStringAsFixed(2)}', style: AppTextStyles.productinfo),
                      ),
                      SizedBox(
                        width: 30,
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
      (total, item) => total + (item.product.price * item.quantity),
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: Text('${selection.quantity.toString().padLeft(2, '0')}', style: AppTextStyles.tableData)),
            Expanded(flex: 3, child: Text(selection.product.productName, style: AppTextStyles.tableData)),
            Expanded(flex: 1, child: Text('S50', style: AppTextStyles.tableData)),
            Expanded(flex: 1, child: Text(selection.product.productType, style: AppTextStyles.tableData)),
            Expanded(flex: 1, child: Text('${selection.product.price.toStringAsFixed(2)}', style: AppTextStyles.tableData, textAlign: TextAlign.right)),
            Expanded(flex: 1, child: Text('${(selection.product.price * selection.quantity).toStringAsFixed(2)}', style: AppTextStyles.tableData, textAlign: TextAlign.right)),
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
  const receiptType({super.key});

  @override
  State<receiptType> createState() => ReceiptTypeState();
}

class ReceiptTypeState extends State<receiptType> {
  bool _otros = false;
  bool _factura = false;
  bool _boleta = false;

  String get selectedReceiptType {
    if (_otros) return "OTROS/N.V.";
    if (_factura) return "FACTURA";
    if (_boleta) return "BOLETA";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 25,
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: _otros, 
                  activeColor: AppColors.gris,
                  checkColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _otros = value!;
                      if (_otros) 
                        _factura = false; 
                        _boleta = false;
                    });
                  },
                ),
              ),
            ),
            Text('OTROS/N.V.', style: AppTextStyles.vars),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 25,
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: _factura, 
                  activeColor: AppColors.gris,
                  checkColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _factura = value!;
                      if (_factura) 
                        _otros = false; 
                        _boleta = false;
                    });
                  },
                ),
              ),
            ),
            Text('FACTURA', style: AppTextStyles.vars),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 25,
              child: Transform.scale(
                scale: 0.8,
                child: Checkbox(
                  value: _boleta, 
                  activeColor: AppColors.gris,
                  checkColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      _boleta = value!;
                      if (_boleta) 
                        _otros = false;
                        _factura = false;
                    });
                  },
                ),
              ),
            ),
            Text('BOLETA DE VENTA', style: AppTextStyles.vars),
          ],
        ),
      ],
    );
  }
}

class paymentMethod extends StatefulWidget {
  const paymentMethod({super.key});

  @override
  State<paymentMethod> createState() => PaymentMethodState();
}

class PaymentMethodState extends State<paymentMethod> {
  bool _contado = false;
  bool _credito = false;
  double? _importeGuardado;
  double? _saldoGuardado;
  int? _cuotasGuardadas;
  double? _montoGuardado;
  DateTime? _fechaGuardada;
  PaymentInfo? paymentInfo;
  
  String get selectedPaymentMethod {
    if (_contado) return "CONTADO";
    if (_credito) return "CRÉDITO";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final bool haySeleccion = _credito || _contado;
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final selectedProducts = products.selectedProducts;
    final total = selectedProducts.fold(
      0.0,
      (total, item) => total + (item.product.price * item.quantity),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text('Modalidad de Pago', style: AppTextStyles.subtitle),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CONTADO', style: AppTextStyles.vars),
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                      activeColor: AppColors.gris,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: _contado,
                      onChanged: (value) {
                        setState(() {
                          _contado = value!;
                          if (_contado) _credito = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CRÉDITO', style: AppTextStyles.vars),
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                      activeColor: AppColors.gris,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: _credito,
                      onChanged: (value) {
                        setState(() {
                          _credito = value!;
                          if (_credito) _contado = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
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
                            builder: (context) {
                              if (_contado) {
                                _cuotasGuardadas = null;
                                _montoGuardado = null;
                                _fechaGuardada = null;
                                return RegistrarPagoContado(
                                  importeInicial: _importeGuardado,
                                  saldoInicial: _saldoGuardado,
                                  total: total,
                                  onGuardar: (importe, saldo) {
                                    setState(() {
                                      _importeGuardado = importe;
                                      _saldoGuardado = saldo;
                                      paymentInfo = ContadoPaymentInfo(
                                        importe: importe,
                                        saldo: saldo,
                                      );
                                    });
                                  },
                                );
                              }
                              if (_credito) {
                                _importeGuardado = null;
                                _saldoGuardado = null;
                                return RegistrarPagoCredito(
                                  total: total,
                                  onGuardar: (cuotasList) {
                                    setState(() {
                                      _cuotasGuardadas = cuotasList.length;
                                      final totalCuotas = cuotasList.fold(0.0, (suma, c) => suma + c.monto);
                                      _montoGuardado = totalCuotas;
                                      _fechaGuardada = cuotasList.first.fecha;

                                      paymentInfo = CreditoPaymentInfo(
                                        cuotas: cuotasList
                                      );
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
                    child: Text('Registrar Pago', style: AppTextStyles.btnPayment(haySeleccion)),
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
  
  // Map<String, String> getPayments() {
  //   return {
  //     "importe": _importeGuardado.toString(),
  //     "saldo": _saldoGuardado.toString(),
  //     "cuota": _cuotasGuardadas.toString(),
  //     "monto": _montoGuardado.toString(),
  //     "fecha": _fechaGuardada.toString(),
  //   };
  // }
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrarPagoCredito extends StatefulWidget {
  final void Function(List<Cuota> cuotas) onGuardar;
  final double total;

  const RegistrarPagoCredito({
    super.key,
    required this.onGuardar,
    required this.total,
  });

  @override
  State<RegistrarPagoCredito> createState() => _RegistrarPagoCreditoState();
}

class _RegistrarPagoCreditoState extends State<RegistrarPagoCredito> {
  final TextEditingController _cuotasController = TextEditingController();
  final List<TextEditingController> _montosControllers = [];
  final List<DateTime?> _fechas = [];

  double _montoRestante = 0.0;
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
      firstDate: DateTime(2020),
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
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    cuotas.add(Cuota(monto: monto, fecha: fecha));
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
            ],
          ),
        ),
      ),
    );
  }
}


class observations extends StatefulWidget  {
  const observations({super.key});

  @override
  State<observations> createState() => ObservationsState();
}

class ObservationsState extends State<observations> {
  final deliveryLocation = TextEditingController();
  final _deliveryDate = TextEditingController();
  final _deliveryTime = TextEditingController();
  final _additionalInfo = TextEditingController();
  
  @override
  void dispose() {
    deliveryLocation.dispose();
    _deliveryDate.dispose();
    _deliveryTime.dispose();
    _additionalInfo.dispose();
    super.dispose();
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

  const buttonRegisterOrder({
    required this.onPressed,
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
            child: Text('REGISTRAR PEDIDO', style: AppTextStyles.btnSave),
          ),
        ),
      ],
    );
  }
}

Future<void> registerOrder({
  required BuildContext context,
  int? idCustomer,
  required GlobalKey<ObservationsState> observationsKey,
  required GlobalKey<PaymentMethodState> paymentKey,
  required GlobalKey<ReceiptTypeState> receiptKey,
  required GlobalKey<PaymentMethodState> paymentInfoKey,
  required VoidCallback resetForm,
  // PaymentInfo? paymentInfo,
}) async {
  final provider = Provider.of<OrdersProvider>(context, listen: false);
  final products = Provider.of<ProductsProvider>(context, listen: false);
  final selectedProducts = products.selectedProducts;

  final obs = observationsKey.currentState!.getObservations();
  final payment = paymentKey.currentState!.selectedPaymentMethod;
  final receipt = receiptKey.currentState!.selectedReceiptType;
  final paymentInfo = paymentKey.currentState!.paymentInfo;
  
  double total = selectedProducts.fold(
    0.0,
    (total, item) => total + (item.product.price * item.quantity),
  );

  double subtotal = total / 1.18;
  double igv = total - subtotal;

  final details = selectedProducts.map((item) {
    return OrderDetail(
      idProducto: item.product.idProduct,
      quantity: item.quantity,
      unitPrice: item.product.price,
      partialPrice: item.quantity * item.product.price,
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
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      } catch (_) {
        print('Formato de hora inválido: $time');
      }
    }
    return null;
  }

  final order = Order(
    idCustomer: idCustomer!,
    paymentMethod: payment,
    receiptType: receipt,
    subtotal: subtotal,
    igv: igv,
    total: total,
    deliveryLocation: obs['place'] ?? '',
    deliveryDate: _tryParseDate(obs['date']),
    deliveryTime: _tryParseTimeOfDay(obs['time']),
    additionalInformation: obs['info'] ?? '',
    details: details,
    paymentInfo: paymentInfo,
    state: 'Pendiente',
    paymentState: "Pendiente",
    dateCreated: DateTime.now(),
    timeCreated: TimeOfDay.now(),
  );

  final success = await provider.registerOrder(order);

  if (success) {
    resetForm();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pedido registrado correctamente")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al registrar pedido")),
    );
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
  static TextStyle btnPayment(bool haySeleccion) {
    return base.copyWith(
      fontSize: 14, fontWeight: FontWeight.w300, color: haySeleccion ? Colors.white : Color(0xFFFF6600),
    );
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
  static const lightGris = Color(0xFFBDBDBD);
}