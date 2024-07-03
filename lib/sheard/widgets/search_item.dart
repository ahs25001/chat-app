import 'package:chat_app/generated/assets.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/sheard/routes/routes.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchItem extends StatelessWidget {
  ChatModel? chatModel;

  SearchItem(this.chatModel);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.chatScreen,
          arguments: chatModel),
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.imagesMovies,
              width: 150.w,
              height: 99.h,
            ),
            SizedBox(
              width: 15.w,
            ),
            Text(
              chatModel?.title ?? "",
              style: chatTitleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
