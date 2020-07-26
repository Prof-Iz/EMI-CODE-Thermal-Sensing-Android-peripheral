//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/services.dart';
//import 'package:maps_launcher/maps_launcher.dart';
//import 'package:thermaldisplay/companyInfo.dart';
//import 'dart:typed_data';
//import 'dart:async';
//import 'package:usb_serial/usb_serial.dart';
//import 'package:usb_serial/transaction.dart';
//import 'package:audioplayers/audioplayers.dart';
//import 'package:audioplayers/audio_cache.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:flutter_tts/flutter_tts.dart';
//import 'dart:io';
//
//void main() {
//  runApp(MaterialApp(theme: ThemeData(fontFamily: "Roboto"),home: HomeScreen()));
//}
//
//
//class HomeScreen extends StatefulWidget {
//  @override
//  _HomeScreenState createState() => _HomeScreenState();
//}
//
//class _HomeScreenState extends State<HomeScreen> {
//  UsbPort _port;
//  String status = "Please Plug in the Device";
//  List<Widget> _ports = [];
//  String serialData;
//  StreamSubscription<String> _subscription;
//  Transaction<String> _transaction;
//  int _deviceId;
//  double intermediate = -1; //initial value that wont trigger function
//  double finalValue;
//  bool pendingRequest = false;
//  List<double> average = [];
//  AudioPlayer feverDetected = AudioPlayer();
//  // AudioCache fever2 = AudioCache();
//  String feverSoundURI;
//  String noFeverSoundURI;
//  FlutterTts readTemperatureResult = FlutterTts();
//  Color alertColor = Colors.limeAccent;
//  bool callHospital = false;
//
//  Future _speak() async {
//    var result =
//    await readTemperatureResult.speak("Your Temperature is, $serialData");
//  }
//
//  playSoundFever() {
//    feverDetected.play(feverSoundURI, isLocal: true);
//  }
//
//  playSoundNormal() {
//    feverDetected.play(noFeverSoundURI, isLocal: true);
//  }
//
//  void _loadSounds() async {
//    //prepare warning and okay sounds
//    final ByteData dangerFeverSound =
//    await rootBundle.load('assets/sounds/fever_ting.mp3');
//    final ByteData okayNoFeverSound =
//    await rootBundle.load('assets/sounds/mans_not_hot.mp3');
//
//    Directory tempDir = await getTemporaryDirectory();
//    File tempFile_1 = File('${tempDir.path}/fever_ting.mp3');
//    await tempFile_1.writeAsBytes(dangerFeverSound.buffer.asUint8List(),
//        flush: true);
//    File tempFile_2 = File('${tempDir.path}/mans_not_hot.mp3');
//    await tempFile_2.writeAsBytes(okayNoFeverSound.buffer.asUint8List(),
//        flush: true);
//
//    feverSoundURI = tempFile_1.uri.toString();
//    noFeverSoundURI = tempFile_2.uri.toString();
//  }
//
//  Future<bool> _connectTo(device) async {
//    serialData = "click";
//
//    if (_subscription != null) {
//      _subscription.cancel();
//      _subscription = null;
//    }
//
//    if (_transaction != null) {
//      _transaction.dispose();
//      _transaction = null;
//    }
//
//    if (device == null) {
//      _deviceId = null;
//      setState(() {
//        status = "Disconnected";
//      });
//      return true;
//    }
//
//    _port = await device.create();
//    if (!await _port.open()) {
//      setState(() {
//        status = "PORT Problem";
//      });
//      return false;
//    }
//
//    _deviceId = device.deviceId;
//    await _port.setDTR(true);
//    await _port.setRTS(true);
//    await _port.setPortParameters(9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1,
//        UsbPort.PARITY_NONE); //settings for Arduino Nano as per GitHub Repo
//
//    _transaction = Transaction.stringTerminated(
//        _port.inputStream, Uint8List.fromList([13, 10]));
//
//    _subscription = _transaction.stream.listen((String line) {
//      setState(() {
//        serialData = line;
//        intermediate = double.parse(serialData);
//      });
//    });
//
//    setState(() {
//      status = "Connected";
//    });
//    return true;
//  }
//
//  void _getPorts() async {
//    List<UsbDevice> devices = await UsbSerial.listDevices();
//    if (devices.length > 0) {
//      _connectTo(devices[0]); //connect to whatever is plugged into phone first
//    } else {
//      // if connection lost update serial data
//      setState(() {
//        intermediate = -1;
//        status = "Disconnected";
//        pendingRequest = false;
//      });
//    }
//  }
//
//  @override
//  void initState() {
//    super.initState();
//
//    _loadSounds();
//
//    UsbSerial.usbEventStream.listen((UsbEvent event) {
//      _getPorts();
//    });
//
//    _getPorts();
//    setState(() {
//      serialData = "click"; //show instruction to click on init
//    });
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _connectTo(null);
//  }
//
//
//  requestTemperature() {
//    if ((pendingRequest == false) && (status == "Connected")) {
//      _port.write(Uint8List.fromList("G\r\n".codeUnits));
//      pendingRequest = true;
//      print("if condition triggered"); // debugging
//    }
//    print(pendingRequest); //debugging
//  }
//
//  void updateColorsAndOpacity() {
//    if (intermediate == -1) {
//      //avoid initial -1 display
//      serialData = "click";
//      callHospital = false;
//      alertColor = Colors.lightBlueAccent;
//    } else if (average.length < 3) {
//      // switch reading to 3 to see if state build issue persists
//      callHospital = false;
//      if (intermediate == 0) {
//        alertColor = Colors.limeAccent;
//        serialData = 'FAR';
//      } else if (intermediate > 37.6) {
//        alertColor = Colors.redAccent;
//      } else {
//        if ((intermediate < 37.6) && (intermediate > 37.0)) {
//          alertColor = Colors.orangeAccent;
//        } else {
//          alertColor = Colors.limeAccent;
//        }
//      }
//      intermediate > 0
//          ? average.add(intermediate)
//          : average =
//      []; // collects three readings not erroneous and resets if too far
//    } else {
//      double sum = 0;
//      average.forEach((num e) {
//        sum += e;
//      });
//      finalValue =
//          sum / average.length; //finds average of the collected measurements
//      serialData = finalValue.toString().substring(0, 4);
//      pendingRequest = false; // request completed
//      if (finalValue > 37.6) {
//        //repeats checking procedure with averaged value
//        callHospital = true;
//        alertColor = Colors.redAccent;
//        playSoundFever();
//        _speak();
//      } else {
//        callHospital = false;
//        playSoundNormal();
//        _speak();
//        if ((finalValue < 37.6) && (finalValue > 37.0)) {
//          alertColor = Colors.orangeAccent;
//        } else {
//          alertColor = Colors.limeAccent;
//        }
//      }
//
//      average = []; //reset average
//      sum = 0; //reset sum value
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    updateColorsAndOpacity();
//    return Scaffold(
//        backgroundColor: alertColor,
//        floatingActionButton: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: [
//              Visibility(
//                visible: callHospital,
//                child: FloatingActionButton(
//                  backgroundColor: Colors.white,
//                  foregroundColor: Colors.redAccent,
//                  onPressed: () =>
//                      MapsLauncher.launchQuery("hospitals near me"),
//                  child: Icon(
//                    Icons.local_hospital,
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//        body: Padding(
//          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: [
//              Spacer(
//                flex: 1,
//              ),
//              Row(
//                //Serial Status
//                children: [
//                  Expanded(
//                    child: FractionallySizedBox(
//                      widthFactor: 0.5,
//                      child: Container(
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(20.0),
//                          color: Colors.black,
//                        ),
//                        child: Text(
//                          status,
//                          style: TextStyle(
//                            fontSize: 14.0,
//                            color: Colors.white,
//                          ),
//                          textAlign: TextAlign.center,
//                        ),
//                      ),
//                    ),
//                  )
//                ],
//              ),
//              Spacer(
//                flex: 1,
//              ),
//              Row(
//                //Temperature Display Row
//                children: [
//                  Expanded(
//                    child: FlatButton(
//                      splashColor: Colors.white10,
//                      onPressed: requestTemperature,
//                      child: Text(
//                        serialData,
//                        style: TextStyle(
//                          fontSize: 150.0,
//                        ),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                  )
//                ],
//              ),
//              Spacer(
//                flex: 2,
//              )
//            ],
//          ),
//        ),
//        bottomNavigationBar: BottomAppBar(
//          color: Colors.transparent,
//          elevation: 0.0,
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: [
//              Expanded(
//                child: FractionallySizedBox(
//                  widthFactor: 0.5,
//                  child: FlatButton(
//                    onPressed: (){
//                      Navigator.push(context, new MaterialPageRoute(builder: (context) => InformationPage()));
//                    },
//                    child: Text(
//                      "© QE Sdn Bhd 2020",
//                      style: TextStyle(fontSize: 15, color: Colors.black45),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                ),
//              )
//            ],
//          ),
//        ));
//
//  }
//}
