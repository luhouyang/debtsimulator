import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/components/circular_percentage.dart';
import 'package:debtsimulator/components/game_tiles.dart';
import 'package:debtsimulator/components/money_card.dart';
import 'package:debtsimulator/entities/chat_entity.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:debtsimulator/useCase/game_state_usecase.dart';
import 'package:debtsimulator/useCase/game_tile_usecase.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  final String gameId;

  const GamePage({super.key, required this.gameId});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  CollectionReference gameColRef =
      FirebaseFirestore.instance.collection("games");
  TextEditingController chatTextController = TextEditingController();

  bool timerStarted = false;
  Timer timer = Timer(const Duration(milliseconds: 1), () {});

  void checkMoveCounter(GameStateUsecase gameStateUsecase) {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      gameStateUsecase.updateCountdown();
    });
  }

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
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    return Consumer<GameTileUseCase>(
      builder: (context, gameTileUseCase, child) {
        return StreamBuilder(
          stream: streamController.stream,
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
            if (!snapshot.hasData) {
              const Center(
                child: Text(
                  "No Data",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              );
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

            Future<void> setNextPlayer() async {
              if (playerEntity.state == 1) {
                playerEntity.state = 0;
                gameEntity.playerList[playerIndex] = playerEntity.toMap();

                int nextPlayerIndex = -1;
                gameEntity.playerList.asMap().forEach((key, value) {
                  if (key > playerIndex) {
                    PlayerEntity pe = PlayerEntity.fromMap(value);
                    if (pe.state != -1) {
                      nextPlayerIndex = key;
                    }
                  }
                });
                if (nextPlayerIndex == -1) {
                  gameEntity.playerList.asMap().forEach((key, value) {
                    if (key < playerIndex) {
                      PlayerEntity pe = PlayerEntity.fromMap(value);
                      if (pe.state != -1) {
                        nextPlayerIndex = key;
                      }
                    }
                  });

                  PlayerEntity nextPlayerEntity = PlayerEntity.fromMap(
                      gameEntity.playerList[nextPlayerIndex]);

                  if (nextPlayerEntity.state != -1) {
                    nextPlayerEntity.state = 1;
                    gameEntity.playerList[nextPlayerIndex] =
                        nextPlayerEntity.toMap();
                    gameEntity.moveCountdown == gameEntity.moveCountdownLimit;
                    await gameColRef.doc(widget.gameId).set(gameEntity.toMap());
                  }
                }
              }
            }

            GameStateUsecase gameStateUsecase =
                Provider.of<GameStateUsecase>(context, listen: false);

            if (!timerStarted) {
              timerStarted = true;
              checkMoveCounter(gameStateUsecase);
            }

            gameStateUsecase.updateCoundtdownOnFirebase(
                playerEntity, gameEntity, playerIndex);

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
                    /*SizedBox(
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                ),*/
                    Column(
                      children: [
                        NeuContainer(
                          color: gameTileUseCase
                              .gameTileMap[gameTileUseCase.getTileIndex()]!
                              .color,
                          width: double.infinity,
                          child: Text(
                            gameTileUseCase
                                .gameTileMap[gameTileUseCase.getTileIndex()]!
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
                                .gameTileMap[gameTileUseCase.getTileIndex()]!
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
                                  shape:
                                      BoxShape.circle, // Make the dot a circle
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
                        NeuTextButton(
                          buttonColor: Colors.orange,
                          buttonWidth: 110,
                          enableAnimation: true,
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return chatDialog(
                                    gameEntity, userUsecase, context);
                              },
                            );
                          },
                          text: const Text(
                            "Chat",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        NeuTextButton(
                          buttonColor: Colors.blue,
                          buttonWidth: 110,
                          enableAnimation: true,
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return statusDialog(gameEntity);
                              },
                            );
                          },
                          text: const Text(
                            "Status",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: const BottomAppBar(
                elevation: 0,
                color: Colors.transparent,
                shape: CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MoneyCard(
                        text: "\$",
                        amount: "900",
                        iconColor: Colors.orange,
                        textColor: Colors.black),
                    SizedBox(
                      width: 70,
                    ),
                    MoneyCard(
                        text: "!",
                        amount: "-100",
                        iconColor: Colors.red,
                        textColor: Colors.red),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(0, 5))
                    ],
                    border: Border.all(width: 3),
                    borderRadius: BorderRadius.circular(50)),
                margin: const EdgeInsets.all(5),
                height: 80,
                width: 80,
                child: FittedBox(
                  child: FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        gameTileUseCase.moveToNext();
                        debugPrint(
                            "Changed to ${gameTileUseCase.currentIndex}");

                        setNextPlayer();
                      },
                      shape: const CircleBorder(),
                      child: const CircularPercentage(
                        center: Text(
                          "GO",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget playerStatusCard(PlayerEntity playerEntity) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: NeuContainer(
        height: 100,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(0, 5))
                  ],
                  border: Border.all(width: 3),
                  borderRadius: BorderRadius.circular(50)),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerEntity.username,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Money: ${playerEntity.money}",
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                Text(
                  "Debt: ${playerEntity.debt}",
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String chatVerify(value) {
    return value != null ? "" : "Please enter chat";
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
              fillColor: Colors.grey[200],
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

  Dialog chatDialog(GameEntity gameEntity, UserUsecase userUsecase,
      BuildContext parentContext) {
    List<ChatEntity> chatLog = List.from(
        gameEntity.chatLog.map((element) => ChatEntity.fromMap(element)));

    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: NeuContainer(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                ),
              ),
              NeuContainer(
                color: Colors.grey[200],
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: chatLog.length,
                  itemBuilder: (context, index) {
                    return chatLog[index].userId ==
                            userUsecase.userEntity.userId
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                              child: NeuContainer(
                                color: Colors.amber,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    "${chatLog[index].username}:\n${chatLog[index].chat}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: NeuContainer(
                                color: Colors.lightBlue,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    "${chatLog[index].username}:\n${chatLog[index].chat}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
              inputTextWidget(
                  "chat message...", chatVerify, chatTextController),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: NeuTextButton(
                  buttonHeight: MediaQuery.of(context).size.height * 0.07,
                  buttonWidth: MediaQuery.of(context).size.width,
                  enableAnimation: true,
                  onPressed: () async {
                    ChatEntity chatEntity = ChatEntity(
                        userId: userUsecase.userEntity.userId,
                        username: userUsecase.userEntity.username,
                        chat: chatTextController.text,
                        profileIndex: userUsecase.userEntity.profileIndex);

                    gameEntity.chatLog.add(chatEntity.toMap());

                    await FirebaseFirestore.instance
                        .collection("games")
                        .doc(widget.gameId)
                        .set(gameEntity.toMap())
                        .then((value) {
                      chatTextController.clear();
                      Navigator.pop(context);
                      showDialog(
                        context: parentContext,
                        barrierDismissible: false,
                        builder: (context) {
                          return chatDialog(gameEntity, userUsecase, context);
                        },
                      );
                    });
                  },
                  text: const Text(
                    "Send Chat",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Dialog statusDialog(GameEntity gameEntity) {
    List<PlayerEntity> playerList = List.from(
        gameEntity.playerList.map((element) => PlayerEntity.fromMap(element)));

    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: NeuContainer(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: playerList.length,
                itemBuilder: (context, index) {
                  return playerStatusCard(playerList[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
