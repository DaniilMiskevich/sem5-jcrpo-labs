final class MetronomeConfig {
  MetronomeConfig({int bpm = 120, this.accentBeat = 4, this.soundId})
    : _bpm = bpm;

  static const bpmMin = 30, bpmMax = 600;

  int _bpm = 120;
  int get bpm => _bpm;
  set bpm(int val) => _bpm = val.clamp(bpmMin, bpmMax);

  int accentBeat = 4;

  int? soundId;
}
