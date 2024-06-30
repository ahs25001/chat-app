import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/sheard/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../cubits/sign_up_cubit/sign_up_cubit.dart';
import '../generated/assets.dart';
import '../sheard/styles/colors.dart';
import '../sheard/styles/styles.dart';
import '../sheard/widgets/custom_field.dart';
import '../sheard/widgets/register_button.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "signUp";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 943));
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.signUpScreenState ==
              SignUpScreenState.accountCreatedError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                state.errorMassage ?? "",
                style: registerTextStyle.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          } else if (state.signUpScreenState ==
              SignUpScreenState.accountCreatedSuccess) {
            Navigator.pop(context);
            SignUpCubit.get(context).addUser();
          } else if (state.signUpScreenState ==
              SignUpScreenState.addUserSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Account Created Success , Verify Email Now.",
                style: registerTextStyle.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ));
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginScreen.routeName,
              (route) => false,
            );
          } else if (state.signUpScreenState ==
                  SignUpScreenState.accountCreatedLoading ||
              state.signUpScreenState == SignUpScreenState.addUserLoading) {
            doLoading(context);
          }
        },
        builder: (context, state) {
          return Form(
              key: SignUpCubit.get(context).key,
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
                                "Create Account",
                                style: appBarStyle,
                              ),
                              iconTheme: IconThemeData(color: Colors.white),
                              centerTitle: true,
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(
                              height: 248.h,
                            ),
                            CustomField(
                              label: "Full Name",
                              controller:
                                  SignUpCubit.get(context).nameController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "This field is required";
                                }
                              },
                              isPassword: false,
                            ),
                            SizedBox(
                              height: 56.h,
                            ),
                            CustomField(
                              label: "Email",
                              controller:
                                  SignUpCubit.get(context).emailController,
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
                                  SignUpCubit.get(context).passwordController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "This field is required";
                                }
                              },
                              isPassword: true,
                              isPasswordVisible:
                                  state.isPasswordVisible ?? false,
                              changeVisibility: () {
                                SignUpCubit.get(context)
                                    .changePasswordVisibility();
                              },
                            ),
                            SizedBox(
                              height: 60.h,
                            ),
                            RegisterButton(
                              backgroundColor: primaryColor,
                              textColor: Colors.white,
                              onTab: () {
                                if (SignUpCubit.get(context)
                                    .key
                                    .currentState!
                                    .validate()) {
                                  SignUpCubit.get(context).signUp();
                                }
                              },
                              title: 'Create Account',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
