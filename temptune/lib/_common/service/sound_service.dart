import "package:minisound/engine_flutter.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";
import "package:temptune/metronome/domain/usecases/metronome_sound_usecases.dart";
import "package:temptune/tuner/domain/entities/tuner_config.dart";

final class SoundService {
  SoundService(this.metronomeSoundUsecases);

  final _engine = Engine();

  Future<void> init() => _engine.init().then((_) => _engine.start());

  final MetronomeSoundUsecases metronomeSoundUsecases;

  LoadedSound? _metronomeSound;

  Future<void> updateMetronomeConfig(MetronomeConfig config) async {
    final sound =
        (config.soundId == null
            ? null
            : await metronomeSoundUsecases.load(config.soundId!)) ??
        await metronomeSoundUsecases.fallback;

    final metronomeSound = await switch (sound) {
      BuiltinMetronomeSoundMeta(:final assetPath) => _engine.loadSoundAsset(
        assetPath,
      ),
      CustomMetronomeSoundMeta(:final data) => _engine.loadSound(data),
    };
    metronomeSound.playLooped(
      delay:
          Duration(milliseconds: 60000 ~/ config.bpm) - metronomeSound.duration,
    );
    _metronomeSound?.stop();
    _metronomeSound = metronomeSound;
  }

  void startMetronome() {}

  void stopMetronome() {
    _metronomeSound?.stop();
    _metronomeSound = null;
  }

  late final WaveformSound _tunerSound = _engine.genWaveform(WaveformType.sine);
  void startTuner() => _tunerSound.play();
  void stopTuner() => _tunerSound.stop();
  void updateTunerConfig(TunerConfig config) {
    _tunerSound.type = config.waveType;
    _tunerSound.freq = config.freq;
    _tunerSound.volume = config.volume;
  }
}
