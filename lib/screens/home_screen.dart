import 'package:chat_app/cubits/home_cubit/home_cubit.dart';
import 'package:chat_app/screens/browse_tab.dart';
import 'package:chat_app/screens/my_rooms_tab.dart';
import 'package:chat_app/sheard/routes/routes.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../sheard/constants/widgets.dart';
import '../sheard/styles/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 943));
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.homeScreenState == HomeScreenState.getChatsError) {
            showErrorSnackBar(context: context, text: state.errorMassage ?? "");
          }
        },
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  Navigator.pushNamed(context, AppRoutes.createChatScreen);
                },
                backgroundColor: primaryColor,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              drawer: SafeArea(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  color: Colors.white,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, AppRoutes.settingsScreen);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.settings,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              AppLocalizations.of(context)!.settings,
                              style: tabLabelTextStyle.copyWith(
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              body: Stack(
                children: [
                  SvgPicture.asset(
                    Assets.imagesAppBarBackground,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 193.h,
                          child: AppBar(
                            title: Text(
                              AppLocalizations.of(context)!.chatApp,
                              style: appBarStyle,
                            ),
                            iconTheme: const IconThemeData(color: Colors.white),
                            centerTitle: true,
                            backgroundColor: Colors.transparent,
                            bottom: TabBar(
                              dividerColor: Colors.transparent,
                              indicatorColor: Colors.white,
                              labelStyle: tabLabelTextStyle,
                              unselectedLabelStyle: tabLabelTextStyle.copyWith(
                                  color: unselectedTabLabelColor),
                              tabs: [
                                Tab(
                                  text: AppLocalizations.of(context)!.myChats,
                                ),
                                Tab(
                                  text: AppLocalizations.of(context)!.browse,
                                )
                              ],
                            ),
                            actions: [
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.searchScreen),
                                child: Icon(
                                  Icons.search,
                                  size: 30.sp,
                                ),
                              )
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 47.h,
                        // ),
                        const Expanded(
                          child:
                              TabBarView(children: [MyRoomsTab(), BrowseTab()]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
