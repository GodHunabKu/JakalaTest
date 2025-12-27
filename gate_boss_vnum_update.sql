-- ============================================================
-- HUNTER SYSTEM - Gate Boss VNUM Update
-- Aggiunge il campo boss_vnum per tracciare l'uccisione del boss
-- ============================================================

USE srv1_hunabku;

-- Aggiungi campo boss_vnum alla tabella hunter_gate_config
ALTER TABLE `hunter_gate_config`
ADD COLUMN `boss_vnum` int NOT NULL DEFAULT 0 COMMENT 'VNUM del boss da uccidere (0 = nessun boss specifico)' AFTER `dungeon_index`;

-- Opzionale: Aggiorna i gate esistenti con i VNUM dei boss
-- Modifica questi valori in base ai tuoi dungeon reali
UPDATE `hunter_gate_config` SET `boss_vnum` = 4035 WHERE `gate_id` = 1; -- Gate Primordiale
UPDATE `hunter_gate_config` SET `boss_vnum` = 6790 WHERE `gate_id` = 2; -- Gate Astrale
UPDATE `hunter_gate_config` SET `boss_vnum` = 6831 WHERE `gate_id` = 3; -- Gate Abissale
UPDATE `hunter_gate_config` SET `boss_vnum` = 986 WHERE `gate_id` = 4;  -- Gate Cremisi
UPDATE `hunter_gate_config` SET `boss_vnum` = 989 WHERE `gate_id` = 5;  -- Gate Aureo
UPDATE `hunter_gate_config` SET `boss_vnum` = 4385 WHERE `gate_id` = 6; -- Gate Infausto
UPDATE `hunter_gate_config` SET `boss_vnum` = 4011 WHERE `gate_id` = 7; -- Gate del Giudizio

-- ============================================================
-- FINE UPDATE
-- ============================================================
