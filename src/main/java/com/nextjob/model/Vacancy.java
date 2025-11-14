package com.nextjob.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.util.List;
import java.util.ArrayList;

@Entity
public class Vacancy {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Size(max = 150)
    private String title;

    @Column(length = 2000)
    private String description;

    @ElementCollection
    @CollectionTable(name = "vacancy_skills", joinColumns = @JoinColumn(name = "vacancy_id"))
    @Column(name = "skill")
    private List<String> requiredSkills = new ArrayList<>();

    public Vacancy() {}

    // getters/setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<String> getRequiredSkills() { return requiredSkills; }
    public void setRequiredSkills(List<String> requiredSkills) { this.requiredSkills = requiredSkills; }
}
