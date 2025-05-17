import 'package:flutter/material.dart';

import 'package:balanced_foods/models/customer.dart';

class EditCustomerScreen extends StatelessWidget {
  final Customer customer;
  final String companyName;

  const EditCustomerScreen({
    Key? key, 
    required this.customer, 
    required this.companyName,
  }) : super(key: key);

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
            backgroundColor: AppColors.orange,
            title: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 58,
                    backgroundImage: customer.customerImage.isNotEmpty
                        ? NetworkImage(customer.customerImage)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: customer.customerImage.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 100,
                            color: AppColors.gris,
                          )
                        : null,
                  ),
                  Text(customer.customerName, style: AppTextStyles.name),
                  Text(companyName, style: AppTextStyles.company),
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
                        customer.customerPhone.length == 9
                        ? '${customer.customerPhone.substring(0, 3)} ${customer.customerPhone.substring(3, 6)} ${customer.customerPhone.substring(6)}'
                        : customer.customerPhone,
                        style: AppTextStyles.customerData
                      ),
                      Text('Celular', style: AppTextStyles.subtitle),
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
                      Text(customer.customerEmail, style: AppTextStyles.customerData),
                      Text('Particular', style: AppTextStyles.subtitle),
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
                          '${customer.customerAddress} (${customer.customerReference})',
                          style: AppTextStyles.customerData,
                          softWrap: true,
                        ),
                        Text(
                          '${customer.idDepartment}, ${customer.idProvince}, ${customer.idDistrict}',
                          style: AppTextStyles.customerData
                        ),
                        Text('Dirección Fiscal', style: AppTextStyles.subtitle),
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
                          color: AppColors.orange, 
                          width: 1, 
                        ),
                      ),
                    ),
                    child: Text('Editar Contacto', style: AppTextStyles.btn),
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
                          ? Border.all(color: AppColors.lightGris)
                          : Border.all(color: AppColors.lightGris),
                    ),
                    child: Text(
                      _titulos[index],
                       style: AppTextStyles.titleCards(isSelected),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(color: AppColors.lightGris, thickness: 1.0, height: 0,),
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

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
    fontSize: 13,
    color: AppColors.gris
  );
  static final name = base.copyWith(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white);
  static final company = base.copyWith(fontSize: 12,color: Colors.black);
  static final customerData = base.copyWith();
  static final subtitle = base.copyWith(fontSize: 10, color: AppColors.lightGris);
  static final btn = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.orange);
  static TextStyle titleCards(bool isSelected) {
    return base.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isSelected ? AppColors.orange : AppColors.lightGris,
    );
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const lightGris = Color(0xFFBDBDBD);
}
