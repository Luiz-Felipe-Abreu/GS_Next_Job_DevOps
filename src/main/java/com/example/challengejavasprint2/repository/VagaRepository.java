package com.example.challengejavasprint2.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.challengejavasprint2.model.Vaga;

@Repository
public interface VagaRepository extends JpaRepository<Vaga, UUID> {

    List<Vaga> findByStatus(String status);

    List<Vaga> findByEmpresaId(UUID empresaId);

    List<Vaga> findByTituloContainingIgnoreCase(String titulo);

    List<Vaga> findByCidade(String cidade);

    List<Vaga> findByModalidade(String modalidade);

    List<Vaga> findByNivelExperiencia(String nivelExperiencia);

    @Query("SELECT COUNT(v) FROM Vaga v WHERE v.status = ?1")
    long countByStatus(String status);

    @Query("SELECT COUNT(v) FROM Vaga v WHERE v.empresa.id = ?1")
    long countByEmpresaId(UUID empresaId);

    @Query("SELECT v FROM Vaga v WHERE v.status = 'ABERTA' ORDER BY v.dataPublicacao DESC")
    List<Vaga> findVagasAtivas();
}
