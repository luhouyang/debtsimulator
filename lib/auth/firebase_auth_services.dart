import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';

class FirebaseAuthServices {
  Future<void> signUp(BuildContext context, String email, String password,
      String username, UserUsecase userUsecase) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((UserCredential userCredential) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(UserEntity(
                userId: userCredential.user!.uid,
                username: username,
                ongoingGame: "",
                profileIndex: 0,
                achievements: []).toMap());
      });

      debugPrint("SIGNING UP");
    } catch (e) {
      // Handle authentication exceptions
      debugPrint("Error during create user: $e");
    }
  }

  Future<void> signIn(BuildContext context, String email, String password,
      UserUsecase userUsecase) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((UserCredential userCredential) async {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .get();
        UserEntity userEntity =
            UserEntity.fromMap(doc.data() as Map<String, dynamic>);
        userUsecase.setUser(userEntity);
      });
      debugPrint("SIGNING IN");
    } catch (e) {
      // Handle authentication exceptions
      debugPrint("Error during sign-in: $e");
    }
  }

  Future<void> logout(UserUsecase userUsecase) async {
    userUsecase.setUser(UserEntity(
                userId: "",
                username: "",
                ongoingGame: "",
                profileIndex: 0,
                achievements: []));
    await FirebaseAuth.instance.signOut();
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle exceptions
      debugPrint("Error during send reset email: $e");
    }
  }
}
