import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: "Mask Dude");
  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(levelName: "level-01", player: player);
    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if (showJoystick) {
      addJoyStick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUB/Knob.png'))),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUB/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.direction = PlayerDirection.right;
        break;
      default:
        player.direction = PlayerDirection.none;
        break;
    }
  }
}
