import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class GAMEMODE extends StatefulWidget {
  const GAMEMODE({super.key});

  @override
  State<GAMEMODE> createState() => _GAMEMODEState();
}

class _GAMEMODEState extends State<GAMEMODE> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 229, 229, 229),
            body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  color: const Color.fromARGB(255, 229, 229, 229),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(270, 30, 25, 0),
                        child: NeuContainer(
                          color: Colors.white,
                          width: 57,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(1, 55, 20, 10),
                        child: Image.asset(
                          'assets/monopoly.png',
                          height: 195,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(1, 1, 190, 1),
                            child: Text(
                              "PayDay",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(1, 1, 40, 1),
                            child: Text(
                              "Gamified Financial Literacy App",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      NeuContainer(
                          color: Colors.white,
                          width: 300,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Solo Mode",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      NeuContainer(
                          color: const Color.fromARGB(255, 243, 187, 65),
                          width: 300,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Multiplayer Mode",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      const SizedBox(height: 20),
                      NeuContainer(
                          color: const Color.fromARGB(255, 190, 243, 65),
                          width: 300,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Badges",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ],
                  ),
                ))));
  }
}