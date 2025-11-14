package com.nextjob.service;

import com.nextjob.model.Candidate;
import com.nextjob.model.Vacancy;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Testes unitários para o MatchService
 * Valida o cálculo de compatibilidade entre candidatos e vagas
 */
@SpringBootTest
class MatchServiceTest {

    @Autowired
    private MatchService matchService;

    @Test
    @DisplayName("Deve retornar 100% quando candidato tem todas as habilidades da vaga")
    void testPerfectMatch() {
        // Arrange
        Candidate candidate = new Candidate();
        candidate.setFullName("João Silva");
        candidate.setEmail("joao@test.com");
        candidate.setSkills(Arrays.asList("Java", "Spring Boot", "PostgreSQL", "Docker"));

        Vacancy vacancy = new Vacancy();
        vacancy.setTitle("Dev Java");
        vacancy.setRequiredSkills(Arrays.asList("Java", "Spring Boot", "PostgreSQL"));

        // Act
        int compatibility = matchService.calculateCompatibility(candidate, vacancy);

        // Assert
        assertEquals(100, compatibility, "Compatibilidade deve ser 100%");
    }

    @Test
    @DisplayName("Deve retornar 0% quando candidato não tem nenhuma habilidade da vaga")
    void testNoMatch() {
        // Arrange
        Candidate candidate = new Candidate();
        candidate.setFullName("Maria Santos");
        candidate.setEmail("maria@test.com");
        candidate.setSkills(Arrays.asList("Python", "Django", "MongoDB"));

        Vacancy vacancy = new Vacancy();
        vacancy.setTitle("Dev Java");
        vacancy.setRequiredSkills(Arrays.asList("Java", "Spring Boot", "PostgreSQL"));

        // Act
        int compatibility = matchService.calculateCompatibility(candidate, vacancy);

        // Assert
        assertEquals(0, compatibility, "Compatibilidade deve ser 0%");
    }

    @Test
    @DisplayName("Deve retornar 50% quando candidato tem metade das habilidades da vaga")
    void testPartialMatch() {
        // Arrange
        Candidate candidate = new Candidate();
        candidate.setFullName("Pedro Oliveira");
        candidate.setEmail("pedro@test.com");
        candidate.setSkills(Arrays.asList("Java", "Python", "React"));

        Vacancy vacancy = new Vacancy();
        vacancy.setTitle("Dev Full Stack");
        vacancy.setRequiredSkills(Arrays.asList("Java", "Spring Boot"));

        // Act
        int compatibility = matchService.calculateCompatibility(candidate, vacancy);

        // Assert
        assertEquals(50, compatibility, "Compatibilidade deve ser 50%");
    }

    @Test
    @DisplayName("Deve ignorar diferença de maiúsculas/minúsculas nas habilidades")
    void testCaseInsensitiveMatch() {
        // Arrange
        Candidate candidate = new Candidate();
        candidate.setFullName("Ana Costa");
        candidate.setEmail("ana@test.com");
        candidate.setSkills(Arrays.asList("java", "spring boot", "postgresql"));

        Vacancy vacancy = new Vacancy();
        vacancy.setTitle("Dev Java");
        vacancy.setRequiredSkills(Arrays.asList("Java", "Spring Boot", "PostgreSQL"));

        // Act
        int compatibility = matchService.calculateCompatibility(candidate, vacancy);

        // Assert
        assertEquals(100, compatibility, "Deve ignorar case das habilidades");
    }

    @Test
    @DisplayName("Deve retornar 100% quando vaga não tem habilidades requeridas")
    void testEmptyVacancySkills() {
        // Arrange
        Candidate candidate = new Candidate();
        candidate.setFullName("Carlos Ferreira");
        candidate.setEmail("carlos@test.com");
        candidate.setSkills(Arrays.asList("Java", "Spring Boot"));

        Vacancy vacancy = new Vacancy();
        vacancy.setTitle("Vaga Genérica");
        vacancy.setRequiredSkills(Arrays.asList());

        // Act
        int compatibility = matchService.calculateCompatibility(candidate, vacancy);

        // Assert
        assertEquals(100, compatibility, "Vaga sem requisitos deve retornar 100%");
    }

    @Test
    @DisplayName("Deve retornar 0% quando candidato não tem habilidades")
    void testEmptyCandidateSkills() {
        // Arrange
        Candidate candidate = new Candidate();
        candidate.setFullName("Laura Santos");
        candidate.setEmail("laura@test.com");
        candidate.setSkills(Arrays.asList());

        Vacancy vacancy = new Vacancy();
        vacancy.setTitle("Dev Java");
        vacancy.setRequiredSkills(Arrays.asList("Java", "Spring Boot", "PostgreSQL"));

        // Act
        int compatibility = matchService.calculateCompatibility(candidate, vacancy);

        // Assert
        assertEquals(0, compatibility, "Candidato sem habilidades deve retornar 0%");
    }

    @Test
    @DisplayName("Deve calcular percentual correto com múltiplas habilidades")
    void testComplexMatch() {
        // Arrange
        Candidate candidate = new Candidate();
        candidate.setFullName("Roberto Lima");
        candidate.setEmail("roberto@test.com");
        candidate.setSkills(Arrays.asList("Java", "Spring Boot", "Docker", "Python", "React"));

        Vacancy vacancy = new Vacancy();
        vacancy.setTitle("Arquiteto de Soluções");
        vacancy.setRequiredSkills(Arrays.asList("Java", "Spring Boot", "Docker", "Kubernetes", "Azure"));

        // Act
        int compatibility = matchService.calculateCompatibility(candidate, vacancy);

        // Assert - Candidato tem 3 de 5 habilidades = 60%
        assertEquals(60, compatibility, "Deve calcular 60% de compatibilidade");
    }

    @Test
    @DisplayName("Deve lidar com habilidades com espaços em branco")
    void testSkillsWithWhitespace() {
        // Arrange
        Candidate candidate = new Candidate();
        candidate.setFullName("Fernanda Alves");
        candidate.setEmail("fernanda@test.com");
        candidate.setSkills(Arrays.asList(" Java ", " Spring Boot ", " PostgreSQL "));

        Vacancy vacancy = new Vacancy();
        vacancy.setTitle("Dev Backend");
        vacancy.setRequiredSkills(Arrays.asList("Java", "Spring Boot", "PostgreSQL"));

        // Act
        int compatibility = matchService.calculateCompatibility(candidate, vacancy);

        // Assert
        assertEquals(100, compatibility, "Deve ignorar espaços em branco");
    }
}
