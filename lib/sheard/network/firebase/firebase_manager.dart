import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/sheard/errors/firebase_errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/massage_model.dart';

class FirebaseManager {
  static CollectionReference<ChatModel> getChatCollection() {
    return FirebaseFirestore.instance
        .collection("Chats")
        .withConverter<ChatModel>(
          fromFirestore: (snapshot, options) =>
              ChatModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance
        .collection("Users")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static CollectionReference<MassageModel> getMassageCollection() {
    return FirebaseFirestore.instance
        .collection("Massage")
        .withConverter<MassageModel>(
          fromFirestore: (snapshot, options) =>
              MassageModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static void addChat(ChatModel chat) {
    CollectionReference<ChatModel> collection = getChatCollection();
    DocumentReference<ChatModel> docRef = collection.doc();
    chat.id = docRef.id;
    docRef.set(chat);
  }

  static Stream<QuerySnapshot<ChatModel>> getChats() {
    return getChatCollection().snapshots();
  }

  static void addUser(UserModel user) {
    CollectionReference<UserModel> collection = getUserCollection();
    DocumentReference<UserModel> docRef = collection.doc(user.id);
    docRef.set(user);
  }

  static Future<UserModel?> getUserById(String userId) async {
    DocumentSnapshot<UserModel> userSnapshot =
        await getUserCollection().doc(userId).get();
    return userSnapshot.data();
  }

  static Stream<QuerySnapshot<MassageModel>> getMassages(String chatId) {
    return getMassageCollection()
        .orderBy("sendTime", descending: true)
        .where("chatId", isEqualTo: chatId)
        .snapshots();
  }

  static void sendMassage(MassageModel massage) {
    DocumentReference<MassageModel> docRef = getMassageCollection().doc();
    massage.id = docRef.id;
    docRef.set(massage);
  }

  static void updateChat(ChatModel? newChatModel) async {

    await getChatCollection()
        .doc(newChatModel?.id)
        .update(newChatModel?.toJson() ?? {});
  }

  static Future<FirebaseErrors?> createAccount(
      String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      credential.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return FirebaseErrors('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return FirebaseErrors('The account already exists for that email.');
      }
    } catch (e) {
      return FirebaseErrors(e.toString());
    }
    return null;
  }

  static Future<FirebaseErrors?> login(
      String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      if (!(credential.user!.emailVerified)) {
        return FirebaseErrors('Pleas verify your email.');
      }
    } on FirebaseAuthException catch (e) {
      return FirebaseErrors('Wrong password or email.');
    }
    return null;
  }
}
