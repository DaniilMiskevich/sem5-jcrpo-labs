import "dart:typed_data";

import "package:flutter/material.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";

class CustomSoundsScreen extends StatefulWidget {
  const CustomSoundsScreen({super.key});

  @override
  State<CustomSoundsScreen> createState() => _CustomSoundsScreenState();
}

class _CustomSoundsScreenState extends State<CustomSoundsScreen> {
  final List<MetronomeSoundMeta> _customSounds = [];

  Future<void> _importSound() async => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Import Sound"),
      content: const Text("Select an audio file from your device"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Mock import - in real app, this would handle file selection
            final newSound = CustomMetronomeSoundMeta(
              id: DateTime.now().millisecondsSinceEpoch,
              name: "Custom Sound ${_customSounds.length + 1}",
              data: Uint8List(0), // Would be actual audio data
            );
            setState(() {
              _customSounds.add(newSound);
            });
            Navigator.pop(context);
          },
          child: const Text("Import"),
        ),
      ],
    ),
  );

  void _editSound(CustomMetronomeSoundMeta sound) {
    if (sound is BuiltinMetronomeSoundMeta) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Built-in sounds cannot be edited")),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => SoundEditDialog(
        sound: sound,
        onSave: (updatedSound) {
          setState(() {
            final index = _customSounds.indexWhere((s) => s.id == sound.id);
            if (index != -1) {
              _customSounds[index] = updatedSound;
            }
          });
        },
      ),
    );
  }

  void _deleteSound(MetronomeSoundMeta sound) {
    if (sound is BuiltinMetronomeSoundMeta) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Built-in sounds cannot be deleted")),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Sound"),
        content: Text('Are you sure you want to delete "${sound.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _customSounds.removeWhere((s) => s.id == sound.id);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Custom Sounds"),
      actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: _importSound),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_customSounds.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text("No custom sounds imported yet"),
              ),
            )
          else
            ..._customSounds.map(_buildSoundCard),
        ],
      ),
    ),
  );

  Widget _buildSoundCard(MetronomeSoundMeta sound) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: const Icon(Icons.audio_file),
      title: Text(sound.name),
      subtitle: sound is BuiltinMetronomeSoundMeta
          ? const Text("Built-in")
          : const Text("Custom"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (sound is CustomMetronomeSoundMeta)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editSound(sound),
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteSound(sound),
          ),
        ],
      ),
      onTap: () {
        // Preview sound
      },
    ),
  );
}

class SoundEditDialog extends StatefulWidget {
  const SoundEditDialog({super.key, required this.sound, required this.onSave});

  final CustomMetronomeSoundMeta sound;
  final void Function(MetronomeSoundMeta) onSave;

  @override
  State<SoundEditDialog> createState() => _SoundEditDialogState();
}

class _SoundEditDialogState extends State<SoundEditDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sound.name);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text("Edit Sound"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: "Sound Name",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Replace sound file
          },
          icon: const Icon(Icons.audio_file),
          label: const Text("Replace Sound File"),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel"),
      ),
      TextButton(
        onPressed: () {
          final updatedSound = CustomMetronomeSoundMeta(
            id: widget.sound.id,
            name: _nameController.text,
            data: widget.sound.data,
          );
          widget.onSave(updatedSound);
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
