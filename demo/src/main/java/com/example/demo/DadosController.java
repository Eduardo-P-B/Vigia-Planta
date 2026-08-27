package com.example.demo;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class DadosController {

    private final DadosRepository repository;

    public DadosController(DadosRepository repository) {
        this.repository = repository;
    }

    @PostMapping("/dados")
    public Dados receberDados(@RequestBody Dados dados) {
        return repository.save(dados);
    }
}