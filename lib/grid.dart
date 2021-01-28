import 'dart:math';

List<List<int>> emptyGrid() {
  List<List<int>> emptyGrid = [];
  for(int i=0;i<4;i++){
    emptyGrid.add([0,0,0,0]);
  }
  return emptyGrid;
}