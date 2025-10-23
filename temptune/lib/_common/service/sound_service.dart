final class SoundService {
  final _minisound = Engine();

  Future<void> initialize() => _minisound.initialize();
  void dispose() => _minisound.dispose(); 
}

