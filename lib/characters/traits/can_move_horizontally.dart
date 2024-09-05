import 'package:pixel_adventure/characters/character.dart';
import 'package:pixel_adventure/utils/collision_block.dart';

mixin CanMoveHorizontally on Character {
  double moveSpeed = 100;
  bool _isBlockedOnRight = false;
  bool _isBlockedOnLeft = false;
  CollisionBlock? _collidableFromLeft = null;
  CollisionBlock? _collidableFromRight = null;

  CollisionBlock? get collidableFromLeft => _collidableFromLeft;
  set collidableFromLeft(CollisionBlock? newCollidableFromLeft) => _collidableFromLeft = newCollidableFromLeft;
  CollisionBlock? get collidableFromRight => _collidableFromRight;
  set collidableFromRight(CollisionBlock? newCollidableFromRight) => _collidableFromRight = newCollidableFromRight;
  bool get isBlockedOnRight => _isBlockedOnRight;
  set isBlockedOnRight(bool newIsBlockedOnRight) => _isBlockedOnRight = newIsBlockedOnRight;
  bool get isBlockedOnLeft => _isBlockedOnLeft;
  set isBlockedOnLeft(bool newIsBlockedOnLeft) => _isBlockedOnLeft = newIsBlockedOnLeft;
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

  void updateHorizontalPosition(double dt) {
    if (_horizontalMove < 0 && !isBlockedOnLeft || _horizontalMove > 0 && !isBlockedOnRight) {
      position.x += _horizontalMove * dt;
    }
  }
}