import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../cubits/app_cubit/app_cubit.dart';
import '../sheard/widgets/massage_item.dart';

class ChatBody extends StatelessWidget {
  ChatModel chatModel;

  ChatBody(this.chatModel);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        List<MassageModel>? massages =
            state.massagesSnapshot?.docs.map((doc) => doc.data()).toList();
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                  reverse: true,
                  controller: ChatCubit.get(context).scrollController,
                  itemBuilder: (context, index) {
                    return MassageItem(massageModel: massages?[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 15.h,
                    );
                  },
                  itemCount: massages?.length ?? 0),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      return TextFormField(
                        cursorColor: primaryColor,
                        controller: ChatCubit.get(context).massageController,
                        maxLines: 10,
                        minLines: 1,
                        style: registerTextStyle.copyWith(color: Colors.black),
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.typeAMassage,
                            hintStyle: labelStyle,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.h, vertical: 5.w),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                              topRight:
                                  (state.appStatus == AppStatus.enLanguage)
                                      ? Radius.circular(18.r)
                                      : Radius.zero,
                              topLeft: (state.appStatus == AppStatus.arLanguage)
                                  ? Radius.circular(18.r)
                                  : Radius.zero,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      (state.appStatus == AppStatus.enLanguage)
                                          ? Radius.circular(18.r)
                                          : Radius.zero,
                                  topLeft:
                                      (state.appStatus == AppStatus.arLanguage)
                                          ? Radius.circular(18.r)
                                          : Radius.zero,
                                )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight:
                                (state.appStatus == AppStatus.enLanguage)
                                    ? Radius.circular(18.r)
                                    : Radius.zero,
                                topLeft: (state.appStatus == AppStatus.arLanguage)
                                    ? Radius.circular(18.r)
                                    : Radius.zero,
                              ))
                        ),
                        // scrollPadding: ,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                (state.chatScreenState == ChatScreenState.sendMassageLoading)
                    ? CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : InkWell(
                        onTap: () {
                          if (ChatCubit.get(context)
                              .massageController
                              .text
                              .trim()
                              .isNotEmpty) {
                            ChatCubit.get(context).sendMassage(chat: chatModel);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12.r)),
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: 16.w),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.send,
                                style: registerTextStyle,
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Icon(
                                Icons.send,
                                size: 16.sp,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
          ],
        );
      },
    );
  }
}
