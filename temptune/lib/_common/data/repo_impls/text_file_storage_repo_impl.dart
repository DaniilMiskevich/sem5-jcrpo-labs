import "dart:io";

import "package:temptune/_common/domain/repos/storage_repo.dart";

class TextFileStorageRepoImpl implements StorageRepo<String, String> {
  TextFileStorageRepoImpl(this.basePath);

  final String basePath;

  @override
  Future<String?> load(String id) async {
    try {
      final str = await File("$basePath/$id").readAsString();
      return str;
    } on FileSystemException {
      return null;
    }
  }

  @override
  Future<Iterable<String>> list() async {
    try {
      final list = await Directory(basePath)
          .list()
          .where((entity) => entity is File)
          .map((entity) => entity.uri.pathSegments.last)
          .toList();
      return list;
    } on FileSystemException {
      return const Iterable.empty();
    }
  }

  @override
  Future<void> save(String id, String val) async {
    try {
      final file = File("$basePath/$id");
      await file.create(recursive: true);
      await file.writeAsString(val);
    } on FileSystemException {
      throw Exception("Saving failed!");
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final file = File("$basePath/$id");
      await file.delete();
    } on FileSystemException {
      // ignore
    }
  }
}
