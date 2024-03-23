import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:debtsimulator/auth/auth_usecase.dart';
import 'package:debtsimulator/auth/firebase_auth_services.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  //clientId: '00-xx.apps.googleusercontent.com',
  scopes: scopes,
);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var inEmailTextController = TextEditingController();
  var inPassTextController = TextEditingController();
  var upEmailTextController = TextEditingController();
  var upPassTextController = TextEditingController();

  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?

  bool _isSignIn = true;

  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      bool isAuthorized = account != null;
      // However, on web...
      if (kIsWeb && account != null) {
        isAuthorized = await _googleSignIn.canAccessScopes(scopes);
      }

      _currentUser = account;
      _isAuthorized = isAuthorized;

      if (!mounted) return;
      setState(() {});

      if (isAuthorized) {}
    });

    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    AuthUseCase authUseCase = Provider.of<AuthUseCase>(context, listen: false);
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 75, 25, 150),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(32.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(4, 8), // Shadow position
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
          child: Column(
            children: [
              _isSignIn
                  ? Column(
                      children: [
                        const Text(
                          "SIGN IN",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 36),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        signInWithGoogleButton(),
                        const Divider(color: Colors.black, height: 2.0),
                        inputTextWidget(
                            "email", emailVerify, inEmailTextController),
                        inputTextWidget(
                            "password", passwordVerify, inPassTextController),
                        forgotPassword(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 24, 0, 16),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    authUseCase.changeLoadingBool(true);
                                    await FirebaseAuthServices().signIn(
                                        context,
                                        inEmailTextController.text,
                                        inPassTextController.text,
                                        userUsecase);

                                    authUseCase.changeLoadingBool(false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(5.0),
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    "SIGN IN",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.black, height: 2.0),
                        createNewAccountText(),
                      ],
                    )
                  : Column(
                      children: [
                        const Text(
                          "SIGN UP",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 36),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        signInWithGoogleButton(),
                        const Divider(color: Colors.black, height: 2.0),
                        inputTextWidget(
                            "email", emailVerify, upEmailTextController),
                        inputTextWidget(
                            "password", passwordVerify, upPassTextController),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 24, 0, 16),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    authUseCase.changeLoadingBool(true);
                                    await FirebaseAuthServices().signUp(
                                        context,
                                        upEmailTextController.text,
                                        upPassTextController.text,
                                        userUsecase);

                                    authUseCase.changeLoadingBool(false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(5.0),
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.black, height: 2.0),
                        loginWithAccountText(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _handleSignIn() async {
    AuthUseCase authUseCase = Provider.of<AuthUseCase>(context, listen: false);
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    try {
      authUseCase.changeGoogleBool(true);
      _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      userUsecase.setGoogleUser(_currentUser!);

      await FirebaseAuth.instance.signInWithCredential(credential);

      authUseCase.changeGoogleBool(false);
    } catch (error) {
      print(error);
    }
  }

  Widget signInWithGoogleButton() {
    return ElevatedButton(
      onPressed: () async {
        _handleSignIn();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(5.0),
        elevation: 5,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      child: const Text(
        "Sign In with Google",
        style: TextStyle(color: Colors.lightBlue, fontSize: 16),
      ),
    );
  }

  String emailVerify(value) {
    return EmailValidator.validate(value ?? "")
        ? ""
        : "Please enter a valid email";
  }

  String passwordVerify(value) {
    return value != null ? "" : "Please enter a valid password";
  }

  Widget inputTextWidget(
      String hint, Function validator, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: TextFormField(
        validator: (value) => validator(value),
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(32.0),
            ),
            focusColor: Colors.blue,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
              text: TextSpan(
                  text: "forgot password?",
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (inEmailTextController.text.isNotEmpty) {
                        FirebaseAuthServices().forgotPassword(
                            context, inEmailTextController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blue[200],
                            duration: const Duration(milliseconds: 700),
                            content: const Text(
                              "Enter your email",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }
                    }))
        ],
      ),
    );
  }

  Widget createNewAccountText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16),
              children: <TextSpan>[
            const TextSpan(
                text: "Create a new account ",
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: "Here",
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _isSignIn = !_isSignIn;
                    setState(() {});
                  })
          ])),
    );
  }

  Widget loginWithAccountText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: RichText(
          text: TextSpan(
              style: const TextStyle(fontSize: 16),
              children: <TextSpan>[
            const TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: "Login",
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _isSignIn = !_isSignIn;
                    setState(() {});
                  })
          ])),
    );
  }
}
