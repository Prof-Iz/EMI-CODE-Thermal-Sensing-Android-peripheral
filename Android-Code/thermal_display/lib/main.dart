import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';
import 'dart:typed_data';
import 'dart:async';

void main() => runApp(MaterialApp(
  home: HomeScreen(),
));

class HomeScreen extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UsbPort _port;
  String status = "Connect your device :)";
  String serialData = "                    ";
  List<Widget> _ports = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;

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

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      setState(() {
        status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (!await _port.open()) {
      setState(() {
        status = "Port has problem";
      });
      return false;
    }

    _deviceId = device.DeviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      setState(() {
        serialData = line;
      });
    });

    setState(() {
      status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    devices.length > 0
        ? _connectTo(devices[0]) //connect to whatever is plugged into phone first
        : status = "Disconnected";

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

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text('Temperature Sensor'),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "$status",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          Divider(
              height: 50.0),
          Text(
            "Distance: ${serialData.substring(0,5)} m\n",
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Temperature: ${serialData.substring(5,9)} °C\n",
            style: TextStyle(
              color: Colors.black,
              letterSpacing: 2.0,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height:100.0),
          Center(
            child: RaisedButton(
              onPressed: (){
                _port.write(Uint8List.fromList("t\r\n".codeUnits));
              },
              child: Text(
                "Activate",
              ),
            ),
          ),
          Text(
            "Quantum Technologies",
            style: TextStyle(
                color: Colors.black,
                fontSize:16.0,
                fontStyle: FontStyle.italic
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

