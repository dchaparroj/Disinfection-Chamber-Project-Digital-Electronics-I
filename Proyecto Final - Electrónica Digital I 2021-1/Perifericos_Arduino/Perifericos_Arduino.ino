#include <Servo.h> 

int zumbador_in = A0; //Se establecen las entradas
int led_in = A1;
int servo180_in = A2;
int servo360_in = A3;
int sensor_in = A4;

int zumbador = 9; //Se establecen las salidas
int led = 8;
Servo servo180;
Servo servo360;
 
void setup() { 
  Serial.begin(9600);

  pinMode(zumbador_in, INPUT);
  pinMode(led_in, INPUT);
  pinMode(servo180_in, INPUT);
  pinMode(servo360_in, INPUT);
  pinMode(sensor_in, INPUT);
  
  pinMode(zumbador, OUTPUT);
  pinMode(led, OUTPUT);
  servo180.attach(10);
  servo360.attach(11);
} 
 
void loop() { 
    int zumbador_valor = analogRead(zumbador_in);
    int led_valor = analogRead(led_in);  
    int servo180_valor = analogRead(servo180_in);  
    int servo360_valor = analogRead(servo360_in);  
    int sensor_valor = analogRead(sensor_in);    
  
    Serial.print("Zumbador: ");
    Serial.print(zumbador_valor);
    Serial.print("  Led: ");
    Serial.print(led_valor);
    Serial.print("  Servo180: ");
    Serial.print(servo180_valor);
    Serial.print("  Servo360: ");
    Serial.print(servo360_valor);
    Serial.print("  Sensor: ");
    Serial.println(sensor_valor);
    delay(500); 
    
    if(zumbador_valor > 600){
      digitalWrite(zumbador, HIGH);
    } 
    else {
      digitalWrite(zumbador, LOW);
    }

    if((led_valor > 600) || (sensor_valor > 600) ){
      digitalWrite(led, HIGH);
    } 
    else {
      digitalWrite(led, LOW);
    }

    if(servo180_valor > 600){
      servo180.write(30);
    } 
    else {
      servo180.write(120);
    }

    if(servo360_valor > 600){
      servo360.write(75);
    } 
    else {
      servo360.write(90);
    }  
} 
