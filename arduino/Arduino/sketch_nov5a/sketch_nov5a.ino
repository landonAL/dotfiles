#include <DFRobotDFPlayerMini.h>
#include <SoftwareSerial.h>

DFRobotDFPlayerMini player;
SoftwareSerial serialSpeaker(10, 11);

int track = 1, trackTotal = 6;

void setup() {
  Serial.begin(9600);
  serialSpeaker.begin(9600);
}

void loop() {
  if (player.begin(serialSpeaker)) Serial.println("Player Online");
  else Serial.println("Player Not Found");

  Serial.println(track);

  player.volume(28);
  player.play(track);
  track++;
  delay(5000);

  if (track > trackTotal) track = 1;
}
