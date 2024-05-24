import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:flutter/material.dart';

class GameStateUsecase extends ChangeNotifier {
  bool gameEnded = false;

  bool resetTimer = false;
  int currentMove = 0;
  double moveCountdown = 30000;

  void setGameEnded() {
    gameEnded = true;
    notifyListeners();
  }

  void setResetTimer() {
    moveCountdown = 30000;
    notifyListeners();
  }

  void setCurrentMove(int move) {
    currentMove = move;
    notifyListeners();
  }

  void updateCountdown() {
    moveCountdown -= 100;
    if (moveCountdown < 0 && !resetTimer) {
      resetTimer = true;
    }
    notifyListeners();
  }

  Future<void> updateCoundtdownGoAFK(
      PlayerEntity playerEntity, GameEntity gameEntity, int playerIndex) async {
    if (resetTimer) {
      if (playerEntity.state == 1) {
        if (resetTimer) {
          playerEntity.afkCounter++;
        }
        gameEntity.currentMove = gameEntity.currentMove +
            1; // allow countdown to be resetted once without change in database
        resetTimer = false;

        playerEntity.state = 0;
        if (playerEntity.afkCounter >= 3) {
          playerEntity.state = -1;
        }

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
        }

        if (nextPlayerIndex == -1) {
          // ends game
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
            gameEnded = true;
            notifyListeners();
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
              .then((value) {
            notifyListeners();
          });
        }
      } else {
        if (gameEntity.currentMove != currentMove) {
          resetTimer = false;
          moveCountdown = 30000;
          currentMove = gameEntity.currentMove;
          notifyListeners();
        }
      }
    }
  }

  updateMoneyDebt(PlayerEntity playerEntity, GameEntity gameEntity,
      int playerIndex, double money, double debt, int boardIndex) {
    playerEntity.boardIndex = boardIndex;
    playerEntity.money += money;
    playerEntity.debt += debt;

    gameEntity.playerList[playerIndex] = playerEntity.toMap();
    notifyListeners();
  }
}
