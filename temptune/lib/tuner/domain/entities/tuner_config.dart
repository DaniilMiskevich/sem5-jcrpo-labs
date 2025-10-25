import "package:minisound/engine.dart";
import "package:temptune/tuner/domain/entities/note.dart";

class TunerConfig {
  TunerConfig({
    double frequency = 440.0,
    double volume = 0.3,
    this.waveType = WaveformType.sine,
  });

  static const freqMin = 65.41 /* C2 */, freqMax = 4186.01 /* C8 */;

  double _freq = 440.0;
  double get freq => _freq;
  set freq(double val) => _freq = val.clamp(freqMin, freqMax);

  double _volume = 0.5;
  double get volume => _volume;
  set volume(double val) => _volume = val.clamp(0.0, 1.0);

  WaveformType waveType;

  Note note() => Note(_freq);
}
