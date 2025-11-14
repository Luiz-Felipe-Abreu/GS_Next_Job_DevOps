package com.nextjob.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nextjob.model.Candidate;
import com.nextjob.repository.CandidateRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.hamcrest.Matchers.*;

/**
 * Testes de integração para CandidateController
 * Valida operações CRUD da API REST
 */
@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class CandidateControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private CandidateRepository candidateRepository;

    @BeforeEach
    void setUp() {
        candidateRepository.deleteAll();
    }

    @Test
    @DisplayName("Deve listar todos os candidatos")
    void testListAllCandidates() throws Exception {
        // Arrange
        Candidate candidate = new Candidate("João Silva", "joao@test.com", Arrays.asList("Java", "Spring Boot"));
        candidateRepository.save(candidate);

        // Act & Assert
        mockMvc.perform(get("/api/candidates"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].fullName", is("João Silva")))
                .andExpect(jsonPath("$[0].email", is("joao@test.com")))
                .andExpect(jsonPath("$[0].skills", hasSize(2)));
    }

    @Test
    @DisplayName("Deve criar novo candidato")
    void testCreateCandidate() throws Exception {
        // Arrange
        Candidate newCandidate = new Candidate();
        newCandidate.setFullName("Maria Santos");
        newCandidate.setEmail("maria@test.com");
        newCandidate.setSkills(Arrays.asList("Python", "Django"));

        // Act & Assert
        mockMvc.perform(post("/api/candidates")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(newCandidate)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", notNullValue()))
                .andExpect(jsonPath("$.fullName", is("Maria Santos")))
                .andExpect(jsonPath("$.email", is("maria@test.com")));
    }

    @Test
    @DisplayName("Deve buscar candidato por ID")
    void testGetCandidateById() throws Exception {
        // Arrange
        Candidate candidate = new Candidate("Pedro Oliveira", "pedro@test.com", Arrays.asList("React", "JavaScript"));
        Candidate saved = candidateRepository.save(candidate);

        // Act & Assert
        mockMvc.perform(get("/api/candidates/" + saved.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.fullName", is("Pedro Oliveira")))
                .andExpect(jsonPath("$.email", is("pedro@test.com")));
    }

    @Test
    @DisplayName("Deve atualizar candidato existente")
    void testUpdateCandidate() throws Exception {
        // Arrange
        Candidate candidate = new Candidate("Ana Costa", "ana@test.com", Arrays.asList("Java"));
        Candidate saved = candidateRepository.save(candidate);

        Candidate updated = new Candidate();
        updated.setFullName("Ana Costa Atualizada");
        updated.setEmail("ana@test.com");
        updated.setSkills(Arrays.asList("Java", "Spring Boot", "Azure"));

        // Act & Assert
        mockMvc.perform(put("/api/candidates/" + saved.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updated)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.fullName", is("Ana Costa Atualizada")))
                .andExpect(jsonPath("$.skills", hasSize(3)));
    }

    @Test
    @DisplayName("Deve excluir candidato")
    void testDeleteCandidate() throws Exception {
        // Arrange
        Candidate candidate = new Candidate("Carlos Ferreira", "carlos@test.com", Arrays.asList("Docker"));
        Candidate saved = candidateRepository.save(candidate);

        // Act & Assert
        mockMvc.perform(delete("/api/candidates/" + saved.getId()))
                .andExpect(status().isNoContent());

        // Verificar que foi excluído
        mockMvc.perform(get("/api/candidates/" + saved.getId()))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("Deve retornar 404 ao buscar candidato inexistente")
    void testGetNonExistentCandidate() throws Exception {
        mockMvc.perform(get("/api/candidates/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("Deve retornar 400 ao tentar criar candidato com email duplicado")
    void testCreateDuplicateEmail() throws Exception {
        // Arrange
        Candidate existing = new Candidate("Laura Santos", "laura@test.com", Arrays.asList("Python"));
        candidateRepository.save(existing);

        Candidate duplicate = new Candidate();
        duplicate.setFullName("Outro Nome");
        duplicate.setEmail("laura@test.com");
        duplicate.setSkills(Arrays.asList("Java"));

        // Act & Assert
        mockMvc.perform(post("/api/candidates")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(duplicate)))
                .andExpect(status().isBadRequest());
    }
}
