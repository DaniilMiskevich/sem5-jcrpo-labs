import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/data/repo_impls/bin_file_storage_repo_impl.dart";
import "package:temptune/_common/data/repo_impls/text_file_storage_repo_impl.dart";
import "package:temptune/_common/domain/usecases/preset_usecases.dart";
import "package:temptune/_common/service/sound_service.dart";
import "package:temptune/_common/ui/main_screen.dart";
import "package:temptune/auth/data/firebase_auther_repo_impl.dart";
import "package:temptune/auth/domain/usecases/auth_usecases.dart";
import "package:temptune/firebase_options.dart";
import "package:temptune/metronome/data/repo_impls/builtin_metronome_sound_storage_repo_impl.dart";
import "package:temptune/metronome/data/repo_impls/custom_metronome_sound_file_storage_repo_impl.dart";
import "package:temptune/metronome/data/repo_impls/metronome_preset_file_storage_repo_impl.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";
import "package:temptune/metronome/domain/usecases/metronome_sound_usecases.dart";

final metronomePresetStorage = MetronomePresetFileStorageRepoImpl(
  TextFileStorageRepoImpl("userdata/metronome/presets/"),
);
final builtinMetronomeSoundsStorage = BuiltinMetronomeSoundStorageRepoImpl([
  BuiltinMetronomeSoundMeta(
    name: "Click",
    assetPath: "assets/metronome/sounds/click.wav",
  ),
  BuiltinMetronomeSoundMeta(
    name: "Beep",
    assetPath: "assets/metronome/sounds/8_bit.wav",
  ),
]);
final customMetronomeSoundStorage = CustomMetronomeSoundFileStorageRepoImpl(
  BinFileStorageRepoImpl("userdata/metronome/sounds/data/"),
  TextFileStorageRepoImpl("userdata/metronome/sounds/meta/"),
);

final metronomePresetUsecases = PresetUsecases<MetronomeConfig>(
  metronomePresetStorage,
);
final metronomeSoundUsecases = MetronomeSoundUsecases(
  builtinMetronomeSoundsStorage,
  customMetronomeSoundStorage,
);
final authUsecases = AuthUsecases(FirebaseAutherRepoImpl());

final soundService = SoundService(metronomeSoundUsecases);

void main() async {
  await soundService.init();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      Provider.value(value: authUsecases),
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

class AuthProvider extends StatelessWidget {
  const AuthProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
