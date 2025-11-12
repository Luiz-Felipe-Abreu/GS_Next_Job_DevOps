-- ==============================================================================
-- Script de Criação do Banco de Dados NextJob
-- ==============================================================================
-- RM: 555197
-- Descrição: Banco de dados para sistema de gestão de vagas e candidatos
-- ==============================================================================

-- Criar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================================================
-- TABELA: usuarios
-- ==============================================================================
CREATE TABLE IF NOT EXISTS usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE,
    data_nascimento DATE,
    tipo_usuario VARCHAR(50) DEFAULT 'CANDIDATO',
    foto_perfil TEXT,
    linkedin_url VARCHAR(500),
    github_url VARCHAR(500),
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================================================
-- TABELA: empresas
-- ==============================================================================
CREATE TABLE IF NOT EXISTS empresas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    descricao TEXT,
    setor VARCHAR(100),
    website VARCHAR(500),
    logo_url TEXT,
    endereco VARCHAR(500),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    telefone VARCHAR(20),
    email VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================================================
-- TABELA: vagas
-- ==============================================================================
CREATE TABLE IF NOT EXISTS vagas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    empresa_id UUID NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    requisitos TEXT,
    salario_min DECIMAL(10, 2),
    salario_max DECIMAL(10, 2),
    tipo_contrato VARCHAR(50),
    modalidade VARCHAR(50),
    nivel_experiencia VARCHAR(50),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    area VARCHAR(100),
    status VARCHAR(50) DEFAULT 'ABERTA',
    data_publicacao DATE DEFAULT CURRENT_DATE,
    data_expiracao DATE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id) ON DELETE CASCADE
);

-- ==============================================================================
-- TABELA: competencias
-- ==============================================================================
CREATE TABLE IF NOT EXISTS competencias (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(100) UNIQUE NOT NULL,
    categoria VARCHAR(50),
    descricao TEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================================================
-- TABELA: usuario_competencias
-- ==============================================================================
CREATE TABLE IF NOT EXISTS usuario_competencias (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID NOT NULL,
    competencia_id UUID NOT NULL,
    nivel VARCHAR(50),
    anos_experiencia INTEGER,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (competencia_id) REFERENCES competencias(id) ON DELETE CASCADE,
    UNIQUE(usuario_id, competencia_id)
);

-- ==============================================================================
-- TABELA: candidaturas
-- ==============================================================================
CREATE TABLE IF NOT EXISTS candidaturas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID NOT NULL,
    vaga_id UUID NOT NULL,
    status VARCHAR(50) DEFAULT 'ENVIADA',
    curriculo_url TEXT,
    carta_apresentacao TEXT,
    match_score DECIMAL(5, 2),
    data_candidatura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (vaga_id) REFERENCES vagas(id) ON DELETE CASCADE,
    UNIQUE(usuario_id, vaga_id)
);

-- ==============================================================================
-- ÍNDICES
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);
CREATE INDEX IF NOT EXISTS idx_vagas_empresa ON vagas(empresa_id);
CREATE INDEX IF NOT EXISTS idx_vagas_status ON vagas(status);
CREATE INDEX IF NOT EXISTS idx_candidaturas_usuario ON candidaturas(usuario_id);
CREATE INDEX IF NOT EXISTS idx_candidaturas_vaga ON candidaturas(vaga_id);

-- ==============================================================================
-- DADOS INICIAIS - Competências
-- ==============================================================================
INSERT INTO competencias (nome, categoria, descricao) VALUES
('Java', 'TECNICA', 'Linguagem de programação'),
('Spring Boot', 'TECNICA', 'Framework Java'),
('PostgreSQL', 'TECNICA', 'Banco de dados relacional'),
('Docker', 'TECNICA', 'Containerização'),
('Azure', 'TECNICA', 'Cloud Computing'),
('Comunicação', 'COMPORTAMENTAL', 'Habilidade de comunicação'),
('Trabalho em Equipe', 'COMPORTAMENTAL', 'Trabalho colaborativo'),
('Inglês', 'IDIOMA', 'Idioma inglês')
ON CONFLICT (nome) DO NOTHING;

-- ==============================================================================
-- DADOS INICIAIS - Empresa
-- ==============================================================================
INSERT INTO empresas (nome, cnpj, descricao, setor, cidade, estado) VALUES
('TechCorp', '12.345.678/0001-90', 'Empresa de tecnologia', 'Tecnologia', 'São Paulo', 'SP')
ON CONFLICT (cnpj) DO NOTHING;
