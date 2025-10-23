class MetronomeSoundUsecases {
  MetronomeSoundUsecases(this._builtin, this._customStorage);

  final Map<int, MetronomeSound> _builtin;
  final StorageRepo<int, MetronomeSound> _customStorage;

  Future<MetronomeSound?> load(int id) async {
    if (_builtin.containsKey(id)) {
      return _builtin[id];
    }
    return _customStorage.load(id);
  }

  Future<Iterable<int>> list() async {
    final builtinIds = _builtin.keys;
    final customIds = await _customStorage.list();
    return [...builtinIds, ...customIds];
  }

  Future<void> save(MetronomeSound sound) async {
    if (sound.isProtected) {
      throw Exception('Cannot modify protected sounds');
    }
    final id = sound.id ?? DateTime.now().millisecondsSinceEpoch;
    await _customStorage.save(id, sound);
  }

  Future<void> delete(MetronomeSound sound) async {
    if (sound.isProtected) {
      throw Exception('Cannot delete protected sounds');
    }
    if (sound.id != null) {
      await _customStorage.delete(sound.id!);
    }
  }

  Future<MetronomeSound> fallback() async {
    return _builtin.values.first;
  }
}

