#include <ESP8266WiFi.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>


const char* ssid = "EDUARDO HOST";
const char* password = "redeeduardo";


const char* host = "preteen-driving-echo.ngrok-free.dev";
const int port = 443;


void setup() {
  Serial.begin(9600);
  delay(1000);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  WiFiClientSecure client;

  client.setInsecure();
  client.setTimeout(15000);


  Serial.println();
  Serial.println("Conectando ao ngrok...");


  if (!client.connect(host, port)) {
    Serial.println("FALHA ao conectar!");
    return;
  }


  Serial.println("HTTPS conectado!");


  StaticJsonDocument<200> doc;


  doc["temperatura"] = 25.5;
  doc["umidade"] = 60.0;
  doc["luzSolar"] = 800.0;


  String json;
  serializeJson(doc, json);


  Serial.println();
  Serial.println("--- ENVIANDO ---");
  Serial.println("PUT /api/dados/3");
  Serial.println("Dados: " + json);


  client.println("PUT /api/dados/3 HTTP/1.1");
  client.println("Host: preteen-driving-echo.ngrok-free.dev");
  client.println("Content-Type: application/json");
  client.print("Content-Length: ");
  client.println(json.length());
  client.println("Connection: close");
  client.println();
  client.println(json);


  Serial.println();
  Serial.println("--- RESPOSTA ---");


  unsigned long inicio = millis();


  while (client.connected() && millis() - inicio < 15000) {


    while (client.available()) {
      String linha = client.readStringUntil('\n');
      Serial.println(linha);


      inicio = millis();
    }
  }


  client.stop();
  Serial.println();
  Serial.println("--- FIM ---");
}


void loop() {
}


