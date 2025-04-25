INSERT INTO main_patente (id, nome) VALUES
(1, 'Cadete'),
(2, 'Alferes'),
(3, 'Tenente junior'),
(4, 'Tenente'),
(5, 'Tenente comandante'),
(6, 'Capitão'),
(7, 'Comodoro'),
(8, 'Vice almirante'),
(9, 'Almirante');

-- Insert Tripulantes (Crew Members)
INSERT INTO main_tripulante (id, nome, patente_id, funcao_principal, funcao_secundaria, email, telefone) VALUES
(1, 'James Kirk', 2, 'capitao', 'engenheiro', 'james.kirk@starfleet.com', '+1-555-1234'),
(2, 'Spock', 3, 'ciencias', 'engenheiro', 'spock@starfleet.com', '+1-555-1235'),
(3, 'Leonard McCoy', 3, 'ciencias', 'comunicacao', 'bones@starfleet.com', '+1-555-1236'),
(4, 'Montgomery Scott', 3, 'engenheiro', 'armas', 'scotty@starfleet.com', '+1-555-1237'),
(5, 'Hikaru Sulu', 4, 'piloto', 'armas', 'sulu@starfleet.com', '+1-555-1238'),
(6, 'Pavel Chekov', 5, 'navegador', 'armas', 'chekov@starfleet.com', '+1-555-1239');

-- Insert Naves (Ships)
INSERT INTO main_nave (id, nome) VALUES
(1, 'USS São Paulo'),
(2, 'Tupã');
-- Insert Bases
INSERT INTO main_base (id, nome) VALUES
(1, 'Butanta'),
(2, 'Diadema'),
(3, 'Perdizes');

-- Insert Missoes (Missions)
INSERT INTO main_missao (id, nome, descricao) VALUES
(1, 'Guerra em Orion', 'Conflito armado na região de Orion contra forças hostis'),
(2, 'Corrida em Orion', 'Competição de velocidade entre naves na região de Orion'),
(3, 'Incidente LV-426', 'Evento misterioso ocorrido na colônia LV-426');

-- Insert Historicos (History Records)
INSERT INTO main_historico (id, data, base_id, missao_id, teve_gm, nave_id) VALUES
(1, '2024-01-15', 1, 1, true, 1),
(2, '2024-02-20', 2, 2, false, 2),
(3, '2024-03-10', 3, 3, true, 3);

-- Insert Funcoes Exercidas (Functions Performed)
INSERT INTO main_funcaoexercida (id, historico_id, tripulante_id, funcao, pontuacao, descricao) VALUES
(1, 1, 1, 'capitao', 100, 'Comando da nave durante exploração'),
(2, 1, 2, 'ciencias', 95, 'Análise científica da nebulosa'),
(3, 1, 3, 'ciencias', 90, 'Suporte médico'),
(4, 2, 4, 'engenheiro', 95, 'Manutenção dos sistemas'),
(5, 2, 5, 'piloto', 90, 'Navegação em combate'),
(6, 3, 6, 'navegador', 85, 'Navegação diplomática');

-- Insert Nave-Tripulante relationships
INSERT INTO main_nave_tripulante (nave_id, tripulante_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(2, 1), (2, 2), (2, 3),
(3, 4), (3, 5), (3, 6);
