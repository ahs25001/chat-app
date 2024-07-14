import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/sheard/network/local/audio/audio_manager.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../cubits/app_cubit/app_cubit.dart';
import '../sheard/constants/widgets.dart';
import '../sheard/network/local/record/record_manager.dart';
import '../sheard/widgets/massage_item.dart';
import '../sheard/widgets/select_image_source_dialog.dart';

class ChatBody extends StatefulWidget {
  ChatModel chatModel;

  ChatBody(this.chatModel, {super.key});

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  void initState() {
    RecordManager.initRecord();
    AudioManager.initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    RecordManager.disposeRecord();
    AudioManager.disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      buildWhen: (previous, current) {
        return current.chatScreenState == ChatScreenState.getMassagesSuccess;
      },
      listener: (context, state) {
        if (state.chatScreenState == ChatScreenState.sendMassageError ||
            state.chatScreenState == ChatScreenState.joinToChatError ||
            state.chatScreenState == ChatScreenState.leaveChatError ||
            state.chatScreenState == ChatScreenState.getMassagesError ||
            state.chatScreenState == ChatScreenState.voiceMassageError) {
          showErrorSnackBar(context: context, text: state.massage ?? "");
        }
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
                  itemCount: (massages?.length) ?? 0),
            ),
            BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: BlocBuilder<AppCubit, AppState>(
                        builder: (context, appState) {
                          return TextFormField(
                            onChanged: (value) {
                              ChatCubit.get(context).setMassageOption(value);
                            },
                            cursorColor: primaryColor,
                            controller:
                                ChatCubit.get(context).massageController,
                            maxLines: 10,
                            minLines: 1,
                            style:
                                registerTextStyle.copyWith(color: Colors.black),
                            decoration: InputDecoration(
                                suffixIcon: AnimatedSwitcher(
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  duration: 200.ms,
                                  child: (ChatCubit.get(context)
                                              .state
                                              .massageIsEmpty ??
                                          true)
                                      ? InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return SelectImageSourceDialog(
                                                  userId: state
                                                          .currentUser
                                                          ?.id ??
                                                      "",
                                                  chatId:
                                                      widget.chatModel.id ?? "",
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            key: ValueKey(ChatCubit.get(context)
                                                .state
                                                .massageIsEmpty),
                                            Icons.camera,
                                            color: primaryColor,
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                hintText:
                                    AppLocalizations.of(context)!.typeAMassage,
                                hintStyle: labelStyle,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.h, vertical: 5.w),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  topRight: (appState.localCode == "en")
                                      ? Radius.circular(18.r)
                                      : Radius.zero,
                                  topLeft: (appState.localCode == "ar")
                                      ? Radius.circular(18.r)
                                      : Radius.zero,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.only(
                                      topRight: (appState.localCode == "en")
                                          ? Radius.circular(18.r)
                                          : Radius.zero,
                                      topLeft: (appState.localCode == "ar")
                                          ? Radius.circular(18.r)
                                          : Radius.zero,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                  topRight: (appState.localCode == "en")
                                      ? Radius.circular(18.r)
                                      : Radius.zero,
                                  topLeft: (appState.localCode == "ar")
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
                            onLongPressCancel: () {
                              RecordManager.cancelRecord();
                            },
                            onLongPress: () {
                              if (state.massageIsEmpty ?? true) {
                                ChatCubit.get(context).startRecord();
                              }
                            },
                            onLongPressEnd: (details) {
                              if (state.massageIsEmpty ?? true) {
                                ChatCubit.get(context).sendVoiceMassage(
                                    widget.chatModel.id ?? "");
                              }
                            },
                            onTap: () {
                              if (!(state.massageIsEmpty ?? true)) {
                                if (ChatCubit.get(context)
                                    .massageController
                                    .text
                                    .trim()
                                    .isNotEmpty) {
                                  ChatCubit.get(context)
                                      .sendMassage(widget.chatModel.id ?? "");
                                }
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 30.r,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
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
                );
              },
            ),
          ],
        );
      },
    );
  }
}
