import 'dart:math';

import 'package:debtsimulator/entities/game_tile_entity.dart';
import 'package:flutter/material.dart';

class GameTileUseCase extends ChangeNotifier {
  Map<int, GameTileEntity> gameTileMap = {
    1: GameTileEntity(
      index: 1,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.red,
      money: 200,
      debt: 0,
    ),
    2: GameTileEntity(
      index: 2,
      title: "Start",
      description: "GG DEBT.\nLose RM200*100.",
      color: Colors.white,
      money: 0,
      debt: 20000,
    ),
    3: GameTileEntity(
      index: 3,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.purple,
      money: 200,
      debt: 0,
    ),
    4: GameTileEntity(
      index: 4,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.lightBlue,
      money: 200,
      debt: 0,
    ),
    5: GameTileEntity(
      index: 5,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.yellow,
      money: 200,
      debt: 0,
    ),
    6: GameTileEntity(
      index: 6,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.orange,
      money: 200,
      debt: 0,
    ),
    7: GameTileEntity(
      index: 7,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.grey,
      money: 200,
      debt: 0,
    ),
    12: GameTileEntity(
      index: 12,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.lightGreen,
      money: 200,
      debt: 0,
    ),
    13: GameTileEntity(
      index: 13,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.yellow,
      money: 200,
      debt: 0,
    ),
    18: GameTileEntity(
      index: 18,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.white,
      money: 200,
      debt: 0,
    ),
    19: GameTileEntity(
      index: 19,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.purple,
      money: 200,
      debt: 0,
    ),
    24: GameTileEntity(
      index: 24,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.lightBlue,
      money: 200,
      debt: 0,
    ),
    25: GameTileEntity(
      index: 25,
      title: "Market Up",
      description:
          "The stock market went up by 5%!\nClaim your dividend of RM200 if you invested.",
      color: Colors.lightGreen,
      money: 200,
      debt: 0,
    ),
    30: GameTileEntity(
      index: 30,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.grey,
      money: 200,
      debt: 0,
    ),
    31: GameTileEntity(
      index: 31,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.orange,
      money: 200,
      debt: 0,
    ),
    32: GameTileEntity(
      index: 32,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.white,
      money: 200,
      debt: 0,
    ),
    33: GameTileEntity(
      index: 33,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.lightGreen,
      money: 200,
      debt: 0,
    ),
    34: GameTileEntity(
      index: 34,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.lightBlue,
      money: 200,
      debt: 0,
    ),
    35: GameTileEntity(
      index: 35,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.purple,
      money: 200,
      debt: 0,
    ),
    36: GameTileEntity(
      index: 36,
      title: "Start",
      description: "New beginning.\nClaim RM200.",
      color: Colors.orange,
      money: 200,
      debt: 0,
    ),
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
    int nextIndex =
        currentIndex + Random(Random().nextInt(10000)).nextInt(7);
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
