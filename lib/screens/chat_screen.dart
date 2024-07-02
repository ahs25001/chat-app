import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../sheard/styles/styles.dart';
import 'chat_body.dart';
import 'join_to_chat_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ChatScreen extends StatelessWidget {
  static const String routeName = "chat screen";

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatModel chatModel =
        ModalRoute.of(context)!.settings.arguments as ChatModel;

    return BlocProvider(
      create: (context) => ChatCubit(chatModel.id ?? "")..getCurrentUser(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.chatScreenState == ChatScreenState.leaveChatSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreen.routeName,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          bool isUserInChat = false;
          for (UserModel? user in (chatModel.users) ?? []) {
            if (user!.id == FirebaseAuth.instance.currentUser!.uid) {
              isUserInChat = true;
              state.currentUser = user;
            }
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                SvgPicture.asset(
                  Assets.imagesAppBarBackground,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        title: Text(
                          chatModel.title ?? "",
                          style: appBarStyle,
                        ),
                        iconTheme: const IconThemeData(color: Colors.white),
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        actions: (isUserInChat)
                            ? [
                                PopupMenuButton<int>(
                                  onSelected: (value) {
                                    if (value == 0) {
                                      ChatCubit.get(context)
                                          .leaveChat(chatModel);
                                    }
                                  },
                                  popUpAnimationStyle: AnimationStyle(
                                      duration:
                                          const Duration(milliseconds: 500)),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 0,
                                        child: Text(
                                          AppLocalizations.of(context)!.leaveChat,
                                          style: menuItemStyle,
                                        ),
                                      )
                                    ];
                                  },
                                )
                              ]
                            : null,
                      ),
                      Expanded(
                        child: Center(
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.r)),
                            child: Padding(
                              padding: (isUserInChat)
                                  ? EdgeInsets.symmetric(
                                      vertical: 12.h, horizontal: 14.w)
                                  : EdgeInsets.symmetric(
                                      vertical: 44.h, horizontal: 34.w),
                              child: (isUserInChat)
                                  ? ChatBody(chatModel)
                                  : JoinToChatBody(
                                      chatModel: chatModel,
                                      user: state.currentUser,
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
