// MIT License
// 
// Copyright (c) 2020 Ken Fallon
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <ESP8266WiFi.h>

const char* wifi_ssid = "MY-SSID";
const char* wifi_password = "MY-WIFI-PASSWORD";

int scanner_lid = D5;

WiFiServer server(80);

void setup() 
{
  Serial.begin(9600);
  delay(10);
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(scanner_lid, INPUT);
  WiFi.begin(wifi_ssid, wifi_password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  server.begin();
  Serial.print("Assigned IPAddress : ");
  Serial.println(WiFi.localIP());
}

void loop() {
  WiFiClient client = server.available();
  if (!client) {
    return;
  }
  while(!client.available()){
    delay(1);
  }
  String request = client.readStringUntil('\r');
  client.flush();
  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: application/json");
  client.println(""); 
  client.print("{ \"closed\": ");
  scanner_lid_state(client);
  client.println("}");
  delay(1);
}

void scanner_lid_state(WiFiClient wificlient)
{
  if (digitalRead(scanner_lid)) 
  {
    wificlient.print("true");
    digitalWrite(LED_BUILTIN, HIGH);
  }
  else 
  {
    wificlient.print("false");
    digitalWrite(LED_BUILTIN, LOW);
  }
}
