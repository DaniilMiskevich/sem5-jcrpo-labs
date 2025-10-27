import "dart:async";

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

  ({MetronomeSoundMeta meta, LoadedSound loadedSound})? _metronomeSound;
  ({bool isPlaying, Timer timer})? _metronome;
  void startMetronome() => _metronome = _metronome == null
      ? null
      : (isPlaying: true, timer: _metronome!.timer);
  void stopMetronome() => _metronome = _metronome == null
      ? null
      : (isPlaying: false, timer: _metronome!.timer);
  Future<void> updateMetronomeConfig(MetronomeConfig config) async {
    final sound =
        (config.soundId == null
            ? null
            : await metronomeSoundUsecases.load(config.soundId!)) ??
        await metronomeSoundUsecases.fallback;
    if (_metronomeSound?.meta != sound) {
      final loadedSound = await switch (sound) {
        BuiltinMetronomeSoundMeta(:final assetPath) => _engine.loadSoundAsset(
          assetPath,
        ),
        CustomMetronomeSoundMeta(:final data) => _engine.loadSound(data),
      };
      _metronomeSound = (meta: sound, loadedSound: loadedSound);
    }

    _metronome?.timer.cancel();
    _metronome = (
      isPlaying: _metronome?.isPlaying ?? false,
      timer: Timer.periodic(Duration(microseconds: 60000000 ~/ config.bpm), (
        t,
      ) {
        if (!(_metronome?.isPlaying ?? false)) return;

        final sound = _metronomeSound?.loadedSound;
        if (sound == null) return;

        sound.volume =
            config.accentBeat != 0 && (t.tick - 1) % config.accentBeat == 0
            ? 1
            : 0.5;
        sound.play();
      }),
    );
  }

  late final _tunerSound = _engine.genWaveform(WaveformType.sine);
  void startTuner() => _tunerSound.play();
  void stopTuner() => _tunerSound.stop();
  void updateTunerConfig(TunerConfig config) {
    _tunerSound.type = config.waveType;
    _tunerSound.freq = config.freq;
    _tunerSound.volume = config.volume;
  }
}
