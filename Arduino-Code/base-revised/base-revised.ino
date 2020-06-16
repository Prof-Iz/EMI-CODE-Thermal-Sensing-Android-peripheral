#include <Wire.h>
#include <Adafruit_MLX90614.h> //download header file
#include <AP3216_WE.h>         //download header file

// Declaration of functions
void getProximityArduino();
void getTemperatureC();

Adafruit_MLX90614 mlx = Adafruit_MLX90614(); //Temperature detection object

AP3216_WE prox = AP3216_WE(); // proximity detection object
int proximity_delay = 600;    //600ms delay for proximity sensor < to be tested

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
//    if (Serial.available())
//    {
              
            Serial.flush();
            getProximityArduino();
            delay(300); // coordinate with phone app to send 'G' , Delay 500
            // Serial.flush(); commented out for debugging
        
//    }
}

void getProximityArduino()
{
    prox.setMode(ALS_PS_ONCE); //initiating measurement
    delay(proximity_delay);    //check for optimal delay time
    unsigned int proximity = prox.getProximity();
//    Serial.println(proximity); //debugging for calibration

    if ((proximity > 1000) || (proximity < 300)) //calibrate values after testing
    {
        Serial.println("X"); //if out of optimal range return X
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
        Serial.println("X"); // if temperature outside validated range return X
    }
    else
    {
        Serial.println(temp + 4, 1); // if temperature inside validated range return temperature to two dp
    }
}
