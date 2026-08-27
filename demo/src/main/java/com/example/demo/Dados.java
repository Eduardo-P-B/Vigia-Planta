package com.example.demo;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Dados {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private Double temperatura;

    private Double umidade;

    @Column(name = "luz_solar")
    private Double luzSolar;

    public Dados() {
    }

    public int getId() {
        return id;
    }

    public Double getTemperatura() {
        return temperatura;
    }

    public void setTemperatura(Double temperatura) {
        this.temperatura = temperatura;
    }

    public Double getUmidade() {
        return umidade;
    }

    public void setUmidade(Double umidade) {
        this.umidade = umidade;
    }

    public Double getLuzSolar() {
        return luzSolar;
    }

    public void setLuzSolar(Double luzSolar) {
        this.luzSolar = luzSolar;
    }
}