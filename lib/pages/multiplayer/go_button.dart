import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:debtsimulator/pages/multiplayer/circular_percentage.dart';
import 'package:debtsimulator/useCase/game_state_usecase.dart';
import 'package:debtsimulator/useCase/game_tile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoButton extends StatefulWidget {
  final int playerIndex;
  final GameEntity gameEntity;

  const GoButton(
      {super.key, required this.playerIndex, required this.gameEntity});

  @override
  State<GoButton> createState() => _GoButtonState();
}

class _GoButtonState extends State<GoButton> {
  Timer timer = Timer(const Duration(milliseconds: 1), () {});

  void checkMoveCounter(GameStateUsecase gameStateUsecase) {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      gameStateUsecase.updateCountdown();
    });
  }

  @override
  void initState() {
    GameStateUsecase gameStateUsecase =
        Provider.of<GameStateUsecase>(context, listen: false);
    checkMoveCounter(gameStateUsecase);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // game loop
  Future<void> setNextPlayer(
      PlayerEntity playerEntity, GameEntity gameEntity) async {
    GameTileUseCase gameTileUseCase =
        Provider.of<GameTileUseCase>(context, listen: false);
    GameStateUsecase gameStateUsecase =
        Provider.of<GameStateUsecase>(context, listen: false);

    gameTileUseCase.moveToNext(); // update tile

    PlayerEntity playerEntity =
        PlayerEntity.fromMap(widget.gameEntity.playerList[widget.playerIndex]);

    gameStateUsecase.updateMoneyDebt(
        playerEntity,
        widget.gameEntity,
        widget.playerIndex,
        gameTileUseCase.getTileMoney(),
        gameTileUseCase.getTileDebt(),
        gameTileUseCase.getTileIndex()); // update money/debt

    if (gameTileUseCase.getTileIndex() == 1) {
      if (playerEntity.money < playerEntity.debt) {
        playerEntity.state = -1;
        widget.gameEntity.playerList[widget.playerIndex] = playerEntity.toMap();
      }
    } // check if money is enough to pay debt

    if (playerEntity.state == 1) {
      // update own player data
      playerEntity.state = 0;
      gameEntity.playerList[widget.playerIndex] = playerEntity.toMap();
      gameEntity.currentMove++;

      // search for next player in queue
      int nextPlayerIndex = -1;
      gameEntity.playerList.asMap().forEach((key, value) {
        if (key > widget.playerIndex) {
          PlayerEntity pe = PlayerEntity.fromMap(value);
          if (pe.state != -1) {
            nextPlayerIndex = key;
          }
        }
      });
      if (nextPlayerIndex == -1) {
        gameEntity.playerList.asMap().forEach((key, value) {
          if (key < widget.playerIndex) {
            PlayerEntity pe = PlayerEntity.fromMap(value);
            if (pe.state != -1) {
              nextPlayerIndex = key;
            }
          }
        });
      }

      if (nextPlayerIndex == -1) {
        // ends game in all player state = -1
        GameStateUsecase gameStateUsecase =
            Provider.of<GameStateUsecase>(context, listen: false);
        await FirebaseFirestore.instance
            .collection("games")
            .doc(gameEntity.gameId)
            .delete()
            .then((value) {
          gameEntity.playerList.asMap().forEach((key, value) {
            PlayerEntity deletePE = PlayerEntity.fromMap(value);
            FirebaseFirestore.instance
                .collection("users")
                .doc(deletePE.userId)
                .set({"ongoingGame": ""}, SetOptions(merge: true));
          });
          gameStateUsecase.setGameEnded();
        });
      } else {
        PlayerEntity nextPlayerEntity =
            PlayerEntity.fromMap(gameEntity.playerList[nextPlayerIndex]);

        nextPlayerEntity.state = 1;
        gameEntity.playerList[nextPlayerIndex] = nextPlayerEntity.toMap();
        await FirebaseFirestore.instance
            .collection("games")
            .doc(gameEntity.gameId)
            .set(gameEntity.toMap())
            .then((value) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameTileUseCase, GameStateUsecase>(
      builder: (context, gameTileUseCase, gameStatUesecase, child) {
        GameStateUsecase gameStateUsecase =
            Provider.of<GameStateUsecase>(context, listen: false);

        PlayerEntity playerEntity = PlayerEntity.fromMap(
            widget.gameEntity.playerList[widget.playerIndex]);

        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            gameStateUsecase.updateCoundtdown(
                playerEntity, widget.gameEntity, widget.playerIndex);
          },
        );

        return Container(
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
              backgroundColor: (widget.gameEntity.currentMove ==
                          gameStateUsecase.currentMove &&
                      playerEntity.state == 1)
                  ? Colors.red
                  : Colors.blue,
              onPressed: () async {
                if (widget.gameEntity.currentMove ==
                        gameStateUsecase.currentMove &&
                    playerEntity.state == 1) {
                  await setNextPlayer(playerEntity, widget.gameEntity);
                }
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
              ),
            ),
          ),
        );
      },
    );
  }
}
