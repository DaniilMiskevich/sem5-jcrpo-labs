import "package:flutter/material.dart";
import "package:temptune/settings/ui/custom_sounds_screen.dart";
import "package:temptune/settings/ui/presets_screen.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _keepAwake = true;
  bool _enableSync = false;
  String _username = "Guest User";
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
      padding: const EdgeInsets.all(16),
      children: [
        // Account Section
        _buildSectionHeader("Account"),
        Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(_username),
            subtitle: _email.isNotEmpty ? Text(_email) : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: _showAccountDialog,
          ),
        ),

        const SizedBox(height: 24),

        // Application Settings Section
        _buildSectionHeader("Application"),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Dark Mode"),
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
              ),
              SwitchListTile(
                title: const Text("Keep Screen Awake"),
                subtitle: const Text("Prevent screen from locking during use"),
                value: _keepAwake,
                onChanged: (value) => setState(() => _keepAwake = value),
              ),
              SwitchListTile(
                title: const Text("Enable Sync"),
                subtitle: const Text("Synchronize presets across devices"),
                value: _enableSync,
                onChanged: (value) => setState(() => _enableSync = value),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Management Section
        _buildSectionHeader("Management"),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.save),
                title: const Text("Metronome Presets"),
                subtitle: const Text(
                  "Manage your saved metronome configurations",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: _navigateToPresetsScreen,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.audio_file),
                title: const Text("Custom Sounds"),
                subtitle: const Text("Manage imported metronome sounds"),
                trailing: const Icon(Icons.chevron_right),
                onTap: _navigateToCustomSoundsScreen,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // About Section
        _buildSectionHeader("About"),
        Card(
          child: Column(
            children: [
              const ListTile(title: Text("Version"), subtitle: Text("1.0.0")),
              const Divider(),
              ListTile(
                title: const Text("Privacy Policy"),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // Open privacy policy
                },
              ),
              const Divider(),
              ListTile(
                title: const Text("Terms of Service"),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // Open terms of service
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}
