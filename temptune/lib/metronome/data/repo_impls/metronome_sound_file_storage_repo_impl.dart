class MetronomeSoundFileStorageRepoImpl implements StorageRepo<int, MetronomeSound> {
  final BinFileStorageRepoImpl _fileStorage;

  MetronomeSoundFileStorageRepoImpl(this._fileStorage);

  @override
  Future<MetronomeSound?> load(int id) async {
    final data = await _fileStorage.load('$id.data');
    final metaData = await _fileStorage.load('$id.meta');
    if (data != null && metaData != null) {
      final json = Map<String, dynamic>.from(dart.convert.jsonDecode(metaData));
      return MetronomeSound(
        id: id,
        name: json['name'],
        data: data,
        isProtected: json['isProtected'] ?? false,
      );
    }
    return null;
  }

  @override
  Future<Iterable<int>> list() async {
    final files = await _fileStorage.list();
    return files.where((f) => f.endsWith('.meta')).map((f) => int.tryParse(f.split('.')[0]) ?? -1).where((id) => id != -1);
  }

  @override
  Future<void> save(int id, MetronomeSound val) async {
    await _fileStorage.save('$id.data', val.data);
    final meta = {
      'name': val.name,
      'isProtected': val.isProtected,
    };
    await _fileStorage.save('$id.meta', dart.convert.jsonEncode(meta));
  }

  @override
  Future<void> delete(int id) async {
    await _fileStorage.delete('$id.data');
    await _fileStorage.delete('$id.meta');
  }
}

