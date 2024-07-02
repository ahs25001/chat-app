import 'package:chat_app/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/create_chat_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/screens/settings_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/sheard/network/local/shared_preferences/shared_preferences_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferencesManager.initSharedPreferences();
  await ScreenUtil.ensureScreenSize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getCurrentLocal(),
      child: ScreenUtilInit(
        designSize: const Size(375, 943),
        minTextAdapt: true,
        splitScreenMode: true,
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) {
            return MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(scaffoldBackgroundColor: Colors.white),
              debugShowCheckedModeBanner: false,
              // locale: (state.appStatus == AppStatus.arLanguage)
              //     ? const Locale("ar")
              //     : const Locale("en"),
              locale: Locale(state.localCode ?? "ar"),
              routes: {
                LoginScreen.routeName: (context) => const LoginScreen(),
                SplashScreen.routeName: (context) => const SplashScreen(),
                SignUpScreen.routeName: (context) => const SignUpScreen(),
                HomeScreen.routeName: (context) => const HomeScreen(),
                ChatScreen.routeName: (context) => const ChatScreen(),
                SettingsScreen.routeName: (context) => const SettingsScreen(),
                CreateChatScreen.routeName: (context) =>
                    const CreateChatScreen(),
                SearchScreen.routeName: (context) => const SearchScreen(),
              },
              initialRoute: SplashScreen.routeName,
              // initialRoute:CreateChatScreen.routeName ,
            );
          },
        ),
      ),
    );
  }
}
