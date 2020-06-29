#include <Wire.h>
#include <Adafruit_MLX90614.h> //download header file
#include <AP3216_WE.h>         //download header file

// Declaration of functions
void getProximityArduino();
void getTemperatureC();

Adafruit_MLX90614 mlx = Adafruit_MLX90614(); //Temperature detection object

AP3216_WE prox = AP3216_WE(); // proximity detection object
int proximity_delay = 600;    //600ms delay for proximity sensor < to be tested

int count = 0; // counter to track 4 consecutive correct measurements

void setup()
{
    Serial.begin(9600);
    Wire.begin();
    mlx.begin();

    // Proximity Sensor Calibration
    prox.init();
    prox.setMode(ALS_PS_ONCE);
    prox.setLuxRange(RANGE_20661);
    prox.setPSGain(2);
    delay(proximity_delay); //initial Sensor Calibration

    // --------------------------------------------
}

void loop()
{
    char command = Serial.read();
    if (command == 'G')
    {
            while (count < 4){
            Serial.flush();
            getProximityArduino();
            delay(300); // coordinate with phone app to send 'G' , Delay 500
            // Serial.flush(); commented out for debugging
            }
        
    }
    count = 0; //reset counter value for next time
    Serial.flush(); // check if repeated requests to get temperature are not chained
}

void getProximityArduino()
{
    prox.setMode(ALS_PS_ONCE); //initiating measurement
    delay(proximity_delay);    //check for optimal delay time
    unsigned int proximity = prox.getProximity();
//    Serial.println(proximity); //debugging for calibration

    if ((proximity > 1000) || (proximity < 300)) //calibrate values after testing
    {
        Serial.println("0"); //if out of optimal range return 0
        count = 0; // if erroneous value set to 0;
    }
    else
    {
        getTemperatureC(); // if proximity in optimal range continue to get temperature
    }
}

void getTemperatureC()
{
    float temp = mlx.readObjectTempC();

    if ((temp < 10.0) || (temp > 50.0))
    {
        Serial.println("0"); // if temperature outside validated range return 0
        count = 0; // if erroneous value set to 0
    }
    else
    {
        Serial.println(temp + 4, 1); // if temperature inside validated range return temperature to one dp
        count ++; // increment counter for each successful measurement taken
    }
}
