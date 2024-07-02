part of 'search_cubit.dart';

enum SearchScreenState {
  init,
  gitChatsSuccess,
  gitChatsLoading,
  gitChatsError,
}

@immutable
class SearchState {
  SearchScreenState? searchScreenState;
  List<ChatModel>? chats;
  String? massage;

  SearchState({this.searchScreenState, this.chats, this.massage});

  SearchState copyWith(
      {SearchScreenState? searchScreenState,
      String? massage,
      List<ChatModel>? chats}) {
    return SearchState(
        chats: chats ?? this.chats,
        massage: massage ?? this.massage,
        searchScreenState: searchScreenState ?? this.searchScreenState);
  }
}

final class SearchInitial extends SearchState {
  SearchInitial() : super(searchScreenState: SearchScreenState.init);
}
