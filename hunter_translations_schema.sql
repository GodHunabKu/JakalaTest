-- ============================================================
-- HUNTER TRANSLATIONS SYSTEM
-- Multi-language support for Hunter Terminal
-- ============================================================

SET NAMES utf8mb4;

-- ----------------------------
-- Table: hunter_translations
-- Stores all translatable texts with language codes
-- ----------------------------
DROP TABLE IF EXISTS `hunter_translations`;
CREATE TABLE `hunter_translations` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `text_key` VARCHAR(100) NOT NULL COMMENT 'Unique identifier for the text (e.g., UI_RANK_TITLE)',
    `lang_code` VARCHAR(5) NOT NULL COMMENT 'Language code: it, en, de, es, fr, pt, ru, pl',
    `text_value` TEXT NOT NULL COMMENT 'Translated text value',
    `category` VARCHAR(50) NOT NULL DEFAULT 'general' COMMENT 'Category: ui, rank, mission, achievement, event, item, system',
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
INSERT INTO `hunter_languages` VALUES ('ru', 'Russkij', 'Russian', 'flag_ru', 7, 0);
INSERT INTO `hunter_languages` VALUES ('pl', 'Polski', 'Polish', 'flag_pl', 8, 0);

-- ============================================================
-- DEFAULT TRANSLATIONS - ITALIAN (Primary Language)
-- ============================================================

-- UI Category - Main Terminal
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TERMINAL_TITLE', 'it', 'HUNTER TERMINAL', 'ui'),
('UI_TAB_STATUS', 'it', 'STATUS', 'ui'),
('UI_TAB_RANKING', 'it', 'RANKING', 'ui'),
('UI_TAB_SHOP', 'it', 'NEGOZIO', 'ui'),
('UI_TAB_ACHIEVEMENTS', 'it', 'OBIETTIVI', 'ui'),
('UI_TAB_EVENTS', 'it', 'EVENTI', 'ui'),
('UI_TAB_MISSIONS', 'it', 'MISSIONI', 'ui'),
('UI_TAB_SETTINGS', 'it', 'IMPOSTAZIONI', 'ui'),
('UI_CLOSE', 'it', 'CHIUDI', 'ui'),
('UI_CONFIRM', 'it', 'CONFERMA', 'ui'),
('UI_CANCEL', 'it', 'ANNULLA', 'ui'),
('UI_BACK', 'it', 'INDIETRO', 'ui'),
('UI_NEXT', 'it', 'AVANTI', 'ui'),
('UI_LOADING', 'it', 'Caricamento...', 'ui'),
('UI_ERROR', 'it', 'Errore', 'ui'),
('UI_SUCCESS', 'it', 'Successo', 'ui'),
('UI_WARNING', 'it', 'Attenzione', 'ui'),
('UI_LANGUAGE', 'it', 'Lingua', 'ui'),
('UI_LANGUAGE_SELECT', 'it', 'Seleziona Lingua', 'ui');

-- Rank Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'it', 'NOVIZIO', 'rank'),
('RANK_E_TITLE', 'it', 'Cacciatore Novizio', 'rank'),
('RANK_E_SUBTITLE', 'it', 'Inizia il Viaggio', 'rank'),
('RANK_D_NAME', 'it', 'APPRENDISTA', 'rank'),
('RANK_D_TITLE', 'it', 'Cacciatore Apprendista', 'rank'),
('RANK_D_SUBTITLE', 'it', 'Mostra il Potenziale', 'rank'),
('RANK_C_NAME', 'it', 'GUERRIERO', 'rank'),
('RANK_C_TITLE', 'it', 'Cacciatore Guerriero', 'rank'),
('RANK_C_SUBTITLE', 'it', 'Forza Crescente', 'rank'),
('RANK_B_NAME', 'it', 'VETERANO', 'rank'),
('RANK_B_TITLE', 'it', 'Cacciatore Veterano', 'rank'),
('RANK_B_SUBTITLE', 'it', 'Esperienza Comprovata', 'rank'),
('RANK_A_NAME', 'it', 'ELITE', 'rank'),
('RANK_A_TITLE', 'it', 'Cacciatore Elite', 'rank'),
('RANK_A_SUBTITLE', 'it', 'Potere Supremo', 'rank'),
('RANK_S_NAME', 'it', 'LEGGENDA', 'rank'),
('RANK_S_TITLE', 'it', 'Cacciatore Leggendario', 'rank'),
('RANK_S_SUBTITLE', 'it', 'Tra i Migliori', 'rank'),
('RANK_N_NAME', 'it', 'MONARCA', 'rank'),
('RANK_N_TITLE', 'it', 'Monarca Nazionale', 'rank'),
('RANK_N_SUBTITLE', 'it', 'Re delle Ombre', 'rank'),
('RANK_UP_TITLE', 'it', 'R A N K   U P', 'rank'),
('RANK_UP_MSG', 'it', 'Congratulazioni! Sei salito di rango!', 'rank');

-- Mission Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('MISSION_DAILY', 'it', 'Missioni Giornaliere', 'mission'),
('MISSION_WEEKLY', 'it', 'Missioni Settimanali', 'mission'),
('MISSION_PROGRESS', 'it', 'Progresso', 'mission'),
('MISSION_COMPLETE', 'it', 'Completata!', 'mission'),
('MISSION_REWARD', 'it', 'Ricompensa', 'mission'),
('MISSION_TIME_LEFT', 'it', 'Tempo Rimanente', 'mission'),
('MISSION_ALL_COMPLETE', 'it', 'Tutte le Missioni Complete!', 'mission'),
('MISSION_BONUS', 'it', 'Bonus Completamento', 'mission'),
('MISSION_FAILED', 'it', 'Missione Fallita', 'mission'),
('MISSION_NEW', 'it', 'Nuova Missione', 'mission');

-- Achievement Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('ACH_TITLE', 'it', 'Obiettivi', 'achievement'),
('ACH_CLAIMED', 'it', 'Riscattato', 'achievement'),
('ACH_CLAIM', 'it', 'Riscatta', 'achievement'),
('ACH_LOCKED', 'it', 'Bloccato', 'achievement'),
('ACH_PROGRESS', 'it', 'Progresso', 'achievement');

-- Event Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('EVENT_TITLE', 'it', 'Eventi in Corso', 'event'),
('EVENT_SCHEDULE', 'it', 'Programma Eventi', 'event'),
('EVENT_ACTIVE', 'it', 'Attivo', 'event'),
('EVENT_UPCOMING', 'it', 'In Arrivo', 'event'),
('EVENT_ENDED', 'it', 'Terminato', 'event'),
('EVENT_JOIN', 'it', 'Partecipa', 'event'),
('EVENT_PARTICIPANTS', 'it', 'Partecipanti', 'event');

-- Shop Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SHOP_TITLE', 'it', 'Negozio Cacciatori', 'shop'),
('SHOP_BUY', 'it', 'Acquista', 'shop'),
('SHOP_PRICE', 'it', 'Prezzo', 'shop'),
('SHOP_POINTS', 'it', 'Punti Gloria', 'shop'),
('SHOP_INSUFFICIENT', 'it', 'Punti insufficienti', 'shop'),
('SHOP_PURCHASED', 'it', 'Acquistato!', 'shop');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'it', 'Gate completato!', 'system'),
('SYS_GATE_FAILED', 'it', 'Gate fallito!', 'system'),
('SYS_TRIAL_START', 'it', 'Nuova Trial iniziata', 'system'),
('SYS_TRIAL_COMPLETE', 'it', 'Trial completata!', 'system'),
('SYS_EMERGENCY', 'it', 'EMERGENZA RILEVATA', 'system'),
('SYS_EMERGENCY_END', 'it', 'Emergenza terminata', 'system'),
('SYS_FRACTURE', 'it', 'Frattura rilevata!', 'system'),
('SYS_CHEST_OPEN', 'it', 'Baule aperto', 'system'),
('SYS_JACKPOT', 'it', 'JACKPOT!', 'system'),
('SYS_LEVEL_UP', 'it', 'Il tuo potere si risveglia!', 'system'),
('SYS_DANGER', 'it', 'PERICOLO', 'system'),
('SYS_DUNGEON_DETECTED', 'it', 'DUNGEON RILEVATO', 'system'),
('SYS_DUNGEON_COMPLETE', 'it', 'DUNGEON COMPLETATO', 'system'),
('SYS_CRITICAL_FAILURE', 'it', 'FALLIMENTO CRITICO', 'system'),
('SYS_DEATH_PENALTY', 'it', 'SEI MORTO', 'system'),
('SYS_OVERTAKEN', 'it', 'Sei stato superato in classifica!', 'system');

-- Stats Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('STAT_GLORY', 'it', 'Gloria', 'stat'),
('STAT_GLORY_TOTAL', 'it', 'Gloria Totale', 'stat'),
('STAT_GLORY_SPENDABLE', 'it', 'Gloria Spendibile', 'stat'),
('STAT_KILLS', 'it', 'Uccisioni', 'stat'),
('STAT_KILLS_DAILY', 'it', 'Uccisioni Oggi', 'stat'),
('STAT_KILLS_WEEKLY', 'it', 'Uccisioni Settimana', 'stat'),
('STAT_RANK_POS', 'it', 'Posizione Classifica', 'stat'),
('STAT_RANK_DAILY', 'it', 'Classifica Giornaliera', 'stat'),
('STAT_RANK_WEEKLY', 'it', 'Classifica Settimanale', 'stat'),
('STAT_NEXT_RANK', 'it', 'Prossimo Rango', 'stat'),
('STAT_POINTS_NEEDED', 'it', 'Punti Necessari', 'stat');

-- ============================================================
-- ENGLISH TRANSLATIONS
-- ============================================================

-- UI Category - Main Terminal
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TERMINAL_TITLE', 'en', 'HUNTER TERMINAL', 'ui'),
('UI_TAB_STATUS', 'en', 'STATUS', 'ui'),
('UI_TAB_RANKING', 'en', 'RANKING', 'ui'),
('UI_TAB_SHOP', 'en', 'SHOP', 'ui'),
('UI_TAB_ACHIEVEMENTS', 'en', 'ACHIEVEMENTS', 'ui'),
('UI_TAB_EVENTS', 'en', 'EVENTS', 'ui'),
('UI_TAB_MISSIONS', 'en', 'MISSIONS', 'ui'),
('UI_TAB_SETTINGS', 'en', 'SETTINGS', 'ui'),
('UI_CLOSE', 'en', 'CLOSE', 'ui'),
('UI_CONFIRM', 'en', 'CONFIRM', 'ui'),
('UI_CANCEL', 'en', 'CANCEL', 'ui'),
('UI_BACK', 'en', 'BACK', 'ui'),
('UI_NEXT', 'en', 'NEXT', 'ui'),
('UI_LOADING', 'en', 'Loading...', 'ui'),
('UI_ERROR', 'en', 'Error', 'ui'),
('UI_SUCCESS', 'en', 'Success', 'ui'),
('UI_WARNING', 'en', 'Warning', 'ui'),
('UI_LANGUAGE', 'en', 'Language', 'ui'),
('UI_LANGUAGE_SELECT', 'en', 'Select Language', 'ui');

-- Rank Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'en', 'NOVICE', 'rank'),
('RANK_E_TITLE', 'en', 'Novice Hunter', 'rank'),
('RANK_E_SUBTITLE', 'en', 'Begin the Journey', 'rank'),
('RANK_D_NAME', 'en', 'APPRENTICE', 'rank'),
('RANK_D_TITLE', 'en', 'Apprentice Hunter', 'rank'),
('RANK_D_SUBTITLE', 'en', 'Show Potential', 'rank'),
('RANK_C_NAME', 'en', 'WARRIOR', 'rank'),
('RANK_C_TITLE', 'en', 'Warrior Hunter', 'rank'),
('RANK_C_SUBTITLE', 'en', 'Growing Strength', 'rank'),
('RANK_B_NAME', 'en', 'VETERAN', 'rank'),
('RANK_B_TITLE', 'en', 'Veteran Hunter', 'rank'),
('RANK_B_SUBTITLE', 'en', 'Proven Experience', 'rank'),
('RANK_A_NAME', 'en', 'ELITE', 'rank'),
('RANK_A_TITLE', 'en', 'Elite Hunter', 'rank'),
('RANK_A_SUBTITLE', 'en', 'Supreme Power', 'rank'),
('RANK_S_NAME', 'en', 'LEGEND', 'rank'),
('RANK_S_TITLE', 'en', 'Legendary Hunter', 'rank'),
('RANK_S_SUBTITLE', 'en', 'Among the Best', 'rank'),
('RANK_N_NAME', 'en', 'MONARCH', 'rank'),
('RANK_N_TITLE', 'en', 'National Monarch', 'rank'),
('RANK_N_SUBTITLE', 'en', 'Shadow King', 'rank'),
('RANK_UP_TITLE', 'en', 'R A N K   U P', 'rank'),
('RANK_UP_MSG', 'en', 'Congratulations! You ranked up!', 'rank');

-- Mission Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('MISSION_DAILY', 'en', 'Daily Missions', 'mission'),
('MISSION_WEEKLY', 'en', 'Weekly Missions', 'mission'),
('MISSION_PROGRESS', 'en', 'Progress', 'mission'),
('MISSION_COMPLETE', 'en', 'Completed!', 'mission'),
('MISSION_REWARD', 'en', 'Reward', 'mission'),
('MISSION_TIME_LEFT', 'en', 'Time Remaining', 'mission'),
('MISSION_ALL_COMPLETE', 'en', 'All Missions Complete!', 'mission'),
('MISSION_BONUS', 'en', 'Completion Bonus', 'mission'),
('MISSION_FAILED', 'en', 'Mission Failed', 'mission'),
('MISSION_NEW', 'en', 'New Mission', 'mission');

-- Achievement Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('ACH_TITLE', 'en', 'Achievements', 'achievement'),
('ACH_CLAIMED', 'en', 'Claimed', 'achievement'),
('ACH_CLAIM', 'en', 'Claim', 'achievement'),
('ACH_LOCKED', 'en', 'Locked', 'achievement'),
('ACH_PROGRESS', 'en', 'Progress', 'achievement');

-- Event Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('EVENT_TITLE', 'en', 'Active Events', 'event'),
('EVENT_SCHEDULE', 'en', 'Event Schedule', 'event'),
('EVENT_ACTIVE', 'en', 'Active', 'event'),
('EVENT_UPCOMING', 'en', 'Upcoming', 'event'),
('EVENT_ENDED', 'en', 'Ended', 'event'),
('EVENT_JOIN', 'en', 'Join', 'event'),
('EVENT_PARTICIPANTS', 'en', 'Participants', 'event');

-- Shop Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SHOP_TITLE', 'en', 'Hunter Shop', 'shop'),
('SHOP_BUY', 'en', 'Buy', 'shop'),
('SHOP_PRICE', 'en', 'Price', 'shop'),
('SHOP_POINTS', 'en', 'Glory Points', 'shop'),
('SHOP_INSUFFICIENT', 'en', 'Insufficient points', 'shop'),
('SHOP_PURCHASED', 'en', 'Purchased!', 'shop');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'en', 'Gate completed!', 'system'),
('SYS_GATE_FAILED', 'en', 'Gate failed!', 'system'),
('SYS_TRIAL_START', 'en', 'New Trial started', 'system'),
('SYS_TRIAL_COMPLETE', 'en', 'Trial completed!', 'system'),
('SYS_EMERGENCY', 'en', 'EMERGENCY DETECTED', 'system'),
('SYS_EMERGENCY_END', 'en', 'Emergency ended', 'system'),
('SYS_FRACTURE', 'en', 'Fracture detected!', 'system'),
('SYS_CHEST_OPEN', 'en', 'Chest opened', 'system'),
('SYS_JACKPOT', 'en', 'JACKPOT!', 'system'),
('SYS_LEVEL_UP', 'en', 'Your power awakens!', 'system'),
('SYS_DANGER', 'en', 'DANGER', 'system'),
('SYS_DUNGEON_DETECTED', 'en', 'DUNGEON DETECTED', 'system'),
('SYS_DUNGEON_COMPLETE', 'en', 'DUNGEON COMPLETED', 'system'),
('SYS_CRITICAL_FAILURE', 'en', 'CRITICAL FAILURE', 'system'),
('SYS_DEATH_PENALTY', 'en', 'YOU DIED', 'system'),
('SYS_OVERTAKEN', 'en', 'You have been overtaken in ranking!', 'system');

-- Stats Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('STAT_GLORY', 'en', 'Glory', 'stat'),
('STAT_GLORY_TOTAL', 'en', 'Total Glory', 'stat'),
('STAT_GLORY_SPENDABLE', 'en', 'Spendable Glory', 'stat'),
('STAT_KILLS', 'en', 'Kills', 'stat'),
('STAT_KILLS_DAILY', 'en', 'Kills Today', 'stat'),
('STAT_KILLS_WEEKLY', 'en', 'Kills This Week', 'stat'),
('STAT_RANK_POS', 'en', 'Ranking Position', 'stat'),
('STAT_RANK_DAILY', 'en', 'Daily Ranking', 'stat'),
('STAT_RANK_WEEKLY', 'en', 'Weekly Ranking', 'stat'),
('STAT_NEXT_RANK', 'en', 'Next Rank', 'stat'),
('STAT_POINTS_NEEDED', 'en', 'Points Needed', 'stat');

-- ============================================================
-- GERMAN TRANSLATIONS (DEUTSCH)
-- ============================================================

-- UI Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TERMINAL_TITLE', 'de', 'HUNTER TERMINAL', 'ui'),
('UI_TAB_STATUS', 'de', 'STATUS', 'ui'),
('UI_TAB_RANKING', 'de', 'RANGLISTE', 'ui'),
('UI_TAB_SHOP', 'de', 'LADEN', 'ui'),
('UI_TAB_ACHIEVEMENTS', 'de', 'ERFOLGE', 'ui'),
('UI_TAB_EVENTS', 'de', 'EVENTS', 'ui'),
('UI_TAB_MISSIONS', 'de', 'MISSIONEN', 'ui'),
('UI_TAB_SETTINGS', 'de', 'EINSTELLUNGEN', 'ui'),
('UI_CLOSE', 'de', 'SCHLIESSEN', 'ui'),
('UI_CONFIRM', 'de', 'BESTATIGEN', 'ui'),
('UI_CANCEL', 'de', 'ABBRECHEN', 'ui'),
('UI_BACK', 'de', 'ZURUCK', 'ui'),
('UI_NEXT', 'de', 'WEITER', 'ui'),
('UI_LOADING', 'de', 'Laden...', 'ui'),
('UI_ERROR', 'de', 'Fehler', 'ui'),
('UI_SUCCESS', 'de', 'Erfolg', 'ui'),
('UI_WARNING', 'de', 'Warnung', 'ui'),
('UI_LANGUAGE', 'de', 'Sprache', 'ui'),
('UI_LANGUAGE_SELECT', 'de', 'Sprache wahlen', 'ui');

-- Rank Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'de', 'ANFANGER', 'rank'),
('RANK_E_TITLE', 'de', 'Anfanger Jager', 'rank'),
('RANK_E_SUBTITLE', 'de', 'Beginne die Reise', 'rank'),
('RANK_D_NAME', 'de', 'LEHRLING', 'rank'),
('RANK_D_TITLE', 'de', 'Lehrling Jager', 'rank'),
('RANK_D_SUBTITLE', 'de', 'Zeige Potenzial', 'rank'),
('RANK_C_NAME', 'de', 'KRIEGER', 'rank'),
('RANK_C_TITLE', 'de', 'Krieger Jager', 'rank'),
('RANK_C_SUBTITLE', 'de', 'Wachsende Starke', 'rank'),
('RANK_B_NAME', 'de', 'VETERAN', 'rank'),
('RANK_B_TITLE', 'de', 'Veteran Jager', 'rank'),
('RANK_B_SUBTITLE', 'de', 'Bewiesene Erfahrung', 'rank'),
('RANK_A_NAME', 'de', 'ELITE', 'rank'),
('RANK_A_TITLE', 'de', 'Elite Jager', 'rank'),
('RANK_A_SUBTITLE', 'de', 'Hochste Macht', 'rank'),
('RANK_S_NAME', 'de', 'LEGENDE', 'rank'),
('RANK_S_TITLE', 'de', 'Legendarer Jager', 'rank'),
('RANK_S_SUBTITLE', 'de', 'Unter den Besten', 'rank'),
('RANK_N_NAME', 'de', 'MONARCH', 'rank'),
('RANK_N_TITLE', 'de', 'Nationaler Monarch', 'rank'),
('RANK_N_SUBTITLE', 'de', 'Schattenkonig', 'rank'),
('RANK_UP_TITLE', 'de', 'R A N G   A U F', 'rank'),
('RANK_UP_MSG', 'de', 'Gluckwunsch! Du bist aufgestiegen!', 'rank');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'de', 'Gate abgeschlossen!', 'system'),
('SYS_GATE_FAILED', 'de', 'Gate fehlgeschlagen!', 'system'),
('SYS_TRIAL_START', 'de', 'Neue Trial gestartet', 'system'),
('SYS_TRIAL_COMPLETE', 'de', 'Trial abgeschlossen!', 'system'),
('SYS_EMERGENCY', 'de', 'NOTFALL ERKANNT', 'system'),
('SYS_EMERGENCY_END', 'de', 'Notfall beendet', 'system'),
('SYS_FRACTURE', 'de', 'Bruch erkannt!', 'system'),
('SYS_CHEST_OPEN', 'de', 'Truhe geoffnet', 'system'),
('SYS_JACKPOT', 'de', 'JACKPOT!', 'system'),
('SYS_LEVEL_UP', 'de', 'Deine Macht erwacht!', 'system'),
('SYS_DANGER', 'de', 'GEFAHR', 'system'),
('SYS_DUNGEON_DETECTED', 'de', 'DUNGEON ERKANNT', 'system'),
('SYS_DUNGEON_COMPLETE', 'de', 'DUNGEON ABGESCHLOSSEN', 'system'),
('SYS_CRITICAL_FAILURE', 'de', 'KRITISCHER FEHLER', 'system'),
('SYS_DEATH_PENALTY', 'de', 'DU BIST GESTORBEN', 'system'),
('SYS_OVERTAKEN', 'de', 'Du wurdest uberholt!', 'system');

-- ============================================================
-- SPANISH TRANSLATIONS (ESPANOL)
-- ============================================================

-- UI Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TERMINAL_TITLE', 'es', 'HUNTER TERMINAL', 'ui'),
('UI_TAB_STATUS', 'es', 'ESTADO', 'ui'),
('UI_TAB_RANKING', 'es', 'RANKING', 'ui'),
('UI_TAB_SHOP', 'es', 'TIENDA', 'ui'),
('UI_TAB_ACHIEVEMENTS', 'es', 'LOGROS', 'ui'),
('UI_TAB_EVENTS', 'es', 'EVENTOS', 'ui'),
('UI_TAB_MISSIONS', 'es', 'MISIONES', 'ui'),
('UI_TAB_SETTINGS', 'es', 'AJUSTES', 'ui'),
('UI_CLOSE', 'es', 'CERRAR', 'ui'),
('UI_CONFIRM', 'es', 'CONFIRMAR', 'ui'),
('UI_CANCEL', 'es', 'CANCELAR', 'ui'),
('UI_BACK', 'es', 'ATRAS', 'ui'),
('UI_NEXT', 'es', 'SIGUIENTE', 'ui'),
('UI_LOADING', 'es', 'Cargando...', 'ui'),
('UI_ERROR', 'es', 'Error', 'ui'),
('UI_SUCCESS', 'es', 'Exito', 'ui'),
('UI_WARNING', 'es', 'Atencion', 'ui'),
('UI_LANGUAGE', 'es', 'Idioma', 'ui'),
('UI_LANGUAGE_SELECT', 'es', 'Seleccionar Idioma', 'ui');

-- Rank Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'es', 'NOVATO', 'rank'),
('RANK_E_TITLE', 'es', 'Cazador Novato', 'rank'),
('RANK_E_SUBTITLE', 'es', 'Comienza el Viaje', 'rank'),
('RANK_D_NAME', 'es', 'APRENDIZ', 'rank'),
('RANK_D_TITLE', 'es', 'Cazador Aprendiz', 'rank'),
('RANK_D_SUBTITLE', 'es', 'Muestra Potencial', 'rank'),
('RANK_C_NAME', 'es', 'GUERRERO', 'rank'),
('RANK_C_TITLE', 'es', 'Cazador Guerrero', 'rank'),
('RANK_C_SUBTITLE', 'es', 'Fuerza Creciente', 'rank'),
('RANK_B_NAME', 'es', 'VETERANO', 'rank'),
('RANK_B_TITLE', 'es', 'Cazador Veterano', 'rank'),
('RANK_B_SUBTITLE', 'es', 'Experiencia Probada', 'rank'),
('RANK_A_NAME', 'es', 'ELITE', 'rank'),
('RANK_A_TITLE', 'es', 'Cazador Elite', 'rank'),
('RANK_A_SUBTITLE', 'es', 'Poder Supremo', 'rank'),
('RANK_S_NAME', 'es', 'LEYENDA', 'rank'),
('RANK_S_TITLE', 'es', 'Cazador Legendario', 'rank'),
('RANK_S_SUBTITLE', 'es', 'Entre los Mejores', 'rank'),
('RANK_N_NAME', 'es', 'MONARCA', 'rank'),
('RANK_N_TITLE', 'es', 'Monarca Nacional', 'rank'),
('RANK_N_SUBTITLE', 'es', 'Rey de las Sombras', 'rank'),
('RANK_UP_TITLE', 'es', 'S U B I D A', 'rank'),
('RANK_UP_MSG', 'es', 'Felicidades! Has subido de rango!', 'rank');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'es', 'Gate completado!', 'system'),
('SYS_GATE_FAILED', 'es', 'Gate fallido!', 'system'),
('SYS_TRIAL_START', 'es', 'Nueva Trial iniciada', 'system'),
('SYS_TRIAL_COMPLETE', 'es', 'Trial completada!', 'system'),
('SYS_EMERGENCY', 'es', 'EMERGENCIA DETECTADA', 'system'),
('SYS_EMERGENCY_END', 'es', 'Emergencia terminada', 'system'),
('SYS_FRACTURE', 'es', 'Fractura detectada!', 'system'),
('SYS_CHEST_OPEN', 'es', 'Cofre abierto', 'system'),
('SYS_JACKPOT', 'es', 'JACKPOT!', 'system'),
('SYS_LEVEL_UP', 'es', 'Tu poder despierta!', 'system'),
('SYS_DANGER', 'es', 'PELIGRO', 'system'),
('SYS_DUNGEON_DETECTED', 'es', 'DUNGEON DETECTADO', 'system'),
('SYS_DUNGEON_COMPLETE', 'es', 'DUNGEON COMPLETADO', 'system'),
('SYS_CRITICAL_FAILURE', 'es', 'FALLO CRITICO', 'system'),
('SYS_DEATH_PENALTY', 'es', 'HAS MUERTO', 'system'),
('SYS_OVERTAKEN', 'es', 'Te han superado en el ranking!', 'system');

-- ============================================================
-- FRENCH TRANSLATIONS (FRANCAIS)
-- ============================================================

-- UI Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TERMINAL_TITLE', 'fr', 'HUNTER TERMINAL', 'ui'),
('UI_TAB_STATUS', 'fr', 'STATUT', 'ui'),
('UI_TAB_RANKING', 'fr', 'CLASSEMENT', 'ui'),
('UI_TAB_SHOP', 'fr', 'BOUTIQUE', 'ui'),
('UI_TAB_ACHIEVEMENTS', 'fr', 'SUCCES', 'ui'),
('UI_TAB_EVENTS', 'fr', 'EVENEMENTS', 'ui'),
('UI_TAB_MISSIONS', 'fr', 'MISSIONS', 'ui'),
('UI_TAB_SETTINGS', 'fr', 'PARAMETRES', 'ui'),
('UI_CLOSE', 'fr', 'FERMER', 'ui'),
('UI_CONFIRM', 'fr', 'CONFIRMER', 'ui'),
('UI_CANCEL', 'fr', 'ANNULER', 'ui'),
('UI_BACK', 'fr', 'RETOUR', 'ui'),
('UI_NEXT', 'fr', 'SUIVANT', 'ui'),
('UI_LOADING', 'fr', 'Chargement...', 'ui'),
('UI_ERROR', 'fr', 'Erreur', 'ui'),
('UI_SUCCESS', 'fr', 'Succes', 'ui'),
('UI_WARNING', 'fr', 'Attention', 'ui'),
('UI_LANGUAGE', 'fr', 'Langue', 'ui'),
('UI_LANGUAGE_SELECT', 'fr', 'Choisir la Langue', 'ui');

-- Rank Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'fr', 'DEBUTANT', 'rank'),
('RANK_E_TITLE', 'fr', 'Chasseur Debutant', 'rank'),
('RANK_E_SUBTITLE', 'fr', 'Debut du Voyage', 'rank'),
('RANK_D_NAME', 'fr', 'APPRENTI', 'rank'),
('RANK_D_TITLE', 'fr', 'Chasseur Apprenti', 'rank'),
('RANK_D_SUBTITLE', 'fr', 'Montre le Potentiel', 'rank'),
('RANK_C_NAME', 'fr', 'GUERRIER', 'rank'),
('RANK_C_TITLE', 'fr', 'Chasseur Guerrier', 'rank'),
('RANK_C_SUBTITLE', 'fr', 'Force Croissante', 'rank'),
('RANK_B_NAME', 'fr', 'VETERAN', 'rank'),
('RANK_B_TITLE', 'fr', 'Chasseur Veteran', 'rank'),
('RANK_B_SUBTITLE', 'fr', 'Experience Prouvee', 'rank'),
('RANK_A_NAME', 'fr', 'ELITE', 'rank'),
('RANK_A_TITLE', 'fr', 'Chasseur Elite', 'rank'),
('RANK_A_SUBTITLE', 'fr', 'Pouvoir Supreme', 'rank'),
('RANK_S_NAME', 'fr', 'LEGENDE', 'rank'),
('RANK_S_TITLE', 'fr', 'Chasseur Legendaire', 'rank'),
('RANK_S_SUBTITLE', 'fr', 'Parmi les Meilleurs', 'rank'),
('RANK_N_NAME', 'fr', 'MONARQUE', 'rank'),
('RANK_N_TITLE', 'fr', 'Monarque National', 'rank'),
('RANK_N_SUBTITLE', 'fr', 'Roi des Ombres', 'rank'),
('RANK_UP_TITLE', 'fr', 'M O N T E E', 'rank'),
('RANK_UP_MSG', 'fr', 'Felicitations! Tu as monte de rang!', 'rank');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'fr', 'Gate complete!', 'system'),
('SYS_GATE_FAILED', 'fr', 'Gate echoue!', 'system'),
('SYS_TRIAL_START', 'fr', 'Nouvelle Trial commencee', 'system'),
('SYS_TRIAL_COMPLETE', 'fr', 'Trial completee!', 'system'),
('SYS_EMERGENCY', 'fr', 'URGENCE DETECTEE', 'system'),
('SYS_EMERGENCY_END', 'fr', 'Urgence terminee', 'system'),
('SYS_FRACTURE', 'fr', 'Fracture detectee!', 'system'),
('SYS_CHEST_OPEN', 'fr', 'Coffre ouvert', 'system'),
('SYS_JACKPOT', 'fr', 'JACKPOT!', 'system'),
('SYS_LEVEL_UP', 'fr', 'Ton pouvoir se reveille!', 'system'),
('SYS_DANGER', 'fr', 'DANGER', 'system'),
('SYS_DUNGEON_DETECTED', 'fr', 'DONJON DETECTE', 'system'),
('SYS_DUNGEON_COMPLETE', 'fr', 'DONJON COMPLETE', 'system'),
('SYS_CRITICAL_FAILURE', 'fr', 'ECHEC CRITIQUE', 'system'),
('SYS_DEATH_PENALTY', 'fr', 'TU ES MORT', 'system'),
('SYS_OVERTAKEN', 'fr', 'Tu as ete depasse au classement!', 'system');

-- ============================================================
-- PORTUGUESE TRANSLATIONS (PORTUGUES)
-- ============================================================

-- UI Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('UI_TERMINAL_TITLE', 'pt', 'HUNTER TERMINAL', 'ui'),
('UI_TAB_STATUS', 'pt', 'STATUS', 'ui'),
('UI_TAB_RANKING', 'pt', 'RANKING', 'ui'),
('UI_TAB_SHOP', 'pt', 'LOJA', 'ui'),
('UI_TAB_ACHIEVEMENTS', 'pt', 'CONQUISTAS', 'ui'),
('UI_TAB_EVENTS', 'pt', 'EVENTOS', 'ui'),
('UI_TAB_MISSIONS', 'pt', 'MISSOES', 'ui'),
('UI_TAB_SETTINGS', 'pt', 'CONFIGURACOES', 'ui'),
('UI_CLOSE', 'pt', 'FECHAR', 'ui'),
('UI_CONFIRM', 'pt', 'CONFIRMAR', 'ui'),
('UI_CANCEL', 'pt', 'CANCELAR', 'ui'),
('UI_BACK', 'pt', 'VOLTAR', 'ui'),
('UI_NEXT', 'pt', 'PROXIMO', 'ui'),
('UI_LOADING', 'pt', 'Carregando...', 'ui'),
('UI_ERROR', 'pt', 'Erro', 'ui'),
('UI_SUCCESS', 'pt', 'Sucesso', 'ui'),
('UI_WARNING', 'pt', 'Atencao', 'ui'),
('UI_LANGUAGE', 'pt', 'Idioma', 'ui'),
('UI_LANGUAGE_SELECT', 'pt', 'Selecionar Idioma', 'ui');

-- Rank Category
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('RANK_E_NAME', 'pt', 'NOVATO', 'rank'),
('RANK_E_TITLE', 'pt', 'Cacador Novato', 'rank'),
('RANK_E_SUBTITLE', 'pt', 'Comece a Jornada', 'rank'),
('RANK_D_NAME', 'pt', 'APRENDIZ', 'rank'),
('RANK_D_TITLE', 'pt', 'Cacador Aprendiz', 'rank'),
('RANK_D_SUBTITLE', 'pt', 'Mostre Potencial', 'rank'),
('RANK_C_NAME', 'pt', 'GUERREIRO', 'rank'),
('RANK_C_TITLE', 'pt', 'Cacador Guerreiro', 'rank'),
('RANK_C_SUBTITLE', 'pt', 'Forca Crescente', 'rank'),
('RANK_B_NAME', 'pt', 'VETERANO', 'rank'),
('RANK_B_TITLE', 'pt', 'Cacador Veterano', 'rank'),
('RANK_B_SUBTITLE', 'pt', 'Experiencia Comprovada', 'rank'),
('RANK_A_NAME', 'pt', 'ELITE', 'rank'),
('RANK_A_TITLE', 'pt', 'Cacador Elite', 'rank'),
('RANK_A_SUBTITLE', 'pt', 'Poder Supremo', 'rank'),
('RANK_S_NAME', 'pt', 'LENDA', 'rank'),
('RANK_S_TITLE', 'pt', 'Cacador Lendario', 'rank'),
('RANK_S_SUBTITLE', 'pt', 'Entre os Melhores', 'rank'),
('RANK_N_NAME', 'pt', 'MONARCA', 'rank'),
('RANK_N_TITLE', 'pt', 'Monarca Nacional', 'rank'),
('RANK_N_SUBTITLE', 'pt', 'Rei das Sombras', 'rank'),
('RANK_UP_TITLE', 'pt', 'S U B I D A', 'rank'),
('RANK_UP_MSG', 'pt', 'Parabens! Voce subiu de rank!', 'rank');

-- System Messages
INSERT INTO `hunter_translations` (`text_key`, `lang_code`, `text_value`, `category`) VALUES
('SYS_GATE_COMPLETE', 'pt', 'Gate completo!', 'system'),
('SYS_GATE_FAILED', 'pt', 'Gate falhou!', 'system'),
('SYS_TRIAL_START', 'pt', 'Nova Trial iniciada', 'system'),
('SYS_TRIAL_COMPLETE', 'pt', 'Trial completa!', 'system'),
('SYS_EMERGENCY', 'pt', 'EMERGENCIA DETECTADA', 'system'),
('SYS_EMERGENCY_END', 'pt', 'Emergencia terminada', 'system'),
('SYS_FRACTURE', 'pt', 'Fratura detectada!', 'system'),
('SYS_CHEST_OPEN', 'pt', 'Bau aberto', 'system'),
('SYS_JACKPOT', 'pt', 'JACKPOT!', 'system'),
('SYS_LEVEL_UP', 'pt', 'Seu poder desperta!', 'system'),
('SYS_DANGER', 'pt', 'PERIGO', 'system'),
('SYS_DUNGEON_DETECTED', 'pt', 'DUNGEON DETECTADA', 'system'),
('SYS_DUNGEON_COMPLETE', 'pt', 'DUNGEON COMPLETA', 'system'),
('SYS_CRITICAL_FAILURE', 'pt', 'FALHA CRITICA', 'system'),
('SYS_DEATH_PENALTY', 'pt', 'VOCE MORREU', 'system'),
('SYS_OVERTAKEN', 'pt', 'Voce foi ultrapassado no ranking!', 'system');
