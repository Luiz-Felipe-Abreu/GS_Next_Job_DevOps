-- ============================================
-- NextJob Database Schema
-- Sistema de Gestão de Carreira e Matches
-- ============================================

-- Criar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- Tabela: Candidate (Candidatos)
-- ============================================
CREATE TABLE IF NOT EXISTS candidate (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para otimização
CREATE INDEX idx_candidate_email ON candidate(email);
CREATE INDEX idx_candidate_name ON candidate(full_name);

-- ============================================
-- Tabela: candidate_skills (Habilidades dos Candidatos)
-- ============================================
CREATE TABLE IF NOT EXISTS candidate_skills (
    candidate_id BIGINT NOT NULL,
    skill VARCHAR(255) NOT NULL,
    FOREIGN KEY (candidate_id) REFERENCES candidate(id) ON DELETE CASCADE
);

-- Índices para otimização
CREATE INDEX idx_candidate_skills_id ON candidate_skills(candidate_id);
CREATE INDEX idx_candidate_skills_skill ON candidate_skills(skill);

-- ============================================
-- Tabela: Vacancy (Vagas)
-- ============================================
CREATE TABLE IF NOT EXISTS vacancy (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para otimização
CREATE INDEX idx_vacancy_title ON vacancy(title);

-- ============================================
-- Tabela: vacancy_skills (Habilidades Requeridas das Vagas)
-- ============================================
CREATE TABLE IF NOT EXISTS vacancy_skills (
    vacancy_id BIGINT NOT NULL,
    skill VARCHAR(255) NOT NULL,
    FOREIGN KEY (vacancy_id) REFERENCES vacancy(id) ON DELETE CASCADE
);

-- Índices para otimização
CREATE INDEX idx_vacancy_skills_id ON vacancy_skills(vacancy_id);
CREATE INDEX idx_vacancy_skills_skill ON vacancy_skills(skill);

-- ============================================
-- Dados de exemplo para testes
-- ============================================

-- Inserir candidatos de exemplo
INSERT INTO candidate (full_name, email) VALUES
('João Silva', 'joao.silva@email.com'),
('Maria Santos', 'maria.santos@email.com'),
('Pedro Oliveira', 'pedro.oliveira@email.com'),
('Ana Costa', 'ana.costa@email.com'),
('Carlos Ferreira', 'carlos.ferreira@email.com')
ON CONFLICT (email) DO NOTHING;

-- Inserir habilidades dos candidatos
INSERT INTO candidate_skills (candidate_id, skill) VALUES
-- João Silva - Desenvolvedor Full Stack
(1, 'Java'),
(1, 'Spring Boot'),
(1, 'PostgreSQL'),
(1, 'Docker'),
(1, 'JavaScript'),
(1, 'React'),

-- Maria Santos - DevOps Engineer
(2, 'Azure'),
(2, 'Docker'),
(2, 'Kubernetes'),
(2, 'CI/CD'),
(2, 'Terraform'),
(2, 'Python'),

-- Pedro Oliveira - Data Scientist
(3, 'Python'),
(3, 'Machine Learning'),
(3, 'TensorFlow'),
(3, 'SQL'),
(3, 'Data Analysis'),
(3, 'Statistics'),

-- Ana Costa - Frontend Developer
(4, 'JavaScript'),
(4, 'React'),
(4, 'TypeScript'),
(4, 'HTML'),
(4, 'CSS'),
(4, 'Vue.js'),

-- Carlos Ferreira - Backend Developer
(5, 'Java'),
(5, 'Spring Boot'),
(5, 'Microservices'),
(5, 'PostgreSQL'),
(5, 'MongoDB'),
(5, 'Redis')
ON CONFLICT DO NOTHING;

-- Inserir vagas de exemplo
INSERT INTO vacancy (title, description) VALUES
('Desenvolvedor Java Sênior', 'Buscamos desenvolvedor Java com experiência em Spring Boot e microsserviços para atuar em projetos de transformação digital.'),
('DevOps Engineer', 'Profissional com conhecimento em Azure, Docker, Kubernetes e pipelines CI/CD para automação de infraestrutura.'),
('Cientista de Dados', 'Profissional com domínio em Python, Machine Learning e análise de dados para projetos de IA e predição.'),
('Desenvolvedor Frontend', 'Desenvolvedor com expertise em React, TypeScript e design responsivo para criar interfaces modernas.'),
('Arquiteto de Soluções Cloud', 'Especialista em arquitetura cloud Azure para desenhar e implementar soluções escaláveis.')
ON CONFLICT DO NOTHING;

-- Inserir habilidades requeridas das vagas
INSERT INTO vacancy_skills (vacancy_id, skill) VALUES
-- Desenvolvedor Java Sênior
(1, 'Java'),
(1, 'Spring Boot'),
(1, 'Microservices'),
(1, 'PostgreSQL'),
(1, 'Docker'),

-- DevOps Engineer
(2, 'Azure'),
(2, 'Docker'),
(2, 'Kubernetes'),
(2, 'CI/CD'),
(2, 'Terraform'),

-- Cientista de Dados
(3, 'Python'),
(3, 'Machine Learning'),
(3, 'TensorFlow'),
(3, 'SQL'),
(3, 'Statistics'),

-- Desenvolvedor Frontend
(4, 'JavaScript'),
(4, 'React'),
(4, 'TypeScript'),
(4, 'HTML'),
(4, 'CSS'),

-- Arquiteto de Soluções Cloud
(5, 'Azure'),
(5, 'Microservices'),
(5, 'Docker'),
(5, 'Kubernetes'),
(5, 'Terraform'),
(5, 'CI/CD')
ON CONFLICT DO NOTHING;

-- ============================================
-- Triggers para atualizar timestamp
-- ============================================

-- Função para atualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para candidate
CREATE TRIGGER update_candidate_updated_at BEFORE UPDATE ON candidate
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger para vacancy
CREATE TRIGGER update_vacancy_updated_at BEFORE UPDATE ON vacancy
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- Views úteis para análise
-- ============================================

-- View: Candidatos com contagem de habilidades
CREATE OR REPLACE VIEW v_candidates_summary AS
SELECT 
    c.id,
    c.full_name,
    c.email,
    COUNT(cs.skill) as total_skills,
    STRING_AGG(cs.skill, ', ' ORDER BY cs.skill) as skills_list
FROM candidate c
LEFT JOIN candidate_skills cs ON c.id = cs.candidate_id
GROUP BY c.id, c.full_name, c.email;

-- View: Vagas com contagem de habilidades requeridas
CREATE OR REPLACE VIEW v_vacancies_summary AS
SELECT 
    v.id,
    v.title,
    v.description,
    COUNT(vs.skill) as required_skills_count,
    STRING_AGG(vs.skill, ', ' ORDER BY vs.skill) as required_skills_list
FROM vacancy v
LEFT JOIN vacancy_skills vs ON v.id = vs.vacancy_id
GROUP BY v.id, v.title, v.description;

-- ============================================
-- Comentários nas tabelas
-- ============================================

COMMENT ON TABLE candidate IS 'Armazena informações dos candidatos cadastrados no sistema';
COMMENT ON TABLE candidate_skills IS 'Armazena as habilidades de cada candidato';
COMMENT ON TABLE vacancy IS 'Armazena as vagas de emprego disponíveis';
COMMENT ON TABLE vacancy_skills IS 'Armazena as habilidades requeridas para cada vaga';

-- ============================================
-- Fim do script
-- ============================================
