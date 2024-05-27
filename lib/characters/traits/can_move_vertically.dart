import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/characters/playable_character.dart';

mixin CanMoveVertically on PlayableCharacter {

  // final double _gravity = 9.8;
  // final double _terminalVelocity = 300;
  //
  // set _verticalSpeed(double newVerticalSpeed) => velocity.y = newVerticalSpeed;
  bool get isFalling => velocity.y > 0;
  bool get isJumping => velocity.y < 0;
  bool get isIdle => velocity.y == 0;
  //
  // void bounce(double bounceHeight) {
  //   _verticalSpeed = -bounceHeight;
  // }
  //
  // void updateVerticalMove(double dt) {
  //   _applyJump(dt);
  //   _applyGravity(dt);
  // }
  //
  // void resetVerticalMovement() {
  //   _verticalSpeed = 0;
  // }
  //
  // void _applyGravity(double dt) {
  //   _verticalSpeed += _gravity;
  //   _verticalSpeed = _verticalSpeed.clamp(-jumpForce, _terminalVelocity);
  //   position.y += _verticalSpeed * dt;
  // }

  void setPositionBelow(double blockY, double blockHeight, double hitBoxOffsetY) {
    velocity.y = 0;
    position.y = blockY + blockHeight - hitBoxOffsetY;
  }

  void setPositionAbove(double blockY, double hitBoxHeight, double hitBoxOffsetY) {
    velocity.y = 0;
    position.y = blockY - hitBoxHeight - hitBoxOffsetY;
  }
}