import 'package:debtsimulator/useCase/game_state_usecase.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CircularPercentage extends StatefulWidget {
  final Widget center;

  const CircularPercentage({super.key, required this.center});

  @override
  State<CircularPercentage> createState() => _CircularPercentageState();
}

class _CircularPercentageState extends State<CircularPercentage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateUsecase>(
      builder: (context, gameStateUsecase, child) {
        return CircularPercentIndicator(
          radius: 28,
          circularStrokeCap: CircularStrokeCap.round,
          percent:
              gameStateUsecase.moveCountdown / 20000,
          progressColor: Colors.amber,
          backgroundColor: Colors.red,
          lineWidth: 3.0,
          center: widget.center
        );
      },
    );
  }
}
