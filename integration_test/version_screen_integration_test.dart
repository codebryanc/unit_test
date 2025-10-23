import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:unit_test/features/version/version_screen.dart';
import 'package:unit_test/common/environment.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('VersionScreen Integration Tests', () {
    testWidgets('muestra correctamente el título de bienvenida', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(Environment.welcomeTitle), findsOneWidget);
      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('muestra correctamente la descripción de bienvenida', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(Environment.welcomeDescription), findsOneWidget);
      expect(find.text('to Unit Testing in Flutter!'), findsOneWidget);
    });

    testWidgets('muestra correctamente el número de versión', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Versión ${Environment.appVersion}'), findsOneWidget);
      expect(find.text('Versión 1.0.0'), findsOneWidget);
    });

    testWidgets('usa Material widget con fondo blanco', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final materialWidget = tester.widget<Material>(find.byType(Material).first);
      expect(materialWidget.color, Colors.white);
    });

    testWidgets('muestra todos los elementos en pantalla', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Verificar que todos los elementos están visibles
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('to Unit Testing in Flutter!'), findsOneWidget);
      expect(find.textContaining('Versión'), findsOneWidget);
    });

    testWidgets('tiene el espaciado correcto entre elementos', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Verificar que hay SizedBox entre elementos
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('respeta el SafeArea', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('los textos están centrados', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('tiene padding horizontal de 42px', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Verificar que existe un Padding widget con horizontal de 42
      final paddingWidgets = find.byType(Padding);
      expect(paddingWidgets, findsWidgets);

      // Buscar el padding correcto (el que configuramos nosotros)
      bool foundCorrectPadding = false;
      for (var element in paddingWidgets.evaluate()) {
        final widget = element.widget as Padding;
        if (widget.padding is EdgeInsets) {
          final edgeInsets = widget.padding as EdgeInsets;
          if (edgeInsets.left == 42.0 && edgeInsets.right == 42.0) {
            foundCorrectPadding = true;
            break;
          }
        }
      }
      expect(foundCorrectPadding, true);
    });

    testWidgets('renderiza sin errores', (tester) async {
      // Arrange & Act & Assert
      await tester.pumpWidget(
        const MaterialApp(
          home: VersionScreen(),
        ),
      );

      // No debe haber errores de renderizado
      expect(tester.takeException(), isNull);
    });
  });
}
