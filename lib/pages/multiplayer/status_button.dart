import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/entities/player_entity.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class StatusButton extends StatefulWidget {
  final GameEntity gameEntity;

  const StatusButton({super.key, required this.gameEntity});

  @override
  State<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    return NeuTextButton(
      buttonColor: Colors.blue,
      buttonWidth: 110,
      enableAnimation: true,
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return statusDialog(widget.gameEntity);
          },
        );
      },
      text: const Text(
        "Status",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget playerStatusCard(PlayerEntity playerEntity) {
    double difference = playerEntity.money - playerEntity.debt;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: NeuContainer(
        height: 100,
        color: difference < -100 ? Colors.red
        : difference < 0 ? Colors.amber
        : difference < 100 ? Colors.grey
        : Colors.green,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(0, 5))
                  ],
                  border: Border.all(width: 3),
                  borderRadius: BorderRadius.circular(50)),
              margin: const EdgeInsets.all(5),
              height: 55,
              width: 55,
              child: FittedBox(
                child: ClipOval(
                  child: Image.asset(
                    "assets/profile_placeholder.jpg",
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playerEntity.username,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Money: ${playerEntity.money}",
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
                Text(
                  "Debt: ${playerEntity.debt}",
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Dialog statusDialog(GameEntity gameEntity) {
    List<PlayerEntity> playerList = List.from(
        gameEntity.playerList.map((element) => PlayerEntity.fromMap(element)));

    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: NeuContainer(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: playerList.length,
                itemBuilder: (context, index) {
                  return playerStatusCard(playerList[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
