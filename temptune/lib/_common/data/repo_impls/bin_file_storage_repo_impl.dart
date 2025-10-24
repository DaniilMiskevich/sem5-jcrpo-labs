import "dart:io";
import "dart:typed_data";

import "package:temptune/_common/domain/repos/storage_repo.dart";

class BinFileStorageRepoImpl implements StorageRepo<String, Uint8List> {
  BinFileStorageRepoImpl(this.basePath);

  final String basePath;

  @override
  Future<Uint8List?> load(String id) async {
    try {
      final file = File("$basePath/$id");
      return await file.readAsBytes();
    } on FileSystemException {
      return null;
    }
  }

  @override
  Future<Iterable<String>> list() async {
    final dir = Directory(basePath);
    try {
      return dir
          .list()
          .where((entity) => entity is File)
          .map((entity) => entity.uri.pathSegments.last)
          .toList();
    } on FileSystemException {
      return const Iterable.empty();
    }
  }

  @override
  Future<void> save(String id, Uint8List val) async {
    try {
      final file = File("$basePath/$id");
      await file.create(recursive: true);
      await file.writeAsBytes(val);
    } on FileSystemException {
      throw Exception("Saving failed!");
    }
  }

  @override
  Future<void> delete(String id) async {
    final file = File("$basePath/$id");
    try {
      await file.delete();
    } on FileSystemException {
      // ignore
    }
  }
}
