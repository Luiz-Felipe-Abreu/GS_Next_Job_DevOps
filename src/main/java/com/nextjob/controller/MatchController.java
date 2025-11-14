package com.nextjob.controller;

import com.nextjob.model.Candidate;
import com.nextjob.model.Vacancy;
import com.nextjob.repository.CandidateRepository;
import com.nextjob.repository.VacancyRepository;
import com.nextjob.service.MatchService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/match")
public class MatchController {

    private final CandidateRepository candRepo;
    private final VacancyRepository vacRepo;
    private final MatchService matchService;

    public MatchController(CandidateRepository candRepo, VacancyRepository vacRepo, MatchService matchService) {
        this.candRepo = candRepo;
        this.vacRepo = vacRepo;
        this.matchService = matchService;
    }

    @PostMapping("/compatibility")
    public ResponseEntity<Map<String,Object>> compatibility(@RequestBody Map<String,Long> body) {
        Long candidateId = body.get("candidateId");
        Long vacancyId = body.get("vacancyId");
        if (candidateId == null || vacancyId == null) return ResponseEntity.badRequest().build();
        Candidate c = candRepo.findById(candidateId).orElse(null);
        Vacancy v = vacRepo.findById(vacancyId).orElse(null);
        if (c == null || v == null) return ResponseEntity.notFound().build();
        int score = matchService.calculateCompatibility(c, v);
        return ResponseEntity.ok(Map.of(
            "candidateId", candidateId,
            "vacancyId", vacancyId,
            "compatibility", score
        ));
    }
}
