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
import org.springframework.web.bind.annotation.RestController;

import com.example.challengejavasprint2.model.Competencia;
import com.example.challengejavasprint2.repository.CompetenciaRepository;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/competencias")
public class CompetenciaController {

    @Autowired
    private CompetenciaRepository competenciaRepository;

    // CREATE - Criar nova competência
    @PostMapping
    public ResponseEntity<Competencia> create(@Valid @RequestBody Competencia competencia) {
        if (competenciaRepository.existsByNome(competencia.getNome())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        competencia.setDataCriacao(LocalDateTime.now());
        Competencia saved = competenciaRepository.save(competencia);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    // READ - Listar todas as competências
    @GetMapping
    public ResponseEntity<List<Competencia>> getAll() {
        List<Competencia> competencias = competenciaRepository.findAll();
        return ResponseEntity.ok(competencias);
    }

    // READ - Buscar competência por ID
    @GetMapping("/{id}")
    public ResponseEntity<Competencia> getById(@PathVariable UUID id) {
        return competenciaRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // READ - Buscar competência por nome
    @GetMapping("/nome/{nome}")
    public ResponseEntity<Competencia> getByNome(@PathVariable String nome) {
        return competenciaRepository.findByNome(nome)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // UPDATE - Atualizar competência
    @PutMapping("/{id}")
    public ResponseEntity<Competencia> update(@PathVariable UUID id, @Valid @RequestBody Competencia competencia) {
        return competenciaRepository.findById(id)
                .map(existing -> {
                    competencia.setId(id);
                    competencia.setDataCriacao(existing.getDataCriacao());
                    Competencia updated = competenciaRepository.save(competencia);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // DELETE - Deletar competência
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        if (!competenciaRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        competenciaRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
