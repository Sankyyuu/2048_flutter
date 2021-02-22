import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'game.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamePage()),
              );
            },
              child: Text(
                "Play",
              ),
            ),
            FlatButton(
              color: Colors.orange,
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int high_score = prefs.getInt("high_score");
                await prefs.setInt('high_score', high_score == null ? 1 : high_score + 1);
              },
              child: Text(
                "Increment high score",
              ),
            ),
            FlatButton(
              color: Colors.orange,
              onPressed: () {
                exit(0);
            },
              child: Text(
                "Quit",
              ),
            )
          ],
        ),
      ),
    );
  }
}