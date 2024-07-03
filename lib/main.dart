import 'package:chat_app/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/sheard/network/local/shared_preferences/shared_preferences_manager.dart';
import 'package:chat_app/sheard/routes/routes.dart';
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
  await SharedPreferencesManager.initSharedPreferences();
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
              onGenerateRoute: (settings) => Routes.onGenerate(settings),
              initialRoute:"/",
              // initialRoute:CreateChatScreen.routeName ,
            );
          },
        ),
      ),
    );
  }
}
