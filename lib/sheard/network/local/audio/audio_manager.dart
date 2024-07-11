import 'package:audioplayers/audioplayers.dart';
import 'package:dartz/dartz.dart';

import '../../../errors/audio_player_errors.dart';

class AudioManager {
  static late AudioPlayer player;

  static initPlayer() {
    player = AudioPlayer();
  }

  static void playLocalSound(String path) async {
    await player.play(AssetSource(path));
  }

  static Future<void> playRemoteSound(String url) async {
    return await player.play(UrlSource(url));
  }

  static void stop() async {
    await player.stop();
  }

  static void disposePlayer() async {
    await player.dispose();
  }

  static Stream<Duration?> getPosition() {
    return player.onPositionChanged;
  }

  static PlayerState getCurrentStatus() {
    return player.state;
  }

  static Future<Either<Duration?, AudioPlayerErrors>> getDuration(
      String url) async {
    try {
      final AudioPlayer player = AudioPlayer();
      await player.setSourceUrl(url);
      final duration = await player.getDuration();
      return Left(duration);
    } catch (e) {
      return Right(AudioPlayerErrors(e.toString()));
    }
  }
}
