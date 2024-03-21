import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class MainPageWithAuth extends StatefulWidget {
  const MainPageWithAuth({super.key});

  @override
  State<MainPageWithAuth> createState() => _MainPageWithAuthState();
}

class _MainPageWithAuthState extends State<MainPageWithAuth> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?

  Future<void> _handleSignOut() async {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();

    userUsecase.user = null;
  }

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

      if (!mounted) return;
      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      if (isAuthorized) {}
    });

    _googleSignIn.signInSilently();
    if (!mounted) return;
    setState(() {
      _currentUser = _googleSignIn.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    userUsecase.user = _currentUser;

    return _currentUser == null
        ? () {
            return Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: _handleSignOut,
                  child: const Text('SIGN OUT'),
                ),
                Text("NO USER DATA YET"),
              ],
            );
          }()
        : Scaffold(
            body: ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ListTile(
                    leading: GoogleUserCircleAvatar(
                      identity: _currentUser!,
                    ),
                    title: Text(_currentUser!.displayName ?? ''),
                    subtitle: Text(_currentUser!.email),
                  ),
                  const Text('Signed in successfully.'),
                  if (_isAuthorized) ...<Widget>[
                    // The user has Authorized all required scopes
                    Text(_currentUser!.email),
                  ],
                  ElevatedButton(
                    onPressed: _handleSignOut,
                    child: const Text('SIGN OUT'),
                  ),
                ],
              ),
            ),
          );
  }
}
