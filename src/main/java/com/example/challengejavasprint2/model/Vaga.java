package com.example.challengejavasprint2.model;

import java.math.BigDecimal;
import java.time.LocalDate;
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
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "vagas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Vaga {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;
    
    @ManyToOne
    @JoinColumn(name = "empresa_id", nullable = false)
    private Empresa empresa;
    
    @NotBlank(message = "Título é obrigatório")
    @Column(nullable = false)
    private String titulo;
    
    @Column(columnDefinition = "TEXT", nullable = false)
    private String descricao;
    
    @Column(columnDefinition = "TEXT")
    private String requisitos;
    
    @Column(name = "salario_min")
    private BigDecimal salarioMin;
    
    @Column(name = "salario_max")
    private BigDecimal salarioMax;
    
    @Column(name = "tipo_contrato", length = 50)
    private String tipoContrato;
    
    @Column(length = 50)
    private String modalidade;
    
    @Column(name = "nivel_experiencia", length = 50)
    private String nivelExperiencia;
    
    @Column(length = 100)
    private String cidade;
    
    @Column(length = 2)
    private String estado;
    
    @Column(length = 100)
    private String area;
    
    @Column(length = 50)
    private String status = "ABERTA";
    
    @Column(name = "data_publicacao")
    private LocalDate dataPublicacao = LocalDate.now();
    
    @Column(name = "data_expiracao")
    private LocalDate dataExpiracao;
    
    @Column(name = "data_criacao")
    private LocalDateTime dataCriacao = LocalDateTime.now();
    
    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao = LocalDateTime.now();
}
