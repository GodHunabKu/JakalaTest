-- ============================================================
-- HUNTER SYSTEM - FRACTURE DEFENSE SYSTEM
-- Sistema di difesa ispirato a Solo Leveling / Diablo
-- ============================================================

USE srv1_hunabku;

-- Tabella per configurare le ondate di difesa frattura
CREATE TABLE IF NOT EXISTS `hunter_fracture_defense_waves` (
  `wave_id` int NOT NULL AUTO_INCREMENT,
  `rank_grade` varchar(2) NOT NULL COMMENT 'E,D,C,B,A,S,N - rank della frattura',
  `wave_number` int NOT NULL DEFAULT 1 COMMENT 'Numero ondata (1,2,3...)',
  `spawn_time` int NOT NULL DEFAULT 10 COMMENT 'Quando spawna questa ondata (secondi dall inizio)',
  `mob_vnum` int NOT NULL COMMENT 'VNUM del mob da spawnare',
  `mob_count` int NOT NULL DEFAULT 5 COMMENT 'Quanti mob spawnare',
  `spawn_radius` int NOT NULL DEFAULT 7 COMMENT 'Raggio di spawn dal player',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`wave_id`),
  KEY `idx_rank_wave` (`rank_grade`, `wave_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Configurazione difesa frattura globale
CREATE TABLE IF NOT EXISTS `hunter_fracture_defense_config` (
  `config_key` varchar(64) NOT NULL,
  `config_value` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Inserisci configurazioni base
INSERT INTO `hunter_fracture_defense_config` VALUES
('defense_duration', 60, 'Durata difesa in secondi'),
('check_distance', 10, 'Distanza massima dalla frattura (metri)'),
('check_interval', 2, 'Ogni quanti secondi controllare la posizione'),
('party_all_required', 1, 'Se 1, tutti i membri party devono stare vicini'),
('spawn_start_delay', 5, 'Secondi prima della prima ondata');

-- ============================================================
-- ESEMPI DI ONDATE PER RANK E (FACILE)
-- ============================================================
INSERT INTO `hunter_fracture_defense_waves`
(rank_grade, wave_number, spawn_time, mob_vnum, mob_count, spawn_radius, enabled)
VALUES
-- Ondata 1: spawn dopo 5 secondi
('E', 1, 5, 101, 3, 7, 1),   -- 3 Lupi
-- Ondata 2: spawn dopo 15 secondi
('E', 2, 15, 103, 5, 7, 1),  -- 5 Orsi
-- Ondata 3: spawn dopo 30 secondi
('E', 3, 30, 105, 4, 7, 1),  -- 4 Tigri
-- Ondata 4: spawn dopo 45 secondi (finale)
('E', 4, 45, 191, 2, 7, 1);  -- 2 Orsi Capo

-- ============================================================
-- ESEMPI DI ONDATE PER RANK D (MEDIO)
-- ============================================================
INSERT INTO `hunter_fracture_defense_waves`
(rank_grade, wave_number, spawn_time, mob_vnum, mob_count, spawn_radius, enabled)
VALUES
('D', 1, 5, 301, 4, 7, 1),   -- 4 Soldati
('D', 2, 15, 303, 6, 7, 1),  -- 6 Arcieri
('D', 3, 30, 305, 5, 7, 1),  -- 5 Cavalieri
('D', 4, 45, 391, 3, 7, 1);  -- 3 Elite

-- ============================================================
-- ESEMPI DI ONDATE PER RANK C (DIFFICILE)
-- ============================================================
INSERT INTO `hunter_fracture_defense_waves`
(rank_grade, wave_number, spawn_time, mob_vnum, mob_count, spawn_radius, enabled)
VALUES
('C', 1, 5, 501, 5, 8, 1),
('C', 2, 15, 503, 7, 8, 1),
('C', 3, 30, 505, 6, 8, 1),
('C', 4, 45, 591, 4, 8, 1);

-- ============================================================
-- NOTA: Personalizza i VNUM mob in base al tuo server!
-- Questi sono solo esempi. Modifica con i VNUM reali del tuo gioco.
-- ============================================================
