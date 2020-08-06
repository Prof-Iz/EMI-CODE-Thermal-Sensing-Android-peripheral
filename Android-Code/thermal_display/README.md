# thermaldisplay

Supporting Android Application for the EMI project

## Warning
The usb serial library that is used proved to have some issues with Arduino Nano devices using the CH340 interface. The serial communication was unable to run in any mode besides the **release** version of the built APK, for the Arduino Nano and some older Arduino Boards. However, for our porject we used the **Seeeduino Xiao** which did not present these errors, despite running at the same settings for a Nano.

The **http** library that is used with this project to send a **GET** request to the Google Sheets Web App did not work properly with the release verson of the app, thus we had to use the Debug version with the larger binary footprint.


## Repositories/Packages Used
The Repositories/Packages that have been used for this project are noted below.
**usb_serial: ^0.2.4**
The package is used to establish serial connection with any connected devices and the android phone.
Documentation: https://pub.dev/packages/usb_serial

**maps_launcher : ^1.2.0**
The package provides a quick method to launch any maps software installed on your android phone with a specific search query.
Documentation: https://pub.dev/packages/maps_launcher

**path_provider : ^1.6.11**
This package provides commonly used locations on the filesystem. Supports iOS, Android, Linux and MacOS. Not all methods are supported on all platforms.
Documentation: https://pub.dev/packages/path_provider

**audioplayers: ^0.15.1**
This package is used in conjunction with path_provider to play audio files to alert the fever status before temperature is read out.
Documentation: https://pub.dev/packages/audioplayers

**flutter_tts: ^1.2.3**
This package is used to convert text (temperature value) into speech, which will be read out in your program.
Documentation: https://pub.dev/packages/flutter_tts

**flutter_barcode_scanner: ^1.0.1**
This package is to scan and return QR codes data before sending it to the GOOGLE SHEETS DATABASE using http.
Documentation: https://pub.dev/packages/flutter_barcode_scanner

**http:**
This package facilitates the GET request to store the data of individuals with a fever into a GOOGLE SHEETS, which is deployed as a Web App.
Documentation: https://pub.dev/packages/http

<br>
## Flow charts
Flow charts of how the data is roughly processed is given in the **FLOWCHARTS** Folder