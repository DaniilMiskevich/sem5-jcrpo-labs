import "package:minisound/engine.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";
import "package:temptune/metronome/domain/usecases/metronome_sound_usecases.dart";
import "package:temptune/tuner/domain/entities/tuner_config.dart";

final class SoundService {
  SoundService(this.metronomeSoundUsecases);

  final _engine = Engine();

  Future<void> init() => _engine.init().then((_) => _engine.start());

  final MetronomeSoundUsecases metronomeSoundUsecases;

  LoadedSound? _metronomeSound;

  Future<void> updateMetronomeConfig(MetronomeConfig config) async {
    // final metronomeSoundInfo = await storage.load(config.soundId!);
    // if (metronomeSoundInfo == null) return;
    // final metronomeSound = await _engine.loadSound(metronomeSoundInfo.data);
    // _metronomeSound = metronomeSound;
  }

  void startMetronome() {
    if (_metronomeSound != null) return;
  }

  void stopMetronome() {
    _metronomeSound?.stop();
    _metronomeSound = null;
  }

  GeneratedSound? _tunerSound;

  void updateTunerConfig(TunerConfig config) {
    _tunerSound ??= _engine.genWaveform(config.waveType, freq: config.freq);
    _tunerSound!.volume = config.volume;
  }

  void startTuner() {
    _tunerSound?.play();
  }

  void stopTuner() {
    _tunerSound?.stop();
    _tunerSound = null;
  }
}
