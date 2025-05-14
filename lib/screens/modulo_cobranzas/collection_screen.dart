import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      MaterialPageRoute(
                        builder: (context) => SalesModuleScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 1),
                const Text(
                  'Módulo de Cobranzas',
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
      body: SafeArea(child: Column(children: [const CreditosCard()])),
    );
  }
}

class CreditosCard extends StatefulWidget {
  const CreditosCard({super.key});

  @override
  State<CreditosCard> createState() => _CreditosCardState();
}

class _CreditosCardState extends State<CreditosCard> {
  int _selectedIndex = 0;
  String _sortBy = 'Fecha Vencimiento';
  final List<String> _titulos = ['Créditos Vencidos', 'Créditos por Vencer'];
  final List<String> _sortOptions = [
    'Fecha Vencimiento',
    'Monto Total',
    'Días Vencido',
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Tabs
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_titulos.length, (index) {
              final bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? Colors.white
                      : null,
                    border: isSelected
                        ? Border.all(color: const Color(0xFFBDBDBD))
                        : Border.all(color: Color(0xFFBDBDBD)),
                  ),
                  child: Text(
                    _titulos[index],
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected 
                      ? const Color(0xFFFF6600)
                      : const Color(0xFFBDBDBD),
                    ),
                  ),
                ),
              );
            }),
          ),
          const Divider(color: Color(0xFFBDBDBD), thickness: 1.0, height: 0,),

          // Ordenar por Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Ordenar por: ',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF333333)
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 20,
                  width: 130,
                  child: DropdownButtonFormField<String>(
                    value: _sortBy,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF333333),
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      border: OutlineInputBorder(),
                    ),
                    items: _sortOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sortBy = value);
                      }
                    },
                  ),
                )

              ],
            ),
          ),
          // Tarjetas scrollables
          Expanded(
            child: _selectedIndex == 0
                ? ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: 3, // Créditos vencidos
                    itemBuilder: (context, index) {
                      return _creditCard(
                        cliente: index == 0
                            ? 'MOLINOS PERUANOS SA'
                            : 'AGROINDUSTRIA LOS ANDES SAC',
                        contacto: 'Angel Sebastian Cubas',
                        pedido: '95-2025',
                        estadoVencimiento: 'VENCIDO',
                        vencidoDias: '${3 + index} días',
                        monto: 'S/. 780.50',
                        saldo: 'S/. 780.50',
                        fechaVencimiento: '17/05/2025',
                        esPorVencer: false,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: 3, // Créditos por vencer
                    itemBuilder: (context, index) {
                      return _creditCard(
                        cliente: index == 0
                            ? 'FRUTAS DEL SUR SAC'
                            : 'EXPORTACIONES PERUANAS EIRL',
                        contacto: 'Maria López',
                        pedido: '96-2025',
                        estadoVencimiento: 'VIGENTE',
                        vencidoDias: 'En ${5 - index} días',
                        monto: 'S/. 540.00',
                        saldo: 'S/. 540.00',
                        fechaVencimiento: '20/05/2025',
                        esPorVencer: true,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  ),
          )
        ],
      ),
    );
  }

  Widget _creditCard({
    required String cliente,
    required String contacto,
    required String pedido,
    required String estadoVencimiento,
    required String vencidoDias,
    required String monto,
    required String saldo,
    required String fechaVencimiento,
    required bool esPorVencer,
  }) {
    final Color estadoColor = esPorVencer ? Colors.blue : Colors.red;

    final _labelStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 10,
      color: Colors.black,
    );
    final _weakStyle = _labelStyle.copyWith(fontWeight: FontWeight.w300);
    final _strongStyle = _labelStyle.copyWith(fontWeight: FontWeight.w400); 
    final _customerStyle = _labelStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 12,); 
    final _estadoStyle = _labelStyle.copyWith(fontWeight: FontWeight.w500, color: estadoColor);    
    final _saldoStyle = _labelStyle.copyWith(fontWeight: FontWeight.w500, color: estadoColor, fontSize: 12);    


    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cliente:',
                      style: _strongStyle
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Contacto:',
                      style: _strongStyle,
                    ),
                  ],
                ),
                const SizedBox(width: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cliente,
                      style: _customerStyle
                    ),
                    const SizedBox(height: 5),
                    Text(
                      contacto,
                      style: _weakStyle
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'N° de Pedido:',
                      style: _strongStyle,
                    )
                  ],
                ),
                const SizedBox(width: 42),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'PEDIDO N° $pedido',
                      style: _weakStyle,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    Icon(
                      Icons.attach_file,
                      color: Colors.black,
                      size: 20
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Estado del Crédito:',
                      style: _strongStyle,
                    ),
                  ],
                ),
                const SizedBox(width: 17),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      estadoVencimiento,
                      style: _estadoStyle,
                    )
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Fecha Vencimiento:',
                      style: _strongStyle
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      fechaVencimiento,
                      style: _weakStyle
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'N° días Vencido:',
                      style: _strongStyle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Monto TOTAL:',
                      style: _strongStyle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Saldo:',
                      style: _strongStyle
                    )
                  ],
                ),
                const SizedBox(width: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vencidoDias,
                      style: _estadoStyle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      monto,
                      style: _estadoStyle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      saldo,
                      style: _saldoStyle,
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 25,
                      width: 113,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF6600),
                          side: BorderSide(color: Color(0xFFFF6600), width: 1),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Llamar',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFF6600),
                              ),
                            ),
                            Image.asset(
                              'assets/images/phone.png',
                              color: Color(0xFFFF6600),
                              scale: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 25,
                      width: 113,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF6600),
                          side: BorderSide(color: Color(0xFFFF6600), width: 1),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Whatsapp',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFF6600),
                              ),
                            ),
                            Image.asset(
                              'assets/images/whatsapp.png',
                              color: Color(0xFFFF6600),
                              scale: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
