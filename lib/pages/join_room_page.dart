import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
          stream: _controller.stream,
          builder: (context, snapshot) {
            // check the snapshot (hasError, hasData, etc.)
            if (snapshot.hasError) {
              return const Text("Error");
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
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: intList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: InkWell(
                            onTap: () {},
                            onHover: (bol) {},
                            child: NeuContainer(
                              height: 100,
                              width: 300,
                              child: Text(intList[index].toString()),
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
