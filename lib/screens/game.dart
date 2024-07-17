import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/characters/player.dart';
import 'package:pixel_adventure/dialogs/game_pause_dialog.dart';
import 'package:pixel_adventure/levels/map_level.dart';
import 'package:pixel_adventure/main.dart';
import 'package:pixel_adventure/games/map_exploration.dart';

class GameScreen extends StatelessWidget {
  final String level;

  const GameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return GameWidget<MapExploration>(
      game: MapExploration(
        player: Player(character: 'Mask Dude'),
        world: MapLevel(
          levelName: level,
        ),
      ),
      overlayBuilderMap: {
        pauseButton: (context, game) {
          return Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              onPressed: () {
                game.pauseEngine();
                game.overlays.add(pauseDialog);
                game.overlays.remove(pauseButton);
              },
              icon: const Icon(
                Icons.pause,
                size: 80,
              ),
            ),
          );
        },
        pauseDialog: (context, game) {
          return GamePauseDialog(
            onResume: () {
              game.overlays.remove(pauseDialog);
              game.overlays.add(pauseButton);
              game.resumeEngine();
            },
          );
        }
      },
    );
  }
}
