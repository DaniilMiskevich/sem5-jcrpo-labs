import "package:flutter/material.dart";
import "package:temptune/metronome/ui/metronome_screen.dart";
import "package:temptune/settings/ui/settings_screen.dart";
import "package:temptune/tuner/ui/tuner_screen.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<Widget> _screens = [
    MetronomeScreen(),
    TunerScreen(),
    SettingsScreen(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _screens[_selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.music_note_rounded),
          label: "Metronome",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.equalizer_rounded),
          label: "Tuner",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: "Settings",
        ),
      ],
    ),
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
