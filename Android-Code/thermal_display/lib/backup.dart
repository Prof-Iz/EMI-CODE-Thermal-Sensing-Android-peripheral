//import 'package:flutter/material.dart';
//import 'package:maps_launcher/maps_launcher.dart';
//import 'dart:typed_data';
//import 'dart:async';
//import 'package:usb_serial/usb_serial.dart';
//import 'package:usb_serial/transaction.dart';
//
//void main() {
//  runApp(homeScreen());
//}
//
//class homeScreen extends StatefulWidget {
//  @override
//  _homeScreenState createState() => _homeScreenState();
//}
//
//class _homeScreenState extends State<homeScreen> {
//
//  Color alertColor = Colors.limeAccent;
//  String statusSerial = "Serial Connected";
//  String serialReading = "30.5";
//  bool callHospital = false;
//
//  showHospital(){
//    setState(() {
//      double temp = double.parse(serialReading);
//      temp+=0.3;
//      serialReading = temp.toStringAsFixed(1);
//      if (double.parse(serialReading) > 37.6) {
//        callHospital = true;
//        alertColor = Colors.redAccent;
//      } else {
//        callHospital = false;
//        if ((double.parse(serialReading) < 37.6) &&
//            (double.parse(serialReading) > 37.0)) {
//          alertColor = Colors.orangeAccent;
//        }
//        else {
//          alertColor = Colors.limeAccent;
//        }
//      }
//
//
//    });
//
//  }
//  @override
//  Widget build(BuildContext context) {
//    showHospital();
//
//    return MaterialApp(
//      title: "QE Thermal",
//      debugShowCheckedModeBanner: false,
//      home: AnimatedContainer(
//        duration: Duration(milliseconds: 1500),
//        child: Scaffold(
//          backgroundColor: alertColor,
//          floatingActionButton: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: [
//                Visibility(
//                  visible: callHospital,
//                  child: FloatingActionButton(
//                    backgroundColor: Colors.white,
//                    foregroundColor: Colors.redAccent,
//                    onPressed: ()=> MapsLauncher.launchQuery("hospitals near me"),
//                    child: Icon(
//                      Icons.local_hospital,
//                    ),
//                  ),
//                ),
//
//              ],),
//          ),
//          body: Padding(
//            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 5.0),
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: [Spacer(flex: 1,),
//                Row( //Serial Status
//                  children: [
//                    Expanded(
//                      child: FractionallySizedBox(
//                        widthFactor: 0.5,
//                        child: Container(
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(20.0),
//                            color: Colors.black,
//                          ),
//                          child: Text(statusSerial,
//                            style: TextStyle(
//                              fontSize: 14.0,
//                              color: Colors.white,
//                            ),textAlign: TextAlign.center,),
//                        ),
//                      ),
//                    )
//                  ],
//                ),Spacer(flex: 1,),
//                Row( //Temperature Display Row
//                  children: [Expanded(
//                    child: FlatButton(
//                      splashColor: Colors.white10,
//                      onPressed: showHospital,
//                      child: Text(serialReading,
//                        style: TextStyle(
//                          fontSize: 150.0,
//                        ),
//                        textAlign: TextAlign.center,),
//                    ),
//                  )],
//                ),
//                Spacer(flex: 2,)
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
