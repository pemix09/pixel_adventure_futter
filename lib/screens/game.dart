import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/characters/player.dart';
import 'package:pixel_adventure/dialogs/game_pause_dialog.dart';
import 'package:pixel_adventure/levels/level.dart';
import 'package:pixel_adventure/main.dart';
import 'package:pixel_adventure/games/pixel_adventure.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget<PixelAdventure>(
      game: PixelAdventure(
        world: Level(
          levelName: 'Level-01',
        ),
      ),
      overlayBuilderMap: {
        pauseButton: (context, game) {
          return Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              onPressed: () {
                if (game.paused) {
                  game.resumeEngine();
                  game.overlays.remove(pauseDialog);
                } else {
                  game.pauseEngine();
                  game.overlays.add(pauseDialog);
                }
              },
              icon: Icon(
                game.paused ? Icons.play_arrow : Icons.pause,
                size: 80,
              ),
            ),
          );
        },
        pauseDialog: (context, game) {
          return GamePauseDialog(
            onResume: () {
              game.overlays.remove(pauseDialog);
              game.resumeEngine();
            },
          );
        }
      },
    );
  }
}
