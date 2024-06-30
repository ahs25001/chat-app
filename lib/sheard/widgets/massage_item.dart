
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../models/massage_model.dart';

class MassageItem extends StatelessWidget {
  MassageModel? massageModel;

  MassageItem({super.key, required this.massageModel});

  @override
  Widget build(BuildContext context) {
    bool fromMe =
        (FirebaseAuth.instance.currentUser!.uid == massageModel?.senderId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (fromMe)
            ? const SizedBox()
            : Text(
                massageModel?.senderName ?? "",
                style: labelStyle,
              ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (fromMe)
                ? Text(DateFormat.jm().format(
                DateTime.fromMicrosecondsSinceEpoch(
                    massageModel?.sendTime ?? 0)),style: chatTimeStyle,)
                : const SizedBox(),
            (fromMe) ? const Spacer() : const SizedBox(),

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 241.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
                decoration: BoxDecoration(
                    color: (fromMe) ? primaryColor : labelColor.withOpacity(.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                      bottomLeft: fromMe ? Radius.circular(25.r) : Radius.zero,
                      bottomRight:
                          !fromMe ? Radius.circular(25.r) : Radius.zero,
                    )),
                child: Text(massageModel?.content ?? "",
                    style: fromMe ? sandMassageStyle : receivedMassageStyle),
              ),
            ),
            (!fromMe) ? const Spacer() : const SizedBox(),
            (!fromMe) ? Text(DateFormat.jm().format(
                DateTime.fromMicrosecondsSinceEpoch(
                    massageModel?.sendTime ?? 0)),style: chatTimeStyle,) : const SizedBox()
          ],
        ),
      ],
    );
  }
}
