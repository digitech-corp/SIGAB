import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  String query = '';

  List<Persona> personas = [
    Persona(
      nombre: 'Alberto Diaz Cerro',
      empresa: 'JC Company Sociedad Anonima',
      imagenUrl: 'https://img.freepik.com/foto-gratis/joven-barbudo-camisa-rayas_273609-5677.jpg',
    ),
    Persona(
      nombre: 'Angela Jimenez Puican',
      empresa: 'Agropecuaria del Norte SAC',
      imagenUrl: 'https://media.istockphoto.com/id/1389348844/es/foto/foto-de-estudio-de-una-hermosa-joven-sonriendo-mientras-est%C3%A1-de-pie-sobre-un-fondo-gris.jpg?s=1024x1024&w=is&k=20&c=OQE7FSSw4bJdPxfEsPQt-cr_vK56LuUBdvFM43quMg8=',
    ),
    Persona(
      nombre: 'Armando Sandoval Saucedo',
      empresa: 'Sandoval y Asociados',
      imagenUrl: 'https://st2.depositphotos.com/4431055/7495/i/950/depositphotos_74950191-stock-photo-men-latin-american-and-hispanic.jpg',
    ),
    Persona(
      nombre: 'Beatriz Bocanegra Senmache',
      empresa: 'Bocanegra Consulting',
      imagenUrl: 'https://media.istockphoto.com/id/1389348844/es/foto/foto-de-estudio-de-una-hermosa-joven-sonriendo-mientras-est%C3%A1-de-pie-sobre-un-fondo-gris.jpg?s=1024x1024&w=is&k=20&c=OQE7FSSw4bJdPxfEsPQt-cr_vK56LuUBdvFM43quMg8=',
    ),
    Persona(
      nombre: 'Beto del castillo Limo',
      empresa: 'Del Castillo Exportaciones',
      imagenUrl: 'https://media.istockphoto.com/id/1090878494/es/foto/retrato-de-joven-sonriente-a-hombre-guapo-en-camiseta-polo-azul-aislado-sobre-fondo-gris-de.jpg?s=612x612&w=is&k=20&c=Dflvwx6khOs9VBQYSaQGVbfG6yVLCnuNr8uGhvNBLm0=',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final listaFiltrada = personas
        .where((p) =>
            p.nombre.toLowerCase().contains(query.toLowerCase()) ||
            p.empresa.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final agrupado = agruparPorInicial(listaFiltrada);

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
                child: ListView.builder(
                  itemCount: agrupado.length,
                  itemBuilder: (context, index) {
                    String letra = agrupado.keys.elementAt(index);
                    List<Persona> grupo = agrupado[letra]!;

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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(p.imagenUrl),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.nombre,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFFFF6600),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      p.empresa,
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
                                  debugPrint('Llamando a ${p.nombre}');
                                },
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: Image.asset('assets/images/whatsapp.png', color: Colors.black),
                                ),
                                onPressed: () {
                                  debugPrint('Chateando con ${p.nombre}');
                                },
                              ),
                            ],
                          ),
                        )),
                      ],
                    );
                  },
                ),
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
                      onPressed: () {},
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
}

// MODELO DE DATOS
class Persona {
  final String nombre;
  final String empresa;
  final String imagenUrl;

  Persona({
    required this.nombre,
    required this.empresa,
    required this.imagenUrl,
  });
}

Map<String, List<Persona>> agruparPorInicial(List<Persona> personas) {
  Map<String, List<Persona>> agrupado = {};

  for (var persona in personas) {
    String inicial = persona.nombre[0].toUpperCase();
    if (!agrupado.containsKey(inicial)) {
      agrupado[inicial] = [];
    }
    agrupado[inicial]!.add(persona);
  }

  var keysOrdenadas = agrupado.keys.toList()..sort();
  return {
    for (var key in keysOrdenadas)
      key: (agrupado[key]!..sort((a, b) => a.nombre.compareTo(b.nombre)))
  };
}
