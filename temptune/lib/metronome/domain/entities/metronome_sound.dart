class MetronomeSound {
  MetronomeSound({this.id, required this.name, required this.data, this.isProtected = false});
  
  MetronomeSound.fromAsset({this.id, required this.name, String assetPath, this.isProtected = true}) 
    : data = Uint8List(rootBundle.load(assetPath));

  final int? id;
  String name;
  Uint8List data;
  final bool isProtected;
}
