import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'arkanoid_game.dart';
import 'background_wrapper.dart';

class ArkanoidGameScreen extends StatefulWidget {
  final int level;
  final VoidCallback onExit;

  const ArkanoidGameScreen({
    required this.level,
    required this.onExit,
    super.key,
  });

  @override
  State<ArkanoidGameScreen> createState() => _ArkanoidGameScreenState();
}

class _ArkanoidGameScreenState extends State<ArkanoidGameScreen> {
  late ArkanoidGame _game;
  bool _levelLoaded = false;

  @override
  void initState() {
    super.initState();
    _game = ArkanoidGame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_levelLoaded && _game.hasLayout) {
      _game.loadLevel(widget.level);
      _levelLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: GestureDetector(
          onPanUpdate: (details) {
            final localPosition = details.localPosition;
            _game.movePaddle(localPosition.dx);
          },
          child: GameWidget(
            game: _game,
            overlayBuilderMap: <String, Widget Function(BuildContext, ArkanoidGame)>{
              // сюда гамеовер
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onExit,
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.arrow_back),
        tooltip: 'Вернуться в меню',
      ),
    );
  }
}
