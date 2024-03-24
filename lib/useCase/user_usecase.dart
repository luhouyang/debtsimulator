import 'package:flutter/material.dart';
import 'package:debtsimulator/entities/user_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserUsecase extends ChangeNotifier {
  UserEntity userEntity = UserEntity(
    username: "",
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
