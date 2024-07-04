import 'package:chat_app/sheard/errors/firebase_errors.dart';
import 'package:chat_app/sheard/network/local/firebase/firebase_manager.dart';
import 'package:chat_app/sheard/network/local/shared_preferences/shared_preferences_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  void changeLocal(String code) {
    SharedPreferencesManager.saveString("local", code);
    emit(state.copyWith(localCode: code));
  }

  void getCurrentLocal() {
    String? code = SharedPreferencesManager.getString("local");
    emit(state.copyWith(
      localCode: code ?? "en",
    ));
  }

  void signOut() async {
    emit(state.copyWith(appStatus: AppStatus.signOutLoading));

    var response = await FirebaseManager.signOut();
    response.fold(
      (l) {
        emit(state.copyWith(appStatus: AppStatus.signOutSuccess));
      },
      (r) {
        emit(state.copyWith(appStatus: AppStatus.signOutError));
      },
    );
  }
}
