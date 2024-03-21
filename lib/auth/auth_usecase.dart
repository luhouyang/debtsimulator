import 'package:flutter/material.dart';

class AuthUseCase extends ChangeNotifier {
  bool isLoading = false;
  bool isGoogleOAuthLoading = false;

  void changeLoadingBool(bool boolean) {
    isLoading = boolean;
    notifyListeners();
  }

  void changeGoogleBool(bool boolean) {
    isGoogleOAuthLoading = boolean;
    notifyListeners();
  }
}
