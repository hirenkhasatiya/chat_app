import 'dart:developer';

import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:chat_application/Helpers/firestore_helper.dart';
import 'package:chat_application/Modal/text_modal.dart';
import 'package:chat_application/Modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Utils/colour_utils.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModal user = ModalRoute.of(context)!.settings.arguments as UserModal;

    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: c5,
        foregroundColor: c4,
        title: Row(
          children: [
            CircleAvatar(foregroundImage: NetworkImage(user.img)),
            const SizedBox(
              width: 10,
            ),
            Text(user.username),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: FireStoreHelper.fireStoreHelper.getmessage(
                      recieveremail: user.email,
                      senderemail: FbHelper.fbHelper.firebaseAuth.currentUser
                          .toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot<Map<String, dynamic>>? snaps =
                          snapshot.data;

                      List<QueryDocumentSnapshot> docs = snaps!.docs;

                      List<Map> data =
                          docs.map((e) => e.data() as Map).toList();

                      List allchat =
                          data.map((e) => chatModal.fromMap(data: e)).toList();

                      log("DATA >>>>>>>>>>>>> $allchat");

                      return (allchat.isEmpty)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: allchat.length,
                              itemBuilder: (context, index) {
                                chatModal chat = allchat[index];
                                return Row(
                                  children: [
                                    Card(
                                      child: Text(chat.msj),
                                    ),
                                  ],
                                );
                              },
                            );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: textEditingController,
                    onSubmitted: (val) {
                      chatModal chat = chatModal(
                          msj: val, time: DateTime.now(), type: 'sent');

                      FireStoreHelper.fireStoreHelper.messageSend(
                          chat: chat,
                          sender: FbHelper
                              .fbHelper.firebaseAuth.currentUser!.email
                              .toString(),
                          receiver: user.email);
                      textEditingController.clear();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
