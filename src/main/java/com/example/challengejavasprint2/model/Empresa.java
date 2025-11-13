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
@Table(name = "empresas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Empresa {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;
    
    @NotBlank(message = "Nome é obrigatório")
    @Column(nullable = false)
    private String nome;
    
    @NotBlank(message = "CNPJ é obrigatório")
    @Column(nullable = false, unique = true, length = 18)
    private String cnpj;
    
    @Column(columnDefinition = "TEXT")
    private String descricao;
    
    @Column(length = 100)
    private String setor;
    
    @Column(length = 500)
    private String website;
    
    @Column(name = "logo_url", columnDefinition = "TEXT")
    private String logoUrl;
    
    @Column(length = 500)
    private String endereco;
    
    @Column(length = 100)
    private String cidade;
    
    @Column(length = 2)
    private String estado;
    
    @Column(length = 20)
    private String telefone;
    
    @Column(length = 255)
    private String email;
    
    @Column(nullable = false)
    private Boolean ativo = true;
    
    @Column(name = "data_criacao")
    private LocalDateTime dataCriacao = LocalDateTime.now();
    
    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao = LocalDateTime.now();
}
