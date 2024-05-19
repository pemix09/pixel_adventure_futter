import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pixel_adventure/dialogs/game_pause_dialog.dart';
import 'package:pixel_adventure/main.dart';
import 'package:pixel_adventure/screens/pixel_adventure.dart';
import 'package:pixel_adventure/screens/menu.dart';

final router = GoRouter(
  initialLocation: '/game',
  routes: [
    GoRoute(
      path: '/menu',
      builder: (context, state) => Menu(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) {
        return GameWidget<PixelAdventure>(
          game: PixelAdventure(),
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
      },
    ),
  ],
);
