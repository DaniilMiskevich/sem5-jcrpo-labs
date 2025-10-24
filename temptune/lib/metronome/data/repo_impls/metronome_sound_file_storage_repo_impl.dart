import "dart:convert";

import "package:temptune/_common/data/repo_impls/bin_file_storage_repo_impl.dart";
import "package:temptune/_common/data/repo_impls/text_file_storage_repo_impl.dart";
import "package:temptune/_common/domain/repos/storage_repo.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";

class MetronomeSoundFileStorageRepoImpl
    implements StorageRepo<int, MetronomeSound> {
  MetronomeSoundFileStorageRepoImpl(this._binFileStorage, this._fileStorage);

  final BinFileStorageRepoImpl _binFileStorage;
  final TextFileStorageRepoImpl _fileStorage;

  @override
  Future<MetronomeSound?> load(int id) async {
    final meta = await _fileStorage.load(id.toString());
    final data = await _binFileStorage.load(id.toString());
    if (meta == null || data == null) return null;

    final {"name": String name} = jsonDecode(meta) as Map;
    return MetronomeSound(id: id, name: name, data: data);
  }

  @override
  Future<Iterable<int>> list() async {
    final files = await _fileStorage.list();
    try {
      return files.map(int.parse);
    } on FormatException {
      return const Iterable.empty();
    }
  }

  @override
  Future<void> save(int id, MetronomeSound val) async {
    await _fileStorage.save(id.toString(), jsonEncode({"name": val.name}));
    await _binFileStorage.save(id.toString(), val.data);
  }

  @override
  Future<void> delete(int id) async {
    await _fileStorage.delete(id.toString());
    await _binFileStorage.delete(id.toString());
  }
}
