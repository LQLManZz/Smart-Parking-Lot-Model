#ifndef OTA_CONNECTION_H
#define OTA_CONNECTION_H

#include <Arduino.h>

void initOTA(const char* ssid, const char* password);
void handleOTA();

#endif