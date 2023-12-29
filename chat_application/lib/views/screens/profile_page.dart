import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:chat_application/Modal/user_modal.dart';
import 'package:chat_application/controllers/theme_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/colour_utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FbHelper.fbHelper.firebaseAuth.currentUser;

    ThemeController themeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c5,
        foregroundColor: c4,
        centerTitle: true,
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 80,
              foregroundImage: NetworkImage(user!.photoURL.toString()),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              color: (themeController.isDark == true) ? c5 : c4,
              child: ListTile(
                title: Text(
                  "User Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (themeController.isDark == true) ? c4 : c1,
                  ),
                ),
                subtitle: Text(user.displayName.toString(),
                    style: TextStyle(
                      color: (themeController.isDark == true) ? c4 : c1,
                    )),
                leading: Icon(
                  Icons.account_circle_rounded,
                  color: (themeController.isDark == true) ? c4 : c1,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: (themeController.isDark == true) ? c5 : c4,
              child: ListTile(
                title: Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (themeController.isDark == true) ? c4 : c1,
                  ),
                ),
                subtitle: Text(user.email.toString(),
                    style: TextStyle(
                      color: (themeController.isDark == true) ? c4 : c1,
                    )),
                leading: Icon(
                  Icons.email,
                  color: (themeController.isDark == true) ? c4 : c1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
