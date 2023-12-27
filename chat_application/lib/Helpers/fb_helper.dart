import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FbHelper {
  FbHelper._();
  static final FbHelper fbHelper = FbHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Anonymous Login
  Future<User?> anonymousLogin() async {
    UserCredential userCredential = await firebaseAuth.signInAnonymously();

    return userCredential.user;
  }

  Future<User?> emailPasswordSignIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Create User Successfully")));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    if (userCredential != null) {
      return userCredential.user;
    } else {
      return null;
    }
  }

  Future<User?> emailPasswordLogIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Successfully")));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    if (userCredential != null) {
      return userCredential.user;
    } else {
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);

    return userCredential.user;
  }

  Future<void> logoutUser() async {
    await firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }
}
