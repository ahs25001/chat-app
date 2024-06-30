import 'package:chat_app/cubits/create_chat_cubit/create_chat_cubit.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../sheard/styles/styles.dart';
import '../sheard/widgets/create_chat_field.dart';
import '../sheard/widgets/loading.dart';

class CreateChatScreen extends StatelessWidget {
  static const String routeName = "create chat screen";

  const CreateChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateChatCubit(),
      child: BlocConsumer<CreateChatCubit, CreateChatState>(
        listener: (context, state) {
          if (state.chatScreenState ==
              CreateChatScreenState.createChatLoading) {
            doLoading(context);
          } else if (state.chatScreenState ==
              CreateChatScreenState.createChatSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text("Chat Created Success.",
                    style: registerTextStyle.copyWith(color: Colors.white))));
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName,
              (route) => false,
            );
          } else if (state.chatScreenState ==
              CreateChatScreenState.createChatError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                state.errorMassage ?? "",
                style: registerTextStyle.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) => Form(
          key: CreateChatCubit.get(context).formKey,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                SvgPicture.asset(
                  Assets.imagesAppBarBackground,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          title: Text(
                            "Chat App",
                            style: appBarStyle,
                          ),
                          iconTheme: IconThemeData(color: Colors.white),
                          centerTitle: true,
                          backgroundColor: Colors.transparent,
                          actions: [
                            Icon(
                              Icons.more_vert,
                              size: 30.sp,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Center(
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.r)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28.0.w, vertical: 25.h),
                              child: Column(
                                children: [
                                  Text(
                                    "Create New Chat",
                                    style: chatTitleStyle,
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  SvgPicture.asset(
                                    Assets.imagesGroup,
                                    width: 160.w,
                                    height: 80.h,
                                  ),
                                  SizedBox(
                                    height: 45.h,
                                  ),
                                  CreateChatField(
                                    label: "Enter Chat Name",
                                    controller: CreateChatCubit.get(context)
                                        .chatNameController,
                                    validator: (String? value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "This Field is required";
                                      }
                                    },
                                  ),
                                  SizedBox(height: 25.h),
                                  CreateChatField(
                                    validator: (String? value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "This Field is required";
                                      }
                                    },
                                    controller: CreateChatCubit.get(context)
                                        .chatDescriptionController,
                                    label: "Enter  Chat Description",
                                  ),
                                  SizedBox(
                                    height: 75.h,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (CreateChatCubit.get(context)
                                          .formKey
                                          .currentState!
                                          .validate()) {
                                        CreateChatCubit.get(context)
                                            .createChat();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 100.w, vertical: 15.h)),
                                    child: Text(
                                      "Create",
                                      style: buttonNameStyle,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}