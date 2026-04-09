#include "Arduino.h"
#include "../include/ota_connection.h"
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <WiFi.h>

// const char *WIFI_SSID = "Nha Tin Anh_5G";
// const char *WIFI_PASS = "";

int temp = 2;

bool isBlocked = false;
unsigned long lastDetectionTime = 0;

void setup()
{
    Serial.begin(115200);
    pinMode(15, INPUT);
    pinMode(14, INPUT);

    Serial.println("Thiet lap cam bien laser");
}

void loop()
{
    // handleOTA();

    int laserState1 = digitalRead(15);
    int laserState2 = digitalRead(14);

    // unsigned long currentTime = millis();

    // // If the sensor sees ANY IR pulse (Reads LOW)
    // if (laserState == LOW)
    // {
    //     if (!isBlocked)
    //     {
    //         Serial.println(laserState);
    //         isBlocked = true;
    //     }
    //     // Reset the timer every time we see a pulse
    //     lastDetectionTime = currentTime;
    // }

    // // If the sensor reads HIGH, check if enough time has passed to be sure
    // if (laserState == HIGH && isBlocked)
    // {
    //     if (currentTime - lastDetectionTime > 100)
    //     {
    //         Serial.println(laserState);
    //         isBlocked = false;
    //     }
    // }
    Serial.printf("State: %d%d\n", laserState1, laserState2);
    // A tiny delay to keep the ESP32 from freezing
    delay(1);
}