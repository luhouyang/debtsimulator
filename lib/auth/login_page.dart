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

  bool buttonPressed = false;

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
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.fromLTRB(25, 75, 25, 150),
          color: const Color.fromARGB(255, 229, 229, 229),
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 50),
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
                        orSignInWithWidget(),
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
                                child: Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 0,
                                        blurStyle: BlurStyle.solid,
                                        offset: buttonPressed
                                            ? const Offset(0, 0)
                                            : const Offset(-6, 6))
                                  ]),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        buttonPressed = true;
                                      });
                                      authUseCase.changeLoadingBool(true);
                                      await FirebaseAuthServices().signIn(
                                          context,
                                          inEmailTextController.text,
                                          inPassTextController.text,
                                          userUsecase);

                                      authUseCase.changeLoadingBool(false);
                                      if (!mounted) return;
                                      setState(() {
                                        buttonPressed = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: buttonPressed
                                          ? const EdgeInsets.fromLTRB(
                                              6, 9, 6, 9)
                                          : const EdgeInsets.all(8),
                                      elevation: 5,
                                      shape: BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      shadowColor: Colors.transparent,
                                      backgroundColor: const Color.fromARGB(
                                          255, 219, 254, 1),
                                    ),
                                    child: const Text(
                                      "SIGN IN",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                            color: Colors.black, thickness: 1.5, height: 3.0),
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
                        orSignInWithWidget(),
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
                                child: Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 0,
                                        blurStyle: BlurStyle.solid,
                                        offset: buttonPressed
                                            ? const Offset(0, 0)
                                            : const Offset(-6, 6))
                                  ]),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        buttonPressed = true;
                                      });
                                      authUseCase.changeLoadingBool(true);
                                      await FirebaseAuthServices().signUp(
                                          context,
                                          upEmailTextController.text,
                                          upPassTextController.text,
                                          userUsecase);

                                      authUseCase.changeLoadingBool(false);
                                      if (!mounted) return;
                                      setState(() {
                                        buttonPressed = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: buttonPressed
                                          ? const EdgeInsets.fromLTRB(
                                              6, 9, 6, 9)
                                          : const EdgeInsets.all(8),
                                      elevation: 5,
                                      shape: BeveledRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      shadowColor: Colors.transparent,
                                      backgroundColor: const Color.fromARGB(
                                          255, 219, 254, 1),
                                    ),
                                    child: const Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                            color: Colors.black, thickness: 1.5, height: 3.0),
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
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            blurStyle: BlurStyle.solid,
            offset: buttonPressed ? const Offset(0, 0) : const Offset(-6, 6))
      ]),
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            buttonPressed = true;
          });
          _handleSignIn();
          setState(() {
            buttonPressed = false;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: buttonPressed
              ? const EdgeInsets.fromLTRB(6, 9, 6, 9)
              : const EdgeInsets.all(8),
          elevation: 5,
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
          shadowColor: Colors.transparent,
          backgroundColor: const Color.fromARGB(255, 0, 132, 255),
        ),
        child: Text(
          _isSignIn ? "Sign In with Google" : "Sign Up with Google",
          style: const TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
    );
  }

  Widget orSignInWithWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            ),
          ),
          const Text("   Or Sign In With   ",
              style: TextStyle(color: Colors.black)),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
            ),
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        decoration: const BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black,
              blurRadius: 0,
              blurStyle: BlurStyle.solid,
              offset: Offset(-6, 6))
        ]),
        child: TextFormField(
          validator: (value) => validator(value),
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(0),
              ),
              focusColor: Colors.blue,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black)),
        ),
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
