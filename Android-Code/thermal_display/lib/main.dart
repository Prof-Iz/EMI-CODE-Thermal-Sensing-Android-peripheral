import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Thermal Sensing Device",
      theme: ThemeData(fontFamily: 'Arvo'),
      home: Scaffold( body: Column(children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              child: Container(alignment: Alignment.topCenter,
              child: Text("Sensor is in China",
              textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'Arvo'),
              ),
                color: CupertinoColors.darkBackgroundGray,
                padding: EdgeInsets.only(top: 25.0,left: 16.0,right: 16.0,bottom: 10.0),

            ),),
          ],),
          Row(children: [
            Expanded(
              child: Container(alignment: Alignment.center,
                padding: EdgeInsets.only(top: 170.0),
                child: Text(
                  "39.9",
                  style: TextStyle(
                    fontSize: 125.0,
                  ),
                ),
              ),
            ),
          ],),
        ],),
          backgroundColor: Color.fromARGB(255, 211, 235, 52) ),
      );


  }
}
//backgroundColor: Color.fromARGB(255, 142, 255, 125),
void main(){
  SystemChrome.setEnabledSystemUIOverlays([]); //tried to remove the android status bar
  runApp(MainScreen()
  );
}