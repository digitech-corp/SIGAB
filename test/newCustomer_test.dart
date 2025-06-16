

import 'package:balanced_foods/models/company.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/providers/AppSettingsProvider.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/departments_provider.dart';
import 'package:balanced_foods/providers/districts_provider.dart';
import 'package:balanced_foods/providers/provinces_provider.dart';
import 'package:balanced_foods/screens/modulo_clientes/new_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'salesModule_test.dart';

void main() {
  // setUp(() {
  //   SharedPreferences.setMockInitialValues({});
  // });
  testWidgets('NewCustomerScreen muestra validaciones y permite registro', (tester) async {
    // Proveedores fake
    final fakeDepartments = FakeDepartmentsProvider();
    final fakeProvinces = FakeProvincesProvider();
    final fakeDistricts = FakeDistrictsProvider();
    final fakeCustomers = FakeCustomersProvider();
    final fakeCompanies = FakeCompaniesProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DepartmentsProvider>.value(value: fakeDepartments),
          ChangeNotifierProvider<ProvincesProvider>.value(value: fakeProvinces),
          ChangeNotifierProvider<DistrictsProvider>.value(value: fakeDistricts),
          ChangeNotifierProvider<CompaniesProvider>.value(value: fakeCompanies),
          ChangeNotifierProvider<CustomersProvider>.value(value: fakeCustomers),
        ],
        child: MaterialApp(home: NewCustomerScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Registrar Nuevo Cliente'), findsOneWidget);
    final registerButton = find.text('Añadir Contacto');
    
    // Datos de prueba
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'p. ej. Alfredo Fiestas'),
      'Juan Pérez');
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'DNI'),
      '12345678');
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'p. ej. Alfredo Fiestas'),
      'Juan Pérez');
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'Celular'),
      '987654321');
    await tester.tap(find.byType(DropdownButton<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lima').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lima').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miraflores').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'Dirección...'),
      'Calle Real 456');
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'Referencia'),
      'Frente a la plaza');
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'RUC'),
      '20123456789');
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'Razón Social'),
      'MiEmpresa SAC');
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'Dirección Fiscal'),
      'Av. Central 123');
    await tester.enterText(
      find.byWidgetPredicate((widget) =>
        widget is TextField && widget.decoration?.hintText == 'Sitio Web'),
      'www.miempresa.com');

    // Registrar   
    await tester.pumpAndSettle();
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(registerButton);
    // await tester.pumpAndSettle();
    // expect(find.text("Se ha añadido exitosamente"), findsOneWidget);
  });
}

class FakeAppSettingsProvider extends AppSettingsProvider {
  @override
  bool get useLocalData => true;
}

class FakeCompaniesProvider extends CompaniesProvider {
  FakeCompaniesProvider() : super(settingsProvider: FakeAppSettingsProvider());

  @override
  Future<int> createCompany(Company company) async {
    return company.idCompany = 6;
  }
}

class FakeCustomersProvider extends CustomersProvider {
  FakeCustomersProvider() : super(settingsProvider: FakeAppSettingsProvider());

  @override
  Future<bool> registerCustomer(Customer customer) async {
    print('CUSTOMER REGISTRADO: ${customer.toJson()}');
    return true;
  }
}