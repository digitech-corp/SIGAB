import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/screens/modulo_pedidos/part_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Customer> _filteredCustomers = [];
  Customer? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final companiesProvider = Provider.of<CompaniesProvider>(context, listen: false);
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

      productsProvider.fetchProducts();
      customersProvider.fetchCustomers();
      companiesProvider.fetchCompanies();
    });
  }

  void _resetForm() {
    setState(() {
      _selectedCustomer = null;
      _searchController.clear();
      _filteredCustomers = [];
    });

    final provider = Provider.of<ProductsProvider>(context, listen: false);
    provider.clearSelections();
  }

  final _observationsKey = GlobalKey<ObservationsState>();
  final _paymentKey = GlobalKey<PaymentMethodState>();
  final _receiptKey = GlobalKey<ReceiptTypeState>();

  @override
  Widget build(BuildContext context) {
    final customersProvider = Provider.of<CustomersProvider>(context);
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    
    void _applySearch() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        if (query.isEmpty) {
          _filteredCustomers = [];
        } else {
          _filteredCustomers = customersProvider.customers.where((customer) {
            final name = customer.customerName.toLowerCase();
            final companyName = companiesProvider.getCompanyNameById(customer.idCompany).toLowerCase();
            return name.contains(query) || companyName.contains(query);
          }).toList();
        }
      });
    }

    if (!_searchController.hasListeners) {
      _searchController.addListener(_applySearch);
    }
    
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 1),
                Text('Gestión de Pedidos', style: AppTextStyles.title),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('CLIENTE', style: AppTextStyles.base),
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
                          fillColor: AppColors.backgris,
                          prefixIcon: const Icon(Icons.search, size: 15, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredCustomers.length,
                        itemBuilder: (context, index) {
                          final customer = _filteredCustomers[index];
                          return ListTile(
                            dense: true,
                            title: Text(customer.customerName, style: AppTextStyles.base),
                            subtitle: Text(companiesProvider.getCompanyNameById(customer.idCompany), style: AppTextStyles.base),
                            onTap: () {
                              setState(() {
                                _selectedCustomer = customer;
                                _filteredCustomers = [];
                                _searchController.clear();
                              });

                              final productProvider = Provider.of<ProductsProvider>(context, listen: false);
                              productProvider.setCurrentCustomer(customer.idCustomer!);
                            },
                          );
                        },
                      ),
                    const SizedBox(height: 10),
                    if (_selectedCustomer != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('CLIENTE:', style: AppTextStyles.base),
                                    SizedBox(height: 2),
                                    Text('EMPRESA:', style: AppTextStyles.base),
                                  ],
                                ),
                                const SizedBox(width: 40),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_selectedCustomer!.customerName, style: AppTextStyles.selection),
                                    Text(companiesProvider.getCompanyNameById(_selectedCustomer!.idCompany), style: AppTextStyles.base),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            receiptType(key: _receiptKey)
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
                      ? partOrder(idCustomer: _selectedCustomer!.idCustomer!)
                      : partOrder(idCustomer: 0),
                    ),

                    const SizedBox(height: 10),
                    SearchProduct(
                      idCustomer: _selectedCustomer?.idCustomer ?? 0,
                    ),
                    SizedBox(height: 20),
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
                child: ResumeProduct(selectedProducts: Provider.of<ProductsProvider>(context).selectedProducts,)
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
                  child: paymentMethod(key: _paymentKey),
                ),
              ),

              const SizedBox(height: 20),
              observations(key: _observationsKey),
              const SizedBox(height: 30),
              buttonRegisterOrder(onPressed: _registerOrder),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
    
  void _registerOrder() {
    final idCustomer = _selectedCustomer?.idCustomer;
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final selectedProducts = products.selectedProducts;
    final paymentMethod = _paymentKey.currentState?.selectedPaymentMethod;
    final receiptType = _receiptKey.currentState?.selectedReceiptType;
    // final paymentInfo = _paymentKey.currentState!.paymentInfo;

    // Validar cliente
    if (idCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona un cliente")),
      );
      return;
    }

    // Validar tipo de recibo
    if (receiptType == null || receiptType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona un tipo de recibo")),
      );
      return;
    }

    // Validar productos
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona al menos un producto")),
      );
      return;
    }

    // Validar método de pago
    if (paymentMethod == null || paymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecciona un método de pago")),
      );
      return;
    }

    // Si todo es válido, cerrar modal y registrar
    Navigator.pop(context);

    registerOrder(
      context: context,
      idCustomer: idCustomer,
      receiptKey: _receiptKey,
      observationsKey: _observationsKey,
      paymentKey: _paymentKey,
      paymentInfoKey: _paymentKey,
      resetForm: _resetForm,
    );
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
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
}