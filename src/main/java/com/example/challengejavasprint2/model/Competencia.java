package com.example.challengejavasprint2.model;

import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "competencias")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Competencia {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;
    
    @NotBlank(message = "Nome é obrigatório")
    @Column(nullable = false, unique = true, length = 100)
    private String nome;
    
    @Column(length = 50)
    private String categoria;
    
    @Column(columnDefinition = "TEXT")
    private String descricao;
    
    @Column(name = "data_criacao")
    private LocalDateTime dataCriacao = LocalDateTime.now();
}
