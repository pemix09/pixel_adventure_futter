import 'dart:async';

import 'package:flame/components.dart';
import 'package:pixel_adventure/games/map_exploration.dart';
import 'package:pixel_adventure/main.dart';
import 'package:pixel_adventure/utils/collision_block.dart';

abstract class Level extends World with HasGameRef<MapExploration>, HasCollisionDetection {
  // collision blocks below has to be checked for collision every frame, not by
  // using collision detection, as they are crucial for setting right player position
  // thus collision detection from flame game engine cannot be used
  List<CollisionBlock> collisionBlocks = [];
  late CameraComponent cam;
}