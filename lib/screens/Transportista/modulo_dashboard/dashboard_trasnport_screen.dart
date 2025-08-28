import 'package:balanced_foods/providers/entregas_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Transportista/modulo_dashboard/BarrasApiladas.dart';
import 'package:balanced_foods/screens/Transportista/modulo_dashboard/EstadoEntregasCards.dart';
import 'package:balanced_foods/screens/Transportista/modulo_dashboard/Lineas.dart';
import 'package:balanced_foods/screens/Transportista/transport_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardTransportScreen extends StatefulWidget {
  const DashboardTransportScreen({super.key});

  @override
  State<DashboardTransportScreen> createState() => _DashboardTransportScreenState();
}

class _DashboardTransportScreenState extends State<DashboardTransportScreen> {
  String _filtro = 'Día actual'; // valor inicial
  late DateTime fechaInicio;
  late DateTime fechaFin;

  @override
  void initState() {
    super.initState();
    _setFechas(); 
    Future.microtask(() async {
      await _cargarEntregas();
    });
  }

  void _setFechas() {
    final hoy = DateTime.now();
    if (_filtro == 'Día actual') {
      fechaInicio = DateTime(hoy.year, hoy.month, hoy.day);
      fechaFin = fechaInicio;
    } else if (_filtro == 'Semana actual') {
      final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1));
      final finSemana = inicioSemana.add(const Duration(days: 6));
      fechaInicio = DateTime(inicioSemana.year, inicioSemana.month, inicioSemana.day);
      fechaFin = DateTime(finSemana.year, finSemana.month, finSemana.day);
    } else if (_filtro == 'Mes actual') {
      fechaInicio = DateTime(hoy.year, hoy.month, 1);
      fechaFin = DateTime(hoy.year, hoy.month + 1, 0);
    }
  }

  Future<void> _cargarEntregas() async {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final entregasProvider = Provider.of<EntregasProvider>(context, listen: false);
    final idTransportista = userProvider.loggedUser?.idTransportista ?? null;
    final token = userProvider.token;
    await entregasProvider.fetchEntregas(token!, DateFormat('yyyy-MM-dd').format(fechaInicio), DateFormat('yyyy-MM-dd').format(fechaFin), idTransportista);
  }
  
  @override
  Widget build(BuildContext context) {
    final entregasProvider =  Provider.of<EntregasProvider>(context);
    final entregas = entregasProvider.entregas;
    final entregados = entregas.where((entregas){
      final idEntregado = [239];
      return idEntregado.contains(entregas.idEstado);
    }).toList();
    final noEntregados = entregas.where((entregas){
      final idNoEntregado = [240];
      return idNoEntregado.contains(entregas.idEstado);
    }).toList();

    final entregadosLenght = entregados.length;
    final noEntregadosLenght = noEntregados.length;

    return Scaffold(
      backgroundColor: AppColors.backgris,
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
                      MaterialPageRoute(builder: (context) => TransportScreen()),
                    );
                  },
                ),
                const SizedBox(width: 1),
                Text('Dashboard', style: AppTextStyles.title),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Panel de Entregas',
                      style: AppTextStyles.subtitle,
                    ),
                    Row(
                      children: [
                        Text(
                          'Filtrar por:',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gris,
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _filtro,
                          style: const TextStyle(fontSize: 12, color: AppColors.gris),
                          items: ['Día actual', 'Semana actual', 'Mes actual']
                              .map((opcion) => DropdownMenuItem(
                                    value: opcion,
                                    child: Text(opcion),
                                  ))
                              .toList(),
                          onChanged: (nuevoValor) async {
                            setState(() {
                              _filtro = nuevoValor!;
                              _setFechas();
                            });
                            await _cargarEntregas();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              EstadoEntregasCards(entregados: entregadosLenght, noEntregados: noEntregadosLenght),
              const SizedBox(height: 20),
              BarrasApiladas(entregas: entregas),
              const SizedBox(height: 20),
              Lineas(entregas: entregas),
              const SizedBox(height: 20),
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
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.gris
  );
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
  static final subtitle = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static final titlecard = base.copyWith(color: AppColors.orange);
  static final infocard = base.copyWith(fontSize: 10, color: Colors.black);
  static final percent = base.copyWith(fontSize: 20, color: AppColors.green);
  static final count = base.copyWith(fontSize: 20, color: AppColors.red);
  static TextStyle titleCards(bool isSelected) {
    return base.copyWith(
      color: isSelected ? AppColors.orange : AppColors.gris,
    );
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
  static const green = Color(0xFF2ECC71);
  static const red = Color(0xFFE74C3C);
}