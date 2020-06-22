import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UsbPort _port;
  String _status = "Please Plug in the Device";
  List<Widget> _ports = [];
  String serialData;
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  double intermediate = -1; //initial value that wont trigger function
  List<double> average;

  Future<bool> _connectTo(device) async {
    serialData = "click";

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

//    if (_port != null) {
//      _port.close();
//      _port = null;
//    }

    if (device == null) {
      _deviceId = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      setState(() {
        _status = "PORT Problem";
      });
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE); //settings for Arduino Nano as per GitHub Repo

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      setState(() {
        serialData = line;
        intermediate = double.parse(serialData);
      });
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.length > 0) {
      _connectTo(devices[0]); //connect to whatever is plugged into phone first
    } else {
      // if connection lost update serial data
      _status = "Disconnected";
      serialData = "owo'";
      callHospital = false;
      alertColor = Colors.amberAccent;
//      _showDisconnectDialog();
    }

    setState(() {
      print(_ports);
    });
  }

//  Future<void> _showDisconnectDialog() async {
//    //alert dialog for when the device disconnects
//    return showDialog<void>(
//        context: context,
//        barrierDismissible: true, // user must tap button!
//        builder: (BuildContext context) {
//          return AlertDialog(
//            backgroundColor: Colors.black,
//            title: Text(
//              'No Connected Device',
//              style: TextStyle(color: Colors.white, fontSize: 20),
//            ),
//            content: SingleChildScrollView(
//              child: ListBody(
//                children: <Widget>[
//                  Text(
//                    'If this is unintentional, make sure your cable is working properly. Otherwise, visit our certified Quick Fix shops to get it fixed',
//                    style: TextStyle(color: Colors.white, fontSize: 15),
//                  ),
//                ],
//              ),
//            ),
//          );
//        });
//  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
    serialData = "click"; //show instruction to click on init
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  Color alertColor = Colors.limeAccent;
  bool callHospital = false;

  requestTemperature() {
    _port.write(Uint8List.fromList("G\r\n".codeUnits)); //why cant we send this wtf
  }

  void updateColorsAndOpacity() {
    while (average.length < 4) {
      callHospital = false;
      if (intermediate == 0) {
//        callHospital = false;
        alertColor = Colors.limeAccent;
        serialData = 'X';
      } else if (intermediate > 37.6) {
//        callHospital = true;
        alertColor = Colors.redAccent;
      } else {
//        callHospital = false;
        if ((intermediate < 37.6) & (intermediate > 37.0)) {
          alertColor = Colors.orangeAccent;
        } else {
          alertColor = Colors.limeAccent;
        }
      }
      intermediate >= 35.5 ? average.add(intermediate):null; // collects three readings not erroneous
    }
    double sum = 0;
    average.forEach((num e) {sum+=e;});
    double finalValue = sum/3; //finds average of the collected measurements
    if (finalValue == 0) { // repeats checking procedure with the average answer
      callHospital = false; //only shows hospital in average case
      alertColor = Colors.limeAccent;
      serialData = 'X';
    } else if (finalValue > 37.6) {
      serialData = finalValue.toString();
      callHospital = true;
      alertColor = Colors.redAccent;
    } else {
      callHospital = false;
      serialData = finalValue.toString()+"!";
      if ((finalValue < 37.6) & (finalValue > 37.0)) {
        alertColor = Colors.orangeAccent;
      } else {
        alertColor = Colors.limeAccent;
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    updateColorsAndOpacity();
    return MaterialApp(
      title: "QE Thermal",
      home: Scaffold(
          backgroundColor: alertColor,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: callHospital,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                    onPressed: () =>
                        MapsLauncher.launchQuery("hospitals near me"),
                    child: Icon(
                      Icons.local_hospital,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(
                  flex: 1,
                ),
                Row(
                  //Serial Status
                  children: [
                    Expanded(
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black,
                          ),
                          child: Text(
                            _status,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                Row(
                  //Temperature Display Row
                  children: [
                    Expanded(
                      child: FlatButton(
                        splashColor: Colors.white10,
                        onPressed: requestTemperature,
                        child: Text(
                          serialData,
                          style: TextStyle(
                            fontSize: 150.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "© QE Sdn Bhd 2020",
                      style: TextStyle(fontSize: 15, color: Colors.black45),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
