import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test/common/environment.dart';

void main() {
  group('Environment', () {
    group('Constantes de aplicación', skip: false, () {
      test('appName tiene el valor correcto', () {
        // Arrange & Act
        final appName = Environment.appName;

        // Assert
        expect(appName, 'Unit Testing Demo');
        expect(appName, isNotEmpty);
        expect(appName, isA<String>());
      });

      test('appName no está vacío', () {
        // Arrange & Act
        final appName = Environment.appName;

        // Assert
        expect(appName.isNotEmpty, true);
      });
    });

    group('Mensajes de bienvenida', skip: false, () {
      test('welcomeTitle contiene el texto correcto', () {
        // Arrange & Act
        final welcomeTitle = Environment.welcomeTitle;

        // Assert
        expect(welcomeTitle, 'Welcome');
        expect(welcomeTitle, isNotEmpty);
      });

      test('welcomeDescription contiene el texto correcto', () {
        // Arrange & Act
        final welcomeDescription = Environment.welcomeDescription;

        // Assert
        expect(welcomeDescription, 'to Unit Testing in Flutter!');
        expect(welcomeDescription, isNotEmpty);
      });

      test('mensajes de bienvenida son diferentes', () {
        // Arrange & Act
        final title = Environment.welcomeTitle;
        final description = Environment.welcomeDescription;

        // Assert
        expect(title, isNot(equals(description)));
      });

      test('mensajes combinados forman oración completa', () {
        // Arrange
        final title = Environment.welcomeTitle;
        final description = Environment.welcomeDescription;

        // Act
        final fullMessage = '$title $description';

        // Assert
        expect(fullMessage, 'Welcome to Unit Testing in Flutter!');
        expect(fullMessage, contains('Welcome'));
        expect(fullMessage, contains('Flutter'));
      });
    });

    group('Versión de la aplicación', () {
      test('appVersion tiene formato semántico válido', () {
        // Arrange & Act
        final version = Environment.appVersion;

        // Assert
        expect(version, '1.0.0');
        expect(version, matches(RegExp(r'^\d+\.\d+\.\d+$')));
      });

      test('appVersion no está vacío', () {
        // Arrange & Act
        final version = Environment.appVersion;

        // Assert
        expect(version.isNotEmpty, true);
      });

      test('appVersion contiene solo números y puntos', () {
        // Arrange & Act
        final version = Environment.appVersion;

        // Assert
        expect(version, matches(RegExp(r'^[\d.]+$')));
      });

      test('appVersion tiene exactamente 3 partes separadas por puntos', () {
        // Arrange & Act
        final version = Environment.appVersion;
        final parts = version.split('.');

        // Assert
        expect(parts.length, 3);
        expect(parts[0], '1'); // Major version
        expect(parts[1], '0'); // Minor version
        expect(parts[2], '0'); // Patch version
      });
    });

    group('Tipos de datos', () {
      test('todas las constantes son String', () {
        // Arrange & Act & Assert
        expect(Environment.appName, isA<String>());
        expect(Environment.welcomeTitle, isA<String>());
        expect(Environment.welcomeDescription, isA<String>());
        expect(Environment.appVersion, isA<String>());
      });
    });

    group('Inmutabilidad', () {
      test('todas las constantes son static const', () {
        // Arrange & Act
        final name1 = Environment.appName;
        final name2 = Environment.appName;

        // Assert
        expect(identical(name1, name2), true);
      });

      test('valores no cambian entre accesos', () {
        // Arrange
        final version1 = Environment.appVersion;

        // Act
        final version2 = Environment.appVersion;

        // Assert
        expect(version1, version2);
        expect(identical(version1, version2), true);
      });
    });

    group('Validaciones de contenido', () {
      test('ninguna constante contiene valores nulos o vacíos', () {
        // Arrange & Act & Assert
        expect(Environment.appName, isNotNull);
        expect(Environment.appName, isNotEmpty);

        expect(Environment.welcomeTitle, isNotNull);
        expect(Environment.welcomeTitle, isNotEmpty);

        expect(Environment.welcomeDescription, isNotNull);
        expect(Environment.welcomeDescription, isNotEmpty);

        expect(Environment.appVersion, isNotNull);
        expect(Environment.appVersion, isNotEmpty);
      });

      test('texto de bienvenida no contiene caracteres especiales inválidos', () {
        // Arrange & Act
        final title = Environment.welcomeTitle;
        final description = Environment.welcomeDescription;

        // Assert
        expect(title, isNot(contains('<')));
        expect(title, isNot(contains('>')));
        expect(description, isNot(contains('<')));
        expect(description, isNot(contains('>')));
      });
    });
  });
}
