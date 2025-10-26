import "dart:async";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:temptune/_common/ui/widgets/space.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";

class CustomSoundEditDialog extends StatefulWidget {
  const CustomSoundEditDialog({
    super.key,
    required this.sound,
    required this.onSave,
  });

  final CustomMetronomeSoundMeta? sound;
  final FutureOr<void> Function(CustomMetronomeSoundMeta) onSave;

  @override
  State<CustomSoundEditDialog> createState() => _CustomSoundEditDialogState();
}

class _CustomSoundEditDialogState extends State<CustomSoundEditDialog> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.sound?.name,
  );

  PlatformFile? file;

  bool get isEditing => widget.sound != null;

  void _updateFile(PlatformFile val) => setState(() {
    file = val;
  });

  Future<PlatformFile?> _showFilePicker() => FilePicker.platform
      .pickFiles(type: FileType.audio)
      .then((r) => r?.files.firstOrNull);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(isEditing ? "Edit Sound" : "Add Sound"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Name"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "Start typing...",
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),

        const Space.sm(),

        const Text("Sound File"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: switch (file) {
              PlatformFile(:final name) => ElevatedButton.icon(
                onPressed: () async {},
                label: SizedBox(child: Text(name)),
                icon: const Icon(Icons.audio_file_rounded),
              ),
              _ => ElevatedButton.icon(
                onPressed: () async {
                  final file = await _showFilePicker();
                  if (file != null) _updateFile(file);
                },
                label: Text(isEditing ? "Replace..." : "Upload..."),
                icon: const Icon(Icons.upload_file_rounded),
              ),
            },
          ),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Cancel"),
      ),
      TextButton(
        onPressed: () async {
          final data = file?.bytes ?? widget.sound?.data;
          if (data == null) return;

          await widget.onSave(
            CustomMetronomeSoundMeta(
              id: widget.sound?.id,
              name: _nameController.text,
              data: data,
            ),
          );
          if (!context.mounted) return;

          Navigator.pop(context);
        },
        child: const Text("Save"),
      ),
    ],
  );
}
