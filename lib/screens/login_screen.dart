import 'package:chat_app/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/generated/assets.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/sheard/routes/routes.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../sheard/widgets/custom_field.dart';
import '../sheard/widgets/register_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 943));
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.loginScreenState == LoginScreenState.loginLoading) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.transparent,
                content: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              ),
            );
          } else if (state.loginScreenState == LoginScreenState.loginSuccess) {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.homeScreen,
              (route) => false,
            );
          } else if (state.loginScreenState == LoginScreenState.loginError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                state.massage ?? "",
                style: registerTextStyle.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          return Form(
            key: LoginCubit.get(context).key,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      Assets.imagesAppBarBackground,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBar(
                              title: Text(
                                AppLocalizations.of(context)!.login,
                                style: appBarStyle,
                              ),
                              centerTitle: true,
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(
                              height: 215.h,
                            ),
                            Text(
                              AppLocalizations.of(context)!.welcomeBack,
                              style: titleStyle,
                            ),
                            SizedBox(
                              height: 36.h,
                            ),
                            CustomField(
                              label: AppLocalizations.of(context)!.email,
                              controller:
                                  LoginCubit.get(context).emailController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .thisFieldIsRequired;
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value ?? "")) {
                                  return AppLocalizations.of(context)!
                                      .emailNotValid;
                                }
                              },
                              isPassword: false,
                            ),
                            SizedBox(
                              height: 56.h,
                            ),
                            CustomField(
                              label: AppLocalizations.of(context)!.password,
                              controller:
                                  LoginCubit.get(context).passwordController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .thisFieldIsRequired;
                                }
                              },
                              isPassword: true,
                              isPasswordVisible:
                                  state.isPasswordVisible ?? false,
                              changeVisibility: () {
                                LoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            Text(
                              AppLocalizations.of(context)!.forgetPassword,
                              style: labelStyle,
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            RegisterButton(
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              onTab: () {
                                if (LoginCubit.get(context)
                                    .key
                                    .currentState!
                                    .validate()) {
                                  LoginCubit.get(context).login();
                                }
                              },
                              title: AppLocalizations.of(context)!.login,
                            ),
                            SizedBox(
                              height: 35.h,
                            ),
                            InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, AppRoutes.signUpScreen),
                              child: Text(
                                AppLocalizations.of(context)!.orCreateMyAccount,
                                style: labelStyle,
                              ),
                            ),
                            SizedBox(
                              height: 35.h,
                            ),
                            Visibility(
                              visible:
                                  FirebaseAuth.instance.currentUser != null,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  LoginCubit.get(context)
                                      .reSendEmailVerification();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .resendEmailVerification,
                                  style:
                                      labelStyle.copyWith(color: primaryColor),
                                ),
                              ),
                            )
                          ]),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
