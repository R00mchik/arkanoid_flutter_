import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/components.dart' hide Block;
import 'package:flutter/material.dart';
import 'game_config.dart';
import 'paddle.dart';
import 'ball.dart';
import 'block.dart';

class ArkanoidGame extends FlameGame {
  late final Paddle paddle;
  late final Ball ball;
  int currentLevel = GameConfig.level;

  bool _levelLoaded = false;
  int? _pendingLevel;

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    paddle = Paddle()
      ..anchor = Anchor.center
      ..size = Vector2(GameConfig.difficulty.paddleWidth, 20)
      ..position = Vector2(size.x / 2, size.y - 40);
    add(paddle);

    ball = Ball(
      radius: 8,
      velocity: Vector2(GameConfig.difficulty.ballSpeed, -GameConfig.difficulty.ballSpeed),
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(ball);

    if (_pendingLevel != null && !_levelLoaded) {
      generateLevel(_pendingLevel!);
      _levelLoaded = true;
      _pendingLevel = null;
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    if (_pendingLevel != null && !_levelLoaded) {
      generateLevel(_pendingLevel!);
      _levelLoaded = true;
      _pendingLevel = null;
    }
  }

  void loadLevel(int level) {
    currentLevel = level;
    if (!hasLayout) {
      _pendingLevel = level;
      _levelLoaded = false;                        // -удаление блоков, нужно убрать-
      return;
    }
    _pendingLevel = null;
    _levelLoaded = true;

    children.whereType<Block>().toList().forEach((b) => b.removeFromParent());

    generateLevel(level);
    overlays.remove('LevelSelect');
    resumeEngine();
  }

  void generateLevel(int index) {
    const rows = 5;
    const cols = 8;
    final blockWidth = size.x / cols;
    final blockHeight = (size.y / 3) / rows;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        bool placeBlock = false;

        switch (index) {
          case 0:
          case 1:
            placeBlock = true;
            break;
          case 2:
            placeBlock = j == 0 || j == cols - 1 || (j == i && i <= cols / 2);
            break;
          case 3:
            placeBlock = (j - cols ~/ 2).abs() + (i - rows ~/ 2).abs() <= 2;                 //фигуры к разным уровням, доделать
            break;
          case 4:
            placeBlock =
                (i == 1 && (j == 2 || j == 5)) || (i == 3 && j >= 2 && j <= 5);
            break;
          default:
            placeBlock = true;
            break;
        }

        if (placeBlock) {
          final block = Block(
            position: Vector2(
              j * blockWidth + blockWidth / 2,
              i * blockHeight + blockHeight / 2,
            ),
            size: Vector2(blockWidth - 2, blockHeight - 2),
            color: [Colors.red, Colors.green, Colors.blue][(i + j) % 3],
          )..anchor = Anchor.center;
          add(block);
        }
      }
    }
  }

  @override   //столкновения шарика
  void update(double dt) {
    super.update(dt);

    final r = ball.radius;

    if (ball.position.x <= r) {
      ball.position.x = r;
      ball.velocity.x = -ball.velocity.x;
    } else if (ball.position.x >= size.x - r) {
      ball.position.x = size.x - r;
      ball.velocity.x = -ball.velocity.x;
    }

    if (ball.position.y <= r) {
      ball.position.y = r;
      ball.velocity.y = -ball.velocity.y;
    }

    final ballRect = Rect.fromCircle(
      center: Offset(ball.position.x, ball.position.y),
      radius: r,
    );

    for (final block in children.whereType<Block>().toList()) {
      if (block.isBreaking) continue;

      final blockRect = Rect.fromCenter(
        center: Offset(block.position.x, block.position.y),
        width: block.size.x,
        height: block.size.y,
      );

      if (ballRect.overlaps(blockRect)) {
        block.breakBlock();
        block.removeFromParent();

        final dx = (ball.position.x - block.position.x).abs();
        final dy = (ball.position.y - block.position.y).abs();

        if (dx > dy) {
          ball.velocity.x = -ball.velocity.x;
          ball.position.x += ball.velocity.x * dt * 2;
        } else {
          ball.velocity.y = -ball.velocity.y;
          ball.position.y += ball.velocity.y * dt * 2;
        }
        break;
      }
    }

    final paddleTop = paddle.position.y - paddle.size.y / 2;
    if (ball.position.y + r >= paddleTop &&
        ball.position.x >= paddle.position.x - paddle.size.x / 2 &&
        ball.position.x <= paddle.position.x + paddle.size.x / 2 &&
        ball.velocity.y > 0) {
      ball.position.y = paddleTop - r;
      ball.velocity.y = -ball.velocity.y;

      final hitPos = (ball.position.x - paddle.position.x) / (paddle.size.x / 2);
      ball.velocity.x += hitPos * 100;
    }

    // проверка проигрыша тут доделать
    if (ball.position.y >= size.y + r) {
      gameOver();
    }
  }

  void movePaddle(double x) {
    final half = paddle.size.x / 2;
    paddle.position.x = x.clamp(half, size.x - half);
  }

  void gameOver() {
    pauseEngine();
    overlays.add('GameOver');
  }
}
