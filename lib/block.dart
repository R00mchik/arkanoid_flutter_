import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Block extends RectangleComponent with CollisionCallbacks {
  bool isBreaking = false;
  final Color color;

  Block({
    required Vector2 position,
    required Vector2 size,
    required this.color,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawRect(size.toRect(), paint);

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(size.toRect(), borderPaint);
  }

  void breakBlock() {
    isBreaking = true;
  }
}
