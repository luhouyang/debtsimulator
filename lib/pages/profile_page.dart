import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debtsimulator/auth/firebase_auth_services.dart';
import 'package:debtsimulator/components/badge_tiles.dart';
import 'package:debtsimulator/entities/user_entity.dart';
import 'package:debtsimulator/useCase/user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<int, String> badges = {
    0: "assets/CREAM_badge.png",
    1: "assets/FIRE_BASED_badge.png",
    2: "assets/monopoly.png",
    3: "assets/CREAM_badge.png",
    4: "assets/CREAM_badge.png",
    5: "assets/CREAM_badge.png",
    6: "assets/CREAM_badge.png",
    7: "assets/CREAM_badge.png",
    8: "assets/CREAM_badge.png",
    9: "assets/CREAM_badge.png",
    10: "assets/CREAM_badge.png",
    11: "assets/CREAM_badge.png",
    12: "assets/CREAM_badge.png",
    13: "assets/CREAM_badge.png",
    14: "assets/CREAM_badge.png",
  };

  // final Map<int, String> avatars = {
  //   0: "assets/profile_placeholder.jpg",
  //   1: "assets/CREAM_badge.png",
  //   2: "assets/FIRE_BASED_badge.png",
  //   3: "assets/monopoly.png",
  // };

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    Widget profileScreen() {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: [
          const SizedBox(
            height: 25,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(75, 0, 75, 10),
            child: Stack(
              children: [
                const SizedBox(
                  height: 30,
                ),
                ClipOval(
                  child: Image.asset(
                    UserUsecase().avatars[userUsecase.userEntity.profileIndex]!,
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
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
                      child: FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: NeuContainer(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                            child: IconButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                icon: const Icon(Icons
                                                    .arrow_back_ios_new_rounded)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.70,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: GridView.builder(
                                            padding: const EdgeInsets.all(8),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10,
                                                    crossAxisCount: 3,
                                                    childAspectRatio: 1),
                                            itemCount: UserUsecase().avatars.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onHover: (value) {},
                                                onTap: () {
                                                  userUsecase.userEntity
                                                      .profileIndex = index;
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(userUsecase
                                                          .userEntity.userId)
                                                      .set(userUsecase
                                                          .userEntity
                                                          .toMap())
                                                      .then((value) {
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  });
                                                },
                                                child: NeuContainer(
                                                  child: Image.asset(
                                                      UserUsecase().avatars[index]!),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          );
                        },
                        shape: const CircleBorder(),
                        child: const Icon(
                          color: Colors.black,
                          Icons.camera_enhance,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(32.0)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: NeuTextButton(
                    enableAnimation: true,
                    onPressed: () async {
                      UserEntity userEntity = UserEntity(
                          userId: "",
                          username: "",
                          ongoingGame: "",
                          profileIndex: 0,
                          achievements: []);

                      await FirebaseAuthServices()
                          .logout(userUsecase)
                          .then((value) {
                        userUsecase.setUser(userEntity);
                      }).then((value) => Navigator.pop(context));
                    },
                    text: const Text(
                      "LOGOUT",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ]),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            height: MediaQuery.of(context).size.height * 0.55,
            child: GridView.builder(
              padding: const EdgeInsets.only(top: 6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  childAspectRatio: 1),
              itemCount: badges.length,
              itemBuilder: (context, index) {
                List<int> listInt =
                    List<int>.from(userUsecase.userEntity.achievements);
                if (listInt.contains(index)) {
                  return BadgeTiles(imagePath: badges[index]!);
                } else {
                  return const BadgeTiles(imagePath: "");
                }
              },
            ),
          ),
        ]),
      );
    }

    return Scaffold(body: profileScreen());
  }
}
