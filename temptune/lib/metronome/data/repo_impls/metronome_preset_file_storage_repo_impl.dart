import "dart:convert";

import "package:temptune/_common/data/repo_impls/text_file_storage_repo_impl.dart";
import "package:temptune/_common/domain/entities/preset.dart";
import "package:temptune/_common/domain/repos/storage_repo.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";

class MetronomePresetFileStorageRepoImpl
    implements StorageRepo<int, Preset<MetronomeConfig>> {
  MetronomePresetFileStorageRepoImpl(this._fileStorage);

  final StorageRepo<String, String> _fileStorage;

  @override
  Future<Preset<MetronomeConfig>?> load(int id) async {
    final data = await _fileStorage.load(id.toString());
    if (data == null) return null;

    final {
      "name": String name,
      "bpm": int bpm,
      "accent_beat": int accentBeat,
      "sound_id": int? soundId,
    } = jsonDecode(data) as Map;
    return Preset<MetronomeConfig>(
      id: id,
      name: name,
      val: MetronomeConfig(bpm: bpm, accentBeat: accentBeat, soundId: soundId),
    );
  }

  @override
  Future<Iterable<int>> list() async {
    final ids = await _fileStorage.list();
    try {
      return ids.map(int.parse);
    } on FormatException {
      return const Iterable.empty();
    }
  }

  @override
  Future<void> save(int id, Preset<MetronomeConfig> val) async =>
      _fileStorage.save(
        id.toString(),
        jsonEncode({
          "name": val.name,
          "bpm": val.val.bpm,
          "accent_beat": val.val.accentBeat,
          "sound_id": val.val.soundId,
        }),
      );

  @override
  Future<void> delete(int id) async => _fileStorage.delete(id.toString());
}
