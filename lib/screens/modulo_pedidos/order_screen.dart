import 'package:balanced_foods/screens/modulo_pedidos/new_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
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
            backgroundColor: Colors.transparent,
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
                  'MODULO DE PEDIDOS',
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
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Resumen del día',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        '{20/05/2025}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFBDBDBD), thickness: 1.0),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total de Pedidos del día:',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '{5}',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monto facturado:',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '{S/.3,290.00}',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Detalles de Pedidos',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Divider(color: Color(0xFFBDBDBD), thickness: 1.0),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _detailOrder(
                          'MOLINOS PERUANOS SA', 
                          'Beto del Castillo Limo',
                          'PEDIDO N° 78-2025'
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xFFFF6600),
                    size: 45,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewOrderScreen()),
                      );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _detailOrder(String company, String person, String codOrder) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 70,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage('https://img.freepik.com/foto-gratis/joven-barbudo-camisa-rayas_273609-5677.jpg'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Color(0xFFFF6600),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          person,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          codOrder,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      children: [
                        Text(
                          '8:46 am',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF333333),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          'S/. 460.80',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF333333),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}