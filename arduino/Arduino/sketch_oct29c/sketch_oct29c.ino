#define LED 7

void setup() {
  pinMode(LED, INPUT);
  Serial.begin(9600);
}

void loop() {
  int now = millis();

  if (abs(now) % 2000 <= 50) {
    digitalWrite(LED, HIGH);
    Serial.println("HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASDASDSADASDAds");
  } else digitalWrite(LED, LOW);

  Serial.println(now);
}
