import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                        onChanged: (value) {
                          ChatCubit.get(context).setMassageOption(value);
                        },
                        cursorColor: primaryColor,
                        controller: ChatCubit.get(context).massageController,
                        maxLines: 10,
                        minLines: 1,
                        style: registerTextStyle.copyWith(color: Colors.black),
                        decoration: InputDecoration(
                            suffixIcon: AnimatedSwitcher(
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(scale: animation,child: child,);
                              },
                              duration: 200.ms,
                              child: (ChatCubit.get(context)
                                          .state
                                          .massageIsEmpty ??
                                      true)
                                  ? Icon(
                                      key: ValueKey(ChatCubit.get(context)
                                          .state
                                          .massageIsEmpty),
                                      Icons.camera,
                                      color: primaryColor,
                                    )
                                  : SizedBox(),
                            ),
                            hintText:
                                AppLocalizations.of(context)!.typeAMassage,
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
                                borderSide: BorderSide(color: primaryColor),
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
                (state.chatScreenState == ChatScreenState.sendMassageLoading)
                    ? CircularProgressIndicator(
                        color: primaryColor,
                      )
                    : InkWell(
                        onTap: () {
                          if (state.massageIsEmpty ?? true) {
                          } else {
                            if (ChatCubit.get(context)
                                .massageController
                                .text
                                .trim()
                                .isNotEmpty) {
                              ChatCubit.get(context)
                                  .sendMassage(chat: chatModel);
                            }
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 30.r,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              (state.massageIsEmpty ?? true)
                                  ? Icons.mic
                                  : Icons.send,
                              key: ValueKey(state.massageIsEmpty),
                              color: Colors.white,
                              size: 25.sp,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}
