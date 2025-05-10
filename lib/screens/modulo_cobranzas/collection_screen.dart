import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

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
        child: Column(
          children: [
            const CreditosCard(),
          ],
        )
      ),
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
  final List<String> _titulos = ['Créditos Vencidos', 'Créditos por Vencer'];
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
          ),
          const Divider(color: Color(0xFFBDBDBD), thickness: 1.0, height: 0,),
          // Contenido del gráfico
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Expanded(
              child: Column(
                children: [
                  IndexedStack(
                    index: _selectedIndex,
                    children: [
                      Row(
                        children: [
                          Expanded(child: _overdueCredits()),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: _dueCredits()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _overdueCredits() {
    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Crédito Vencido...')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dueCredits() {
    return Card(
      color: Color(0xFFD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Crédito por Vencer...')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
