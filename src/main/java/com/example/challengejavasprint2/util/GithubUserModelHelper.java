package com.example.challengejavasprint2.util;

import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;

public class GithubUserModelHelper {
    public static void addGithubUserInfo(Model model, Authentication authentication) {
        // OAuth2 removido - método mantido para compatibilidade mas não faz nada
        if (authentication != null) {
            model.addAttribute("userName", authentication.getName());
            model.addAttribute("userLogin", authentication.getName());
        }
    }

    public static String getGithubUsername(Authentication authentication) {
        if (authentication != null) {
            return authentication.getName();
        }
        return null;
    }

    public static String getGithubName(Authentication authentication) {
        if (authentication != null) {
            return authentication.getName();
        }
        return null;
    }
}