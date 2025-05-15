import 'package:flutter/material.dart';
import 'level_select_screen.dart';
import 'difficulty_select_screen.dart';
import 'arkanoid_game_screen.dart';
import 'background_wrapper.dart';
import 'game_config.dart';
import 'endless_game_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _openDifficultySelect(BuildContext context, int selectedLevel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DifficultySelectScreen(
          selectedLevel: selectedLevel,
          onDifficultySelected: (level, difficulty) {
            GameConfig.level = level;
            GameConfig.difficulty = difficulty;
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ArkanoidGameScreen(
                  level: level,
                  onExit: () => Navigator.pop(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.white, size: 28),
                tooltip: 'Выход',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ARKANOID',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.orange,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  _StyledButton(
                    label: 'Уровни',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LevelSelectScreen(
                            onLevelSelected: (level) {
                              _openDifficultySelect(context, level);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _StyledButton(
                    label: 'Бесконечный режим',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EndlessGameScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyledButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _StyledButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        shadowColor: Colors.deepOrangeAccent.withOpacity(0.6),
        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
