import 'package:flutter/material.dart';

class LevelSelectScreen extends StatelessWidget {
  final void Function(int) onLevelSelected;

  const LevelSelectScreen({required this.onLevelSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[700],
        title: const Text('Выбор уровня'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            children: List.generate(5, (index) {
              final level = index + 1;
              return _LevelButton(
                level: level,
                onTap: () {
                  onLevelSelected(level);
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final int level;
  final VoidCallback onTap;

  const _LevelButton({required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withOpacity(0.6),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$level',
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Colors.black54,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
