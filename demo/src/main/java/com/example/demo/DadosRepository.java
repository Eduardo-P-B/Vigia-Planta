package com.example.demo;

import org.springframework.data.jpa.repository.JpaRepository;

public interface DadosRepository extends JpaRepository<Dados, Long> {
    //repository.save(dados); salva o dado no banco
}