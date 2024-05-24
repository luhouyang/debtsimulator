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
  Timer timer = Timer(const Duration(milliseconds: 100), () {});

  void checkMoveCounter(GameStateUsecase gameStateUsecase) {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (gameStateUsecase.currentMove != widget.gameEntity.currentMove) {
        gameStateUsecase.setCurrentMove(widget.gameEntity.currentMove);
        gameStateUsecase.setResetTimer();
      }
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

    bool eval = gameTileUseCase.moveToNext(); // update tile

    PlayerEntity playerEntity =
        PlayerEntity.fromMap(widget.gameEntity.playerList[widget.playerIndex]);

    gameStateUsecase.updateMoneyDebt(
        playerEntity,
        widget.gameEntity,
        widget.playerIndex,
        gameTileUseCase.getTileMoney(),
        gameTileUseCase.getTileDebt(),
        gameTileUseCase.getTileIndex()); // update money/debt

    if (playerEntity.state == 1) {
      // update own player data

      if (eval) {
        if (playerEntity.money < playerEntity.debt) {
          // check if money is enough to pay debt
          playerEntity.state = -1;
        } else {
          playerEntity.state = 0;
        }
      } else {
        playerEntity.state = 0;
      }

      gameEntity.playerList[widget.playerIndex] = playerEntity.toMap();

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
        gameEntity.currentMove = gameEntity.currentMove + 1;

        PlayerEntity nextPlayerEntity =
            PlayerEntity.fromMap(gameEntity.playerList[nextPlayerIndex]);

        nextPlayerEntity.state = 1;
        gameEntity.playerList[nextPlayerIndex] = nextPlayerEntity.toMap();
        await FirebaseFirestore.instance
            .collection("games")
            .doc(gameEntity.gameId)
            .set(gameEntity.toMap())
            .then((value) {
          gameStateUsecase.setCurrentMove(gameEntity.currentMove);
          gameStateUsecase.setResetTimer();
        });
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
            gameStateUsecase.updateCoundtdownGoAFK(
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
              backgroundColor:
                  (playerEntity.state == 1) ? Colors.red : Colors.blue,
              onPressed: () async {
                if (playerEntity.state == 1) {
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
