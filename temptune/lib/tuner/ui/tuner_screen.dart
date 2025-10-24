import "package:flutter/material.dart";
import "package:minisound/engine.dart";
import "package:temptune/_common/service/sound_service.dart";
import "package:temptune/tuner/domain/entities/tuner_config.dart";

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final _config = TunerConfig();
  final _soundService = SoundService();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _soundService.initialize();
  }

  void _toggleTuner() {
    setState(() {
      if (_isPlaying) {
        _soundService.stopTuner();
      } else {
        _soundService.startTuner(_config);
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _updateFrequency(double frequency) {
    setState(() {
      _config.frequency = frequency;
      // TODO apply dynamically
    });
  }

  void _updateVolume(double volume) {
    setState(() {
      _config.volume = volume;
      // TODO apply dynamically
    });
  }

  void _updateWaveform(WaveformType waveType) {
    setState(() {
      _config.waveType = waveType;
      // TODO apply dynamically
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Tuner")),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Current Note and Frequency Display
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
                  "${_config.frequency.toStringAsFixed(1)} Hz",
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
                "Frequency: ${_config.frequency.toStringAsFixed(1)} Hz",
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
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final freq = [440.0, 440.0, 440.0, 440.0, 440.0][index];
                    final note = TunerConfig(frequency: freq).note();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text("$note (${freq.toStringAsFixed(0)} Hz)"),
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
                "Volume: ${(_config.volume * 100).toStringAsFixed(0)}%",
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
              Text("Waveform", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildWaveformChip("Sine", WaveformType.sine),
                  _buildWaveformChip("Square", WaveformType.square),
                  _buildWaveformChip("Triangle", WaveformType.triangle),
                  _buildWaveformChip("Sawtooth", WaveformType.sawtooth),
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
                Text(_isPlaying ? "STOP TONE" : "PLAY TONE"),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildWaveformChip(String label, WaveformType waveType) => FilterChip(
    label: Text(label),
    selected: _config.waveType == waveType,
    onSelected: (_) => _updateWaveform(waveType),
  );
}
