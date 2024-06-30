import 'package:bloc/bloc.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/sheard/network/firebase/firebase_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(String chatId) : super(ChatInitial()) {
    getMassages(chatId);
  }

  static ChatCubit get(context) => BlocProvider.of(context);
  TextEditingController massageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void sendMassage({required ChatModel chat}) {
    emit(state.copyWith(chatScreenState: ChatScreenState.sendMassageLoading));
    FirebaseManager.sendMassage(MassageModel(
        chatId: chat.id,
        content: massageController.text,
        senderId: state.currentUser?.id,
        sendTime: DateTime.now().microsecondsSinceEpoch,
        senderName: state.currentUser?.name));
    massageController.clear();
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
    emit(state.copyWith(chatScreenState: ChatScreenState.sendMassageSuccess));
  }

  void getMassages(String chatId) {
    emit(state.copyWith(chatScreenState: ChatScreenState.getMassageLoading));
    try {
      Stream<QuerySnapshot<MassageModel>> streamData =
          FirebaseManager.getMassages(chatId);
      streamData.listen(
        (event) {
          emit(state.copyWith(
              massagesSnapshot: event,
              chatScreenState: ChatScreenState.getMassagesSuccess));
        },
      );
    } catch (e) {
      emit(state.copyWith(massage: e.toString()));
    }
  }

  void updateChat(ChatModel? newChatModel) {
    emit(state.copyWith(chatScreenState: ChatScreenState.joinToChatLoading));
    FirebaseManager.updateChat(newChatModel);
    emit(state.copyWith(chatScreenState: ChatScreenState.joinToChatSuccess));
  }

  void getCurrentUser() async {
    UserModel? currentUser = await FirebaseManager.getUserById(
        FirebaseAuth.instance.currentUser?.uid ?? "");
    emit(state.copyWith(currentUser: currentUser));
  }
}