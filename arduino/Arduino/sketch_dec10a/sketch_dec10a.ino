#define PSP A0

void setup() {
  pinMode(PSP, INPUT);
  Serial.begin(9600);
}

void loop() {
  float voltage = analogRead(PSP) * (5.0 / 1023.0);
  Serial.println(voltage);
}
