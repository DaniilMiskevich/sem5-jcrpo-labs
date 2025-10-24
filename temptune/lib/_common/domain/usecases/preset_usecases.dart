import "package:temptune/_common/domain/entities/preset.dart";
import "package:temptune/_common/domain/repos/storage_repo.dart";

final class PresetUsecases<T extends Preset> {
  PresetUsecases(this._storage);

  final StorageRepo<int, T> _storage;

  Future<T?> load(int id) => _storage.load(id);

  Future<Iterable<int>> list() => _storage.list();

  Future<void> save(T preset) async =>
      _storage.save(preset.id ?? DateTime.now().millisecondsSinceEpoch, preset);

  Future<void> delete(T preset) async {
    if (preset.id == null) return;
    await _storage.delete(preset.id!);
  }
}
