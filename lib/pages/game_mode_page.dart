import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/user_entity.dart';
import 'package:debtsimulator/pages/create_new_game_page.dart';
import 'package:debtsimulator/pages/game_page.dart';
import 'package:debtsimulator/pages/join_room_page.dart';
import 'package:debtsimulator/pages/profile_page.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class GAMEMODE extends StatefulWidget {
  const GAMEMODE({super.key});

  @override
  State<GAMEMODE> createState() => _GAMEMODEState();
}

class _GAMEMODEState extends State<GAMEMODE> {
  Future<void> getUserData() async {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    if (userUsecase.userEntity.username == "") {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      userUsecase
          .setUser(UserEntity.fromMap(doc.data() as Map<String, dynamic>));
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 229, 229, 229),
            body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  color: const Color.fromARGB(255, 229, 229, 229),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(270, 30, 25, 0),
                        child: NeuContainer(
                          color: Colors.white,
                          width: 57,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(1, 55, 20, 10),
                        child: Image.asset(
                          'assets/monopoly.png',
                          height: 195,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(1, 1, 190, 1),
                            child: Text(
                              "PayDay",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(1, 1, 40, 1),
                            child: Text(
                              "Gamified Financial Literacy App",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      NeuTextButton(
                        buttonHeight: 60,
                        buttonWidth: 300,
                        enableAnimation: true,
                        buttonColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GamePage()));
                        },
                        text: const Text(
                          "Solo Mode",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // NeuContainer(
                      //     color: Colors.white,
                      //     width: 300,
                      //     child: const Padding(
                      //       padding: EdgeInsets.symmetric(vertical: 8),
                      //       child: Text(
                      //         "Solo Mode",
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 28),
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     )),
                      const SizedBox(
                        height: 20,
                      ),
                      //TODO: create room -> waiting page (ready/quit) [streambuilder]
                      //TODO: join room [listview builder] -> waiting page (ready/quit) [streambuilder]
                      //TODO: when start -> GamePage() [streambuilder]
                      NeuTextButton(
                        buttonHeight: 60,
                        buttonWidth: 300,
                        enableAnimation: true,
                        buttonColor: const Color.fromARGB(255, 243, 187, 65),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return multiplayerDialog();
                            },
                          );
                        },
                        text: const Text(
                          "Multiplayer Mode",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) {
                      //           return const GamePage();
                      //         },
                      //       ),
                      //     );
                      //   },
                      //   child: NeuContainer(
                      //       color: const Color.fromARGB(255, 243, 187, 65),
                      //       width: 300,
                      //       child: const Padding(
                      //         padding: EdgeInsets.symmetric(vertical: 8),
                      //         child: Text(
                      //           "Multiplayer Mode",
                      //           style: TextStyle(
                      //               color: Colors.black,
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 28),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       )),
                      // ),
                      const SizedBox(height: 20),
                      NeuTextButton(
                        buttonHeight: 60,
                        buttonWidth: 300,
                        enableAnimation: true,
                        buttonColor: const Color.fromARGB(255, 190, 243, 65),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()));
                        },
                        text: const Text(
                          "Badges",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // NeuContainer(
                      //     color: const Color.fromARGB(255, 190, 243, 65),
                      //     width: 300,
                      //     child: const Padding(
                      //       padding: EdgeInsets.symmetric(vertical: 8),
                      //       child: Text(
                      //         "Badges",
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: 28),
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     ),),
                    ],
                  ),
                ))));
  }

  Dialog multiplayerDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: NeuContainer(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeuTextButton(
              buttonHeight: MediaQuery.of(context).size.height * 0.1,
              buttonWidth: MediaQuery.of(context).size.width * 0.7,
              enableAnimation: true,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JoinRoomPage()));
              },
              text: const Text(
                "Join Game",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            NeuTextButton(
              buttonHeight: MediaQuery.of(context).size.height * 0.1,
              buttonWidth: MediaQuery.of(context).size.width * 0.7,
              enableAnimation: true,
              buttonColor: Colors.red,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateNewGamePage()));
              },
              text: const Text(
                "New Game",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
