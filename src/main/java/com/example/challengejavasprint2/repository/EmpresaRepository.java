package com.example.challengejavasprint2.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.challengejavasprint2.model.Empresa;

@Repository
public interface EmpresaRepository extends JpaRepository<Empresa, UUID> {
    
    Optional<Empresa> findByCnpj(String cnpj);
    
    boolean existsByCnpj(String cnpj);
}
