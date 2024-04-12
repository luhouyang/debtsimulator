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
      title: "GG Debt",
      description: "You fell in a hole and lost your change.\nLose RM20.",
      color: Colors.white,
      money: 0,
      debt: 20,
    ),
    3: GameTileEntity(
      index: 3,
      title: "Birthday",
      description: "Its your birthday.\nClaim RM50 from your parents.",
      color: Colors.purple,
      money: 50,
      debt: 0,
    ),
    4: GameTileEntity(
      index: 4,
      title: "Lunch",
      description: "Commoners food.\nPay RM10.",
      color: Colors.lightBlue,
      money: 0,
      debt: 10,
    ),
    5: GameTileEntity(
      index: 5,
      title: "Bill",
      description: "Electricity bill.\nPay RM100.",
      color: Colors.yellow,
      money: 0,
      debt: 100,
    ),
    6: GameTileEntity(
      index: 6,
      title: "Work",
      description: "Working hard pays off.\nClaim RM500.",
      color: Colors.orange,
      money: 500,
      debt: 0,
    ),
    7: GameTileEntity(
      index: 7,
      title: "Money",
      description: "You found RM50 lying on the ground.\nClaim RM50.",
      color: Colors.grey,
      money: 50,
      debt: 0,
    ),
    12: GameTileEntity(
      index: 12,
      title: "Bill",
      description: "Water bill.\nPay RM100.",
      color: Colors.lightGreen,
      money: 0,
      debt: 100,
    ),
    13: GameTileEntity(
      index: 13,
      title: "Dinner",
      description: "Commoners dinner.\nPay RM10.",
      color: Colors.yellow,
      money: 0,
      debt: 10,
    ),
    18: GameTileEntity(
      index: 18,
      title: "Car",
      description: "Pay your car instalments.\nPay RM200.",
      color: Colors.white,
      money: 0,
      debt: 200,
    ),
    19: GameTileEntity(
      index: 19,
      title: "Work",
      description: "Working hard pays off.\nClaim RM250.",
      color: Colors.purple,
      money: 250,
      debt: 0,
    ),
    24: GameTileEntity(
      index: 24,
      title: "Work",
      description: "Working hard pays off.\nClaim RM400.",
      color: Colors.lightBlue,
      money: 400,
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
      title: "Lunch",
      description: "VERY expensive lunch.\nPay RM100.",
      color: Colors.grey,
      money: 0,
      debt: 100,
    ),
    31: GameTileEntity(
      index: 31,
      title: "Dinner",
      description: "VERY expensive dinner.\nPay RM100.",
      color: Colors.orange,
      money: 0,
      debt: 100,
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
      title: "Lucky",
      description: "You hit jackpot.\nClaim RM10000.",
      color: Colors.purple,
      money: 10000,
      debt: 0,
    ),
    36: GameTileEntity(
      index: 36,
      title: "Unlucky",
      description: "Lost your wallet.\nLose RM11000.",
      color: Colors.orange,
      money: 0,
      debt: 11000,
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
    int nextIndex = currentIndex + Random().nextInt(6) + 1;
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

  double getTileMoney() {
    GameTileEntity gameTileEntity = gameTileMap[currentIndex]!;
    return gameTileEntity.money;
  }

    double getTileDebt() {
    GameTileEntity gameTileEntity = gameTileMap[currentIndex]!;
    return gameTileEntity.debt;
  }
}
