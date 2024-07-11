import 'dart:io';

import 'package:chat_app/sheard/network/local/audio/audio_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../../generated/assets.dart';

class RecordManager {
  static late AudioRecorder record;

  static initRecord() {
    record = AudioRecorder();
  }

  static Future<String> getFilePath() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path = appDocumentsDir.path;
    return "$path/record${DateTime.now().microsecondsSinceEpoch}.mp3";
  }

  static void startRecord() async {
    try {
      if (await record.hasPermission()) {
        String filePath = await getFilePath();
        AudioManager.playLocalSound(Assets.voicesNotification);
        AudioManager.player.onPlayerComplete.listen(
          (event) async {},
        );
        await Future.delayed(const Duration(milliseconds: 500));
        await record.start(const RecordConfig(), path: filePath);
      }
    } catch (e) {
      print(
          "======================================================= ${e.toString()}");
    }
  }

  static Future<String?> stopRecord() async {
    AudioManager.playLocalSound(Assets.voicesNotification);
    AudioManager.player.onPlayerComplete.listen(
      (event) async {},
    );
    return await record.stop();
  }

  static void disposeRecord() {
    record.dispose();
  }

  static void cancelRecord() {
    record.cancel();
  }
}
