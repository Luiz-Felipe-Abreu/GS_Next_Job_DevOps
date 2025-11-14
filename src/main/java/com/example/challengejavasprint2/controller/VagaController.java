package com.example.challengejavasprint2.controller;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.challengejavasprint2.model.Vaga;
import com.example.challengejavasprint2.repository.VagaRepository;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/vagas")
public class VagaController {

    @Autowired
    private VagaRepository vagaRepository;

    // CREATE - Criar nova vaga
    @PostMapping
    public ResponseEntity<Vaga> create(@Valid @RequestBody Vaga vaga) {
        vaga.setDataCriacao(LocalDateTime.now());
        vaga.setDataAtualizacao(LocalDateTime.now());
        Vaga saved = vagaRepository.save(vaga);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    // READ - Listar todas as vagas
    @GetMapping
    public ResponseEntity<List<Vaga>> getAll(@RequestParam(required = false) String status) {
        List<Vaga> vagas;
        if (status != null && !status.isEmpty()) {
            vagas = vagaRepository.findByStatus(status);
        } else {
            vagas = vagaRepository.findAll();
        }
        return ResponseEntity.ok(vagas);
    }

    // READ - Buscar vaga por ID
    @GetMapping("/{id}")
    public ResponseEntity<Vaga> getById(@PathVariable UUID id) {
        return vagaRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // READ - Buscar vagas ativas
    @GetMapping("/ativas")
    public ResponseEntity<List<Vaga>> getVagasAtivas() {
        List<Vaga> vagas = vagaRepository.findVagasAtivas();
        return ResponseEntity.ok(vagas);
    }

    // READ - Buscar vagas por empresa
    @GetMapping("/empresa/{empresaId}")
    public ResponseEntity<List<Vaga>> getByEmpresa(@PathVariable UUID empresaId) {
        List<Vaga> vagas = vagaRepository.findByEmpresaId(empresaId);
        return ResponseEntity.ok(vagas);
    }

    // READ - Buscar vagas por cidade
    @GetMapping("/cidade/{cidade}")
    public ResponseEntity<List<Vaga>> getByCidade(@PathVariable String cidade) {
        List<Vaga> vagas = vagaRepository.findByCidade(cidade);
        return ResponseEntity.ok(vagas);
    }

    // UPDATE - Atualizar vaga
    @PutMapping("/{id}")
    public ResponseEntity<Vaga> update(@PathVariable UUID id, @Valid @RequestBody Vaga vaga) {
        return vagaRepository.findById(id)
                .map(existing -> {
                    vaga.setId(id);
                    vaga.setDataCriacao(existing.getDataCriacao());
                    vaga.setDataAtualizacao(LocalDateTime.now());
                    Vaga updated = vagaRepository.save(vaga);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // DELETE - Deletar vaga
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        if (!vagaRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        vagaRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
