import 'package:unit_test/data/models/version_model.dart';

/// Interfaz abstracta del repositorio de versión
/// Esta interfaz permite crear mocks fácilmente para testing
abstract class VersionRepository {
  /// Guarda la versión en la base de datos
  Future<void> saveVersion(VersionModel version);

  /// Obtiene la versión almacenada en la base de datos
  Future<VersionModel?> getVersion();

  /// Elimina la versión de la base de datos
  Future<void> deleteVersion();
}
