import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/characters/playable_character.dart';

mixin CanJump on PlayableCharacter {

  int queuedJumps = 0;

  double get jumpForce => 260;
  int get maxJumps => 2;

  void jump() {
    if (queuedJumps < maxJumps) {
      queuedJumps++;
    }
  }

  // tutaj to się wykonuje podczas renderowania kadej klatki, dlatego ustawia od razu na 2 madeJumps
  void checkShouldJump(double dt) {
    if (queuedJumps <= 0)    {
      debugPrint('queued: $queuedJumps');
      return;
    }

    if (game.playSounds) {
      FlameAudio.play('jump.wav', volume: game.soundVolume);
    }
    velocity.y = -jumpForce;
    position.y += velocity.y * dt;
    queuedJumps--;
  }

  void resetJumps() {
    queuedJumps = 0;
  }
}