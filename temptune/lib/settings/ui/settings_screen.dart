import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/ui/widgets/space.dart";
import "package:temptune/auth/domain/entities/user.dart";
import "package:temptune/auth/domain/usecases/auth_usecases.dart";
import "package:temptune/settings/ui/presets_screen.dart";
import "package:temptune/settings/ui/sound_management_screen.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final _authUsecases = context.read<AuthUsecases>();

  User? currentUser;

  Future<void> _showLoginDialog() async {
    final emailController = TextEditingController();
    final passController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log In/Register"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "E-mail"),
            ),
            const Space.sm(),
            TextField(
              controller: passController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
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
              await _authUsecases.signIn(
                emailController.text,
                passController.text,
              );
              if (!context.mounted) return;

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Log Out"),
      content: const Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await _authUsecases.signOut();
            if (!context.mounted) return;

            setState(() {
              currentUser = null;
            });

            Navigator.pop(context);
          },
          child: const Text("Log Out"),
        ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();

    _authUsecases.userChanges.forEach(
      (user) => setState(() {
        currentUser = user;
      }),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
            title: Text(currentUser?.email ?? "Annonymous"),
            onTap: currentUser == null ? _showLoginDialog : _showLogoutDialog,
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const PresetsScreen(),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text("Sound Management"),
                leading: const Icon(Icons.audio_file_rounded),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SoundManagementScreen(),
                  ),
                ),
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
}
