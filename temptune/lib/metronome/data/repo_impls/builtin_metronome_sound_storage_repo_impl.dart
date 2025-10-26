import "package:temptune/_common/domain/repos/storage_repo.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";

class BuiltinMetronomeSoundStorageRepoImpl
    implements ROStorageRepo<int, BuiltinMetronomeSoundMeta> {
  BuiltinMetronomeSoundStorageRepoImpl(
    Iterable<BuiltinMetronomeSoundMeta> builtinSounds,
  ) : builtinSounds = Map.fromEntries(
        builtinSounds.indexed.map(
          (t) => MapEntry(
            t.$1,
            BuiltinMetronomeSoundMeta(
              id: t.$1,
              name: t.$2.name,
              assetPath: t.$2.assetPath,
            ),
          ),
        ),
      );

  final Map<int, BuiltinMetronomeSoundMeta> builtinSounds;

  @override
  Future<BuiltinMetronomeSoundMeta?> load(int id) =>
      Future.value(builtinSounds[id]);

  @override
  Future<Iterable<int>> list() => Future.value(builtinSounds.keys);
}
