import 'package:flutter/material.dart';
import 'dart:io';
import 'grid.dart';


class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GamePageState();
  }
}

class _GamePageState extends State<GamePage> {

  List<List<int>> grid = [];

  @override
  void initState() {
    // TODO: implement initState
    grid = emptyGrid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}