import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/characters/playable_character.dart';

mixin CanJump on PlayableCharacter {
  final double jumpForce = 260;
  int get maxJumps => 2;
  int queuedJumps = 0;
  int madeJumps = 0;

  void jump() {
    if (queuedJumps < maxJumps) {
      queuedJumps++;
    }
  }

  void checkShouldJump(double dt) {
    if (queuedJumps <= 0 || madeJumps == maxJumps) {
      return;
    }

    if (game.playSounds) {
      FlameAudio.play('jump.wav', volume: game.soundVolume);
    }
    velocity.y = -jumpForce;
    position.y += velocity.y * dt;
    madeJumps++;
  }

  void resetJumps() {
    queuedJumps = 0;
    madeJumps = 0;
  }
}