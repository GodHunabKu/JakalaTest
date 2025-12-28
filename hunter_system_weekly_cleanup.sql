-- ============================================================
-- HUNTER SYSTEM - WEEKLY QUICK CLEANUP
-- Pulizia veloce settimanale (esegui ogni 7 giorni)
-- Data: 27 Dicembre 2025
-- ============================================================

USE srv1_hunabku;

-- Pulizia missioni vecchie (7+ giorni)
DELETE FROM hunter_player_missions
WHERE assigned_date < DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- Pulizia eventi passati
DELETE FROM hunter_quest_events
WHERE end_time < NOW();

-- Reset overtake corrotti
UPDATE hunter_quest_ranking
SET overtaken_by = NULL, overtaken_diff = 0, overtaken_label = NULL
WHERE overtaken_by IS NOT NULL AND overtaken_diff = 0;

-- Ottimizza tabelle principali
OPTIMIZE TABLE hunter_quest_ranking;
OPTIMIZE TABLE hunter_player_missions;
OPTIMIZE TABLE hunter_quest_events;

SELECT '✓ Weekly cleanup completato!' AS Status;
