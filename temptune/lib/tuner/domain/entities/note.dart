import "dart:math";

const _adjOctavesDifference = 2;
final _adjNotesDifference = pow(_adjOctavesDifference, 1 / 12);
final _logNote = log(_adjNotesDifference);
int _globalNoteIndex(double freq) =>
    (log(freq / 16.35 /* C0 */) / _logNote).round();

final class Note {
  Note(this.freq);

  final double freq;

  late final int octave = _globalNoteIndex(freq) ~/ 12;
  late final String name = [
    "C",
    "C#",
    "D",
    "D#",
    "E",
    "F",
    "F#",
    "G",
    "G#",
    "A",
    "A#",
    "B",
  ][_globalNoteIndex(freq) % 12];

  Note next() => Note(freq * _adjNotesDifference);
  Note prev() => Note(freq / _adjNotesDifference);
  Note nextOctave() => Note(freq * _adjOctavesDifference);
  Note prevOctave() => Note(freq / _adjOctavesDifference);
}
