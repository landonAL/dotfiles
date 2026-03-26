#define LED 8
#define TSP 3

void setup() {
  pinMode(LED, OUTPUT);
  pinMode(TSP, INPUT_PULLUP);

  digitalWrite(LED, LOW);
  Serial.begin(9600);
}

void loop() {
  digitalWrite(LED, digitalRead(TSP));
}
