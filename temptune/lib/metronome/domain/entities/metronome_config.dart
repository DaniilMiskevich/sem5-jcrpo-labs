class MetronomeConfig {
  MetronomeConfig({this.bpm = 120, this.accentBeat = 4, this.soundId});

  int _bpm = 120;
  int get bpm => _bpm;
  set bpm(int val) {
    if (val >= 30 && val <= 250) {
      _bpm = val;
    }
  }

  int _accentBeat = 4;
  int get accentBeat => _accentBeat;
  set accentBeat(int val) {
    if (val >= 1 && val <= 16) {
      _accentBeat = val;
    }
  }

  int? soundId;
}

