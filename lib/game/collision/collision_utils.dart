import 'package:dune_run/game/collision/collision_box.dart';
import 'package:dune_run/game/game.dart';
import 'package:dune_run/game/obstacle/obstacle.dart';
import 'package:dune_run/game/camel_r/config.dart';
import 'package:dune_run/game/camel_r/camel_r.dart';

bool checkForCollision(Obstacle obstacle, CamelR camelR) {
  CollisionBox camelRBox = CollisionBox(
    x: camelR.x + 1,
    y: camelR.y + 1,
    width: CamelRConfig.width - 2,
    height: CamelRConfig.height - 2,
  );

  CollisionBox obstacleBox = CollisionBox(
    x: obstacle.x + 1,
    y: obstacle.y + 1,
    width: obstacle.type.width * obstacle.internalSize - 2,
    height: obstacle.type.height - 2,
  );

  if (boxCompare(camelRBox, obstacleBox)) {
    List<CollisionBox> collisionBoxes = obstacle.collisionBoxes;
    List<CollisionBox> camelRCollisionBoxes =
        camelR.ducking ? CamelRCollisionBoxes.ducking : CamelRCollisionBoxes.running;

    bool crashed = false;

    collisionBoxes.forEach((obstacleCollisionBox) {
      CollisionBox adjObstacleBox =
          createAdjustedCollisionBox(obstacleCollisionBox, obstacleBox);

      camelRCollisionBoxes.forEach((camelRCollisionBox) {
        CollisionBox adjCamelRBox =
            createAdjustedCollisionBox(camelRCollisionBox, camelRBox);
        crashed = crashed || boxCompare(adjCamelRBox, adjObstacleBox);
      });
    });
    return crashed;
  }
  return false;
}

bool boxCompare(CollisionBox camelRBox, CollisionBox obstacleBox) {
  final double obstacleX = obstacleBox.x;
  final double obstacleY = obstacleBox.y;

  return (camelRBox.x < obstacleX + obstacleBox.width &&
      camelRBox.x + camelRBox.width > obstacleX &&
      camelRBox.y < obstacleBox.y + obstacleBox.height &&
      camelRBox.height + camelRBox.y > obstacleY);
}

CollisionBox createAdjustedCollisionBox(
    CollisionBox box, CollisionBox adjustment) {
  return CollisionBox(
      x: box.x + adjustment.x,
      y: box.y + adjustment.y,
      width: box.width,
      height: box.height);
}
