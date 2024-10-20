import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/user_entity.dart';
import 'package:debtsimulator/pages/create_new_game_page.dart';
import 'package:debtsimulator/pages/game_page_solo.dart';
import 'package:debtsimulator/pages/info_page.dart';
import 'package:debtsimulator/pages/join_room_page.dart';
import 'package:debtsimulator/pages/profile_page.dart';
import 'package:debtsimulator/pages/waiting_room_page.dart';
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
    if (userUsecase.userEntity.userId == "") {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      userUsecase.setUser(UserEntity.fromMap(doc.data() as Map<String, dynamic>));
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color.fromARGB(255, 229, 229, 229),
            body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  color: const Color.fromARGB(255, 229, 229, 229),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onHover: (value) {},
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InfoPage(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 25, top: 20),
                            child: NeuContainer(
                              color: Colors.white,
                              width: 57,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "?",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 60),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/monopoly.png',
                                height: 195,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "PayDay",
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Gamified Financial Literacy App",
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              NeuTextButton(
                                buttonHeight: 70,
                                buttonWidth: 300,
                                enableAnimation: true,
                                buttonColor: Colors.white,
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePageSolo()));
                                },
                                text: const Text(
                                  "Solo Mode",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              NeuTextButton(
                                buttonHeight: 70,
                                buttonWidth: 300,
                                enableAnimation: true,
                                buttonColor: const Color.fromARGB(255, 243, 187, 65),
                                onPressed: () {
                                  if (userUsecase.userEntity.userId.length < 5) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.grey[500],
                                      content: const Text(
                                        "Loading Data",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                                        textAlign: TextAlign.center,
                                      ),
                                    ));
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return multiplayerDialog(userUsecase, context);
                                      },
                                    );
                                  }
                                },
                                text: const Text(
                                  "Multiplayer Mode",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20),
                              NeuTextButton(
                                buttonHeight: 70,
                                buttonWidth: 300,
                                enableAnimation: true,
                                buttonColor: const Color.fromARGB(255, 190, 243, 65),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                                },
                                text: const Text(
                                  "Profile",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  Dialog multiplayerDialog(UserUsecase userUsecase, BuildContext parentContext) {
    double heightSizedBox = MediaQuery.of(context).size.height * 0.05;

    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: NeuContainer(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width * 0.9,
        child: userUsecase.userEntity.ongoingGame.length < 5
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeuTextButton(
                          buttonHeight: MediaQuery.of(context).size.height * 0.1,
                          buttonWidth: MediaQuery.of(context).size.width * 0.7,
                          enableAnimation: true,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const JoinRoomPage()));
                          },
                          text: const Text(
                            "Join Game",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: heightSizedBox,
                        ),
                        NeuTextButton(
                          buttonHeight: MediaQuery.of(context).size.height * 0.1,
                          buttonWidth: MediaQuery.of(context).size.width * 0.7,
                          enableAnimation: true,
                          buttonColor: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewGamePage()));
                          },
                          text: const Text(
                            "New Game",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: heightSizedBox,
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NeuTextButton(
                          buttonHeight: MediaQuery.of(context).size.height * 0.1,
                          buttonWidth: MediaQuery.of(context).size.width * 0.7,
                          enableAnimation: true,
                          onPressed: () async {
                            await FirebaseFirestore.instance.collection("games").doc(userUsecase.userEntity.ongoingGame).get().then((value) {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WaitingRoomPage(
                                            gameId: userUsecase.userEntity.ongoingGame,
                                            doc: value,
                                          )));
                            });
                          },
                          text: const Text(
                            "Continue Game",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: heightSizedBox,
                        ),
                        NeuTextButton(
                          buttonColor: Colors.blue,
                          buttonHeight: MediaQuery.of(context).size.height * 0.1,
                          buttonWidth: MediaQuery.of(context).size.width * 0.7,
                          enableAnimation: true,
                          onPressed: () async {
                            String uid = FirebaseAuth.instance.currentUser!.uid;
                            DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
                            userUsecase.setUser(UserEntity.fromMap(doc.data() as Map<String, dynamic>)).then((value) {
                              Navigator.pop(context);
                              showDialog(
                                context: parentContext,
                                barrierDismissible: false,
                                builder: (context) {
                                  return multiplayerDialog(userUsecase, context);
                                },
                              );
                            });
                          },
                          text: const Text(
                            "Refresh",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: heightSizedBox,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
