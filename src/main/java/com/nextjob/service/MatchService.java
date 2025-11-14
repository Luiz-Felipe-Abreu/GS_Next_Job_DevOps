package com.nextjob.service;

import com.nextjob.model.Candidate;
import com.nextjob.model.Vacancy;
import org.springframework.stereotype.Service;
import java.util.Set;
import java.util.HashSet;
import java.util.List;

@Service
public class MatchService {

    // Simple compatibility: percentage of vacancy required skills that candidate has
    public int calculateCompatibility(Candidate candidate, Vacancy vacancy) {
        List<String> candSkills = candidate.getSkills();
        List<String> vacSkills = vacancy.getRequiredSkills();
        if (vacSkills == null || vacSkills.isEmpty()) return 100;
        if (candSkills == null || candSkills.isEmpty()) return 0;

        Set<String> candSet = new HashSet<>();
        for (String s : candSkills) candSet.add(s.trim().toLowerCase());
        int matched = 0;
        for (String s : vacSkills) {
            if (s == null) continue;
            if (candSet.contains(s.trim().toLowerCase())) matched++;
        }
        return (int) Math.round( (matched * 100.0) / vacSkills.size() );
    }
}
