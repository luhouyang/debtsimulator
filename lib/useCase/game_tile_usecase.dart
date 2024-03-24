import 'package:debtsimulator/entities/game_tile_entity.dart';
import 'package:flutter/material.dart';

class GameTileUseCase extends ChangeNotifier {
  Map<int, GameTileEntity> gameTileMap = {
    1: GameTileEntity(
        index: 1,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.red),
    2: GameTileEntity(
        index: 2,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.white),
    3: GameTileEntity(
        index: 3,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.purple),
    4: GameTileEntity(
        index: 4,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.lightBlue),
    5: GameTileEntity(
        index: 5,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.yellow),
    6: GameTileEntity(
        index: 6,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.orange),
    7: GameTileEntity(
        index: 7,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.grey),
    12: GameTileEntity(
        index: 12,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.lightGreen),
    13: GameTileEntity(
        index: 13,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.yellow),
    18: GameTileEntity(
        index: 18,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.white),
    19: GameTileEntity(
        index: 19,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.purple),
    24: GameTileEntity(
        index: 24,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.lightBlue),
    25: GameTileEntity(
        index: 25,
        title: "Market Up",
        description:
            "The stock market went up by 5%!\nClaim your dividend of RM200 if you invested.",
        color: Colors.lightGreen),
    30: GameTileEntity(
        index: 30,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.grey),
    31: GameTileEntity(
        index: 31,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.orange),
    32: GameTileEntity(
        index: 32,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.white),
    33: GameTileEntity(
        index: 33,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.lightGreen),
    34: GameTileEntity(
        index: 34,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.lightBlue),
    35: GameTileEntity(
        index: 35,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.purple),
    36: GameTileEntity(
        index: 36,
        title: "Start",
        description: "New beginning.\nClaim RM200.",
        color: Colors.orange),
  };

  int currentIndex = 1;
  List<int> availableIndex = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    12,
    13,
    18,
    19,
    24,
    25,
    30,
    31,
    32,
    33,
    34,
    35,
    36
  ];
  void moveToNext() {
    // Find the next available index greater than currentIndex
    int nextIndex = currentIndex + 1;
    if (nextIndex < gameTileMap.length) {
      currentIndex = nextIndex;
    } else {
      currentIndex = 1;
    }
    notifyListeners();
  }

  int getTileIndex() {
    return availableIndex[currentIndex];
  }
}
