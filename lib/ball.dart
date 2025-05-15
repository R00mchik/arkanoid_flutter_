import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Ball extends CircleComponent with CollisionCallbacks {
  Vector2 velocity;

  Ball({
    required this.velocity,
    required Vector2 position,
    required double radius,
  }) : super(
    position: position,
    radius: radius,
    anchor: Anchor.center,
    paint: Paint()..color = Colors.white,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }
}
