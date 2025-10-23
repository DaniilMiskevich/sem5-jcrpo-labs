import 'package:minisound/minisound.dart';

class TunerService {
  bool _isTunerRunning = false;

  Future<void> playTuner(TunerConfig config) async {
    if (!_isTunerRunning) return;
    
    await _minisound.playFrequency(
      frequency: config.frequency,
      volume: config.volume,
      waveformType: config.waveType,
    );
  }

  void stopTuner() {
    _isTunerRunning = false;
    _minisound.stop();
  }

  void startTuner() {
    _isTunerRunning = true;
  }
}
