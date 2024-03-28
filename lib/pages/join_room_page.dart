import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:debtsimulator/pages/waiting_room_page.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    Query query = FirebaseFirestore.instance
        .collection("games")
        .where("gameStatus", isEqualTo: false);

    return Scaffold(
      body: StreamBuilder(
          stream: query.snapshots(),
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
            // widget
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Join Game",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    if (!snapshot.hasData)
                      const Center(
                        child: Text(
                          "No Games",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                        ),
                      ),
                    if (snapshot.hasData)
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          GameEntity gameEntity = GameEntity.fromMap(
                              snapshot.data!.docs.first.data()
                                  as Map<String, dynamic>);

                          Color color = Color.fromARGB(
                              255,
                              Random().nextInt(105) + 150,
                              Random().nextInt(105) + 150,
                              Random().nextInt(105) + 150);

                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: InkWell(
                              onTap: () {},
                              onHover: (bol) {},
                              child: NeuContainer(
                                color: color.withOpacity(0.75),
                                width: 300,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      NeuContainer(
                                        color: color,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 8),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    gameEntity.roomName,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 28),
                                                  ),
                                                  Text(
                                                    gameEntity.gameId,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              const Expanded(child: SizedBox()),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          NeuContainer(
                                            color: color,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.22,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 4, 8, 4),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Players:",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    "${gameEntity.numPlayer}",
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 28),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          Expanded(
                                            child: NeuContainer(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.22,
                                              color: color,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        6, 2, 6, 2),
                                                child: ListView.builder(
                                                  itemCount: gameEntity
                                                      .playerList.length,
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    PlayerEntity playerEntity =
                                                        PlayerEntity.fromMap(
                                                            gameEntity
                                                                    .playerList[
                                                                index]);

                                                    return Text(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      "${index + 1}. ${playerEntity.username}",
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                          ),
                                          Expanded(
                                            child: NeuTextButton(
                                              buttonHeight:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.22,
                                              enableAnimation: true,
                                              buttonColor: color,
                                              onPressed: () async {
                                                bool joined = false;

                                                gameEntity.playerList
                                                    .asMap()
                                                    .forEach((key, value) {
                                                  if (value['userId'] ==
                                                      userUsecase
                                                          .userEntity.userId) {
                                                    joined = true;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    "YOU ARE IN THE GAME ALREADY")));
                                                  }
                                                });

                                                if (!joined) {
                                                  FirebaseFirestore
                                                      firebaseFirestore =
                                                      FirebaseFirestore
                                                          .instance;

                                                  PlayerEntity playerEntity =
                                                      PlayerEntity(
                                                          userId: userUsecase
                                                              .userEntity
                                                              .userId,
                                                          username: userUsecase
                                                              .userEntity
                                                              .username,
                                                          money: 0,
                                                          debt: 0,
                                                          ready: false,
                                                          state: 0,
                                                          afkCounter: 0,
                                                          boardIndex: 0,
                                                          assets: [],
                                                          moveHistory: []);

                                                  gameEntity.playerList.add(
                                                      playerEntity.toMap());
                                                  gameEntity.numPlayer++;

                                                  await firebaseFirestore
                                                      .collection("games")
                                                      .doc(gameEntity.gameId)
                                                      .set(gameEntity.toMap())
                                                      .then((value) {
                                                    userUsecase.userEntity
                                                            .ongoingGame =
                                                        gameEntity.gameId;
                                                    firebaseFirestore
                                                        .collection("users")
                                                        .doc(userUsecase
                                                            .userEntity.userId)
                                                        .set(userUsecase
                                                            .userEntity
                                                            .toMap());
                                                  });

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("games")
                                                      .doc(gameEntity.gameId)
                                                      .get()
                                                      .then((value) {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                WaitingRoomPage(
                                                                  gameId: userUsecase
                                                                      .userEntity
                                                                      .ongoingGame,
                                                                  doc: value,
                                                                )));
                                                  });
                                                }
                                              },
                                              text: const Text(
                                                "JOIN",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 28),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
