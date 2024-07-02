import 'package:bloc/bloc.dart';
import 'package:chat_app/sheard/errors/firebase_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../sheard/network/local/firebase/firebase_manager.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  void changePasswordVisibility() {
    emit(state.copyWith(
        loginScreenState: LoginScreenState.init,
        isPasswordVisible: !(state.isPasswordVisible ?? false)));
  }

  void login() async {
    emit(state.copyWith(loginScreenState: LoginScreenState.loginLoading));
    FirebaseErrors? response = await FirebaseManager.login(
        emailController.text, passwordController.text);
    if (response == null) {
      emit(state.copyWith(loginScreenState: LoginScreenState.loginSuccess));
    } else {
      emit(state.copyWith(
          loginScreenState: LoginScreenState.loginError,
          massage: response.massage));
    }
  }

  void reSendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }
}
