# DISCLAIMER | Referencing
This is a work in progress!! Some code may have errors and is purely for my own personal tracking. Eventually if the code works and you are able to use it, by all means please do ;) but remember to **reference my code** to *avoid **plagiarism** issues*<br>
***Ibrahim Izdhan**, 1001852671, UCSI University, Electrical and Electronics Engineering*<br><br>
# EMI CODE Thermal Sensing Android peripheral
 Code repository for EMI Project May Sem Y2 Engineering<br>

Repository contains 2 folders
<ol>Android Code</ol>
<ol>Arduino Code</ol>



## Arduino Code
The project in question requires the Arduino to take in data from 2 sensor modules - a thermal sensing module and an ALS distance measuring module. Code would collect the data and then process it before passing data through connected serial to an accompanyng Android device. <br>

### Specifics of Data Processing on the Arduino

#### AP3216 Proximity Sensor (CJMCU - 3216)
The proximity sensor used in the project is a CJMCU IR and Light based proximity sensor. The sensor was programmed using the library by **Wollewad**
https://github.com/wollewald/AP3216_WE and tweaked for single pulse detection mode of proximity following the instructions on his repo. The values received for proximity are compared in a conditional that was calibrated for my specific sensor and if it was within threshold values (**distance of roughly 2 - 4 cm**) from forehead the reading from the thermal sensor is triggered - else the Arduino returns **X** in the serial indicating that the forehead is not at an optimal distance. <br>

#### MLX90614 Thermal Sensor (GY90614)
Once the thermal sensor is triggered, the **getObjectTemperatureC** method is invoked for the mlx object and it returns the temperature of the object. if it is between a validated range the Arduino prints the temperature to 1 dp to the Serial - else X is returned to indicate erroneous range for a human.
The code uses the **Adafruit Library for the Module** https://github.com/adafruit/Adafruit-MLX90614-Library to initialise the object and invoke the methods.

## Android Code
The Android app was built with Flutter and coded in Android Studio. The USB portion of the code is based on a flutter port of **felHR85**'s UsbSerial for Android https://github.com/felHR85/UsbSerial - which was found on pub.dev - provided by **Bessem.dev** https://pub.dev/packages/usb_serial. The example code was tweaked to make the phone connect to the first device input into the serial port and only displays the immediate serial data (*it was a list in the example*)
