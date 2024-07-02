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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoinToChatBody extends StatelessWidget {
  ChatModel? chatModel;

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
              AppLocalizations.of(context)!.welcomeMassage,
              style: registerTextStyle.copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "${AppLocalizations.of(context)!.joinThe} ${chatModel?.title ?? ""}",
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
                ChatCubit.get(context).joinToChat(chatModel, user);
              },
              child: Text(
                AppLocalizations.of(context)!.join,
                style: buttonNameStyle,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 61.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r))),
            )
          ],
        ),
      ),
    );
  }
}
