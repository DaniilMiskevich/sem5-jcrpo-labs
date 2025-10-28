import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:temptune/_common/data/repo_impls/bin_file_storage_repo_impl.dart";
import "package:temptune/_common/data/repo_impls/text_file_storage_repo_impl.dart";
import "package:temptune/_common/domain/usecases/preset_usecases.dart";
import "package:temptune/_common/service/sound_service.dart";
import "package:temptune/_common/ui/main_screen.dart";
import "package:temptune/auth/data/mock_auther_repo_impl.dart";
import "package:temptune/auth/domain/usecases/auth_usecases.dart";
import "package:temptune/metronome/data/repo_impls/builtin_metronome_sound_storage_repo_impl.dart";
import "package:temptune/metronome/data/repo_impls/custom_metronome_sound_file_storage_repo_impl.dart";
import "package:temptune/metronome/data/repo_impls/metronome_preset_file_storage_repo_impl.dart";
import "package:temptune/metronome/domain/entities/metronome_config.dart";
import "package:temptune/metronome/domain/entities/metronome_sound.dart";
import "package:temptune/metronome/domain/usecases/metronome_sound_usecases.dart";

late final MetronomePresetFileStorageRepoImpl metronomePresetStorage;
MetronomePresetFileStorageRepoImpl createMetronomePresetSync(String uuid) =>
    MetronomePresetFileStorageRepoImpl(
      TextFileStorageRepoImpl("userdata/metronome/presets/$uuid"),
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
late final CustomMetronomeSoundFileStorageRepoImpl customMetronomeSoundStorage;

late final PresetUsecases<MetronomeConfig> metronomePresetUsecases;
late final MetronomeSoundUsecases metronomeSoundUsecases;
late final AuthUsecases authUsecases;

late final SoundService soundService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const userdata =
      "userdata"; //(await getApplicationDocumentsDirectory()).path;

  metronomePresetStorage = MetronomePresetFileStorageRepoImpl(
    TextFileStorageRepoImpl("$userdata/metronome/presets/"),
  );
  customMetronomeSoundStorage = CustomMetronomeSoundFileStorageRepoImpl(
    BinFileStorageRepoImpl("$userdata/metronome/sounds/data/"),
    TextFileStorageRepoImpl("$userdata/metronome/sounds/meta/"),
  );

  metronomePresetUsecases = PresetUsecases<MetronomeConfig>(
    metronomePresetStorage,
  );
  metronomeSoundUsecases = MetronomeSoundUsecases(
    builtinMetronomeSoundsStorage,
    customMetronomeSoundStorage,
  );
  authUsecases = AuthUsecases(MockAutherRepoImpl())
    ..userChanges.forEach((u) async {
      await metronomePresetUsecases.updateStorage(
        u == null ? metronomePresetStorage : createMetronomePresetSync(u.uuid),
      );
    });

  soundService = SoundService(metronomeSoundUsecases);
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
