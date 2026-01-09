-- ============================================================================
-- CLEANUP: Rimozione traduzioni dal database
-- Le traduzioni ora sono gestite lato client in Python
-- ============================================================================

USE srv1_hunabku;

-- Svuota la tabella traduzioni (mantieni la struttura per compatibilita')
TRUNCATE TABLE hunter_translations;

-- Opzionale: Rimuovi completamente la tabella se non serve piu'
-- DROP TABLE IF EXISTS hunter_translations;

-- Verifica
SELECT 'Traduzioni rimosse dal database. Ora gestite in Python.' AS status;
SELECT COUNT(*) AS remaining_translations FROM hunter_translations;
