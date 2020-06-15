#include <Wire.h>
#include <AP3216_WE.h> 
    
AP3216_WE prox = AP3216_WE(); // proximity detection object
int proximity_delay = 300;

int count = 0;
void getProximityArduino();

void setup(){
  Serial.begin(9600);
  Wire.begin();
  prox.init();
    prox.setMode(ALS_PS_ONCE);
    prox.setLuxRange(RANGE_20661);
    prox.setPSGain(2);
    delay(proximity_delay); //initial Sensor Calibration
}

void loop(){
  if (Serial.available()){
    if (Serial.read() == 'G'){
      while (count <20){
      Serial.flush();
      getProximityArduino();
      count++;
      }
      count =0;
    }
  }
}


void getProximityArduino()
{
    prox.setMode(ALS_PS_ONCE); //initiating measurement
    delay(proximity_delay);    //check for optimal delay time
    unsigned int proximity = prox.getProximity();
    if (proximity> 800){
      Serial.println("Close Enough");
    }
    else{
      Serial.println("Too far");
    }
    }
