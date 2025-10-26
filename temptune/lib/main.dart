import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/data/repo_impls/bin_file_storage_repo_impl.dart";
import "package:temptune/_common/data/repo_impls/text_file_storage_repo_impl.dart";
import "package:temptune/_common/domain/entities/preset.dart";
import "package:temptune/_common/domain/usecases/preset_usecases.dart";
import "package:temptune/_common/service/sound_service.dart";
import "package:temptune/_common/ui/main_screen.dart";
import "package:temptune/metronome/data/repo_impls/metronome_preset_file_storage_repo_impl.dart";
import "package:temptune/metronome/data/repo_impls/metronome_sound_file_storage_repo_impl.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";
import "package:temptune/metronome/domain/usecases/metronome_sound_usecases.dart";

final metronomePresetStorage = MetronomePresetFileStorageRepoImpl(
  TextFileStorageRepoImpl("userdata/metronome/presets/"),
);
final customMetronomeSoundStorage = MetronomeSoundFileStorageRepoImpl(
  BinFileStorageRepoImpl("userdata/metronome/sounds/data/"),
  TextFileStorageRepoImpl("userdata/metronome/sounds/meta/"),
);

final metronomePresetUsecases = PresetUsecases<MetronomeConfig>(
  metronomePresetStorage,
);
final metronomeSoundUsecases = MetronomeSoundUsecases(
  {},
  customMetronomeSoundStorage,
);

final soundService = SoundService(metronomeSoundUsecases);

void main() async {
  await soundService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      Provider.value(value: soundService),
      Provider.value(value: metronomeSoundUsecases),
      Provider.value(value: metronomePresetUsecases),
    ],
    child: MaterialApp(
      title: "TempTune",
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    ),
  );
}
