import 'package:pixel_adventure/characters/character.dart';

mixin CanMoveHorizontally on Character {
  double moveSpeed = 100;

  double get _horizontalMove => velocity.x;
  set horizontalMove(double newHorizontalSpeed) => velocity.x = newHorizontalSpeed;
  bool get isRunning => _horizontalMove != 0;
  bool get isGoingRight => _horizontalMove > 0;
  bool get isGoingLeft => _horizontalMove < 0;


  void moveRight() {
    horizontalMove = moveSpeed;
  }

  void moveLeft() {
    horizontalMove = -moveSpeed;
  }

  void resetHorizontalMove() {
    horizontalMove = 0;
  }

  void checkHorizontalMove(double dt) {
    position.x += _horizontalMove * dt;
  }

  void setPositionOnTheRight(double blockX, double hitBoxOffsetX, double hitBoxWidth) {
    resetHorizontalMove();
    position.x = blockX - hitBoxOffsetX - hitBoxWidth;
  }

  void setPositionOnTheLeft(double blockX, double blockWidth, double hitBoxOffsetX, double hitBoxWidth) {
    resetHorizontalMove();
    position.x = blockX + blockWidth + hitBoxWidth + hitBoxOffsetX;
  }
}