import 'package:chat_app/models/massage_model.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowPhoto extends StatelessWidget {
  MassageModel? massageModel;

  ShowPhoto(this.massageModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Hero(
          tag: massageModel?.imageLink ?? "",
          child: FancyShimmerImage(
            imageUrl:massageModel?.imageLink ?? "" ,
            width: double.infinity,
            height: double.infinity,
            boxFit: BoxFit.contain,

          ),
        ),
      ),
    ));
  }
}
