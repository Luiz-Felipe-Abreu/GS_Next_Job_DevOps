package com.example.challengejavasprint2.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.challengejavasprint2.model.Candidatura;

@Repository
public interface CandidaturaRepository extends JpaRepository<Candidatura, UUID> {
    
    List<Candidatura> findByUsuarioId(UUID usuarioId);
    
    List<Candidatura> findByVagaId(UUID vagaId);
    
    boolean existsByUsuarioIdAndVagaId(UUID usuarioId, UUID vagaId);
}
