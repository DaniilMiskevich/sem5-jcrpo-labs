import 'package:minisound/minisound.dart';

class TunerConfig {
  TunerConfig({this.frequency = 440.0, this.volume = 0.5, this.waveType = WaveformType.sine});

  double _frequency = 440.0;
  double get frequency => _frequency;
  set frequency(double val) {
    if (val >= 27.5 && val <= 4186.0) { // A0 to C8 range
      _frequency = val;
    }
  }

  double _volume = 0.5;
  double get volume => _volume;
  set volume(double val) {
    if (val >= 0.0 && val <= 1.0) {
      _volume = val;
    }
  }

  WaveformType waveType;

  String note() {
    const notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final noteIndex = 0;//((69 + 12 * (log(frequency - 440.0) / log(pow(2, 1.0/12.0)))) % 12).round();
    final octave = 4 + ((log(frequency / 440.0) / ln2) / 12).floor();
    return "${notes[noteIndex]}$octave";
  }
}
