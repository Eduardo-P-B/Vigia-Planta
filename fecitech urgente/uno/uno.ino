#include "DHT.h"


#define DHTPIN 9     // Pino digital conectado ao DATA do sensor
#define DHTTYPE DHT11   // Definindo o modelo como DHT11
int umidade = 0;
int envio = 0;
int dump = 0;


DHT dht(DHTPIN, DHTTYPE);




void setup() {
  Serial.begin(9600);
  dht.begin();
}


void loop() {
 
  float temperatura = dht.readTemperature();
  umidade = analogRead(A0);


  // Verifica se alguma leitura falhou
  if (isnan(temperatura)) {
    Serial.println("Falha ao ler o sensor DHT11!");
    return;
  }


  envio = 0;


  Serial.println(temperatura);
  do{
    if(Serial.available() > 0){
      dump = Serial.read();
      if(dump == 49){
        envio = 1;
      }
    }
    delay(300);
  }while(envio == 0);


  envio = 0;


  Serial.println(umidade);
  do{
    if(Serial.available() > 0){
      dump = Serial.read();
      if(dump == 50){
        envio = 1;
      }
    }
    delay(100);
  }while(envio == 0);


  delay(300);
}
