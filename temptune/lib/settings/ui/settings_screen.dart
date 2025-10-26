import "package:flutter/material.dart";
import "package:temptune/_common/ui/widgets/space.dart";
import "package:temptune/settings/ui/custom_sounds_screen.dart";
import "package:temptune/settings/ui/presets_screen.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _username = "Guest";
  String _email = "";

  void _navigateToPresetsScreen() => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (_) => const PresetsScreen()),
  );

  void _navigateToCustomSoundsScreen() => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (_) => const CustomSoundsScreen()),
  );

  void _showAccountDialog() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Account Settings"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: "Username",
              hintText: "Enter your username",
            ),
            onChanged: (value) => setState(() => _username = value),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
            ),
            onChanged: (value) => setState(() => _email = value),
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
            // Save account settings
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Settings")),
    body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      children: [
        // Account Section
        _buildSectionHeader("Account"),
        Card(
          child: ListTile(
            leading: const Icon(Icons.person_rounded),
            title: Text(_username),
            subtitle: _email.isNotEmpty ? Text(_email) : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: _showAccountDialog,
          ),
        ),

        const Space.md(),

        // Management Section
        _buildSectionHeader("Management"),
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text("Metronome Presets"),
                leading: const Icon(Icons.save),
                trailing: const Icon(Icons.chevron_right),
                onTap: _navigateToPresetsScreen,
              ),
              const Divider(),
              ListTile(
                title: const Text("Custom Sounds"),
                leading: const Icon(Icons.audio_file_rounded),
                trailing: const Icon(Icons.chevron_right),
                onTap: _navigateToCustomSoundsScreen,
              ),
            ],
          ),
        ),

        const Space.md(),

        // About Section
        _buildSectionHeader("About"),
        const Card(
          child: ListTile(title: Text("Version"), subtitle: Text("1.0.0")),
        ),
      ],
    ),
  );

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}
