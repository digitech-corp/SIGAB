import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:balanced_foods/models/user.dart';
import 'package:balanced_foods/providers/AppSettingsProvider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/new_user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Registro exitoso de usuario simulado', (WidgetTester tester) async {
    // Simulación de providers
    final fakeSettings = FakeAppSettingsProvider();
    final fakeProvider = FakeUsersProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppSettingsProvider>.value(value: fakeSettings),
          ChangeNotifierProvider<UsersProvider>.value(value: fakeProvider),
        ],
        child: const MaterialApp(home: NewUserScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Campos de texto
    final nameField = find.byType(TextFormField).at(0);
    final dniField = find.byType(TextFormField).at(1);
    final emailField = find.byType(TextFormField).at(2);
    final passwordField = find.byType(TextFormField).at(3);
    final confirmPasswordField = find.byType(TextFormField).at(4);
    final registerButton = find.text('Registrarse');

    // Nuevos datos de prueba
    await tester.enterText(nameField, 'Nuevo Usuario');
    await tester.enterText(dniField, '12345678');
    await tester.enterText(emailField, 'nuevo@correo.com');
    await tester.enterText(passwordField, 'password123');
    await tester.enterText(confirmPasswordField, 'password123');

    // Registrar
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    // Mensaje de éxito
    expect(find.text('Registrado correctamente'), findsOneWidget);
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
  Future<bool> registerUser(User user) async {
    // Simula éxito siempre
    return true;
  }
}