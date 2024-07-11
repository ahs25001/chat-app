import 'package:chat_app/cubits/app_cubit/app_cubit.dart';
import 'package:chat_app/sheard/network/local/audio/audio_manager.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:chat_app/sheard/widgets/voice_massage_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../models/massage_model.dart';

class MassageItem extends StatefulWidget {
  MassageModel? massageModel;

  MassageItem({super.key, required this.massageModel});

  @override
  State<MassageItem> createState() => _MassageItemState();
}

class _MassageItemState extends State<MassageItem> {
  @override
  Widget build(BuildContext context) {
    bool fromMe = (FirebaseAuth.instance.currentUser!.uid ==
        widget.massageModel?.senderId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (fromMe)
            ? const SizedBox()
            : Text(
                widget.massageModel?.senderName ?? "",
                style: labelStyle,
              ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (fromMe)
                ? Text(
                    DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(
                        widget.massageModel?.sendTime ?? 0)),
                    style: chatTimeStyle,
                  )
                : const SizedBox(),
            (fromMe) ? const Spacer() : const SizedBox(),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 241.w),
                  child: (widget.massageModel?.voiceLink != null)
                      ? VoiceMassageWidget(
                       massageModel: widget.massageModel,
                          fromMe: fromMe,
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 18.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                              color: (fromMe)
                                  ? primaryColor
                                  : labelColor.withOpacity(.2),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.r),
                                topRight: Radius.circular(25.r),
                                bottomLeft: (state.localCode == "en")
                                    ? (fromMe
                                        ? Radius.circular(25.r)
                                        : Radius.zero)
                                    : (!fromMe
                                        ? Radius.circular(25.r)
                                        : Radius.zero),
                                bottomRight: (state.localCode == "en")
                                    ? (!fromMe
                                        ? Radius.circular(25.r)
                                        : Radius.zero)
                                    : (fromMe
                                        ? Radius.circular(25.r)
                                        : Radius.zero),
                              )),
                          child: Text(widget.massageModel?.content ?? "",
                              style: fromMe
                                  ? sandMassageStyle
                                  : receivedMassageStyle),
                        ),
                );
              },
            ),
            (!fromMe) ? const Spacer() : const SizedBox(),
            (!fromMe)
                ? Text(
                    DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(
                        widget.massageModel?.sendTime ?? 0)),
                    style: chatTimeStyle,
                  )
                : const SizedBox()
          ],
        ),
      ],
    );
  }
}
