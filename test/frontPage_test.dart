import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:balanced_foods/screens/front_page_screen.dart';
import 'package:balanced_foods/screens/login_screen.dart';
import 'package:balanced_foods/screens/new_user_screen.dart';

void main() {
  testWidgets('FrontPage navigates to Login and Register screens', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: FrontPage()),
    );

    // Verifica que el texto de los botones esté presente
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.text('Registrarse'), findsOneWidget);

    // Prueba navegación al LoginScreen
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle(); // Espera la animación

    expect(find.byType(LoginScreen), findsOneWidget);

    // Volver atrás para probar el otro botón
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // Prueba navegación al NewUserScreen
    await tester.tap(find.text('Registrarse'));
    await tester.pumpAndSettle();

    expect(find.byType(NewUserScreen), findsOneWidget);
  });
}
