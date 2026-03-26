#include <DHT11.h>

#define SP 10

DHT11 dht(SP);

void setup() {
  Serial.begin(9600);
}

void loop() {
  int temperature = 0;
  int humidity = 0;

  int result = dht.readTemperatureHumidity(temperature, humidity);

  if (result == 0) {
    Serial.print("Temperature: ");
    Serial.print((temperature * 1.8) + 32);
    Serial.print(" °F\nHumidity: ");
    Serial.print(humidity);
    Serial.println("%\n");
  } else Serial.println(DHT11::getErrorString(result));
}
