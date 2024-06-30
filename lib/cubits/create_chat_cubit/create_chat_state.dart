part of 'create_chat_cubit.dart';

enum CreateChatScreenState {
  init,
  createChatLoading,
  createChatSuccess,
  createChatError,
}

@immutable
class CreateChatState {
  CreateChatScreenState? chatScreenState;
  String? errorMassage;

  CreateChatState({this.chatScreenState, this.errorMassage});

  CreateChatState copyWith(
      {CreateChatScreenState? chatScreenState, String? errorMassage}) {
    return CreateChatState(
        chatScreenState: chatScreenState ?? this.chatScreenState,
        errorMassage: errorMassage ?? this.errorMassage);
  }
}

final class CreateChatInitial extends CreateChatState {
  CreateChatInitial() : super(chatScreenState: CreateChatScreenState.init);
}
