import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/layer.png',      //найти норм фон
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}

// этот клас чисто для фона сделал, один раз по сути его загружаем и во всем приложении
// просто на других экранах прозрачные фоны и этот виджет сзади.