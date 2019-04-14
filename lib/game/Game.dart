
import 'dart:ui';
import 'package:flutter/material.dart' show AlwaysStoppedAnimation, Center, Colors, Container, RotationTransition, Text, TextPainter, Transform;
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/painting/text_painter.dart';
import 'package:dune_run/game/Horizon/horizon.dart';
import 'package:dune_run/game/collision/collision_utils.dart';
import 'package:dune_run/game/game_config.dart';
import 'package:dune_run/game/game_over/game_over.dart';
import 'package:dune_run/game/camel_r/config.dart';
import 'package:dune_run/game/camel_r/camel_r.dart';

enum CamelRGameStatus { playing, waiting, gameOver }


class CamelRGame extends BaseGame {
  
  CamelR camelR;
  Horizon horizon;
  GameOverPanel gameOverPanel;
  CamelRGameStatus status = CamelRGameStatus.waiting;

  double currentSpeed = GameConfig.speed;
  double timePlaying = 0.0;
  

  CamelRGame({Image spriteImage}) {
    camelR = new CamelR(spriteImage);
    horizon = new Horizon(spriteImage);
    gameOverPanel = new GameOverPanel(spriteImage);

    this..add(horizon)..add(camelR)..add(gameOverPanel);
  }



  void onTap() {
    
    if (gameOver) {
      restart();
      return;
    }
    camelR.startJump(this.currentSpeed);
  }

  @override
  void update(double t) {

    camelR.update(t);
    horizon.updateWithSpeed(0.0, this.currentSpeed);

    if (gameOver) return;

    if (camelR.playingIntro && camelR.x >= CamelRConfig.startXPos) {
      startGame();
    } else if (camelR.playingIntro) {
      horizon.updateWithSpeed(0.0, this.currentSpeed);
    }

    if (this.playing) {
      timePlaying += t;
      horizon.updateWithSpeed(t, this.currentSpeed);

      var obstacles = horizon.horizonLine.obstacleManager.components;
      bool collision =
          obstacles.length > 0 && checkForCollision(obstacles.first, camelR);
      if (!collision) {
        if (this.currentSpeed < GameConfig.maxSpeed) {
          this.currentSpeed += GameConfig.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }

  void startGame() {
     Flame.util.enableEvents();
     Flame.audio.loop('music.mp3');
    camelR.status = CamelRStatus.running;
    status = CamelRGameStatus.playing;
    camelR.hasPlayedIntro = true;
   
  }

  bool get playing => status == CamelRGameStatus.playing;
  bool get gameOver => status == CamelRGameStatus.gameOver;
  void doGameOver() {
    this.gameOverPanel.visible = true;
    stop();
    camelR.status = CamelRStatus.crashed;
  }

  void stop() {
    this.status = CamelRGameStatus.gameOver;
    
  }

  void restart() {
    status = CamelRGameStatus.playing;
    camelR.reset();
    horizon.reset();
    currentSpeed = GameConfig.speed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
  }
  
  
  
  
  
}
