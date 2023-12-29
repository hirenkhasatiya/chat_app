import 'dart:developer';
import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:chat_application/Helpers/firestore_helper.dart';
import 'package:chat_application/Modal/text_modal.dart';
import 'package:chat_application/Modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/colour_utils.dart';
import '../../controllers/theme_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FbHelper.fbHelper.firebaseAuth.currentUser;
    ThemeController themeController = Get.find();
    UserModal usr;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: c5,
        foregroundColor: c4,
        title: Text("CHAT BOX",
            style: TextStyle(fontWeight: FontWeight.bold, color: c4)),
        actions: [
          Obx(() {
            return IconButton(
              onPressed: () {
                themeController.changeTheme();
              },
              icon: Icon(
                themeController.isDark.value
                    ? Icons.light_mode
                    : Icons.dark_mode_outlined,
              ),
            );
          }),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed('profile', arguments: user),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: c5),
                currentAccountPicture: CircleAvatar(
                  foregroundImage: NetworkImage(
                    user?.photoURL ??
                        "https://tse3.mm.bing.net/th?id=OIP.NS-EV3f9r1drh7h4Z6p9SAHaFC&pid=Api&P=0&h=180",
                  ),
                ),
                accountName: Text(user?.displayName ?? "Unknown",
                    style: TextStyle(
                        color: c4, fontSize: 18, fontWeight: FontWeight.bold)),
                accountEmail: Text(user?.email ?? "SIGN IN WITH EMAIL",
                    style: TextStyle(color: c4)),
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(c5),
                foregroundColor: MaterialStatePropertyAll(c4),
              ),
              icon: Icon(Icons.logout),
              onPressed: () {
                FbHelper.fbHelper.logoutUser().then(
                    (value) => Navigator.of(context).pushReplacementNamed('/'));
              },
              label: Text(
                "Log Out",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: (themeController.isDark == true) ? c5 : c4,
        foregroundColor: c1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            30,
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SizedBox(
              height: 400,
              child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper.getdata(),
                builder: (context, snp) {
                  if (snp.hasData) {
                    QuerySnapshot? snaps = snp.data;

                    List<QueryDocumentSnapshot> docs = snaps?.docs ?? [];

                    List<UserModal> alluser = docs
                        .map((e) => UserModal.fromMap(data: e.data() as Map))
                        .toList();

                    alluser
                        .removeWhere((element) => element.email == user!.email);

                    log("DATA ::::::: $alluser");

                    return ListView.separated(
                      padding: const EdgeInsets.all(10),
                      itemCount: alluser.length,
                      itemBuilder: (context, index) {
                        usr = alluser[index];
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(c4),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      c5)),
                                          onPressed: () {
                                            log("${usr.email}");
                                            log("SENDER>>>>>>>${FbHelper.fbHelper.firebaseAuth.currentUser!.email.toString()}");
                                            FireStoreHelper.fireStoreHelper
                                                .addContact(
                                                    receiver: usr.email,
                                                    sender:
                                                        user!.email as String)
                                                .then((value) =>
                                                    Navigator.of(context)
                                                        .pop());
                                          },
                                          child: const Text("Done")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(color: c4),
                                          ))
                                    ],
                                    backgroundColor: c1,
                                    title: Text("* CONFIRM ADD USER *",
                                        style: TextStyle(color: c4)),
                                  );
                                });
                          },
                          child: Card(
                            color: (themeController.isDark == true) ? c5 : c4,
                            child: ListTile(
                              textColor: Colors.white,
                              leading: CircleAvatar(
                                foregroundImage: NetworkImage(usr.img),
                              ),
                              title: Text(usr.email),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(color: c4),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FireStoreHelper.fireStoreHelper
              .getContactList(email: user!.email.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? snaps =
                  snapshot.data as DocumentSnapshot<Map<String, dynamic>>?;

              Map<String, dynamic>? data = snaps?.data();

              List contacts = data?['contact'] ?? [];

              return contacts.isNotEmpty
                  ? ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                          stream: FireStoreHelper.fireStoreHelper
                              .getUserByEmail(email: contacts[index]),
                          builder: (context, snapshot1) {
                            if (snapshot1.hasData) {
                              DocumentSnapshot? docs = snapshot1.data;

                              UserModal usermodal =
                                  UserModal.fromMap(data: docs!.data() as Map);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('chat', arguments: usermodal);
                                },
                                child: Card(
                                  color: (themeController.isDark == true)
                                      ? c5
                                      : c4,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        foregroundImage: NetworkImage(
                                      usermodal.img,
                                    )),
                                    title: Text(usermodal.username,
                                        style: TextStyle(
                                          color:
                                              (themeController.isDark == true)
                                                  ? c4
                                                  : c1,
                                        )),
                                    subtitle: StreamBuilder(
                                      stream: FireStoreHelper.fireStoreHelper
                                          .getLastMsg(
                                              senderEmail: FbHelper
                                                  .fbHelper
                                                  .firebaseAuth
                                                  .currentUser!
                                                  .email
                                                  .toString(),
                                              receiverEmail: usermodal.email),
                                      builder: (context, snapshot3) {
                                        if (snapshot3.hasData) {
                                          DocumentSnapshot<
                                                  Map<String, dynamic>>? data =
                                              snapshot3.data;

                                          Map<String, dynamic>? data2 =
                                              data!.data();

                                          if (data2 != null) {
                                            chatModal chat = chatModal.fromMap(
                                              data: data2,
                                            );

                                            return Text(
                                              chat.msj,
                                              style: TextStyle(
                                                color:
                                                    (themeController.isDark ==
                                                            true)
                                                        ? c4
                                                        : c1,
                                              ),
                                            );
                                          } else {
                                            return Text(
                                              "Tap and chat",
                                              style: TextStyle(
                                                color:
                                                    (themeController.isDark ==
                                                            true)
                                                        ? c4
                                                        : c1,
                                              ),
                                            );
                                          }
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    trailing: StreamBuilder(
                                      stream: FireStoreHelper.fireStoreHelper
                                          .getLastMsg(
                                              senderEmail: FbHelper
                                                  .fbHelper
                                                  .firebaseAuth
                                                  .currentUser!
                                                  .email
                                                  .toString(),
                                              receiverEmail: usermodal.email),
                                      builder: (context, snapshot3) {
                                        if (snapshot3.hasData) {
                                          DocumentSnapshot<
                                                  Map<String, dynamic>>? data =
                                              snapshot3.data;

                                          Map<String, dynamic>? data2 =
                                              data!.data();

                                          if (data2 != null) {
                                            chatModal chat = chatModal.fromMap(
                                              data: data2,
                                            );

                                            return Text(
                                              "${chat.time.hour % 12} : ${chat.time.minute}",
                                              style: TextStyle(
                                                color:
                                                    (themeController.isDark ==
                                                            true)
                                                        ? c4
                                                        : c1,
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                              "",
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            );
                                          }
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      },
                    )
                  : Container();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
