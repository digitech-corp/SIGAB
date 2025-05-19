import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/front_page_screen.dart';
import 'package:balanced_foods/screens/modulo_clientes/customer_screen.dart';
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
          create: (_) => CustomersProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => CompaniesProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => UsersProvider(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ADYSA',
        home: FrontPage(),
      ),
    );
  }
}
