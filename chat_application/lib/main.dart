import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:chat_application/views/screens/chat_page.dart';
import 'package:chat_application/views/screens/home_page.dart';
import 'package:chat_application/views/screens/login_page.dart';
import 'package:chat_application/views/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute:
          (FbHelper.fbHelper.firebaseAuth.currentUser == null) ? '/' : 'home',
      routes: {
        '/': (context) => LoginPage(),
        'home': (context) => const HomePage(),
        'register': (context) => RegisterPage(),
        'chat': (context) => const ChatPage(),
      },
    );
  }
}
