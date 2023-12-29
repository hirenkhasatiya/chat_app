import 'package:chat_application/Modal/text_modal.dart';
import 'package:chat_application/Modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FireStoreHelper {
  FireStoreHelper._();
  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String userCollection = 'user';
  String lM = "lastMsg";

  adduser({required UserModal user}) {
    firestore.collection(userCollection).doc(user.email).set(user.toMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getdata() {
    return firestore.collection(userCollection).snapshots();
  }

  Future<List> getContactData({required String email}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(userCollection).doc(email).get();

    Map data = snapshot.data() as Map;

    return data['contact'] ?? [];
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getContactList(
      {required String email}) {
    return firestore.collection(userCollection).doc(email).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByEmail(
      {required String email}) {
    return firestore.collection(userCollection).doc(email).snapshots();
  }

  Future<void> addContact(
      {required String receiver, required String sender}) async {
    List contacts = await getContactData(email: sender);

    if (!contacts.contains(receiver)) {
      contacts.add(receiver);
      firestore
          .collection(userCollection)
          .doc(sender)
          .update({'contact': contacts});
    }

    contacts = await getContactData(email: receiver);
    if (!contacts.contains(sender)) {
      contacts.add(sender);
      firestore
          .collection(userCollection)
          .doc(receiver)
          .update({'contact': contacts});
    }
  }

  messageSend(
      {required chatModal chat,
      required String sender,
      required String receiver}) {
    Map<String, dynamic> data = chat.toMap;

    data.update("type", (value) => "sent");

    firestore
        .collection(userCollection)
        .doc(sender)
        .collection(receiver)
        .doc("allchat")
        .collection("chatdata")
        .doc(chat.time.millisecondsSinceEpoch.toString())
        .set(data);

    data.update("type", (value) => "receive");

    firestore
        .collection(userCollection)
        .doc(receiver)
        .collection(sender)
        .doc("allchat")
        .collection("chatdata")
        .doc(chat.time.millisecondsSinceEpoch.toString())
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getmessage(
      {required String senderemail, required String recieveremail}) {
    Logger loigger = Logger();

    loigger.i("Sender email : $senderemail // Reciever email:$recieveremail");
    return firestore
        .collection(userCollection)
        .doc(senderemail)
        .collection(recieveremail)
        .doc("allchat")
        .collection("chatdata")
        .snapshots();
  }

  setLastMsg({
    required chatModal chatModal,
    required String senderEmail,
    required String receiverEmail,
  }) {
    Map<String, dynamic> chat = chatModal.toMap;

    chat.update("type", (value) => "sent");

    firestore
        .collection(userCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc(lM)
        .set(chat);

    chat.update("type", (value) => "receive");

    firestore
        .collection(userCollection)
        .doc(receiverEmail)
        .collection(senderEmail)
        .doc(lM)
        .set(chat);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getLastMsg({
    required String senderEmail,
    required String receiverEmail,
  }) {
    return firestore
        .collection(userCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc(lM)
        .snapshots();
  }

  Future<void> deleteMsg({
    required chatModal chatModal,
    required String senderEmail,
    required String receiverEmail,
  }) async {
    Map<String, dynamic> chat = chatModal.toMap;

    chat.update("type", (value) => "sent");
    chat.update("msg", (value) => "This message was deleted");

    await firestore
        .collection(userCollection)
        .doc(senderEmail)
        .collection(receiverEmail)
        .doc("allChats")
        .collection("chatData")
        .doc(chatModal.time.millisecondsSinceEpoch.toString())
        .update(chat);
  }
}
