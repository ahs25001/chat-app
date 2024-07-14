import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/sheard/routes/routes.dart';
import 'package:chat_app/sheard/widgets/show_photo.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubits/app_cubit/app_cubit.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';

class PhotoMassage extends StatelessWidget {
  MassageModel? massageModel;
  bool fromMe;

  PhotoMassage({required this.massageModel, required this.fromMe});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
          decoration: BoxDecoration(
              color: (fromMe) ? primaryColor : labelColor.withOpacity(.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
                bottomLeft: (state.localCode == "en")
                    ? (fromMe ? Radius.circular(25.r) : Radius.zero)
                    : (!fromMe ? Radius.circular(25.r) : Radius.zero),
                bottomRight: (state.localCode == "en")
                    ? (!fromMe ? Radius.circular(25.r) : Radius.zero)
                    : (fromMe ? Radius.circular(25.r) : Radius.zero),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (fromMe)
                  ? const SizedBox()
                  : Text(
                      massageModel?.senderName ?? "",
                      style: labelStyle,
                    ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                    context, AppRoutes.showPhotoScreen,
                    arguments: massageModel),
                child: Hero(
                    tag: massageModel?.imageLink ?? "",
                    child: FancyShimmerImage(
                      imageUrl: massageModel?.imageLink ?? "",
                      width: 150.w,
                      height: 200.h,
                      boxFit: BoxFit.contain,
                    )),
              ),
              SizedBox(
                height: 10.h,
              ),
              ((massageModel?.content ?? "").isNotEmpty)
                  ? Text(massageModel?.content ?? "",
                      style: fromMe ? sandMassageStyle : receivedMassageStyle)
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
