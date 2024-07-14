import 'dart:io';

import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubits/app_cubit/app_cubit.dart';
import '../sheard/styles/colors.dart';
import '../sheard/styles/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendPhotoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MassageModel massage =
        ModalRoute.of(context)!.settings.arguments as MassageModel;
    File imageFile = File(massage.imageLink ?? "");
    return BlocProvider.value(
      value: ChatCubit(),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if(state.chatScreenState==ChatScreenState.sendMassageSuccess){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          print(state.chatScreenState);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.file(imageFile,width: double.infinity,height: double.infinity,),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: BlocBuilder<AppCubit, AppState>(
                              builder: (context, state) {
                                return TextFormField(
                                  onChanged: (value) {
                                    ChatCubit.get(context)
                                        .setMassageOption(value);
                                  },
                                  cursorColor: primaryColor,
                                  controller:
                                      ChatCubit.get(context).massageController,
                                  maxLines: 10,
                                  minLines: 1,
                                  style: registerTextStyle.copyWith(
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: AppLocalizations.of(context)!
                                          .typeAMassage,
                                      hintStyle: labelStyle,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.h, vertical: 5.w),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                        topRight: (state.localCode == "en")
                                            ? Radius.circular(18.r)
                                            : Radius.zero,
                                        topLeft: (state.localCode == "ar")
                                            ? Radius.circular(18.r)
                                            : Radius.zero,
                                      )),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor),
                                          borderRadius: BorderRadius.only(
                                            topRight: (state.localCode == "en")
                                                ? Radius.circular(18.r)
                                                : Radius.zero,
                                            topLeft: (state.localCode == "ar")
                                                ? Radius.circular(18.r)
                                                : Radius.zero,
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                        topRight: (state.localCode == "en")
                                            ? Radius.circular(18.r)
                                            : Radius.zero,
                                        topLeft: (state.localCode == "ar")
                                            ? Radius.circular(18.r)
                                            : Radius.zero,
                                      ))),
                                  // scrollPadding: ,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          (state.chatScreenState ==
                                  ChatScreenState.sendMassageLoading)
                              ? CircularProgressIndicator(
                                  color: primaryColor,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    ChatCubit.get(context).sendPhoto(
                                            massage.chatId ?? "",
                                            massage.imageLink ?? "",massage.senderId??"");
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 30.r,
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 25.sp,
                                    ),
                                  ),
                                ),
                        ],
                      ),
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
