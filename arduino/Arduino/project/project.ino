// Panasonic sensor detects hand distance. When close enough, box lid will jump open (spring?) and roar at you.
// Speaker: 2-3 watts, 8 ohms
// MicroSD with SD adapter
// 3-4 batteries taped together and connected in series

#include <Servo.h>
#include <DFRobotDFPlayerMini.h>
#include <SoftwareSerial.h>

#define BP 8
#define MP 3
#define TP 6
#define EP 7

DFRobotDFPlayerMini player;
SoftwareSerial serialSpeaker(10, 11);

Servo motor;

int track = 1, trackTotal = 6;
bool buttonState = false, buttonReading = false, buttonPrev = false;
unsigned long time = 0, debounce = 200;

void setup() {
  Serial.begin(9600);
  serialSpeaker.begin(9600);

  if (!motor.attached()) motor.attach(MP); // if (!motor.attached() && motor.attach(MP)) Serial.println("Motor online");
  else if (!motor.attach(MP)) Serial.println("Motor not found");
  else Serial.println("Motor already connected");

  if (player.begin(serialSpeaker)) Serial.println("Player online");
  else Serial.println("Player not found");

  pinMode(BP, INPUT);
  pinMode(EP, INPUT);
  pinMode(TP, OUTPUT);
}

float sensor(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  return (pulseIn(echoPin, HIGH) * 0.0343) / 2;
}

void loop() {
  player.volume(28);

  buttonReading = digitalRead(BP);

  if (buttonReading == HIGH && buttonPrev == LOW && millis() - time > debounce) {
    if (buttonState == HIGH) buttonState = LOW;
    else buttonState = HIGH;

    time = millis();
  }

  float distance = sensor(TP, EP);
  Serial.println(distance);

  if (distance < 10 && distance > 0) {
    Serial.println("SCARE SCARE SCARE");
    player.play(track);
    motor.write(0);
    track++;
    delay(5000);
    buttonState = false;
  } else if (buttonState) {
    if (motor.read() == 45) motor.write(180);
    else motor.write(45);

    buttonState = false;
    delay(1000);
  }

  if (track > trackTotal) track = 1;
  buttonPrev = buttonReading;
}
