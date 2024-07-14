import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/sheard/errors/firebase_errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../models/massage_model.dart';

class FirebaseManager {
  ///chat operations
  static CollectionReference<ChatModel> getChatCollection() {
    return FirebaseFirestore.instance
        .collection("Chats")
        .withConverter<ChatModel>(
          fromFirestore: (snapshot, options) =>
              ChatModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static Either<void, FirebaseErrors> addChat(ChatModel chat) {
    try {
      CollectionReference<ChatModel> collection = getChatCollection();
      DocumentReference<ChatModel> docRef = collection.doc();
      chat.id = docRef.id;
      docRef.set(chat);
      return Left(() {});
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  static Either<Stream<QuerySnapshot<ChatModel>>, FirebaseErrors> getChats() {
    try {
      return Left(getChatCollection().snapshots());
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  static Future<Either<void, FirebaseErrors>> updateChat(
      ChatModel? newChatModel) async {
    try {
      await getChatCollection()
          .doc(newChatModel?.id)
          .update(newChatModel?.toJson() ?? {});
      return Left(() {});
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  static Future<Either<QuerySnapshot<ChatModel>, FirebaseErrors>> searchInChats(
      String name) async {
    try {
      var result = await getChatCollection()
          .where('title', isGreaterThanOrEqualTo: name)
          .where('title', isLessThanOrEqualTo: '$name\uf7ff')
          .get();
      return Left(result);
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  ///massages operations
  static CollectionReference<MassageModel> getMassageCollection() {
    return FirebaseFirestore.instance
        .collection("Massage")
        .withConverter<MassageModel>(
          fromFirestore: (snapshot, options) =>
              MassageModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static Either<Stream<QuerySnapshot<MassageModel>>, FirebaseErrors>
      getMassages(String chatId) {
    try {
      return Left(getMassageCollection()
          .orderBy("sendTime", descending: true)
          .where("chatId", isEqualTo: chatId)
          .snapshots());
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  static Either<void, FirebaseErrors> sendMassage(MassageModel massage) {
    try {
      DocumentReference<MassageModel> docRef = getMassageCollection().doc();
      massage.id = docRef.id;
      docRef.set(massage);
      return Left(() {});
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  static Future<Either<String, FirebaseErrors>> uploadFileOnFirebase(
      String path, File file) async {
    try {
      UploadTask task =
          FirebaseStorage.instance.ref().child(path).putFile(file);
      var snapShot = await task.whenComplete(
        () {},
      );
      return Left(await snapShot.ref.getDownloadURL());
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  ///user operations
  static Future<Either<void, FirebaseErrors>> createAccount(
      String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      credential.user?.sendEmailVerification();
      return Left(() {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Right(FirebaseErrors('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return Right(
            FirebaseErrors('The account already exists for that email.'));
      }
      return Right(FirebaseErrors(e.toString()));
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  static Future<Either<void, FirebaseErrors>> login(
      String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      if (!(credential.user!.emailVerified)) {
        return Right(FirebaseErrors('Pleas verify your email.'));
      }
      return Left(() {});
    } on FirebaseAuthException catch (_) {
      return Right(FirebaseErrors('Wrong password or email.'));
    }
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

  static Future<Either<UserModel?, FirebaseErrors>> getUserById(
      String userId) async {
    try {
      DocumentSnapshot<UserModel> userSnapshot =
          await getUserCollection().doc(userId).get();
      return Left(userSnapshot.data());
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  static Either<void, FirebaseErrors> addUser(UserModel user) {
    try {
      CollectionReference<UserModel> collection = getUserCollection();
      DocumentReference<UserModel> docRef = collection.doc(user.id);
      docRef.set(user);
      return Left(() {});
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }

  static Future<Either<void, FirebaseErrors>> signOut() async {
    try {
      return Left(await FirebaseAuth.instance.signOut());
    } catch (e) {
      return Right(FirebaseErrors(e.toString()));
    }
  }
}
