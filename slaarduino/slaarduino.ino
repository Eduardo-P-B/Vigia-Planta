#include <ESP8266WiFi.h>

const char* ssid = "EDUARDO HOST";
const char* senha = "cudadoobrigado";

void setup() {
  Serial.begin(115200);
  delay(100);

  Serial.println();
  Serial.print("Conectando em: ");
  Serial.println(ssid);

  WiFi.begin(ssid, senha);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println();
  Serial.println("WiFi conectado!");
  Serial.print("IP: ");
  Serial.println(WiFi.localIP());
  Serial.print("Sinal (RSSI): ");
  Serial.print(WiFi.RSSI());
  Serial.println(" dBm");
}

void loop() {
  // nada aqui, só testando conexão
}