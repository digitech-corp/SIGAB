import 'package:balanced_foods/providers/AppSettingsProvider.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/entregas_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
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
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProxyProvider<AppSettingsProvider, CustomersProvider>(
          create: (context) => CustomersProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              CustomersProvider(settingsProvider: settingsProvider),
        ),

        ChangeNotifierProxyProvider<AppSettingsProvider, CompaniesProvider>(
          create: (context) => CompaniesProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              CompaniesProvider(settingsProvider: settingsProvider),
        ),

        ChangeNotifierProxyProvider<AppSettingsProvider, UsersProvider>(
          create: (context) => UsersProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              UsersProvider(settingsProvider: settingsProvider),
        ),

        ChangeNotifierProxyProvider<AppSettingsProvider, DepartmentsProvider>(
          create: (context) => DepartmentsProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              DepartmentsProvider(settingsProvider: settingsProvider),
        ),

        ChangeNotifierProxyProvider<AppSettingsProvider, ProvincesProvider>(
          create: (context) => ProvincesProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              ProvincesProvider(settingsProvider: settingsProvider),
        ),

        ChangeNotifierProxyProvider<AppSettingsProvider, DistrictsProvider>(
          create: (context) => DistrictsProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              DistrictsProvider(settingsProvider: settingsProvider),
        ),

        ChangeNotifierProxyProvider<AppSettingsProvider, ProductsProvider>(
          create: (context) => ProductsProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              ProductsProvider(settingsProvider: settingsProvider),
        ),

        ChangeNotifierProxyProvider<AppSettingsProvider, OrdersProvider>(
          create: (context) => OrdersProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              OrdersProvider(settingsProvider: settingsProvider),
        ),

        ChangeNotifierProxyProvider<AppSettingsProvider, EntregasProvider>(
          create: (context) => EntregasProvider(
            settingsProvider: Provider.of<AppSettingsProvider>(context, listen: false),
          ),
          update: (_, settingsProvider, __) =>
              EntregasProvider(settingsProvider: settingsProvider),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ADYSA',
        home: FrontPage(),
        // home: InvoiceScreen(idOrder: 1),
      ),
    );
  }
}
