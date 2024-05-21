import 'package:flutter/material.dart';
import 'package:debtsimulator/entities/user_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserUsecase extends ChangeNotifier {
  final Map<int, String> avatars = {
    0: "assets/profile_placeholder.jpg",
    1: "assets/CREAM_badge.png",
    2: "assets/FIRE_BASED_badge.png",
    3: "assets/monopoly.png",
    4: "assets/FIRE_BASED_GOLDEN.png",
    5: "assets/almondmilfinverted.jpg"
  };
  
  UserEntity userEntity = UserEntity(
      userId: "",
      username: "",
      ongoingGame: "",
      profileIndex: 0,
      achievements: []);

  Future<void> setUser(UserEntity newUserEntity) async {
    userEntity = newUserEntity;
    notifyListeners();
  }

  GoogleSignInAccount? user;

  void setGoogleUser(GoogleSignInAccount newUser) {
    user = newUser;
    notifyListeners();
  }
}
