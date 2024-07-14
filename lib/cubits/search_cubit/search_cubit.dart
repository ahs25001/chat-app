import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../models/chat_model.dart';
import '../../sheard/network/local/firebase/firebase_manager.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);
  TextEditingController searchController = TextEditingController();

  void searchInChats() async {
    emit(state.copyWith(searchScreenState: SearchScreenState.gitChatsLoading));

     var response =
          await FirebaseManager.searchInChats(searchController.text);
     response.fold((l) {
       List<ChatModel> chats = l.docs
           .map(
             (doc) => doc.data(),
       )
           .toList();
       emit(state.copyWith(
           searchScreenState: SearchScreenState.gitChatsSuccess, chats: chats));
     }, (r) {
       emit(state.copyWith(
           searchScreenState: SearchScreenState.gitChatsError,
           massage: r.massage));
     },);




  }
}
