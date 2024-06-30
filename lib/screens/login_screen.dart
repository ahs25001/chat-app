import 'package:chat_app/cubits/login_cubit/login_cubit.dart';
import 'package:chat_app/generated/assets.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../sheard/widgets/custom_field.dart';
import '../sheard/widgets/register_button.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "loginScreen";

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
              HomeScreen.routeName,
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
              // resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Stack(
                  // alignment: Alignment.topCenter,
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
                                "Login",
                                style: appBarStyle,
                              ),
                              centerTitle: true,
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(
                              height: 215.h,
                            ),
                            Text(
                              "Welcome back!",
                              style: titleStyle,
                            ),
                            SizedBox(
                              height: 36.h,
                            ),
                            CustomField(
                              label: "Email",
                              controller:
                                  LoginCubit.get(context).emailController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "This field is required";
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value ?? "")) {
                                  return "Email not valid !";
                                }
                              },
                              isPassword: false,
                            ),
                            SizedBox(
                              height: 56.h,
                            ),
                            CustomField(
                              label: "Password",
                              controller:
                                  LoginCubit.get(context).passwordController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "This field is required";
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
                              "Forgot password?",
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
                              title: 'Login',
                            ),
                            SizedBox(
                              height: 35.h,
                            ),
                            InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, SignUpScreen.routeName),
                              child: Text(
                                "Or Create My Account",
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
                                  "Re send Email Verification",
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
