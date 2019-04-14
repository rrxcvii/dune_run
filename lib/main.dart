import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dune_run/game/game.dart';

void main() async {
  Flame.audio.disableLog();
  List<ui.Image> image = await Flame.images.loadAll(["sprite.png"]);
  CamelRGame camelRGame = CamelRGame(spriteImage: image[0]);
  runApp(MaterialApp(
    title: 'CamelRGame',
    home: Scaffold(     
      body: GameWrapper(camelRGame),  
    ),
  ));
  Flame.util.addGestureRecognizer(new TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) => camelRGame.onTap());

  SystemChrome.setEnabledSystemUIOverlays([]);
}

class GameWrapper extends StatelessWidget {
  final CamelRGame camelRGame;
  GameWrapper(this.camelRGame);

  @override
  Widget build(BuildContext context) {
    
    return camelRGame.widget;
  }

   
}


