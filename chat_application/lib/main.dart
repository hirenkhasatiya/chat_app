import 'package:chat_application/Helpers/fb_helper.dart';
import 'package:chat_application/views/screens/chat_page.dart';
import 'package:chat_application/views/screens/home_page.dart';
import 'package:chat_application/views/screens/login_page.dart';
import 'package:chat_application/views/screens/profile_page.dart';
import 'package:chat_application/views/screens/register_page.dart';
import 'package:chat_application/views/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Utils/colour_utils.dart';
import 'controllers/theme_controller.dart';
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
    ThemeController themeController = Get.put(ThemeController());

    return Obx(() => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          themeMode:
              themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,
          initialRoute: 'splash',
          routes: {
            '/': (context) => LoginPage(),
            'home': (context) => const HomePage(),
            'register': (context) => RegisterPage(),
            'chat': (context) => const ChatPage(),
            'splash': (context) => const SplashScreen(),
            'profile': (context) => const ProfilePage(),
          },
        ));
  }
}
