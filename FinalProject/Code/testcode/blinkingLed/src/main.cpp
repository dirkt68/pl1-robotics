#include <Arduino.h>

#define LED_CHOICE 3

#define REDLED 2
#define BLUELED 3

int value = 0;

void setup() {
  Serial.begin(9600);
  pinMode(REDLED, OUTPUT);
  pinMode(BLUELED, OUTPUT);
  Serial.println("Device Initialized");
}

void loop() {
  if (LED_CHOICE == 2){
    noTone(BLUELED);
    tone(REDLED, 1000);
  }
  else if (LED_CHOICE == 3){
    noTone(REDLED);
    tone(BLUELED, 300);
  }
}
