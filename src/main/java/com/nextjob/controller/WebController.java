package com.nextjob.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controller para servir páginas web da aplicação NextJob
 * Gerencia navegação entre diferentes páginas HTML
 */
@Controller
public class WebController {

    @GetMapping("/")
    public String home() {
        return "index";
    }

    @GetMapping("/candidates")
    public String candidates() {
        return "candidates";
    }

    @GetMapping("/vacancies")
    public String vacancies() {
        return "vacancies";
    }
}
