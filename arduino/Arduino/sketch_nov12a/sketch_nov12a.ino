#include <Servo.h>

#define MP 10

Servo motor;

void setup() {
  motor.attach(MP);
  Serial.begin(9600);
}

int pos;
bool rotated = false;

void loop() {
  if (!rotated) {
    for (pos = 0; pos <= 60; pos++) {
      motor.write(pos);
      delay(1);
      if (pos == 60) rotated = true;
      Serial.print(pos);
      Serial.println(" 1");
    }
  }

  if (rotated) {
    for (pos = 60; pos >= 0; pos--) {
      motor.write(pos);
      delay(1);
      if (pos == 0) rotated = false;
      Serial.print(pos);
      Serial.println(" 2");
    }
  }
}
