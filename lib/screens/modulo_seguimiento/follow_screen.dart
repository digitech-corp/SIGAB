import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  bool _isExpanded = false;

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
                  'Modulo de Seguimiento de Pedidos',
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
                        'Pedidos del día',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Item',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const Text(
                        'N° Pedido',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const Text(
                        'Estado',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const Text(
                        'F. entrega',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const Text(
                        'Lugar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const Text(
                        'Detalle',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFFBDBDBD), thickness: 1.0),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _detailOrder()),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _detailOrder() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('{01}', style: TextStyle(fontSize: 10)),
                  const Text('{P-51-2025}', style: TextStyle(fontSize: 10)),
                  const Text('{Pendiente}', style: TextStyle(fontSize: 10, color: Color(0xFFE74C3C))),
                  const Text('{20/05/25}', style: TextStyle(fontSize: 10)),
                  const Text('{Chongoyape}', style: TextStyle(fontSize: 10)),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Image.asset(
                      _isExpanded 
                        ? 'assets/images/eyeOpen.png' 
                        : 'assets/images/eyeClose.png',
                      width: 15,
                      height: 15,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen del Pedido:', 
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF333333)
                    )
                  ),
                  Text('03 ADYaves Plus ...'),
                  Text('01 Campero Cerdos ...'),
                  Text('04 ADV Alevino Alta ...'),
                  SizedBox(height: 5),
                  Text('Tipo de Pago: Contado'),
                  Text('Dirección: Dirección fiscal'),
                  Text('Hora: 11:30 am'),
                  Text('Observación: Dirige frente al grifo San Antonio'),
                  SizedBox(height: 10),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Image.asset(
                        'assets/images/map.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}