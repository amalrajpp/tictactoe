// lib/app/modules/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import 'home_controller.dart';
import 'widgets/animated_background.dart';
import 'widgets/glass_altar.dart';
import 'widgets/intro_screen.dart';
import 'widgets/misc_widgets.dart';
import 'widgets/neumorphic_widgets.dart';
import 'widgets/player_widgets.dart';
import 'widgets/wave_container.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: Obx(
          () => Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPlayerHeader(),
                      _buildGameBoard(),
                      _buildGameInfoPanel(),
                    ],
                  ),
                ),
              ),
              if (controller.gameState.value == GameState.intro)
                IntroScreen(onStart: controller.startGame),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerHeader() {
    return Obx(() {
      if (controller.winner.value != null) {
        return VictoryHeader(winner: controller.winner.value!);
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayerPod(
            player: 'X',
            isActive: controller.currentPlayer.value == 'X',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'VS',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          PlayerPod(
            player: 'O',
            isActive: controller.currentPlayer.value == 'O',
          ),
        ],
      );
    });
  }

  Widget _buildGameBoard() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(-0.25),
      alignment: FractionalOffset.center,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: [
            const GlassAltar(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 9,
                itemBuilder: (context, index) => _buildCell(index),
              ),
            ),
            Obx(() {
              if (controller.winningLine.value != null) {
                return WinningLineOverlay(
                  winningLine: controller.winningLine.value!,
                  color: controller.winner.value == 'X'
                      ? CustomColors.player1Color
                      : CustomColors.player2Color,
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    return Obx(() {
      final hasMark = controller.marks[index] != '';
      final liquidOwner = controller.liquidOwner[index];
      final color = liquidOwner == 'X'
          ? CustomColors.player1Color
          : CustomColors.player2Color;
      final CurvedAnimation fillAnimation = CurvedAnimation(
        parent: controller.liquidControllers[index],
        curve: Curves.easeOut,
      );
      final isEmpowered = index == controller.empoweredTileIndex.value;

      return GestureDetector(
        onTap: () => controller.handleTap(index),
        child: NeumorphicContainer(
          pressed: hasMark,
          borderRadius: BorderRadius.circular(15),
          padding: EdgeInsets.zero,
          color: CustomColors.container.withOpacity(0.2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                if (isEmpowered && !hasMark) const EmpoweredTileAura(),
                if (liquidOwner != '')
                  AnimatedBuilder(
                    animation: fillAnimation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        heightFactor: fillAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - fillAnimation.value) * 20),
                          child: WaveContainer(
                            size: const Size(200, 200),
                            offset: Offset.zero,
                            color: color.withOpacity(0.8),
                            fillController: controller.liquidControllers[index],
                            particleType: liquidOwner == 'X'
                                ? ParticleType.fire
                                : ParticleType.water,
                          ),
                        ),
                      );
                    },
                  ),
                if (controller.isDraw.value)
                  ParticleBurst(
                    controller: controller.burstControllers[index],
                    color: const Color(0xffa29bfe),
                  )
                else
                  ParticleBurst(
                    controller: controller.burstControllers[index],
                    color: color,
                  ),
                Center(
                  child: AnimatedBuilder(
                    animation: controller.runeControllers[index],
                    builder: (context, child) => CustomPaint(
                      painter: RunePainter(
                        mark: controller.marks[index],
                        progress: controller.runeControllers[index].value,
                      ),
                      size: const Size(50, 50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildGameInfoPanel() {
    return Column(
      children: [
        Obx(() {
          String statusText;
          if (controller.winner.value != null) {
            statusText =
                'Player ${controller.winner.value == 'X' ? 1 : 2} is Victorious!';
          } else if (controller.isDraw.value) {
            statusText = "It's a Draw!";
          } else {
            statusText =
                "Player ${controller.currentPlayer.value == 'X' ? 1 : 2}'s Turn";
          }
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Text(
              statusText,
              key: ValueKey<String>(statusText),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(blurRadius: 5.0, color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => NeumorphicIconButton(
                onTap: controller.toggleSound,
                icon: Icon(
                  controller.isSoundOn.value
                      ? Icons.volume_up
                      : Icons.volume_off,
                  color: Colors.white.withOpacity(0.8),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 20),
            NeumorphicIconButton(
              onTap: () => controller.resetGame(),
              icon: Icon(
                Icons.refresh,
                color: Colors.white.withOpacity(0.8),
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            NeumorphicIconButton(
              onTap: controller.openSettings,
              icon: Icon(
                Icons.settings,
                color: Colors.white.withOpacity(0.8),
                size: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
