import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class Point {
  int x;
  int y;

  Point(this.x, this.y);
}

List<List<int>> emptyGrid() {
  List<List<int>> emptyGrid = [];
  for(int i=0;i<4;i++){
    emptyGrid.add([0,0,0,0]);
  }
  return emptyGrid;
}

List<List<int>> addRandomNumber(List<List<int>> grid) {
  // Add random number
  List<Point> availableSpots = [];

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) {
        availableSpots.add(Point(i, j));
      }
    }
  }
  if (availableSpots.length > 0) {
    int spotRandomIndex =  new Random().nextInt(availableSpots.length);
    Point spot = availableSpots[spotRandomIndex];
    int r = new Random().nextInt(100);
    grid[spot.x][spot.y] = r > 80 ? 4 : 2;
  }
  return grid;
}

List<List<int>> addNumber(List<List<int>> grid, int number) {
  // Add random number
  List<Point> availableSpots = [];

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) {
        availableSpots.add(Point(i, j));
      }
    }
  }
  if (availableSpots.length > 0) {
    int spotRandomIndex =  new Random().nextInt(availableSpots.length);
    Point spot = availableSpots[spotRandomIndex];
    grid[spot.x][spot.y] = number;
  }
  return grid;
}

List<List<int>> moveEverything(List<List<int>> grid, int direction) {
  if (direction == 0) {
    // Left
    for (int i = 0; i < 4; i++) {
      for (int j = 3; j > 0; j--) {
        if (grid[i][j] != 0) {
          if (j != 0 && grid[i][j - 1] == 0) {
            grid[i][j - 1] = grid[i][j];
            grid[i][j] = 0;
            j = 4;
          }
        }
      }
    }
  } else if (direction == 1) {
    // Right
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] != 0) {
          if (j != 3 && grid[i][j + 1] == 0) {
            grid[i][j + 1] = grid[i][j];
            grid[i][j] = 0;
            j = -1;
          }
        }
      }
    }
  } else if (direction == 2) {
    // Up
    for (int i = 0; i < 4; i++) {
      for (int j = 3; j > 0; j--) {
        if (grid[j][i] != 0) {
          if (j != 0 && grid[j - 1][i] == 0) {
            grid[j - 1][i] = grid[j][i];
            grid[j][i] = 0;
            j = 4;
          }
        }
      }
    }
  } else if (direction == 3) {
    // Down
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[j][i] != 0) {
          if (j != 3 && grid[j + 1][i] == 0) {
            grid[j + 1][i] = grid[j][i];
            grid[j][i] = 0;
            j = -1;
          }
        }
      }
    }
  }

  return grid;
}

List<List<int>> checkHorizontal(List<List<int>> grid, int direction, Function incrScore) {
  // 0 Left 1 Right
  grid = moveEverything(grid, direction);
  if (direction == 0) {
    // Left
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (j != 3) {
          if (grid[i][j] == grid[i][j + 1]) {
            grid[i][j] += grid[i][j + 1];
            incrScore(grid[i][j]);
            grid[i][j + 1] = 0;
          }
        }
      }
    }
  } else if (direction == 1) {
    // Right
    for (int i = 0; i < 4; i++) {
      for (int j = 3; j > 0; j--) {
        if (j != 0) {
          if (grid[i][j] == grid[i][j - 1]) {
            grid[i][j] += grid[i][j - 1];
            incrScore(grid[i][j]);
            grid[i][j - 1] = 0;
          }
        }
      }
    }
  } else if (direction == 2) {
    // Up
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (j != 3) {
          if (grid[j][i] == grid[j + 1][i] && grid[j][i] != 0) {
            grid[j][i] += grid[j + 1][i];
            incrScore(grid[j][i]);
            grid[j + 1][i] = 0;
          }
        }
      }
    }
  } else if (direction == 3) {
    // Down
    for (int i = 0; i < 4; i++) {
      for (int j = 3; j > 0; j--) {
        if (j != 0) {
          if (grid[j][i] == grid[j - 1][i] && grid[j][i] != 0) {
            grid[j][i] += grid[j - 1][i];
            incrScore(grid[j][i]);
            grid[j - 1][i] = 0;
          }
        }
      }
    }
  }

  grid = moveEverything(grid, direction);
  return grid;
}

bool checkGameOver(List<List<int>> grid) {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 0) {
        return false;
      }
      if (i != 3 && grid[i][j] == grid[i + 1][j]) {
        return false;
      }
      if (j != 3 && grid[i][j] == grid[i][j + 1]) {
        return false;
      }
    }
  }
  return true;
}

bool checkGameWon(List<List<int>> grid) {
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (grid[i][j] == 2048) {
        return true;
      }
    }
  }
  return false;
}

List<List<int>> copyGrid(List<List<int>> grid) {
  List<List<int>> newGrid = [];
  for (int i = 0; i < 4; i++) {
    List<int> newList = List.from(grid[i]);
    newGrid.add(newList);
  }
  return newGrid;
}