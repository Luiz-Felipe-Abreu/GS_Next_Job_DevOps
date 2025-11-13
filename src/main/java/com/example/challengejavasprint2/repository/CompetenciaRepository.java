package com.example.challengejavasprint2.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.challengejavasprint2.model.Competencia;

@Repository
public interface CompetenciaRepository extends JpaRepository<Competencia, UUID> {
    
    Optional<Competencia> findByNome(String nome);
    
    boolean existsByNome(String nome);
}
