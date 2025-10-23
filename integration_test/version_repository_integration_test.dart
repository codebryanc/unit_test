import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:unit_test/data/models/version_model.dart';
import 'package:unit_test/data/repositories/version_repository_impl.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('VersionRepository Integration Tests con BD Real', () {
    late VersionRepositoryImpl repository;

    setUp(() async {
      // Arrange - Crear instancia del repositorio REAL
      repository = VersionRepositoryImpl();

      // Limpiar la base de datos antes de cada test
      await repository.deleteVersion();
    });

    tearDown(() async {
      // Limpiar después de cada test
      await repository.deleteVersion();
      await repository.close();
    });

    testWidgets('puede guardar y recuperar versión de BD real', (tester) async {
      // Arrange
      final version = VersionModel(
        version: '1.0.0',
        lastUpdated: DateTime(2024, 10, 22),
      );

      // Act
      await repository.saveVersion(version);
      final result = await repository.getVersion();

      // Assert
      expect(result, isNotNull);
      expect(result?.version, '1.0.0');
      expect(result?.lastUpdated, DateTime(2024, 10, 22));
    });

    testWidgets('devuelve null cuando no hay versión en BD', (tester) async {
      // Arrange & Act
      final result = await repository.getVersion();

      // Assert
      expect(result, isNull);
    });

    testWidgets('puede actualizar versión existente en BD', (tester) async {
      // Arrange
      final version1 = VersionModel(
        version: '1.0.0',
        lastUpdated: DateTime(2024, 1, 1),
      );
      final version2 = VersionModel(
        version: '2.0.0',
        lastUpdated: DateTime(2024, 10, 22),
      );

      // Act
      await repository.saveVersion(version1);
      await repository.saveVersion(version2);
      final result = await repository.getVersion();

      // Assert
      expect(result?.version, '2.0.0');
      expect(result?.lastUpdated, DateTime(2024, 10, 22));
    });

    testWidgets('puede eliminar versión de BD real', (tester) async {
      // Arrange
      final version = VersionModel(
        version: '1.0.0',
        lastUpdated: DateTime.now(),
      );
      await repository.saveVersion(version);

      // Act
      await repository.deleteVersion();
      final result = await repository.getVersion();

      // Assert
      expect(result, isNull);
    });

    testWidgets('persiste datos después de cerrar y reabrir conexión', (tester) async {
      // Arrange
      final version = VersionModel(
        version: '3.5.2',
        lastUpdated: DateTime(2024, 5, 15),
      );

      // Act - Guardar, cerrar y reabrir
      await repository.saveVersion(version);
      await repository.close();

      // Crear nueva instancia (simula reabrir la app)
      final newRepository = VersionRepositoryImpl();
      final result = await newRepository.getVersion();
      await newRepository.close();

      // Assert - Los datos deben persistir
      expect(result, isNotNull);
      expect(result?.version, '3.5.2');
      expect(result?.lastUpdated, DateTime(2024, 5, 15));
    });

    testWidgets('mantiene integridad de datos con múltiples operaciones', (tester) async {
      // Arrange
      final versions = [
        VersionModel(version: '1.0.0', lastUpdated: DateTime(2024, 1, 1)),
        VersionModel(version: '1.1.0', lastUpdated: DateTime(2024, 2, 1)),
        VersionModel(version: '1.2.0', lastUpdated: DateTime(2024, 3, 1)),
        VersionModel(version: '2.0.0', lastUpdated: DateTime(2024, 4, 1)),
      ];

      // Act - Guardar múltiples versiones secuencialmente
      for (var version in versions) {
        await repository.saveVersion(version);
        final saved = await repository.getVersion();

        // Assert - Cada guardado debe ser correcto
        expect(saved?.version, version.version);
        expect(saved?.lastUpdated, version.lastUpdated);
      }

      // Assert final - Solo debe quedar la última versión
      final finalResult = await repository.getVersion();
      expect(finalResult?.version, '2.0.0');
    });

    testWidgets('guarda correctamente fechas con hora específica', (tester) async {
      // Arrange
      final exactDate = DateTime(2024, 10, 22, 14, 30, 45, 123);
      final version = VersionModel(
        version: '1.0.0',
        lastUpdated: exactDate,
      );

      // Act
      await repository.saveVersion(version);
      final result = await repository.getVersion();

      // Assert - La fecha debe ser exacta (puede perder microsegundos)
      expect(result?.lastUpdated.year, exactDate.year);
      expect(result?.lastUpdated.month, exactDate.month);
      expect(result?.lastUpdated.day, exactDate.day);
      expect(result?.lastUpdated.hour, exactDate.hour);
      expect(result?.lastUpdated.minute, exactDate.minute);
      expect(result?.lastUpdated.second, exactDate.second);
    });

    testWidgets('maneja versiones con formato especial', (tester) async {
      // Arrange
      final specialVersions = [
        '1.0.0-beta',
        '2.0.0-alpha.1',
        '3.0.0+build.123',
        '0.0.1-rc.1+20240101',
      ];

      // Act & Assert
      for (var versionString in specialVersions) {
        final version = VersionModel(
          version: versionString,
          lastUpdated: DateTime.now(),
        );

        await repository.saveVersion(version);
        final result = await repository.getVersion();

        expect(result?.version, versionString);
      }
    });

    testWidgets('operaciones de BD son asíncronas', (tester) async {
      // Arrange
      final version = VersionModel(
        version: '1.0.0',
        lastUpdated: DateTime.now(),
      );

      // Act - Operaciones deben ser Future
      final saveFuture = repository.saveVersion(version);
      expect(saveFuture, isA<Future<void>>());
      await saveFuture;

      final getFuture = repository.getVersion();
      expect(getFuture, isA<Future<VersionModel?>>());
      await getFuture;

      final deleteFuture = repository.deleteVersion();
      expect(deleteFuture, isA<Future<void>>());
      await deleteFuture;
    });
  });
}
