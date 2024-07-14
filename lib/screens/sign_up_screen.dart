import 'package:chat_app/sheard/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../cubits/sign_up_cubit/sign_up_cubit.dart';
import '../generated/assets.dart';
import '../sheard/constants/widgets.dart';
import '../sheard/styles/colors.dart';
import '../sheard/styles/styles.dart';
import '../sheard/widgets/custom_field.dart';
import '../sheard/widgets/register_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatelessWidget {
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
           showErrorSnackBar(context: context, text: state.errorMassage??"");
          } else if (state.signUpScreenState ==
              SignUpScreenState.accountCreatedSuccess) {
            Navigator.pop(context);
            SignUpCubit.get(context).addUser();
          } else if (state.signUpScreenState ==
              SignUpScreenState.addUserSuccess) {
            Navigator.pop(context);
            showSuccessSnackBar(
                context: context,
                text: AppLocalizations.of(context)!.accountCreatedSuccess);
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginScreen,
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
                                AppLocalizations.of(context)!.createAccount,
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
                              label: AppLocalizations.of(context)!.fullName,
                              controller:
                                  SignUpCubit.get(context).nameController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .thisFieldIsRequired;
                                }
                              },
                              isPassword: false,
                            ),
                            SizedBox(
                              height: 56.h,
                            ),
                            CustomField(
                              label: AppLocalizations.of(context)!.email,
                              controller:
                                  SignUpCubit.get(context).emailController,
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .thisFieldIsRequired;
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
                              label: AppLocalizations.of(context)!.password,
                              controller:
                                  SignUpCubit.get(context).passwordController,
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
                              title:
                                  AppLocalizations.of(context)!.createAccount,
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
