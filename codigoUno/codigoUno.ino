String mensagem;
int numero;

void setup() {
  Serial.begin(9600);
  digitalWrite(6, LOW);
}

void loop() {
  Serial.println(analogRead(A0));
  if(Serial.available() > 0){
    mensagem = Serial.readStringUntil('\n');
    numero = mensagem.toInt();
    if(numero == 1023){
      digitalWrite(6, HIGH);
    }
    else{
      digitalWrite(6, LOW);
    }
  }
  delay(1000);
}
