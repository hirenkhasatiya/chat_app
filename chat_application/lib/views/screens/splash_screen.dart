import 'dart:async';
import 'package:flutter/material.dart';

import '../../Helpers/fb_helper.dart';
import '../../Utils/colour_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ChangePage() {
    Timer.periodic(
      Duration(seconds: 4),
      (timer) {
        Navigator.of(context).pushReplacementNamed(
          (FbHelper.fbHelper.firebaseAuth.currentUser == null) ? '/' : 'home',
        );
        timer.cancel();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ChangePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c4,
      body: Center(
        child: Column(
          children: [
            Spacer(
              flex: 2,
            ),
            Image.asset("assets/chat.png"),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "CHAT BOX",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 30,
                ),
                CircularProgressIndicator(color: c1),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
