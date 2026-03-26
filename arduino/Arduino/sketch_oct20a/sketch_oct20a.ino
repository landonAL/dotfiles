#define EP 5
#define in1P 7
#define in2P 8

void setup() {
  pinMode(EP, OUTPUT);
  pinMode(in1P, OUTPUT);
  pinMode(in2P, OUTPUT);

  digitalWrite(in1P, LOW);
  digitalWrite(in2P, LOW);
}

int speed = 0;

void loop() {
  digitalWrite(in1P, HIGH);
  digitalWrite(in2P, LOW);
  
  for (int i = 0; i < 200; i += 10) {
    speed = map(i, 0, 1023, 0, 255);
    digitalWrite(EP, speed);
    delay(500);
  }

  digitalWrite(EP, 0);
}
