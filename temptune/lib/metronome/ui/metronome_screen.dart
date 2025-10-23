class MetronomeScreen extends StatefulWidget {
  const MetronomeScreen({super.key});

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  final MetronomeConfig _config = MetronomeConfig();
  final AudioService _audioService = AudioService();
  bool _isRunning = false;
  DateTime? _lastTap;
  final List<DateTime> _taps = [];

  @override
  void initState() {
    super.initState();
    _audioService.initialize();
  }

  void _toggleMetronome() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _audioService.startMetronome();
        _startMetronomeLoop();
      } else {
        _audioService.stopMetronome();
      }
    });
  }

  void _startMetronomeLoop() {
    // Implementation for metronome timing loop
    // This would use Timer.periodic to schedule beats
  }

  void _handleTapTempo() {
    final now = DateTime.now();
    setState(() {
      if (_lastTap != null) {
        _taps.add(now);
        if (_taps.length > 4) {
          _taps.removeAt(0);
        }
        
        if (_taps.length >= 2) {
          final intervals = <int>[];
          for (int i = 1; i < _taps.length; i++) {
            intervals.add(_taps[i].difference(_taps[i-1]).inMilliseconds);
          }
          final averageInterval = intervals.reduce((a, b) => a + b) ~/ intervals.length;
          _config.bpm = (60000 ~/ averageInterval).clamp(30, 250);
        }
      }
      _lastTap = now;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metronome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _showSavePresetDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BPM Display and Control
            Text(
              '${_config.bpm} BPM',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Slider(
              value: _config.bpm.toDouble(),
              min: 30,
              max: 250,
              onChanged: (value) {
                setState(() {
                  _config.bpm = value.round();
                });
              },
            ),
            
            // Accent Beat Control
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Accent every:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _config.accentBeat,
                  items: [1, 2, 3, 4, 6, 8, 12, 16].map((beat) {
                    return DropdownMenuItem<int>(
                      value: beat,
                      child: Text('$beat beats'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        _config.accentBeat = value;
                      }
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _handleTapTempo,
                  icon: const Icon(Icons.tap_and_play),
                  label: const Text('Tap Tempo'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _toggleMetronome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_isRunning ? 'STOP' : 'START'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSavePresetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Preset'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Preset name'),
          onChanged: (value) {
            // Handle preset name input
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Save preset logic
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}

