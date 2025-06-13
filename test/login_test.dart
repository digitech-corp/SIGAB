import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:balanced_foods/models/user.dart';
import 'package:balanced_foods/providers/AppSettingsProvider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  testWidgets('Login exitoso con usuario simulado', (WidgetTester tester) async {
    // SIMULACIONES
    final fakeSettings = FakeAppSettingsProvider();
    final fakeProvider = FakeUsersProvider();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppSettingsProvider>.value(value: fakeSettings),
          ChangeNotifierProvider<UsersProvider>.value(value: fakeProvider),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Encuentro de los campos de texto
    final emailField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);
    final loginButton = find.text('Iniciar Sesión');

    // Ingreso de credenciales válidas
    await tester.enterText(emailField, 'ventasadysa@gmail.com');
    await tester.enterText(passwordField, '47978672');

    // Al presionar el botón
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verifica que se muestre mensaje de éxito
    expect(find.text('Inicio de sesión exitoso'), findsOneWidget);
  });
}

// Fakes

class FakeAppSettingsProvider extends AppSettingsProvider {
  @override
  bool get useLocalData => true;
}

class FakeUsersProvider extends UsersProvider {
  FakeUsersProvider() : super(settingsProvider: FakeAppSettingsProvider());

  @override
  Future<User?> validateUser(String email, String password) async {
    if (email == 'ventasadysa@gmail.com' && password == '47978672') {
      return User(
        idUser: 2,
        name: 'Test User',
        dni: 'Test dni',
        email: email,
        password: password,
        image: "",
        role: 'Vendedor',
      );
    }
    return null;
  }
}