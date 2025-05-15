import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../endless_arkanoid_game.dart';
import 'background_wrapper.dart';

class EndlessGameScreen extends StatelessWidget {
  const EndlessGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: GameWidget(
          game: EndlessArkanoidGame(),
          overlayBuilderMap: {
            'GameOver': (context, _) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Игра окончена',
                      style: TextStyle(fontSize: 36, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Вернуться в меню'),
                    ),
                  ],
                ),
              );
            },
          },
        ),
      ),
    );
  }
}
// для бесконечного режима экран поражения