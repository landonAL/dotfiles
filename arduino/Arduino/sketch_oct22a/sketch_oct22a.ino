#include <Stepper.h>

int in1 = 11, 
    in2 = 10, 
    in3 = 9, 
    in4 = 8, 
    spr = 2048, 
    rpm = 10;

Stepper motor(spr, in1, in2, in3, in4);

void setup() {
  motor.setSpeed(rpm);
}

void loop() {
  motor.step(2 * spr);
  delay(400);
  motor.step(-2 * spr);
  delay(400);
}
