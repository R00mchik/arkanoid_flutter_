import 'package:flutter/material.dart';
import 'game_config.dart';

class DifficultySelectScreen extends StatelessWidget {
  final int selectedLevel;
  final void Function(int level, Difficulty difficulty) onDifficultySelected;

  const DifficultySelectScreen({
    super.key,
    required this.selectedLevel,
    required this.onDifficultySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(title: const Text('Выберите сложность')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: Difficulty.values.map((difficulty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  onDifficultySelected(selectedLevel, difficulty);
                },
                child: Text(
                  difficulty.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
