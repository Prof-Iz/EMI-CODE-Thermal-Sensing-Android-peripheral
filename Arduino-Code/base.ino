#include <Wire.h>
#include <Adafruit_MLX90614.h> //download header file
 


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
    delay(50); // further test if delays are sufficient or not
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

    if ((temp < 10.0) || (temp > 50.0)){
        compile[1] = 'X'; // if temperature outside validated range make first char of compile array X to tell phone result has errors
    } else
    {
        String placeholder = str(temp); //convert the stored temperature reading to string and store in a placeholder
        for (int i=0;i<4;i++){
        compile[i] = placeholder[i]; // replace first 4 elements of compiled answer with tmeperature reading
        }
    }
    
    
}