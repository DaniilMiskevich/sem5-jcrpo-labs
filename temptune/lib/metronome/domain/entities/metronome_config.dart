final class MetronomeConfig {
  MetronomeConfig({int bpm = 120, int accentBeat = 4, this.soundId})
    : _bpm = bpm,
      _accentBeat = accentBeat;

  static const bpmMin = 30, bpmMax = 600;

  int _bpm = 120;
  int get bpm => _bpm;
  set bpm(int val) => _bpm = val.clamp(bpmMin, bpmMax);

  int _accentBeat = 4;
  int get accentBeat => _accentBeat;
  set accentBeat(int val) => _accentBeat = val.clamp(1, 16);

  int? soundId;
}
