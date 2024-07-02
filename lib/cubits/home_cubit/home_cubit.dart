import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../sheard/network/local/firebase/firebase_manager.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    getChatsAndCurrentUser();
  }

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  void getChatsAndCurrentUser() async {
    if (!isClosed) {
      emit(state.copyWith(
        homeScreenState: HomeScreenState.getChatsLoading,
        myChats: [],
        allChats: [],
        browserChats: [],
      ));
    }

    try {
      final currentUser = state.currentUser ??
          await FirebaseManager.getUserById(
              FirebaseAuth.instance.currentUser?.uid ?? "");

      final streamData = FirebaseManager.getChats();
      await for (final event in streamData) {
        final allChats = event.docs.map((e) => e.data()).toList();
        final myChats = <ChatModel>[];
        final browserChats = <ChatModel>[];

        for (final chat in allChats) {
          final usersIds = chat.users?.map((user) => user?.id).toList() ?? [];
          if (usersIds.contains(currentUser?.id)) {
            myChats.add(chat);
          } else {
            browserChats.add(chat);
          }
        }
        if (!isClosed) {
          emit(state.copyWith(
            homeScreenState: HomeScreenState.getChatsSuccess,
            currentUser: currentUser,
            browserChats: browserChats,
            myChats: myChats,
            allChats: allChats,
          ));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(homeScreenState: HomeScreenState.getChatsError));
      }
    }
  }
}
