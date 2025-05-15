import 'package:flutter/material.dart';

class LevelSelectOverlay extends StatelessWidget {
  final void Function(int) onLevelSelected;
  const LevelSelectOverlay({required this.onLevelSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54, // поменять?
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: List.generate(5, (index) {
            final level = index + 1;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(80, 80),
                shape: const CircleBorder(),
                backgroundColor: Colors.deepOrange,
                textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              onPressed: () => onLevelSelected(level),
              child: Text('$level'),
            );
          }),
        ),
      ),
    );
  }
}
