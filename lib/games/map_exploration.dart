import 'dart:async';
import 'dart:io';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/buttons/jump_button.dart';
import 'package:pixel_adventure/characters/player.dart';
import 'package:pixel_adventure/games/base_game.dart';
import 'package:pixel_adventure/levels/map_level.dart';
import 'package:pixel_adventure/main.dart';

class MapExploration extends BaseGame with DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  final Player player;
  JoystickComponent? joystick;
  MapLevel world;
  bool showControls = Platform.isIOS || Platform.isAndroid;
  bool playSounds = true;
  double soundVolume = 1.0;
  int currentLevelIndex = 0;

  MapExploration({required this.world, required this.player});

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();
    add(world);

    if (showControls) {
      add(JumpButton());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      _updateJoystick();
    }
    super.update(dt);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (showControls && event.canvasPosition.x < canvasSize.x / 2 && !children.contains(joystick)) {
      joystick = _buildJoystick(event.canvasPosition);
      joystick!.onDragStart(event);
      add(joystick!);
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    joystick?.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (joystick != null && children.contains(joystick)) {
      joystick!.onDragEnd(event);
      remove(joystick!);
      joystick = null;
    }
    super.onDragEnd(event);
  }

  @override
  void onDragCancel(DragCancelEvent event){
    if (joystick != null && children.contains(joystick)) {
      joystick!.onDragCancel(event);
      remove(joystick!);
      joystick = null;
    }
    super.onDragCancel(event);
  }

  @override
  FutureOr<void> onMount() async {
    super.onMount();
    overlays.add(pauseButton);
  }

  JoystickComponent _buildJoystick(Vector2 position) {
    return JoystickComponent(
      position: position,
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
    );
  }

  void _updateJoystick() {
    if (joystick == null || !children.contains(joystick)) {
      player.resetHorizontalMove();
      return;
    }

    switch (joystick!.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.moveLeft();
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.moveRight();
        break;
      default:
        player.resetHorizontalMove();
        break;
    }
  }
}
