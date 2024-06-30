part of 'home_cubit.dart';

enum HomeScreenState {
  init,
  getChatsLoading,
  getChatsSuccess,
  getChatsError,
}

@immutable
class HomeState {
  HomeScreenState? homeScreenState;
  List<ChatModel>? allChats;
  String? errorMassage;
  List<ChatModel>? myChats;
  List<ChatModel>? browserChats;
  UserModel? currentUser;

  HomeState(
      {this.homeScreenState,
      this.allChats,
      this.currentUser,
      this.errorMassage,
      this.browserChats,
      this.myChats});

  HomeState copyWith(
      {HomeScreenState? homeScreenState,
      List<ChatModel>? myChats,
      UserModel? currentUser,
      List<ChatModel>? browserChats,
      List<ChatModel>? allChats,
      String? errorMassage}) {
    return HomeState(
        errorMassage: errorMassage ?? this.errorMassage,
        browserChats: browserChats ?? this.browserChats,
        currentUser: currentUser ?? this.currentUser,
        myChats: myChats ?? this.browserChats,
        homeScreenState: homeScreenState ?? this.homeScreenState,
        allChats: allChats ?? this.allChats);
  }
}

final class HomeInitial extends HomeState {
  HomeInitial() : super(homeScreenState: HomeScreenState.init);
}
