import 'dart:ffi';

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
                Text(
                  'Selección de Productos',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black
                  ),
                ),
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
                  child: Text(
                    'Ver Catálogo',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                    ),
                  ),
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
    
    // Asegúrate de tener un ProductSelection por cada producto
    final filteredSelections = allProducts.where((product) {
      return product.productName.toLowerCase().contains(_searchText.toLowerCase()) ||
            product.idProduct.toString().contains(_searchText);
    }).map((product) {
      // Si no está en el mapa, lo creas en ese momento (sin seleccionarlo aún)
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
                    hintStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFECEFF1),
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
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_searchText.isNotEmpty)
          SizedBox(
            height: 200, // puedes ajustar esto
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
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
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
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 200,
                        child: Text(
                          product.productName,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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
                              selection.isSelected ? const Color(0xFF333333) : Colors.white,
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
    const style = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: Color(0xFF333333),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(flex: 1, child: Text('Cant.', style: style)),
        Expanded(flex: 3, child: Text('Nombre del Producto', style: style)),
        Expanded(flex: 1, child: Text('Pres', style: style)),
        Expanded(flex: 1, child: Text('Tipo', style: style)),
        Expanded(flex: 1, child: Text('Precio', style: style, textAlign: TextAlign.right)),
        Expanded(flex: 1, child: Text('Parcial', style: style, textAlign: TextAlign.right)),
      ],
    );
  }

  Widget _buildProductList() {
    const style = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 11,
      fontWeight: FontWeight.w300,
      color: Color(0xFF333333),
    );
    return ListView.builder(
      itemCount: selectedProducts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final selection = selectedProducts[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 1, child: Text('${selection.quantity.toString().padLeft(2, '0')}', style: style)),
            Expanded(flex: 3, child: Text(selection.product.productName, style: style)),
            Expanded(flex: 1, child: Text('S50', style: style)), // Aquí puedes ajustar 'Pres' si tienes ese dato
            Expanded(flex: 1, child: Text(selection.product.productType, style: style)),
            Expanded(flex: 1, child: Text('${selection.product.price.toStringAsFixed(2)}', style: style, textAlign: TextAlign.right)),
            Expanded(flex: 1, child: Text('${(selection.product.price * selection.quantity).toStringAsFixed(2)}', style: style, textAlign: TextAlign.right)),
          ],
        );
      },
    );
  }

  Widget _buildTotalSection(double subtotal, double igv, double total) {
    const labelStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 11,
      fontWeight: FontWeight.w300,
      color: Color(0xFF333333),
    );
    const totalStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: Color(0xFF333333),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text('SubTotal', style: labelStyle),
            Text('I.G.V.', style: labelStyle),
            Text('TOTAL', style: totalStyle),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(subtotal.toStringAsFixed(2), style: labelStyle),
            Text(igv.toStringAsFixed(2), style: labelStyle),
            Text(total.toStringAsFixed(2), style: totalStyle),
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
                  activeColor: Color(0xFF333333),
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
            Text(
              'OTROS/N.V.',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            ),
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
                  activeColor: Color(0xFF333333),
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
            Text(
              'FACTURA',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            ),
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
                  activeColor: Color(0xFF333333),
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
            Text(
              'BOLETA DE VENTA',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Modalidad de Pago',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF333333)
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CONTADO',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                      activeColor: Color(0xFF333333),
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
                  Text(
                    'CRÉDITO',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.9,
                    child: Checkbox(
                      visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                      activeColor: Color(0xFF333333),
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
                                _cuotasGuardadas = 0;
                                _montoGuardado = 0.0;
                                _fechaGuardada = null;
                                return RegistrarPagoContado(
                                  importeInicial: _importeGuardado,
                                  saldoInicial: _saldoGuardado,
                                  onGuardar: (importe, saldo) {
                                    setState(() {
                                      _importeGuardado = importe;
                                      _saldoGuardado = saldo;
                                      paymentInfo = ContadoPaymentInfo(
                                        importe: importe,
                                        saldo: saldo,
                                      );
                                    });
                                    print('Pago guardado');
                                  },
                                );
                              }
                              if (_credito) {
                                _importeGuardado = 0.0;
                                _saldoGuardado = 0.0;
                                return RegistrarPagoCredito(
                                  cuotasInicial: _cuotasGuardadas,
                                  montoInicial: _montoGuardado,
                                  fechaInicial: _fechaGuardada,
                                  onGuardar: (cuotas, monto, fecha) {
                                    setState(() {
                                      _cuotasGuardadas = cuotas;
                                      _montoGuardado = monto;
                                      _fechaGuardada = fecha;
                                      paymentInfo = CreditoPaymentInfo(
                                        numeroCuotas: cuotas,
                                        monto: monto,
                                        fechaPago: fecha!,
                                      );
                                    });
                                    print('Pago guardado');
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
                      ? Color(0xFFFF6600)
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
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: haySeleccion
                        ? Colors.white
                        : Color(0xFFFF6600),
                      ),
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
  
  Map<String, String> getPayments() {
    return {
      "importe": _importeGuardado.toString(),
      "saldo": _saldoGuardado.toString(),
      "cuota": _cuotasGuardadas.toString(),
      "monto": _montoGuardado.toString(),
      "fecha": _fechaGuardada.toString(),
    };
  }
}

class RegistrarPagoContado extends StatefulWidget {
  final void Function(double importe, double saldo) onGuardar;
  final double? importeInicial;
  final double? saldoInicial;

  const RegistrarPagoContado({
    super.key,
    required this.onGuardar,
    this.importeInicial,
    this.saldoInicial,
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
    _importeController = TextEditingController(text: widget.importeInicial.toString());
    _saldoController = TextEditingController(text: widget.saldoInicial.toString());
  }

  @override
  void dispose() {
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
            const Center(
              child: Text(
                'Registro de Pago',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Importe:'),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _importeController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
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
                const Text('Saldo:'),
                const SizedBox(width: 26),
                Expanded(
                  child: TextField(
                    controller: _saldoController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
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
                  widget.onGuardar(
                    double.tryParse(_importeController.text) ?? 0.0,
                    double.tryParse(_saldoController.text) ?? 0.0,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6600),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrarPagoCredito extends StatefulWidget {
  final void Function(int cuotas, double monto, DateTime fecha) onGuardar;

  final int? cuotasInicial;
  final double? montoInicial;
  final DateTime? fechaInicial;

  const RegistrarPagoCredito({
    super.key,
    required this.onGuardar,
    this.cuotasInicial,
    this.montoInicial,
    this.fechaInicial,
  });

  @override
  State<RegistrarPagoCredito> createState() => _RegistrarPagoCreditoState();
}

class _RegistrarPagoCreditoState extends State<RegistrarPagoCredito> {
  late final TextEditingController _cuotasController;
  late final TextEditingController _montoController;
  late final TextEditingController _fechaController;

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada != null) {
      final String fechaFormateada = DateFormat('dd/MM/yyyy').format(fechaSeleccionada);
      setState(() {
        _fechaController.text = fechaFormateada;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cuotasController = TextEditingController(text: widget.cuotasInicial.toString());
    _montoController = TextEditingController(text: widget.montoInicial.toString());
    _fechaController = TextEditingController(text: widget.fechaInicial.toString());
  }

  @override
  void dispose() {
    _cuotasController.dispose();
    _montoController.dispose();
    _fechaController.dispose();
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
            const Center(
              child: Text(
                'Registro de Cuotas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(flex: 2, child: const Text('N° de Cuotas:')),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3, 
                  child: TextField(
                    controller: _cuotasController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(flex: 2, child: const Text('Monto:')),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _montoController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
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
                Expanded(flex: 2, child: const Text('Fecha de Pago:')),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _fechaController,
                    readOnly: true,
                    onTap: () => _seleccionarFecha(context),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFD9D9D9),
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onGuardar(
                    int.tryParse(_cuotasController.text) ?? 0,
                    double.tryParse(_montoController.text) ?? 0.0,
                    _fechaController.text.isNotEmpty
                        ? DateFormat('dd/MM/yyyy').parse(_fechaController.text)
                        : DateTime.now(),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6600),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
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
        Text(
          'OBSERVACIONES', 
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.black
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity, 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Color(0xFFECEFF1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Lugar de Entrega:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: deliveryLocation,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Fecha de Entrega:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: _deliveryDate,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Hora de Entrega:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: _deliveryTime,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 1),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Información Adicional:',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                      ),
                    ),
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
                            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2),
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: Colors.black,
                        ),
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
              backgroundColor: Color(0xFFFF6600),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'REGISTRAR PEDIDO',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
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
