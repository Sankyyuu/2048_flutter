import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'grid.dart';
import 'case.dart';
import 'dart:math';


class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GamePageState();
  }
}

class _GamePageState extends State<GamePage> {

  List<List<int>> grid = [];
  List<List<int>> saveGrid = [];
  int score = 0;
  Future<int> highScore;
  SharedPreferences sharedPreferences;
  bool isGameOver = false;
  bool isGameWon = false;
  bool isResetAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    grid = emptyGrid();
    grid = addRandomNumber(grid);
    grid = addRandomNumber(grid);
    super.initState();
  }

  Future<int> getHighScore() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int score = sharedPreferences.getInt('high_score');
    if (score == null) {
      score = 0;
    }
    return score;
  }

  void setHighScore() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("high_score", score);
  }

  List<Widget> getTilesFromGrid (double width, double height) {
    List<Widget> grids = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        int num = grid[i][j];
        String number;
        MaterialColor color;
        double size = 82;
        if (num == 0) {
          number = "";
          color = Colors.grey;
        } else if (num == 4) {
          number = "${num}";
          color = Colors.orange;
        } else if (num == 8) {
          number = "${num}";
          color = Colors.red;
        } else if (num > 8 && num < 65) {
          number = "${num}";
          color = Colors.purple;
          size = 41;
        } else if (num > 64 && num < 1024) {
          number = "${num}";
          color = Colors.blue;
          size = 35;
        } else if (num > 1023) {
          number = "${num}";
          color = Colors.green;
          size = 30;
        }
        else {
          number = "${num}";
          color = Colors.yellow;
        }
        grids.add(Case(i, j, height, size, number, color));
      }
    }
    return grids;
  }

  void incrScore(int newScore) {
    this.score += newScore;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double gridWidth = (width - 80) / 4;
    double gridHeight = gridWidth;
    double height = 50 + (gridHeight * 4) + 10;
    highScore = getHighScore();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyGamePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Game"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
            children: [
              // SCORE
              Container(
                width: 150.0,
                height: 82,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey,
                  ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                      child: Text(
                        'Score',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        score.toString(),
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              // High SCORE
              Padding(padding: EdgeInsets.only(left: 25.0), 
              child:
                Container(
                  width: 150.0,
                  height: 82,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey,
                    ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                        child: Text(
                          'High Score',
                        style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FutureBuilder<int>(
                        future: getHighScore(),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.toString(),
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          }
                        },)
                    ],
                  ),
                )
              ),
          ]),
          SizedBox(height: 10,),
          // GRID
          InkWell(
            child: 
              Container(
                  height: height,
                  width: width,
                  color: Colors.grey,
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: 
                          GridView.count(
                            primary: false,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            crossAxisCount: 4,
                            children: getTilesFromGrid(gridWidth, gridHeight),
                          ),
                        onVerticalDragEnd: (DragEndDetails details) {
                          setState(() {
                            if (details.primaryVelocity > 0) {
                              saveGrid = copyGrid(grid);
                              isResetAvailable = true;
                              grid = checkHorizontal(grid, 3, incrScore);
                              grid = addRandomNumber(grid);
                            } else if (details.primaryVelocity < 0) {
                              saveGrid = copyGrid(grid);
                              isResetAvailable = true;
                              grid = checkHorizontal(grid, 2, incrScore);
                              grid = addRandomNumber(grid);
                            }
                            isGameOver = checkGameOver(grid);
                            isGameWon = checkGameWon(grid);
                            if (isGameOver == true || isGameWon == true) {
                              setHighScore();
                            }
                          });
                        },
                        onHorizontalDragEnd: (details) {
                          setState(() {
                            if (details.primaryVelocity > 0) {
                              saveGrid = copyGrid(grid);
                              isResetAvailable = true;
                              grid = checkHorizontal(grid, 1, incrScore);
                              grid = addRandomNumber(grid);
                            } else if (details.primaryVelocity < 0) {
                              saveGrid = copyGrid(grid);
                              isResetAvailable = true;
                              grid = checkHorizontal(grid, 0, incrScore);
                              grid = addRandomNumber(grid);
                            }
                            isGameOver = checkGameOver(grid);
                            isGameWon = checkGameWon(grid);
                            if (isGameOver == true || isGameWon == true) {
                              setHighScore();
                            }
                          });
                        },
                      ),
                      isGameOver
                      ? Container(
                          height: height,
                          color: Colors.grey.withAlpha(30),
                          child: Center(
                            child: Text(
                              'Game over!',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                            ),
                          ),
                        )
                      )
                      : SizedBox(),
                      isGameWon
                      ? Container(
                          height: height,
                          color: Colors.orange.withAlpha(30),
                          child: Center(
                            child: Text(
                              'You won !',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                            ),
                          ),
                        )
                      )
                      : SizedBox(),
                    ]
                  )
              ),
            ),
            SizedBox(height: 20,),
            Center(child: 
            Ink(
                  
                decoration: ShapeDecoration(
                  color: (isResetAvailable == true) ? Colors.green : Colors.grey,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: Icon(Icons.refresh),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      grid = copyGrid(saveGrid);
                      isResetAvailable = false;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}