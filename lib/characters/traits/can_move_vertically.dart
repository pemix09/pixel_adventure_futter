import 'package:pixel_adventure/characters/playable_character.dart';

mixin CanMoveVertically on PlayableCharacter {

  final double _gravity = 9.8;
  final double _terminalVelocity = 300;
  bool _isOnGround = false;

  set _verticalSpeed(double newVerticalSpeed) => velocity.y = newVerticalSpeed;
  double get _verticalSpeed => velocity.y;
  bool get isFalling => velocity.y > 0;
  bool get isJumping => velocity.y < 0;
  bool get isIdle => velocity.y == 0;

  void bounce(double bounceHeight) {
    _verticalSpeed = -bounceHeight;
  }

  void resetVerticalMovement() {
    _verticalSpeed = 0;
  }

  void applyGravity(double dt) {
    _verticalSpeed += _gravity;
    _verticalSpeed = _verticalSpeed.clamp(-_terminalVelocity, _terminalVelocity);
    position.y += _verticalSpeed * dt;
  }

  void setPositionBelow(double blockY, double blockHeight, double hitBoxOffsetY) {
    velocity.y = 0;
    position.y = blockY + blockHeight - hitBoxOffsetY;
  }

  void setPositionAbove(double blockY, double hitBoxHeight, double hitBoxOffsetY) {
    velocity.y = 0;
    position.y = blockY - hitBoxHeight - hitBoxOffsetY;
    _isOnGround = true;
  }
}