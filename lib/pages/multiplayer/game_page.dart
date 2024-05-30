import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/components/game_tiles.dart';
import 'package:debtsimulator/components/money_card.dart';
import 'package:debtsimulator/components/u_is_dead.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:debtsimulator/entities/user_entity.dart';
import 'package:debtsimulator/pages/multiplayer/chat_button.dart';
import 'package:debtsimulator/pages/multiplayer/go_button.dart';
import 'package:debtsimulator/pages/multiplayer/status_button.dart';
import 'package:debtsimulator/useCase/game_tile_usecase.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  final String gameId;
  final DocumentSnapshot doc;

  const GamePage({super.key, required this.gameId, required this.doc});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late DocumentReference query;
  StreamController streamController = StreamController();

  @override
  void initState() {
    query = FirebaseFirestore.instance.collection("games").doc(widget.gameId);
    streamController.addStream(query.snapshots());
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    return Scaffold(
      body: Consumer<GameTileUseCase>(
        builder: (context, gameTileUseCase, child) {
          return StreamBuilder(
            stream: streamController.stream,
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
                return noDataGameEnd(userUsecase);
              }
              // game logic
              GameEntity gameEntity = GameEntity.fromMap(
                  snapshot.data!.data() as Map<String, dynamic>);

              int playerIndex = 0;
              gameEntity.playerList.asMap().forEach((key, value) {
                if (value['userId'] == userUsecase.userEntity.userId) {
                  playerIndex = key;
                }
              });

              PlayerEntity playerEntity =
                  PlayerEntity.fromMap(gameEntity.playerList[playerIndex]);

              // widget
              return Scaffold(
                  backgroundColor: Colors.grey[300],
                  body: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            NeuContainer(
                              color: gameTileUseCase
                                  .gameTileMap[gameTileUseCase.getTileIndex()]!
                                  .color,
                              width: double.infinity,
                              child: Text(
                                gameTileUseCase
                                    .gameTileMap[
                                        gameTileUseCase.getTileIndex()]!
                                    .title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            NeuContainer(
                              width: double.infinity,
                              color: Colors.white,
                              child: Text(
                                style: const TextStyle(fontSize: 18),
                                gameTileUseCase
                                    .gameTileMap[
                                        gameTileUseCase.getTileIndex()]!
                                    .description,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: 36,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 6,
                                      childAspectRatio: 1),
                              itemBuilder: (context, index) {
                                // Condition to check if it's an outermost square
                                if (index < 6 || // Top row
                                        index % 6 == 0 || // Leftmost column
                                        index % 6 == 5 || // Rightmost column
                                        index > 29 // Bottom row
                                    ) {
                                  return GameTile(index: index);
                                } else {
                                  // Empty container for inner squares
                                  return Container();
                                }
                              },
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width / 3 + 10,
                              top: MediaQuery.of(context).size.width / 3 + 35,
                              child: NeuContainer(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width / 3,
                              top: MediaQuery.of(context).size.width / 3 + 25,
                              child: NeuContainer(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape
                                          .circle, // Make the dot a circle
                                    ),
                                    height:
                                        20, // Adjust the size of the dot as needed
                                    width: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NeuContainer(
                              color: Colors.amberAccent,
                              width: 150,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Financial\nAdvice",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            NeuContainer(
                              color: Colors.purple[800],
                              width: 150,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "???",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ChatButton(
                              gameEntity: gameEntity,
                            ),
                            const SizedBox(
                              width: 45,
                            ),
                            StatusButton(gameEntity: gameEntity),
                          ],
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: BottomAppBar(
                    elevation: 0,
                    color: Colors.transparent,
                    shape: const CircularNotchedRectangle(),
                    child: playerEntity.state == -1
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              UIsDead(
                                  text: "no moneyyy", textColor: Colors.black),
                              UIsDead(text: "you broke", textColor: Colors.red),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MoneyCard(
                                  text: "\$",
                                  amount: playerEntity.money.toString(),
                                  iconColor: Colors.orange,
                                  textColor: Colors.black),
                              MoneyCard(
                                  text: "!-",
                                  amount: playerEntity.debt.toString(),
                                  iconColor: Colors.red,
                                  textColor: Colors.red),
                            ],
                          ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: GoButton(
                    playerIndex: playerIndex,
                    gameEntity: gameEntity,
                  ));
            },
          );
        },
      ),
    );
  }

  Widget noDataGameEnd(UserUsecase userUsecase) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "No Data\nor\nGame Ended\nPress \"Refresh\"",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: NeuTextButton(
            buttonColor: Colors.blue,
            buttonHeight: MediaQuery.of(context).size.height * 0.1,
            buttonWidth: MediaQuery.of(context).size.width * 0.7,
            enableAnimation: true,
            onPressed: () async {
              String uid = FirebaseAuth.instance.currentUser!.uid;
              DocumentSnapshot doc = await FirebaseFirestore.instance
                  .collection("users")
                  .doc(uid)
                  .get();
              userUsecase
                  .setUser(
                      UserEntity.fromMap(doc.data() as Map<String, dynamic>))
                  .then((value) {
                Navigator.pop(context);
              });
            },
            text: const Text(
              "Refresh",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
