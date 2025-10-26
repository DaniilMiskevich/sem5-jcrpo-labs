import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/domain/entities/preset.dart";
import "package:temptune/_common/domain/usecases/preset_usecases.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";

class PresetsScreen extends StatefulWidget {
  const PresetsScreen({super.key});

  @override
  State<PresetsScreen> createState() => _PresetsScreenState();
}

class _PresetsScreenState extends State<PresetsScreen> {
  late final _presetUsecases = context.read<PresetUsecases<MetronomeConfig>>();

  var presets = <Preset<MetronomeConfig>>{};
  Future<Set<Preset<MetronomeConfig>>> _loadPresets() => _presetUsecases
      .list()
      .then(
        (presetIds) =>
            presetIds.map((presetId) => _presetUsecases.load(presetId)),
      )
      .then(Future.wait)
      .then((presets) => presets.whereType<Preset<MetronomeConfig>>().toSet());

  void _deletePreset(Preset<MetronomeConfig> preset) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Preset"),
      content: Text("Are you sure you want to delete '${preset.name}'?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await _presetUsecases.delete(preset);
            if (!context.mounted) return;

            Navigator.pop(context);

            await _loadPresets().then(
              (loadedPresets) => setState(() {
                presets = loadedPresets;
              }),
            );
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();

    _loadPresets().then(
      (loadedPresets) => setState(() {
        presets = loadedPresets;
      }),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Metronome Presets")),
    body: presets.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("No presets yet"),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            itemCount: presets.length,
            itemBuilder: (_, i) {
              final preset = presets.elementAt(i);
              return Card(
                child: ListTile(
                  title: Text(preset.name),
                  subtitle: Text(
                    "${preset.val.bpm} BPM, Accent every ${preset.val.accentBeat} ${preset.val.accentBeat > 1 ? "beats" : "beat"}",
                  ),
                  onLongPress: () => _deletePreset(preset),
                ),
              );
            },
          ),
  );
}
