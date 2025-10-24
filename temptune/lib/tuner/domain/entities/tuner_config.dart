import "dart:math";

import "package:minisound/minisound.dart";

class TunerConfig {
  TunerConfig({
    double frequency = 440.0,
    double volume = 0.5,
    this.waveType = WaveformType.sine,
  });

  double _frequency = 440.0;
  double get frequency => _frequency;
  set frequency(double val) =>
      _frequency = val.clamp(27.5 /* A0 */, 7040 /* A8 */);

  double _volume = 0.5;
  double get volume => _volume;
  set volume(double val) => _volume = val.clamp(0.0, 1.0);

  WaveformType waveType;

  String note() {
    const notes = [
      "A",
      "A#",
      "B",
      "C",
      "C#",
      "D",
      "D#",
      "E",
      "F",
      "F#",
      "G",
      "G#",
    ];
    final logNote = log(pow(2, 1 / 12));

    final noteIndex = (log(_frequency - 440.0 /* A4 */) / logNote).floor();
    final note = notes[noteIndex % 12];
    final octave = noteIndex ~/ 12;
    return "$note:$octave";
  }
}
