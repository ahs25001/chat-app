import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/create_chat_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 943),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          SplashScreen.routeName: (context) => const SplashScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
          CreateChatScreen.routeName: (context) => const CreateChatScreen(),
        },
        initialRoute:  SplashScreen.routeName,
        // initialRoute:CreateChatScreen.routeName ,
      ),
    );
  }
}
