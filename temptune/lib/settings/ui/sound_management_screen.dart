import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";
import "package:temptune/metronome/domain/usecases/metronome_sound_usecases.dart";
import "package:temptune/settings/ui/custom_sound_edit_dialog.dart";

class SoundManagementScreen extends StatefulWidget {
  const SoundManagementScreen({super.key});

  @override
  State<SoundManagementScreen> createState() => _SoundManagementScreenState();
}

class _SoundManagementScreenState extends State<SoundManagementScreen> {
  late final _soundUsecases = context.read<MetronomeSoundUsecases>();

  var sounds = <MetronomeSoundMeta>{};
  Future<Set<MetronomeSoundMeta>> _loadSounds() => _soundUsecases
      .list()
      .then((ids) => ids.map((id) => _soundUsecases.load(id)))
      .then(Future.wait)
      .then((sounds) => sounds.whereType<MetronomeSoundMeta>().toSet());

  Future<void> _saveSound(CustomMetronomeSoundMeta sound) async {
    await _soundUsecases.save(sound);

    await _loadSounds().then((loadedSounds) => sounds = loadedSounds);
    setState(() {});
  }

  Future<void> _deleteSound(CustomMetronomeSoundMeta sound) async {
    await _soundUsecases.delete(sound);

    await _loadSounds().then((loadedSounds) => sounds = loadedSounds);
    setState(() {});
  }

  void _showEditDialog([CustomMetronomeSoundMeta? sound]) => showDialog<void>(
    context: context,
    builder: (context) =>
        CustomSoundEditDialog(sound: sound, onSave: _saveSound),
  );

  void _showDeleteDialog(CustomMetronomeSoundMeta sound) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Sound"),
      content: Text("Are you sure you want to delete '${sound.name}'?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            _deleteSound(sound);
            if (!context.mounted) return;
            Navigator.pop(context);
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();

    () async {
      await _loadSounds().then((loadedSounds) => sounds = loadedSounds);

      setState(() {});
    }();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Sound Management"),
      actions: [
        IconButton(
          icon: const Icon(Icons.import_export_rounded),
          onPressed: _showEditDialog,
        ),
      ],
    ),
    body: sounds.isEmpty
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
            itemCount: sounds.length,
            itemBuilder: (_, i) {
              final sound = sounds.elementAt(i);
              return Card(
                child: ListTile(
                  enabled: sound is! BuiltinMetronomeSoundMeta,
                  title: Text(sound.name),
                  subtitle: sound is BuiltinMetronomeSoundMeta
                      ? const Text("Built-in")
                      : const Text("Custom"),
                  leading: const Icon(Icons.audio_file),
                  // TODO! preview the sound if have time
                  onTap: sound is! CustomMetronomeSoundMeta
                      ? null
                      : () => _showEditDialog(sound),
                  onLongPress: sound is! CustomMetronomeSoundMeta
                      ? null
                      : () => _showDeleteDialog(sound),
                ),
              );
            },
          ),
  );
}
