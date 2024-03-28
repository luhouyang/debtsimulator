import 'package:flutter/material.dart';

class GameTileEntity {
  int index;
  String title;
  String description;
  Color color;
  double money;
  double debt;

  GameTileEntity(
      {required this.index,
      required this.title,
      required this.description,
      required this.color,
      required this.money,
      required this.debt,
      });
}
