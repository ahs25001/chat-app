import 'package:chat_app/cubits/search_cubit/search_cubit.dart';
import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:chat_app/sheard/widgets/search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              automaticallyImplyLeading: false,
              title: TextField(
                controller: SearchCubit.get(context).searchController,
                onChanged: (value) {
                  SearchCubit.get(context).searchInChats();
                },
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchChatName,
                  hintStyle: labelStyle,
                  prefixIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 17.w),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(56.r)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(56.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(56.r)),
                ),
              ),
            ),
            body: (state.searchScreenState == SearchScreenState.gitChatsLoading)
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return SearchItem(state.chats?[index]);
                    },
                    itemCount: state.chats?.length ?? 0,
                  ),
          );
        },
      ),
    );
  }
}
