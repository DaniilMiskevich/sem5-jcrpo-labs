import "dart:typed_data";

enum MetronomeSoundType { builtin, custom }

sealed class MetronomeSoundMeta {
  MetronomeSoundMeta({this.id, required this.name});

  final int? id;
  String name;

  @override
  bool operator ==(Object other) =>
      other is MetronomeSoundMeta && id != null && other.id == id;

  @override
  int get hashCode => Object.hash(id ?? super.hashCode, null);
}

final class BuiltinMetronomeSoundMeta extends MetronomeSoundMeta {
  BuiltinMetronomeSoundMeta({
    super.id,
    required super.name,
    required this.assetPath,
  });

  final String assetPath;
}

final class CustomMetronomeSoundMeta extends MetronomeSoundMeta {
  CustomMetronomeSoundMeta({super.id, required super.name, required this.data});

  final Uint8List data;
}
