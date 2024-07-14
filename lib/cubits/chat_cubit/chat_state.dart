part of 'chat_cubit.dart';

enum ChatScreenState {
  init,
  getMassageLoading,
  getMassagesSuccess,
  getMassagesError,
  joinToChatSuccess,
  joinToChatLoading,
  joinToChatError,
  leaveChatSuccess,
  leaveChatLoading,
  leaveChatError,
  sendMassageSuccess,
  sendMassageLoading,
  sendMassageError,
  voiceMassagePlayed,
  voiceMassageLoading,
  voiceMassagePaused,
  voiceMassageError,
  voiceMassageComplete,
  getPhotoSuccess,
  getPhotoCanceled,
}

@immutable
class ChatState {
  ChatScreenState? chatScreenState;
  String? massage;
  UserModel? currentUser;
  num? currentVoicePositionInSeconds;
  MassageModel? playedMassage;
  bool? massageIsEmpty;
  QuerySnapshot<MassageModel>? massagesSnapshot;
  XFile? photo;

  ChatState(
      {this.chatScreenState,
      this.currentUser,
      this.massageIsEmpty,
      this.photo,
      this.currentVoicePositionInSeconds,
      this.massagesSnapshot,
      this.playedMassage,
      this.massage});

  ChatState copyWith(
      {ChatScreenState? chatScreenState,
      bool? massageIsEmpty,
      String? massage,
      XFile? photo,
      num? currentVoicePositionInSeconds,
      MassageModel? playedMassage,
      UserModel? currentUser,
      QuerySnapshot<MassageModel>? massagesSnapshot}) {
    return ChatState(
        photo: photo ?? this.photo,
        playedMassage: playedMassage ?? this.playedMassage,
        massageIsEmpty: massageIsEmpty ?? this.massageIsEmpty,
        massage: massage ?? this.massage,
        currentVoicePositionInSeconds:
            currentVoicePositionInSeconds ?? this.currentVoicePositionInSeconds,
        currentUser: currentUser ?? this.currentUser,
        chatScreenState: chatScreenState ?? this.chatScreenState,
        massagesSnapshot: massagesSnapshot ?? this.massagesSnapshot);
  }
}

final class ChatInitial extends ChatState {
  ChatInitial() : super(chatScreenState: ChatScreenState.init);
}
