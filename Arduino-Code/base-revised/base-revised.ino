#include <Wire.h>
#include <Adafruit_MLX90614.h> //download header file
#include <AP3216_WE.h> //download header file

 


// Declaration of functions
void getProximtyArduino();
void getTemperatureC();

Adafruit_MLX90614 mlx = Adafruit_MLX90614(); //Temperature detection object

AP3216_WE prox = AP3216_WE(); // proximity detection object

void setup(){
  Serial.begin(9600);

  mlx.begin();
  prox.init();
}

void loop(){
    if (Serial.available()){
        if (Serial.read() == 'G'){ //prompt to iniate functions
            Serial.flush();
            getProximtyArduino();
            delay(300); // coordinate with phone app to send 'G' , Delay 500
            Serial.flush();
        }
    }

}

void getProximtyArduino(){
    int proximity = prox.getProximity();
    Serial.println(proximity); //debugging

    if ((proximity > 1000) || (proximity < 20)) //calibrate values after testing
    {
        Serial.println("X"); //if out of optimal range return X
    }
    else
    {
        getTemperatureC(); // if proximity in optimal range continue to get temperature
    }
    

}

void getTemperatureC(){
    float temp = mlx.readObjectTempC();

    if ((temp < 10.0) || (temp > 50.0)){
       Serial.println("X") ; // if temperature outside validated range return X
    } else
    {
        Serial.println(temp,2); // if temperature inside validated range return temperature to two dp
    }
    
    
}
