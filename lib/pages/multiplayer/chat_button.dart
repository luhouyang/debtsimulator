import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/entities/chat_entity.dart';
import 'package:debtsimulator/entities/game_entity.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class ChatButton extends StatefulWidget {
  final GameEntity gameEntity;

  const ChatButton({super.key, required this.gameEntity});

  @override
  State<ChatButton> createState() => _ChatButtonState();
}

class _ChatButtonState extends State<ChatButton> {
  TextEditingController chatTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserUsecase>(
      builder: (context, userUsecase, child) {
        return NeuTextButton(
          buttonColor: Colors.orange,
          buttonWidth: 110,
          enableAnimation: true,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return chatDialog(widget.gameEntity, userUsecase, context);
              },
            );
          },
          text: const Text(
            "Chat",
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  String chatVerify(value) {
    return value != null ? "" : "Please enter chat";
  }

  Widget inputTextWidget(
      String hint, Function validator, TextEditingController controller) {
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

  Dialog chatDialog(GameEntity gameEntity, UserUsecase userUsecase,
      BuildContext parentContext) {
    List<ChatEntity> chatLog = List.from(
        gameEntity.chatLog.map((element) => ChatEntity.fromMap(element)));

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
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  ),
                ),
                NeuContainer(
                  color: Colors.grey[200],
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemCount: chatLog.length,
                    itemBuilder: (context, index) {
                      return chatLog[index].userId ==
                              userUsecase.userEntity.userId
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                                child: NeuContainer(
                                  color: Colors.amber,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      "${chatLog[index].username}:\n${chatLog[index].chat}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: NeuContainer(
                                  color: Colors.lightBlue,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      "${chatLog[index].username}:\n${chatLog[index].chat}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),
                inputTextWidget(
                    "chat message...", chatVerify, chatTextController),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: NeuTextButton(
                    buttonHeight: MediaQuery.of(context).size.height * 0.07,
                    buttonWidth: MediaQuery.of(context).size.width,
                    enableAnimation: true,
                    onPressed: () async {
                      ChatEntity chatEntity = ChatEntity(
                          userId: userUsecase.userEntity.userId,
                          username: userUsecase.userEntity.username,
                          chat: chatTextController.text,
                          profileIndex: userUsecase.userEntity.profileIndex);
        
                      gameEntity.chatLog.add(chatEntity.toMap());
        
                      await FirebaseFirestore.instance
                          .collection("games")
                          .doc(widget.gameEntity.gameId)
                          .set(gameEntity.toMap())
                          .then((value) {
                        chatTextController.clear();
                        Navigator.pop(context);
                        showDialog(
                          context: parentContext,
                          barrierDismissible: false,
                          builder: (context) {
                            return chatDialog(gameEntity, userUsecase, context);
                          },
                        );
                      });
                    },
                    text: const Text(
                      "Send Chat",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
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
}
