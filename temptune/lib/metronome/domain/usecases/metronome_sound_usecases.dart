import "package:temptune/_common/domain/repos/storage_repo.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";

final class MetronomeSoundUsecases {
  MetronomeSoundUsecases(this._builtin, this._customStorage);

  final Map<int, MetronomeSound> _builtin;
  final StorageRepo<int, MetronomeSound> _customStorage;

  Future<MetronomeSound?> load(int id) async =>
      await _customStorage.load(id) ?? _builtin[id];

  Future<Iterable<int>> list() async => [
    ..._builtin.keys,
    ...await _customStorage.list(),
  ];

  Future<void> save(MetronomeSound sound) async {
    if (sound.isProtected) throw Exception("Cannot modify protected sounds.");
    await _customStorage.save(sound.id, sound);
  }

  Future<void> delete(MetronomeSound sound) async {
    if (sound.isProtected) throw Exception("Cannot delete protected sounds.");
    await _customStorage.delete(sound.id);
  }

  Future<MetronomeSound> fallback() => Future.value(_builtin.values.first);
}
