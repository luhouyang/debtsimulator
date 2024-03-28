import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:debtsimulator/pages/game_page.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class WaitingRoomPage extends StatefulWidget {
  final DocumentSnapshot doc;
  final String gameId;

  const WaitingRoomPage({super.key, required this.gameId, required this.doc});

  @override
  State<WaitingRoomPage> createState() => _WaitingRoomPageState();
}

class _WaitingRoomPageState extends State<WaitingRoomPage> {
  bool gameStarting = false;

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("games").doc(widget.gameId).snapshots(),
      initialData: widget.doc,
      builder: (context, snapshot) {
        // error handling
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.discreteCircle(
                color: Colors.blue, size: 40.0),
          );
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(
            child: Text(
              "No Data",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
          );
        } else {
          // logic in else clause for extra safety
          GameEntity gameEntity =
              GameEntity.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          if (gameEntity.numPlayer > 1) {
            int readyCounter = 0;
            gameEntity.playerList.asMap().forEach((key, value) {
              PlayerEntity playerEntity =
                  PlayerEntity.fromMap(gameEntity.playerList[key]);

              if (playerEntity.ready) {
                readyCounter++;
              }
            });

            if (readyCounter == gameEntity.numPlayer) {
              gameStarting = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                gameEntity.gameStatus = true;

                FirebaseFirestore.instance
                    .collection("games")
                    .doc(widget.gameId)
                    .set(gameEntity.toMap())
                    .then((value) {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GamePage(
                          gameId: widget.gameId,
                        ),
                      ));
                });
              });
            }
          }

          int playerIndex = 0;
          gameEntity.playerList.asMap().forEach((key, value) {
            if (value['userId'] == userUsecase.userEntity.userId) {
              playerIndex = key;
            }
          });

          PlayerEntity playerEntity =
              PlayerEntity.fromMap(gameEntity.playerList[playerIndex]);

          // widget
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 20),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.height * 0.9,
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width *
                            (0.15 / gameEntity.maxPlayer),
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: gameEntity.maxPlayer,
                    itemBuilder: (context, index) {
                      return index < gameEntity.playerList.length
                          ? () {
                              PlayerEntity readyPlayerEntity =
                                  PlayerEntity.fromMap(
                                      gameEntity.playerList[index]);

                              return NeuContainer(
                                color: readyPlayerEntity.ready
                                    ? Colors.green
                                    : Colors.red,
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black,
                                                offset: Offset(0, 5))
                                          ],
                                          border: Border.all(width: 3),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      margin: const EdgeInsets.all(5),
                                      height: 55,
                                      width: 55,
                                      child: FittedBox(
                                        child: ClipOval(
                                          child: Image.asset(
                                            "assets/profile_placeholder.jpg",
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      readyPlayerEntity.username,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      readyPlayerEntity.ready
                                          ? "READY"
                                          : "WAITING",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            }()
                          : NeuContainer(
                              color: Colors.grey[200],
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(0, 5))
                                        ],
                                        border: Border.all(width: 3),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    margin: const EdgeInsets.all(5),
                                    height: 55,
                                    width: 55,
                                    child: FittedBox(
                                      child: ClipOval(
                                        child: Image.asset(
                                          "assets/profile_placeholder.jpg",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Player ${index + 1}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NeuTextButton(
                      buttonColor:
                          playerEntity.ready ? Colors.red : Colors.green,
                      buttonHeight: MediaQuery.of(context).size.width * 0.2,
                      enableAnimation: true,
                      onPressed: () async {
                        if (!gameStarting) {
                          playerEntity.ready = !playerEntity.ready;
                          gameEntity.playerList[playerIndex] =
                              playerEntity.toMap();

                          await FirebaseFirestore.instance
                              .collection("games")
                              .doc(widget.gameId)
                              .set(gameEntity.toMap());
                        }
                      },
                      text: Text(
                        playerEntity.ready ? "WAIT" : "READY",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    NeuTextButton(
                      buttonHeight: MediaQuery.of(context).size.width * 0.2,
                      enableAnimation: true,
                      buttonColor: Colors.red,
                      onPressed: () async {
                        if (!gameStarting) {
                          FirebaseFirestore firebaseFirestore =
                              FirebaseFirestore.instance;

                          gameEntity.playerList.removeAt(playerIndex);
                          gameEntity.numPlayer--;

                          if (gameEntity.playerList.isEmpty) {
                            await firebaseFirestore
                                .collection("games")
                                .doc(widget.gameId)
                                .delete()
                                .then((value) {
                              userUsecase.userEntity.ongoingGame = "";
                              firebaseFirestore
                                  .collection("users")
                                  .doc(userUsecase.userEntity.userId)
                                  .set(userUsecase.userEntity.toMap());

                              Navigator.pop(context);
                            });
                          } else {
                            await firebaseFirestore
                                .collection("games")
                                .doc(widget.gameId)
                                .set(gameEntity.toMap())
                                .then((value) {
                              userUsecase.userEntity.ongoingGame = "";
                              firebaseFirestore
                                  .collection("users")
                                  .doc(userUsecase.userEntity.userId)
                                  .set(userUsecase.userEntity.toMap());

                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                      text: const Text(
                        "QUIT",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      },
    ));
  }
}
