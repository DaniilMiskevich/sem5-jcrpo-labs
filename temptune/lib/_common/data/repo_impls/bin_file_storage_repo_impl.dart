class BinFileStorageRepoImpl implements StorageRepo<String, Uint8List> {
  final String basePath;

  BinFileStorageRepoImpl(this.basePath);

  @override
  Future<Uint8List?> load(String id) async {
    try {
      final file = File('$basePath/$id');
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Iterable<String>> list() async {
    final dir = Directory(basePath);
    if (await dir.exists()) {
      return dir.list().where((entity) => entity is File).map((entity) => entity.uri.pathSegments.last);
    }
    return [];
  }

  @override
  Future<void> save(String id, Uint8List val) async {
    final file = File('$basePath/$id');
    await file.create(recursive: true);
    await file.writeAsBytes(val);
  }

  @override
  Future<void> delete(String id) async {
    final file = File('$basePath/$id');
    if (await file.exists()) {
      await file.delete();
    }
  }
}

