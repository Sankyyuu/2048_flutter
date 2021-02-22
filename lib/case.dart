import 'package:flutter/material.dart';

class Case extends StatefulWidget {
  int x;
  int y;
  String number;
  double width;
  double height;
  double size;
  MaterialColor color;

  Case(this.x,this.y, this.height, this.size, this.number, this.color);

  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _CaseState();
    }
}

class _CaseState extends State<Case> {
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Container(
        child: Center(
          child: Text(widget.number,style: TextStyle(fontSize:widget.size,fontWeight: FontWeight.bold, color: widget.color == Colors.orange ? Colors.yellow : Colors.orange),),
        ),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      );
    }
}