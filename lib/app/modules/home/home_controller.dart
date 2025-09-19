// lib/app/modules/home/home_controller.dart
import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/sound_manager.dart';

enum GameState { intro, playing, gameOver }

// Add GetSingleTickerProviderStateMixin for animation controllers
class HomeController extends GetxController with GetTickerProviderStateMixin {
  // SFX
  late final SoundManager soundManager;
  final isSoundOn = true.obs;

  // Game State
  final marks = List.filled(9, '').obs;
  final liquidOwner = List.filled(9, '').obs;
  late List<AnimationController> liquidControllers;
  late List<AnimationController> burstControllers;
  late List<AnimationController> runeControllers;
  Timer? winSpreadTimer;

  final currentPlayer = 'X'.obs;
  final winner = Rxn<String>(); // Rxn for nullable types
  final isDraw = false.obs;
  final gameState = GameState.intro.obs;

  // State for Empowered Tile and Winning Line mechanics
  final empoweredTileIndex = Rxn<int>();
  final winningLine = Rxn<List<int>>();

  @override
  void onInit() {
    super.onInit();
    soundManager = SoundManager();
    _initializeAnimationControllers();
    resetGame(isInitialLoad: true);
  }

  void _initializeAnimationControllers() {
    liquidControllers = List.generate(
      9,
      (i) => AnimationController(
        vsync:
            this, // 'this' works because of GetSingleTickerProviderStateMixin
        duration: const Duration(milliseconds: 1200),
      ),
    );
    burstControllers = List.generate(
      9,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    runeControllers = List.generate(
      9,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  void startGame() {
    soundManager.playStart();
    gameState.value = GameState.playing;
  }

  void toggleSound() {
    isSoundOn.value = !isSoundOn.value;
    soundManager.setSound(isSoundOn.value);
  }

  void openSettings() {
    print("Settings button tapped!");
  }

  void handleTap(int index) {
    if (marks[index] != '' ||
        winner.value != null ||
        gameState.value != GameState.playing)
      return;

    soundManager.playTap();

    marks[index] = currentPlayer.value;
    liquidOwner[index] = currentPlayer.value;
    burstControllers[index].forward(from: 0);
    liquidControllers[index].forward(from: 0);
    runeControllers[index].forward(from: 0);

    _checkWinner();
    if (winner.value == null) {
      currentPlayer.value = currentPlayer.value == 'X' ? 'O' : 'X';
      _checkDraw();
    }
  }

  List<int> _getNeighbors(int index) {
    const int numCols = 3;
    List<int> neighbors = [];
    if (index % numCols > 0) neighbors.add(index - 1);
    if (index % numCols < numCols - 1) neighbors.add(index + 1);
    if (index >= numCols) neighbors.add(index - numCols);
    if (index < marks.length - numCols) neighbors.add(index + numCols);
    return neighbors;
  }

  void _checkWinner() {
    const List<List<int>> winningLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6], // diagonals
    ];

    for (var line in winningLines) {
      String p1 = marks[line[0]];
      String p2 = marks[line[1]];
      String p3 = marks[line[2]];

      if (p1 != '' && p1 == p2 && p2 == p3) {
        soundManager.playWin();
        winner.value = p1;
        winningLine.value = line;
        gameState.value = GameState.gameOver;
        Future.delayed(const Duration(milliseconds: 1500), () {
          _startWinSpreadAnimation(winner.value!);
        });
        return;
      }
    }
  }

  void _startWinSpreadAnimation(String winner) {
    Queue<int> queue = Queue();
    Set<int> visited = {};

    for (int i = 0; i < marks.length; i++) {
      if (marks[i] == winner) {
        queue.add(i);
        visited.add(i);
      }
    }

    winSpreadTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (queue.isEmpty) {
        timer.cancel();
        return;
      }
      int currentSize = queue.length;
      for (int i = 0; i < currentSize; i++) {
        int currentIndex = queue.removeFirst();
        for (int neighborIndex in _getNeighbors(currentIndex)) {
          if (!visited.contains(neighborIndex)) {
            visited.add(neighborIndex);
            liquidOwner[neighborIndex] = winner;
            liquidControllers[neighborIndex].forward(from: 0);
            queue.add(neighborIndex);
          }
        }
      }
    });
  }

  void _checkDraw() {
    if (!marks.contains('') && winner.value == null) {
      soundManager.playDraw();
      isDraw.value = true;
      gameState.value = GameState.gameOver;
      Future.delayed(const Duration(milliseconds: 1000), _animateDraw);
    }
  }

  void _animateDraw() {
    for (int i = 0; i < liquidOwner.length; i++) {
      if (liquidOwner[i] != '') {
        liquidControllers[i].reverse();
      }
    }
  }

  void resetGame({bool isInitialLoad = false}) {
    if (!isInitialLoad) {
      soundManager.playReset();
    }
    winSpreadTimer?.cancel();

    for (int i = 0; i < liquidOwner.length; i++) {
      if (liquidOwner[i] != '') liquidControllers[i].reverse();
      burstControllers[i].reset();
      runeControllers[i].reset();
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      marks.value = List.filled(9, '');
      liquidOwner.value = List.filled(9, '');
      currentPlayer.value = 'X';
      winner.value = null;
      winningLine.value = null;
      isDraw.value = false;
      empoweredTileIndex.value = Random().nextInt(9);
      gameState.value = GameState.playing;
    });
  }

  @override
  void onClose() {
    soundManager.dispose();
    winSpreadTimer?.cancel();
    for (var controller in liquidControllers) controller.dispose();
    for (var controller in burstControllers) controller.dispose();
    for (var controller in runeControllers) controller.dispose();
    super.onClose();
  }
}
