import "package:temptune/_common/domain/entities/preset.dart";
import "package:temptune/_common/domain/repos/storage_repo.dart";

final class PresetUsecases<T> {
  PresetUsecases(this._storage);

  StorageRepo<int, Preset<T>> _storage;

  Future<void> updateStorage(StorageRepo<int, Preset<T>> newStorage) async {
    final ids = await list();
    final oldPresets = await Future.wait(ids.map(load));

    _storage = newStorage;

    await Future.wait(oldPresets.whereType<Preset<T>>().map(save));
  }

  Future<Preset<T>?> load(int id) => _storage.load(id);

  Future<Iterable<int>> list() => _storage.list();

  Future<Preset<T>> save(Preset<T> preset) async {
    // ignore: parameter_assignments
    preset = Preset(
      id: preset.id ?? DateTime.now().millisecondsSinceEpoch,
      name: preset.name,
      val: preset.val,
    );

    await _storage.save(preset.id!, preset);
    return preset;
  }

  Future<void> delete(Preset<T> preset) async {
    if (preset.id == null) return;
    await _storage.delete(preset.id!);
  }
}
