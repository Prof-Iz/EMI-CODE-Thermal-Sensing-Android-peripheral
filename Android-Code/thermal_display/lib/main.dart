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
  String _serialData = "34.0";
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;

  Future<bool> _connectTo(device) async {
    _serialData = "INIT";

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
        _serialData = line;
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
    print(devices);

//    devices.forEach((device) {
//      _ports.add(ListTile(
//          leading: Icon(Icons.usb),
//          title: Text(device.productName),
//          subtitle: Text(device.manufacturerName),
//          trailing: RaisedButton(
//            child:
//            Text(_deviceId == device.deviceId ? "Disconnect" : "Connect"),
//            onPressed: () {
//              _connectTo(_deviceId == device.deviceId ? null : device)
//                  .then((res) {
//                _getPorts();
//              });
//            },
//          )));

//    });

    devices.length > 0
        ? _connectTo(devices[0])
        : null; // connect to whatever is plugged into phone first

    setState(() {
      print(_ports);
    });
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

//  @override
//  void dispose() {
//    super.dispose();
//    _connectTo(null);
//  }

  Color alertColor = Colors.limeAccent;
  bool callHospital = false;

  requestTemperature() async {
    await _port.write('G\r\n'.codeUnits);
  }

  showTemperature() {
    requestTemperature();
    setState(() {
      if (double.parse(_serialData) > 37.6) {
        callHospital = true;
        alertColor = Colors.redAccent;
      } else {
        callHospital = false;
        if ((double.parse(_serialData) < 37.6) &&
            (double.parse(_serialData) > 37.0)) {
          alertColor = Colors.orangeAccent;
        } else {
          alertColor = Colors.limeAccent;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QE Thermal",
      debugShowCheckedModeBanner: false,
      home: AnimatedContainer(
        duration: Duration(milliseconds: 1500),
        child: Scaffold(
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
                        onPressed: showTemperature,
                        child: Text(
                          _serialData,
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
        ),
      ),
    );
  }
}
