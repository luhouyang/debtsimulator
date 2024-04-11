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

  @override
  Widget build(BuildContext context) {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);

    Widget profileScreen() {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: [
          const SizedBox(
            height: 35,
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
                    "assets/profile_placeholder.jpg",
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
                        onPressed: () {},
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
              padding: EdgeInsets.only(top: 6),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  childAspectRatio: 1),
              itemCount: badges.length,
              itemBuilder: (context, index) {
                List<int> listInt =
                    List<int>.from(userUsecase.userEntity.achievements);
                debugPrint(badges[index]);
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
