import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/service/sound_service.dart";
import "package:temptune/_common/ui/main_screen.dart";

final soundService = SoundService();

void main() async {
  await soundService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Provider.value(
    value: soundService,
    child: MaterialApp(
      title: "TempTune",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    ),
  );
}
