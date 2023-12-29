import 'dart:developer';
import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:chat_application/Helpers/firestore_helper.dart';
import 'package:chat_application/Modal/text_modal.dart';
import 'package:chat_application/Modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../Utils/colour_utils.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModal user = ModalRoute.of(context)!.settings.arguments as UserModal;

    TextEditingController textEditingController = TextEditingController();

    String msj = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: c5,
        foregroundColor: c4,
        title: Row(
          children: [
            CircleAvatar(foregroundImage: NetworkImage(user.img)),
            const SizedBox(
              width: 15,
            ),
            Text(user.username),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper.getmessage(
                    recieveremail: user.email,
                    senderemail: FbHelper
                        .fbHelper.firebaseAuth.currentUser!.email
                        .toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>>? snaps = snapshot.data;

                    List<QueryDocumentSnapshot> docs = snaps!.docs;

                    List<Map> data = docs.map((e) => e.data() as Map).toList();

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
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: (chat.type == "sent")
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      (chat.type == "sent")
                                          ? Slidable(
                                              direction: Axis.horizontal,
                                              endActionPane: ActionPane(
                                                motion: const ScrollMotion(),
                                                extentRatio: 2 / 2,
                                                children: [
                                                  Text(
                                                    "${chat.time.hour % 12} : ${chat.time.minute}",
                                                  ),
                                                ],
                                              ),
                                              child: GestureDetector(
                                                onLongPress: () {
                                                  FireStoreHelper
                                                      .fireStoreHelper
                                                      .deleteMsg(
                                                    chatModal: allchat[index],
                                                    senderEmail: FbHelper
                                                        .fbHelper
                                                        .firebaseAuth
                                                        .currentUser!
                                                        .email
                                                        .toString(),
                                                    receiverEmail: user.email,
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  margin: const EdgeInsets.only(
                                                      top: 5, right: 10),
                                                  decoration: BoxDecoration(
                                                      color: c5,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                      )),
                                                  child: Text(
                                                    chat.msj,
                                                    style: TextStyle(color: c4),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Slidable(
                                              direction: Axis.horizontal,
                                              startActionPane: ActionPane(
                                                motion: const ScrollMotion(),
                                                extentRatio: 2 / 2,
                                                children: [
                                                  Text(
                                                    "${chat.time.hour % 12} : ${chat.time.minute}",
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin: const EdgeInsets.only(
                                                    top: 5, right: 10),
                                                decoration: BoxDecoration(
                                                    color: c2,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    )),
                                                child: Text(
                                                  chat.msj,
                                                  style: TextStyle(color: c4),
                                                ),
                                              ),
                                            ),
                                    ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: textEditingController,
                    onChanged: (val) {
                      msj = val;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    chatModal chat =
                        chatModal(msj: msj, time: DateTime.now(), type: 'sent');

                    (chat.msj == "")
                        ? null
                        : FireStoreHelper.fireStoreHelper.messageSend(
                            chat: chat,
                            sender: FbHelper
                                .fbHelper.firebaseAuth.currentUser!.email
                                .toString(),
                            receiver: user.email);
                    FireStoreHelper.fireStoreHelper.setLastMsg(
                        chatModal: chat,
                        senderEmail: FbHelper
                            .fbHelper.firebaseAuth.currentUser!.email
                            .toString(),
                        receiverEmail: user.email);
                    textEditingController.clear();
                  },
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
