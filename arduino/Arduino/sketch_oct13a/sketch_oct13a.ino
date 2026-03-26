#include <Stepper.h>

#define TRIG A0
#define ECHO A1

int rpm, spr = 2048;
Stepper motor(spr, 8, 10, 9, 11);

void setup() {
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  motor.setSpeed(10);
  Serial.begin(9600);
}

void spinMotor(int rot, int seg) {
  motor.setSpeed(rot);

  motor.step(seg);
  // delay(500);
  motor.step(-seg);
  // delay(500);
}

float duration, distanceCM, distanceIN;

void loop() {
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);

  duration = pulseIn(ECHO, HIGH);
  distanceCM = (0.0343 * duration) / 2;
  distanceIN = distanceCM / 2.54;
  
  rpm = distanceCM * 2;
  rpm = map(rpm, 0, 15, 0, distanceCM);

  spinMotor(rpm, spr);
}
