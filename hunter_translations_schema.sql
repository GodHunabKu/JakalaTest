-- ============================================================
-- HUNTER TRANSLATIONS SYSTEM - COMPLETE SCHEMA
-- Multi-language support for Hunter Terminal
-- Version: 3.0 - Aligned with Lua code (uses translation_key)
-- ============================================================

SET NAMES utf8mb4;

-- ----------------------------
-- Table: hunter_translations
-- Stores all translatable texts with language codes
-- NOTA: Usa 'translation_key' (non 'text_key') per compatibilita' con hunterlib.lua
-- ----------------------------
DROP TABLE IF EXISTS `hunter_translations`;
CREATE TABLE `hunter_translations` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `translation_key` VARCHAR(100) NOT NULL COMMENT 'Unique identifier for the text',
    `lang_code` VARCHAR(5) NOT NULL COMMENT 'Language code: it, en, de, es, fr, pt',
    `text_value` TEXT NOT NULL COMMENT 'Translated text value',
    `color_code` VARCHAR(10) DEFAULT NULL COMMENT 'Optional color code for colored texts',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_key_lang` (`translation_key` ASC, `lang_code` ASC) USING BTREE,
    INDEX `idx_lang` (`lang_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table: hunter_player_settings
-- Stores player-specific settings including language preference
-- ----------------------------
DROP TABLE IF EXISTS `hunter_player_settings`;
CREATE TABLE `hunter_player_settings` (
    `player_id` INT NOT NULL,
    `setting_key` VARCHAR(50) NOT NULL,
    `setting_value` VARCHAR(255) NOT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`player_id`, `setting_key`) USING BTREE,
    INDEX `idx_player` (`player_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table: hunter_languages
-- Available languages for the Hunter System
-- ----------------------------
DROP TABLE IF EXISTS `hunter_languages`;
CREATE TABLE `hunter_languages` (
    `lang_code` VARCHAR(5) NOT NULL,
    `lang_name` VARCHAR(50) NOT NULL COMMENT 'Native language name',
    `lang_name_en` VARCHAR(50) NOT NULL COMMENT 'English name',
    `flag_icon` VARCHAR(20) DEFAULT NULL COMMENT 'Icon identifier',
    `display_order` INT NOT NULL DEFAULT 0,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`lang_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Insert available languages
-- ----------------------------
INSERT INTO `hunter_languages` VALUES ('it', 'Italiano', 'Italian', 'flag_it', 1, 1);
INSERT INTO `hunter_languages` VALUES ('en', 'English', 'English', 'flag_en', 2, 1);
INSERT INTO `hunter_languages` VALUES ('de', 'Deutsch', 'German', 'flag_de', 3, 1);
INSERT INTO `hunter_languages` VALUES ('es', 'Espanol', 'Spanish', 'flag_es', 4, 1);
INSERT INTO `hunter_languages` VALUES ('fr', 'Francais', 'French', 'flag_fr', 5, 1);
INSERT INTO `hunter_languages` VALUES ('pt', 'Portugues', 'Portuguese', 'flag_pt', 6, 1);

-- ============================================================
-- ITALIAN TRANSLATIONS (Primary Language)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_TAB_STATS', 'it', 'Stats'),
('UI_TAB_RANK', 'it', 'Rank'),
('UI_TAB_SHOP', 'it', 'Shop'),
('UI_TAB_ACHIEV', 'it', 'Achiev'),
('UI_TAB_EVENTS', 'it', 'Eventi'),
('UI_TAB_GUIDE', 'it', 'Guida');

-- Guide Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('GUIDE_TITLE', 'it', 'GUIDA COMPLETA HUNTER SYSTEM'),
('GUIDE_TAB_RANKS', 'it', 'Ranghi'),
('GUIDE_TAB_GLORY', 'it', 'Gloria'),
('GUIDE_TAB_MISSIONS', 'it', 'Missioni'),
('GUIDE_TAB_EVENTS', 'it', 'Eventi'),
('GUIDE_TAB_SHOP', 'it', 'Shop'),
('GUIDE_TAB_FAQ', 'it', 'FAQ'),
('GUIDE_RANKS_TITLE', 'it', 'SISTEMA DEI RANGHI'),
('GUIDE_RANKS_DESC1', 'it', 'Il tuo Rango determina il tuo prestigio e i contenuti'),
('GUIDE_RANKS_DESC2', 'it', 'a cui puoi accedere. Accumula Gloria per salire!');

-- Events Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('EVENTS_HEADER', 'it', 'MISSIONI & EVENTI'),
('EVENTS_CONTAINS', 'it', 'Questa schermata contiene:'),
('EVENTS_DESC', 'it', 'Missioni Giornaliere + Eventi Programmati 24H'),
('DAILY_MISSIONS_TITLE', 'it', 'MISSIONI GIORNALIERE (Reset: 00:05)'),
('BTN_OPEN_DETAILS', 'it', 'Apri Dettagli'),
('MISSION_AUTO_OPEN', 'it', 'Il Terminale si apre automaticamente quando fai progresso!'),
('MISSION_BONUS_TIP', 'it', 'Completa TUTTE E 3 per bonus x1.5 Gloria!');

-- Rank Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('RANK_E_NAME', 'it', 'Risvegliato'),
('RANK_D_NAME', 'it', 'Apprendista'),
('RANK_C_NAME', 'it', 'Cacciatore'),
('RANK_B_NAME', 'it', 'Veterano'),
('RANK_A_NAME', 'it', 'Maestro'),
('RANK_S_NAME', 'it', 'Leggenda'),
('RANK_N_NAME', 'it', 'Monarca');

-- Common UI Elements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_CLOSE', 'it', 'Chiudi'),
('UI_CONFIRM', 'it', 'Conferma'),
('UI_CANCEL', 'it', 'Annulla'),
('UI_BACK', 'it', 'Indietro'),
('UI_NEXT', 'it', 'Avanti'),
('UI_LOADING', 'it', 'Caricamento...'),
('UI_ERROR', 'it', 'Errore'),
('UI_SUCCESS', 'it', 'Successo'),
('UI_GLORY', 'it', 'Gloria'),
('UI_POINTS', 'it', 'Punti');

-- Shop
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SHOP_TITLE', 'it', 'NEGOZIO HUNTER'),
('SHOP_BUY', 'it', 'Acquista'),
('SHOP_PRICE', 'it', 'Prezzo'),
('SHOP_INSUFFICIENT', 'it', 'Gloria insufficiente'),
('SHOP_PURCHASED', 'it', 'Acquistato!');

-- Achievements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('ACH_TITLE', 'it', 'OBIETTIVI'),
('ACH_CLAIM', 'it', 'Riscuoti'),
('ACH_CLAIMED', 'it', 'Riscattato'),
('ACH_LOCKED', 'it', 'Bloccato'),
('ACH_PROGRESS', 'it', 'Progresso');

-- System Messages
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SYS_GATE_COMPLETE', 'it', 'Gate completato!'),
('SYS_GATE_FAILED', 'it', 'Gate fallito!'),
('SYS_JACKPOT', 'it', 'JACKPOT!'),
('SYS_DANGER', 'it', 'PERICOLO'),
('SYS_EMERGENCY', 'it', 'EMERGENZA RILEVATA');

-- ============================================================
-- ENGLISH TRANSLATIONS
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_TAB_STATS', 'en', 'Stats'),
('UI_TAB_RANK', 'en', 'Rank'),
('UI_TAB_SHOP', 'en', 'Shop'),
('UI_TAB_ACHIEV', 'en', 'Achiev'),
('UI_TAB_EVENTS', 'en', 'Events'),
('UI_TAB_GUIDE', 'en', 'Guide');

-- Guide Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('GUIDE_TITLE', 'en', 'COMPLETE HUNTER SYSTEM GUIDE'),
('GUIDE_TAB_RANKS', 'en', 'Ranks'),
('GUIDE_TAB_GLORY', 'en', 'Glory'),
('GUIDE_TAB_MISSIONS', 'en', 'Missions'),
('GUIDE_TAB_EVENTS', 'en', 'Events'),
('GUIDE_TAB_SHOP', 'en', 'Shop'),
('GUIDE_TAB_FAQ', 'en', 'FAQ'),
('GUIDE_RANKS_TITLE', 'en', 'RANKING SYSTEM'),
('GUIDE_RANKS_DESC1', 'en', 'Your Rank determines your prestige and the content'),
('GUIDE_RANKS_DESC2', 'en', 'you can access. Accumulate Glory to rank up!');

-- Events Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('EVENTS_HEADER', 'en', 'MISSIONS & EVENTS'),
('EVENTS_CONTAINS', 'en', 'This screen contains:'),
('EVENTS_DESC', 'en', 'Daily Missions + 24H Scheduled Events'),
('DAILY_MISSIONS_TITLE', 'en', 'DAILY MISSIONS (Reset: 00:05)'),
('BTN_OPEN_DETAILS', 'en', 'Open Details'),
('MISSION_AUTO_OPEN', 'en', 'The Terminal opens automatically when you make progress!'),
('MISSION_BONUS_TIP', 'en', 'Complete ALL 3 for x1.5 Glory bonus!');

-- Rank Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('RANK_E_NAME', 'en', 'Awakened'),
('RANK_D_NAME', 'en', 'Apprentice'),
('RANK_C_NAME', 'en', 'Hunter'),
('RANK_B_NAME', 'en', 'Veteran'),
('RANK_A_NAME', 'en', 'Master'),
('RANK_S_NAME', 'en', 'Legend'),
('RANK_N_NAME', 'en', 'Monarch');

-- Common UI Elements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_CLOSE', 'en', 'Close'),
('UI_CONFIRM', 'en', 'Confirm'),
('UI_CANCEL', 'en', 'Cancel'),
('UI_BACK', 'en', 'Back'),
('UI_NEXT', 'en', 'Next'),
('UI_LOADING', 'en', 'Loading...'),
('UI_ERROR', 'en', 'Error'),
('UI_SUCCESS', 'en', 'Success'),
('UI_GLORY', 'en', 'Glory'),
('UI_POINTS', 'en', 'Points');

-- Shop
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SHOP_TITLE', 'en', 'HUNTER SHOP'),
('SHOP_BUY', 'en', 'Buy'),
('SHOP_PRICE', 'en', 'Price'),
('SHOP_INSUFFICIENT', 'en', 'Insufficient Glory'),
('SHOP_PURCHASED', 'en', 'Purchased!');

-- Achievements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('ACH_TITLE', 'en', 'ACHIEVEMENTS'),
('ACH_CLAIM', 'en', 'Claim'),
('ACH_CLAIMED', 'en', 'Claimed'),
('ACH_LOCKED', 'en', 'Locked'),
('ACH_PROGRESS', 'en', 'Progress');

-- System Messages
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SYS_GATE_COMPLETE', 'en', 'Gate completed!'),
('SYS_GATE_FAILED', 'en', 'Gate failed!'),
('SYS_JACKPOT', 'en', 'JACKPOT!'),
('SYS_DANGER', 'en', 'DANGER'),
('SYS_EMERGENCY', 'en', 'EMERGENCY DETECTED');

-- ============================================================
-- GERMAN TRANSLATIONS (DEUTSCH)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_TAB_STATS', 'de', 'Status'),
('UI_TAB_RANK', 'de', 'Rang'),
('UI_TAB_SHOP', 'de', 'Shop'),
('UI_TAB_ACHIEV', 'de', 'Erfolge'),
('UI_TAB_EVENTS', 'de', 'Events'),
('UI_TAB_GUIDE', 'de', 'Hilfe');

-- Guide Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('GUIDE_TITLE', 'de', 'KOMPLETTER HUNTER SYSTEM GUIDE'),
('GUIDE_TAB_RANKS', 'de', 'Range'),
('GUIDE_TAB_GLORY', 'de', 'Ruhm'),
('GUIDE_TAB_MISSIONS', 'de', 'Missionen'),
('GUIDE_TAB_EVENTS', 'de', 'Events'),
('GUIDE_TAB_SHOP', 'de', 'Shop'),
('GUIDE_TAB_FAQ', 'de', 'FAQ'),
('GUIDE_RANKS_TITLE', 'de', 'RANGSYSTEM'),
('GUIDE_RANKS_DESC1', 'de', 'Dein Rang bestimmt dein Prestige und die Inhalte'),
('GUIDE_RANKS_DESC2', 'de', 'auf die du zugreifen kannst. Sammle Ruhm um aufzusteigen!');

-- Events Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('EVENTS_HEADER', 'de', 'MISSIONEN & EVENTS'),
('EVENTS_CONTAINS', 'de', 'Diese Ansicht enthalt:'),
('EVENTS_DESC', 'de', 'Tagliche Missionen + 24H geplante Events'),
('DAILY_MISSIONS_TITLE', 'de', 'TAGLICHE MISSIONEN (Reset: 00:05)'),
('BTN_OPEN_DETAILS', 'de', 'Details offnen'),
('MISSION_AUTO_OPEN', 'de', 'Das Terminal offnet sich automatisch bei Fortschritt!'),
('MISSION_BONUS_TIP', 'de', 'Schliesse ALLE 3 ab fur x1.5 Ruhm Bonus!');

-- Rank Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('RANK_E_NAME', 'de', 'Erwacht'),
('RANK_D_NAME', 'de', 'Lehrling'),
('RANK_C_NAME', 'de', 'Jager'),
('RANK_B_NAME', 'de', 'Veteran'),
('RANK_A_NAME', 'de', 'Meister'),
('RANK_S_NAME', 'de', 'Legende'),
('RANK_N_NAME', 'de', 'Monarch');

-- Common UI Elements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_CLOSE', 'de', 'Schliessen'),
('UI_CONFIRM', 'de', 'Bestatigen'),
('UI_CANCEL', 'de', 'Abbrechen'),
('UI_BACK', 'de', 'Zuruck'),
('UI_NEXT', 'de', 'Weiter'),
('UI_LOADING', 'de', 'Laden...'),
('UI_ERROR', 'de', 'Fehler'),
('UI_SUCCESS', 'de', 'Erfolg'),
('UI_GLORY', 'de', 'Ruhm'),
('UI_POINTS', 'de', 'Punkte');

-- Shop
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SHOP_TITLE', 'de', 'HUNTER SHOP'),
('SHOP_BUY', 'de', 'Kaufen'),
('SHOP_PRICE', 'de', 'Preis'),
('SHOP_INSUFFICIENT', 'de', 'Nicht genug Ruhm'),
('SHOP_PURCHASED', 'de', 'Gekauft!');

-- Achievements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('ACH_TITLE', 'de', 'ERFOLGE'),
('ACH_CLAIM', 'de', 'Einlosen'),
('ACH_CLAIMED', 'de', 'Eingelost'),
('ACH_LOCKED', 'de', 'Gesperrt'),
('ACH_PROGRESS', 'de', 'Fortschritt');

-- System Messages
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SYS_GATE_COMPLETE', 'de', 'Gate abgeschlossen!'),
('SYS_GATE_FAILED', 'de', 'Gate fehlgeschlagen!'),
('SYS_JACKPOT', 'de', 'JACKPOT!'),
('SYS_DANGER', 'de', 'GEFAHR'),
('SYS_EMERGENCY', 'de', 'NOTFALL ERKANNT');

-- ============================================================
-- SPANISH TRANSLATIONS (ESPANOL)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_TAB_STATS', 'es', 'Estado'),
('UI_TAB_RANK', 'es', 'Rango'),
('UI_TAB_SHOP', 'es', 'Tienda'),
('UI_TAB_ACHIEV', 'es', 'Logros'),
('UI_TAB_EVENTS', 'es', 'Eventos'),
('UI_TAB_GUIDE', 'es', 'Guia');

-- Guide Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('GUIDE_TITLE', 'es', 'GUIA COMPLETA DEL SISTEMA HUNTER'),
('GUIDE_TAB_RANKS', 'es', 'Rangos'),
('GUIDE_TAB_GLORY', 'es', 'Gloria'),
('GUIDE_TAB_MISSIONS', 'es', 'Misiones'),
('GUIDE_TAB_EVENTS', 'es', 'Eventos'),
('GUIDE_TAB_SHOP', 'es', 'Tienda'),
('GUIDE_TAB_FAQ', 'es', 'FAQ'),
('GUIDE_RANKS_TITLE', 'es', 'SISTEMA DE RANGOS'),
('GUIDE_RANKS_DESC1', 'es', 'Tu Rango determina tu prestigio y el contenido'),
('GUIDE_RANKS_DESC2', 'es', 'al que puedes acceder. Acumula Gloria para subir!');

-- Events Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('EVENTS_HEADER', 'es', 'MISIONES Y EVENTOS'),
('EVENTS_CONTAINS', 'es', 'Esta pantalla contiene:'),
('EVENTS_DESC', 'es', 'Misiones Diarias + Eventos Programados 24H'),
('DAILY_MISSIONS_TITLE', 'es', 'MISIONES DIARIAS (Reset: 00:05)'),
('BTN_OPEN_DETAILS', 'es', 'Abrir Detalles'),
('MISSION_AUTO_OPEN', 'es', 'El Terminal se abre automaticamente cuando progresas!'),
('MISSION_BONUS_TIP', 'es', 'Completa LAS 3 para bonus x1.5 Gloria!');

-- Rank Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('RANK_E_NAME', 'es', 'Despertado'),
('RANK_D_NAME', 'es', 'Aprendiz'),
('RANK_C_NAME', 'es', 'Cazador'),
('RANK_B_NAME', 'es', 'Veterano'),
('RANK_A_NAME', 'es', 'Maestro'),
('RANK_S_NAME', 'es', 'Leyenda'),
('RANK_N_NAME', 'es', 'Monarca');

-- Common UI Elements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_CLOSE', 'es', 'Cerrar'),
('UI_CONFIRM', 'es', 'Confirmar'),
('UI_CANCEL', 'es', 'Cancelar'),
('UI_BACK', 'es', 'Atras'),
('UI_NEXT', 'es', 'Siguiente'),
('UI_LOADING', 'es', 'Cargando...'),
('UI_ERROR', 'es', 'Error'),
('UI_SUCCESS', 'es', 'Exito'),
('UI_GLORY', 'es', 'Gloria'),
('UI_POINTS', 'es', 'Puntos');

-- Shop
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SHOP_TITLE', 'es', 'TIENDA HUNTER'),
('SHOP_BUY', 'es', 'Comprar'),
('SHOP_PRICE', 'es', 'Precio'),
('SHOP_INSUFFICIENT', 'es', 'Gloria insuficiente'),
('SHOP_PURCHASED', 'es', 'Comprado!');

-- Achievements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('ACH_TITLE', 'es', 'LOGROS'),
('ACH_CLAIM', 'es', 'Reclamar'),
('ACH_CLAIMED', 'es', 'Reclamado'),
('ACH_LOCKED', 'es', 'Bloqueado'),
('ACH_PROGRESS', 'es', 'Progreso');

-- System Messages
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SYS_GATE_COMPLETE', 'es', 'Gate completado!'),
('SYS_GATE_FAILED', 'es', 'Gate fallido!'),
('SYS_JACKPOT', 'es', 'JACKPOT!'),
('SYS_DANGER', 'es', 'PELIGRO'),
('SYS_EMERGENCY', 'es', 'EMERGENCIA DETECTADA');

-- ============================================================
-- FRENCH TRANSLATIONS (FRANCAIS)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_TAB_STATS', 'fr', 'Statut'),
('UI_TAB_RANK', 'fr', 'Rang'),
('UI_TAB_SHOP', 'fr', 'Boutique'),
('UI_TAB_ACHIEV', 'fr', 'Succes'),
('UI_TAB_EVENTS', 'fr', 'Events'),
('UI_TAB_GUIDE', 'fr', 'Guide');

-- Guide Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('GUIDE_TITLE', 'fr', 'GUIDE COMPLET DU SYSTEME HUNTER'),
('GUIDE_TAB_RANKS', 'fr', 'Rangs'),
('GUIDE_TAB_GLORY', 'fr', 'Gloire'),
('GUIDE_TAB_MISSIONS', 'fr', 'Missions'),
('GUIDE_TAB_EVENTS', 'fr', 'Events'),
('GUIDE_TAB_SHOP', 'fr', 'Boutique'),
('GUIDE_TAB_FAQ', 'fr', 'FAQ'),
('GUIDE_RANKS_TITLE', 'fr', 'SYSTEME DE RANG'),
('GUIDE_RANKS_DESC1', 'fr', 'Ton Rang determine ton prestige et le contenu'),
('GUIDE_RANKS_DESC2', 'fr', 'auquel tu peux acceder. Accumule de la Gloire pour monter!');

-- Events Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('EVENTS_HEADER', 'fr', 'MISSIONS ET EVENEMENTS'),
('EVENTS_CONTAINS', 'fr', 'Cet ecran contient:'),
('EVENTS_DESC', 'fr', 'Missions Quotidiennes + Evenements Programmes 24H'),
('DAILY_MISSIONS_TITLE', 'fr', 'MISSIONS QUOTIDIENNES (Reset: 00:05)'),
('BTN_OPEN_DETAILS', 'fr', 'Ouvrir Details'),
('MISSION_AUTO_OPEN', 'fr', 'Le Terminal s ouvre automatiquement quand tu progresses!'),
('MISSION_BONUS_TIP', 'fr', 'Complete LES 3 pour un bonus x1.5 Gloire!');

-- Rank Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('RANK_E_NAME', 'fr', 'Eveille'),
('RANK_D_NAME', 'fr', 'Apprenti'),
('RANK_C_NAME', 'fr', 'Chasseur'),
('RANK_B_NAME', 'fr', 'Veteran'),
('RANK_A_NAME', 'fr', 'Maitre'),
('RANK_S_NAME', 'fr', 'Legende'),
('RANK_N_NAME', 'fr', 'Monarque');

-- Common UI Elements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_CLOSE', 'fr', 'Fermer'),
('UI_CONFIRM', 'fr', 'Confirmer'),
('UI_CANCEL', 'fr', 'Annuler'),
('UI_BACK', 'fr', 'Retour'),
('UI_NEXT', 'fr', 'Suivant'),
('UI_LOADING', 'fr', 'Chargement...'),
('UI_ERROR', 'fr', 'Erreur'),
('UI_SUCCESS', 'fr', 'Succes'),
('UI_GLORY', 'fr', 'Gloire'),
('UI_POINTS', 'fr', 'Points');

-- Shop
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SHOP_TITLE', 'fr', 'BOUTIQUE HUNTER'),
('SHOP_BUY', 'fr', 'Acheter'),
('SHOP_PRICE', 'fr', 'Prix'),
('SHOP_INSUFFICIENT', 'fr', 'Gloire insuffisante'),
('SHOP_PURCHASED', 'fr', 'Achete!');

-- Achievements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('ACH_TITLE', 'fr', 'SUCCES'),
('ACH_CLAIM', 'fr', 'Reclamer'),
('ACH_CLAIMED', 'fr', 'Reclame'),
('ACH_LOCKED', 'fr', 'Bloque'),
('ACH_PROGRESS', 'fr', 'Progres');

-- System Messages
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SYS_GATE_COMPLETE', 'fr', 'Gate complete!'),
('SYS_GATE_FAILED', 'fr', 'Gate echoue!'),
('SYS_JACKPOT', 'fr', 'JACKPOT!'),
('SYS_DANGER', 'fr', 'DANGER'),
('SYS_EMERGENCY', 'fr', 'URGENCE DETECTEE');

-- ============================================================
-- PORTUGUESE TRANSLATIONS (PORTUGUES)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_TAB_STATS', 'pt', 'Status'),
('UI_TAB_RANK', 'pt', 'Rank'),
('UI_TAB_SHOP', 'pt', 'Loja'),
('UI_TAB_ACHIEV', 'pt', 'Conquis'),
('UI_TAB_EVENTS', 'pt', 'Eventos'),
('UI_TAB_GUIDE', 'pt', 'Guia');

-- Guide Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('GUIDE_TITLE', 'pt', 'GUIA COMPLETO DO SISTEMA HUNTER'),
('GUIDE_TAB_RANKS', 'pt', 'Ranks'),
('GUIDE_TAB_GLORY', 'pt', 'Gloria'),
('GUIDE_TAB_MISSIONS', 'pt', 'Missoes'),
('GUIDE_TAB_EVENTS', 'pt', 'Eventos'),
('GUIDE_TAB_SHOP', 'pt', 'Loja'),
('GUIDE_TAB_FAQ', 'pt', 'FAQ'),
('GUIDE_RANKS_TITLE', 'pt', 'SISTEMA DE RANKS'),
('GUIDE_RANKS_DESC1', 'pt', 'Seu Rank determina seu prestigio e o conteudo'),
('GUIDE_RANKS_DESC2', 'pt', 'que voce pode acessar. Acumule Gloria para subir!');

-- Events Section
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('EVENTS_HEADER', 'pt', 'MISSOES E EVENTOS'),
('EVENTS_CONTAINS', 'pt', 'Esta tela contem:'),
('EVENTS_DESC', 'pt', 'Missoes Diarias + Eventos Programados 24H'),
('DAILY_MISSIONS_TITLE', 'pt', 'MISSOES DIARIAS (Reset: 00:05)'),
('BTN_OPEN_DETAILS', 'pt', 'Abrir Detalhes'),
('MISSION_AUTO_OPEN', 'pt', 'O Terminal abre automaticamente quando voce progride!'),
('MISSION_BONUS_TIP', 'pt', 'Complete TODAS AS 3 para bonus x1.5 Gloria!');

-- Rank Names
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('RANK_E_NAME', 'pt', 'Despertado'),
('RANK_D_NAME', 'pt', 'Aprendiz'),
('RANK_C_NAME', 'pt', 'Cacador'),
('RANK_B_NAME', 'pt', 'Veterano'),
('RANK_A_NAME', 'pt', 'Mestre'),
('RANK_S_NAME', 'pt', 'Lenda'),
('RANK_N_NAME', 'pt', 'Monarca');

-- Common UI Elements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('UI_CLOSE', 'pt', 'Fechar'),
('UI_CONFIRM', 'pt', 'Confirmar'),
('UI_CANCEL', 'pt', 'Cancelar'),
('UI_BACK', 'pt', 'Voltar'),
('UI_NEXT', 'pt', 'Proximo'),
('UI_LOADING', 'pt', 'Carregando...'),
('UI_ERROR', 'pt', 'Erro'),
('UI_SUCCESS', 'pt', 'Sucesso'),
('UI_GLORY', 'pt', 'Gloria'),
('UI_POINTS', 'pt', 'Pontos');

-- Shop
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SHOP_TITLE', 'pt', 'LOJA HUNTER'),
('SHOP_BUY', 'pt', 'Comprar'),
('SHOP_PRICE', 'pt', 'Preco'),
('SHOP_INSUFFICIENT', 'pt', 'Gloria insuficiente'),
('SHOP_PURCHASED', 'pt', 'Comprado!');

-- Achievements
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('ACH_TITLE', 'pt', 'CONQUISTAS'),
('ACH_CLAIM', 'pt', 'Resgatar'),
('ACH_CLAIMED', 'pt', 'Resgatado'),
('ACH_LOCKED', 'pt', 'Bloqueado'),
('ACH_PROGRESS', 'pt', 'Progresso');

-- System Messages
INSERT INTO `hunter_translations` (`translation_key`, `lang_code`, `text_value`) VALUES
('SYS_GATE_COMPLETE', 'pt', 'Gate completo!'),
('SYS_GATE_FAILED', 'pt', 'Gate falhou!'),
('SYS_JACKPOT', 'pt', 'JACKPOT!'),
('SYS_DANGER', 'pt', 'PERIGO'),
('SYS_EMERGENCY', 'pt', 'EMERGENCIA DETECTADA');

-- ============================================================
-- END OF TRANSLATIONS
-- Run this SQL to update the database with all translations
-- ============================================================
