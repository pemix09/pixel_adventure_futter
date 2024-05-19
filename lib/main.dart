import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixel_adventure/dialogs/game_pause_dialog.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

const String pauseButton = 'pause_button_key';
const String pauseDialog = 'pause_dialog_key';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: flutterNesTheme(),
      home: GameWidget<PixelAdventure>(
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
      ),
    ),
  );
}
