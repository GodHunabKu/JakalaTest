-- ============================================================
-- HUNTER SYSTEM - BALANCE UPDATE
-- Obiettivo: Hardcore raggiunge 1.5M (Monarca) in 2 mesi
-- Gerarchia: BOSS > SUPER_METIN > BAULE
-- ============================================================
-- Target: 25.000 Gloria/giorno per hardcore (7h/giorno)
-- ============================================================

SET NAMES utf8mb4;

-- ============================================================
-- 1. AGGIORNA PUNTI BASE SPAWN (hunter_quest_spawns)
-- Colonna: base_points (7° valore)
-- ============================================================

-- BOSS - I PIU' IMPORTANTI (valori alti)
UPDATE `hunter_quest_spawns` SET `base_points` = 50  WHERE `vnum` = 4035;  -- Funglash (E-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 70  WHERE `vnum` = 719;   -- Thaloren (D-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 100 WHERE `vnum` = 2771;  -- Yinlee (C-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 130 WHERE `vnum` = 768;   -- Slubina (C-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 170 WHERE `vnum` = 6790;  -- Alastor (B-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 220 WHERE `vnum` = 6831;  -- Grimlor (B-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 280 WHERE `vnum` = 986;   -- Branzhul (A-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 350 WHERE `vnum` = 989;   -- Torgal (A-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 450 WHERE `vnum` = 4011;  -- Nerzakar (S-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 550 WHERE `vnum` = 6830;  -- Nozzera (S-Rank)
UPDATE `hunter_quest_spawns` SET `base_points` = 750 WHERE `vnum` = 4385;  -- Velzahar (N-Rank) - RE DEI BOSS

-- SUPER METIN - VALORE MEDIO (inferiore ai boss)
UPDATE `hunter_quest_spawns` SET `base_points` = 20  WHERE `vnum` = 63010; -- Metin Lv.45
UPDATE `hunter_quest_spawns` SET `base_points` = 30  WHERE `vnum` = 63011; -- Metin Lv.60
UPDATE `hunter_quest_spawns` SET `base_points` = 45  WHERE `vnum` = 63012; -- Metin Lv.75
UPDATE `hunter_quest_spawns` SET `base_points` = 60  WHERE `vnum` = 63013; -- Metin Lv.90
UPDATE `hunter_quest_spawns` SET `base_points` = 80  WHERE `vnum` = 63014; -- Metin Lv.95
UPDATE `hunter_quest_spawns` SET `base_points` = 100 WHERE `vnum` = 63015; -- Metin Lv.115
UPDATE `hunter_quest_spawns` SET `base_points` = 130 WHERE `vnum` = 63016; -- Metin Lv.135
UPDATE `hunter_quest_spawns` SET `base_points` = 170 WHERE `vnum` = 63017; -- Metin Lv.165
UPDATE `hunter_quest_spawns` SET `base_points` = 220 WHERE `vnum` = 63018; -- Metin Lv.200
UPDATE `hunter_quest_spawns` SET `base_points` = 250 WHERE `vnum` = 63019; -- Metin Lv.???

-- BAULE - VALORE BASSO (solo spawn, il vero valore e' in chest_rewards)
UPDATE `hunter_quest_spawns` SET `base_points` = 3  WHERE `vnum` = 63000; -- Cassa E-Rank
UPDATE `hunter_quest_spawns` SET `base_points` = 5  WHERE `vnum` = 63001; -- Cassa D-Rank
UPDATE `hunter_quest_spawns` SET `base_points` = 8  WHERE `vnum` = 63002; -- Cassa C-Rank
UPDATE `hunter_quest_spawns` SET `base_points` = 10 WHERE `vnum` = 63003; -- Cassa B-Rank
UPDATE `hunter_quest_spawns` SET `base_points` = 12 WHERE `vnum` = 63004; -- Cassa A-Rank
UPDATE `hunter_quest_spawns` SET `base_points` = 15 WHERE `vnum` = 63005; -- Cassa S-Rank
UPDATE `hunter_quest_spawns` SET `base_points` = 18 WHERE `vnum` = 63006; -- Cassa N-Rank
UPDATE `hunter_quest_spawns` SET `base_points` = 20 WHERE `vnum` = 63007; -- Cassa ???-Rank

-- ============================================================
-- 2. AGGIORNA RICOMPENSE BAULI (hunter_chest_rewards)
-- Colonne: glory_min, glory_max (4° e 5° valore)
-- ============================================================

UPDATE `hunter_chest_rewards` SET `glory_min` = 5,   `glory_max` = 15   WHERE `vnum` = 63000; -- E-Rank
UPDATE `hunter_chest_rewards` SET `glory_min` = 10,  `glory_max` = 25   WHERE `vnum` = 63001; -- D-Rank
UPDATE `hunter_chest_rewards` SET `glory_min` = 18,  `glory_max` = 40   WHERE `vnum` = 63002; -- C-Rank
UPDATE `hunter_chest_rewards` SET `glory_min` = 30,  `glory_max` = 65   WHERE `vnum` = 63003; -- B-Rank
UPDATE `hunter_chest_rewards` SET `glory_min` = 50,  `glory_max` = 100  WHERE `vnum` = 63004; -- A-Rank
UPDATE `hunter_chest_rewards` SET `glory_min` = 80,  `glory_max` = 160  WHERE `vnum` = 63005; -- S-Rank
UPDATE `hunter_chest_rewards` SET `glory_min` = 120, `glory_max` = 250  WHERE `vnum` = 63006; -- N-Rank
UPDATE `hunter_chest_rewards` SET `glory_min` = 50,  `glory_max` = 500  WHERE `vnum` = 63007; -- ???-Rank (jackpot style)

-- ============================================================
-- 3. AGGIORNA RICOMPENSE MISSIONI GIORNALIERE
-- Ridotte del 30% per bilanciare
-- ============================================================

UPDATE `hunter_mission_definitions` SET `reward_glory` = 35,  `penalty_glory` = 7   WHERE `min_rank` = 'E';
UPDATE `hunter_mission_definitions` SET `reward_glory` = 55,  `penalty_glory` = 11  WHERE `min_rank` = 'D';
UPDATE `hunter_mission_definitions` SET `reward_glory` = 90,  `penalty_glory` = 18  WHERE `min_rank` = 'C';
UPDATE `hunter_mission_definitions` SET `reward_glory` = 150, `penalty_glory` = 30  WHERE `min_rank` = 'B';
UPDATE `hunter_mission_definitions` SET `reward_glory` = 250, `penalty_glory` = 50  WHERE `min_rank` = 'A';
UPDATE `hunter_mission_definitions` SET `reward_glory` = 400, `penalty_glory` = 80  WHERE `min_rank` = 'S';
UPDATE `hunter_mission_definitions` SET `reward_glory` = 600, `penalty_glory` = 120 WHERE `min_rank` = 'N';

-- ============================================================
-- 4. AGGIORNA BONUS RANK (ridotti per non far esplodere i punti)
-- ============================================================

UPDATE `hunter_ranks` SET `bonus_gloria` = 0  WHERE `rank_letter` = 'E';  -- Nessun bonus per newbie
UPDATE `hunter_ranks` SET `bonus_gloria` = 2  WHERE `rank_letter` = 'D';  -- +2%
UPDATE `hunter_ranks` SET `bonus_gloria` = 4  WHERE `rank_letter` = 'C';  -- +4%
UPDATE `hunter_ranks` SET `bonus_gloria` = 6  WHERE `rank_letter` = 'B';  -- +6%
UPDATE `hunter_ranks` SET `bonus_gloria` = 9  WHERE `rank_letter` = 'A';  -- +9%
UPDATE `hunter_ranks` SET `bonus_gloria` = 13 WHERE `rank_letter` = 'S';  -- +13%
UPDATE `hunter_ranks` SET `bonus_gloria` = 18 WHERE `rank_letter` = 'N';  -- +18%
UPDATE `hunter_ranks` SET `bonus_gloria` = 25 WHERE `rank_letter` = '?';  -- +25% Trascendente

-- ============================================================
-- 5. AGGIORNA CONFIGURAZIONE SPEED KILL
-- ============================================================

UPDATE `hunter_config` SET `cfg_value` = '200' WHERE `cfg_key` = 'speedkill_boss_bonus_pts';
UPDATE `hunter_config` SET `cfg_value` = '80'  WHERE `cfg_key` = 'speedkill_metin_bonus_pts';

-- Se non esistono, inseriscili
INSERT IGNORE INTO `hunter_config` (`cfg_key`, `cfg_value`, `cfg_description`) VALUES
('speedkill_boss_bonus_pts', '200', 'Gloria bonus per speed kill boss'),
('speedkill_metin_bonus_pts', '80', 'Gloria bonus per speed kill metin');

-- ============================================================
-- 6. AGGIORNA BONUS STREAK (login consecutivi)
-- ============================================================

UPDATE `hunter_config` SET `cfg_value` = '3'  WHERE `cfg_key` = 'streak_bonus_3days';
UPDATE `hunter_config` SET `cfg_value` = '7'  WHERE `cfg_key` = 'streak_bonus_7days';
UPDATE `hunter_config` SET `cfg_value` = '12' WHERE `cfg_key` = 'streak_bonus_30days';

-- Se non esistono, inseriscili
INSERT IGNORE INTO `hunter_config` (`cfg_key`, `cfg_value`, `cfg_description`) VALUES
('streak_bonus_3days', '3', 'Bonus % per 3 giorni consecutivi'),
('streak_bonus_7days', '7', 'Bonus % per 7 giorni consecutivi'),
('streak_bonus_30days', '12', 'Bonus % per 30 giorni consecutivi');

-- ============================================================
-- 7. JACKPOT LOOT - Riduci gloria jackpot
-- ============================================================

UPDATE `hunter_chest_loot` SET `glory_min` = 50,  `glory_max` = 150  WHERE `loot_type` = 'GLORY' AND `min_rank_tier` <= 2;
UPDATE `hunter_chest_loot` SET `glory_min` = 100, `glory_max` = 300  WHERE `loot_type` = 'GLORY' AND `min_rank_tier` BETWEEN 3 AND 4;
UPDATE `hunter_chest_loot` SET `glory_min` = 200, `glory_max` = 500  WHERE `loot_type` = 'GLORY' AND `min_rank_tier` BETWEEN 5 AND 6;
UPDATE `hunter_chest_loot` SET `glory_min` = 400, `glory_max` = 1000 WHERE `loot_type` = 'GLORY' AND `min_rank_tier` >= 7;

-- ============================================================
-- RIEPILOGO BILANCIAMENTO FINALE
-- ============================================================
--
-- GERARCHIA GLORIA PER ORA (hardcore):
-- +-----------------+--------+--------+------------+
-- | Tipo            | Qty/h  | Media  | Gloria/h   |
-- +-----------------+--------+--------+------------+
-- | BOSS            | 6      | 200    | 1,200      | << PIU' IMPORTANTE
-- | SUPER METIN     | 12     | 80     | 960        |
-- | BAULI           | 18     | 35     | 630        | << MENO IMPORTANTE
-- | EMERGENZE       | 4      | 120    | 480        |
-- +-----------------+--------+--------+------------+
-- | TOTALE BASE/h   |        |        | ~3,270     |
-- +-----------------+--------+--------+------------+
--
-- CALCOLO GIORNALIERO HARDCORE (7h):
-- - Base: 7h × 3,270 = 22,890 Gloria
-- - Missioni 3/3: ~400 Gloria
-- - Fracture Bonus +50% (4h): +6,540 Gloria
-- - Streak/Rank bonus ~10%: +2,980 Gloria
-- ----------------------------------------
-- TOTALE GIORNALIERO: ~32,800 Gloria
--
-- PROGRESSIONE HARDCORE:
-- - Mese 1: ~750,000 Gloria (Rank A→S)
-- - Mese 2: ~1,500,000 Gloria (Rank N - MONARCA) ✓
--
-- PROGRESSIONE NORMALE (2.5h/day):
-- - Mese 1: ~250,000 Gloria (Rank B→A)
-- - Mese 6: ~1,500,000 Gloria (Rank N)
--
-- PROGRESSIONE CASUAL (1h/day):
-- - Mese 1: ~80,000 Gloria (Rank C)
-- - Mese 12: ~960,000 Gloria (Rank S)
-- ============================================================

SELECT 'Bilanciamento completato!' AS Status;
