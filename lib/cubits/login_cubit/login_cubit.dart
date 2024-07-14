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
    var response = await FirebaseManager.login(
        emailController.text, passwordController.text);
    response.fold((l) {
      emit(state.copyWith(loginScreenState: LoginScreenState.loginSuccess));

    }, (r) {
      emit(state.copyWith(
          loginScreenState: LoginScreenState.loginError,
          massage: r.massage));
    },);
  }

  void reSendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }
}
