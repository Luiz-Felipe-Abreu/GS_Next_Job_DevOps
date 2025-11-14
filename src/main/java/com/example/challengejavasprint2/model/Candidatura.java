package com.example.challengejavasprint2.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "candidaturas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Candidatura {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;
    
    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;
    
    @ManyToOne
    @JoinColumn(name = "vaga_id", nullable = false)
    private Vaga vaga;
    
    @Column(length = 50)
    private String status = "ENVIADA";
    
    @Column(name = "curriculo_url", columnDefinition = "TEXT")
    private String curriculoUrl;
    
    @Column(name = "carta_apresentacao", columnDefinition = "TEXT")
    private String cartaApresentacao;
    
    @Column(name = "match_score", precision = 5, scale = 2)
    private BigDecimal matchScore;
    
    @Column(name = "data_candidatura")
    private LocalDateTime dataCandidatura = LocalDateTime.now();
    
    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao = LocalDateTime.now();
}
