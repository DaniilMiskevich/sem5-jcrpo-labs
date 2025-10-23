class Preset<T> {
  Preset({this.id, required this.name, required this.settings});

  final int? id;
  String name;
  T settings;
}

