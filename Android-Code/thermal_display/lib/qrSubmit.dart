import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class QRSubmitPage extends StatefulWidget {
  final String incomingTemp;
  QRSubmitPage(this.incomingTemp);
  @override
  _QRSubmitPageState createState() => _QRSubmitPageState();
}

class _QRSubmitPageState extends State<QRSubmitPage> {
  String scannedID = '';
  String _scanResult;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future scanEmployeeID() async {
    _scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#80ffff', "CANCEL", true, ScanMode.QR);
    setState(() {
      scannedID = _scanResult;
    });
  }

  Future<void> submitData() async {
    scannedID == '' ? scannedID = "ANON" : null;
    const String URL =
        "https://script.google.com/macros/s/AKfycbzVIf1F9Mk04fgpqXH1KaD4n9iGl_UV2mqT7wGkIaT_Ahngeg/exec";
    _showSnackbar("Syncing with Company Database");
    var response = await http.get(URL +"?id=$scannedID&temperature=${widget.incomingTemp}");
    if (response.statusCode == 200) {
      _showSnackbar("Data Transferred");
    }else{
      _showSnackbar("Code not 200?");
    }
  }


  _showSnackbar(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      textAlign: TextAlign.center,
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        foregroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        color: Colors.amberAccent,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Spacer(
                flex: 1,
              ),
              Text(
                "Scanned ID:",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                scannedID,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 70.0, color: Colors.black45),
              ),
              Text(
                "Recorded Temperature: ${widget.incomingTemp}",
                style: TextStyle(color: Colors.black45, fontSize: 20.0),
                textAlign: TextAlign.left,
              ),
              Spacer(
                flex: 2,
              ),
              ButtonBar(
                buttonPadding: EdgeInsets.all(8.0),
                alignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    //launch Hospital
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.redAccent, // inkwell color
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.local_hospital)),
                        onTap: () {
                          MapsLauncher.launchQuery("hospitals near me");
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    //to read barcode
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.lightGreenAccent, // inkwell color
                        child: SizedBox(
                            width: 56, height: 56, child: Icon(Icons.camera)),
                        onTap: scanEmployeeID,
                      ),
                    ),
                  ),
                  ClipOval(
                    //to submit data to database
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.limeAccent, // inkwell color
                        child: SizedBox(
                            width: 56, height: 56, child: Icon(Icons.backup)),
                        onTap: submitData,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}


