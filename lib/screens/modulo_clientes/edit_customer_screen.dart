import 'package:flutter/material.dart';

import 'customer_screen.dart';

class EditCustomerScreen extends StatelessWidget {
  final Persona persona;

  const EditCustomerScreen({Key? key, required this.persona}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            toolbarHeight: double.infinity,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFFF6600),
            title: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(persona.imagenUrl),
                  ),
                  Text(
                    persona.nombre, 
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    )
                  ),
                  Text(
                    persona.empresa,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/images/phone.png', color: Colors.black),
                        ),
                        onPressed: () {
                          debugPrint('Llamando...');
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        '{972 143 314}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        'Celular',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFFBDBDBD),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                        ),
                        onPressed: () {
                          debugPrint('Abriendo WhatsApp');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            'assets/images/gmail.png',
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          debugPrint('Abriendo Gmail');
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        '{adiazchero@gmail.com}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        'Particular',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFFBDBDBD),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          debugPrint('Abriendo Gmail');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            'assets/images/gps.png',
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          debugPrint('Viendo Ubicación');
                        },
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          '{Mza. F Lote 3 (Cal J. Zapata frente al Col. Cristo Jesus)}',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF333333),
                          ),
                          softWrap: true,
                        ),
                        Text(
                          'Trujillo, La Libertad',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          'Dirección Fiscal',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFBDBDBD),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          debugPrint('Viendo Ubicación');
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                const RecordCard(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 282,
                  height: 37,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Color(0xFFFF6600), 
                          width: 1, 
                        ),
                      ),
                    ),
                    child: const Text(
                      'Editar Contacto',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Color(0xFFFF6600),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )
          ],
        ),
        
      ),
    );
  }
}

class RecordCard extends StatefulWidget {
  const RecordCard({super.key});

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  int _selectedIndex = 0;
  final List<String> _titulos = ['Historial', 'Pedidos', 'Facturación', 'Créditos'];
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      child: Column(
        children: [
          // Botones de filtro
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_titulos.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? null
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
          ),
          const Divider(color: Color(0xFFBDBDBD), thickness: 1.0, height: 0,),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                IndexedStack(
                  index: _selectedIndex,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _recordDetail()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _ordersDetail()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _collectionsDetail()),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _creditsDetail()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recordDetail() {
    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Historial')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _ordersDetail() {
    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Pedidos')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _collectionsDetail() {
    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Facturación')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _creditsDetail() {
    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Créditos')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}