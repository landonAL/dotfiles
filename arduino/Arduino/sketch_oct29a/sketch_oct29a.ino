#include <DFRobotDFPlayerMini.h>

int track = 1, totalTracks = 2;
DFRobotDFPlayerMini player;

void setup() {
  Serial.begin(9600);

  float timer = millis();
  player.volume(20);
  
  while (!player.begin(Serial)) {
    delay(1000);
    Serial.println("Searching for DF player...");

    if (timer > 20000) break;
  }
}

void loop() {
  player.play(track);
  delay(1000);
  track++;

  if (track > totalTracks) track = 1;
}
