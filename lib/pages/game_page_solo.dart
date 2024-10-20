import 'package:debtsimulator/components/game_tiles.dart';
import 'package:debtsimulator/components/money_card.dart';
import 'package:debtsimulator/useCase/game_tile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class GamePageSolo extends StatefulWidget {
  const GamePageSolo({super.key});

  @override
  State<GamePageSolo> createState() => _GamePageSoloState();
}

class _GamePageSoloState extends State<GamePageSolo> {
  TextEditingController chatTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<GameTileUseCase>(
      builder: (context, value, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[300],
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    NeuContainer(
                      color: value.gameTileMap[value.getTileIndex()]!.color,
                      width: double.infinity,
                      child: Text(
                        value.gameTileMap[value.getTileIndex()]!.title,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    NeuContainer(
                      width: double.infinity,
                      color: Colors.white,
                      child: Text(
                        style: const TextStyle(fontSize: 18),
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 6, childAspectRatio: 1),
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NeuContainer(
                      color: Colors.amberAccent,
                      width: 150,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
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
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "???",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NeuTextButton(
                      buttonColor: Colors.orange,
                      buttonWidth: 110,
                      enableAnimation: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return chatDialog();
                          },
                        );
                      },
                      text: const Text(
                        "Chat",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 45,
                    ),
                    NeuTextButton(
                      buttonColor: Colors.blue,
                      buttonWidth: 110,
                      enableAnimation: true,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return statusDialog();
                          },
                        );
                      },
                      text: const Text(
                        "Status",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
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
                MoneyCard(text: "\$", amount: "900", iconColor: Colors.orange, textColor: Colors.black),
                SizedBox(
                  width: 70,
                ),
                MoneyCard(text: "!", amount: "-100", iconColor: Colors.red, textColor: Colors.red),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Container(
            decoration: BoxDecoration(
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(0, 5))],
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
                  debugPrint("Changed to ${value.currentIndex}");
                },
                shape: const CircleBorder(),
                child: const Text(
                  "GO",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget playerStatus() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: NeuContainer(
        height: 100,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(0, 5))],
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Players 1",
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Money: ",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                Text(
                  "Debt: ",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String chatVerify(value) {
    return value != null ? "" : "Please enter chat";
  }

  Widget inputTextWidget(String hint, Function validator, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: NeuContainer(
          child: TextFormField(
            validator: (value) => validator(value),
            controller: controller,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(0),
              ),
              focusColor: Colors.blue,
            ),
          ),
        ));
  }

  Dialog chatDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: NeuContainer(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  ),
                ),
                NeuContainer(
                  color: Colors.grey[200],
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: NeuContainer(
                            color: Colors.lightBlue,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const Text("Text 1"),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: NeuContainer(
                            color: Colors.lightBlue,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const Text("Text 2"),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: NeuContainer(
                            color: Colors.amber,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const Text("Visit me at: https://www.luhouyang.com"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                inputTextWidget("chat message...", chatVerify, chatTextController),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: NeuTextButton(
                    buttonHeight: MediaQuery.of(context).size.height * 0.07,
                    buttonWidth: MediaQuery.of(context).size.width,
                    enableAnimation: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: const Text(
                      "Send Chat",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Dialog statusDialog() {
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
                child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              ),
            ),
            playerStatus(),
            playerStatus(),
            playerStatus(),
            playerStatus(),
          ],
        ),
      ),
    );
  }
}
