import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:dune_run/game/camel_r/config.dart';
import 'package:dune_run/game/custom/composed_component.dart';

enum CamelRStatus { crashed, ducking, jumping, running, waiting, intro }

class CamelR extends PositionComponent with ComposedComponent, Resizable {
  bool isIdle = true;

  CamelRStatus status = CamelRStatus.waiting;

  WaitingCamelR idleCamel;
  RunningCamelR runningCamel;
  JumpingCamelR jumpingCamelR;
  SurprisedCamelR surprisedCamelR;

  double jumpVelocity = 0.0;
  bool reachedMinHeight = false;
  int jumpCount = 0;
  bool hasPlayedIntro = false;

  CamelR(Image spriteImage)
      : runningCamel = RunningCamelR(spriteImage),
        idleCamel = WaitingCamelR(spriteImage),
        jumpingCamelR = JumpingCamelR(spriteImage),
        surprisedCamelR = SurprisedCamelR(spriteImage),
        super();

  PositionComponent get actualCamel {
    switch (status) {
      case CamelRStatus.waiting:
        return idleCamel;
      case CamelRStatus.jumping:
        return jumpingCamelR;

      case CamelRStatus.crashed:
        return surprisedCamelR;
      case CamelRStatus.intro:
      case CamelRStatus.running:
      default:
        return runningCamel;
    }
  }

  void startJump(double speed) {
    if (status == CamelRStatus.jumping || status == CamelRStatus.ducking) return;

    status = CamelRStatus.jumping;
    this.jumpVelocity = CamelRConfig.initialJumpVelocity - (speed / 10);
    this.reachedMinHeight = false;
  }

  @override
  void render(Canvas canvas) {
    this.actualCamel.render(canvas);
  }

  void reset() {
    y = groundYPos;
    jumpVelocity = 0.0;
    jumpCount = 0;
    status = CamelRStatus.running;
  }

  void update(double t) {
    if (status == CamelRStatus.jumping) {
      y += (jumpVelocity);
      this.jumpVelocity += CamelRConfig.gravity;
      if (this.y > this.groundYPos) {
        this.reset();
        this.jumpCount++;
      }
    } else {
      y = this.groundYPos;
    }

    // intro related
    if (jumpCount == 1 && !playingIntro && !hasPlayedIntro) {
      status = CamelRStatus.intro;
    }
    if (playingIntro && x < CamelRConfig.startXPos) {
      x += ((CamelRConfig.startXPos / CamelRConfig.introDuration) * t * 5000);
    }

    updateCoordinates(t);
  }

  void updateCoordinates(double t) {
    this.actualCamel.x = x;
    this.actualCamel.y = y;
    this.actualCamel.update(t);
  }

  double get groundYPos {
    if (size == null) return 0.0;
    return (size.height / 2) - CamelRConfig.height / 2;
  }

  bool get playingIntro => status == CamelRStatus.intro;

  bool get ducking => status == CamelRStatus.ducking;
}

class RunningCamelR extends AnimationComponent {
  RunningCamelR(Image spriteImage)
      : super(
            88.0,
            90.0,
            Animation.spriteList([
              Sprite.fromImage(
                spriteImage,
                width: CamelRConfig.width,
                height: CamelRConfig.height,
                y: 4.0,
                x: 1514.0,
              ),
              Sprite.fromImage(
                spriteImage,
                width: CamelRConfig.width,
                height: CamelRConfig.height,
                y: 4.0,
                x: 1602.0,
              ),
            ], stepTime: 0.2, loop: true));
}

class WaitingCamelR extends SpriteComponent {
  WaitingCamelR(Image spriteImage)
      : super.fromSprite(
            CamelRConfig.width,
            CamelRConfig.height,
            Sprite.fromImage(spriteImage,
                width: CamelRConfig.width,
                height: CamelRConfig.height,
                x: 76.0,
                y: 6.0));
}

class JumpingCamelR extends SpriteComponent {
  JumpingCamelR(Image spriteImage)
      : super.fromSprite(
            CamelRConfig.width,
            CamelRConfig.height,
            Sprite.fromImage(spriteImage,
                width: CamelRConfig.width,
                height: CamelRConfig.height,
                x: 1339.0,
                y: 6.0));
}

class SurprisedCamelR extends SpriteComponent {
  SurprisedCamelR(Image spriteImage)
      : super.fromSprite(
            CamelRConfig.width,
            CamelRConfig.height,
            Sprite.fromImage(spriteImage,
                width: CamelRConfig.width,
                height: CamelRConfig.height,
                x: 1782.0,
                y: 6.0));
}
