import "package:flutter/material.dart";
import "package:temptune/_common/domain/entities/preset.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";

class PresetsScreen extends StatefulWidget {
  const PresetsScreen({super.key});

  @override
  State<PresetsScreen> createState() => _PresetsScreenState();
}

class _PresetsScreenState extends State<PresetsScreen> {
  final List<Preset<MetronomeConfig>> _presets = [
    Preset(
      id: 1,
      name: "Standard Practice",
      settings: MetronomeConfig(bpm: 120, accentBeat: 4),
    ),
    Preset(
      id: 2,
      name: "Slow Practice",
      settings: MetronomeConfig(bpm: 60, accentBeat: 2),
    ),
    Preset(
      id: 3,
      name: "Fast Rock",
      settings: MetronomeConfig(bpm: 180, accentBeat: 4),
    ),
  ];

  void _editPreset(Preset<MetronomeConfig> preset) => showDialog<void>(
    context: context,
    builder: (context) => PresetEditDialog(
      preset: preset,
      onSave: (updatedPreset) {
        setState(() {
          final index = _presets.indexWhere((p) => p.id == preset.id);
          if (index != -1) {
            _presets[index] = updatedPreset;
          }
        });
      },
    ),
  );

  void _deletePreset(Preset<MetronomeConfig> preset) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Preset"),
      content: Text('Are you sure you want to delete "${preset.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _presets.removeWhere((p) => p.id == preset.id);
            });
            Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );

  void _addNewPreset() => showDialog<void>(
    context: context,
    builder: (context) => PresetEditDialog(
      preset: Preset(name: "New Preset", settings: MetronomeConfig()),
      onSave: (newPreset) {
        setState(() {
          _presets.add(newPreset);
        });
      },
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Metronome Presets"),
      actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: _addNewPreset),
      ],
    ),
    body: _presets.isEmpty
        ? const Center(child: Text("No presets saved yet"))
        : ListView.builder(
            itemCount: _presets.length,
            itemBuilder: (context, index) {
              final preset = _presets[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(preset.name),
                  subtitle: Text(
                    "${preset.settings.bpm} BPM • Accent: ${preset.settings.accentBeat}",
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: "edit", child: Text("Edit")),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == "edit") {
                        _editPreset(preset);
                      } else if (value == "delete") {
                        _deletePreset(preset);
                      }
                    },
                  ),
                  onTap: () {
                    // Load this preset into the metronome
                    Navigator.pop(context, preset);
                  },
                ),
              );
            },
          ),
  );
}

class PresetEditDialog extends StatefulWidget {
  const PresetEditDialog({
    super.key,
    required this.preset,
    required this.onSave,
  });

  final Preset<MetronomeConfig> preset;
  final void Function(Preset<MetronomeConfig>) onSave;

  @override
  State<PresetEditDialog> createState() => _PresetEditDialogState();
}

class _PresetEditDialogState extends State<PresetEditDialog> {
  late TextEditingController _nameController;
  late MetronomeConfig _config;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.preset.name);
    _config = MetronomeConfig(
      bpm: widget.preset.settings.bpm,
      accentBeat: widget.preset.settings.accentBeat,
      soundId: widget.preset.settings.soundId,
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text("Edit Preset"),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Preset Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BPM: ${_config.bpm}"),
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text("Accent Beat:"),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: _config.accentBeat,
                items: [1, 2, 3, 4, 6, 8, 12, 16]
                    .map(
                      (beat) => DropdownMenuItem<int>(
                        value: beat,
                        child: Text("$beat"),
                      ),
                    )
                    .toList(),
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
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel"),
      ),
      TextButton(
        onPressed: () {
          final updatedPreset = Preset<MetronomeConfig>(
            id: widget.preset.id,
            name: _nameController.text,
            settings: _config,
          );
          widget.onSave(updatedPreset);
          Navigator.pop(context);
        },
        child: const Text("Save"),
      ),
    ],
  );

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
