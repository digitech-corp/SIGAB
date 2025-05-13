import 'package:balanced_foods/screens/modulo_pedidos/product_catalog_screen.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  bool _contado = false;
  bool _credito = false;

  @override
  Widget build(BuildContext context) {
    final bool haySeleccion = _credito || _contado;
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
                  'Gestión de Pedidos',
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'CLIENTE', 
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xFFECEFF1),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 25,
                            child: TextField(
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
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.black),
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
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CLIENTE:',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'EMPRESA:',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'FACTURA:',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                    ),
                                  ),
                                ], 
                              ),
                              const SizedBox(width: 40),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '{Alfredo Perez Santisteban}',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '{MOLINO SANTISTEBAN SAC}',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Icon(Icons.check_box),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              Text(
                'CATÁLOGO', 
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xFFECEFF1),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Selección de Productos',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                    ),
                                  ),
                                ], 
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ProductCatalogScreen()),
                                      );
                                    },
                                    child: Text(
                                      'Ver Catálogo',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 25,
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                hintText: 'Buscar Producto/Código',
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
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.black),
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
                    SizedBox(height: 20),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              Text(
                'RESUMEN DE PEDIDO', 
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity, //POR MIENTRAS PARA VISUALIZAR
                height: 80, //POR MIENTRAS PARA VISUALIZAR
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xFFECEFF1),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('<<AQUI VA IR LA TABLA>>'),
                          ]
                      )
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              Text(
                'MODALIDAD DE PAGO', 
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity, //POR MIENTRAS
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xFFECEFF1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Modalidad de Pago',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333)
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'CONTADO',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.9,
                                  child: Checkbox(
                                    visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                                    activeColor: Color(0xFFFF6600),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: _contado,
                                    onChanged: (value) {
                                      setState(() {
                                        _contado = value!;
                                        if (_contado) _credito = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 18,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'CRÉDITO',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.9,
                                  child: Checkbox(
                                    visualDensity: VisualDensity(horizontal: -4.0, vertical: -4.0),
                                    activeColor: Color(0xFFFF6600),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    value: _credito,
                                    onChanged: (value) {
                                      setState(() {
                                        _credito = value!;
                                        if (_credito) _contado = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: haySeleccion 
                                    ? () {}
                                    : null,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: haySeleccion 
                                    ? Color(0xFFFF6600)
                                    : Colors.white,
                                    foregroundColor: haySeleccion
                                      ? Colors.white
                                      : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                  ),
                                  child: Text(
                                    'Registrar Pago',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: haySeleccion
                                      ? Colors.white
                                      : Color(0xFFFF6600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                'OBSERVACIONES', 
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity, //POR MIENTRAS
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xFFECEFF1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Lugar de Entrega:',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 1),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2),
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Fecha de Entrega:',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 1),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2),
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Hora de Entrega:',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 1),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2),
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Información Adicional:',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              maxLines: 2,
                              minLines: 2,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 1),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 2),
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción al presionar el botón
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Color(0xFFFF6600),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'REGISTRAR PEDIDO',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}