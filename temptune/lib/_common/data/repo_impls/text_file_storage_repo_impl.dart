import 'dart:io';
import 'dart:typed_data';

class TextFileStorageRepoImpl implements StorageRepo<String, String> {
  final String basePath;

  TextFileStorageRepoImpl(this.basePath);

  @override
  Future<String?> load(String id) async {
    try {
      final file = File('$basePath/$id');
      if (await file.exists()) {
        return await file.readAsString();
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
  Future<void> save(String id, String val) async {
    final file = File('$basePath/$id');
    await file.create(recursive: true);
    await file.writeAsString(val);
  }

  @override
  Future<void> delete(String id) async {
    final file = File('$basePath/$id');
    if (await file.exists()) {
      await file.delete();
    }
  }
}

