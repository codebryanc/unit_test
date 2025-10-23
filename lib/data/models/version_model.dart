class VersionModel {
  final String version;
  final DateTime lastUpdated;

  VersionModel({
    required this.version,
    required this.lastUpdated,
  });

  // Convertir a JSON para almacenar en BD
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Crear desde JSON (leer de BD)
  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      version: json['version'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  @override
  String toString() => 'VersionModel(version: $version, lastUpdated: $lastUpdated)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VersionModel &&
        other.version == version &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode => version.hashCode ^ lastUpdated.hashCode;
}
