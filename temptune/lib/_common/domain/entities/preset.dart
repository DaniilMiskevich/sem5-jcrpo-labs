class Preset<T> {
  Preset({this.id, required this.name, required this.val});

  final int? id;
  String name;
  T val;

  Preset<T> withId(int id) => Preset<T>(id: id, name: name, val: val);

  @override
  bool operator ==(Object other) =>
      other is Preset<T> && id != null && other.id == id;

  @override
  int get hashCode => Object.hash(id ?? super.hashCode, null);
}
