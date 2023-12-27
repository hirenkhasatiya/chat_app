import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:chat_application/Helpers/firestore_helper.dart';
import 'package:chat_application/Modal/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Utils/colour_utils.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c5,
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(1, -2),
            child: Transform.scale(
              scale: 1.4,
              child: CircleAvatar(
                backgroundColor: c4,
                radius: 270,
              ),
            ),
          ),
          const Align(
            alignment: Alignment(-0.75, -0.65),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: "Welcome Back ,\n",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                TextSpan(
                  text: "Login !",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                ),
              ]),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              width: 340,
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Email";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => email = value,
                      decoration: InputDecoration(
                        label: Text("Enter Email", style: TextStyle(color: c3)),
                        hintText: "Enter Email",
                        suffixIcon: Icon(
                          Icons.email,
                          color: c3,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Password";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => password = value,
                      decoration: InputDecoration(
                        label:
                            Text("Enter Password", style: TextStyle(color: c3)),
                        hintText: "Enter Password",
                        suffixIcon: Icon(Icons.lock, color: c3),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(c4)),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: Text("Register User",
                            style: TextStyle(
                                color: c5, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(c4),
                        foregroundColor: MaterialStateProperty.all(c1),
                      ),
                      onPressed: () async {
                        formkey.currentState!.validate();
                        FbHelper.fbHelper.emailPasswordLogIn(
                          email: email!,
                          password: password!,
                          context: context,
                        );
                        User? user = FbHelper.fbHelper.firebaseAuth.currentUser;

                        if (FbHelper.fbHelper.firebaseAuth.currentUser !=
                            null) {
                          Navigator.of(context)
                              .pushReplacementNamed("/home", arguments: user);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("User Not Valid"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("Log In"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(c4)),
                      onPressed: () async {
                        await FbHelper.fbHelper.signInWithGoogle().then(
                              (value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Success........"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            );
                        FireStoreHelper.fireStoreHelper.adduser(
                            user: UserModal(
                          id: FbHelper.fbHelper.firebaseAuth.currentUser!.uid
                              .toString(),
                          email: FbHelper
                              .fbHelper.firebaseAuth.currentUser!.email
                              .toString(),
                          password: "N/A",
                          img: FbHelper
                              .fbHelper.firebaseAuth.currentUser!.photoURL
                              .toString(),
                          username: FbHelper
                              .fbHelper.firebaseAuth.currentUser!.displayName
                              .toString(),
                        ));
                        Navigator.of(context).pushReplacementNamed('home',
                            arguments:
                                FbHelper.fbHelper.firebaseAuth.currentUser);
                      },
                      label: const Text("Sign In With Google"),
                      icon: const Icon(Icons.attach_email),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.8, 0.95),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(c4),
              ),
              onPressed: () {
                FbHelper.fbHelper.anonymousLogin().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login Anonymously"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context)
                      .pushReplacementNamed('/home', arguments: value);
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login Anonymously Failed"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
              icon: const Icon(Icons.login),
              label: const Text("Guest Login"),
            ),
          ),
        ],
      ),
    );
  }
}
