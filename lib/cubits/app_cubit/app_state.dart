part of 'app_cubit.dart';

enum AppStatus {
  init,
  signOutLoading,
  signOutSuccess,
  signOutError,
}

@immutable
class AppState {
  AppStatus? appStatus;
  String? localCode;

  AppState({this.appStatus, this.localCode});

  copyWith({AppStatus? appStatus, String? localCode}) {
    return AppState(
        appStatus: appStatus ?? this.appStatus,
        localCode: localCode ?? this.localCode);
  }
}

class AppInitial extends AppState {
  AppInitial() : super(appStatus: AppStatus.init);
}
