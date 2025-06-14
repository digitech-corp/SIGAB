
import 'package:balanced_foods/models/company.dart';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/providers/companies_provider.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/screens/modulo_clientes/customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'login_test.dart';

class FakeCustomersProvider extends CustomersProvider {
  FakeCustomersProvider() : super(settingsProvider: FakeAppSettingsProvider()) {
    _customers = [
      Customer(
        idCustomer: 1,
        customerName: "Ana",
        dni: "71585463",
        customerImage: "https://img.freepik.com/foto-gratis/joven-barbudo-camisa-rayas_273609-5677.jpg",
        customerPhone: "987654324",
        customerEmail: "pedro.gomez@example.com",
        customerAddress: "Calle Falsa 123",
        customerReference: "Frente al parque",
        idCompany: 1,
        idDepartment: 1,
        idProvince: 1,
        idDistrict: 1
      ),
      Customer(
        idCustomer: 2,
        customerName: "Carlos",
        dni: "85858585",
        customerImage: "https://img.freepik.com/foto-gratis/joven-barbudo-camisa-rayas_273609-5677.jpg",
        customerPhone: "987654324",
        customerEmail: "juan.marrero@example.com",
        customerAddress: "Calle Falsa 123",
        customerReference: "Frente al parque",
        idCompany: 1,
        idDepartment: 1,
        idProvince: 1,
        idDistrict: 1
      ),
    ];
  }

  @override
  bool get isLoading => false;

  @override
  List<Customer> get customers => _customers;

  List<Customer> _customers = [];

  @override
  Future<void> fetchCustomers() async {
    // Simula la carga
    await Future.delayed(Duration(milliseconds: 50));
  }
}

class FakeCompaniesProvider extends CompaniesProvider {
  FakeCompaniesProvider() : super(settingsProvider: FakeAppSettingsProvider()) {
    _companies = [
      Company(
        idCompany: 1,
        companyName: "TechCorp",
        companyRUC: "20123456789",
        companyAddress: "Av. Los Olivos 123",
        companyWeb: "www.TechCorp.com"
      ),
      Company(
        idCompany: 2,
        companyName: "InnovaSoft",
        companyRUC: "20987654321",
        companyAddress: "Calle Innovación 456",
        companyWeb: "www.InnovaSoft.com"
      ),
    ];
  }

  List<Company> _companies = [];

  @override
  List<Company> get companies => _companies;

  @override
  Future<void> fetchCompanies() async {
    await Future.delayed(Duration(milliseconds: 50));
  }

  @override
  String getCompanyNameById(int id) {
    return _companies.firstWhere((c) => c.idCompany == id).companyName;
  }
}

void main() {
  testWidgets('CustomerScreen muestra lista agrupada y permite búsqueda', (tester) async {
    // Crea los fakes
    final fakeCustomers = FakeCustomersProvider();
    final fakeCompanies = FakeCompaniesProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CustomersProvider>.value(value: fakeCustomers),
          ChangeNotifierProvider<CompaniesProvider>.value(value: fakeCompanies),
        ],
        child: const MaterialApp(home: CustomerScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Verifica que el título y los nombres estén
    expect(find.text('Gestión de Clientes'), findsOneWidget);
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Carlos'), findsOneWidget);

    // Verifica que aparecen agrupados por inicial
    expect(find.text('A'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);

    // Filtrar por nombre
    await tester.enterText(find.byType(TextField), 'ana');
    await tester.pumpAndSettle();

    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Carlos'), findsNothing);
  });
}