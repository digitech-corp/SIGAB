import 'package:balanced_foods/models/customer.dart';
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
  bool isLoading = true;
  String query = '';
  
  Future<List<Customer>> fetchCustomers() async {
    final url = Uri.parse('http://10.0.2.2:12346/customers');
    final response = await http.get(url);
    // V1
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> rawCustomers = data['customers'];
      print('Clientes cargados: ${rawCustomers.length}');
      print(rawCustomers);
      return rawCustomers.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los clientes');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomers().then((data) {
      setState(() {
        customers = data;
        isLoading = false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final listaFiltrada = customers
        .where((p) =>
            p.customerName.toLowerCase().contains(query.toLowerCase()) ||
            p.idCompany.toString().contains(query))
        .toList();
    final agrupado = agruparPorInicial(listaFiltrada);
  if (agrupado.isEmpty) {
  return const Center(child: Text('No se encontraron clientes'));
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
                      MaterialPageRoute(builder: (context) => SalesModuleScreen()),
                    );
                  },
                ),
                const SizedBox(width: 1),
                const Text(
                  'Gestión de Clientes',
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
              const SizedBox(height: 10),

              Expanded(
                child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : agrupado.isEmpty
                      ? const Center(child: Text('No hay clientes disponibles'))
                      : _CustomersList(context, agrupado),
              ),
                
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFFFF6600),
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
              child: Text(
                letra,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF6600),
                  fontSize: 12,
                ),
              ),
            ),
            ...grupo.map((p) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditCustomerScreen(persona: p)),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: p.customerImage.isNotEmpty
                        ? NetworkImage(p.customerImage)
                        : null,
                      backgroundColor: Colors.grey[300],
                      child: p.customerImage.isEmpty
                        ? Icon(Icons.person, color: Colors.white)
                        : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.customerName,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFFFF6600),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.idCompany.toString(),
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.black87,
                            ),
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
                        debugPrint('Llamando a ${p.customerName}');
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
                        debugPrint('Chateando con ${p.customerName}');
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
    // Validar que tenga nombre no vacío
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

