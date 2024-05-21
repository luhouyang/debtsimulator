import 'package:debtsimulator/useCase/game_tile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class GameTile extends StatelessWidget {
  final int index;
  GameTile({super.key, required this.index});

  final Map<int, Color> colorMap = {
    1: Colors.red,
    2: Colors.white,
    3: Colors.purple,
    4: Colors.lightBlue,
    5: Colors.yellow,
    6: Colors.orange,
    7: Colors.grey,
    12: Colors.lightGreen,
    13: Colors.white,
    18: Colors.white,
    19: Colors.white,
    24: Colors.white,
    25: Colors.white,
    30: Colors.white,
    31: Colors.orange,
    32: Colors.white,
    33: Colors.white,
    34: Colors.white,
    35: Colors.white,
    36: Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
        borderRadius: BorderRadius.circular(10),
        color: GameTileUseCase().gameTileMap[index + 1]!.color);
  }
}
