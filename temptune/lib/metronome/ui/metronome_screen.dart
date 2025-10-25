import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/service/sound_service.dart";
import "package:temptune/_common/ui/widgets/space.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";
import "package:temptune/tuner/ui/widgets/my_circular_slider.dart";

class MetronomeScreen extends StatefulWidget {
  const MetronomeScreen({super.key});

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  final _config = MetronomeConfig();
  bool _isRunning = false;
  DateTime? _lastTap;
  final List<DateTime> _taps = [];

  late final _soundService = context.read<SoundService>();

  void _toggleMetronome() => setState(() {
    if (_isRunning) {
      _soundService.stopMetronome();
    } else {
      _soundService.startMetronome(_config);
    }
    _isRunning = !_isRunning;
  });

  void _updateBpm(int bpm) => setState(() {
    _config.bpm = bpm;
    // TODO apply dynamically
  });

  void _updateAccentBeat(int accentBeat) => setState(() {
    _config.accentBeat = accentBeat;
    // TODO apply dynamically
  });

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
          for (var i = 1; i < _taps.length; i++) {
            intervals.add(_taps[i].difference(_taps[i - 1]).inMilliseconds);
          }
          final averageInterval =
              intervals.reduce((a, b) => a + b) ~/ intervals.length;
          _config.bpm = (60000 ~/ averageInterval).clamp(30, 250);
        }
      }
      _lastTap = now;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Metronome")),
    floatingActionButton: FloatingActionButton(
      onPressed: _toggleMetronome,
      child: Icon(_isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded),
    ),
    body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: DropdownMenu(
                initialSelection: "Foo",
                dropdownMenuEntries: ["Foo", "Bar"]
                    .map(
                      (preset) =>
                          DropdownMenuEntry(value: preset, label: preset),
                    )
                    .toList(),
                onSelected: (_) => print("Preset changed!"),
                expandedInsets: EdgeInsets.zero,
              ),
            ),
            const Space.sm(),
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: _showSavePresetDialog,
            ),
          ],
        ),

        const Space.lg(),

        const Text("Sound"),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DropdownMenu(
            initialSelection: "Qux",
            dropdownMenuEntries: ["Baz", "Qux"]
                .map((sound) => DropdownMenuEntry(value: sound, label: sound))
                .toList(),
            onSelected: (_) => print("Sound changed!"),
            expandedInsets: EdgeInsets.zero,
          ),
        ),

        const Space.sm(),

        const Text("Accent Beat"),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,

            spacing: 8,
            runSpacing: 8,
            children: [0, 1, 2, 3, 4, 6, 8, 12, 16]
                .map(
                  (beat) => FilterChip(
                    label: Text(
                      beat == 0
                          ? "No accent"
                          : "Every $beat${{1: "st", 2: "nd", 3: "rd"}[beat] ?? "th"}",
                    ),
                    selected: beat == _config.accentBeat,
                    onSelected: (_) => _updateAccentBeat(beat),
                  ),
                )
                .toList(),
          ),
        ),

        const Space.lg(),

        Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [
                        (label: "-1", val: _config.bpm - 1),
                        (label: "½x", val: _config.bpm ~/ 2),
                      ]
                      .map(
                        (t) => TextButton(
                          onPressed: t.val < MetronomeConfig.bpmMin
                              ? null
                              : () => _updateBpm(t.val),
                          child: Text(t.label),
                        ),
                      )
                      .toList(),
            ),

            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MyCircularSlider(
                    value: _config.bpm.toDouble(),
                    min: MetronomeConfig.bpmMin.toDouble(),
                    max: MetronomeConfig.bpmMax.toDouble(),
                    divisions: MetronomeConfig.bpmMax - MetronomeConfig.bpmMin,
                    onChanged: (val) => _updateBpm(val.floor()),
                  ),
                  IconButton(
                    onPressed: _handleTapTempo,
                    icon: SizedBox.square(
                      dimension: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _config.bpm.toString(),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Text("BPM", style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [
                        (label: "+1", val: _config.bpm + 1),
                        (label: "2x", val: _config.bpm * 2),
                      ]
                      .map(
                        (t) => TextButton(
                          onPressed: t.val > MetronomeConfig.bpmMax
                              ? null
                              : () => _updateBpm(t.val),
                          child: Text(t.label),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ],
    ),
  );

  void _showSavePresetDialog() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Save Preset"),
      content: TextField(
        decoration: const InputDecoration(hintText: "Preset name"),
        onChanged: (value) {
          // Handle preset name input
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Save preset logic
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}
