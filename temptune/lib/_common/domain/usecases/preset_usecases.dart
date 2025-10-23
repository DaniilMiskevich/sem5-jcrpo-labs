class PresetUsecases<T extends Preset> {
  PresetUsecases(this._storage);

  final StorageRepo<int, T> _storage;

  Future<T?> load(int id) => _storage.load(id);

  Future<Iterable<int>> list() => _storage.list();

  Future<void> save(T preset) async {
    final id = preset.id ?? DateTime.now().millisecondsSinceEpoch;
    await _storage.save(id, preset);
  }

  Future<void> delete(T preset) async {
    if (preset.id != null) {
      await _storage.delete(preset.id!);
    }
  }
}

