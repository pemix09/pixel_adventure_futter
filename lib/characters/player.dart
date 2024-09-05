import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/characters/playable_character.dart';
import 'package:pixel_adventure/characters/traits/can_jump.dart';
import 'package:pixel_adventure/characters/traits/can_move_vertically.dart';
import 'package:pixel_adventure/characters/traits/can_move_horizontally.dart';
import 'package:pixel_adventure/collectables/checkpoint.dart';
import 'package:pixel_adventure/characters/chicken.dart';
import 'package:pixel_adventure/collectables/fruit.dart';
import 'package:pixel_adventure/obstacles/saw.dart';
import 'package:pixel_adventure/utils/collision_block.dart';
import 'package:pixel_adventure/utils/custom_hitbox.dart';
import 'package:pixel_adventure/utils/utils.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  hit,
  appearing,
  disappearing
}

class Player extends PlayableCharacter
    with CanJump, CanMoveHorizontally, CanMoveVertically {
  String character;

  Player({
    position,
    this.character = 'Ninja Frog',
  }) : super(position: position);

  factory Player.byName(String playerName) => Player(character: playerName);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  Vector2 startingPosition = Vector2.zero();
  bool gotHit = false;
  bool reachedCheckpoint = false;
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;

    startingPosition = Vector2(position.x, position.y);

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // todo check whether it's necessary to use accumulatedTIme and fixedDeltaTime
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        updateHorizontalPosition(dt);
        checkShouldJump(dt);
        applyGravity(fixedDeltaTime);
        updateVerticalPosition(dt);
      }

      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    resetHorizontalMove();
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      resetHorizontalMove();
    } else if (isLeftKeyPressed) {
      moveLeft();
    } else if (isRightKeyPressed) {
      moveRight();
    }

    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      jump();
      isBlockedOnBottom = false;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollisionBlock) {
      double playerRealX = isFlippedHorizontally ? x - width : x;
      if ((isFalling || isIdle) && collidableFromBottom == null &&
          !identical(other, collidableFromRight) && !identical(other, collidableFromLeft)) {
        print('Hit from the bottom, other y: ${other.y}, y: $y');
        resetJumps();
        resetVerticalMovement();
        collidableFromBottom = other;
        isBlockedOnBottom = true;
      } else if (isJumping && collidableFromTop == null &&
          !identical(other, collidableFromRight) && !identical(other, collidableFromLeft)) {
        print('Hit from the top, other y: ${other.y}, y: $y');
        resetVerticalMovement();
        collidableFromTop = other;
        isBlockedOnTop = true;
      } else if (isGoingRight && collidableFromRight == null &&
          !identical(other, collidableFromTop) && !identical(other, collidableFromBottom)) {
        print('Hit from the right, other x: ${other.x}, x: $x, width: $width');
        collidableFromRight = other;
        isBlockedOnRight = true;
      } else if (isGoingLeft && collidableFromLeft == null &&
          !identical(other, collidableFromTop) && !identical(other, collidableFromBottom)) {
        print('Hit from the left, other x: ${other.x}, x: $x');
        collidableFromLeft = other;
        isBlockedOnLeft = true;
      }
    }

    if (!reachedCheckpoint) {
      if (other is Fruit) other.collidedWithPlayer();
      if (other is Saw) _respawn();
      if (other is Chicken) other.collidedWithPlayer();
      if (other is Checkpoint) _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is CollisionBlock) {
      if (identical(other, collidableFromBottom)) {
        collidableFromBottom = null;
        isBlockedOnBottom = false;
      } else if (identical(other, collidableFromTop)) {
        collidableFromTop = null;
        isBlockedOnTop = false;
      } else if (identical(other, collidableFromLeft)) {
        collidableFromLeft = null;
        isBlockedOnLeft = false;
      } else if (identical(other, collidableFromRight)) {
        collidableFromRight = null;
        isBlockedOnRight = false;
      }
    }
    super.onCollisionEnd(other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Desappearing', 7);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if ((velocity.x < 0 && scale.x > 0) || (velocity.x > 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (isRunning) playerState = PlayerState.running;

    // check if Falling set to falling
    if (isFalling) playerState = PlayerState.falling;

    // Checks if jumping, set to jumping
    if (isJumping) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _respawn() async {
    if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    const canMoveDuration = Duration(milliseconds: 400);
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    resetVelocity();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  void _reachedCheckpoint() async {
    reachedCheckpoint = true;
    if (game.playSounds) {
      FlameAudio.play('disappear.wav', volume: game.soundVolume);
    }
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640);
  }

  void collidedwithEnemy() {
    _respawn();
  }
}
