#define ECHO 9
#define TRIG 10
// #define RP A0
// #define GP A1
// #define BP A2
#define BZP 6
#define PP 3

void setup() {
  pinMode(ECHO, INPUT);
  pinMode(TRIG, OUTPUT);
  // pinMode(RP, INPUT);
  // pinMode(GP, INPUT);
  // pinMode(BP, INPUT);
  pinMode(BZP, OUTPUT);
  pinMode(PP, INPUT);
  Serial.begin(9600);
}

// void changeColor(int red, int green, int blue) {
//   digitalWrite(RP, red);
//   digitalWrite(GP, green);
//   digitalWrite(BP, blue);
// }

void buzz(uint8_t pin, int frequency, int duration) {
  analogWrite(BZP, analogRead(PP));

  tone(pin, frequency);
  delay(duration * 30);
  noTone(pin);
  delay(duration * 30);
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

  // if (distanceCM < 10) changeColor(125, 0, 0);
  // else if (distanceCM >= 10 && distanceCM < 20) changeColor(0, 125, 0);
  // else if (distanceCM >= 20 && distanceCM < 50) changeColor(0, 0, 125);

  if (distanceCM < 10) { buzz(BZP, 1000, distanceCM); }
  else if (distanceCM >= 10 && distanceCM < 20) { buzz(BZP, 1000, distanceCM); }
  else if (distanceCM >= 20 && distanceCM < 50) { buzz(BZP, 1000, distanceCM); }
  else if (distanceCM >= 50) { buzz(BZP, 1000, distanceCM); }

  Serial.print("dCM=");
  Serial.print(distanceCM);
  Serial.print(" dIN=");
  Serial.println(distanceIN);
}
