import 'package:debtsimulator/pages/game_mode_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:debtsimulator/auth/auth_usecase.dart';
import 'package:debtsimulator/auth/login_page.dart';
import 'package:provider/provider.dart';

class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthUseCase>(
      builder: (context, value, child) {
        return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.blue, size: 40.0),
                ),
              );
            } else if (snapshot.hasData /* && !value.isGoogleOAuthLoading*/) {
              return const GAMEMODE();
            } else if (value.isLoading) {
              return Scaffold(
                body: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                      color: Colors.blue, size: 40.0),
                ),
              );
            } else {
              return const LoginPage();
            }
          },
        );
      },
    );
  }
}
