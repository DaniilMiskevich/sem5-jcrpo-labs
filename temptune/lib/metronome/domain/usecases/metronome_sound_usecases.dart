import "package:temptune/_common/domain/repos/storage_repo.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";

final class MetronomeSoundUsecases {
  MetronomeSoundUsecases(this._builtinStorage, this._customStorage);

  final ROStorageRepo<int, BuiltinMetronomeSoundMeta> _builtinStorage;
  final StorageRepo<int, CustomMetronomeSoundMeta> _customStorage;

  Future<MetronomeSoundMeta?> load(int id) async =>
      await _customStorage.load(id) ?? await _builtinStorage.load(id);

  Future<Iterable<int>> list() async => {
    ...await _customStorage.list(),
    ...await _builtinStorage.list(),
  };

  Future<void> save(MetronomeSoundMeta sound) async {
    if (sound is! CustomMetronomeSoundMeta) return;

    await _customStorage.save(
      sound.id ?? DateTime.now().millisecondsSinceEpoch,
      sound,
    );
  }

  Future<void> delete(MetronomeSoundMeta sound) async {
    if (sound is! CustomMetronomeSoundMeta) return;

    if (sound.id == null) return;
    await _customStorage.delete(sound.id!);
  }

  late Future<MetronomeSoundMeta> fallback = () async {
    final firstId = await _builtinStorage.list().then((ids) => ids.first);
    final fallbackSound = (await _builtinStorage.load(firstId))!;
    return fallbackSound;
  }();
}
