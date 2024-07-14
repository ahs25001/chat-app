import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/sheard/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';

class SelectImageSourceDialog extends StatelessWidget {
  String chatId;
  String userId;

  SelectImageSourceDialog({required this.chatId,required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.chatScreenState == ChatScreenState.getPhotoCanceled) {
            Navigator.pop(context);
          } else if (state.chatScreenState == ChatScreenState.getPhotoSuccess) {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.sendPhotoScreen,
                arguments: MassageModel(
                    imageLink: state.photo?.path ?? "",
                    chatId: chatId,
                    senderId: userId));
          }
        },
        builder: (context, state) {
          return AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () {
                      ChatCubit.get(context).getPhotoFromCamera();
                    },
                    child: Icon(Icons.camera_alt,
                        size: 40.sp, color: primaryColor)),
                InkWell(
                    onTap: () {
                      ChatCubit.get(context).selectPhotoFromGallery();
                    },
                    child: Icon(Icons.image, size: 40.sp, color: primaryColor)),
              ],
            ),
          );
        },
      ),
    ).animate().scale(
        duration: const Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }
}
