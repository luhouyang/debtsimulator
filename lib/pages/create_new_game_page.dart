import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:debtsimulator/pages/waiting_room_page.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class CreateNewGamePage extends StatefulWidget {
  const CreateNewGamePage({super.key});

  @override
  State<CreateNewGamePage> createState() => _CreateNewGamePageState();
}

class _CreateNewGamePageState extends State<CreateNewGamePage> {
  TextEditingController roomNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            inputTextWidget(
                "Room Name", roomNameVerify, roomNameTextController),
            NeuTextButton(
              buttonHeight: MediaQuery.of(context).size.height * 0.1,
              buttonWidth: MediaQuery.of(context).size.width * 0.7,
              enableAnimation: true,
              buttonColor: Colors.red,
              onPressed: () async {
                FirebaseFirestore firebaseFirestore =
                    FirebaseFirestore.instance;

                String newId = firebaseFirestore.collection("games").doc().id;

                PlayerEntity playerEntity = PlayerEntity(
                    userId: userUsecase.userEntity.userId,
                    username: userUsecase.userEntity.username,
                    money: 0,
                    debt: 0,
                    ready: false,
                    state: 1,
                    afkCounter: 0,
                    boardIndex: 0,
                    assets: [],
                    moveHistory: []);
                List<Map<String, dynamic>> playerList = [playerEntity.toMap()];
                debugPrint(playerList.toString());

                await firebaseFirestore
                    .collection("games")
                    .doc(newId)
                    .set(GameEntity(
                            roomName: roomNameTextController.text,
                            gameId: newId,
                            moveCountdown: 10000,
                            gameStatus: false,
                            numPlayer: 1,
                            chatLog: [],
                            playerList: playerList)
                        .toMap())
                    .then((value) {
                  userUsecase.userEntity.ongoingGame = newId;
                  firebaseFirestore
                      .collection("users")
                      .doc(userUsecase.userEntity.userId)
                      .set(userUsecase.userEntity.toMap());
                      
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WaitingRoomPage(gameId: newId)));
                });
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
    ));
  }

  String roomNameVerify(value) {
    return value != null ? "" : "Please enter a valid Room Name";
  }

  Widget inputTextWidget(
      String hint, Function validator, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: NeuContainer(
          child: TextFormField(
            validator: (value) => validator(value),
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(0),
              ),
              focusColor: Colors.blue,
            ),
          ),
        ));
  }
}
