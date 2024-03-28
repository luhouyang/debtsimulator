import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:flutter/material.dart';

class GameStateUsecase extends ChangeNotifier {
  int currentMove = 0;
  double moveCountdown = 20000;

  void updateCountdown() {
    if (moveCountdown > 0) {
      moveCountdown -= 50;
      debugPrint(moveCountdown.toString());
      notifyListeners();
    }
  }

  void updateCoundtdownOnFirebase(
      PlayerEntity playerEntity, GameEntity gameEntity, int playerIndex) {
    
    if (gameEntity.currentMove != currentMove) {
      moveCountdown = 20000;
      currentMove = gameEntity.currentMove;
      if (playerEntity.state == 1) {
        if (moveCountdown > 0) {
          debugPrint(moveCountdown.toString());
          if (moveCountdown == 0) {
            playerEntity.state = 0;
            playerEntity.afkCounter++;
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

            PlayerEntity nextPlayerEntity =
                PlayerEntity.fromMap(gameEntity.playerList[nextPlayerIndex]);

            if (nextPlayerEntity.state != -1) {
              nextPlayerEntity.state = 1;
              gameEntity.playerList[nextPlayerIndex] = nextPlayerEntity.toMap();
              gameEntity.moveCountdown == gameEntity.moveCountdownLimit;
              FirebaseFirestore.instance
                  .collection("games")
                  .doc(gameEntity.gameId)
                  .set(gameEntity.toMap());
            }
          } else if (moveCountdown % 5000 == 0) {
            gameEntity.moveCountdown = moveCountdown;
            FirebaseFirestore.instance
                .collection("games")
                .doc(gameEntity.gameId)
                .set(gameEntity.toMap());
          }
        }
      }
      notifyListeners();
    } else {}
  }
}
