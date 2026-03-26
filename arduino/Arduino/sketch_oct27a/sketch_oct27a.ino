#define LED 8
#define SENSOR 3

bool motionStatus = false, motionDetected = false;

void setup() {
  pinMode(SENSOR, INPUT);
  pinMode(LED, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  motionDetected = digitalRead(SENSOR);
  //Serial.println(motionDetected);

  if (motionDetected && !motionStatus) {
    Serial.println("Motion Detected");
    digitalWrite(LED, HIGH);
    motionStatus = true;
  } else if (!motionDetected && motionStatus) {
    Serial.println("Motion Ended");
    digitalWrite(LED, LOW);
    motionStatus = false;
  }
}
