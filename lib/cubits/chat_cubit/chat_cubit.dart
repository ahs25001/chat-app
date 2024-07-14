import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:bloc/bloc.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/massage_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/sheard/network/local/audio/audio_manager.dart';
import 'package:chat_app/sheard/network/local/image_picker/image_picker_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

// import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../../sheard/network/local/firebase/firebase_manager.dart';
import '../../sheard/network/local/record/record_manager.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({String? chatId}) : super(ChatInitial()) {
    if (chatId != null) {
      getMassages(chatId);
    }
  }

  static ChatCubit get(context) => BlocProvider.of(context);
  TextEditingController massageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void sendMassage(String chatId) {
    emit(state.copyWith(
      chatScreenState: ChatScreenState.sendMassageLoading,
    ));
    var response = FirebaseManager.sendMassage(MassageModel(
        chatId: chatId,
        content: massageController.text,
        senderId: state.currentUser?.id,
        sendTime: DateTime.now().microsecondsSinceEpoch,
        senderName: state.currentUser?.name));
    response.fold(
      (l) {
        massageController.clear();
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
        emit(state.copyWith(
            chatScreenState: ChatScreenState.sendMassageSuccess,
            massageIsEmpty: true));
      },
      (r) {
        emit(state.copyWith(
          chatScreenState: ChatScreenState.sendMassageError,
        ));
      },
    );
  }

  void getMassages(String chatId) {
    emit(state.copyWith(chatScreenState: ChatScreenState.getMassageLoading));

    var response = FirebaseManager.getMassages(chatId);
    response.fold(
      (streamData) {
        streamData.listen(
          (event) {
            if (!isClosed) {
              emit(state.copyWith(
                  massagesSnapshot: event,
                  chatScreenState: ChatScreenState.getMassagesSuccess));
            }
          },
        );
      },
      (r) {
        emit(state.copyWith(massage: r.massage));
      },
    );
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
            var sendMassageResponse = FirebaseManager.sendMassage(MassageModel(
                chatId: chatId,
                voiceLink: link,
                senderId: state.currentUser?.id,
                durationInSecond: duration?.inSeconds ?? 0,
                sendTime: DateTime.now().microsecondsSinceEpoch,
                senderName: state.currentUser?.name));
            sendMassageResponse.fold(
              (l) {
                scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
                emit(state.copyWith(
                    chatScreenState: ChatScreenState.sendMassageSuccess,
                    massageIsEmpty: true));
              },
              (r) {
                emit(state.copyWith(
                  chatScreenState: ChatScreenState.sendMassageError,
                  massage: r.massage,
                ));
              },
            );
          },
          (r) {
            emit(state.copyWith(
              chatScreenState: ChatScreenState.sendMassageError,
              massage: r.massage,
            ));
          },
        );
      },
      (r) {
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

  void joinToChat(ChatModel? chatModel, UserModel? user) async {
    emit(state.copyWith(chatScreenState: ChatScreenState.joinToChatLoading));
    chatModel?.users?.add(user);
    var response = await FirebaseManager.updateChat(chatModel);
    response.fold(
      (l) {
        emit(
            state.copyWith(chatScreenState: ChatScreenState.joinToChatSuccess));
      },
      (r) {
        emit(state.copyWith(
            chatScreenState: ChatScreenState.joinToChatError,
            massage: r.massage));
      },
    );
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
    var response = await FirebaseManager.getUserById(
        FirebaseAuth.instance.currentUser?.uid ?? "");
    response.fold(
      (currentUser) {
        if (!isClosed) {
          emit(state.copyWith(currentUser: currentUser));
        }
      },
      (r) {
        if (!isClosed) {
          emit(state.copyWith(massage: r.massage));
        }
      },
    );
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

  void pauseMassage() {
    AudioManager.pausePlayer();
    emit(state.copyWith(chatScreenState: ChatScreenState.voiceMassagePaused));
  }

  void resumeMassage() {
    AudioManager.resumePlayer();
    emit(state.copyWith(chatScreenState: ChatScreenState.voiceMassagePlayed));
  }

  void getPhotoFromCamera() async {
    XFile? photo = await ImagePickerManager.getImageFromCamera();
    if (photo != null) {
      print("Photo captured successfully path is : ${photo.path}");
      emit(state.copyWith(
          chatScreenState: ChatScreenState.getPhotoSuccess, photo: photo));
    } else {
      print("Photo capture canceled");
      emit(state.copyWith(chatScreenState: ChatScreenState.getPhotoCanceled));
    }
  }

  void selectPhotoFromGallery() async {
    XFile? photo = await ImagePickerManager.getImageFromGallery();
    if (photo != null) {
      print("Photo captured successfully path is : ${photo.path}");
      emit(state.copyWith(
          chatScreenState: ChatScreenState.getPhotoSuccess, photo: photo));
    } else {
      print("Photo capture canceled");
      emit(state.copyWith(chatScreenState: ChatScreenState.getPhotoCanceled));
    }
  }

  void sendPhoto(String chatId, String imagePath, String userId) async {
    emit(state.copyWith(
      chatScreenState: ChatScreenState.sendMassageLoading,
    ));
    File imageFile = File(imagePath);
    var response =
        await FirebaseManager.uploadFileOnFirebase(imagePath, imageFile);
    response.fold(
      (l) {
        var sendMassageResponse = FirebaseManager.sendMassage(MassageModel(
            chatId: chatId,
            content: massageController.text,
            imageLink: l,
            senderId: userId,
            sendTime: DateTime.now().microsecondsSinceEpoch,
            senderName: state.currentUser?.name));
        response.fold(
          (l) {
            massageController.clear();
            emit(state.copyWith(
                chatScreenState: ChatScreenState.sendMassageSuccess,
                massageIsEmpty: true));
          },
          (r) {
            emit(state.copyWith(
              chatScreenState: ChatScreenState.sendMassageError,
              massage: r.massage,
            ));
          },
        );
      },
      (r) {
        emit(state.copyWith(
          chatScreenState: ChatScreenState.sendMassageError,
          massage: r.massage,
        ));
      },
    );
  }
}
