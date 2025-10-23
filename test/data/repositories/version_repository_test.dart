import 'package:flutter_test/flutter_test.dart';
import 'package:unit_test/data/models/version_model.dart';
import 'package:unit_test/data/mocks/mock_version_repository.dart';

void main() {
  group('VersionRepository', () {
    late MockVersionRepository repository;

    setUp(() {
      // Se ejecuta antes de cada test
      repository = MockVersionRepository();
    });

    tearDown(() {
      // Se ejecuta después de cada test
      repository.reset();
    });

    group('Guardar versión', () {
      test('puede guardar una versión correctamente', () async {
        // Arrange
        final version = VersionModel(
          version: '1.0.0',
          lastUpdated: DateTime(2024, 1, 1),
        );

        // Act
        await repository.saveVersion(version);
        final result = await repository.getVersion();

        // Assert
        expect(result, isNotNull);
        expect(result?.version, '1.0.0');
        expect(result?.lastUpdated, DateTime(2024, 1, 1));
      });

      test('sobrescribe versión anterior al guardar nueva', () async {
        // Arrange
        final version1 = VersionModel(
          version: '1.0.0',
          lastUpdated: DateTime(2024, 1, 1),
        );
        final version2 = VersionModel(
          version: '2.0.0',
          lastUpdated: DateTime(2024, 2, 1),
        );

        // Act
        await repository.saveVersion(version1);
        await repository.saveVersion(version2);
        final result = await repository.getVersion();

        // Assert
        expect(result?.version, '2.0.0');
        expect(result?.lastUpdated, DateTime(2024, 2, 1));
      });
    });

    group('Obtener versión', () {
      test('devuelve null cuando no hay versión guardada', () async {
        // Arrange & Act
        final result = await repository.getVersion();

        // Assert
        expect(result, isNull);
      });

      test('devuelve la versión guardada correctamente', () async {
        // Arrange
        final version = VersionModel(
          version: '3.5.2',
          lastUpdated: DateTime(2024, 3, 15),
        );
        await repository.saveVersion(version);

        // Act
        final result = await repository.getVersion();

        // Assert
        expect(result, isNotNull);
        expect(result?.version, '3.5.2');
      });

      test('mantiene la versión después de múltiples lecturas', () async {
        // Arrange
        final version = VersionModel(
          version: '1.2.3',
          lastUpdated: DateTime(2024, 1, 1),
        );
        await repository.saveVersion(version);

        // Act
        final result1 = await repository.getVersion();
        final result2 = await repository.getVersion();
        final result3 = await repository.getVersion();

        // Assert
        expect(result1?.version, '1.2.3');
        expect(result2?.version, '1.2.3');
        expect(result3?.version, '1.2.3');
      });
    });

    group('Eliminar versión', () {
      test('elimina la versión guardada', () async {
        // Arrange
        final version = VersionModel(
          version: '1.0.0',
          lastUpdated: DateTime(2024, 1, 1),
        );
        await repository.saveVersion(version);

        // Act
        await repository.deleteVersion();
        final result = await repository.getVersion();

        // Assert
        expect(result, isNull);
      });

      test('no falla al eliminar cuando no hay versión', () async {
        // Arrange & Act & Assert
        expect(
          () async => await repository.deleteVersion(),
          returnsNormally,
        );
      });

      test('permite guardar nueva versión después de eliminar', () async {
        // Arrange
        final version1 = VersionModel(
          version: '1.0.0',
          lastUpdated: DateTime(2024, 1, 1),
        );
        final version2 = VersionModel(
          version: '2.0.0',
          lastUpdated: DateTime(2024, 2, 1),
        );

        // Act
        await repository.saveVersion(version1);
        await repository.deleteVersion();
        await repository.saveVersion(version2);
        final result = await repository.getVersion();

        // Assert
        expect(result?.version, '2.0.0');
      });
    });

    group('Validación de formato de versión', () {
      test('acepta versión en formato semántico', () async {
        // Arrange
        final version = VersionModel(
          version: '10.25.99',
          lastUpdated: DateTime.now(),
        );

        // Act
        await repository.saveVersion(version);
        final result = await repository.getVersion();

        // Assert
        expect(result?.version, matches(RegExp(r'^\d+\.\d+\.\d+$')));
      });

      test('preserva el formato exacto de la versión', () async {
        // Arrange
        final version = VersionModel(
          version: '0.0.1-beta',
          lastUpdated: DateTime.now(),
        );

        // Act
        await repository.saveVersion(version);
        final result = await repository.getVersion();

        // Assert
        expect(result?.version, '0.0.1-beta');
      });
    });

    group('Manejo de fechas', () {
      test('preserva la fecha y hora exacta', () async {
        // Arrange
        final now = DateTime(2024, 10, 22, 14, 30, 45);
        final version = VersionModel(
          version: '1.0.0',
          lastUpdated: now,
        );

        // Act
        await repository.saveVersion(version);
        final result = await repository.getVersion();

        // Assert
        expect(result?.lastUpdated, now);
      });

      test('puede guardar versiones con diferentes fechas', () async {
        // Arrange
        final date1 = DateTime(2024, 1, 1);
        final date2 = DateTime(2024, 12, 31);

        final version1 = VersionModel(version: '1.0.0', lastUpdated: date1);
        final version2 = VersionModel(version: '2.0.0', lastUpdated: date2);

        // Act
        await repository.saveVersion(version1);
        final result1 = await repository.getVersion();

        await repository.saveVersion(version2);
        final result2 = await repository.getVersion();

        // Assert
        expect(result1?.lastUpdated, date1);
        expect(result2?.lastUpdated, date2);
      });
    });
  });
}
