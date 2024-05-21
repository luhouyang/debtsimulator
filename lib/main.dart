import 'package:debtsimulator/auth/auth_stream.dart';
import 'package:debtsimulator/auth/auth_usecase.dart';
import 'package:debtsimulator/useCase/game_state_usecase.dart';
import 'package:debtsimulator/useCase/game_tile_usecase.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserUsecase(),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthUseCase(),
          ),
          ChangeNotifierProvider(
            create: (context) => GameTileUseCase(),
          ),
          ChangeNotifierProvider(
            create: (context) => GameStateUsecase(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const AuthStream(),
        ));
  }
}
