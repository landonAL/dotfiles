#define BP 4
#define B2P 2
#define LED 8
#define LED2 7

void setup() {
  pinMode(BP, INPUT_PULLUP);
  pinMode(B2P, INPUT_PULLUP);
  pinMode(LED, OUTPUT);
  pinMode(LED2, OUTPUT);
  Serial.begin(9600);
}

bool bp;
bool b2p;

void loop() {
  bp = digitalRead(BP);
  b2p = digitalRead(B2P);

  if (bp == LOW && b2p == HIGH) digitalWrite(LED, HIGH);
  else if (b2p == LOW && bp == HIGH) digitalWrite(LED2, HIGH);
  else {
    digitalWrite(LED, LOW);
    digitalWrite(LED2, LOW);
  }
}