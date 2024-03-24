import 'package:debtsimulator/auth/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // @override
  // void initState() {
  //   FirebaseAuthServices().logout();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Column(
              children: [
                NeuContainer(
                  width: double.infinity,
                  child: Text(
                    "Market Up",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                ),
                NeuContainer(
                  width: double.infinity,
                  color: Colors.white,
                  child: Text(
                    style: TextStyle(fontSize: 18),
                    "The stock market went up by 5%!\nClaim your dividend of RM200 if you invested.",
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
                      return NeuContainer(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      );
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
              height: 30,
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Icon(Icons.add), Icon(Icons.delete)],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          shape: CircleBorder(),
          onPressed: () {},
          child: const Text(
            "GO ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          )),
    );
  }
}
