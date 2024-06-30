import 'package:chat_app/cubits/home_cubit/home_cubit.dart';
import 'package:chat_app/screens/browse_tab.dart';
import 'package:chat_app/screens/create_chat_screen.dart';
import 'package:chat_app/screens/my_rooms_tab.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../sheard/styles/styles.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "home screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 943));
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  Navigator.pushNamed(context, CreateChatScreen.routeName);
                },
                backgroundColor: primaryColor,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              drawer: const Column(
                children: [],
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
                              "Chat App",
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
                              tabs: const [
                                Tab(
                                  text: "My Chats",
                                ),
                                Tab(
                                  text: "Browse",
                                )
                              ],
                            ),
                            actions: [
                              Icon(
                                Icons.search,
                                size: 30.sp,
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
