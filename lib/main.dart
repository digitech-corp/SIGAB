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
import 'package:balanced_foods/providers/roles_provider.dart';
import 'package:balanced_foods/providers/ubigeos_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/providers/dashboard_provider.dart';
import 'package:balanced_foods/screens/front_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EntregasProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => UsersProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),
        
        ChangeNotifierProvider(
          create: (_) => FollowProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => CustomersProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => OrdersProvider2(),
        ),

        ChangeNotifierProvider(
          create: (_) => DepartmentsProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ProvincesProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DistrictsProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => UbigeosProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RolesProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => OpcionCatalogoProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => FacturasProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ADYSA',
        home: FrontPage(),
      ),
    );
  }
}
