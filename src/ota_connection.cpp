#include "../include/ota_connection.h"
#include <WiFi.h>
#include <ArduinoOTA.h>

void initOTA(const char *ssid, const char *password)
{
    // 1. Connect to your local Wi-Fi
    Serial.print("Connecting to Wi-Fi...");
    WiFi.mode(WIFI_STA);
    // WiFi.setTxPower(WIFI_POWER_11dBm);
    WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED)
    {
        delay(500);
        Serial.print(".");
    }

    Serial.println("\nWi-Fi Connected!");
    Serial.print("ESP32 IP Address: ");
    Serial.println(WiFi.localIP()); // YOU WILL NEED THIS IP ADDRESS LATER!

    // 2. Configure OTA settings
    // You can set a password here so nobody else can hijack your robot
    // ArduinoOTA.setPassword("my_robot_password");

    ArduinoOTA.onStart([]()
                       {
        String type;
        if (ArduinoOTA.getCommand() == U_FLASH) {
            type = "sketch";
        } 
        else { // U_SPIFFS
            type = "filesystem";
        }
        Serial.println("Start updating " + type); });

    ArduinoOTA.onEnd([]()
                     { Serial.println("\nOTA Update Complete!"); });

    ArduinoOTA.onProgress([](unsigned int progress, unsigned int total)
                          { Serial.printf("Progress: %u%%\r", (progress / (total / 100))); });

    ArduinoOTA.onError([](ota_error_t error)
                       {
        Serial.printf("Error[%u]: ", error);
        if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
        else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
        else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
        else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
        else if (error == OTA_END_ERROR) Serial.println("End Failed"); });

    // 3. Start the OTA listener
    ArduinoOTA.begin();
    Serial.println("OTA Ready. Waiting for wireless uploads...");
}

void handleOTA()
{
    // This needs to run constantly to check for incoming uploads
    ArduinoOTA.handle();
}