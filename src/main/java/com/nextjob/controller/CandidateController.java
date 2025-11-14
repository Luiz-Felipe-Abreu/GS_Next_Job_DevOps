package com.nextjob.controller;

import com.nextjob.model.Candidate;
import com.nextjob.repository.CandidateRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/candidates")
public class CandidateController {

    private final CandidateRepository repo;

    public CandidateController(CandidateRepository repo) { this.repo = repo; }

    @GetMapping
    public List<Candidate> list() { return repo.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Candidate> get(@PathVariable Long id) {
        return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Candidate> create(@Valid @RequestBody Candidate candidate) {
        // basic uniqueness check
        if (candidate.getEmail() != null && repo.findByEmail(candidate.getEmail()).isPresent()) {
            return ResponseEntity.badRequest().build();
        }
        Candidate saved = repo.save(candidate);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Candidate> update(@PathVariable Long id, @Valid @RequestBody Candidate candidate) {
        return repo.findById(id).map(existing -> {
            existing.setFullName(candidate.getFullName());
            existing.setEmail(candidate.getEmail());
            existing.setSkills(candidate.getSkills());
            repo.save(existing);
            return ResponseEntity.ok(existing);
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return repo.findById(id).map(existing -> {
            repo.delete(existing);
            return ResponseEntity.noContent().<Void>build();
        }).orElse(ResponseEntity.notFound().build());
    }
}
