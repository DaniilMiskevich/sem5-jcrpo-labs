import 'package:flutter/material.dart';
import 'package:minisound/minisound.dart';
import '../entities/tuner_config.dart';
import '../services/audio_service.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final TunerConfig _config = TunerConfig();
  final AudioService _audioService = AudioService();
  bool _isPlaying = false;
  final List<double> _commonFrequencies = [
    27.5,  // A0
    55.0,  // A1
    110.0, // A2
    220.0, // A3
    440.0, // A4
    880.0, // A5
    1760.0, // A6
    3520.0, // A7
  ];

  @override
  void initState() {
    super.initState();
    _audioService.initialize();
  }

  void _toggleTuner() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _audioService.startTuner();
        _playTone();
      } else {
        _audioService.stopTuner();
      }
    });
  }

  void _playTone() async {
    if (_isPlaying) {
      await _audioService.playTuner(_config);
    }
  }

  void _updateFrequency(double frequency) {
    setState(() {
      _config.frequency = frequency;
      if (_isPlaying) {
        _playTone();
      }
    });
  }

  void _updateVolume(double volume) {
    setState(() {
      _config.volume = volume;
      if (_isPlaying) {
        _playTone();
      }
    });
  }

  void _updateWaveform(WaveformType waveType) {
    setState(() {
      _config.waveType = waveType;
      if (_isPlaying) {
        _playTone();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tuner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Current Note and Frequency Display
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    _config.note(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_config.frequency.toStringAsFixed(1)} Hz',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Frequency Control
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frequency: ${_config.frequency.toStringAsFixed(1)} Hz',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Slider(
                  value: _config.frequency,
                  min: 27.5,
                  max: 4186.0,
                  divisions: 100,
                  onChanged: _updateFrequency,
                ),
                
                // Common frequency shortcuts
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _commonFrequencies.length,
                    itemBuilder: (context, index) {
                      final freq = _commonFrequencies[index];
                      final note = TunerConfig(frequency: freq).note();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text('$note (${freq.toStringAsFixed(0)} Hz)'),
                          onSelected: (_) => _updateFrequency(freq),
                          selected: _config.frequency == freq,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Volume Control
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volume: ${(_config.volume * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Slider(
                  value: _config.volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  onChanged: _updateVolume,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Waveform Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waveform',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildWaveformChip('Sine', WaveformType.sine),
                    _buildWaveformChip('Square', WaveformType.square),
                    _buildWaveformChip('Triangle', WaveformType.triangle),
                    _buildWaveformChip('Sawtooth', WaveformType.sawtooth),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Play/Stop Button
            ElevatedButton(
              onPressed: _toggleTuner,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isPlaying ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  const SizedBox(width: 8),
                  Text(_isPlaying ? 'STOP TONE' : 'PLAY TONE'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveformChip(String label, WaveformType waveType) {
    return FilterChip(
      label: Text(label),
      selected: _config.waveType == waveType,
      onSelected: (_) => _updateWaveform(waveType),
    );
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
