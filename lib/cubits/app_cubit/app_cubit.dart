import 'package:chat_app/sheard/network/local/shared_preferences/shared_preferences_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  void changeLocal(String code) {
    SharedPreferencesManager.saveString("local", code);
    emit(state.copyWith(
        appStatus: (code == "ar") ? AppStatus.arLanguage : AppStatus.enLanguage,
        localCode: code));
  }

  void getCurrentLocal() {
    String? code = SharedPreferencesManager.getString("local");
    emit(state.copyWith(
        localCode: code ?? "en",
        appStatus:
            (code == "ar") ? AppStatus.arLanguage : AppStatus.enLanguage));
  }
}
