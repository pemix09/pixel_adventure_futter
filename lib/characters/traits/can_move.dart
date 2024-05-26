import 'package:flame/game.dart';
import 'package:pixel_adventure/characters/character.dart';

mixin CanMove on Character {
  double _horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  void moveRight() {
    _horizontalMovement = 1;
  }

  void moveLeft() {
    _horizontalMovement = -1;
  }

  void resetHorizontalMove() {
    _horizontalMovement = 0;
  }

  void checkHorizontalMove(double dt) {
    velocity.x = _horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
}