import 'package:chat_app/generated/assets.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/sheard/routes/routes.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatItem extends StatelessWidget {
  ChatModel? model;

  ChatItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.chatScreen, arguments: model),
      child: Card(
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            children: [
              SvgPicture.asset(
                Assets.imagesMovies,
                width: 85.w,
                height: 85.h,
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                model?.title ?? "",
                style: chatTitleTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                "${model?.users?.length ?? 0} ${AppLocalizations.of(context)!.members}" ??
                    "",
                style: labelStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
