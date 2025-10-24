import "package:flutter/services.dart";

final class MetronomeSound {
  MetronomeSound({
    this.id,
    required this.name,
    required this.data,
    this.isProtected = false,
  });

  static Future<MetronomeSound> fromAsset({
    int? id,
    required String name,
    required String assetPath,
    bool isProtected = true,
  }) async => MetronomeSound(
    id: id,
    name: name,
    data: Uint8List.sublistView(await rootBundle.load(assetPath)),
  );

  final int? id;
  String name;
  Uint8List data;
  final bool isProtected;
}
