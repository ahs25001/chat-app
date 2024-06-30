part of 'sign_up_cubit.dart';

enum SignUpScreenState {
  init,
  accountCreatedSuccess,
  accountCreatedError,
  accountCreatedLoading,
  addUserSuccess,
  addUserError,
  addUserLoading,
}

@immutable
class SignUpState {
  SignUpScreenState? signUpScreenState;
  bool? isPasswordVisible;
  String? errorMassage;

  SignUpState(
      {this.isPasswordVisible, this.signUpScreenState, this.errorMassage});

  SignUpState copyWith(
      {SignUpScreenState? signUpScreenState,
      bool? isPasswordVisible,
      String? errorMassage}) {
    return SignUpState(
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        errorMassage: errorMassage ?? this.errorMassage,
        signUpScreenState: signUpScreenState ?? this.signUpScreenState);
  }
}

final class SignUpInitial extends SignUpState {
  SignUpInitial() : super(signUpScreenState: SignUpScreenState.init);
}
