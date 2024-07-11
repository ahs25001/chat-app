import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/sheard/network/local/audio/audio_manager.dart';
import 'package:chat_app/sheard/network/local/image_picker/image_picker_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../sheard/network/local/firebase/firebase_manager.dart';
import '../../sheard/network/local/record/record_manager.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(String chatId) : super(ChatInitial()) {
    getMassages(chatId);
  }

  static ChatCubit get(context) => BlocProvider.of(context);
  TextEditingController massageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void sendMassage(String chatId) {
    emit(state.copyWith(
      chatScreenState: ChatScreenState.sendMassageLoading,
    ));
    FirebaseManager.sendMassage(MassageModel(
        chatId: chatId,
        content: massageController.text,
        senderId: state.currentUser?.id,
        sendTime: DateTime.now().microsecondsSinceEpoch,
        senderName: state.currentUser?.name));
    massageController.clear();
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
    emit(state.copyWith(
        chatScreenState: ChatScreenState.sendMassageSuccess,
        massageIsEmpty: true));
  }

  void getMassages(String chatId) {
    emit(state.copyWith(chatScreenState: ChatScreenState.getMassageLoading));
    try {
      Stream<QuerySnapshot<MassageModel>> streamData =
          FirebaseManager.getMassages(chatId);
      streamData.listen(
        (event) {
          if (!isClosed) {
            emit(state.copyWith(
                massagesSnapshot: event,
                chatScreenState: ChatScreenState.getMassagesSuccess));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(massage: e.toString()));
    }
  }

  void sendVoiceMassage(String chatId) async {
    emit(state.copyWith(
      chatScreenState: ChatScreenState.sendMassageLoading,
    ));
    String? path = await RecordManager.stopRecord();
    File audioFile = File(path ?? "");
    var responseOfDuration = await AudioManager.getDuration(path ?? "");
    var response =
        await FirebaseManager.uploadFileOnFirebase(path ?? "", audioFile);
    response.fold(
      (link) async {
        var durationResponse = await AudioManager.getDuration(link);
        durationResponse.fold(
          (duration) {
            FirebaseManager.sendMassage(MassageModel(
                chatId: chatId,
                voiceLink: link,
                senderId: state.currentUser?.id,
                durationInSecond: duration?.inSeconds ?? 0,
                sendTime: DateTime.now().microsecondsSinceEpoch,
                senderName: state.currentUser?.name));
            scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
            emit(state.copyWith(
                chatScreenState: ChatScreenState.sendMassageSuccess,
                massageIsEmpty: true));
          },
          (r) {
            print("${r.massage} =====================================");
            emit(state.copyWith(
                chatScreenState: ChatScreenState.sendMassageError,
                massage: r.massage,
                massageIsEmpty: true));
          },
        );
      },
      (r) {
        print("${r.massage} =====================================");
        emit(state.copyWith(
            chatScreenState: ChatScreenState.sendMassageError,
            massage: r.massage,
            massageIsEmpty: true));
      },
    );
  }

  void startRecord() {
    RecordManager.startRecord();
  }

  void joinToChat(ChatModel? chatModel, UserModel? user) {
    try {
      emit(state.copyWith(chatScreenState: ChatScreenState.joinToChatLoading));
      chatModel?.users?.add(user);
      FirebaseManager.updateChat(chatModel);
      emit(state.copyWith(chatScreenState: ChatScreenState.joinToChatSuccess));
    } catch (e) {
      emit(state.copyWith(
          chatScreenState: ChatScreenState.joinToChatError,
          massage: e.toString()));
    }
  }

  void leaveChat(ChatModel? chatModel) {
    try {
      emit(state.copyWith(chatScreenState: ChatScreenState.leaveChatLoading));
      chatModel?.users?.remove(state.currentUser);
      FirebaseManager.updateChat(chatModel);
      emit(state.copyWith(chatScreenState: ChatScreenState.leaveChatSuccess));
    } catch (e) {
      emit(state.copyWith(
          chatScreenState: ChatScreenState.leaveChatError,
          massage: e.toString()));
    }
  }

  void getCurrentUser() async {
    UserModel? currentUser = await FirebaseManager.getUserById(
        FirebaseAuth.instance.currentUser?.uid ?? "");
    if (!isClosed) {
      emit(state.copyWith(currentUser: currentUser));
    }
  }

  void setMassageOption(String? value) {
    emit(state.copyWith(massageIsEmpty: value == null || value.trim().isEmpty));
  }

  void playMassage(MassageModel? massageModel) async {
    emit(state.copyWith(
        playedMassage: massageModel,
        chatScreenState: ChatScreenState.voiceMassageLoading));
    await AudioManager.playRemoteSound(state.playedMassage?.voiceLink ?? "")
        .whenComplete(
      () {
        emit(state.copyWith(
            chatScreenState: ChatScreenState.voiceMassagePlayed));
        AudioManager.getPosition().listen(
          (event) {
            emit(state.copyWith(
                currentVoicePositionInSeconds: event?.inSeconds));
          },
        );
      },
    );
    await Future.delayed(
        Duration(seconds: (state.playedMassage?.durationInSecond ?? 0) + 1));
    emit(state.copyWith(
        chatScreenState: ChatScreenState.voiceMassageComplete,
        currentVoicePositionInSeconds: 0));
  }

  void selectPhotoFromCamera() async {
    XFile? image = await ImagePickerManager.getImageFromCamera();
  }
}
