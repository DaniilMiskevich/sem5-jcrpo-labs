class MetronomePresetFileStorageRepoImpl implements StorageRepo<int, Preset<MetronomeConfig>> {
  final TextFileStorageRepoImpl _fileStorage;

  MetronomePresetFileStorageRepoImpl(this._fileStorage);

  @override
  Future<Preset<MetronomeConfig>?> load(int id) async {
    final data = await _fileStorage.load(id.toString());
    if (data != null) {
      // Simple JSON parsing - in real app use proper serialization
      final json = Map<String, dynamic>.from(dart.convert.jsonDecode(data));
      return Preset<MetronomeConfig>(
        id: id,
        name: json['name'],
        settings: MetronomeConfig(
          bpm: json['bpm'],
          accentBeat: json['accentBeat'],
          soundId: json['soundId'],
        ),
      );
    }
    return null;
  }

  @override
  Future<Iterable<int>> list() async {
    final ids = await _fileStorage.list();
    return ids.map((id) => int.tryParse(id) ?? -1).where((id) => id != -1);
  }

  @override
  Future<void> save(int id, Preset<MetronomeConfig> val) async {
    final json = {
      'name': val.name,
      'bpm': val.settings.bpm,
      'accentBeat': val.settings.accentBeat,
      'soundId': val.settings.soundId,
    };
    await _fileStorage.save(id.toString(), dart.convert.jsonEncode(json));
  }

  @override
  Future<void> delete(int id) async {
    await _fileStorage.delete(id.toString());
  }
}

