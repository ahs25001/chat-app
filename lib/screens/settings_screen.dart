import 'package:chat_app/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app/sheard/routes/routes.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:chat_app/sheard/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../generated/assets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state.appStatus == AppStatus.signOutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.loginScreen,
            (route) => false,
          );
        } else if (state.appStatus == AppStatus.signOutLoading) {
          doLoading(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SvgPicture.asset(
                Assets.imagesAppBarBackground,
                fit: BoxFit.cover,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      centerTitle: true,
                      iconTheme: IconThemeData(color: Colors.white),
                      title: Text(
                        AppLocalizations.of(context)!.settings,
                        style: appBarStyle,
                      ),
                    ),
                    Lottie.asset(
                      Assets.lottieFilesSettingsAnimation,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 18.0.h, horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                              alignment: (state.localCode == "ar")
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Text(
                                  AppLocalizations.of(context)!.language,
                                  style: chatTitleStyle)),
                          SizedBox(height: 15.h,),
                          Center(
                            child: DropdownMenu<String>(
                                initialSelection: state.localCode ?? "en",
                                width: MediaQuery.sizeOf(context).width * .9,
                                onSelected: (value) {
                                  AppCubit.get(context).changeLocal(
                                      value ?? state.localCode ?? "en");
                                },
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(
                                      value: "en",
                                      label: AppLocalizations.of(context)!
                                          .english),
                                  DropdownMenuEntry(
                                      value: "ar",
                                      label:
                                          AppLocalizations.of(context)!.arabic),
                                ]),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 12.h),
                            decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(18.r)),
                            child: Row(
                              children: [
                                Text(AppLocalizations.of(context)!.editeProfile,
                                    style: chatTitleStyle),
                                Spacer(),
                                Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              AppCubit.get(context).signOut();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signOut,
                              style: buttonNameStyle,
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
