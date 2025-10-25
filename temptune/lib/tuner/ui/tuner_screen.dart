import "dart:math";

import "package:flutter/material.dart";
import "package:minisound/engine.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/service/sound_service.dart";
import "package:temptune/_common/ui/widgets/space.dart";
import "package:temptune/tuner/domain/entities/tuner_config.dart";
import "package:temptune/tuner/ui/widgets/my_circular_slider.dart";
import "package:temptune/tuner/ui/widgets/note_widget.dart";

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final _config = TunerConfig();
  bool _isPlaying = false;

  late final _soundService = context.read<SoundService>();

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

  void _updateFrequency(double frequency) => setState(() {
    _config.freq = frequency;
    // TODO apply dynamically
  });

  void _updateVolume(double volume) => setState(() {
    _config.volume = volume;
    // TODO apply dynamically
  });

  void _updateWaveform(WaveformType waveType) => setState(() {
    _config.waveType = waveType;
    // TODO apply dynamically
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Tuner")),
    floatingActionButton: FloatingActionButton(
      onPressed: _toggleTuner,
      child: Icon(_isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded),
    ),
    body: ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text("Waveform Type"),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,

            spacing: 8,
            runSpacing: 8,
            children:
                [
                      WaveformType.sine,
                      WaveformType.square,
                      WaveformType.triangle,
                      WaveformType.sawtooth,
                    ]
                    .map(
                      (type) => FilterChip(
                        label: Text(type.name),
                        selected: _config.waveType == type,
                        onSelected: (_) => _updateWaveform(type),
                      ),
                    )
                    .toList(),
          ),
        ),

        const Space.sm(),

        const Text("Volume"),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Slider(
            value: _config.volume,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            onChanged: _updateVolume,
            padding: EdgeInsets.zero,
            label: "${(_config.volume * 100).toStringAsFixed(0)}%",
          ),
        ),

        const Space.lg(),

        Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [_config.note().prev(), _config.note().prevOctave()]
                  .map(
                    (note) => TextButton(
                      onPressed: note.freq < TunerConfig.freqMin - 0.0001
                          ? null
                          : () => _updateFrequency(note.freq),
                      child: NoteWidget(note),
                    ),
                  )
                  .toList(),
            ),

            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      NoteWidget(
                        _config.note(),
                        style: const TextStyle(fontSize: 22),
                      ),

                      Text(
                        _config.freq.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text("Hz", style: TextStyle(fontSize: 22)),
                    ],
                  ),
                  MyCircularSlider(
                    value: log(_config.freq),
                    min: log(TunerConfig.freqMin),
                    max: log(TunerConfig.freqMax),
                    divisions: 12 * 6,
                    onChanged: (val) =>
                        _updateFrequency(pow(e, val).toDouble()),
                  ),
                ],
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [_config.note().next(), _config.note().nextOctave()]
                  .map(
                    (note) => TextButton(
                      onPressed: note.freq > TunerConfig.freqMax + 0.0001
                          ? null
                          : () => _updateFrequency(note.freq),
                      child: NoteWidget(note),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ],
    ),
  );
}
