//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Container(
        color: Colors.greenAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(
                flex: 2,
              ),
              Text(
                "WE ARE",
                style: TextStyle(fontSize: 30.0, color: Colors.black87),
              ),
              Spacer(
                flex: 1,
              ),
              Image(
                image: AssetImage('assets/Images/logo no bkg.png'),
                height: 200,
                width: 200,
              ),
//                Text("QE",style: TextStyle(fontSize: 55.0,color: Colors.white),),
              Spacer(
                flex: 1,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "A company dedicated to bringing you Quality Products During Quarantine. "
                  "Totally not doing it for EMI marks only. Totally not! "
                  "Message us on Insta Below ;)",
                  style: TextStyle(fontSize: 20.0, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    //to read barcode
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.redAccent, // inkwell color
                        child: SizedBox(
                            width: 56, height: 56, child: Icon(Icons.question_answer)),
                        onTap: () {
                          _launchInsta();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_launchInsta() async{
  const url = 'https://www.instagram.com/qesdnbhd/?hl=en';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

