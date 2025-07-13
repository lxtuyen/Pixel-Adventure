import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

void main() {
  PixelAdventure game = PixelAdventure();
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen;
  Flame.device.setLandscape;

  runApp(GameWidget(game: kDebugMode? PixelAdventure() : game));
}