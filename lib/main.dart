import 'package:balanced_foods/providers/tipos_documento_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // para orientación de dispositivo
import 'package:balanced_foods/providers/configuraciones_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/entregas_provider.dart';
import 'package:balanced_foods/providers/facturas_provider.dart';
import 'package:balanced_foods/providers/follow_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/providers/tipos_cliente_provider.dart';
import 'package:balanced_foods/providers/ubigeos_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/providers/dashboard_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown, // Para invertir disposivo/orientación
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EntregasProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => FollowProvider()),
        ChangeNotifierProvider(create: (_) => CustomersProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentsProvider()),
        ChangeNotifierProvider(create: (_) => ProvincesProvider()),
        ChangeNotifierProvider(create: (_) => DistrictsProvider()),
        ChangeNotifierProvider(create: (_) => UbigeosProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => TipoClienteProvider()),
        ChangeNotifierProvider(create: (_) => TipoDocumentoProvider()),
        ChangeNotifierProvider(create: (_) => OpcionCatalogoProvider()),
        ChangeNotifierProvider(create: (_) => FacturasProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
