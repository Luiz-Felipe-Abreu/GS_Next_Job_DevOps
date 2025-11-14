package com.nextjob.controller;

import com.nextjob.model.Vacancy;
import com.nextjob.repository.VacancyRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/vacancies")
public class VacancyController {

    private final VacancyRepository repo;

    public VacancyController(VacancyRepository repo) { this.repo = repo; }

    @GetMapping
    public List<Vacancy> list() { return repo.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<Vacancy> get(@PathVariable Long id) {
        return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Vacancy> create(@Valid @RequestBody Vacancy vacancy) {
        Vacancy saved = repo.save(vacancy);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Vacancy> update(@PathVariable Long id, @Valid @RequestBody Vacancy vacancy) {
        return repo.findById(id).map(existing -> {
            existing.setTitle(vacancy.getTitle());
            existing.setDescription(vacancy.getDescription());
            existing.setRequiredSkills(vacancy.getRequiredSkills());
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
