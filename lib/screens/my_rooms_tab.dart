import 'package:chat_app/cubits/home_cubit/home_cubit.dart';
import 'package:chat_app/sheard/constants/widgets.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../sheard/widgets/chat_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class MyRoomsTab extends StatelessWidget {
  const MyRoomsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 943));
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder:(context, state) {
          if (state.homeScreenState == HomeScreenState.getChatsLoading) {
            return Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ));
          } else if (state.homeScreenState ==
              HomeScreenState.getChatsSuccess &&
              (state.myChats?.isNotEmpty ?? false)) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 21.w,
                  mainAxisSpacing: 21.h,
                  childAspectRatio: 140 / 180),
              itemBuilder: (context, index) =>
                  ChatItem(model: state.myChats?[index]),
              itemCount: state.myChats?.length ?? 0,
            );
          } else if (state.homeScreenState ==
              HomeScreenState.getChatsSuccess &&
              (state.myChats?.isEmpty ?? true)) {
            return Center(
                child: Text(
                  AppLocalizations.of(context)!.noChatsJoinedYet,
                  style: tabLabelTextStyle.copyWith(color: labelColor),
                ));
          }
          return const AlertDialog(
            content: Text("error"),
          );
        }
      ),
    );
  }
}
