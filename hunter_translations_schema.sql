-- ============================================================
-- HUNTER TRANSLATIONS SYSTEM - COMPLETE SCHEMA
-- Multi-language support for Hunter Terminal
-- Version: 2.0 - Full translations for all UI elements
-- ============================================================

SET NAMES utf8mb4;

-- ----------------------------
-- Table: hunter_translations
-- Stores all translatable texts with language codes
-- ----------------------------
DROP TABLE IF EXISTS `hunter_translations`;
CREATE TABLE `hunter_translations` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `text_key` VARCHAR(100) NOT NULL COMMENT 'Unique identifier for the text',
    `lang_code` VARCHAR(5) NOT NULL COMMENT 'Language code: it, en, de, es, fr, pt',
    `text_value` TEXT NOT NULL COMMENT 'Translated text value',
    `category` VARCHAR(50) NOT NULL DEFAULT 'general' COMMENT 'Category: ui, rank, mission, achievement, event, shop, system, guide',
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_key_lang` (`text_key` ASC, `lang_code` ASC) USING BTREE,
    INDEX `idx_lang` (`lang_code` ASC) USING BTREE,
    INDEX `idx_category` (`category` ASC) USING BTREE
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
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TAB_STATS', 'it', 'Stats', 'ui'),
('UI_TAB_RANK', 'it', 'Rank', 'ui'),
('UI_TAB_SHOP', 'it', 'Shop', 'ui'),
('UI_TAB_ACHIEV', 'it', 'Achiev', 'ui'),
('UI_TAB_EVENTS', 'it', 'Eventi', 'ui'),
('UI_TAB_GUIDE', 'it', 'Guida', 'ui');

-- Guide Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('GUIDE_TITLE', 'it', 'GUIDA COMPLETA HUNTER SYSTEM', 'guide'),
('GUIDE_TAB_RANKS', 'it', 'Ranghi', 'guide'),
('GUIDE_TAB_GLORY', 'it', 'Gloria', 'guide'),
('GUIDE_TAB_MISSIONS', 'it', 'Missioni', 'guide'),
('GUIDE_TAB_EVENTS', 'it', 'Eventi', 'guide'),
('GUIDE_TAB_SHOP', 'it', 'Shop', 'guide'),
('GUIDE_TAB_FAQ', 'it', 'FAQ', 'guide'),
('GUIDE_RANKS_TITLE', 'it', 'SISTEMA DEI RANGHI', 'guide'),
('GUIDE_RANKS_DESC1', 'it', 'Il tuo Rango determina il tuo prestigio e i contenuti', 'guide'),
('GUIDE_RANKS_DESC2', 'it', 'a cui puoi accedere. Accumula Gloria per salire!', 'guide');

-- Events Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('EVENTS_HEADER', 'it', 'MISSIONI & EVENTI', 'event'),
('EVENTS_CONTAINS', 'it', 'Questa schermata contiene:', 'event'),
('EVENTS_DESC', 'it', 'Missioni Giornaliere + Eventi Programmati 24H', 'event'),
('DAILY_MISSIONS_TITLE', 'it', 'MISSIONI GIORNALIERE (Reset: 00:05)', 'mission'),
('BTN_OPEN_DETAILS', 'it', 'Apri Dettagli', 'ui'),
('MISSION_AUTO_OPEN', 'it', 'Il Terminale si apre automaticamente quando fai progresso!', 'mission'),
('MISSION_BONUS_TIP', 'it', 'Completa TUTTE E 3 per bonus x1.5 Gloria!', 'mission');

-- Rank Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'it', 'Risvegliato', 'rank'),
('RANK_D_NAME', 'it', 'Apprendista', 'rank'),
('RANK_C_NAME', 'it', 'Cacciatore', 'rank'),
('RANK_B_NAME', 'it', 'Veterano', 'rank'),
('RANK_A_NAME', 'it', 'Maestro', 'rank'),
('RANK_S_NAME', 'it', 'Leggenda', 'rank'),
('RANK_N_NAME', 'it', 'Monarca', 'rank');

-- Common UI Elements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_CLOSE', 'it', 'Chiudi', 'ui'),
('UI_CONFIRM', 'it', 'Conferma', 'ui'),
('UI_CANCEL', 'it', 'Annulla', 'ui'),
('UI_BACK', 'it', 'Indietro', 'ui'),
('UI_NEXT', 'it', 'Avanti', 'ui'),
('UI_LOADING', 'it', 'Caricamento...', 'ui'),
('UI_ERROR', 'it', 'Errore', 'ui'),
('UI_SUCCESS', 'it', 'Successo', 'ui'),
('UI_GLORY', 'it', 'Gloria', 'ui'),
('UI_POINTS', 'it', 'Punti', 'ui');

-- Shop
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SHOP_TITLE', 'it', 'NEGOZIO HUNTER', 'shop'),
('SHOP_BUY', 'it', 'Acquista', 'shop'),
('SHOP_PRICE', 'it', 'Prezzo', 'shop'),
('SHOP_INSUFFICIENT', 'it', 'Gloria insufficiente', 'shop'),
('SHOP_PURCHASED', 'it', 'Acquistato!', 'shop');

-- Achievements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('ACH_TITLE', 'it', 'OBIETTIVI', 'achievement'),
('ACH_CLAIM', 'it', 'Riscuoti', 'achievement'),
('ACH_CLAIMED', 'it', 'Riscattato', 'achievement'),
('ACH_LOCKED', 'it', 'Bloccato', 'achievement'),
('ACH_PROGRESS', 'it', 'Progresso', 'achievement');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'it', 'Gate completato!', 'system'),
('SYS_GATE_FAILED', 'it', 'Gate fallito!', 'system'),
('SYS_JACKPOT', 'it', 'JACKPOT!', 'system'),
('SYS_DANGER', 'it', 'PERICOLO', 'system'),
('SYS_EMERGENCY', 'it', 'EMERGENZA RILEVATA', 'system');

-- ============================================================
-- ENGLISH TRANSLATIONS
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TAB_STATS', 'en', 'Stats', 'ui'),
('UI_TAB_RANK', 'en', 'Rank', 'ui'),
('UI_TAB_SHOP', 'en', 'Shop', 'ui'),
('UI_TAB_ACHIEV', 'en', 'Achiev', 'ui'),
('UI_TAB_EVENTS', 'en', 'Events', 'ui'),
('UI_TAB_GUIDE', 'en', 'Guide', 'ui');

-- Guide Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('GUIDE_TITLE', 'en', 'COMPLETE HUNTER SYSTEM GUIDE', 'guide'),
('GUIDE_TAB_RANKS', 'en', 'Ranks', 'guide'),
('GUIDE_TAB_GLORY', 'en', 'Glory', 'guide'),
('GUIDE_TAB_MISSIONS', 'en', 'Missions', 'guide'),
('GUIDE_TAB_EVENTS', 'en', 'Events', 'guide'),
('GUIDE_TAB_SHOP', 'en', 'Shop', 'guide'),
('GUIDE_TAB_FAQ', 'en', 'FAQ', 'guide'),
('GUIDE_RANKS_TITLE', 'en', 'RANKING SYSTEM', 'guide'),
('GUIDE_RANKS_DESC1', 'en', 'Your Rank determines your prestige and the content', 'guide'),
('GUIDE_RANKS_DESC2', 'en', 'you can access. Accumulate Glory to rank up!', 'guide');

-- Events Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('EVENTS_HEADER', 'en', 'MISSIONS & EVENTS', 'event'),
('EVENTS_CONTAINS', 'en', 'This screen contains:', 'event'),
('EVENTS_DESC', 'en', 'Daily Missions + 24H Scheduled Events', 'event'),
('DAILY_MISSIONS_TITLE', 'en', 'DAILY MISSIONS (Reset: 00:05)', 'mission'),
('BTN_OPEN_DETAILS', 'en', 'Open Details', 'ui'),
('MISSION_AUTO_OPEN', 'en', 'The Terminal opens automatically when you make progress!', 'mission'),
('MISSION_BONUS_TIP', 'en', 'Complete ALL 3 for x1.5 Glory bonus!', 'mission');

-- Rank Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'en', 'Awakened', 'rank'),
('RANK_D_NAME', 'en', 'Apprentice', 'rank'),
('RANK_C_NAME', 'en', 'Hunter', 'rank'),
('RANK_B_NAME', 'en', 'Veteran', 'rank'),
('RANK_A_NAME', 'en', 'Master', 'rank'),
('RANK_S_NAME', 'en', 'Legend', 'rank'),
('RANK_N_NAME', 'en', 'Monarch', 'rank');

-- Common UI Elements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_CLOSE', 'en', 'Close', 'ui'),
('UI_CONFIRM', 'en', 'Confirm', 'ui'),
('UI_CANCEL', 'en', 'Cancel', 'ui'),
('UI_BACK', 'en', 'Back', 'ui'),
('UI_NEXT', 'en', 'Next', 'ui'),
('UI_LOADING', 'en', 'Loading...', 'ui'),
('UI_ERROR', 'en', 'Error', 'ui'),
('UI_SUCCESS', 'en', 'Success', 'ui'),
('UI_GLORY', 'en', 'Glory', 'ui'),
('UI_POINTS', 'en', 'Points', 'ui');

-- Shop
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SHOP_TITLE', 'en', 'HUNTER SHOP', 'shop'),
('SHOP_BUY', 'en', 'Buy', 'shop'),
('SHOP_PRICE', 'en', 'Price', 'shop'),
('SHOP_INSUFFICIENT', 'en', 'Insufficient Glory', 'shop'),
('SHOP_PURCHASED', 'en', 'Purchased!', 'shop');

-- Achievements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('ACH_TITLE', 'en', 'ACHIEVEMENTS', 'achievement'),
('ACH_CLAIM', 'en', 'Claim', 'achievement'),
('ACH_CLAIMED', 'en', 'Claimed', 'achievement'),
('ACH_LOCKED', 'en', 'Locked', 'achievement'),
('ACH_PROGRESS', 'en', 'Progress', 'achievement');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'en', 'Gate completed!', 'system'),
('SYS_GATE_FAILED', 'en', 'Gate failed!', 'system'),
('SYS_JACKPOT', 'en', 'JACKPOT!', 'system'),
('SYS_DANGER', 'en', 'DANGER', 'system'),
('SYS_EMERGENCY', 'en', 'EMERGENCY DETECTED', 'system');

-- ============================================================
-- GERMAN TRANSLATIONS (DEUTSCH)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TAB_STATS', 'de', 'Status', 'ui'),
('UI_TAB_RANK', 'de', 'Rang', 'ui'),
('UI_TAB_SHOP', 'de', 'Shop', 'ui'),
('UI_TAB_ACHIEV', 'de', 'Erfolge', 'ui'),
('UI_TAB_EVENTS', 'de', 'Events', 'ui'),
('UI_TAB_GUIDE', 'de', 'Hilfe', 'ui');

-- Guide Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('GUIDE_TITLE', 'de', 'KOMPLETTER HUNTER SYSTEM GUIDE', 'guide'),
('GUIDE_TAB_RANKS', 'de', 'Range', 'guide'),
('GUIDE_TAB_GLORY', 'de', 'Ruhm', 'guide'),
('GUIDE_TAB_MISSIONS', 'de', 'Missionen', 'guide'),
('GUIDE_TAB_EVENTS', 'de', 'Events', 'guide'),
('GUIDE_TAB_SHOP', 'de', 'Shop', 'guide'),
('GUIDE_TAB_FAQ', 'de', 'FAQ', 'guide'),
('GUIDE_RANKS_TITLE', 'de', 'RANGSYSTEM', 'guide'),
('GUIDE_RANKS_DESC1', 'de', 'Dein Rang bestimmt dein Prestige und die Inhalte', 'guide'),
('GUIDE_RANKS_DESC2', 'de', 'auf die du zugreifen kannst. Sammle Ruhm um aufzusteigen!', 'guide');

-- Events Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('EVENTS_HEADER', 'de', 'MISSIONEN & EVENTS', 'event'),
('EVENTS_CONTAINS', 'de', 'Diese Ansicht enthalt:', 'event'),
('EVENTS_DESC', 'de', 'Tagliche Missionen + 24H geplante Events', 'event'),
('DAILY_MISSIONS_TITLE', 'de', 'TAGLICHE MISSIONEN (Reset: 00:05)', 'mission'),
('BTN_OPEN_DETAILS', 'de', 'Details offnen', 'ui'),
('MISSION_AUTO_OPEN', 'de', 'Das Terminal offnet sich automatisch bei Fortschritt!', 'mission'),
('MISSION_BONUS_TIP', 'de', 'Schliesse ALLE 3 ab fur x1.5 Ruhm Bonus!', 'mission');

-- Rank Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'de', 'Erwacht', 'rank'),
('RANK_D_NAME', 'de', 'Lehrling', 'rank'),
('RANK_C_NAME', 'de', 'Jager', 'rank'),
('RANK_B_NAME', 'de', 'Veteran', 'rank'),
('RANK_A_NAME', 'de', 'Meister', 'rank'),
('RANK_S_NAME', 'de', 'Legende', 'rank'),
('RANK_N_NAME', 'de', 'Monarch', 'rank');

-- Common UI Elements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_CLOSE', 'de', 'Schliessen', 'ui'),
('UI_CONFIRM', 'de', 'Bestatigen', 'ui'),
('UI_CANCEL', 'de', 'Abbrechen', 'ui'),
('UI_BACK', 'de', 'Zuruck', 'ui'),
('UI_NEXT', 'de', 'Weiter', 'ui'),
('UI_LOADING', 'de', 'Laden...', 'ui'),
('UI_ERROR', 'de', 'Fehler', 'ui'),
('UI_SUCCESS', 'de', 'Erfolg', 'ui'),
('UI_GLORY', 'de', 'Ruhm', 'ui'),
('UI_POINTS', 'de', 'Punkte', 'ui');

-- Shop
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SHOP_TITLE', 'de', 'HUNTER SHOP', 'shop'),
('SHOP_BUY', 'de', 'Kaufen', 'shop'),
('SHOP_PRICE', 'de', 'Preis', 'shop'),
('SHOP_INSUFFICIENT', 'de', 'Nicht genug Ruhm', 'shop'),
('SHOP_PURCHASED', 'de', 'Gekauft!', 'shop');

-- Achievements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('ACH_TITLE', 'de', 'ERFOLGE', 'achievement'),
('ACH_CLAIM', 'de', 'Einlosen', 'achievement'),
('ACH_CLAIMED', 'de', 'Eingelost', 'achievement'),
('ACH_LOCKED', 'de', 'Gesperrt', 'achievement'),
('ACH_PROGRESS', 'de', 'Fortschritt', 'achievement');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'de', 'Gate abgeschlossen!', 'system'),
('SYS_GATE_FAILED', 'de', 'Gate fehlgeschlagen!', 'system'),
('SYS_JACKPOT', 'de', 'JACKPOT!', 'system'),
('SYS_DANGER', 'de', 'GEFAHR', 'system'),
('SYS_EMERGENCY', 'de', 'NOTFALL ERKANNT', 'system');

-- ============================================================
-- SPANISH TRANSLATIONS (ESPANOL)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TAB_STATS', 'es', 'Estado', 'ui'),
('UI_TAB_RANK', 'es', 'Rango', 'ui'),
('UI_TAB_SHOP', 'es', 'Tienda', 'ui'),
('UI_TAB_ACHIEV', 'es', 'Logros', 'ui'),
('UI_TAB_EVENTS', 'es', 'Eventos', 'ui'),
('UI_TAB_GUIDE', 'es', 'Guia', 'ui');

-- Guide Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('GUIDE_TITLE', 'es', 'GUIA COMPLETA DEL SISTEMA HUNTER', 'guide'),
('GUIDE_TAB_RANKS', 'es', 'Rangos', 'guide'),
('GUIDE_TAB_GLORY', 'es', 'Gloria', 'guide'),
('GUIDE_TAB_MISSIONS', 'es', 'Misiones', 'guide'),
('GUIDE_TAB_EVENTS', 'es', 'Eventos', 'guide'),
('GUIDE_TAB_SHOP', 'es', 'Tienda', 'guide'),
('GUIDE_TAB_FAQ', 'es', 'FAQ', 'guide'),
('GUIDE_RANKS_TITLE', 'es', 'SISTEMA DE RANGOS', 'guide'),
('GUIDE_RANKS_DESC1', 'es', 'Tu Rango determina tu prestigio y el contenido', 'guide'),
('GUIDE_RANKS_DESC2', 'es', 'al que puedes acceder. Acumula Gloria para subir!', 'guide');

-- Events Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('EVENTS_HEADER', 'es', 'MISIONES Y EVENTOS', 'event'),
('EVENTS_CONTAINS', 'es', 'Esta pantalla contiene:', 'event'),
('EVENTS_DESC', 'es', 'Misiones Diarias + Eventos Programados 24H', 'event'),
('DAILY_MISSIONS_TITLE', 'es', 'MISIONES DIARIAS (Reset: 00:05)', 'mission'),
('BTN_OPEN_DETAILS', 'es', 'Abrir Detalles', 'ui'),
('MISSION_AUTO_OPEN', 'es', 'El Terminal se abre automaticamente cuando progresas!', 'mission'),
('MISSION_BONUS_TIP', 'es', 'Completa LAS 3 para bonus x1.5 Gloria!', 'mission');

-- Rank Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'es', 'Despertado', 'rank'),
('RANK_D_NAME', 'es', 'Aprendiz', 'rank'),
('RANK_C_NAME', 'es', 'Cazador', 'rank'),
('RANK_B_NAME', 'es', 'Veterano', 'rank'),
('RANK_A_NAME', 'es', 'Maestro', 'rank'),
('RANK_S_NAME', 'es', 'Leyenda', 'rank'),
('RANK_N_NAME', 'es', 'Monarca', 'rank');

-- Common UI Elements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_CLOSE', 'es', 'Cerrar', 'ui'),
('UI_CONFIRM', 'es', 'Confirmar', 'ui'),
('UI_CANCEL', 'es', 'Cancelar', 'ui'),
('UI_BACK', 'es', 'Atras', 'ui'),
('UI_NEXT', 'es', 'Siguiente', 'ui'),
('UI_LOADING', 'es', 'Cargando...', 'ui'),
('UI_ERROR', 'es', 'Error', 'ui'),
('UI_SUCCESS', 'es', 'Exito', 'ui'),
('UI_GLORY', 'es', 'Gloria', 'ui'),
('UI_POINTS', 'es', 'Puntos', 'ui');

-- Shop
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SHOP_TITLE', 'es', 'TIENDA HUNTER', 'shop'),
('SHOP_BUY', 'es', 'Comprar', 'shop'),
('SHOP_PRICE', 'es', 'Precio', 'shop'),
('SHOP_INSUFFICIENT', 'es', 'Gloria insuficiente', 'shop'),
('SHOP_PURCHASED', 'es', 'Comprado!', 'shop');

-- Achievements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('ACH_TITLE', 'es', 'LOGROS', 'achievement'),
('ACH_CLAIM', 'es', 'Reclamar', 'achievement'),
('ACH_CLAIMED', 'es', 'Reclamado', 'achievement'),
('ACH_LOCKED', 'es', 'Bloqueado', 'achievement'),
('ACH_PROGRESS', 'es', 'Progreso', 'achievement');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'es', 'Gate completado!', 'system'),
('SYS_GATE_FAILED', 'es', 'Gate fallido!', 'system'),
('SYS_JACKPOT', 'es', 'JACKPOT!', 'system'),
('SYS_DANGER', 'es', 'PELIGRO', 'system'),
('SYS_EMERGENCY', 'es', 'EMERGENCIA DETECTADA', 'system');

-- ============================================================
-- FRENCH TRANSLATIONS (FRANCAIS)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TAB_STATS', 'fr', 'Statut', 'ui'),
('UI_TAB_RANK', 'fr', 'Rang', 'ui'),
('UI_TAB_SHOP', 'fr', 'Boutique', 'ui'),
('UI_TAB_ACHIEV', 'fr', 'Succes', 'ui'),
('UI_TAB_EVENTS', 'fr', 'Events', 'ui'),
('UI_TAB_GUIDE', 'fr', 'Guide', 'ui');

-- Guide Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('GUIDE_TITLE', 'fr', 'GUIDE COMPLET DU SYSTEME HUNTER', 'guide'),
('GUIDE_TAB_RANKS', 'fr', 'Rangs', 'guide'),
('GUIDE_TAB_GLORY', 'fr', 'Gloire', 'guide'),
('GUIDE_TAB_MISSIONS', 'fr', 'Missions', 'guide'),
('GUIDE_TAB_EVENTS', 'fr', 'Events', 'guide'),
('GUIDE_TAB_SHOP', 'fr', 'Boutique', 'guide'),
('GUIDE_TAB_FAQ', 'fr', 'FAQ', 'guide'),
('GUIDE_RANKS_TITLE', 'fr', 'SYSTEME DE RANG', 'guide'),
('GUIDE_RANKS_DESC1', 'fr', 'Ton Rang determine ton prestige et le contenu', 'guide'),
('GUIDE_RANKS_DESC2', 'fr', 'auquel tu peux acceder. Accumule de la Gloire pour monter!', 'guide');

-- Events Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('EVENTS_HEADER', 'fr', 'MISSIONS ET EVENEMENTS', 'event'),
('EVENTS_CONTAINS', 'fr', 'Cet ecran contient:', 'event'),
('EVENTS_DESC', 'fr', 'Missions Quotidiennes + Evenements Programmes 24H', 'event'),
('DAILY_MISSIONS_TITLE', 'fr', 'MISSIONS QUOTIDIENNES (Reset: 00:05)', 'mission'),
('BTN_OPEN_DETAILS', 'fr', 'Ouvrir Details', 'ui'),
('MISSION_AUTO_OPEN', 'fr', 'Le Terminal s ouvre automatiquement quand tu progresses!', 'mission'),
('MISSION_BONUS_TIP', 'fr', 'Complete LES 3 pour un bonus x1.5 Gloire!', 'mission');

-- Rank Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'fr', 'Eveille', 'rank'),
('RANK_D_NAME', 'fr', 'Apprenti', 'rank'),
('RANK_C_NAME', 'fr', 'Chasseur', 'rank'),
('RANK_B_NAME', 'fr', 'Veteran', 'rank'),
('RANK_A_NAME', 'fr', 'Maitre', 'rank'),
('RANK_S_NAME', 'fr', 'Legende', 'rank'),
('RANK_N_NAME', 'fr', 'Monarque', 'rank');

-- Common UI Elements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_CLOSE', 'fr', 'Fermer', 'ui'),
('UI_CONFIRM', 'fr', 'Confirmer', 'ui'),
('UI_CANCEL', 'fr', 'Annuler', 'ui'),
('UI_BACK', 'fr', 'Retour', 'ui'),
('UI_NEXT', 'fr', 'Suivant', 'ui'),
('UI_LOADING', 'fr', 'Chargement...', 'ui'),
('UI_ERROR', 'fr', 'Erreur', 'ui'),
('UI_SUCCESS', 'fr', 'Succes', 'ui'),
('UI_GLORY', 'fr', 'Gloire', 'ui'),
('UI_POINTS', 'fr', 'Points', 'ui');

-- Shop
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SHOP_TITLE', 'fr', 'BOUTIQUE HUNTER', 'shop'),
('SHOP_BUY', 'fr', 'Acheter', 'shop'),
('SHOP_PRICE', 'fr', 'Prix', 'shop'),
('SHOP_INSUFFICIENT', 'fr', 'Gloire insuffisante', 'shop'),
('SHOP_PURCHASED', 'fr', 'Achete!', 'shop');

-- Achievements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('ACH_TITLE', 'fr', 'SUCCES', 'achievement'),
('ACH_CLAIM', 'fr', 'Reclamer', 'achievement'),
('ACH_CLAIMED', 'fr', 'Reclame', 'achievement'),
('ACH_LOCKED', 'fr', 'Bloque', 'achievement'),
('ACH_PROGRESS', 'fr', 'Progres', 'achievement');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'fr', 'Gate complete!', 'system'),
('SYS_GATE_FAILED', 'fr', 'Gate echoue!', 'system'),
('SYS_JACKPOT', 'fr', 'JACKPOT!', 'system'),
('SYS_DANGER', 'fr', 'DANGER', 'system'),
('SYS_EMERGENCY', 'fr', 'URGENCE DETECTEE', 'system');

-- ============================================================
-- PORTUGUESE TRANSLATIONS (PORTUGUES)
-- ============================================================

-- UI Tab Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TAB_STATS', 'pt', 'Status', 'ui'),
('UI_TAB_RANK', 'pt', 'Rank', 'ui'),
('UI_TAB_SHOP', 'pt', 'Loja', 'ui'),
('UI_TAB_ACHIEV', 'pt', 'Conquis', 'ui'),
('UI_TAB_EVENTS', 'pt', 'Eventos', 'ui'),
('UI_TAB_GUIDE', 'pt', 'Guia', 'ui');

-- Guide Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('GUIDE_TITLE', 'pt', 'GUIA COMPLETO DO SISTEMA HUNTER', 'guide'),
('GUIDE_TAB_RANKS', 'pt', 'Ranks', 'guide'),
('GUIDE_TAB_GLORY', 'pt', 'Gloria', 'guide'),
('GUIDE_TAB_MISSIONS', 'pt', 'Missoes', 'guide'),
('GUIDE_TAB_EVENTS', 'pt', 'Eventos', 'guide'),
('GUIDE_TAB_SHOP', 'pt', 'Loja', 'guide'),
('GUIDE_TAB_FAQ', 'pt', 'FAQ', 'guide'),
('GUIDE_RANKS_TITLE', 'pt', 'SISTEMA DE RANKS', 'guide'),
('GUIDE_RANKS_DESC1', 'pt', 'Seu Rank determina seu prestigio e o conteudo', 'guide'),
('GUIDE_RANKS_DESC2', 'pt', 'que voce pode acessar. Acumule Gloria para subir!', 'guide');

-- Events Section
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('EVENTS_HEADER', 'pt', 'MISSOES E EVENTOS', 'event'),
('EVENTS_CONTAINS', 'pt', 'Esta tela contem:', 'event'),
('EVENTS_DESC', 'pt', 'Missoes Diarias + Eventos Programados 24H', 'event'),
('DAILY_MISSIONS_TITLE', 'pt', 'MISSOES DIARIAS (Reset: 00:05)', 'mission'),
('BTN_OPEN_DETAILS', 'pt', 'Abrir Detalhes', 'ui'),
('MISSION_AUTO_OPEN', 'pt', 'O Terminal abre automaticamente quando voce progride!', 'mission'),
('MISSION_BONUS_TIP', 'pt', 'Complete TODAS AS 3 para bonus x1.5 Gloria!', 'mission');

-- Rank Names
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'pt', 'Despertado', 'rank'),
('RANK_D_NAME', 'pt', 'Aprendiz', 'rank'),
('RANK_C_NAME', 'pt', 'Cacador', 'rank'),
('RANK_B_NAME', 'pt', 'Veterano', 'rank'),
('RANK_A_NAME', 'pt', 'Mestre', 'rank'),
('RANK_S_NAME', 'pt', 'Lenda', 'rank'),
('RANK_N_NAME', 'pt', 'Monarca', 'rank');

-- Common UI Elements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_CLOSE', 'pt', 'Fechar', 'ui'),
('UI_CONFIRM', 'pt', 'Confirmar', 'ui'),
('UI_CANCEL', 'pt', 'Cancelar', 'ui'),
('UI_BACK', 'pt', 'Voltar', 'ui'),
('UI_NEXT', 'pt', 'Proximo', 'ui'),
('UI_LOADING', 'pt', 'Carregando...', 'ui'),
('UI_ERROR', 'pt', 'Erro', 'ui'),
('UI_SUCCESS', 'pt', 'Sucesso', 'ui'),
('UI_GLORY', 'pt', 'Gloria', 'ui'),
('UI_POINTS', 'pt', 'Pontos', 'ui');

-- Shop
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SHOP_TITLE', 'pt', 'LOJA HUNTER', 'shop'),
('SHOP_BUY', 'pt', 'Comprar', 'shop'),
('SHOP_PRICE', 'pt', 'Preco', 'shop'),
('SHOP_INSUFFICIENT', 'pt', 'Gloria insuficiente', 'shop'),
('SHOP_PURCHASED', 'pt', 'Comprado!', 'shop');

-- Achievements
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('ACH_TITLE', 'pt', 'CONQUISTAS', 'achievement'),
('ACH_CLAIM', 'pt', 'Resgatar', 'achievement'),
('ACH_CLAIMED', 'pt', 'Resgatado', 'achievement'),
('ACH_LOCKED', 'pt', 'Bloqueado', 'achievement'),
('ACH_PROGRESS', 'pt', 'Progresso', 'achievement');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'pt', 'Gate completo!', 'system'),
('SYS_GATE_FAILED', 'pt', 'Gate falhou!', 'system'),
('SYS_JACKPOT', 'pt', 'JACKPOT!', 'system'),
('SYS_DANGER', 'pt', 'PERIGO', 'system'),
('SYS_EMERGENCY', 'pt', 'EMERGENCIA DETECTADA', 'system');

-- ============================================================
-- END OF TRANSLATIONS
-- Run this SQL to update the database with all translations
-- ============================================================
