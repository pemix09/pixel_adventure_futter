import 'package:flame/game.dart';
import 'package:pixel_adventure/characters/character.dart';

mixin CanMove on Character {
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  void moveRight() {
    horizontalMovement = 1;
  }

  void moveLeft() {
    horizontalMovement = -1;
  }

  void resetHorizontalMove() {
    horizontalMovement = 0;
  }

  void checkHorizontalMove(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
}