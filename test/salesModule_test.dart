import 'package:balanced_foods/models/user.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/orders_provider.dart';
import 'package:balanced_foods/providers/products_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'login_test.dart'; // Asegúrate de que esta clase contenga `FakeAppSettingsProvider`

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
  }
}

class FakeUsersProvider extends UsersProvider {
  FakeUsersProvider() : super(settingsProvider: FakeAppSettingsProvider());

  @override
  User? get loggedUser => User(
        idUser: 1,
        name: "Juan Pérez",
        dni: "12345678",
        email: "juan.perez@example.com",
        password: "1234",
        image: "", // sin URL remota
        role: "Vendedor",
      );
}

class FakeCustomersProvider extends CustomersProvider {
  FakeCustomersProvider() : super(settingsProvider: FakeAppSettingsProvider());
}

class FakeCompaniesProvider extends CompaniesProvider {
  FakeCompaniesProvider() : super(settingsProvider: FakeAppSettingsProvider());
}

class FakeOrdersProvider extends OrdersProvider {
  FakeOrdersProvider() : super(settingsProvider: FakeAppSettingsProvider());
}

class FakeDepartmentsProvider extends DepartmentsProvider {
  FakeDepartmentsProvider() : super(settingsProvider: FakeAppSettingsProvider());
}

class FakeProvincesProvider extends ProvincesProvider {
  FakeProvincesProvider() : super(settingsProvider: FakeAppSettingsProvider());
}

class FakeDistrictsProvider extends DistrictsProvider {
  FakeDistrictsProvider() : super(settingsProvider: FakeAppSettingsProvider());
}

class FakeProductsProvider extends ProductsProvider {
  FakeProductsProvider() : super(settingsProvider: FakeAppSettingsProvider());
}

void main() {
  final mockObserver = MockNavigatorObserver();

  testWidgets('SalesModuleScreen muestra elementos principales y navegación', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersProvider>(create: (_) => FakeUsersProvider()),
          ChangeNotifierProvider<CustomersProvider>(create: (_) => FakeCustomersProvider()),
          ChangeNotifierProvider<CompaniesProvider>(create: (_) => FakeCompaniesProvider()),
          ChangeNotifierProvider<OrdersProvider>(create: (_) => FakeOrdersProvider()),
          ChangeNotifierProvider<DepartmentsProvider>(create: (_) => FakeDepartmentsProvider()),
          ChangeNotifierProvider<ProvincesProvider>(create: (_) => FakeProvincesProvider()),
          ChangeNotifierProvider<DistrictsProvider>(create: (_) => FakeDistrictsProvider()),
          ChangeNotifierProvider<ProductsProvider>(create: (_) => FakeProductsProvider()),
        ],
        child: MaterialApp(
          home: SalesModuleScreen(),
          navigatorObservers: [mockObserver],
          routes: {
            '/login': (context) => LoginScreen(),
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verifica texto principal
    expect(find.text('Bienvenida a tu panel de trabajo'), findsOneWidget);

    // Verifica íconos de navegación (requiere que tengan keys)
    final bottomIcons = find.descendant(of: find.byType(BottomNavigationBar),matching: find.byType(Image),);

    expect(bottomIcons, findsNWidgets(5));

    // Tap en tarjeta "Dashboard"
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard'), findsWidgets);

    // Regresar
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // Tap en tarjeta "Clientes"
    await tester.tap(find.text('Clientes'));
    await tester.pumpAndSettle();
    expect(find.text('Gestión de Clientes'), findsWidgets);

    // Regresar
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // Tap en tarjeta "Pedidos"
    await tester.tap(find.text('Pedidos'));
    await tester.pumpAndSettle();
    expect(find.text('MODULO DE PEDIDOS'), findsWidgets);

    // Regresar
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // Tap en tarjeta "Seguimiento"
    await tester.tap(find.text('Seguimiento'));
    await tester.pumpAndSettle();
    expect(find.text('Modulo de Seguimiento de Pedidos'), findsWidgets);

    // Regresar
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // Tap en tarjeta "Cobranzas"
    // final cobranzasCard = find.byKey(Key('card-cobranzas'));
    // await tester.scrollUntilVisible(cobranzasCard,200.0,);
    // await tester.tap(cobranzasCard);
    // await tester.pumpAndSettle();
    // expect(find.text('Modulo de Cobranzas'), findsWidgets);

    // Abrir el Drawer
    await tester.dragFrom(tester.getTopLeft(find.byType(Scaffold)),const Offset(300, 0),);
    await tester.pumpAndSettle();

    expect(find.text('Cerrar Sesión'), findsOneWidget);

    // Cerrar sesión
    await tester.tap(find.text('Cerrar Sesión'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Drawer muestra información de usuario correcta', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersProvider>(create: (_) => FakeUsersProvider()),
          ChangeNotifierProvider<CustomersProvider>(create: (_) => FakeCustomersProvider()),
        ],
        child: MaterialApp(
          home: SalesModuleScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Abrir Drawer
    await tester.dragFrom(tester.getTopLeft(find.byType(Scaffold)), const Offset(300, 0));
    await tester.pumpAndSettle();

    expect(find.text('Vendedor'), findsOneWidget); // Debe estar en mayúsculas si así está en el Drawer
    expect(find.byType(Image), findsWidgets); // La imagen local debería cargarse sin fallos
  });
}
