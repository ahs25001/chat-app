import 'package:chat_app/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/sheard/network/firebase/firebase_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_chat_state.dart';

class CreateChatCubit extends Cubit<CreateChatState> {
  CreateChatCubit() : super(CreateChatInitial());

  static CreateChatCubit get(context) => BlocProvider.of(context);
  TextEditingController chatNameController = TextEditingController();
  TextEditingController chatDescriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void createChat() async {
    emit(state.copyWith(
        chatScreenState: CreateChatScreenState.createChatLoading));
    try {
      UserModel? user = await FirebaseManager.getUserById(
          FirebaseAuth.instance.currentUser?.uid ?? "");
      FirebaseManager.addChat(ChatModel(
          users: [user],
          description: chatDescriptionController.text,
          title: chatNameController.text));
      emit(state.copyWith(
          chatScreenState: CreateChatScreenState.createChatSuccess));
    } catch (e) {
      emit(state.copyWith(
          chatScreenState: CreateChatScreenState.createChatError,
          errorMassage: e.toString()));
    }
  }
}
