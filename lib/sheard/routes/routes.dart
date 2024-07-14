import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/create_chat_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/screens/send_photo_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/settings_screen.dart';
import '../widgets/show_photo.dart';

class AppRoutes {
  static const String chatScreen = "chat screen";
  static const String homeScreen = "home screen";
  static const String loginScreen = "login screen";
  static const String searchScreen = "search screen";
  static const String settingsScreen = "settings screen";
  static const String signUpScreen = "signUp screen";
  static const String createChatScreen = "create chat screen";
  static const String showPhotoScreen = "show photo screen";
  static const String sendPhotoScreen = "send photo screen";
  static const String splashScreen = "/";
}

class Routes {
  static Route? onGenerate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signUpScreen:
        return PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin =
                Offset(1.0, 0.0); // Start position (bottom of the screen)
            const end = Offset.zero; // End position (center of the screen)
            const curve = Curves.easeInOut; // Animation curve

            // Create a Tween for the animation
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            // Apply the Tween to the child widget
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SignUpScreen(),
        );
      case AppRoutes.loginScreen:
        return PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin =
                Offset(0.0, 1.0); // Start position (bottom of the screen)
            const end = Offset.zero; // End position (center of the screen)
            const curve = Curves.easeInOut; // Animation curve

            // Create a Tween for the animation
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            // Apply the Tween to the child widget
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
        );
      case AppRoutes.homeScreen:
        return PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin =
                Offset(0.0, 1.0); // Start position (bottom of the screen)
            const end = Offset.zero; // End position (center of the screen)
            const curve = Curves.easeInOut; // Animation curve

            // Create a Tween for the animation
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            // Apply the Tween to the child widget
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
        );
      case AppRoutes.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case AppRoutes.chatScreen:
        return PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin =
                  Offset(0.0, 1.0); // Start position (bottom of the screen)
              const end = Offset.zero; // End position (center of the screen)
              const curve = Curves.easeInOut; // Animation curve

              // Create a Tween for the animation
              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              // Apply the Tween to the child widget
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            // transitionsBuilder: ,
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ChatScreen(),
            settings: settings);
      case AppRoutes.sendPhotoScreen:
        return PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin =
                  Offset(0.0, 1.0); // Start position (bottom of the screen)
              const end = Offset.zero; // End position (center of the screen)
              const curve = Curves.easeInOut; // Animation curve

              // Create a Tween for the animation
              final tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              // Apply the Tween to the child widget
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            // transitionsBuilder: ,
            pageBuilder: (context, animation, secondaryAnimation) =>
                 SendPhotoScreen(),settings: settings);
      case AppRoutes.createChatScreen:
        return PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin =
                Offset(1.0, 0.0); // Start position (bottom of the screen)
            const end = Offset.zero; // End position (center of the screen)
            const curve = Curves.easeInOut; // Animation curve

            // Create a Tween for the animation
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            // Apply the Tween to the child widget
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },

          pageBuilder: (context, animation, secondaryAnimation) =>
              const CreateChatScreen(),
          // settings: settings
        );
      case AppRoutes.searchScreen:
        return PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin =
                Offset(1.0, 0.0); // Start position (bottom of the screen)
            const end = Offset.zero; // End position (center of the screen)
            const curve = Curves.easeInOut; // Animation curve

            // Create a Tween for the animation
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            // Apply the Tween to the child widget
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SearchScreen(),
        );
      case AppRoutes.settingsScreen:
        return PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin =
                Offset(0.0, 1.0); // Start position (bottom of the screen)
            const end = Offset.zero; // End position (center of the screen)
            const curve = Curves.easeInOut; // Animation curve

            // Create a Tween for the animation
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            // Apply the Tween to the child widget
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SettingsScreen(),
        );
      case AppRoutes.showPhotoScreen :
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              ShowPhoto(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            var begin = Offset.zero;
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration:
          Duration(milliseconds: 500), // Adjust the duration here
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        );
    }
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Error"),
      ),
    );
  }
}
