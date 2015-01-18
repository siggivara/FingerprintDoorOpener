#include <Servo.h> 
#include "MsTimer2.h"

volatile int val;
int lastVal = 0;
volatile int counter = 0;
int didOpen = 0;
volatile int fallingEdgeCount = 0;

const int fingerprintPin = 2;
const int ledPin = 13;
const int servoPin = 9;

Servo myservo;  // create servo object to control a servo 
                // a maximum of eight servo objects can be created 
int servoStop = 93;  // Almost stops servo


void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(fingerprintPin, INPUT);
  pinMode(ledPin, OUTPUT);
  
  digitalWrite(ledPin, HIGH);
  delay(500);
  digitalWrite(ledPin, LOW);
  delay(500);
  digitalWrite(ledPin, HIGH);
  delay(500);
  digitalWrite(ledPin, LOW);

  Serial.begin(9600);  
  MsTimer2::set(20000, reset); // 7 sec period
  MsTimer2::start();
}

void loop() {
  val = digitalRead(fingerprintPin);
 
  if(val)
    counter++;
  
  if (lastVal && !val && didOpen != 1)
  {
    Serial.print("Gikk fra hoy til lav.\nCounter: ");
    Serial.println(counter);
    counter = 0;
    fallingEdgeCount++;
  }
  
  // Check if correct finger was used
 // if (counter > 40 && didOpen != 1)
  if (/*fallingEdgeCount > 5 || */(counter > 40 && didOpen != 1))
  {
   // if (didOpen == 0) {
      success(); 
      didOpen = 1;
    //}
  }
  
 /* if (val && counter) {
    Serial.print("Value: ");
    Serial.print(val);
    Serial.print("   Counter: ");
    Serial.println(counter);
  }
  */
  lastVal = val;
  delay(10);
}


void success() {
  myservo.attach(servoPin);
  open();  // Open door
  // Keep door open for 5 seconds and blink LED 
  Serial.println("Door open!!!"); 
  delay(2900);
  close(); // Close door
  myservo.detach();
  Serial.println("Door closed!!!");
}

void open() {
  digitalWrite(ledPin, HIGH);
  myservo.write(10);
  delay(2100);                   // Run clockwise for 2100 ms
  myservo.write(servoStop);      // Stall and hold door open
  digitalWrite(ledPin, LOW);
}

void close() {
  digitalWrite(ledPin, HIGH);
  myservo.write(150);   // Run counter-clockwise fo 1300 ms
  delay(1000);
  digitalWrite(ledPin, LOW);
}

void reset() {
  Serial.println("Resetting!!");
  val = counter = fallingEdgeCount = didOpen = 0; 
}
