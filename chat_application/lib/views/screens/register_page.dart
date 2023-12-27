import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:flutter/material.dart';

import '../../Utils/colour_utils.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

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
          Align(
            alignment: const Alignment(-0.59, -0.44),
            child: Transform.scale(
                scale: 1.4,
                child: Text(
                  "Register User !",
                  style: TextStyle(
                    color: c1,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )),
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
              height: 300,
              width: 340,
              child: Form(
                key: formkey,
                child: Column(
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
                    const Spacer(flex: 2),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(c4),
                        foregroundColor: MaterialStateProperty.all(c1),
                      ),
                      onPressed: () async {
                        formkey.currentState!.validate();
                        await FbHelper.fbHelper
                            .emailPasswordSignIn(
                                context: context,
                                email: email!,
                                password: password!)
                            .then((value) => Navigator.of(context)
                                .pushReplacementNamed('/'));
                      },
                      child: const Text("Register Now"),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
