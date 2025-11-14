package com.nextjob.config;

import com.nextjob.model.Candidate;
import com.nextjob.model.Vacancy;
import com.nextjob.repository.CandidateRepository;
import com.nextjob.repository.VacancyRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.List;

@Configuration
public class DataLoader {

    @Bean
    CommandLineRunner init(CandidateRepository candRepo, VacancyRepository vacRepo) {
        return args -> {
            if (candRepo.count() == 0) {
                candRepo.save(new Candidate("Luiz Felipe", "luiz@example.com", List.of("java","spring","sql")));
                candRepo.save(new Candidate("Ana Silva", "ana@example.com", List.of("python","ml","sql")));
            }
            if (vacRepo.count() == 0) {
                Vacancy v = new Vacancy();
                v.setTitle("Backend Java Developer");
                v.setDescription("Desenvolvedor backend com Spring Boot");
                v.setRequiredSkills(List.of("java","spring","docker"));
                vacRepo.save(v);
            }
        };
    }
}
