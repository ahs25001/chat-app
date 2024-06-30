import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/sheard/network/firebase/firebase_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/chat_model.dart';
import '../../models/user_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    getChatsAndCurrentUser();
  }

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  void getChatsAndCurrentUser() async {
    emit(state.copyWith(
        homeScreenState: HomeScreenState.getChatsLoading,
        myChats: [],
        allChats: [],
        browserChats: []));
    UserModel? currentUser;
    List<ChatModel> myChats = [];
    List<ChatModel> browserChats = [];
    try {
      Stream<QuerySnapshot<ChatModel>> streamData = FirebaseManager.getChats();
      if (state.currentUser == null) {
        currentUser = await FirebaseManager.getUserById(
            FirebaseAuth.instance.currentUser?.uid ?? "");
      } else {
        currentUser = state.currentUser;
      }
      streamData.listen(
        (event) {
          List<ChatModel> allChats = event.docs
              .map(
                (e) => e.data(),
              )
              .toList();
          for (ChatModel chat in allChats) {
            List<String?> usersIsds = [];

            for (UserModel? user in (chat.users) ?? []) {
              usersIsds.add(user?.id);
            }
            if (usersIsds.contains(currentUser?.id)) {
              myChats.add(chat);
            } else {
              browserChats.add(chat);
            }
          }
          emit(state.copyWith(
              homeScreenState: HomeScreenState.getChatsSuccess,
              currentUser: currentUser,
              browserChats: browserChats,
              myChats: myChats,
              allChats: allChats));
        },
      );
    } catch (e) {
      state.copyWith(homeScreenState: HomeScreenState.getChatsError);
    }
  }
}
