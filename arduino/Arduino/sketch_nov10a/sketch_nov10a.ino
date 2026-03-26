#include <Servo.h>

#define MP 10

Servo motor;

void setup() {
  if (!motor.attached()) motor.attach(MP);
}

int angle = 0;

void loop() {
  for (angle = 0; angle <= 180; angle += 1) {
    motor.write(angle);
    delay(15);
  }

  for (angle = 180; angle >= 0; angle -= 1) {
    motor.write(angle);
    delay(15);
  }
}
