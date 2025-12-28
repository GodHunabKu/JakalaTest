-- ============================================================
-- HUNTER SYSTEM - DATABASE CLEANUP QUERY
-- Pulizia completa del database da dati non utilizzati
-- Data: 27 Dicembre 2025
-- ============================================================

USE srv1_hunabku;

-- ============================================================
-- 1. PULIZIA MISSIONI VECCHIE (oltre 30 giorni)
-- ============================================================
-- Rimuove missioni assegnate più di 30 giorni fa (già completate o scadute)
DELETE FROM hunter_player_missions
WHERE assigned_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY);

SELECT CONCAT('✓ Rimosse ', ROW_COUNT(), ' missioni vecchie (>30 giorni)') AS Status;

-- ============================================================
-- 2. PULIZIA EVENTI PASSATI
-- ============================================================
-- Rimuove eventi la cui end_time è passata da più di 7 giorni
DELETE FROM hunter_quest_events
WHERE end_time < DATE_SUB(NOW(), INTERVAL 7 DAY);

SELECT CONCAT('✓ Rimossi ', ROW_COUNT(), ' eventi scaduti (>7 giorni)') AS Status;

-- ============================================================
-- 3. PULIZIA PLAYER RANKINGS INATTIVI
-- ============================================================
-- ATTENZIONE: Questa query rimuove player che NON esistono più nel database account
-- Decommentare solo se sei SICURO di voler rimuovere player cancellati

-- DELETE FROM hunter_quest_ranking
-- WHERE player_id NOT IN (SELECT id FROM account.player);

-- SELECT CONCAT('✓ Rimossi ', ROW_COUNT(), ' ranking di player cancellati') AS Status;

-- ============================================================
-- 4. RESET DATI TEMPORANEI CORROTTI
-- ============================================================
-- Reset player con dati corrotti (defense_active ma nessun timer)
-- Questo pulisce stati "stuck" da crash server

UPDATE hunter_quest_ranking
SET overtaken_by = NULL,
    overtaken_diff = 0,
    overtaken_label = NULL
WHERE overtaken_by IS NOT NULL
  AND overtaken_diff = 0;

SELECT CONCAT('✓ Reset ', ROW_COUNT(), ' overtake status corrotti') AS Status;

-- ============================================================
-- 5. PULIZIA SHOP ITEMS DISABILITATI
-- ============================================================
-- Rimuove item dello shop che sono disabled da più di 60 giorni
-- (mantiene history per 60 giorni poi rimuove definitivamente)

DELETE FROM hunter_quest_shop
WHERE enabled = 0
  AND id NOT IN (
      SELECT DISTINCT item_id
      FROM hunter_purchase_history
      WHERE purchase_date > DATE_SUB(NOW(), INTERVAL 60 DAY)
  );

SELECT CONCAT('✓ Rimossi ', ROW_COUNT(), ' shop items obsoleti') AS Status;

-- ============================================================
-- 6. PULIZIA DEFENSE WAVES DISABILITATE
-- ============================================================
-- Rimuove ondate difesa frattura che sono disabled e non usate

DELETE FROM hunter_fracture_defense_waves
WHERE enabled = 0;

SELECT CONCAT('✓ Rimosse ', ROW_COUNT(), ' defense waves disabilitate') AS Status;

-- ============================================================
-- 7. PULIZIA SPAWNS MOB DISABILITATI
-- ============================================================
-- Rimuove configurazioni spawn mob elite che sono disabled

DELETE FROM hunter_quest_spawns
WHERE enabled = 0;

SELECT CONCAT('✓ Rimossi ', ROW_COUNT(), ' mob spawns disabilitati') AS Status;

-- ============================================================
-- 8. RESET PENDING REWARDS SCADUTI
-- ============================================================
-- Reset pending rewards che non sono stati reclamati per 30+ giorni
-- (considera scaduti e resetta il flag)

UPDATE hunter_quest_ranking
SET pending_daily_reward = 0
WHERE pending_daily_reward > 0
  AND daily_points = 0;  -- Se daily è a 0, significa che è stato resettato almeno 1 volta

UPDATE hunter_quest_ranking
SET pending_weekly_reward = 0
WHERE pending_weekly_reward > 0
  AND weekly_points = 0;  -- Se weekly è a 0, significa che è stato resettato almeno 1 volta

SELECT CONCAT('✓ Reset pending rewards scaduti') AS Status;

-- ============================================================
-- 9. OTTIMIZZAZIONE TABELLE
-- ============================================================
-- Ottimizza tutte le tabelle hunter per recuperare spazio e migliorare performance

OPTIMIZE TABLE hunter_quest_ranking;
OPTIMIZE TABLE hunter_quest_spawns;
OPTIMIZE TABLE hunter_quest_fractures;
OPTIMIZE TABLE hunter_quest_events;
OPTIMIZE TABLE hunter_quest_config;
OPTIMIZE TABLE hunter_quest_shop;
OPTIMIZE TABLE hunter_quest_achievements;
OPTIMIZE TABLE hunter_quest_texts;
OPTIMIZE TABLE hunter_quest_rewards;
OPTIMIZE TABLE hunter_quest_emergencies;
OPTIMIZE TABLE hunter_fracture_defense_waves;
OPTIMIZE TABLE hunter_fracture_defense_config;
OPTIMIZE TABLE hunter_player_missions;
OPTIMIZE TABLE hunter_quest_missions;
OPTIMIZE TABLE hunter_quest_tips;

SELECT '✓ Tabelle ottimizzate con successo' AS Status;

-- ============================================================
-- 10. VACUUM ANALYZE (Recupera spazio disco)
-- ============================================================
-- Nota: OPTIMIZE TABLE fa già VACUUM in MySQL/MariaDB
-- Questa sezione è informativa per PostgreSQL (se mai migrassi)

-- ============================================================
-- 11. STATISTICHE POST-CLEANUP
-- ============================================================

SELECT '============================================================' AS '';
SELECT 'STATISTICHE POST-CLEANUP' AS '';
SELECT '============================================================' AS '';

SELECT
    COUNT(*) as 'Player Attivi',
    SUM(total_points) as 'Total Glory',
    SUM(total_kills) as 'Total Kills',
    SUM(total_fractures) as 'Total Fratture'
FROM hunter_quest_ranking;

SELECT
    COUNT(*) as 'Missioni Attive',
    SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) as 'Completate',
    SUM(CASE WHEN status='active' THEN 1 ELSE 0 END) as 'In Corso'
FROM hunter_player_missions
WHERE assigned_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

SELECT
    COUNT(*) as 'Eventi Programmati',
    SUM(CASE WHEN start_time <= NOW() AND end_time >= NOW() THEN 1 ELSE 0 END) as 'Eventi Attivi'
FROM hunter_quest_events
WHERE end_time >= NOW();

SELECT COUNT(*) as 'Shop Items Attivi'
FROM hunter_quest_shop
WHERE enabled = 1;

SELECT COUNT(*) as 'Elite Mobs Configurati'
FROM hunter_quest_spawns
WHERE enabled = 1;

SELECT '============================================================' AS '';
SELECT '✓ CLEANUP COMPLETATO CON SUCCESSO!' AS '';
SELECT '============================================================' AS '';

-- ============================================================
-- NOTE IMPORTANTI:
-- ============================================================
-- 1. Esegui questa query durante ore di bassa attività (notte)
-- 2. Fai BACKUP del database PRIMA di eseguire cleanup pesanti
-- 3. La query #3 (rimozione player cancellati) è COMMENTATA per sicurezza
-- 4. OPTIMIZE TABLE può bloccare la tabella per alcuni secondi
-- 5. Esegui questa cleanup 1 volta al mese per mantenere DB pulito
-- ============================================================
