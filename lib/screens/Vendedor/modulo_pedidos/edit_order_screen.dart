import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/opcionCatalogo.dart';
import 'package:balanced_foods/models/order.dart';
import 'package:balanced_foods/models/orderDetail.dart';
import 'package:balanced_foods/models/product.dart';
import 'package:balanced_foods/providers/configuraciones_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/part_order.dart';
import 'package:balanced_foods/screens/Vendedor/modulo_pedidos/product_catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditOrderScreen extends StatefulWidget {
  final Order order;
  const EditOrderScreen({super.key, required this.order});

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<OpcionCatalogo> documentosVenta = [];
  List<OpcionCatalogo> tiposPago = [];
  Customer? _selectedCustomer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      final documentosProvider = Provider.of<OpcionCatalogoProvider>(context, listen: false);
      final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final token = usersProvider.token;

      await productsProvider.fetchProducts(token!);
      await customersProvider.fetchCustomers(token);
      await documentosProvider.fetchOpcionesVenta(token);
      await ordersProvider.fetchPedidosClienteCompletos(token, widget.order.idCustomer!).then((_) {
        productsProvider.loadPriceHistory(widget.order.idCustomer!, ordersProvider);
      });

      final initialSelections = _mapOrderDetailsToSelections(
        widget.order.details!,
        productsProvider.products,
      ).values.toList();

      productsProvider.setSelectionsForCustomer(widget.order.idCustomer!, initialSelections);

      setState(() {
        _isLoading = false;
      });

      final clienteExistente = customersProvider.customers.firstWhere(
        (c) => c.idCliente == widget.order.idCustomer,
        orElse: () => Customer(idCliente: 0, nombres: '', apellidos: '', razonSocialAfiliada: '', idListaPrecio: 0, estado: 0, fotoPerfil: '', nroDocumento: '', fechaNacimiento: '', correo: '', numero: '', direccion: '', rucAfiliada: '', direccionAfiliada: ''),
      );
      if (clienteExistente.idCliente != 0) {
        setState(() {
          _selectedCustomer = clienteExistente;
        });
      }
    });
  }

  void _resetForm() {
    setState(() {
      _selectedCustomer = null;
      _searchController.clear();
    });

    final provider = Provider.of<ProductsProvider>(context, listen: false);
    provider.clearSelections();
  }

  Map<int, ProductSelection> _mapOrderDetailsToSelections(
    List<OrderDetail> details, 
    List<Product> products,
  ) {
    final Map<int, ProductSelection> selections = {};
    for (var detail in details) {
      final product = products.firstWhere(
        (p) => p.idProduct == detail.idProduct,
        orElse: () => Product(
          idProduct: detail.idProduct ?? 0,
          productName: "Producto no encontrado",
          price: detail.unitPrice,
          idAnimal: 0,
          animalType: '',
          productType: '',
          descripcion: '',
          unidadMedida: '',
          stockActualEmpresa: 0,
          state: 1,
        ),
      );

      final selection = ProductSelection(
        product: product,
        isSelected: true,
        quantity: detail.quantity,
        initialPrice: product.price,
        currentPrice: detail.unitPrice,
      );

      selection.priceController.text = detail.unitPrice.toStringAsFixed(2);

      selections[product.idProduct] = selection;
    }
    return selections;
  }

  final _observationsKey = GlobalKey<ObservationsState>();
  final _paymentKey = GlobalKey<PaymentMethodState>();
  final _receiptKey = GlobalKey<ReceiptTypeState>();

  @override
  Widget build(BuildContext context) {
    final documentsProvider = Provider.of<OpcionCatalogoProvider>(context);
    documentosVenta = documentsProvider.documentosVenta;
    tiposPago = documentsProvider.tipoPago;
    
    final tipoDocumento = documentsProvider.documentosVenta.firstWhere(
      (d) => d.nombre == widget.order.nombreTipoDocumento,
      orElse: () => OpcionCatalogo(id: 0, nombre: 'Desconocido', codigo: 0, tabla: '', valorAdicionalOpcional: '', ingresadoPor: ''),
    );
    return Scaffold(
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
                  onPressed: () async {
                    final confirmExit = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text('Descartar cambios', style: AppTextStyles.subtitlebtn),
                        content: Text('Se descartarán los cambios. ¿Estás seguro?', style: AppTextStyles.subtitle),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('NO', style: AppTextStyles.btn),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('SI', style: AppTextStyles.btn),
                          ),
                        ],
                      ),
                    );
                    if (confirmExit == true) {
                      _resetForm();
                      if (context.mounted) Navigator.pop(context, true);
                    }
                  },
                ),
                const SizedBox(width: 1),
                Text('Editar Pedido', style: AppTextStyles.title),
              ],
            ),
          ),
        ),
      ),

      body: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('CLIENTE', style: AppTextStyles.subtitle),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: AppColors.backgris,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: 25,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          hintText: 'Buscar Cliente/Empresa',
                          hintStyle: AppTextStyles.search,
                          filled: true,
                          enabled: false,
                          fillColor: AppColors.backgris,
                          prefixIcon: const Icon(Icons.search, size: 15, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    if (_selectedCustomer != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CLIENTE: ${_selectedCustomer!.nombres} ${_selectedCustomer!.apellidos}',
                                style: AppTextStyles.selection),
                            Text('EMPRESA: ${_selectedCustomer!.razonSocialAfiliada}', style: AppTextStyles.base),
                            const SizedBox(height: 10),
                            receiptType(
                              key: _receiptKey,
                              tiposComprobante: documentosVenta,
                              initialSelectedId: tipoDocumento.id,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text('CATÁLOGO', style: AppTextStyles.subtitle),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: AppColors.backgris,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _selectedCustomer != null
                          ? partOrder(idCustomer: _selectedCustomer!.idCliente!)
                          : partOrder(idCustomer: 0),
                    ),
                    const SizedBox(height: 10),
                    SearchProduct(
                      idCustomer: widget.order.idCustomer,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Text('RESUMEN DE PEDIDO', style: AppTextStyles.subtitle),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: AppColors.backgris,
                ),
                child: Consumer<ProductsProvider>(
                  builder: (context, provider, _) {
                    final selectedProducts = provider.selectionMap.values
                        .where((sel) => sel.isSelected && sel.quantity > 0)
                        .toList();

                    return ResumeProduct(
                      selectedProducts: selectedProducts,
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              Text('MODALIDAD DE PAGO', style: AppTextStyles.subtitle),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: AppColors.backgris,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: paymentMethod(
                    key: _paymentKey,
                    tiposPago: tiposPago,
                    initialPaymentId: widget.order.idPaymentMethod,
                    initialImport: widget.order.idPaymentMethod == 195 &&
                        widget.order.pagosMixtos != null &&
                        widget.order.pagosMixtos!.isNotEmpty
                      ? widget.order.pagosMixtos!.first.monto
                      : 0.0,
                    initialCuotas: widget.order.idPaymentMethod == 17
                      ? widget.order.cuotas
                      : null,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              observations(
                key: _observationsKey,
                initialDeliveryLocation: widget.order.deliveryLocation ?? '',
                initialDeliveryDate: widget.order.deliveryDate ?? null,
                initialDeliveryTime: widget.order.deliveryTime ?? null,
                initialAdditionalInformation: widget.order.additionalInformation ?? '',
                habilitar: false,
              ),

              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: buttonRegisterOrder(onPressed: _updateOrder, isEdit: true)),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _updateOrder() async {
    final idCustomer = _selectedCustomer?.idCliente;
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final selectedProducts = products.selectedProducts;

    if (idCustomer == null || selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final success = await registerOrder(
      idOrder: widget.order.idOrder,
      editOrder: true,
      context: context,
      idCustomer: idCustomer,
      receiptKey: _receiptKey,
      observationsKey: _observationsKey,
      paymentKey: _paymentKey,
      resetForm: _resetForm,
    );

    if (success && context.mounted) {
      Navigator.pop(context, true);
    }
  }
}


class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.gris
  );
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gris);
  static final search = base.copyWith(fontWeight: FontWeight.w300, fontSize: 10);
  static final selection = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final subtitle = base.copyWith(fontSize: 16);
  static final subtitlebtn = base.copyWith(fontSize: 16, fontWeight: FontWeight.w500);
  static final btnSave = base.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white);
  static final btnBack = base.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.orange);
  static final btn = base.copyWith(fontSize: 14, color: AppColors.orange, fontWeight: FontWeight.w500);
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
}