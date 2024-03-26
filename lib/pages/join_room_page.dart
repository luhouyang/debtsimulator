import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  // instance of StreamController to put data to the stream
  final StreamController _controller = StreamController();
  List<int> intList = [0];

  // simulate a data source
  addStreamData() async {
    for (var i = 0; i < 100; i++) {
      await Future.delayed(const Duration(seconds: 2));
      // add data to the stram
      intList.add(i);
      _controller.sink.add(intList);
    }
  }

  @override
  void initState() {
    // run the stream
    addStreamData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection("games")
        .where("gameStatus", isEqualTo: false);

    return Scaffold(
      body: StreamBuilder(
          stream: query.snapshots(), //_controller.stream,
          builder: (context, snapshot) {
            // check the snapshot (hasError, hasData, etc.)
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.blue, size: 40.0),
              );
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Join Game",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                      textAlign: TextAlign.center,
                    ),
                    if (!snapshot.hasData)
                      const Center(child: Text("No Games")),
                    if (snapshot.hasData)
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          GameEntity gameEntity = GameEntity.fromMap(
                              snapshot.data!.docs.first.data()
                                  as Map<String, dynamic>);

                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: InkWell(
                              onTap: () {},
                              onHover: (bol) {},
                              child: NeuContainer(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gameEntity.roomName,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28),
                                    ),
                                    Text(
                                      gameEntity.gameId,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              "Players:",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "${gameEntity.numPlayer}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          gameEntity.gameStatus
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
