import 'package:chat_app/models/massage_model.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class ShowPhoto extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var massageModel = ModalRoute.of(context)!.settings.arguments as MassageModel ;
    return Scaffold(
        body: Center(
      child:  Hero(
          tag: massageModel.imageLink ?? "",
          child: FancyShimmerImage(
            imageUrl:massageModel.imageLink ?? "" ,
            width: double.infinity,
            height: double.infinity,
            boxFit: BoxFit.contain,

          ),
        ),

    ));
  }
}
