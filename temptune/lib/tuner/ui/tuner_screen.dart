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
  late final _soundService = context.read<SoundService>();

  final config = TunerConfig();
  bool isPlaying = false;

  void _toggleTuner() {
    setState(() {
      if (isPlaying) {
        _soundService.stopTuner();
      } else {
        _soundService.startTuner();
      }
      isPlaying = !isPlaying;
    });
  }

  void _updateFrequency(double frequency) => setState(() {
    config.freq = frequency;
    _soundService.updateTunerConfig(config);
  });

  void _updateVolume(double volume) => setState(() {
    config.volume = volume;
    _soundService.updateTunerConfig(config);
  });

  void _updateWaveform(WaveformType waveType) => setState(() {
    config.waveType = waveType;
    _soundService.updateTunerConfig(config);
  });

  @override
  void initState() {
    super.initState();

    _soundService.updateTunerConfig(config);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Tuner")),
    floatingActionButton: FloatingActionButton(
      onPressed: _toggleTuner,
      child: Icon(isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded),
    ),
    body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      children: [
        const Text("Waveform Type"),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            alignment: WrapAlignment.center,
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
                        selected: type == config.waveType,
                        onSelected: (_) => _updateWaveform(type),
                      ),
                    )
                    .toList(),
          ),
        ),

        const Space.sm(),

        const Text("Volume"),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Slider(
            value: config.volume,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            onChanged: _updateVolume,
            padding: EdgeInsets.zero,
            label: "${(config.volume * 100).toStringAsFixed(0)}%",
          ),
        ),

        const Space.lg(),

        Row(
          children: [
            Column(
              children: [config.note().prev(), config.note().prevOctave()]
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
                  MyCircularSlider(
                    value: log(config.freq),
                    min: log(TunerConfig.freqMin),
                    max: log(TunerConfig.freqMax),
                    divisions: 12 * 6,
                    onChanged: (val) =>
                        _updateFrequency(pow(e, val).toDouble()),
                  ),
                  Column(
                    children: [
                      NoteWidget(
                        config.note(),
                        style: const TextStyle(fontSize: 22),
                      ),

                      Text(
                        config.freq.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text("Hz", style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              children: [config.note().next(), config.note().nextOctave()]
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
