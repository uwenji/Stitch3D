/*
    SPI Slave Demo Sketch
    Connect the SPI Master device to the following pins on the esp8266:

    GPIO    NodeMCU   Name  |   OPMM9
  ===================================
     15       D8       SS   |   D22
     13       D7      MOSI  |   D21
     12       D6      MISO  |   D20
     14       D5      SCK   |   D19

    Note: If the ESP is booting at a moment when the SPI Master has the Select line HIGH (deselected)
    the ESP8266 WILL FAIL to boot!
    See SPISlave_SafeMaster example for possible workaround

*/
#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <SoftwareSerial.h>
#include "SPISlave.h"
//setup the port
const char *ssid = "Schneider";
const char *password = "20191020";
IPAddress ip(192,168,10,22);
IPAddress gateway(192,168,10,1);
IPAddress subnet(255,255,255,0);
ESP8266WebServer server(80);

//=====================json setup=====================
struct Stitchbot {
  int id;
  int leftVelocity;
  int rightVelocity;
  int needlePosition;
  int stitchON;
};
Stitchbot bot = {0, 0, 0, 900, 0};
// check size_t:https://arduinojson.org/v6/assistant/
const size_t capacity = JSON_OBJECT_SIZE(5) + 100;
const char* json = "{\"id\":0,\"leftVelocity\":0,\"rightVelocity\":0,\"needlePosition\":900,\"stitchOn\":0}";
DynamicJsonDocument jdoc(capacity);

//======================end declare====================

void setup() {
  Serial.begin(115200);
  Serial.setDebugOutput(true);

  // WiFi setup
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(ip, gateway, subnet);

  WiFi.softAP(ssid, password);
  config_rest_server_routing();
  deserializeJson(jdoc, json);
  server.begin();

  // SPI slave setup
  // Setup SPI Slave registers and pins
  SPISlave.begin();

}

void loop() {
  spi_protocol();
  server.handleClient();
  
  
}

void spi_protocol(){
  SPISlave.onData([](uint8_t * data, size_t len) {
    String message = String((char *)data);
    (void) len;
    if (message.equals("Hello Slave!")) {
      SPISlave.setData("Hello Master!");
    } else if (message.equals("Update?")) {
      char answer[36];
      sprintf(answer, "0:%d&1:%d&2:%d&3:%d", bot.leftVelocity, bot.rightVelocity,bot.needlePosition, bot.stitchON);
      Serial.println(answer);
      SPISlave.setData(answer);
    } else {
      SPISlave.setData("Error");
    }
    Serial.printf("FromMaster: %s\n", (char *)data);
  });

  SPISlave.onDataSent([]() {
    Serial.println("Answer Sent");
  });
}

void config_rest_server_routing() {
  server.on("/", HTTP_GET, []() {server.send(200, "text/html", "I'm Schneider");});
  server.on("/velocity", HTTP_GET, get_bot);
  server.on("/velocity", HTTP_POST, post_put_bot);
  server.on("/velocity", HTTP_PUT, post_put_bot);
}

void get_bot(){
  String webPage;

  jdoc["id"] = bot.id;
  jdoc["rightVelocity"] = bot.rightVelocity;
  jdoc["leftVelocity"] = bot.leftVelocity;
  jdoc["needlePosition"] = bot.needlePosition;
  jdoc["stitchON"] = bot.stitchON;

  serializeJsonPretty( jdoc, webPage);
  server.send(200, "application/json", webPage);
  
}

void json_to_bot() {
  bot.id = (int)jdoc["id"];
  bot.rightVelocity = (int)jdoc["rightVelocity"];
  bot.leftVelocity = (int)jdoc["leftVelocity"];
  bot.needlePosition = (int)jdoc["needlePosition"];
  bot.stitchON = (int)jdoc["stitchON"];

  Serial.println(String(bot.leftVelocity) +","+ String(bot.rightVelocity) +","+ String(bot.needlePosition) +","+ String(bot.stitchON));
}

const String httpmethod[] = { "HTTP_ANY", "HTTP_GET", "HTTP_POST", "HTTP_PUT", "HTTP_PATCH", "HTTP_DELETE", "HTTP_OPTIONS" };

void post_put_bot(){
  const String& post_body = server.arg("plain");
  Serial.print("HTTP Method: ");
  Serial.println(httpmethod[server.method()]);

  auto error = deserializeJson(jdoc, post_body);
  json_to_bot();
  if (error) {
    Serial.print("deserializeJson() failed with code ");
    Serial.println(error.c_str());
    return;
  }
  else{
    if (server.method() == HTTP_POST) {
      if (jdoc["id"] >= 0 || jdoc["id"] == bot.id) {
        json_to_bot();
        server.send(200);
      }
      else if(jdoc["id"] < 0){
          server.send(404);
          }
    }
    else if (server.method() == HTTP_PUT) {
      if (jdoc["id"] == bot.id) {
        json_to_bot();
        server.send(200);
      }
      else{
        server.send(405);
        
      }
    }
  }
}
