import 'package:unit_test/data/models/version_model.dart';
import 'package:unit_test/data/repositories/version_repository.dart';

/// Mock del repositorio de versión para usar en pruebas unitarias
/// Este mock NO usa base de datos real, solo almacena en memoria
class MockVersionRepository implements VersionRepository {
  VersionModel? _storedVersion;

  @override
  Future<void> saveVersion(VersionModel version) async {
    // Simula un pequeño delay como si fuera una BD real
    await Future.delayed(const Duration(milliseconds: 10));
    _storedVersion = version;
  }

  @override
  Future<VersionModel?> getVersion() async {
    // Simula un pequeño delay como si fuera una BD real
    await Future.delayed(const Duration(milliseconds: 10));
    return _storedVersion;
  }

  @override
  Future<void> deleteVersion() async {
    // Simula un pequeño delay como si fuera una BD real
    await Future.delayed(const Duration(milliseconds: 10));
    _storedVersion = null;
  }

  /// Método útil para testing: resetear el estado
  void reset() {
    _storedVersion = null;
  }
}
