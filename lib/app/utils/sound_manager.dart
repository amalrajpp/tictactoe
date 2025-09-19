// lib/app/utils/sound_manager.dart
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

/// A dedicated class to manage all sound-related logic.
class SoundManager {
  // We will use a single player instance throughout.
  final AudioPlayer _player = AudioPlayer();
  bool _isSoundOn = true;

  SoundManager() {
    // Configure the player once for low-latency playback.
    _player.setPlayerMode(PlayerMode.lowLatency);
    // Use RELEASE mode, which is better for short sounds than STOP.
    _player.setReleaseMode(ReleaseMode.release);
  }

  /// Toggles the sound on or off.
  void setSound(bool isOn) {
    _isSoundOn = isOn;
  }

  /// A helper method to play a sound effect from the assets.
  Future<void> _playSound(String soundAsset) async {
    if (!_isSoundOn) return;
    try {
      // CRITICAL FIX: Stop any previous playback before starting a new one.
      // This resets the player's internal state and prevents it from getting "stuck".
      await _player.stop();
      await _player.play(AssetSource(soundAsset));
    } catch (e) {
      // Optional: a log to see if any errors are happening.
      print("Error playing sound: $e");
    }
  }

  void playTap() => _playSound('sounds/tap.wav');
  void playWin() => _playSound('sounds/win.wav');
  void playDraw() => _playSound('sounds/draw.wav');
  void playReset() => _playSound('sounds/reset.wav');
  void playStart() => _playSound('sounds/start.wav');

  /// Releases the resources used by the audio player.
  void dispose() {
    _player.dispose();
  }
}
