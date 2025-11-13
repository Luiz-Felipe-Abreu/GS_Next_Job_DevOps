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

import com.example.challengejavasprint2.model.Empresa;
import com.example.challengejavasprint2.repository.EmpresaRepository;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/empresas")
public class EmpresaController {

    @Autowired
    private EmpresaRepository empresaRepository;

    // CREATE - Criar nova empresa
    @PostMapping
    public ResponseEntity<Empresa> create(@Valid @RequestBody Empresa empresa) {
        if (empresaRepository.existsByCnpj(empresa.getCnpj())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).build();
        }
        empresa.setDataCriacao(LocalDateTime.now());
        empresa.setDataAtualizacao(LocalDateTime.now());
        Empresa saved = empresaRepository.save(empresa);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    // READ - Listar todas as empresas
    @GetMapping
    public ResponseEntity<List<Empresa>> getAll() {
        List<Empresa> empresas = empresaRepository.findAll();
        return ResponseEntity.ok(empresas);
    }

    // READ - Buscar empresa por ID
    @GetMapping("/{id}")
    public ResponseEntity<Empresa> getById(@PathVariable UUID id) {
        return empresaRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // READ - Buscar empresa por CNPJ
    @GetMapping("/cnpj/{cnpj}")
    public ResponseEntity<Empresa> getByCnpj(@PathVariable String cnpj) {
        return empresaRepository.findByCnpj(cnpj)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // UPDATE - Atualizar empresa
    @PutMapping("/{id}")
    public ResponseEntity<Empresa> update(@PathVariable UUID id, @Valid @RequestBody Empresa empresa) {
        return empresaRepository.findById(id)
                .map(existing -> {
                    empresa.setId(id);
                    empresa.setDataCriacao(existing.getDataCriacao());
                    empresa.setDataAtualizacao(LocalDateTime.now());
                    Empresa updated = empresaRepository.save(empresa);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // DELETE - Deletar empresa
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        if (!empresaRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        empresaRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
