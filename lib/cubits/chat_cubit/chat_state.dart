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
}

@immutable
class ChatState {
  ChatScreenState? chatScreenState;
  String? massage;
  UserModel? currentUser;
  bool? massageIsEmpty;
  QuerySnapshot<MassageModel>? massagesSnapshot;

  ChatState(
      {this.chatScreenState,
      this.currentUser,
      this.massageIsEmpty,
      this.massagesSnapshot,
      this.massage});

  ChatState copyWith(
      {ChatScreenState? chatScreenState,
      bool? massageIsEmpty,
      String? massage,
      UserModel? currentUser,
      QuerySnapshot<MassageModel>? massagesSnapshot}) {
    return ChatState(
        massageIsEmpty: massageIsEmpty ?? this.massageIsEmpty,
        massage: massage ?? this.massage,
        currentUser: currentUser ?? this.currentUser,
        chatScreenState: chatScreenState ?? this.chatScreenState,
        massagesSnapshot: massagesSnapshot ?? this.massagesSnapshot);
  }
}

final class ChatInitial extends ChatState {
  ChatInitial() : super(chatScreenState: ChatScreenState.init);
}
