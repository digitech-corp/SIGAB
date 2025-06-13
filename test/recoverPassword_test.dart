import 'package:balanced_foods/providers/AppSettingsProvider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:balanced_foods/screens/recover_password_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';


class MockUsersProvider extends Mock implements UsersProvider {
  @override
  Future<String> recoverPassword(String email) =>
      super.noSuchMethod(Invocation.method(#recoverPassword, [email]),
          returnValue: Future.value(''), returnValueForMissingStub: Future.value(''));
}

class DummySettingsProvider extends AppSettingsProvider {
  DummySettingsProvider() : super(); // Usa valores por defecto
}

void main() {
  late MockUsersProvider mockUsersProvider;

  setUp(() {
    mockUsersProvider = MockUsersProvider();
  });

  Future<void> pumpWithProvider(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppSettingsProvider>(
              create: (_) => DummySettingsProvider()),
          ChangeNotifierProvider<UsersProvider>(
              create: (_) => mockUsersProvider),
        ],
        child: const MaterialApp(
          home: RecoverPasswordScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Renderiza elementos y valida campos', (WidgetTester tester) async {
    await pumpWithProvider(tester);

    expect(find.text('Recuperar Contraseña'), findsOneWidget);
    expect(find.text('Ingrese su correo electrónico'), findsOneWidget);
    expect(find.text('Restablecer contraseña'), findsOneWidget);

    // Intenta enviar sin texto
    await tester.tap(find.text('Restablecer contraseña'));
    await tester.pump();
    expect(find.text('Por favor, ingresa un nombre de usuario'), findsOneWidget);
  });

  testWidgets('Llama a recoverPassword con correo válido', (WidgetTester tester) async {
    await pumpWithProvider(tester);

    const testEmail = 'marin.mmoises.456@gmail.com';
    when(mockUsersProvider.recoverPassword(testEmail))
      .thenAnswer((_) async => 'Correo enviado');
    await tester.enterText(find.byType(TextFormField), testEmail);
    await tester.tap(find.text('Restablecer contraseña'));
    await tester.pump();
    await tester.pump();

    verify(mockUsersProvider.recoverPassword(testEmail)).called(1);
  });
}