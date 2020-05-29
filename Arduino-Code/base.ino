#include <Wire.h>
#include <Adafruit_MLX90614.h>
 


// Declaration of functions
void getDistanceCm();
void getTemperatureC();


// Declaration of globals
int trig = 9;
int echo = 7;
float distance;
float timetaken; //Variables for Distance Detection
char compile[4]; //compiled answer

Adafruit_MLX90614 mlx = Adafruit_MLX90614(); //Temperature detection object



void setup(){
  Serial.begin(9600);

  pinMode(echo , INPUT);
  pinMode(trig, OUTPUT);
  
  mlx.begin();
}

void loop(){
    getDistanceCm();
    delay(50);
    getTemperatureC();
    delay(50);
    Serial.println(compile);
    delay(500); //give nano some rest

}

void getDistanceCm(){
    digitalWrite(trig, 0);
    delay(100);
    digitalWrite(trig, 1);
    delay(100);
    digitalWrite(trig, 0);
    timetaken = pulseIn(echo, 1);
    distance = 340*(timetaken /10000)/2;   // to get the ans in centimeers converting from meters. Speed of sound assumed at 340
    
    //Serial.println(timetaken);
    if ((distance > 5.0) || (distance < 2.0))
    {
        compile[4]= 'B'; // if not optimal range set to B
    }
    else
    {
        compile[4]= 'A'; // if optimal range set to A
    }
    

}

void getTemperatureC(){
    float temp = mlx.readObjectTempC();
    // return str(temp[0:3]); check if this syntax works
    for (int i=0;i<4;i++){
        compile[i] = str(temp[i]);
    }
}