import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/company.dart';

import 'package:balanced_foods/screens/modulo_clientes/edit_customer_screen.dart';
import 'package:balanced_foods/screens/modulo_clientes/new_customer_screen.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [];
  List<Company> companies = [];
  bool isLoading = true;
  String query = '';
  //v1

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final customersUrl = Uri.parse('http://10.0.2.2:12346/customers');
      final companiesUrl = Uri.parse('http://10.0.2.2:12346/company');

      final customersResponse = await http.get(customersUrl);
      final companiesResponse = await http.get(companiesUrl);

      if (customersResponse.statusCode == 200 && companiesResponse.statusCode == 200) {
        final customersData = jsonDecode(customersResponse.body);
        final companiesData = jsonDecode(companiesResponse.body);

        final List<dynamic> rawCustomers = customersData['customers'];
        final List<dynamic> rawCompanies = companiesData['company'];

        setState(() {
          customers = rawCustomers.map((json) => Customer.fromJson(json)).toList();
          companies = rawCompanies.map((json) => Company.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }



  //V1
  
  @override
  Widget build(BuildContext context) {
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SalesModuleScreen()),
                    );
                  },
                ),
                const SizedBox(width: 1),
                Text('Gestión de Clientes', style: AppTextStyles.strong),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: 30,
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            query = val;
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          hintText: 'Buscar Cliente/Empresa',
                          hintStyle: AppTextStyles.search,
                          filled: true,
                          fillColor: const Color(0xFFECEFF1),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: AppTextStyles.msj,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : () {
                        final listaFiltrada = customers
                            .where((c) =>
                                c.customerName.toLowerCase().contains(query.toLowerCase()) ||
                                c.idCompany.toString().contains(query))
                            .toList();
                        final agrupado = agruparPorInicial(listaFiltrada);

                        if (agrupado.isEmpty) {
                          return Center(
                            child: Text('No se encontraron clientes', style: AppTextStyles.msj),
                          );
                        }
                        return _CustomersList(context, agrupado);
                      }(),
              ),
                
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: AppColors.orange,
                        size: 45,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => NewCustomerScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _CustomersList(BuildContext context, Map<String, List<Customer>> agrupado) {
    return ListView.builder(
      itemCount: agrupado.length,
      itemBuilder: (context, index) {
        String letra = agrupado.keys.elementAt(index);
        List<Customer> grupo = agrupado[letra]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(letra, style: AppTextStyles.orange),
            ),
            ...grupo.map((c) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditCustomerScreen(
                      customer: c,
                      companyName: companies.firstWhere(
                      (comp) => comp.idCompany == c.idCompany,
                      ).companyName,
                    )),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: c.customerImage.isNotEmpty
                          ? NetworkImage(c.customerImage)
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: c.customerImage.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 30,
                              color: AppColors.gris,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.customerName, style: AppTextStyles.orange),
                          const SizedBox(height: 2),
                          Text(
                            companies.firstWhere((comp) => comp.idCompany == c.idCompany).companyName,
                            style: AppTextStyles.company
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset('assets/images/phone.png', color: Colors.black),
                      ),
                      onPressed: () {
                        debugPrint('Llamando a ${c.customerName}');
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: SizedBox(
                        width: 18,
                        height: 18,
                        child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                      ),
                      onPressed: () {
                        debugPrint('Chateando con ${c.customerName}');
                      },
                    ),
                  ],
                ),
              ),
            )),
          ],
        );
      },
    );
  }
}

Map<String, List<Customer>> agruparPorInicial(List<Customer> customers) {
  Map<String, List<Customer>> agrupado = {};

  for (var customer in customers) {
    if (customer.customerName.trim().isEmpty) continue;
    String inicial = customer.customerName[0].toUpperCase();
    if (!agrupado.containsKey(inicial)) {
      agrupado[inicial] = [];
    }
    agrupado[inicial]!.add(customer);
  }

  var keysOrdenadas = agrupado.keys.toList()..sort();

  return {
    for (var key in keysOrdenadas)
      key: (agrupado[key]!..sort((a, b) => a.customerName.compareTo(b.customerName)))
  };
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColors.orange
  );
  static final strong = base.copyWith(fontSize: 16,fontWeight: FontWeight.w600,color: AppColors.gris);
  static final search = base.copyWith(fontWeight: FontWeight.w300,fontSize: 10,color: Colors.black,);
  static final msj = base.copyWith(color: Colors.black,);
  static final orange = base.copyWith();
  static final company = base.copyWith(fontWeight: FontWeight.w400,fontSize: 10,color: Colors.black);
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
}
