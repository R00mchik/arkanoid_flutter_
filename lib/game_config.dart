enum Difficulty { easy, medium, hard }

extension DifficultyParams on Difficulty {
  double get ballSpeed {
    switch (this) {
      case Difficulty.easy:
        return 200;
      case Difficulty.medium:                 //шар
        return 300;
      case Difficulty.hard:
        return 400;
    }
  }

  double get paddleWidth {
    switch (this) {
      case Difficulty.easy:
        return 120;
      case Difficulty.medium:              //ракетка
        return 90;
      case Difficulty.hard:
        return 60;
    }
  }

  String get name {
    switch (this) {
      case Difficulty.easy:
        return 'Лёгкий';
      case Difficulty.medium:
        return 'Средний';
      case Difficulty.hard:
        return 'Сложный';
    }
  }
}

class GameConfig {
  static Difficulty difficulty = Difficulty.easy;
  static int level = 0;
  static bool isEndless = false;
}
