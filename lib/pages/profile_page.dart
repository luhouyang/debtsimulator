import 'package:debtsimulator/auth/firebase_auth_services.dart';
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

                      await FirebaseAuthServices().logout().then((value) {
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
          //TODO: add badges, grid view builder
        ]),
      );
    }

    return Scaffold(body: profileScreen());
  }
}
