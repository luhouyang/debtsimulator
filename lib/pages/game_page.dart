import 'package:debtsimulator/components/game_tiles.dart';
import 'package:debtsimulator/components/money_card.dart';
import 'package:debtsimulator/useCase/game_tile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameTileUseCase>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                ),
                Column(
                  children: [
                    NeuContainer(
                      color: value.gameTileMap[value.getTileIndex()]!.color,
                      width: double.infinity,
                      child: Text(
                        value.gameTileMap[value.getTileIndex()]!.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    NeuContainer(
                      width: double.infinity,
                      color: Colors.white,
                      child: Text(
                        style: TextStyle(fontSize: 18),
                        value.gameTileMap[value.getTileIndex()]!.description,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                Stack(
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: 36,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 6,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        // Condition to check if it's an outermost square
                        if (index < 6 || // Top row
                                index % 6 == 0 || // Leftmost column
                                index % 6 == 5 || // Rightmost column
                                index > 29 // Bottom row
                            ) {
                          return GameTile(index: index);
                        } else {
                          // Empty container for inner squares
                          return Container();
                        }
                      },
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 3 + 10,
                      top: MediaQuery.of(context).size.width / 3 + 35,
                      child: NeuContainer(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 3,
                      top: MediaQuery.of(context).size.width / 3 + 25,
                      child: NeuContainer(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle, // Make the dot a circle
                            ),
                            height: 20, // Adjust the size of the dot as needed
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NeuContainer(
                      color: Colors.amberAccent,
                      width: 150,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Financial\nAdvice",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    NeuContainer(
                      color: Colors.purple[800],
                      width: 150,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "???",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          bottomNavigationBar: const BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MoneyCard(
                    text: "\$",
                    amount: "900",
                    iconColor: Colors.orange,
                    textColor: Colors.black),
                SizedBox(
                  width: 70,
                ),
                MoneyCard(
                    text: "!",
                    amount: "-100",
                    iconColor: Colors.red,
                    textColor: Colors.red),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
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
                backgroundColor: Colors.red,
                onPressed: () {
                  value.moveToNext();
                  debugPrint("Changed to" + value.currentIndex.toString());
                },
                shape: const CircleBorder(),
                child: const Text(
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
