package com.example.demo;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class DadosController {

    private final DadosRepository repository;

    public DadosController(DadosRepository repository) {
        this.repository = repository;
    }

    @PostMapping("/dados")
    public Dados criarDados(@RequestBody Dados dados) {
        return repository.save(dados);
    }

    @PutMapping("/dados/{id}")
    public ResponseEntity<Dados> upsertDados(
            @PathVariable Long id,
            @RequestBody Dados dadosAtualizados) {

        boolean existe = repository.existsById(id);
        Dados dados;

        if (existe) {
            // Atualiza existente
            dados = repository.findById(id).get();
            dados.setTemperatura(dadosAtualizados.getTemperatura());
            dados.setUmidade(dadosAtualizados.getUmidade());
            dados.setLuzSolar(dadosAtualizados.getLuzSolar());
        } else {
            // Cria novo
            dados = new Dados();
            dados.setId(id);
            dados.setTemperatura(dadosAtualizados.getTemperatura());
            dados.setUmidade(dadosAtualizados.getUmidade());
            dados.setLuzSolar(dadosAtualizados.getLuzSolar());
        }

        Dados dadosSalvos = repository.save(dados);

        // Retorna 200 (OK) se atualizou ou 201 (Created) se criou
        if (existe) {
            return ResponseEntity.ok(dadosSalvos);
        } else {
            return ResponseEntity.status(HttpStatus.CREATED).body(dadosSalvos);
        }
    }
}