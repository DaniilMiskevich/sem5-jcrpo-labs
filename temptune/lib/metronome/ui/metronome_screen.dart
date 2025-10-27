import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/domain/entities/preset.dart";
import "package:temptune/_common/domain/usecases/preset_usecases.dart";
import "package:temptune/_common/service/sound_service.dart";
import "package:temptune/_common/ui/widgets/space.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";
import "package:temptune/metronome/domain/usecases/metronome_sound_usecases.dart";
import "package:temptune/tuner/ui/widgets/my_circular_slider.dart";

class MetronomeScreen extends StatefulWidget {
  const MetronomeScreen({super.key});

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  late final _soundService = context.read<SoundService>();
  late final _presetUsecases = context.read<PresetUsecases<MetronomeConfig>>();
  late final _soundUsecases = context.read<MetronomeSoundUsecases>();
  final presetNameController = TextEditingController();

  var config = MetronomeConfig();

  var presets = <Preset<MetronomeConfig>>{};
  Preset<MetronomeConfig>? currentPreset;
  Future<Set<Preset<MetronomeConfig>>> _loadPresets() => _presetUsecases
      .list()
      .then((ids) => ids.map((id) => _presetUsecases.load(id)))
      .then(Future.wait)
      .then((presets) => presets.whereType<Preset<MetronomeConfig>>().toSet());

  var sounds = <MetronomeSoundMeta>{};
  Future<Set<MetronomeSoundMeta>> _loadSounds() => _soundUsecases
      .list()
      .then((ids) => ids.map((id) => _soundUsecases.load(id)))
      .then(Future.wait)
      .then((sounds) => sounds.whereType<MetronomeSoundMeta>().toSet());

  var isRunning = false;
  void _toggleMetronome() => setState(() {
    if (isRunning) {
      _soundService.stopMetronome();
    } else {
      _soundService.startMetronome();
    }
    isRunning = !isRunning;
  });

  void _updateBpm(int val) => setState(() {
    config.bpm = val;
    _soundService.updateMetronomeConfig(config);
  });
  void _updateAccentBeat(int val) => setState(() {
    config.accentBeat = val;
    _soundService.updateMetronomeConfig(config);
  });
  void _updateSoundId(int? val) => setState(() {
    config.soundId = val;
    _soundService.updateMetronomeConfig(config);
  });
  void _updateConfig(MetronomeConfig val) => setState(() {
    config = val;
    _soundService.updateMetronomeConfig(config);
  });

  DateTime? lastTap;
  final List<DateTime> taps = [];
  void _handleTapTempo() {
    final now = DateTime.now();
    if (lastTap != null) {
      taps.add(now);
      if (taps.length > 4) {
        taps.removeAt(0);
      }

      if (taps.length >= 2) {
        final intervals = <int>[];
        for (var i = 1; i < taps.length; i++) {
          intervals.add(taps[i].difference(taps[i - 1]).inMilliseconds);
        }
        final averageInterval =
            intervals.reduce((a, b) => a + b) ~/ intervals.length;
        _updateBpm(60000 ~/ averageInterval);
      }
    }
    lastTap = now;
  }

  Future<void> _savePreset(Preset<MetronomeConfig> preset) async {
    preset.name = presetNameController.text;
    // ignore: parameter_assignments
    preset = await _presetUsecases.save(preset);

    currentPreset = preset;
    await _loadPresets().then((loadedPresets) => presets = loadedPresets);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    () async {
      await _loadPresets().then((loadedPresets) => presets = loadedPresets);
      await _loadSounds().then((loadedSounds) => sounds = loadedSounds);

      setState(() {});
    }();

    _soundService.updateMetronomeConfig(config);
  }

  @override
  void dispose() {
    _soundService.stopMetronome();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Metronome")),
    floatingActionButton: FloatingActionButton(
      onPressed: _toggleMetronome,
      child: Icon(isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded),
    ),
    body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: DropdownMenu(
                controller: presetNameController,
                initialSelection: currentPreset,
                dropdownMenuEntries:
                    presets
                        .map(
                          (preset) =>
                              DropdownMenuEntry<Preset<MetronomeConfig>?>(
                                value: preset,
                                label: preset.name,
                              ),
                        )
                        .toList()
                      ..add(
                        const DropdownMenuEntry<Preset<MetronomeConfig>?>(
                          value: null,
                          label: "New Preset\u200B",
                          leadingIcon: Icon(Icons.add_rounded),
                        ),
                      ),
                onSelected: (preset) {
                  currentPreset = preset;
                  if (preset != null) _updateConfig(preset.val);
                },
                expandedInsets: EdgeInsets.zero,
              ),
            ),
            const Space.sm(),
            IconButton(
              icon: const Icon(Icons.save_rounded),
              onPressed: () =>
                  _savePreset(currentPreset ?? Preset(name: "", val: config)),
            ),
          ],
        ),

        const Space.lg(),

        const Text("Sound"),
        Padding(
          padding: const EdgeInsets.all(8),
          child: DropdownMenu<int?>(
            initialSelection: config.soundId,
            dropdownMenuEntries:
                sounds
                    .map(
                      (sound) =>
                          DropdownMenuEntry(value: sound.id, label: sound.name),
                    )
                    .toList()
                  ..add(const DropdownMenuEntry(value: null, label: "Default")),
            onSelected: _updateSoundId,
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
                    label: Text(beat == 0 ? "No accent" : "Every $beat"),
                    selected: beat == config.accentBeat,
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
                        (label: "-1", val: config.bpm - 1),
                        (label: "½x", val: config.bpm ~/ 2),
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
                    value: config.bpm.toDouble(),
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
                            config.bpm.toString(),
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
                        (label: "+1", val: config.bpm + 1),
                        (label: "2x", val: config.bpm * 2),
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
}
