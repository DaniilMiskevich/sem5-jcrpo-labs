import "package:minisound/engine.dart";
import "package:temptune/_common/data/repo_impls/bin_file_storage_repo_impl.dart";
import "package:temptune/_common/data/repo_impls/text_file_storage_repo_impl.dart";
import "package:temptune/metronome/data/repo_impls/metronome_sound_file_storage_repo_impl.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";
import "package:temptune/tuner/domain/entities/tuner_config.dart";

final class SoundService {
  final _engine = Engine();

  Future<void> init() => _engine.init().then((_) => _engine.start());

  // TODO! bad
  final storage = MetronomeSoundFileStorageRepoImpl(
    BinFileStorageRepoImpl("build/userdata/sounds/bin/"),
    TextFileStorageRepoImpl("build/userdata/sounds/txt/"),
  );

  LoadedSound? _metronomeSound;

  Future<void> startMetronome(MetronomeConfig config) async {
    if (_metronomeSound != null) return;

    final metronomeSoundInfo = await storage.load(config.soundId!);
    if (metronomeSoundInfo == null) return;
    final metronomeSound = await _engine.loadSound(metronomeSoundInfo.data);
    _metronomeSound = metronomeSound;
  }

  void stopMetronome() {
    _metronomeSound?.stop();
    _metronomeSound = null;
  }

  GeneratedSound? _tunerSound;

  void startTuner(TunerConfig config) {
    if (_tunerSound != null) return;

    final tunerSound = _engine.genWaveform(config.waveType, freq: config.freq);
    tunerSound.volume = config.volume;
    tunerSound.play();
    _tunerSound = tunerSound;
  }

  void stopTuner() {
    _tunerSound?.stop();
    _tunerSound = null;
  }
}
