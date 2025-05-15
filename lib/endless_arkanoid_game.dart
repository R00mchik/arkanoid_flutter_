import 'dart:math';

import 'package:flame/components.dart' hide Block;
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class EndlessArkanoidGame extends FlameGame
    with HasCollisionDetection, PanDetector {
  late Paddle paddle;
  Ball? mainBall;
  late TextComponent scoreText, livesText;
  late Timer _spawnTimer;

  int score = 0;
  int lives = 3;
  final _rand = Random();

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    paddle = Paddle()
      ..anchor = Anchor.center
      ..size = Vector2(80, 20)
      ..position = Vector2(size.x / 2, size.y - 30);
    add(paddle);

    // ХУД
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(10, 10),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white, fontSize: 18)),
      priority: 100,
    );
    livesText = TextComponent(
      text: '❤' * lives,
      position: Vector2(10, 34),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
          style: const TextStyle(color: Colors.red, fontSize: 20)),
      priority: 100,
    );
    addAll([scoreText, livesText]);

    _spawnMainBall();

    // Таймер спавна строк
    _spawnTimer = Timer(4.0, onTick: _spawnRow, repeat: true);
    _spawnRow();
    _spawnTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer.update(dt);
  }

  void _spawnMainBall() {
    mainBall?.removeFromParent();
    final b = Ball(isMain: true)
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y / 2);
    mainBall = b;
    add(b);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    paddle.position.x += info.delta.global.x;
    final half = paddle.size.x / 2;
    paddle.position.x = paddle.position.x.clamp(half, size.x - half);
  }

  void _spawnRow() {
    const cols = 8;
    final w = size.x / cols;
    const h = 20.0;

    for (var i = 0; i < cols; i++) {
      final blk = Block()
        ..anchor = Anchor.topLeft
        ..size = Vector2(w - 2, h)
        ..position = Vector2(i * w, 0);
      // строка блоков в итоге падает
      blk.add(MoveEffect.to(
        Vector2(blk.x, size.y),
        EffectController(duration: 37.5), //за это время
      ));
      add(blk);
    }
  }

  void onBlockHit(Vector2 center) {
    score++;
    scoreText.text = 'Score: $score';

    // бонус с шансом 5 процентов
    if (_rand.nextDouble() < 0.05) {
      final bonus = MultiBallBonus()
        ..anchor = Anchor.center
        ..position = center;
      add(bonus);
    }

    if (score % 10 == 0) {
      _spawnTimer.stop();
      final next = (_spawnTimer.current * 0.9).clamp(1.0, double.infinity);
      _spawnTimer = Timer(next, onTick: _spawnRow, repeat: true)..start();
    }
  }

  void onMainBallLost() {
    lives--;
    livesText.text = '❤' * lives;
    if (lives <= 0) {
      pauseEngine();
      overlays.add('GameOver');
    } else {
      _spawnMainBall();
    }
  }
}

class Paddle extends PositionComponent with CollisionCallbacks {
  Paddle() {
    size = Vector2(80, 20);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    final gradient = LinearGradient(
      colors: [
        Colors.orangeAccent,
        Colors.deepOrange,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect);

    canvas.drawRRect(rrect, paint);

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(rrect, borderPaint);
  }
}

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameRef<EndlessArkanoidGame> {
  late Vector2 velocity;
  final bool isMain;

  Ball({required this.isMain}) : super(radius: isMain ? 8 : 5) {
    final base = (isMain ? 200.0 : 160.0) * 2.0;
    final dir = Random().nextBool() ? 1.0 : -1.0;
    velocity = Vector2(dir * base, -base);
    paint = Paint()..color = isMain ? Colors.white : Colors.lightBlueAccent;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    final dist = velocity.length * dt;
    final steps = (dist / radius).ceil().clamp(1, 5);
    final stepDt = dt / steps;
    for (var i = 0; i < steps; i++) {
      position += velocity * stepDt;
      _checkBounds();
    }
  }

  void _checkBounds() {
    final g = gameRef;
    final sz = g.size;
    if (x <= 0 || x >= sz.x) velocity.x = -velocity.x;
    if (y <= 0) velocity.y = -velocity.y;
    if (y >= sz.y) {
      removeFromParent();
      if (isMain) g.onMainBallLost();
    }
  }

  @override
  void onCollision(Set<Vector2> pts, PositionComponent other) {
    super.onCollision(pts, other);
    if (other is Block || other is Paddle) {
      velocity.y = -velocity.y;
      if (other is Block) {
        other.removeFromParent();
        final center = other.position + other.size / 2;
        gameRef.onBlockHit(center);
      }
    }
  }
}

class Block extends RectangleComponent with CollisionCallbacks {
  late Paint borderPaint;

  Block() {
    paint = Paint()
      ..color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = size.toRect();
    canvas.drawRect(rect, borderPaint);
  }
}

class MultiBallBonus extends CircleComponent
    with CollisionCallbacks, HasGameRef<EndlessArkanoidGame> {
  MultiBallBonus() : super(radius: 6, paint: Paint()..color = Colors.cyan);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 100 * dt;
    if (position.y >= gameRef.size.y) removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> pts, PositionComponent other) {
    super.onCollision(pts, other);
    if (other is Paddle) {
      for (var i = 0; i < 3; i++) {
        final mini = Ball(isMain: false)
          ..anchor = Anchor.center
          ..position = gameRef.mainBall!.position.clone();
        gameRef.add(mini);
      }
      removeFromParent();
    }
  }
}

//вообщем этот режим бесконечный я реализовал первым делом, хотел добавить ещё бонусы типо ускорения шара и т.п.,
// но из-за ускорения баги случались с физикой,
// оставил только, 1 бонус и когда его собираешь типо 2 шарика доп-ых вылетает и тоже блоки ломают и их можно не ловить