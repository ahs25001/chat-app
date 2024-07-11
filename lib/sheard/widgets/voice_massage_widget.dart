import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceMassageWidget extends StatelessWidget {
  MassageModel? massageModel;
  bool fromMe;

  VoiceMassageWidget({required this.massageModel, required this.fromMe});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              color: fromMe ? primaryColor : labelColor.withOpacity(.2)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    if (state.chatScreenState ==
                            ChatScreenState.voiceMassagePlayed &&
                        state.playedMassage?.id == massageModel?.id) {
                      ChatCubit.get(context).pauseMassage();
                    } else if (state.chatScreenState ==
                            ChatScreenState.voiceMassagePaused &&
                        state.playedMassage?.id == massageModel?.id) {
                      ChatCubit.get(context).resumeMassage();
                    } else {
                      ChatCubit.get(context).playMassage(massageModel);
                    }
                  },
                  child: (state.chatScreenState ==
                              ChatScreenState.voiceMassageLoading &&
                          state.playedMassage?.id == massageModel?.id)
                      ? SizedBox(
                          height: 35.h,
                          width: 35.w,
                          child: CircularProgressIndicator(
                            color: fromMe ? Colors.white : Colors.black,
                          ),
                        )
                      : Icon(
                          (state.chatScreenState ==
                                      ChatScreenState.voiceMassagePlayed &&
                                  state.playedMassage?.id == massageModel?.id)
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: fromMe ? Colors.white : Colors.black,
                          size: 30.sp,
                        ),
                ),
                SizedBox(
                  width: 150.w,
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(12.r),
                    backgroundColor: (fromMe) ? null : Colors.grey,
                    minHeight: 10.h,
                    value: (state.playedMassage?.id == massageModel?.id)
                        ? ((state.currentVoicePositionInSeconds ?? 0) /
                            (massageModel?.durationInSecond ?? 0).toInt())
                        : 0,
                    color: fromMe ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
            Text(
              "${((((massageModel?.durationInSecond ?? 0) - ((state.playedMassage?.id == massageModel?.id) ? (state.currentVoicePositionInSeconds ?? 0) : 0)).toInt()) ~/ 60).toString().padLeft(2, "0")}:${((((massageModel?.durationInSecond ?? 0) - ((state.playedMassage?.id == massageModel?.id) ? (state.currentVoicePositionInSeconds ?? 0) : 0)).toInt()) % 60).toString().padLeft(2, "0")}",
              style: fromMe
                  ? sandMassageStyle.copyWith(fontSize: 10.sp)
                  : receivedMassageStyle.copyWith(fontSize: 10.sp),
            )
          ]),
        );
      },
    );
  }
}
