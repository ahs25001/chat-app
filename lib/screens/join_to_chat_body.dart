import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../models/user_model.dart';
import '../sheard/styles/colors.dart';
import '../sheard/styles/styles.dart';

class JoinToChatBody extends StatelessWidget {
  ChatModel ? chatModel;

  UserModel? user;

  JoinToChatBody({required this.chatModel, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Hello, Welcome to our chat room",
              style: registerTextStyle.copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Join The ${chatModel?.title??""}",
              style: chatTitleStyle,
            ),
            SizedBox(
              height: 30.h,
            ),
            SvgPicture.asset(Assets.imagesMovies),
            SizedBox(
              height: 30.h,
            ),
            Text(
              chatModel?.description ?? "",
              style: labelStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 35.h,
            ),
            ElevatedButton(
              onPressed: () {
                chatModel?.users?.add(user);
                ChatCubit.get(context).updateChat(chatModel);
              },
              child: Text(
                "Join",
                style: buttonNameStyle,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: 61.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r))),
            )
          ],
        ),
      ),
    );
  }
}
