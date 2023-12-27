import 'dart:developer';
import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:chat_application/Helpers/firestore_helper.dart';
import 'package:chat_application/Modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Utils/colour_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FbHelper.fbHelper.firebaseAuth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c5,
        title: Text("CHAT BOX",
            style: TextStyle(fontWeight: FontWeight.bold, color: c4)),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
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
            TextButton.icon(
              icon: Icon(Icons.logout, color: c4),
              onPressed: () {
                FbHelper.fbHelper.logoutUser().then(
                    (value) => Navigator.of(context).pushReplacementNamed('/'));
              },
              label: Text(
                "Log Out",
                style: TextStyle(color: c4),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: c4,
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
                        UserModal usr = alluser[index];
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
                            color: c4,
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
                                child: ListTile(
                                  leading: CircleAvatar(
                                      foregroundImage: NetworkImage(
                                    usermodal.img,
                                  )),
                                  title: Text(usermodal.username),
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
