// #include <AccelStepper.h>
#include <Stepper.h>

#define IN1 2
#define IN2 3
#define IN3 4
#define IN4 5
#define BP1 9
#define BP2 10
#define FULLSTEP 4
#define STEP_PER_REVOLUTION 2048

// AccelStepper stepper(FULLSTEP, IN1, IN2, IN3, IN4);
Stepper stepper(FULLSTEP, IN1, IN3, IN2, IN4);

void setup() {
  pinMode(BP1, INPUT_PULLUP);
  pinMode(BP2, INPUT_PULLUP);
  Serial.begin(9600);
  // stepper.setMaxSpeed(10000.0);
  // stepper.setAcceleration(5000);
  stepper.setSpeed(5000);
  // stepper.setCurrentPosition(0);
  // stepper.moveTo(STEP_PER_REVOLUTION);
}

void loop() {
  if (digitalRead(BP1) && !digitalRead(BP2)) stepper.step(1);
  else if (digitalRead(BP2) && !digitalRead(BP1)) stepper.step(-1);
  else stepper.step(0);

  Serial.print(digitalRead(BP1));
  Serial.println();
  Serial.println(digitalRead(BP2));
  Serial.println();

  // Serial.print(F("Current Position: "));
  // Serial.println(stepper.currentPosition());
}
