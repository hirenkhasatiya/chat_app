import 'package:chat_application/Modal/text_modal.dart';
import 'package:chat_application/Modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();
  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String userCollection = 'user';

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
    return firestore
        .collection(userCollection)
        .doc(senderemail)
        .collection(recieveremail)
        .doc("allchat")
        .collection("chatdata")
        .snapshots();
  }
}
