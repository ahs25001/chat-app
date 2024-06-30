part of 'login_cubit.dart';

enum LoginScreenState {
  init,
  loginLoading,
  loginError,
  loginSuccess
}

@immutable
class LoginState {
  LoginScreenState? loginScreenState;
  bool? isPasswordVisible;
  String? massage;

  LoginState({this.loginScreenState, this.isPasswordVisible, this.massage});

  copyWith(
      {LoginScreenState? loginScreenState,
      bool? isPasswordVisible,
      String? massage}) {
    return LoginState(
        massage: massage ?? this.massage,
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        loginScreenState: loginScreenState ?? this.loginScreenState);
  }
}

final class LoginInitial extends LoginState {
  LoginInitial() : super(loginScreenState: LoginScreenState.init);
}
