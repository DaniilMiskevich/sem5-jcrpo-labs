import 'package:flutter/material.dart';
import '../entities/metronome_sound.dart';

class CustomSoundsScreen extends StatefulWidget {
  const CustomSoundsScreen({super.key});

  @override
  State<CustomSoundsScreen> createState() => _CustomSoundsScreenState();
}

class _CustomSoundsScreenState extends State<CustomSoundsScreen> {
  final List<MetronomeSound> _builtinSounds = [
    MetronomeSound.fromAsset(
      id: 1,
      name: 'Wood Block',
      assetPath: 'assets/sounds/wood_block.wav',
    ),
    MetronomeSound.fromAsset(
      id: 2,
      name: 'Electronic Beep',
      assetPath: 'assets/sounds/beep.wav',
    ),
    MetronomeSound.fromAsset(
      id: 3,
      name: 'Drum Click',
      assetPath: 'assets/sounds/click.wav',
    ),
  ];

  final List<MetronomeSound> _customSounds = [];

  void _importSound() async {
    // This would typically use file_picker or similar to select audio files
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Sound'),
        content: const Text('Select an audio file from your device'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Mock import - in real app, this would handle file selection
              final newSound = MetronomeSound(
                id: DateTime.now().millisecondsSinceEpoch,
                name: 'Custom Sound ${_customSounds.length + 1}',
                data: Uint8List(0), // Would be actual audio data
              );
              setState(() {
                _customSounds.add(newSound);
              });
              Navigator.pop(context);
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _editSound(MetronomeSound sound) {
    if (sound.isProtected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Built-in sounds cannot be edited')),
      );
      return;
    }

    showDialog(
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

  void _deleteSound(MetronomeSound sound) {
    if (sound.isProtected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Built-in sounds cannot be deleted')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sound'),
        content: Text('Are you sure you want to delete "${sound.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _customSounds.removeWhere((s) => s.id == sound.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Sounds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _importSound,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Built-in Sounds Section
            _buildSectionHeader('Built-in Sounds'),
            ..._builtinSounds.map((sound) => _buildSoundCard(sound)),

            const SizedBox(height: 24),

            // Custom Sounds Section
            _buildSectionHeader('Custom Sounds'),
            if (_customSounds.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No custom sounds imported yet'),
                ),
              )
            else
              ..._customSounds.map((sound) => _buildSoundCard(sound)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSoundCard(MetronomeSound sound) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.audio_file),
        title: Text(sound.name),
        subtitle: sound.isProtected ? const Text('Built-in') : const Text('Custom'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!sound.isProtected)
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
}

class SoundEditDialog extends StatefulWidget {
  final MetronomeSound sound;
  final Function(MetronomeSound) onSave;

  const SoundEditDialog({
    super.key,
    required this.sound,
    required this.onSave,
  });

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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Sound'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Sound Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Replace sound file
            },
            icon: const Icon(Icons.audio_file),
            label: const Text('Replace Sound File'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final updatedSound = MetronomeSound(
              id: widget.sound.id,
              name: _nameController.text,
              data: widget.sound.data,
              isProtected: widget.sound.isProtected,
            );
            widget.onSave(updatedSound);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
