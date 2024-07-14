import 'package:chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../sheard/errors/firebase_errors.dart';
import '../../sheard/network/local/firebase/firebase_manager.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(BuildContext context) => BlocProvider.of(context);
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  void changePasswordVisibility() {
    emit(state.copyWith(
        signUpScreenState: SignUpScreenState.init,
        isPasswordVisible: !(state.isPasswordVisible ?? false)));
  }

  void signUp() async {
    emit(state.copyWith(
        signUpScreenState: SignUpScreenState.accountCreatedLoading));
    var response = await FirebaseManager.createAccount(
        emailController.text, passwordController.text);
    response.fold(
      (l) {
        emit(state.copyWith(
            signUpScreenState: SignUpScreenState.accountCreatedSuccess));
      },
      (r) {
        emit(state.copyWith(
            signUpScreenState: SignUpScreenState.accountCreatedError,
            errorMassage: r.massage));
      },
    );
  }

  void addUser() {
    emit(state.copyWith(signUpScreenState: SignUpScreenState.addUserLoading));
    var response = FirebaseManager.addUser(UserModel(
        name: nameController.text,
        email: emailController.text,
        id: FirebaseAuth.instance.currentUser?.uid));
    response.fold(
      (l) {
        emit(state.copyWith(
            signUpScreenState: SignUpScreenState.addUserSuccess));
      },
      (r) {
        emit(state.copyWith(
            signUpScreenState: SignUpScreenState.addUserError,
            errorMassage: r.massage));
      },
    );
  }
}
