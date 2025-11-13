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

import com.example.challengejavasprint2.model.Candidatura;
import com.example.challengejavasprint2.repository.CandidaturaRepository;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/candidaturas")
public class CandidaturaController {

    @Autowired
    private CandidaturaRepository candidaturaRepository;

    // CREATE - Criar nova candidatura
    @PostMapping
    public ResponseEntity<Candidatura> create(@Valid @RequestBody Candidatura candidatura) {
        if (candidaturaRepository.existsByUsuarioIdAndVagaId(
                candidatura.getUsuario().getId(), 
                candidatura.getVaga().getId())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        candidatura.setDataCandidatura(LocalDateTime.now());
        candidatura.setDataAtualizacao(LocalDateTime.now());
        Candidatura saved = candidaturaRepository.save(candidatura);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    // READ - Listar todas as candidaturas
    @GetMapping
    public ResponseEntity<List<Candidatura>> getAll() {
        List<Candidatura> candidaturas = candidaturaRepository.findAll();
        return ResponseEntity.ok(candidaturas);
    }

    // READ - Buscar candidatura por ID
    @GetMapping("/{id}")
    public ResponseEntity<Candidatura> getById(@PathVariable UUID id) {
        return candidaturaRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // READ - Buscar candidaturas por usuário
    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<Candidatura>> getByUsuario(@PathVariable UUID usuarioId) {
        List<Candidatura> candidaturas = candidaturaRepository.findByUsuarioId(usuarioId);
        return ResponseEntity.ok(candidaturas);
    }

    // READ - Buscar candidaturas por vaga
    @GetMapping("/vaga/{vagaId}")
    public ResponseEntity<List<Candidatura>> getByVaga(@PathVariable UUID vagaId) {
        List<Candidatura> candidaturas = candidaturaRepository.findByVagaId(vagaId);
        return ResponseEntity.ok(candidaturas);
    }

    // UPDATE - Atualizar candidatura
    @PutMapping("/{id}")
    public ResponseEntity<Candidatura> update(@PathVariable UUID id, @Valid @RequestBody Candidatura candidatura) {
        return candidaturaRepository.findById(id)
                .map(existing -> {
                    candidatura.setId(id);
                    candidatura.setDataCandidatura(existing.getDataCandidatura());
                    candidatura.setDataAtualizacao(LocalDateTime.now());
                    Candidatura updated = candidaturaRepository.save(candidatura);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // DELETE - Deletar candidatura
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        if (!candidaturaRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        candidaturaRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
