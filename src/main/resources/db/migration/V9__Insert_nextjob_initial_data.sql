-- V9__Insert_nextjob_initial_data.sql
-- Dados iniciais para o sistema NextJob

-- Inserir competências
INSERT INTO competencias (nome, categoria, descricao) VALUES
('Java', 'TECNICA', 'Linguagem de programação orientada a objetos'),
('Spring Boot', 'TECNICA', 'Framework Java para desenvolvimento de aplicações'),
('PostgreSQL', 'TECNICA', 'Sistema de gerenciamento de banco de dados relacional'),
('Docker', 'TECNICA', 'Plataforma de containerização'),
('Azure', 'TECNICA', 'Plataforma de computação em nuvem da Microsoft'),
('Python', 'TECNICA', 'Linguagem de programação versátil'),
('Machine Learning', 'TECNICA', 'Área de IA para aprendizado de máquina'),
('JavaScript', 'TECNICA', 'Linguagem de programação para web'),
('React', 'TECNICA', 'Biblioteca JavaScript para interfaces'),
('SQL', 'TECNICA', 'Linguagem para consulta de bancos de dados'),
('Comunicação', 'COMPORTAMENTAL', 'Habilidade de se comunicar efetivamente'),
('Trabalho em Equipe', 'COMPORTAMENTAL', 'Capacidade de trabalhar colaborativamente'),
('Liderança', 'COMPORTAMENTAL', 'Capacidade de liderar e motivar equipes'),
('Resolução de Problemas', 'COMPORTAMENTAL', 'Habilidade de resolver problemas complexos'),
('Inglês', 'IDIOMA', 'Proficiência no idioma inglês'),
('Espanhol', 'IDIOMA', 'Proficiência no idioma espanhol')
ON CONFLICT (nome) DO NOTHING;

-- Inserir empresas
INSERT INTO empresas (nome, cnpj, descricao, setor, cidade, estado, telefone, email) VALUES
('TechNova Solutions', '12.345.678/0001-90', 'Empresa de tecnologia focada em soluções inovadoras', 'Tecnologia', 'São Paulo', 'SP', '(11) 3000-0001', 'contato@technova.com'),
('DataCorp Analytics', '23.456.789/0001-91', 'Especializada em análise de dados e BI', 'Tecnologia', 'Rio de Janeiro', 'RJ', '(21) 3000-0002', 'rh@datacorp.com'),
('CloudFirst Brasil', '34.567.890/0001-92', 'Consultoria em cloud computing e DevOps', 'Tecnologia', 'São Paulo', 'SP', '(11) 3000-0003', 'vagas@cloudfirst.com.br'),
('FinTech Innovations', '45.678.901/0001-93', 'Soluções financeiras com tecnologia', 'Fintech', 'Belo Horizonte', 'MG', '(31) 3000-0004', 'careers@fintech.com'),
('EduTech Learning', '56.789.012/0001-94', 'Plataforma de educação online', 'Educação', 'Curitiba', 'PR', '(41) 3000-0005', 'rh@edutech.com.br')
ON CONFLICT (cnpj) DO NOTHING;

-- Inserir usuários de exemplo
INSERT INTO usuarios (nome, email, senha, telefone, cpf, data_nascimento, tipo_usuario) VALUES
('João Silva', 'joao.silva@email.com', '$2a$10$abcdefghijklmnopqrstuv', '(11) 99999-0001', '111.111.111-11', '1995-05-15', 'CANDIDATO'),
('Maria Santos', 'maria.santos@email.com', '$2a$10$abcdefghijklmnopqrstuv', '(11) 99999-0002', '222.222.222-22', '1992-08-20', 'CANDIDATO'),
('Pedro Oliveira', 'pedro.oliveira@email.com', '$2a$10$abcdefghijklmnopqrstuv', '(21) 99999-0003', '333.333.333-33', '1998-03-10', 'CANDIDATO'),
('Ana Costa', 'ana.costa@email.com', '$2a$10$abcdefghijklmnopqrstuv', '(11) 99999-0004', '444.444.444-44', '1990-11-25', 'CANDIDATO'),
('Carlos Mendes', 'carlos.mendes@email.com', '$2a$10$abcdefghijklmnopqrstuv', '(31) 99999-0005', '555.555.555-55', '1993-07-30', 'CANDIDATO')
ON CONFLICT (email) DO NOTHING;
