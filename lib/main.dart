import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meme_editor_app/core/bloc/offline_mode_bloc.dart';
import 'package:meme_editor_app/core/bloc/theme_bloc.dart';
import 'package:meme_editor_app/core/network/api_client.dart';
import 'package:meme_editor_app/features/editor/data/models/meme_edit_metadata.dart';
import 'package:meme_editor_app/features/home/data/datasources/meme_local_data_source.dart';
import 'package:meme_editor_app/features/home/data/datasources/meme_remote_data_source.dart';
import 'package:meme_editor_app/features/home/data/models/meme_model.dart';
import 'package:meme_editor_app/features/home/data/repositories/meme_repository_impl.dart';
import 'package:meme_editor_app/features/home/domain/repositories/meme_repository.dart';
import 'package:meme_editor_app/features/home/domain/usecases/get_memes.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:meme_editor_app/features/home/presentation/bloc/home_event.dart';
import 'package:http/http.dart' as http;
import 'package:meme_editor_app/features/home/presentation/pages/home_page.dart';

final String apiUrl = dotenv.env['API_URL'] ?? "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(MemeModelAdapter());
  Hive.registerAdapter(MemeEditMetadataAdapter());
  Hive.registerAdapter(DraggableStickerAdapter());
  Hive.registerAdapter(DraggableTextAdapter());
  await Hive.openBox('settings');
  await Hive.openBox<MemeModel>('memes');

  // cek offline mode
  final settingsBox = Hive.box('settings');
  final isOfflineMode = settingsBox.get('isOfflineMode', defaultValue: false);

  final apiClient = ApiClient(http.Client());
  final remoteDataSource = MemeRemoteDataSourceImpl(apiClient, apiUrl);
  final localDataSource = MemeLocalDataSourceImpl();

  final repository =
      MemeRepositoryImpl(remoteDataSource, localDataSource, isOfflineMode);
  final getMemes = GetMemes(repository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(getMemes: getMemes)..add(LoadMemes()),
        ),
        BlocProvider(create: (_) => OfflineModeBloc()),
        BlocProvider(
          create: (_) => ThemeBloc(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(http.Client());

    final remoteDataSource = MemeRemoteDataSourceImpl(apiClient, apiUrl);
    final localDataSource = MemeLocalDataSourceImpl();
    return BlocBuilder<OfflineModeBloc, OfflineModeState>(
      builder: (context, offlineState) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            final repository = MemeRepositoryImpl(
              remoteDataSource,
              localDataSource,
              offlineState.isOfflineMode,
            );

            return RepositoryProvider<MemeRepository>(
              create: (_) => repository,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Meme Editor',
                theme: themeState.themeData,
                home: const HomePage(),
              ),
            );
          },
        );
      },
    );
  }
}
