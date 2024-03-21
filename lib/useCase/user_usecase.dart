import 'package:flutter/material.dart';
import 'package:debtsimulator/entities/user_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserUsecase extends ChangeNotifier {
  UserEntity userEntity = UserEntity(
      name: "name",
      favouriteFood: "favourite food",
      funFact: "fun fact",
      interval: 60.0,
      water: 0.0,
      profilePic: "");

  GoogleSignInAccount? user;

  void setGoogleUser(GoogleSignInAccount newUser) {
    user = newUser;
    notifyListeners();
  }
}
