import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running, jumping, falling, hit }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String character;
  Player({position, required this.character}) : super(position: position);

  PlayerDirection direction = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;

  @override
  FutureOr<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if(isLeftKeyPressed && isRightKeyPressed){
      direction = PlayerDirection.none;
    } else if(isLeftKeyPressed){
      direction = PlayerDirection.left;
    } else if(isRightKeyPressed){
      direction = PlayerDirection.right;
    } else {
      direction = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
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

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (direction) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
