/*
 Navicat Premium Data Transfer

 Source Server         : Metin2Hunter2025
 Source Server Type    : MySQL
 Source Server Version : 101111 (10.11.11-MariaDB)
 Source Host           : 81.180.203.146:3306
 Source Schema         : srv1_hunabku

 Target Server Type    : MySQL
 Target Server Version : 101111 (10.11.11-MariaDB)
 File Encoding         : 65001

 Date: 27/12/2025 17:18:18
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for hunter_event_participants
-- ----------------------------
DROP TABLE IF EXISTS `hunter_event_participants`;
CREATE TABLE `hunter_event_participants`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `player_id` int NOT NULL,
  `player_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `joined_at` datetime NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_event_player`(`event_id` ASC, `player_id` ASC) USING BTREE,
  INDEX `idx_joined_at`(`joined_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_event_participants
-- ----------------------------

-- ----------------------------
-- Table structure for hunter_event_winners
-- ----------------------------
DROP TABLE IF EXISTS `hunter_event_winners`;
CREATE TABLE `hunter_event_winners`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `player_id` int NOT NULL,
  `player_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `winner_type` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `winner_data` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `won_at` datetime NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_event_won`(`event_id` ASC, `won_at` ASC) USING BTREE,
  INDEX `idx_player`(`player_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_event_winners
-- ----------------------------

-- ----------------------------
-- Table structure for hunter_gate_access
-- ----------------------------
DROP TABLE IF EXISTS `hunter_gate_access`;
CREATE TABLE `hunter_gate_access`  (
  `access_id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `player_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gate_id` int NOT NULL,
  `granted_at` timestamp NULL DEFAULT current_timestamp,
  `expires_at` timestamp NOT NULL COMMENT 'Quando scade il permesso (2 ore)',
  `status` enum('pending','entered','completed','failed','expired') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'pending',
  `entered_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `gloria_earned` int NULL DEFAULT 0,
  PRIMARY KEY (`access_id`) USING BTREE,
  INDEX `gate_id`(`gate_id` ASC) USING BTREE,
  INDEX `idx_player_status`(`player_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_expires`(`expires_at` ASC) USING BTREE,
  CONSTRAINT `hunter_gate_access_ibfk_1` FOREIGN KEY (`gate_id`) REFERENCES `hunter_gate_config` (`gate_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_gate_access
-- ----------------------------
INSERT INTO `hunter_gate_access` VALUES (4, 2, '[GF]Aelarion', 2, '2025-12-27 06:42:42', '2025-12-27 08:42:42', 'expired', NULL, NULL, 0);
INSERT INTO `hunter_gate_access` VALUES (5, 2, '[GF]Aelarion', 6, '2025-12-27 10:42:42', '2025-12-27 12:42:42', 'expired', NULL, NULL, 0);
INSERT INTO `hunter_gate_access` VALUES (6, 2, '[GF]Aelarion', 6, '2025-12-27 14:42:42', '2025-12-27 16:42:42', 'pending', NULL, NULL, 0);
INSERT INTO `hunter_gate_access` VALUES (7, 4, '[GF]HunabKu', 1, '2025-12-27 15:51:49', '2025-12-27 17:51:49', 'pending', NULL, NULL, 0);
INSERT INTO `hunter_gate_access` VALUES (8, 4, '[GF]HunabKu', 1, '2025-12-27 16:01:34', '2025-12-27 18:01:34', 'pending', NULL, NULL, 0);

-- ----------------------------
-- Table structure for hunter_gate_config
-- ----------------------------
DROP TABLE IF EXISTS `hunter_gate_config`;
CREATE TABLE `hunter_gate_config`  (
  `gate_id` int NOT NULL AUTO_INCREMENT,
  `gate_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gate_grade` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'E,D,C,B,A,S,N',
  `min_rank` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'E',
  `min_level` int NOT NULL DEFAULT 1,
  `dungeon_index` int NOT NULL COMMENT 'Index del dungeon Metin2',
  `duration_minutes` int NOT NULL DEFAULT 30 COMMENT 'Tempo per completare',
  `cooldown_hours` int NOT NULL DEFAULT 24 COMMENT 'Cooldown personale',
  `gloria_reward` int NOT NULL DEFAULT 500,
  `gloria_penalty` int NOT NULL DEFAULT 250 COMMENT 'Se fallisci o scade timer',
  `max_daily_entries` int NOT NULL DEFAULT 1,
  `color_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'BLUE',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`gate_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_gate_config
-- ----------------------------
INSERT INTO `hunter_gate_config` VALUES (1, 'Gate Primordiale', 'E', 'E', 30, 1, 30, 24, 300, 150, 1, 'GREEN', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (2, 'Gate Astrale', 'D', 'D', 50, 2, 25, 24, 500, 250, 1, 'BLUE', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (3, 'Gate Abissale', 'C', 'C', 70, 3, 25, 24, 800, 400, 1, 'ORANGE', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (4, 'Gate Cremisi', 'B', 'B', 85, 4, 20, 24, 1200, 600, 1, 'RED', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (5, 'Gate Aureo', 'A', 'A', 100, 5, 20, 24, 2000, 1000, 1, 'GOLD', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (6, 'Gate Infausto', 'S', 'S', 115, 6, 15, 24, 3500, 1750, 1, 'PURPLE', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (7, 'Gate del Giudizio', 'N', 'N', 130, 7, 15, 24, 5000, 2500, 1, 'BLACKWHITE', 1, '2025-12-27 02:42:41');

-- ----------------------------
-- Table structure for hunter_gate_history
-- ----------------------------
DROP TABLE IF EXISTS `hunter_gate_history`;
CREATE TABLE `hunter_gate_history`  (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `player_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gate_id` int NOT NULL,
  `gate_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `result` enum('completed','failed','expired','death') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gloria_change` int NOT NULL COMMENT 'Positivo o negativo',
  `duration_seconds` int NULL DEFAULT 0,
  `completed_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`history_id`) USING BTREE,
  INDEX `idx_player`(`player_id` ASC) USING BTREE,
  INDEX `idx_date`(`completed_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_gate_history
-- ----------------------------
INSERT INTO `hunter_gate_history` VALUES (1, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 03:02:02');
INSERT INTO `hunter_gate_history` VALUES (2, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 03:02:28');
INSERT INTO `hunter_gate_history` VALUES (3, 4, '[GF]HunabKu', 4, 'Gate Cremisi', 'completed', 1200, 795, '2025-12-27 03:15:09');
INSERT INTO `hunter_gate_history` VALUES (4, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 03:23:19');
INSERT INTO `hunter_gate_history` VALUES (5, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 03:23:33');
INSERT INTO `hunter_gate_history` VALUES (6, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 03:56:13');
INSERT INTO `hunter_gate_history` VALUES (7, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 03:57:11');
INSERT INTO `hunter_gate_history` VALUES (8, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 03:58:34');
INSERT INTO `hunter_gate_history` VALUES (9, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 05:23:33');
INSERT INTO `hunter_gate_history` VALUES (10, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 13:36:48');
INSERT INTO `hunter_gate_history` VALUES (11, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 13:37:36');
INSERT INTO `hunter_gate_history` VALUES (12, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 13:41:53');
INSERT INTO `hunter_gate_history` VALUES (13, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 14:14:10');
INSERT INTO `hunter_gate_history` VALUES (14, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 14:23:36');
INSERT INTO `hunter_gate_history` VALUES (15, 4, '[GF]HunabKu', 0, 'Accesso Negato', 'death', -500, 0, '2025-12-27 14:39:03');
INSERT INTO `hunter_gate_history` VALUES (16, 4, '[GF]HunabKu', 1, 'Gate Primordiale', 'completed', 1125, 300, '2025-12-27 15:51:39');
INSERT INTO `hunter_gate_history` VALUES (17, 4, '[GF]HunabKu', 1, 'Gate Primordiale', 'failed', -250, 300, '2025-12-27 16:01:17');
INSERT INTO `hunter_gate_history` VALUES (18, 4, '[GF]HunabKu', 1, 'Gate Primordiale', 'completed', 1125, 300, '2025-12-27 16:01:25');
INSERT INTO `hunter_gate_history` VALUES (19, 4, '[GF]HunabKu', 1, 'Gate Primordiale', 'completed', 1125, 300, '2025-12-27 16:17:58');

-- ----------------------------
-- Table structure for hunter_gate_selection_config
-- ----------------------------
DROP TABLE IF EXISTS `hunter_gate_selection_config`;
CREATE TABLE `hunter_gate_selection_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT,
  `selection_interval_hours` int NOT NULL DEFAULT 4 COMMENT 'Ogni quante ore seleziona',
  `players_per_selection` int NOT NULL DEFAULT 5 COMMENT 'Quanti giocatori per volta',
  `access_duration_hours` int NOT NULL DEFAULT 2 COMMENT 'Ore di validità accesso',
  `min_rank` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'E',
  `min_level` int NOT NULL DEFAULT 30,
  `min_total_points` int NOT NULL DEFAULT 1000,
  `last_selection_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_gate_selection_config
-- ----------------------------
INSERT INTO `hunter_gate_selection_config` VALUES (1, 4, 5, 2, 'E', 30, 1000, '2025-12-27 14:42:42');

-- ----------------------------
-- Table structure for hunter_login_messages
-- ----------------------------
DROP TABLE IF EXISTS `hunter_login_messages`;
CREATE TABLE `hunter_login_messages`  (
  `day_number` int NOT NULL,
  `message_text` varchar(300) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`day_number`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_login_messages
-- ----------------------------
INSERT INTO `hunter_login_messages` VALUES (1, 'Primo_giorno_di_caccia._Il_viaggio_inizia_ora.');
INSERT INTO `hunter_login_messages` VALUES (2, 'Secondo_giorno._Stai_costruendo_un_abitudine.');
INSERT INTO `hunter_login_messages` VALUES (3, '[BONUS_ATTIVATO]_3_giorni_consecutivi!_+5%_Gloria.');
INSERT INTO `hunter_login_messages` VALUES (4, 'La_costanza_e_la_chiave._Continua_cosi.');
INSERT INTO `hunter_login_messages` VALUES (5, '5_giorni._Gli_altri_Cacciatori_ti_stanno_notando.');
INSERT INTO `hunter_login_messages` VALUES (6, 'Quasi_una_settimana._Il_Sistema_e_impressionato.');
INSERT INTO `hunter_login_messages` VALUES (7, '[BONUS_POTENZIATO]_7_giorni!_+10%_Gloria._Sei_determinato.');
INSERT INTO `hunter_login_messages` VALUES (14, '2_settimane._Pochi_hanno_la_tua_dedizione.');
INSERT INTO `hunter_login_messages` VALUES (21, '3_settimane._Stai_diventando_una_leggenda.');
INSERT INTO `hunter_login_messages` VALUES (30, '[BONUS_MASSIMO]_30_giorni!_+20%_Gloria._Il_Sistema_ti_onora.');
INSERT INTO `hunter_login_messages` VALUES (60, '60_giorni._Sei_un_esempio_per_tutti_i_Cacciatori.');
INSERT INTO `hunter_login_messages` VALUES (90, '90_giorni._Il_tuo_nome_risuona_nelle_cronache.');
INSERT INTO `hunter_login_messages` VALUES (100, '[CENTENARIO]_100_giorni!_Sei_entrato_nella_storia.');
INSERT INTO `hunter_login_messages` VALUES (180, '180_giorni._Mezzo_anno_di_caccia_ininterrotta.');
INSERT INTO `hunter_login_messages` VALUES (365, '[IMMORTALE]_Un_anno_intero!_Sei_diventato_immortale.');

-- ----------------------------
-- Table structure for hunter_mission_definitions
-- ----------------------------
DROP TABLE IF EXISTS `hunter_mission_definitions`;
CREATE TABLE `hunter_mission_definitions`  (
  `mission_id` int NOT NULL AUTO_INCREMENT,
  `mission_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `mission_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'kill_mob, kill_boss, kill_metin, seal_fracture',
  `target_vnum` int NULL DEFAULT 0 COMMENT 'VNUM specifico (0 = qualsiasi)',
  `target_count` int NOT NULL DEFAULT 10,
  `min_rank` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'E' COMMENT 'Rank minimo richiesto',
  `gloria_reward` int NOT NULL DEFAULT 100,
  `gloria_penalty` int NOT NULL DEFAULT 25,
  `time_limit_minutes` int NULL DEFAULT 1440 COMMENT 'Limite tempo in minuti (1440 = 24h)',
  `enabled` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`mission_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_mission_definitions
-- ----------------------------
INSERT INTO `hunter_mission_definitions` VALUES (1, 'Caccia ai Lupi', 'kill_mob', 101, 10, 'E', 50, 10, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (2, 'Stermina gli Orchi', 'kill_mob', 631, 15, 'E', 75, 15, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (3, 'Elimina i Cinghiali', 'kill_mob', 102, 20, 'E', 60, 12, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (4, 'Caccia agli Orsi', 'kill_mob', 1901, 8, 'E', 80, 16, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (5, 'Pulizia Ragni', 'kill_mob', 491, 12, 'E', 55, 11, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (6, 'Uccidi i Banditi', 'kill_mob', 5001, 10, 'E', 70, 14, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (7, 'Caccia Generale', 'kill_mob', 0, 25, 'E', 65, 13, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (8, 'Caccia ai Guerrieri Orco', 'kill_mob', 632, 15, 'D', 100, 20, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (9, 'Stermina gli Scheletri', 'kill_mob', 691, 20, 'D', 110, 22, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (10, 'Elimina i Demoni Minori', 'kill_mob', 1091, 12, 'D', 120, 24, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (11, 'Distruggi 2 Metin', 'kill_metin', 0, 2, 'D', 150, 30, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (12, 'Caccia agli Zombie', 'kill_mob', 791, 18, 'D', 95, 19, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (13, 'Uccidi i Ninja Nemici', 'kill_mob', 5101, 10, 'D', 130, 26, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (14, 'Pulizia Dungeon', 'kill_mob', 0, 30, 'D', 105, 21, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (15, 'Caccia al Boss Ragno', 'kill_boss', 492, 1, 'C', 200, 40, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (16, 'Stermina i Guerrieri Elite', 'kill_mob', 634, 15, 'C', 180, 36, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (17, 'Distruggi 3 Metin', 'kill_metin', 0, 3, 'C', 250, 50, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (18, 'Caccia ai Demoni', 'kill_mob', 1092, 12, 'C', 190, 38, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (19, 'Uccidi Boss Orco', 'kill_boss', 691, 1, 'C', 220, 44, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (20, 'Pulizia Avanzata', 'kill_mob', 0, 40, 'C', 170, 34, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (21, 'Caccia ai Non-Morti', 'kill_mob', 792, 20, 'C', 185, 37, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (22, 'Uccidi il Generale Orco', 'kill_boss', 693, 1, 'B', 350, 70, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (23, 'Distruggi 5 Metin', 'kill_metin', 0, 5, 'B', 400, 80, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (24, 'Sigilla una Frattura', 'seal_fracture', 0, 1, 'B', 500, 100, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (25, 'Caccia ai Demoni Maggiori', 'kill_mob', 1093, 15, 'B', 300, 60, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (26, 'Stermina i Capitani', 'kill_boss', 0, 2, 'B', 380, 76, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (27, 'Pulizia Massiva', 'kill_mob', 0, 60, 'B', 280, 56, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (28, 'Caccia Notturna', 'kill_mob', 793, 25, 'B', 320, 64, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (29, 'Uccidi il Re degli Orchi', 'kill_boss', 694, 1, 'A', 600, 120, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (30, 'Distruggi 8 Metin', 'kill_metin', 0, 8, 'A', 700, 140, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (31, 'Sigilla 2 Fratture', 'seal_fracture', 0, 2, 'A', 900, 180, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (32, 'Caccia ai Boss Demoniaci', 'kill_boss', 1094, 2, 'A', 650, 130, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (33, 'Sterminio Totale', 'kill_mob', 0, 100, 'A', 550, 110, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (34, 'Caccia ai Generali', 'kill_boss', 0, 3, 'A', 720, 144, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (35, 'Elite Hunter', 'kill_mob', 0, 80, 'A', 580, 116, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (36, 'Uccidi il Signore dei Demoni', 'kill_boss', 1095, 1, 'S', 1000, 200, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (37, 'Distruggi 12 Metin', 'kill_metin', 0, 12, 'S', 1100, 220, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (38, 'Sigilla 3 Fratture', 'seal_fracture', 0, 3, 'S', 1500, 300, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (39, 'Caccia Leggendaria', 'kill_boss', 0, 5, 'S', 1200, 240, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (40, 'Massacro', 'kill_mob', 0, 150, 'S', 900, 180, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (41, 'Dominio Assoluto', 'kill_boss', 0, 4, 'S', 1300, 260, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (42, 'Campione del Server', 'kill_mob', 0, 120, 'S', 950, 190, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (43, 'Uccidi il Boss Finale', 'kill_boss', 0, 3, 'N', 2000, 400, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (44, 'Distruggi 20 Metin', 'kill_metin', 0, 20, 'N', 2500, 500, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (45, 'Sigilla 5 Fratture', 'seal_fracture', 0, 5, 'N', 3000, 600, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (46, 'Leggenda Nazionale', 'kill_boss', 0, 8, 'N', 2200, 440, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (47, 'Annientamento', 'kill_mob', 0, 250, 'N', 1800, 360, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (48, 'Imperatore Hunter', 'kill_boss', 0, 6, 'N', 2400, 480, 1440, 1, '2025-12-24 05:34:27');
INSERT INTO `hunter_mission_definitions` VALUES (49, 'Gloria Eterna', 'kill_mob', 0, 200, 'N', 1900, 380, 1440, 1, '2025-12-24 05:34:27');

-- ----------------------------
-- Table structure for hunter_player_missions
-- ----------------------------
DROP TABLE IF EXISTS `hunter_player_missions`;
CREATE TABLE `hunter_player_missions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `mission_slot` int NOT NULL DEFAULT 1 COMMENT 'Slot 1-3',
  `mission_def_id` int NOT NULL COMMENT 'FK a mission_definitions.mission_id',
  `assigned_date` date NOT NULL,
  `current_progress` int NULL DEFAULT 0,
  `target_count` int NOT NULL,
  `status` enum('active','completed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'active',
  `reward_glory` int NOT NULL DEFAULT 100,
  `penalty_glory` int NOT NULL DEFAULT 25,
  `completed_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_player_slot_day`(`player_id` ASC, `mission_slot` ASC, `assigned_date` ASC) USING BTREE,
  INDEX `idx_player_date`(`player_id` ASC, `assigned_date` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `mission_def_id`(`mission_def_id` ASC) USING BTREE,
  CONSTRAINT `hunter_player_missions_ibfk_1` FOREIGN KEY (`mission_def_id`) REFERENCES `hunter_mission_definitions` (`mission_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_player_missions
-- ----------------------------
INSERT INTO `hunter_player_missions` VALUES (28, 4, 1, 18, '2025-12-27', 12, 12, 'completed', 190, 38, '2025-12-27 02:10:07');
INSERT INTO `hunter_player_missions` VALUES (29, 4, 2, 7, '2025-12-27', 25, 25, 'completed', 65, 13, '2025-12-27 01:59:25');
INSERT INTO `hunter_player_missions` VALUES (30, 4, 3, 9, '2025-12-27', 0, 20, 'active', 110, 22, NULL);
INSERT INTO `hunter_player_missions` VALUES (31, 3900, 1, 7, '2025-12-27', 0, 25, 'active', 65, 13, NULL);
INSERT INTO `hunter_player_missions` VALUES (32, 3900, 2, 2, '2025-12-27', 0, 15, 'active', 75, 15, NULL);
INSERT INTO `hunter_player_missions` VALUES (33, 3900, 3, 6, '2025-12-27', 0, 10, 'active', 70, 14, NULL);
INSERT INTO `hunter_player_missions` VALUES (34, 2, 1, 5, '2025-12-27', 0, 12, 'active', 55, 11, NULL);
INSERT INTO `hunter_player_missions` VALUES (35, 2, 2, 18, '2025-12-27', 0, 12, 'active', 190, 38, NULL);
INSERT INTO `hunter_player_missions` VALUES (36, 2, 3, 17, '2025-12-27', 0, 3, 'active', 250, 50, NULL);

-- ----------------------------
-- Table structure for hunter_player_trials
-- ----------------------------
DROP TABLE IF EXISTS `hunter_player_trials`;
CREATE TABLE `hunter_player_trials`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `trial_id` int NOT NULL,
  `status` enum('locked','available','in_progress','completed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'locked',
  `boss_kills` int NOT NULL DEFAULT 0,
  `metin_kills` int NOT NULL DEFAULT 0,
  `fracture_seals` int NOT NULL DEFAULT 0,
  `chest_opens` int NOT NULL DEFAULT 0,
  `daily_missions` int NOT NULL DEFAULT 0,
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL COMMENT 'Se ha time limit',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_player_trial`(`player_id` ASC, `trial_id` ASC) USING BTREE,
  INDEX `trial_id`(`trial_id` ASC) USING BTREE,
  INDEX `idx_player_status`(`player_id` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `hunter_player_trials_ibfk_1` FOREIGN KEY (`trial_id`) REFERENCES `hunter_rank_trials` (`trial_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_player_trials
-- ----------------------------
INSERT INTO `hunter_player_trials` VALUES (4, 4, 1, 'in_progress', 0, 0, 0, 0, 0, '2025-12-27 16:17:22', NULL, NULL);

-- ----------------------------
-- Table structure for hunter_quest_achievements_config
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_achievements_config`;
CREATE TABLE `hunter_quest_achievements_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `type` int NULL DEFAULT 1,
  `requirement` int NULL DEFAULT 0,
  `reward_vnum` int NULL DEFAULT 0,
  `reward_count` int NULL DEFAULT 0,
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_achievements_config
-- ----------------------------
INSERT INTO `hunter_quest_achievements_config` VALUES (1, 'Novizio (Kill)', 1, 10, 80030, 1, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (2, 'Principiante (Kill)', 1, 50, 80030, 5, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (3, 'Cacciatore D (Kill)', 1, 100, 80031, 1, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (4, 'Cacciatore C (Kill)', 1, 250, 80031, 2, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (5, 'Cacciatore B (Kill)', 1, 500, 80032, 1, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (6, 'Cacciatore A (Kill)', 1, 1000, 80032, 2, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (7, 'Elite S (Kill)', 1, 2500, 80032, 5, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (8, 'Fama Nascente (Punti)', 2, 5000, 80030, 10, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (9, 'Fama Media (Punti)', 2, 20000, 80031, 5, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (10, 'Fama Alta (Punti)', 2, 50000, 80032, 5, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (11, 'Leggenda (Punti)', 2, 100000, 80040, 1, 1);
INSERT INTO `hunter_quest_achievements_config` VALUES (12, 'MONARCA (Punti)', 2, 500000, 80039, 1, 1);

-- ----------------------------
-- Table structure for hunter_quest_config
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_config`;
CREATE TABLE `hunter_quest_config`  (
  `config_key` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `config_value` int NULL DEFAULT 0,
  PRIMARY KEY (`config_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_config
-- ----------------------------
INSERT INTO `hunter_quest_config` VALUES ('bonus_all_missions_complete', 50);
INSERT INTO `hunter_quest_config` VALUES ('bonus_speed_kill_multiplier', 2);
INSERT INTO `hunter_quest_config` VALUES ('challenge_time_seconds', 60);
INSERT INTO `hunter_quest_config` VALUES ('conversion_gloria_to_credits', 10);
INSERT INTO `hunter_quest_config` VALUES ('daily_reset_hour', 0);
INSERT INTO `hunter_quest_config` VALUES ('emergency_chance_percent', 40);
INSERT INTO `hunter_quest_config` VALUES ('rank_threshold_A', 150000);
INSERT INTO `hunter_quest_config` VALUES ('rank_threshold_B', 50000);
INSERT INTO `hunter_quest_config` VALUES ('rank_threshold_C', 10000);
INSERT INTO `hunter_quest_config` VALUES ('rank_threshold_D', 2000);
INSERT INTO `hunter_quest_config` VALUES ('rank_threshold_E', 0);
INSERT INTO `hunter_quest_config` VALUES ('rank_threshold_N', 1500000);
INSERT INTO `hunter_quest_config` VALUES ('rank_threshold_S', 500000);
INSERT INTO `hunter_quest_config` VALUES ('rival_range_chests', 50);
INSERT INTO `hunter_quest_config` VALUES ('rival_range_daily', 500);
INSERT INTO `hunter_quest_config` VALUES ('rival_range_fractures', 20);
INSERT INTO `hunter_quest_config` VALUES ('rival_range_metins', 50);
INSERT INTO `hunter_quest_config` VALUES ('rival_range_total', 50000);
INSERT INTO `hunter_quest_config` VALUES ('rival_range_weekly', 2000);
INSERT INTO `hunter_quest_config` VALUES ('seal_fracture_bonus', 200);
INSERT INTO `hunter_quest_config` VALUES ('spawn_threshold_normal', 500);
INSERT INTO `hunter_quest_config` VALUES ('speedkill_boss_seconds', 60);
INSERT INTO `hunter_quest_config` VALUES ('speedkill_metin_seconds', 300);
INSERT INTO `hunter_quest_config` VALUES ('streak_days_tier1', 3);
INSERT INTO `hunter_quest_config` VALUES ('streak_days_tier2', 7);
INSERT INTO `hunter_quest_config` VALUES ('streak_days_tier3', 30);
INSERT INTO `hunter_quest_config` VALUES ('timer_reset_check', 60);
INSERT INTO `hunter_quest_config` VALUES ('timer_tips_random', 90);
INSERT INTO `hunter_quest_config` VALUES ('timer_update_stats', 60);
INSERT INTO `hunter_quest_config` VALUES ('welcome_offline_seconds', 120);
INSERT INTO `hunter_quest_config` VALUES ('whatif_chance_percent', 50);

-- ----------------------------
-- Table structure for hunter_quest_emergencies
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_emergencies`;
CREATE TABLE `hunter_quest_emergencies`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `duration_seconds` int NULL DEFAULT 60,
  `target_vnum` int NULL DEFAULT 0,
  `target_count` int NULL DEFAULT 10,
  `reward_points` int NULL DEFAULT 100,
  `reward_item_vnum` int NULL DEFAULT 0,
  `reward_item_count` int NULL DEFAULT 0,
  `enabled` int NULL DEFAULT 1,
  `min_level` int NULL DEFAULT 1,
  `max_level` int NULL DEFAULT 120,
  `difficulty` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'NORMAL',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 9 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_emergencies
-- ----------------------------
INSERT INTO `hunter_quest_emergencies` VALUES (1, 'Sopravvivi all\'Orda', 'Uccidi 60 mostri in 60 secondi. Fai del tuo meglio!', 60, 0, 60, 300, 0, 0, 1, 5, 120, 'HARD');
INSERT INTO `hunter_quest_emergencies` VALUES (2, 'Distruttore di Metin', 'Distruggi 5 Metin in 3 minuti. Preparati a correre!', 180, 0, 5, 500, 0, 0, 1, 15, 120, 'HARD');
INSERT INTO `hunter_quest_emergencies` VALUES (3, 'Difesa Disperata', 'Elimina 120 nemici in 90 secondi. (1.3 kill al secondo)', 90, 0, 120, 600, 0, 0, 1, 30, 120, 'EXTREME');
INSERT INTO `hunter_quest_emergencies` VALUES (4, 'Cacciatore di Boss', 'Uccidi 3 Boss in 180 secondi. (Puoi cambiare CH)', 180, 0, 3, 1000, 0, 0, 1, 40, 120, 'EXTREME');
INSERT INTO `hunter_quest_emergencies` VALUES (5, 'Il Massacro', 'Uccidi 250 creature in 180 secondi. Serve AOE potente!', 180, 0, 250, 1200, 0, 0, 1, 50, 120, 'GOD_MODE');
INSERT INTO `hunter_quest_emergencies` VALUES (6, 'Prova del Novizio', 'Uccidi 30 mostri in 60 secondi. Missione introduttiva!', 60, 0, 30, 150, 0, 0, 1, 1, 50, 'EASY');
INSERT INTO `hunter_quest_emergencies` VALUES (7, 'Caccia Rapida', 'Uccidi 2 Boss in 120 secondi.', 120, 0, 2, 400, 0, 0, 1, 20, 80, 'NORMAL');
INSERT INTO `hunter_quest_emergencies` VALUES (8, 'Metin Sprint', 'Distruggi 3 Metin in 150 secondi.', 150, 0, 3, 350, 0, 0, 1, 15, 90, 'NORMAL');

-- ----------------------------
-- Table structure for hunter_quest_fractures
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_fractures`;
CREATE TABLE `hunter_quest_fractures`  (
  `vnum` int NOT NULL,
  `name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `rank_label` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `color_code` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'PURPLE',
  `spawn_chance` int NULL DEFAULT 10,
  `req_points` int NULL DEFAULT 0,
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`vnum`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_fractures
-- ----------------------------
INSERT INTO `hunter_quest_fractures` VALUES (16060, 'Frattura Primordiale', 'E-Rank', 'GREEN', 35, 0, 1);
INSERT INTO `hunter_quest_fractures` VALUES (16061, 'Frattura Astrale', 'D-Rank', 'BLUE', 25, 2000, 1);
INSERT INTO `hunter_quest_fractures` VALUES (16062, 'Frattura Abissale', 'C-Rank', 'ORANGE', 15, 10000, 1);
INSERT INTO `hunter_quest_fractures` VALUES (16063, 'Frattura Cremisi', 'B-Rank', 'RED', 10, 50000, 1);
INSERT INTO `hunter_quest_fractures` VALUES (16064, 'Frattura Aurea', 'A-Rank', 'GOLD', 8, 150000, 1);
INSERT INTO `hunter_quest_fractures` VALUES (16065, 'Frattura Infausta', 'S-Rank', 'PURPLE', 5, 500000, 1);
INSERT INTO `hunter_quest_fractures` VALUES (16066, 'Frattura del Giudizio', 'National', 'BLACKWHITE', 2, 1500000, 1);

-- ----------------------------
-- Table structure for hunter_quest_jackpot_rewards
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_jackpot_rewards`;
CREATE TABLE `hunter_quest_jackpot_rewards`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `item_vnum` int NOT NULL,
  `item_quantity` int NULL DEFAULT 1,
  `bonus_points` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_jackpot_rewards
-- ----------------------------
INSERT INTO `hunter_quest_jackpot_rewards` VALUES (1, 'JACKPOT', 80031, 1, 500);
INSERT INTO `hunter_quest_jackpot_rewards` VALUES (2, 'JACKPOT', 80032, 1, 1000);
INSERT INTO `hunter_quest_jackpot_rewards` VALUES (3, 'JACKPOT', 80040, 1, 0);
INSERT INTO `hunter_quest_jackpot_rewards` VALUES (4, 'BAULE', 80030, 1, 10);
INSERT INTO `hunter_quest_jackpot_rewards` VALUES (5, 'BAULE', 80031, 1, 50);

-- ----------------------------
-- Table structure for hunter_quest_ranking
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_ranking`;
CREATE TABLE `hunter_quest_ranking`  (
  `player_id` int NOT NULL,
  `player_name` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `hunter_rank` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'E',
  `total_points` int NULL DEFAULT 0,
  `spendable_points` int NULL DEFAULT 0,
  `daily_points` int NULL DEFAULT 0,
  `weekly_points` int NULL DEFAULT 0,
  `total_kills` int NULL DEFAULT 0,
  `daily_kills` int NULL DEFAULT 0,
  `weekly_kills` int NULL DEFAULT 0,
  `login_streak` int NULL DEFAULT 0,
  `last_login` int NULL DEFAULT 0,
  `penalty_strikes` int NULL DEFAULT 0,
  `rival_pid` int NULL DEFAULT 0,
  `pending_daily_reward` int NULL DEFAULT 0,
  `pending_weekly_reward` int NULL DEFAULT 0,
  `total_fractures` int NULL DEFAULT 0,
  `total_chests` int NULL DEFAULT 0,
  `total_metins` int NULL DEFAULT 0,
  `current_rank` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'E',
  `last_activity` datetime NULL DEFAULT current_timestamp,
  `penalty_active` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Penalita attiva: 0=no, 1=si',
  `penalty_expires` int UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Timestamp UNIX scadenza penalita',
  `failed_missions` int UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Numero missioni fallite (reset a 0 dopo penalita)',
  `overtaken_by` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `overtaken_diff` int NULL DEFAULT 0,
  `overtaken_label` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`player_id`) USING BTREE,
  INDEX `idx_penalty_status`(`penalty_active` ASC, `penalty_expires` ASC) USING BTREE,
  INDEX `idx_failed_missions`(`failed_missions` ASC) USING BTREE,
  INDEX `idx_penalty`(`penalty_active` ASC, `penalty_expires` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_ranking
-- ----------------------------
INSERT INTO `hunter_quest_ranking` VALUES (2, '[GF]Aelarion', 'C', 34000, 24000, 0, 17000, 300, 0, 100, 0, 0, 0, 0, 1, 1, 48, 0, 0, 'C', '2025-12-21 17:41:26', 0, 0, 0, NULL, 0, NULL);
INSERT INTO `hunter_quest_ranking` VALUES (4, '[GF]HunabKu', 'E', 50325, 147852, 15277, 40025, 341, 30, 111, 0, 0, 0, 0, 1, 1, 147, 0, 52, 'E', '2025-12-21 14:12:05', 0, 0, 0, NULL, 0, NULL);
INSERT INTO `hunter_quest_ranking` VALUES (3893, 'Potenza', 'E', 95, 95, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1, 0, 0, 'E', '2025-12-23 18:06:07', 0, 0, 0, NULL, 0, NULL);
INSERT INTO `hunter_quest_ranking` VALUES (3895, '123123123', 'E', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'E', '2025-12-25 12:02:22', 0, 0, 0, '[GF]HunabKu', 108, 'GIORNALIERA');
INSERT INTO `hunter_quest_ranking` VALUES (3900, 'asdasdasd2', 'E', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'E', '2025-12-27 05:24:00', 0, 0, 0, NULL, 0, NULL);

-- ----------------------------
-- Table structure for hunter_quest_rewards
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_rewards`;
CREATE TABLE `hunter_quest_rewards`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `reward_type` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'daily',
  `rank_position` int NULL DEFAULT 1,
  `item_vnum` int NOT NULL,
  `item_quantity` int NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_rewards
-- ----------------------------
INSERT INTO `hunter_quest_rewards` VALUES (1, 'daily', 1, 80032, 2);
INSERT INTO `hunter_quest_rewards` VALUES (2, 'daily', 2, 80031, 2);
INSERT INTO `hunter_quest_rewards` VALUES (3, 'daily', 3, 80030, 2);
INSERT INTO `hunter_quest_rewards` VALUES (4, 'weekly', 1, 80039, 1);
INSERT INTO `hunter_quest_rewards` VALUES (5, 'weekly', 2, 80040, 1);
INSERT INTO `hunter_quest_rewards` VALUES (6, 'weekly', 3, 80032, 5);

-- ----------------------------
-- Table structure for hunter_quest_shop
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_shop`;
CREATE TABLE `hunter_quest_shop`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_vnum` int NOT NULL,
  `item_count` int NULL DEFAULT 1,
  `price_points` int NULL DEFAULT 1000,
  `description` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'Item',
  `display_order` int NULL DEFAULT 0,
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_shop
-- ----------------------------
INSERT INTO `hunter_quest_shop` VALUES (1, 80030, 1, 500, 'Buono 100 Punti', 1, 1);
INSERT INTO `hunter_quest_shop` VALUES (2, 80031, 1, 2500, 'Buono 500 Punti', 2, 1);
INSERT INTO `hunter_quest_shop` VALUES (3, 80032, 1, 5000, 'Buono 1000 Punti', 3, 1);
INSERT INTO `hunter_quest_shop` VALUES (4, 80040, 1, 200000, 'Buono 50 DR', 4, 1);
INSERT INTO `hunter_quest_shop` VALUES (5, 80039, 1, 500000, 'Buono 100 DR', 5, 1);

-- ----------------------------
-- Table structure for hunter_quest_spawn_types
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_spawn_types`;
CREATE TABLE `hunter_quest_spawn_types`  (
  `type_name` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `probability` int NULL DEFAULT 0,
  `is_jackpot` tinyint(1) NULL DEFAULT 0,
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`type_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_spawn_types
-- ----------------------------
INSERT INTO `hunter_quest_spawn_types` VALUES ('BAULE', 100, 0, 1);
INSERT INTO `hunter_quest_spawn_types` VALUES ('BOSS', 650, 0, 1);
INSERT INTO `hunter_quest_spawn_types` VALUES ('JACKPOT', 25, 1, 1);
INSERT INTO `hunter_quest_spawn_types` VALUES ('SUPER_METIN', 300, 0, 1);

-- ----------------------------
-- Table structure for hunter_quest_spawns
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_spawns`;
CREATE TABLE `hunter_quest_spawns`  (
  `spawn_id` int NOT NULL AUTO_INCREMENT,
  `vnum` int NOT NULL,
  `name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `type_name` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `min_level` int NULL DEFAULT 1,
  `max_level` int NULL DEFAULT 250,
  `base_points` int NULL DEFAULT 100,
  `rank_color` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'PURPLE',
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`spawn_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_spawns
-- ----------------------------
INSERT INTO `hunter_quest_spawns` VALUES (1, 4700, 'Metin Lv.45', 'SUPER_METIN', 35, 55, 50, 'GREEN', 1);
INSERT INTO `hunter_quest_spawns` VALUES (2, 4701, 'Metin Lv.60', 'SUPER_METIN', 50, 70, 70, 'GREEN', 1);
INSERT INTO `hunter_quest_spawns` VALUES (3, 4702, 'Metin Lv.75', 'SUPER_METIN', 65, 85, 90, 'BLUE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (4, 4703, 'Metin Lv.90', 'SUPER_METIN', 80, 100, 110, 'BLUE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (5, 4704, 'Metin Lv.95', 'SUPER_METIN', 85, 105, 130, 'ORANGE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (6, 4705, 'Metin Lv.115', 'SUPER_METIN', 105, 125, 150, 'ORANGE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (7, 4706, 'Metin Lv.135', 'SUPER_METIN', 125, 150, 180, 'RED', 1);
INSERT INTO `hunter_quest_spawns` VALUES (8, 4707, 'Metin Lv.165', 'SUPER_METIN', 150, 180, 220, 'GOLD', 1);
INSERT INTO `hunter_quest_spawns` VALUES (9, 4708, 'Metin Lv.200', 'SUPER_METIN', 180, 250, 300, 'PURPLE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (10, 4035, 'Funglash', 'BOSS', 65, 85, 100, 'GREEN', 1);
INSERT INTO `hunter_quest_spawns` VALUES (11, 719, 'Thaloren', 'BOSS', 85, 105, 120, 'BLUE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (12, 2771, 'Yinlee', 'BOSS', 90, 110, 140, 'BLUE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (13, 768, 'Slubina', 'BOSS', 105, 125, 160, 'ORANGE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (14, 6790, 'Alastor', 'BOSS', 115, 135, 180, 'ORANGE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (15, 6831, 'Grimlor', 'BOSS', 125, 145, 200, 'RED', 1);
INSERT INTO `hunter_quest_spawns` VALUES (16, 986, 'Branzhul', 'BOSS', 140, 160, 250, 'RED', 1);
INSERT INTO `hunter_quest_spawns` VALUES (17, 989, 'Torgal', 'BOSS', 155, 175, 300, 'GOLD', 1);
INSERT INTO `hunter_quest_spawns` VALUES (18, 4011, 'Nerzakar', 'BOSS', 175, 195, 350, 'GOLD', 1);
INSERT INTO `hunter_quest_spawns` VALUES (19, 6830, 'Nozzera', 'BOSS', 190, 210, 400, 'PURPLE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (20, 4385, 'Velzahar', 'BOSS', 200, 250, 500, 'BLACKWHITE', 1);
INSERT INTO `hunter_quest_spawns` VALUES (21, 200102, 'Cassa E-Rank', 'BAULE', 1, 250, 20, 'GREEN', 1);
INSERT INTO `hunter_quest_spawns` VALUES (22, 200101, 'Cassa S-Rank', 'BAULE', 1, 250, 50, 'PURPLE', 1);

-- ----------------------------
-- Table structure for hunter_quest_tips
-- ----------------------------
DROP TABLE IF EXISTS `hunter_quest_tips`;
CREATE TABLE `hunter_quest_tips`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `tip_text` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_tips
-- ----------------------------
INSERT INTO `hunter_quest_tips` VALUES (1, 'Attenzione: Quando apri una Frattura, le tue coordinate vengono svelate a tutto il server!');
INSERT INTO `hunter_quest_tips` VALUES (2, 'Non esiste onore nella caccia: rubare il Boss a un altro giocatore e una strategia valida.');
INSERT INTO `hunter_quest_tips` VALUES (3, 'Chi infligge il maggior danno al Boss si aggiudica il bottino e i Punti Gloria.');
INSERT INTO `hunter_quest_tips` VALUES (4, 'Se vedi un avviso di spawn vicino a te, corri! Potresti rubare un Super Metin.');
INSERT INTO `hunter_quest_tips` VALUES (5, 'La Top 3 della Classifica Settimanale riceve Monete Drago (DR). Dacci dentro!');
INSERT INTO `hunter_quest_tips` VALUES (6, 'SPEED KILL: Uccidi il Boss entro 60 secondi per RADDOPPIARE i punti ottenuti!');
INSERT INTO `hunter_quest_tips` VALUES (7, 'Per i Super Metin hai 5 minuti di tempo per ottenere il bonus Speed Kill (x2 Punti).');
INSERT INTO `hunter_quest_tips` VALUES (8, 'Consiglio: Attiva i buff e le rugiade PRIMA di cliccare sulla Frattura.');
INSERT INTO `hunter_quest_tips` VALUES (9, 'Non spezzare la catena! Logga ogni giorno per un bonus punti passivo fino al +20%.');
INSERT INTO `hunter_quest_tips` VALUES (10, 'Hai perso la streak di login? Dovrai ricominciare da zero per riavere il bonus.');
INSERT INTO `hunter_quest_tips` VALUES (11, 'I Punti Gloria sono una valuta preziosa. Spendili con saggezza nel menu (N).');
INSERT INTO `hunter_quest_tips` VALUES (12, 'Il Mercante Hunter in Capitale vende oggetti esclusivi non presenti nel menu rapido.');
INSERT INTO `hunter_quest_tips` VALUES (13, 'I prezzi del Mercante potrebbero cambiare o apparire offerte speciali. Controllalo spesso.');
INSERT INTO `hunter_quest_tips` VALUES (14, 'Puoi convertire i tuoi punti in Item, ma ricorda: scalare la classifica da prestigio.');
INSERT INTO `hunter_quest_tips` VALUES (15, 'I Buoni Punti trovati nei bauli sono commerciabili? Scoprilo provando a scambiarli!');
INSERT INTO `hunter_quest_tips` VALUES (16, 'Controlla spesso il menu Traguardi (tasto N): ci sono premi che aspettano solo di essere riscossi.');
INSERT INTO `hunter_quest_tips` VALUES (17, 'Esistono due vie per i traguardi: la Via del Sangue (Kill) e la Via della Gloria (Punti).');
INSERT INTO `hunter_quest_tips` VALUES (18, 'Sbloccare il titolo Monarca nei traguardi garantisce una ricompensa leggendaria.');
INSERT INTO `hunter_quest_tips` VALUES (19, 'Anche aprire le Fratture conta per le statistiche del tuo Profilo Cacciatore.');
INSERT INTO `hunter_quest_tips` VALUES (20, 'Le Fratture Rosse (Red Gates) sono molto rare ma hanno un drop rate aumentato.');
INSERT INTO `hunter_quest_tips` VALUES (21, 'Un Red Gate puo spawnare Boss molto piu forti del normale. Non sottovalutarli.');
INSERT INTO `hunter_quest_tips` VALUES (22, 'Se una Frattura evoca un Baule del Tesoro, considerati fortunato: e un Jackpot!');
INSERT INTO `hunter_quest_tips` VALUES (23, 'I Bauli Dimensionali possono contenere Buoni DR (Monete Drago).');
INSERT INTO `hunter_quest_tips` VALUES (24, 'Piu mostri uccidi nel mondo, piu alta e la probabilita che appaia una Frattura.');
INSERT INTO `hunter_quest_tips` VALUES (25, 'Solo i veri Cacciatori sopravvivono ai Dungeon Break.');
INSERT INTO `hunter_quest_tips` VALUES (26, 'Il sistema Hunter premia la costanza, non solo la forza bruta.');
INSERT INTO `hunter_quest_tips` VALUES (27, 'Si narra che alcuni Boss Elite nascondano segreti antichi...');
INSERT INTO `hunter_quest_tips` VALUES (28, 'Il reset Giornaliero avviene ogni notte. Assicurati di aver massimizzato il punteggio.');
INSERT INTO `hunter_quest_tips` VALUES (29, 'Guardati le spalle mentre combatti un Boss... un nemico potrebbe essere in agguato.');
INSERT INTO `hunter_quest_tips` VALUES (30, 'Vuoi vedere il tuo nome in cima a tutti? Premi N e scala la Sala delle Leggende.');

-- ----------------------------
-- Table structure for hunter_rank_trials
-- ----------------------------
DROP TABLE IF EXISTS `hunter_rank_trials`;
CREATE TABLE `hunter_rank_trials`  (
  `trial_id` int NOT NULL AUTO_INCREMENT,
  `from_rank` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Rank attuale',
  `to_rank` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Rank obiettivo',
  `trial_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `trial_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `required_gloria` int NOT NULL DEFAULT 0,
  `required_level` int NOT NULL DEFAULT 1,
  `required_boss_kills` int NOT NULL DEFAULT 0,
  `boss_vnum_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Lista VNUM separati da virgola, NULL=qualsiasi boss',
  `required_metin_kills` int NOT NULL DEFAULT 0,
  `metin_vnum_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Lista VNUM, NULL=qualsiasi metin',
  `required_fracture_seals` int NOT NULL DEFAULT 0,
  `fracture_color_list` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'Colori fratture, NULL=qualsiasi',
  `required_chest_opens` int NOT NULL DEFAULT 0,
  `chest_vnum_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'VNUM bauli, NULL=qualsiasi',
  `required_daily_missions` int NOT NULL DEFAULT 0,
  `required_daily_streaks` int NOT NULL DEFAULT 0,
  `time_limit_hours` int NULL DEFAULT NULL COMMENT 'NULL = nessun limite',
  `gloria_reward` int NOT NULL DEFAULT 0,
  `title_reward` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `item_reward_vnum` int NULL DEFAULT NULL,
  `item_reward_count` int NULL DEFAULT 1,
  `color_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'BLUE',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`trial_id`) USING BTREE,
  UNIQUE INDEX `unique_rank_transition`(`from_rank` ASC, `to_rank` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_rank_trials
-- ----------------------------
INSERT INTO `hunter_rank_trials` VALUES (1, 'E', 'D', 'Prova del Risvegliato', 'Dimostra di essere degno del rango D. Uccidi boss di basso livello e sigilla fratture primordiali.', 2000, 35, 3, '4035', 5, '4700,4701', 2, 'GREEN', 3, '200102', 0, 0, NULL, 500, NULL, NULL, 1, 'GREEN', 1);
INSERT INTO `hunter_rank_trials` VALUES (2, 'D', 'C', 'Prova del Cacciatore', 'Caccia boss più potenti e affronta fratture astrali. Solo i veri cacciatori sopravvivono.', 10000, 55, 5, '4035,719,2771', 10, '4701,4702,4703', 5, 'GREEN,BLUE', 5, NULL, 0, 0, NULL, 1000, NULL, NULL, 1, 'BLUE', 1);
INSERT INTO `hunter_rank_trials` VALUES (3, 'C', 'B', 'Prova del Veterano', 'Affronta le creature più pericolose. Solo i veterani possono aspirare al rango B.', 50000, 75, 10, '719,2771,768,6790', 20, '4702,4703,4704', 10, 'BLUE,ORANGE', 0, NULL, 15, 0, NULL, 2000, NULL, NULL, 1, 'ORANGE', 1);
INSERT INTO `hunter_rank_trials` VALUES (4, 'B', 'A', 'Risveglio Interiore', 'Il tuo potere interiore deve risvegliarsi. Affronta boss leggendari e fratture cremisi.', 150000, 95, 15, '6831,986,989', 30, '4704,4705,4706', 15, 'ORANGE,RED', 0, NULL, 0, 7, 168, 5000, NULL, NULL, 1, 'RED', 1);
INSERT INTO `hunter_rank_trials` VALUES (5, 'A', 'S', 'Ascensione Leggendaria', 'Solo i più potenti possono diventare leggende. Questa prova è brutale.', 500000, 115, 25, '989,4011,6830', 50, '4706,4707,4708', 25, 'RED,GOLD', 0, NULL, 0, 14, 336, 15000, 'Leggenda Vivente', NULL, 1, 'GOLD', 1);
INSERT INTO `hunter_rank_trials` VALUES (6, 'S', 'N', 'Il Giudizio Finale', 'La prova definitiva. Solo coloro che trascendono i limiti mortali possono diventare NATIONAL.', 1500000, 140, 50, '4011,6830,4385', 100, '4707,4708', 50, 'GOLD,PURPLE,BLACKWHITE', 20, '200101', 0, 30, 720, 50000, 'Monarca Nazionale', NULL, 1, 'BLACKWHITE', 1);

-- ----------------------------
-- Table structure for hunter_ranks
-- ----------------------------
DROP TABLE IF EXISTS `hunter_ranks`;
CREATE TABLE `hunter_ranks`  (
  `rank_id` int NOT NULL AUTO_INCREMENT,
  `rank_code` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `rank_name` varchar(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `rank_title` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `min_points` int NULL DEFAULT 0,
  `max_points` int NULL DEFAULT 999999999,
  `color_hex` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'FF808080',
  `bonus_gloria` int NULL DEFAULT 0,
  `bonus_drop` int NULL DEFAULT 0,
  `rank_order` int NULL DEFAULT 0,
  PRIMARY KEY (`rank_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_ranks
-- ----------------------------
INSERT INTO `hunter_ranks` VALUES (1, 'E', 'E-Rank', 'Risvegliato', 0, 2000, 'FF808080', 0, 0, 1);
INSERT INTO `hunter_ranks` VALUES (2, 'D', 'D-Rank', 'Apprendista', 2000, 10000, 'FF00AA00', 2, 1, 2);
INSERT INTO `hunter_ranks` VALUES (3, 'C', 'C-Rank', 'Cacciatore', 10000, 50000, 'FF00CCFF', 5, 2, 3);
INSERT INTO `hunter_ranks` VALUES (4, 'B', 'B-Rank', 'Veterano', 50000, 150000, 'FF0066FF', 8, 4, 4);
INSERT INTO `hunter_ranks` VALUES (5, 'A', 'A-Rank', 'Maestro', 150000, 500000, 'FFAA00FF', 12, 6, 5);
INSERT INTO `hunter_ranks` VALUES (6, 'S', 'S-Rank', 'Leggenda', 500000, 1500000, 'FFFF6600', 18, 10, 6);
INSERT INTO `hunter_ranks` VALUES (7, 'N', 'NATIONAL', 'Monarca Nazionale', 1500000, 5000000, 'FFFF0000', 25, 15, 7);
INSERT INTO `hunter_ranks` VALUES (8, '?', '???', 'Trascendente', 5000000, 999999999, 'FFFFFFFF', 35, 25, 8);

-- ----------------------------
-- Table structure for hunter_scheduled_events
-- ----------------------------
DROP TABLE IF EXISTS `hunter_scheduled_events`;
CREATE TABLE `hunter_scheduled_events`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `event_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'first_rift, first_boss, glory_rush, fracture_hunter, chest_hunter, boss_hunter, metin_hunter',
  `event_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `start_hour` tinyint NOT NULL DEFAULT 0,
  `start_minute` tinyint NOT NULL DEFAULT 0,
  `duration_minutes` smallint NOT NULL DEFAULT 30,
  `days_active` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1,2,3,4,5,6,7' COMMENT '1=Lun, 2=Mar, 3=Mer, 4=Gio, 5=Ven, 6=Sab, 7=Dom',
  `min_rank` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'E' COMMENT 'E, D, C, B, A, S, N',
  `reward_glory_base` int NOT NULL DEFAULT 50,
  `reward_glory_winner` int NOT NULL DEFAULT 200,
  `color_scheme` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'GOLD',
  `priority` tinyint NULL DEFAULT 5,
  `enabled` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_enabled`(`enabled` ASC) USING BTREE,
  INDEX `idx_start_hour`(`start_hour` ASC) USING BTREE,
  INDEX `idx_days_active`(`days_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Hunter System - Eventi Programmati 24h Organizzati' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_scheduled_events
-- ----------------------------
INSERT INTO `hunter_scheduled_events` VALUES (1, 'Alba del Cacciatore', 'glory_rush', 'Gloria x2 per ogni uccisione! Svegliati e guadagna!', 5, 0, 60, '1,2,3,4,5,6,7', 'E', 20, 100, 'GOLD', 5, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (2, 'Prima Frattura', 'first_rift', 'Chi trova PER PRIMO la Frattura dellAlba vince!', 6, 0, 30, '1,2,3,4,5,6,7', 'E', 50, 300, 'PURPLE', 6, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (3, 'Risveglio dei Boss', 'first_boss', 'Boss Mattutino spawna! Chi lo uccide PER PRIMO?', 7, 0, 30, '1,2,3,4,5,6,7', 'D', 60, 350, 'RED', 6, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (4, 'Caccia alle Fratture', 'fracture_hunter', 'Chi sigilla PIU fratture in 20 minuti vince!', 8, 0, 20, '1,2,3,4,5,6,7', 'E', 40, 250, 'PURPLE', 5, 1, '2025-12-26 12:00:00');
INSERT INTO `hunter_scheduled_events` VALUES (5, 'Caccia ai Bauli', 'chest_hunter', 'Chi apre PIU bauli in 20 minuti vince!', 9, 0, 20, '1,2,3,4,5,6,7', 'E', 35, 200, 'GOLD', 5, 1, '2025-12-26 12:00:00');
INSERT INTO `hunter_scheduled_events` VALUES (6, 'Caccia ai Boss', 'boss_hunter', 'Chi uccide PIU boss in 20 minuti vince!', 10, 0, 20, '1,2,3,4,5,6,7', 'D', 70, 400, 'RED', 6, 1, '2025-12-26 12:00:00');
INSERT INTO `hunter_scheduled_events` VALUES (7, 'Gloria Rush Mezzogiorno', 'glory_rush', 'GLORIA x2 per TUTTO! Farming intensivo!', 11, 30, 30, '1,2,3,4,5,6,7', 'E', 25, 120, 'GOLD', 6, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (8, 'Frattura del Mezzogiorno', 'first_rift', 'Frattura Dorata! Il PRIMO che la trova vince GROSSO!', 12, 0, 25, '1,2,3,4,5,6,7', 'C', 100, 600, 'GOLD', 8, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (9, 'Caccia al Boss Leggendario', 'first_boss', 'Boss Leggendario spawna! Chi lo abbatte PER PRIMO?', 12, 30, 30, '1,2,3,4,5,6,7', 'C', 120, 700, 'RED', 9, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (10, 'Caccia ai Metin', 'metin_hunter', 'Chi distrugge PIU metin in 20 minuti vince!', 13, 0, 20, '1,2,3,4,5,6,7', 'E', 30, 180, 'ORANGE', 5, 1, '2025-12-26 12:00:00');
INSERT INTO `hunter_scheduled_events` VALUES (11, 'Gloria Rush Pomeriggio', 'glory_rush', 'GLORIA x2 per TUTTO! Continua a farmare!', 14, 30, 30, '1,2,3,4,5,6,7', 'E', 25, 120, 'GOLD', 6, 1, '2025-12-26 12:00:00');
INSERT INTO `hunter_scheduled_events` VALUES (12, 'Frattura Pomeridiana', 'first_rift', 'Frattura Epica! Trovala PRIMA degli altri!', 15, 0, 30, '1,2,3,4,5,6,7', 'B', 150, 900, 'PURPLE', 8, 1, '2025-12-26 12:00:00');
INSERT INTO `hunter_scheduled_events` VALUES (13, 'Boss Elite Hunt', 'first_boss', 'Boss Elite spawna! Chi lo uccide PER PRIMO?', 15, 30, 30, '1,2,3,4,5,6,7', 'B', 180, 1000, 'RED', 9, 1, '2025-12-26 12:00:00');
INSERT INTO `hunter_scheduled_events` VALUES (14, 'Gloria Rush Sera', 'glory_rush', 'GLORIA x3 per 45 minuti! FARMING MASSIMO!', 18, 30, 45, '1,2,3,4,5,6,7', 'D', 50, 200, 'GOLD', 8, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (15, 'Frattura della Sera', 'first_rift', 'Frattura della Sera! Trovala per prima!', 19, 0, 30, '1,2,3,4,5,6,7', 'A', 200, 1200, 'GOLD', 10, 1, '2025-12-26 12:00:00');
INSERT INTO `hunter_scheduled_events` VALUES (16, 'MEGA Boss Hunt', 'first_boss', 'MEGA BOSS spawna! Chi lo uccide PRIMO?', 19, 30, 30, '1,2,3,4,5,6,7', 'A', 250, 1500, 'RED', 10, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (17, 'Frattura Notturna', 'first_rift', 'Frattura dellOmbra appare SOLO di notte! Trovala!', 22, 0, 30, '1,2,3,4,5,6,7', 'A', 180, 1100, 'PURPLE', 10, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (18, 'Boss Notturno Leggendario', 'first_boss', 'BOSS NOTTURNO! Appare solo a mezzanotte!', 22, 30, 30, '1,2,3,4,5,6,7', 'S', 300, 1800, 'RED', 10, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (19, 'Gloria Notturna x4', 'glory_rush', 'GLORIA x4! Solo per chi resta sveglio!', 1, 30, 60, '1,2,3,4,5,6,7', 'C', 40, 250, 'GOLD', 8, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (20, 'Frattura del Giudizio', 'first_rift', 'Frattura FINALE della notte! Premio MASSIMO!', 1, 0, 30, '1,2,3,4,5,6,7', 'A', 200, 1300, 'PURPLE', 10, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (21, 'Boss Prima dellAlba', 'first_boss', 'Ultimo Boss prima dellalba! Chi lo uccide?', 4, 15, 30, '1,2,3,4,5,6,7', 'C', 70, 450, 'RED', 7, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (22, 'Sabato Gloria x3', 'glory_rush', 'WEEKEND! Gloria TRIPLA tutto il giorno!', 10, 0, 120, '6', 'E', 30, 150, 'GOLD', 8, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (23, 'Sabato Frattura Dorata', 'first_rift', 'Frattura DORATA del weekend! Premio x2!', 11, 0, 30, '6', 'C', 150, 900, 'GOLD', 9, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (24, 'WORLD BOSS Sabato', 'first_boss', 'WORLD BOSS SETTIMANALE! Chi lo uccide?', 20, 0, 60, '6', 'S', 400, 3000, 'RED', 10, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (25, 'Notte Sabato - Tutto x4', 'glory_rush', 'GLORIA x4 tutta la notte di sabato!', 22, 0, 120, '6', 'D', 50, 300, 'GOLD', 9, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (26, 'Domenica Relax Gloria x2', 'glory_rush', 'Domenica tranquilla con Gloria x2!', 9, 0, 180, '7', 'E', 25, 120, 'GOLD', 7, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (27, 'Frattura Domenicale', 'first_rift', 'Frattura della Domenica! Trovala!', 18, 0, 30, '7', 'S', 350, 2500, 'PURPLE', 10, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (28, 'BOSS FINALE SETTIMANALE', 'first_boss', 'IL BOSS PIU FORTE! Chi lo abbatte?', 20, 0, 60, '7', 'S', 500, 4000, 'RED', 10, 1, '2025-12-24 16:44:17');
INSERT INTO `hunter_scheduled_events` VALUES (29, 'Countdown Settimana', 'glory_rush', 'Ultime ore! Gloria x5!', 22, 0, 120, '7', 'E', 60, 350, 'GOLD', 10, 1, '2025-12-24 16:44:17');

-- ----------------------------
-- Table structure for hunter_system_status
-- ----------------------------
DROP TABLE IF EXISTS `hunter_system_status`;
CREATE TABLE `hunter_system_status`  (
  `status_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_update` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`status_key`) USING BTREE,
  UNIQUE INDEX `status_key`(`status_key` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_system_status
-- ----------------------------
INSERT INTO `hunter_system_status` VALUES ('daily_reset', 0);
INSERT INTO `hunter_system_status` VALUES ('weekly_reset', 0);

-- ----------------------------
-- Table structure for hunter_texts
-- ----------------------------
DROP TABLE IF EXISTS `hunter_texts`;
CREATE TABLE `hunter_texts`  (
  `text_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `text_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'general',
  `color_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`text_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_texts
-- ----------------------------
INSERT INTO `hunter_texts` VALUES ('achievements_unlocked', 'TRAGUARDI SBLOCCATI: {COUNT}', 'combat', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('ach_already_claimed', '[!] RICOMPENSA GIA\' RISCOSSA', 'achievement', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('ach_locked', '[!] BLOCCATO - Impegnati di piu\'', 'achievement', '888888', 1);
INSERT INTO `hunter_texts` VALUES ('ach_requirement', 'Requisito: {REQ} {TYPE}', 'achievement', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('ach_reward', 'Ricompensa: x{COUNT} {ITEM}', 'achievement', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('all_missions_bonus', 'BONUS COMPLETAMENTO x1.5!', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('all_missions_complete', '=== TUTTE LE MISSIONI COMPLETE ===', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('awaken1_line1', '========================================', 'awaken', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('awaken1_line2', '        ...ANALISI IN CORSO...', 'awaken', 'FFFFFF', 1);
INSERT INTO `hunter_texts` VALUES ('awaken1_line3', '========================================', 'awaken', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('awaken1_speak', '[SYSTEM] SCANSIONE BIOLOGICA IN CORSO...', 'awaken', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('awaken2_line1', '   >> COMPATIBILITA: 100% <<', 'awaken', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('awaken2_line2', '   >> REQUISITI: SODDISFATTI <<', 'awaken', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('awaken2_speak', '[SYSTEM] COMPATIBILITA CONFERMATA.', 'awaken', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('awaken3_line1', '   NOME: {NAME}', 'awaken', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('awaken3_line2', '   RANGO INIZIALE: [E-RANK]', 'awaken', '808080', 1);
INSERT INTO `hunter_texts` VALUES ('awaken3_speak', '[SYSTEM] NUOVO CACCIATORE REGISTRATO.', 'awaken', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('awaken4_line1', '========================================', 'awaken', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('awaken4_line2', '   !! RISVEGLIO COMPLETATO !!', 'awaken', 'FF6600', 1);
INSERT INTO `hunter_texts` VALUES ('awaken4_line3', '========================================', 'awaken', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('awaken4_speak', 'RISVEGLIO COMPLETATO. BENVENUTO, {NAME}.', 'awaken', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line1', '====================================================', 'awaken', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line10', '   [Y] - Apri Hunter Terminal', 'awaken', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line2', '        *** HUNTER SYSTEM v36.0 ATTIVATO ***', 'awaken', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line3', '====================================================', 'awaken', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line4', '   Il Sistema ti ha scelto. Da questo momento:', 'awaken', 'FFFFFF', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line5', '   >> Ogni nemico cadra sotto la tua lama', 'awaken', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line6', '   >> Ogni vittoria sara registrata', 'awaken', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line7', '   >> Ogni rank sara conquistato', 'awaken', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line8', '   \'Inizia con un solo passo...\'', 'awaken', 'FFAA00', 1);
INSERT INTO `hunter_texts` VALUES ('awaken5_line9', '   \'Finisci come una Leggenda.\'', 'awaken', 'FFAA00', 1);
INSERT INTO `hunter_texts` VALUES ('boss_appeared', 'PERICOLO: {NAME} E APPARSO!', 'spawn', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('chest_bonus', 'Incredibile! Il baule conteneva anche {POINTS} Gloria!', 'combat', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('chest_detected', 'BAULE DEL TESORO RILEVATO!', 'spawn', 'GOLD', 1);
INSERT INTO `hunter_texts` VALUES ('chest_opened', 'BAULE APERTO: OTTENUTO {ITEM}', 'combat', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_ask', 'Vuoi spezzare il sigillo ed entrare?', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_come_back', 'Torna quando sarai piu\' forte o con un Party da 4.', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_intro', 'Questo portale emana un\'energia instabile.', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_not_worthy', 'Non possiedi abbastanza Gloria per questo Gate.', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_party', 'Tuttavia, il tuo Party (4+) puo forzarlo!', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_party_can_force', 'Tuttavia, il tuo Party (4+) puo\' forzarlo!', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_req', 'Gloria Richiesta: {REQ}', 'classic', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_required', 'Gloria Richiesta: |cffFF0000%d|r', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_unworthy', 'Non possiedi abbastanza Gloria per questo Gate.', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_weak', 'Torna quando sarai piu forte o con un Party da 4.', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_gate_worthy', 'Il tuo Rango Hunter e sufficiente.', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_opt_close', 'Chiudi', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_opt_force', 'Forza Gate (Raid)', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_opt_open', 'Apri Gate', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('classic_raid_announce', '|cffFF0000[RAID]|r Il Party di {PLAYER} ha forzato un Gate {RANK}!', 'classic', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('emergency_bonus_item', 'BONUS: {ITEM} x{COUNT}', 'emergency', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('emergency_complete', 'MISSIONE COMPLETATA! +{POINTS} GLORIA', 'emergency', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('emergency_failed', 'MISSIONE FALLITA.', 'emergency', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('event_ended', 'EVENTO TERMINATO: {NAME}', 'event', 'AAAAAA', 1);
INSERT INTO `hunter_texts` VALUES ('event_joined', 'Hai partecipato a {NAME}! +{GLORY} Gloria base', 'event', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('event_started', 'EVENTO INIZIATO: {NAME}! Partecipa ora!', 'event', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('event_starting_soon', 'EVENTO IN ARRIVO: {NAME} tra {MINUTES} minuti!', 'event', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('event_winner', 'VINCITORE EVENTO: {NAME} con {POINTS} punti!', 'event', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_detected', 'ATTENZIONE: FRATTURA {RANK} RILEVATA.', 'fracture', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('fracture_retreat', 'TI ALLONTANI DALLA FRATTURA.', 'fracture', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('fracture_sealed', 'FRATTURA SIGILLATA. +{POINTS} GLORIA', 'fracture', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_no_BLACKWHITE', 'Non sei pronto per essere giudicato.', 'fracture_voice', 'BLACKWHITE', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_no_BLUE', 'Il cosmo ti rifiuta.', 'fracture_voice', 'BLUE', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_no_GOLD', 'L\'oro non brilla per i deboli.', 'fracture_voice', 'GOLD', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_no_GREEN', 'Non sei ancora degno della natura.', 'fracture_voice', 'GREEN', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_no_ORANGE', 'L\'oscurita ti divorerebbe.', 'fracture_voice', 'ORANGE', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_no_PURPLE', 'Il fato ti ha gia condannato.', 'fracture_voice', 'PURPLE', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_no_RED', 'Troppo debole. Saresti solo cibo.', 'fracture_voice', 'RED', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_ok_BLACKWHITE', 'Il Giudizio Finale ti attende.', 'fracture_voice', 'BLACKWHITE', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_ok_BLUE', 'Le stelle hanno scelto te.', 'fracture_voice', 'BLUE', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_ok_GOLD', 'La gloria attende chi osa.', 'fracture_voice', 'GOLD', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_ok_GREEN', 'L\'energia primordiale ti chiama...', 'fracture_voice', 'GREEN', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_ok_ORANGE', 'L\'abisso ti fissa... e tu fissi l\'abisso.', 'fracture_voice', 'ORANGE', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_ok_PURPLE', 'Il destino e scritto. Cambialo.', 'fracture_voice', 'PURPLE', 1);
INSERT INTO `hunter_texts` VALUES ('fracture_voice_ok_RED', 'Il sangue chiama sangue.', 'fracture_voice', 'RED', 1);
INSERT INTO `hunter_texts` VALUES ('gate_open', 'IL SIGILLO SI SPEZZA. PREPARATI.', 'fracture', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('gate_party_error', 'ERRORE: SERVONO 4 MEMBRI VICINI.', 'fracture', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('gate_party_force', 'IL PARTY FORZA IL SIGILLO!', 'fracture', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('gate_raid_global', '[RAID] Il Party di {NAME} ha forzato un Gate {RANK}!', 'fracture', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('item_received', 'OGGETTO RICEVUTO: {ITEM}', 'shop', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line1a', '========================================', 'lv30', '0099FF', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line1b', '       [ S Y S T E M ]', 'lv30', '0099FF', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line1c', '========================================', 'lv30', '0099FF', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line2a', '   HUNTER SYSTEM ATTIVATO', 'lv30', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line2b', '   Benvenuto, {NAME}', 'lv30', 'FFFFFF', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line3a', '   >> Da oggi lotterai per la Gloria!', 'lv30', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line3b', '   >> Fratture, Classifiche, Tesori...', 'lv30', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line3c', '   >> Ti attendono.', 'lv30', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line4a', '   A R I S E', 'lv30', 'FF6600', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line4b', '   Il tuo viaggio come Hunter inizia ORA.', 'lv30', 'FFFFFF', 1);
INSERT INTO `hunter_texts` VALUES ('lv30_line4c', '   [Y] - Apri Hunter Terminal', 'lv30', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('lv5_line1a', '========================================', 'lv5', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('lv5_line1b', '   ! ! ! ANOMALIA RILEVATA ! ! !', 'lv5', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('lv5_line1c', '========================================', 'lv5', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('lv5_line2a', '   Il Sistema ti ha notato...', 'lv5', '888888', 1);
INSERT INTO `hunter_texts` VALUES ('lv5_line2b', '   Qualcosa si sta risvegliando.', 'lv5', '888888', 1);
INSERT INTO `hunter_texts` VALUES ('lv5_line3a', '   Raggiungi il livello 30...', 'lv5', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('lv5_line3b', '   ...e scoprirai la verita.', 'lv5', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('mission_all_complete', 'TUTTE LE MISSIONI COMPLETE! BONUS x1.5!', 'mission', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('mission_assigned', '< NUOVE MISSIONI ASSEGNATE >', 'mission', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('mission_complete', '< MISSIONE COMPLETATA >', 'mission', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('mission_daily_reset', 'Missioni giornaliere resettate!', 'mission', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('mission_failed', '< MISSIONE FALLITA >', 'mission', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('mission_penalty', 'Penalita: -%d Gloria', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('mission_penalty_applied', 'PENALITA: -{PENALTY} Gloria per missioni non completate', 'mission', 'FF4444', 1);
INSERT INTO `hunter_texts` VALUES ('mission_progress', 'Progresso Missione: %d / %d', 'mission', 'FFFFFF', 1);
INSERT INTO `hunter_texts` VALUES ('mission_reward', 'Ricompensa: +%d Gloria', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('mission_time_warning', 'ATTENZIONE: {MINUTES} minuti rimasti!', 'mission', 'FFA500', 1);
INSERT INTO `hunter_texts` VALUES ('mission_type_kill_boss', 'Sconfiggi Boss', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('mission_type_kill_metin', 'Distruggi Metin', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('mission_type_kill_mob', 'Elimina Mostri', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('mission_type_seal_fracture', 'Sigilla Fratture', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('mission_type_speedkill', 'Uccisione Veloce', 'general', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('overtake_congrats', 'CONGRATULAZIONI! SEI NELLA TOP 10 {CATEGORY}!', 'overtake', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('overtake_new_king', '[NUOVO RE] {NAME} ha preso il comando della Classifica {CATEGORY}!', 'overtake', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('overtake_record', '[RECORD] Nuovo Punteggio: {POINTS}!', 'overtake', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('overtake_top10', '[TOP 10] {NAME} e entrato nella Top 10 {CATEGORY}!', 'overtake', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('pending_daily_pos', '[DAILY RANK] Posizione: {POS}', 'pending', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('pending_none', 'Nessun premio in attesa al momento.', 'pending', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('pending_rewards', 'RICOMPENSE IN ATTESA. CONTROLLA IL TERMINALE.', 'pending', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('pending_scala', 'Scala la classifica per ottenere gloria!', 'pending', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('pending_weekly_pos', '[WEEKLY RANK] Posizione: {POS}', 'pending', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('rank_refreshed', '[HUNTER] Rank aggiornato: {RANK} ({POINTS} Gloria)', 'system', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('rank_up_global', '[RANK UP] {NAME} e salito al rango [{RANK}-RANK]!', 'rank', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('rank_up_msg', 'RANK UP! Sei ora un {RANK}-RANK Hunter!', 'rank', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('reset_daily', '|cffFFD700[HUNTER SYSTEM]|r Classifica Giornaliera Resettata! La corsa al potere ricomincia.', 'reset', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('reset_weekly', '|cffFF6600[HUNTER SYSTEM]|r Classifica Settimanale Resettata! I premi sono stati distribuiti.', 'reset', 'FF6600', 1);
INSERT INTO `hunter_texts` VALUES ('reward_claimed', '|cffFFD700[HUNTER]|r {PLAYER} ha riscosso il premio Top Classifica {TYPE}!', 'reward', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('reward_claimed_daily', '{NAME} ha riscosso il premio Top Classifica Giornaliera!', 'reward', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('reward_claimed_weekly', '{NAME} ha riscosso il premio Top Classifica Settimanale!', 'reward', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('reward_type_daily', 'Giornaliera', 'reward', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('reward_type_weekly', 'Settimanale', 'reward', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('shop_ask', 'Vuoi acquistare questo oggetto?', 'shop', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('shop_error', 'ERRORE: CREDITI INSUFFICIENTI.', 'shop', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('shop_error_funds', 'ERRORE: CREDITI INSUFFICIENTI.', 'shop', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('shop_opt_cancel', 'Annulla', 'shop', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('shop_opt_confirm', 'Conferma Acquisto', 'shop', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('shop_success', 'TRANSAZIONE COMPLETATA. -{POINTS} CREDITI', 'shop', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('shop_title', 'MERCANTE HUNTER', 'shop', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('spawn_alert_line1', '[HUNTER ALERT] Il Cacciatore {NAME} ha spezzato il sigillo!', 'spawn', 'FF4444', 1);
INSERT INTO `hunter_texts` VALUES ('spawn_alert_line2', 'Un {MOBNAME} ({RANK}) e apparso a ({X}, {Y})!', 'spawn', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('spawn_alert_location', 'Un |cffFF0000{NAME}|r ({RANK}) e\' apparso a ({X}, {Y})!', 'spawn', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('spawn_alert_seal_broken', '|cffFF4444[HUNTER ALERT]|r Il Cacciatore |cffFFD700{PLAYER}|r ha spezzato il sigillo!', 'spawn', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('spawn_boss_appeared', 'PERICOLO: {NAME} E\' APPARSO!', 'spawn', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('spawn_chest_detected', 'BAULE DEL TESORO RILEVATO!', 'spawn', 'GOLD', 1);
INSERT INTO `hunter_texts` VALUES ('target_eliminated', 'BERSAGLIO ELIMINATO: {NAME} | +{POINTS} GLORIA', 'combat', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('welcome_A_border', '====================================================', 'welcome', 'AA00FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_A_line1', '   !! ALLERTA !! Maestro A-Rank online !!', 'welcome', 'CC66FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_A_line2', '   Il Sistema si inchina al tuo potere.', 'welcome', 'CC66FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_A_line3', '   Sei tra i piu forti di questo mondo.', 'welcome', 'CC66FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_A_quote', '   \'Quando un Maestro cammina, il mondo trema.\'', 'welcome', 'AA00FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_A_stats', '   >> Status: MAESTRO | Autorizzazione: MASSIMA <<', 'welcome', 'AA00FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_A_title', '         *** [A-RANK] MAESTRO ***', 'welcome', 'AA00FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_B_border', '====================================================', 'welcome', '0066FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_B_line1', '   ATTENZIONE: Veterano B-Rank rilevato.', 'welcome', '4488FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_B_line2', '   Pochi raggiungono questo livello.', 'welcome', '4488FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_B_line3', '   Il Sistema onora il tuo cammino.', 'welcome', '4488FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_B_quote', '   \'I deboli temono il buio. I forti lo dominano.\'', 'welcome', '0066FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_B_stats', '   >> Status: ELITE | Autorizzazione: ALTA <<', 'welcome', '0066FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_B_title', '          ** [B-RANK] VETERANO **', 'welcome', '0066FF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_C_border', '====================================================', 'welcome', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_C_line1', '   Benvenuto, Cacciatore Esperto.', 'welcome', '44FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_C_line2', '   Le tue gesta risuonano nei registri.', 'welcome', '44FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_C_line3', '   Il Sistema ti riconosce come guerriero.', 'welcome', '44FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_C_quote', '   \'La forza non e tutto. La volonta lo e.\'', 'welcome', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_C_stats', '   >> Status: ESPERTO | Missioni: DISPONIBILI <<', 'welcome', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_C_title', '           * [C-RANK] CACCIATORE *', 'welcome', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_D_border', '====================================================', 'welcome', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_D_line1', '   Il Sistema rileva la tua crescita.', 'welcome', '44FF44', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_D_line2', '   Non sei piu un semplice risvegliato.', 'welcome', '44FF44', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_D_line3', '   Continua cosi, Cacciatore.', 'welcome', '44FF44', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_D_quote', '   \'Solo chi persevera raggiunge la vetta.\'', 'welcome', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_D_stats', '   >> Status: CRESCITA | Potenziale: ELEVATO <<', 'welcome', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_D_title', '              [D-RANK] APPRENDISTA', 'welcome', '00FF00', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_E_border', '====================================================', 'welcome', '808080', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_E_line1', '   Bentornato nel Sistema, Cacciatore.', 'welcome', 'AAAAAA', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_E_line2', '   La strada e lunga, ma ogni viaggio', 'welcome', 'AAAAAA', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_E_line3', '   inizia con un singolo passo.', 'welcome', 'AAAAAA', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_E_quote', '   \'Il debole di oggi... il forte di domani.\'', 'welcome', '808080', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_E_stats', '   >> Status: ATTIVO | Minacce: IN ATTESA <<', 'welcome', '808080', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_E_title', '              [E-RANK] RISVEGLIATO', 'welcome', '808080', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_N_border', '====================================================', 'welcome', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_N_line1', '   !!! ALLARME MASSIMO !!! MONARCA ONLINE !!!', 'welcome', 'FF4444', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_N_line2', '   Il Sistema stesso si piega davanti a te.', 'welcome', 'FF4444', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_N_line3', '   Tu sei oltre ogni classificazione.', 'welcome', 'FF4444', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_N_quote', '   \'Io sono il Sistema. Il Sistema sono io.\'', 'welcome', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_N_stats', '   >> Status: MONARCA | Potere: ASSOLUTO <<', 'welcome', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_N_title', '     ***** [NATIONAL] MONARCA *****', 'welcome', 'FF0000', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_S_border', '====================================================', 'welcome', 'FF6600', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_S_line1', '   !! EMERGENZA !! S-RANK RILEVATO !!', 'welcome', 'FFAA00', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_S_line2', '   Il Sistema trema davanti a te.', 'welcome', 'FFAA00', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_S_line3', '   Una Leggenda cammina tra i mortali.', 'welcome', 'FFAA00', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_S_quote', '   \'Le leggende non muoiono. Diventano eterne.\'', 'welcome', 'FF6600', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_S_stats', '   >> Status: LEGGENDA | Potere: INCOMMENSURABILE <<', 'welcome', 'FF6600', 1);
INSERT INTO `hunter_texts` VALUES ('welcome_S_title', '        **** [S-RANK] LEGGENDA ****', 'welcome', 'FF6600', 1);
INSERT INTO `hunter_texts` VALUES ('whatif_need_party', 'ERRORE: SERVONO 4 MEMBRI VICINI.', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('whatif_opt1_force', '>> FORZA [Party 4+]', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('whatif_opt1_ok', '>> ATTRAVERSA IL PORTALE', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('whatif_opt2_seal', '|| SIGILLA [+{POINTS} Gloria]', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('whatif_opt3_retreat', '<< INDIETREGGIA', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('whatif_party_force', 'IL PARTY FORZA IL SIGILLO!', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('whatif_retreat', 'TI ALLONTANI DALLA FRATTURA.', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('whatif_sealed', 'FRATTURA SIGILLATA. +{POINTS} GLORIA', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('whatif_seal_break', 'IL SIGILLO SI SPEZZA. PREPARATI.', 'whatif', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('winners_daily_header', '[HUNTER SYSTEM] * VINCITORI CLASSIFICA GIORNALIERA *', 'winners', '00FFFF', 1);
INSERT INTO `hunter_texts` VALUES ('winners_medal_1', '[1]', 'winners', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('winners_medal_2', '[2]', 'winners', 'C0C0C0', 1);
INSERT INTO `hunter_texts` VALUES ('winners_medal_3', '[3]', 'winners', 'CD7F32', 1);
INSERT INTO `hunter_texts` VALUES ('winners_score', '{NAME} - {POINTS} Gloria', 'winners', 'FFFFFF', 1);
INSERT INTO `hunter_texts` VALUES ('winners_separator', '======================================', 'winners', 'FFD700', 1);
INSERT INTO `hunter_texts` VALUES ('winners_separator_weekly', '======================================', 'winners', 'FF6600', 1);
INSERT INTO `hunter_texts` VALUES ('winners_sep_daily', '|cffFFD700======================================|r', 'winners', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('winners_sep_weekly', '|cffFF6600======================================|r', 'winners', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('winners_title_daily', '|cffFFD700[HUNTER SYSTEM]|r |cff00FFFF* VINCITORI CLASSIFICA GIORNALIERA *|r', 'winners', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('winners_title_weekly', '|cffFF6600[HUNTER SYSTEM]|r |cffFFD700** VINCITORI CLASSIFICA SETTIMANALE **|r', 'winners', NULL, 1);
INSERT INTO `hunter_texts` VALUES ('winners_weekly_header', '[HUNTER SYSTEM] ** VINCITORI CLASSIFICA SETTIMANALE **', 'winners', 'FFD700', 1);

-- ----------------------------
-- View structure for v_missions_by_rank
-- ----------------------------
DROP VIEW IF EXISTS `v_missions_by_rank`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_missions_by_rank` AS select `hunter_mission_definitions`.`mission_id` AS `id`,`hunter_mission_definitions`.`mission_name` AS `mission_name`,`hunter_mission_definitions`.`mission_name` AS `mission_desc`,`hunter_mission_definitions`.`mission_type` AS `mission_type`,`hunter_mission_definitions`.`min_rank` AS `min_rank`,`hunter_mission_definitions`.`target_vnum` AS `target_vnum`,`hunter_mission_definitions`.`target_count` AS `target_count`,`hunter_mission_definitions`.`time_limit_minutes` * 60 AS `time_limit_sec`,`hunter_mission_definitions`.`gloria_reward` AS `reward_glory`,`hunter_mission_definitions`.`gloria_penalty` AS `penalty_glory`,'NORMAL' AS `difficulty`,1 AS `weight` from `hunter_mission_definitions` where `hunter_mission_definitions`.`enabled` = 1 order by `hunter_mission_definitions`.`min_rank`,`hunter_mission_definitions`.`mission_id`;

-- ----------------------------
-- View structure for v_today_events
-- ----------------------------
DROP VIEW IF EXISTS `v_today_events`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_today_events` AS select `hunter_scheduled_events`.`id` AS `id`,`hunter_scheduled_events`.`event_name` AS `event_name`,`hunter_scheduled_events`.`event_type` AS `event_type`,`hunter_scheduled_events`.`event_desc` AS `event_desc`,`hunter_scheduled_events`.`start_hour` AS `start_hour`,`hunter_scheduled_events`.`start_minute` AS `start_minute`,`hunter_scheduled_events`.`duration_minutes` AS `duration_minutes`,`hunter_scheduled_events`.`min_rank` AS `min_rank`,`hunter_scheduled_events`.`reward_glory_base` AS `reward_glory_base`,`hunter_scheduled_events`.`reward_glory_winner` AS `reward_glory_winner`,`hunter_scheduled_events`.`color_scheme` AS `color_scheme`,`hunter_scheduled_events`.`priority` AS `priority`,concat(lpad(`hunter_scheduled_events`.`start_hour`,2,'0'),':',lpad(`hunter_scheduled_events`.`start_minute`,2,'0')) AS `start_time` from `hunter_scheduled_events` where `hunter_scheduled_events`.`enabled` = 1 and find_in_set(dayofweek(curdate()),`hunter_scheduled_events`.`days_active`) > 0 order by `hunter_scheduled_events`.`start_hour`,`hunter_scheduled_events`.`start_minute`;

-- ----------------------------
-- Function structure for fn_rank_to_num
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_rank_to_num`;
delimiter ;;
CREATE FUNCTION `fn_rank_to_num`(p_rank VARCHAR(2))
 RETURNS int(11)
  DETERMINISTIC
BEGIN
    -- E=0, D=1, C=2, B=3, A=4, S=5, N=6
    CASE p_rank
        WHEN 'E' THEN RETURN 0;
        WHEN 'D' THEN RETURN 1;
        WHEN 'C' THEN RETURN 2;
        WHEN 'B' THEN RETURN 3;
        WHEN 'A' THEN RETURN 4;
        WHEN 'S' THEN RETURN 5;
        WHEN 'N' THEN RETURN 6;
        ELSE RETURN 0;
    END CASE;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_apply_daily_penalties
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_apply_daily_penalties`;
delimiter ;;
CREATE PROCEDURE `sp_apply_daily_penalties`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_player_id INT;
    DECLARE v_total_penalty INT;
    
    DECLARE cur CURSOR FOR 
        SELECT player_id, SUM(penalty_glory) as total_penalty
        FROM hunter_player_missions
        WHERE assigned_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
          AND status = 'active'
        GROUP BY player_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_player_id, v_total_penalty;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Applica penalità
        UPDATE hunter_quest_ranking 
        SET total_points = GREATEST(0, total_points - v_total_penalty)
        WHERE player_id = v_player_id;
        
        -- Segna missioni come fallite
        UPDATE hunter_player_missions 
        SET status = 'failed'
        WHERE player_id = v_player_id 
          AND assigned_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
          AND status = 'active';
    END LOOP;
    
    CLOSE cur;
    
    SELECT 'Penalties applied' AS result;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_assign_daily_missions
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_assign_daily_missions`;
delimiter ;;
CREATE PROCEDURE `sp_assign_daily_missions`(IN p_player_id INT,
    IN p_rank VARCHAR(2),
    IN p_player_name VARCHAR(64))
BEGIN
    DECLARE v_today DATE;
    DECLARE v_existing INT DEFAULT 0;
    DECLARE v_player_rank_num INT;
    DECLARE v_mission1_id INT DEFAULT NULL;
    DECLARE v_mission2_id INT DEFAULT NULL;
    DECLARE v_mission3_id INT DEFAULT NULL;
    DECLARE v_mission1_target INT;
    DECLARE v_mission2_target INT;
    DECLARE v_mission3_target INT;
    DECLARE v_mission1_reward INT;
    DECLARE v_mission2_reward INT;
    DECLARE v_mission3_reward INT;
    DECLARE v_mission1_penalty INT;
    DECLARE v_mission2_penalty INT;
    DECLARE v_mission3_penalty INT;
    
    SET v_today = CURDATE();
    SET v_player_rank_num = fn_rank_to_num(p_rank);
    
    -- Controlla se il giocatore ha già 3 missioni oggi
    SELECT COUNT(*) INTO v_existing 
    FROM hunter_player_missions 
    WHERE player_id = p_player_id AND assigned_date = v_today;
    
    -- Se ha già 3 missioni, esci subito
    IF v_existing >= 3 THEN
        SELECT 'Already assigned' AS result, v_existing AS count;
    ELSE
        -- Elimina eventuali missioni parziali di oggi (se ce ne sono meno di 3)
        DELETE FROM hunter_player_missions 
        WHERE player_id = p_player_id AND assigned_date = v_today;
        
        -- ============================================================
        -- Seleziona 3 missioni casuali appropriate al rank del giocatore
        -- Usa fn_rank_to_num() per confronto numerico corretto
        -- ============================================================
        
        -- Missione Slot 1
        SELECT mission_id, target_count, gloria_reward, gloria_penalty 
        INTO v_mission1_id, v_mission1_target, v_mission1_reward, v_mission1_penalty
        FROM hunter_mission_definitions 
        WHERE enabled = 1 
          AND fn_rank_to_num(min_rank) <= v_player_rank_num
        ORDER BY RAND()
        LIMIT 1;
        
        -- Missione Slot 2 (diversa dalla 1)
        SELECT mission_id, target_count, gloria_reward, gloria_penalty 
        INTO v_mission2_id, v_mission2_target, v_mission2_reward, v_mission2_penalty
        FROM hunter_mission_definitions 
        WHERE enabled = 1 
          AND fn_rank_to_num(min_rank) <= v_player_rank_num
          AND mission_id != IFNULL(v_mission1_id, -1)
        ORDER BY RAND()
        LIMIT 1;
        
        -- Missione Slot 3 (diversa da 1 e 2)
        SELECT mission_id, target_count, gloria_reward, gloria_penalty 
        INTO v_mission3_id, v_mission3_target, v_mission3_reward, v_mission3_penalty
        FROM hunter_mission_definitions 
        WHERE enabled = 1 
          AND fn_rank_to_num(min_rank) <= v_player_rank_num
          AND mission_id != IFNULL(v_mission1_id, -1)
          AND mission_id != IFNULL(v_mission2_id, -1)
        ORDER BY RAND()
        LIMIT 1;
        
        -- Debug: mostra cosa ha trovato
        -- SELECT v_mission1_id AS m1, v_mission2_id AS m2, v_mission3_id AS m3, v_player_rank_num AS rank_num;
        
        -- Inserisci le missioni (solo se trovate)
        IF v_mission1_id IS NOT NULL THEN
            INSERT INTO hunter_player_missions 
                (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
            VALUES 
                (p_player_id, 1, v_mission1_id, v_today, 0, v_mission1_target, 'active', v_mission1_reward, v_mission1_penalty);
        END IF;
        
        IF v_mission2_id IS NOT NULL THEN
            INSERT INTO hunter_player_missions 
                (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
            VALUES 
                (p_player_id, 2, v_mission2_id, v_today, 0, v_mission2_target, 'active', v_mission2_reward, v_mission2_penalty);
        END IF;
        
        IF v_mission3_id IS NOT NULL THEN
            INSERT INTO hunter_player_missions 
                (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
            VALUES 
                (p_player_id, 3, v_mission3_id, v_today, 0, v_mission3_target, 'active', v_mission3_reward, v_mission3_penalty);
        END IF;
        
        -- Risultato
        SELECT 'Missions assigned' AS result, 
               v_mission1_id AS mission1, 
               v_mission2_id AS mission2, 
               v_mission3_id AS mission3,
               v_player_rank_num AS player_rank_num;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_check_gate_access
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_check_gate_access`;
delimiter ;;
CREATE PROCEDURE `sp_check_gate_access`(IN p_player_id INT,
    OUT p_has_access TINYINT,
    OUT p_gate_id INT,
    OUT p_gate_name VARCHAR(64),
    OUT p_remaining_seconds INT,
    OUT p_color_code VARCHAR(16))
BEGIN
    SELECT 
        1,
        ga.gate_id,
        gc.gate_name,
        GREATEST(0, TIMESTAMPDIFF(SECOND, NOW(), ga.expires_at)),
        gc.color_code
    INTO p_has_access, p_gate_id, p_gate_name, p_remaining_seconds, p_color_code
    FROM hunter_gate_access ga
    JOIN hunter_gate_config gc ON ga.gate_id = gc.gate_id
    WHERE ga.player_id = p_player_id
      AND ga.status = 'pending'
      AND ga.expires_at > NOW()
    LIMIT 1;
    
    IF p_has_access IS NULL THEN
        SET p_has_access = 0;
        SET p_gate_id = 0;
        SET p_gate_name = '';
        SET p_remaining_seconds = 0;
        SET p_color_code = '';
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_check_trial_complete
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_check_trial_complete`;
delimiter ;;
CREATE PROCEDURE `sp_check_trial_complete`(IN p_player_id INT,
    OUT p_completed TINYINT,
    OUT p_new_rank VARCHAR(2),
    OUT p_gloria_reward INT,
    OUT p_title_reward VARCHAR(64))
BEGIN
    DECLARE v_trial_id INT;
    DECLARE v_boss_kills INT;
    DECLARE v_metin_kills INT;
    DECLARE v_fracture_seals INT;
    DECLARE v_chest_opens INT;
    DECLARE v_daily_missions INT;
    DECLARE v_req_boss INT;
    DECLARE v_req_metin INT;
    DECLARE v_req_fracture INT;
    DECLARE v_req_chest INT;
    DECLARE v_req_daily INT;
    
    SET p_completed = 0;
    
    SELECT pt.trial_id, pt.boss_kills, pt.metin_kills, pt.fracture_seals, pt.chest_opens, pt.daily_missions,
           rt.required_boss_kills, rt.required_metin_kills, rt.required_fracture_seals, rt.required_chest_opens, rt.required_daily_missions,
           rt.to_rank, rt.gloria_reward, rt.title_reward
    INTO v_trial_id, v_boss_kills, v_metin_kills, v_fracture_seals, v_chest_opens, v_daily_missions,
         v_req_boss, v_req_metin, v_req_fracture, v_req_chest, v_req_daily,
         p_new_rank, p_gloria_reward, p_title_reward
    FROM hunter_player_trials pt
    JOIN hunter_rank_trials rt ON pt.trial_id = rt.trial_id
    WHERE pt.player_id = p_player_id AND pt.status = 'in_progress'
    LIMIT 1;
    
    IF v_trial_id IS NOT NULL THEN
        IF v_boss_kills >= v_req_boss 
           AND v_metin_kills >= v_req_metin 
           AND v_fracture_seals >= v_req_fracture 
           AND v_chest_opens >= v_req_chest 
           AND v_daily_missions >= v_req_daily THEN
            
            -- Completa la prova
            UPDATE hunter_player_trials SET status = 'completed', completed_at = NOW() WHERE player_id = p_player_id AND trial_id = v_trial_id;
            
            -- Aggiorna rank e gloria
            UPDATE hunter_quest_ranking 
            SET hunter_rank = p_new_rank, 
                current_rank = p_new_rank,
                total_points = total_points + p_gloria_reward
            WHERE player_id = p_player_id;
            
            SET p_completed = 1;
        END IF;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_complete_gate
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_complete_gate`;
delimiter ;;
CREATE PROCEDURE `sp_complete_gate`(IN p_player_id INT,
    IN p_result VARCHAR(16),
    OUT p_gloria_change INT)
BEGIN
    DECLARE v_access_id INT;
    DECLARE v_gate_id INT;
    DECLARE v_gate_name VARCHAR(64);
    DECLARE v_entered_at TIMESTAMP;
    DECLARE v_gloria_reward INT;
    DECLARE v_gloria_penalty INT;
    DECLARE v_duration INT;
    
    -- Trova l'accesso attivo
    SELECT ga.access_id, ga.gate_id, gc.gate_name, ga.entered_at, gc.gloria_reward, gc.gloria_penalty
    INTO v_access_id, v_gate_id, v_gate_name, v_entered_at, v_gloria_reward, v_gloria_penalty
    FROM hunter_gate_access ga
    JOIN hunter_gate_config gc ON ga.gate_id = gc.gate_id
    WHERE ga.player_id = p_player_id AND ga.status = 'entered'
    LIMIT 1;
    
    IF v_access_id IS NOT NULL THEN
        SET v_duration = TIMESTAMPDIFF(SECOND, v_entered_at, NOW());
        
        IF p_result = 'completed' THEN
            SET p_gloria_change = v_gloria_reward;
            UPDATE hunter_gate_access SET status = 'completed', completed_at = NOW(), gloria_earned = v_gloria_reward WHERE access_id = v_access_id;
        ELSE
            SET p_gloria_change = -v_gloria_penalty;
            UPDATE hunter_gate_access SET status = 'failed', completed_at = NOW(), gloria_earned = -v_gloria_penalty WHERE access_id = v_access_id;
        END IF;
        
        -- Aggiorna Gloria del giocatore
        UPDATE hunter_quest_ranking 
        SET total_points = GREATEST(0, total_points + p_gloria_change),
            daily_points = daily_points + GREATEST(0, p_gloria_change)
        WHERE player_id = p_player_id;
        
        -- Inserisci in history
        INSERT INTO hunter_gate_history (player_id, player_name, gate_id, gate_name, result, gloria_change, duration_seconds)
        SELECT p_player_id, player_name, v_gate_id, v_gate_name, p_result, p_gloria_change, v_duration
        FROM hunter_quest_ranking WHERE player_id = p_player_id;
    ELSE
        SET p_gloria_change = 0;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_enter_gate
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_enter_gate`;
delimiter ;;
CREATE PROCEDURE `sp_enter_gate`(IN p_player_id INT,
    IN p_access_id INT,
    OUT p_success TINYINT,
    OUT p_dungeon_index INT,
    OUT p_duration_minutes INT)
BEGIN
    DECLARE v_gate_id INT;
    
    SELECT ga.gate_id, gc.dungeon_index, gc.duration_minutes
    INTO v_gate_id, p_dungeon_index, p_duration_minutes
    FROM hunter_gate_access ga
    JOIN hunter_gate_config gc ON ga.gate_id = gc.gate_id
    WHERE ga.access_id = p_access_id
      AND ga.player_id = p_player_id
      AND ga.status = 'pending'
      AND ga.expires_at > NOW();
    
    IF v_gate_id IS NOT NULL THEN
        UPDATE hunter_gate_access 
        SET status = 'entered', entered_at = NOW()
        WHERE access_id = p_access_id;
        SET p_success = 1;
    ELSE
        SET p_success = 0;
        SET p_dungeon_index = 0;
        SET p_duration_minutes = 0;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_select_gate_players
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_select_gate_players`;
delimiter ;;
CREATE PROCEDURE `sp_select_gate_players`()
BEGIN
    DECLARE v_players_count INT;
    DECLARE v_access_hours INT;
    DECLARE v_min_rank VARCHAR(2);
    DECLARE v_min_level INT;
    DECLARE v_min_points INT;
    DECLARE v_gate_id INT;
    
    -- Leggi config
    SELECT players_per_selection, access_duration_hours, min_rank, min_level, min_total_points
    INTO v_players_count, v_access_hours, v_min_rank, v_min_level, v_min_points
    FROM hunter_gate_selection_config LIMIT 1;
    
    -- Seleziona un gate casuale abilitato
    SELECT gate_id INTO v_gate_id 
    FROM hunter_gate_config 
    WHERE enabled = 1 
    ORDER BY RAND() 
    LIMIT 1;
    
    IF v_gate_id IS NOT NULL THEN
        -- Inserisci giocatori selezionati casualmente
        INSERT INTO hunter_gate_access (player_id, player_name, gate_id, expires_at)
        SELECT 
            r.player_id,
            r.player_name,
            v_gate_id,
            DATE_ADD(NOW(), INTERVAL v_access_hours HOUR)
        FROM hunter_quest_ranking r
        WHERE r.total_points >= v_min_points
          AND NOT EXISTS (
              -- Non selezionare chi ha già un accesso pending
              SELECT 1 FROM hunter_gate_access ga 
              WHERE ga.player_id = r.player_id 
              AND ga.status = 'pending' 
              AND ga.expires_at > NOW()
          )
          AND NOT EXISTS (
              -- Non selezionare chi ha completato un gate nelle ultime 24 ore
              SELECT 1 FROM hunter_gate_history gh
              WHERE gh.player_id = r.player_id
              AND gh.completed_at > DATE_SUB(NOW(), INTERVAL 24 HOUR)
          )
        ORDER BY RAND()
        LIMIT v_players_count;
        
        -- Aggiorna timestamp ultima selezione
        UPDATE hunter_gate_selection_config SET last_selection_at = NOW();
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_start_rank_trial
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_start_rank_trial`;
delimiter ;;
CREATE PROCEDURE `sp_start_rank_trial`(IN p_player_id INT,
    IN p_current_rank VARCHAR(2),
    OUT p_trial_id INT,
    OUT p_trial_name VARCHAR(128),
    OUT p_success TINYINT,
    OUT p_message VARCHAR(255))
BEGIN
    DECLARE v_player_gloria INT;
    DECLARE v_player_level INT;
    DECLARE v_required_gloria INT;
    DECLARE v_required_level INT;
    DECLARE v_time_limit INT;
    
    -- Trova la prova per questo rank
    SELECT trial_id, trial_name, required_gloria, required_level, time_limit_hours
    INTO p_trial_id, p_trial_name, v_required_gloria, v_required_level, v_time_limit
    FROM hunter_rank_trials
    WHERE from_rank = p_current_rank AND enabled = 1
    LIMIT 1;
    
    IF p_trial_id IS NULL THEN
        SET p_success = 0;
        SET p_message = 'Nessuna prova disponibile per il tuo rank.';
    ELSE
        -- Controlla se già in corso o completata
        IF EXISTS (SELECT 1 FROM hunter_player_trials WHERE player_id = p_player_id AND trial_id = p_trial_id AND status IN ('in_progress', 'completed')) THEN
            SET p_success = 0;
            SET p_message = 'Prova già in corso o completata.';
        ELSE
            -- Controlla requisiti Gloria
            SELECT total_points INTO v_player_gloria FROM hunter_quest_ranking WHERE player_id = p_player_id;
            IF v_player_gloria < v_required_gloria THEN
                SET p_success = 0;
                SET p_message = CONCAT('Gloria insufficiente. Richiesti: ', v_required_gloria);
            ELSE
                -- Inizia la prova
                INSERT INTO hunter_player_trials (player_id, trial_id, status, started_at, expires_at)
                VALUES (p_player_id, p_trial_id, 'in_progress', NOW(), 
                        IF(v_time_limit IS NOT NULL, DATE_ADD(NOW(), INTERVAL v_time_limit HOUR), NULL))
                ON DUPLICATE KEY UPDATE 
                    status = 'in_progress', 
                    started_at = NOW(),
                    expires_at = IF(v_time_limit IS NOT NULL, DATE_ADD(NOW(), INTERVAL v_time_limit HOUR), NULL),
                    boss_kills = 0, metin_kills = 0, fracture_seals = 0, chest_opens = 0, daily_missions = 0;
                
                SET p_success = 1;
                SET p_message = CONCAT('Prova iniziata: ', p_trial_name);
            END IF;
        END IF;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_update_trial_progress
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_update_trial_progress`;
delimiter ;;
CREATE PROCEDURE `sp_update_trial_progress`(IN p_player_id INT,
    IN p_progress_type VARCHAR(32),
    IN p_vnum INT,
    IN p_amount INT)
BEGIN
    DECLARE v_trial_id INT;
    DECLARE v_boss_list VARCHAR(255);
    DECLARE v_metin_list VARCHAR(255);
    DECLARE v_fracture_list VARCHAR(128);
    DECLARE v_chest_list VARCHAR(255);
    DECLARE v_vnum_str VARCHAR(16);
    
    SET v_vnum_str = CAST(p_vnum AS CHAR);
    
    -- Trova prova in corso
    SELECT pt.trial_id, rt.boss_vnum_list, rt.metin_vnum_list, rt.fracture_color_list, rt.chest_vnum_list
    INTO v_trial_id, v_boss_list, v_metin_list, v_fracture_list, v_chest_list
    FROM hunter_player_trials pt
    JOIN hunter_rank_trials rt ON pt.trial_id = rt.trial_id
    WHERE pt.player_id = p_player_id AND pt.status = 'in_progress'
    AND (pt.expires_at IS NULL OR pt.expires_at > NOW())
    LIMIT 1;
    
    IF v_trial_id IS NOT NULL THEN
        CASE p_progress_type
            WHEN 'boss_kill' THEN
                IF v_boss_list IS NULL OR FIND_IN_SET(v_vnum_str, v_boss_list) > 0 THEN
                    UPDATE hunter_player_trials SET boss_kills = boss_kills + p_amount WHERE player_id = p_player_id AND trial_id = v_trial_id;
                END IF;
            WHEN 'metin_kill' THEN
                IF v_metin_list IS NULL OR FIND_IN_SET(v_vnum_str, v_metin_list) > 0 THEN
                    UPDATE hunter_player_trials SET metin_kills = metin_kills + p_amount WHERE player_id = p_player_id AND trial_id = v_trial_id;
                END IF;
            WHEN 'fracture_seal' THEN
                -- p_vnum qui è il colore come stringa (passato come 0 se non serve)
                UPDATE hunter_player_trials SET fracture_seals = fracture_seals + p_amount WHERE player_id = p_player_id AND trial_id = v_trial_id;
            WHEN 'chest_open' THEN
                IF v_chest_list IS NULL OR FIND_IN_SET(v_vnum_str, v_chest_list) > 0 THEN
                    UPDATE hunter_player_trials SET chest_opens = chest_opens + p_amount WHERE player_id = p_player_id AND trial_id = v_trial_id;
                END IF;
            WHEN 'daily_mission' THEN
                UPDATE hunter_player_trials SET daily_missions = daily_missions + p_amount WHERE player_id = p_player_id AND trial_id = v_trial_id;
        END CASE;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Event structure for evt_daily_mission_reset
-- ----------------------------
DROP EVENT IF EXISTS `evt_daily_mission_reset`;
delimiter ;;
CREATE EVENT `evt_daily_mission_reset`
ON SCHEDULE
EVERY '1' DAY STARTS '2025-12-24 00:05:00'
DO BEGIN
    -- Applica penalita per missioni non completate
    CALL sp_apply_daily_penalties();
END
;;
delimiter ;

-- ----------------------------
-- Event structure for evt_gate_expire_access
-- ----------------------------
DROP EVENT IF EXISTS `evt_gate_expire_access`;
delimiter ;;
CREATE EVENT `evt_gate_expire_access`
ON SCHEDULE
EVERY '1' HOUR STARTS '2025-12-27 02:42:42'
DO UPDATE hunter_gate_access 
    SET status = 'expired'
    WHERE status = 'pending' AND expires_at < NOW()
;;
delimiter ;

-- ----------------------------
-- Event structure for evt_gate_player_selection
-- ----------------------------
DROP EVENT IF EXISTS `evt_gate_player_selection`;
delimiter ;;
CREATE EVENT `evt_gate_player_selection`
ON SCHEDULE
EVERY '4' HOUR STARTS '2025-12-27 02:42:42'
DO CALL sp_select_gate_players()
;;
delimiter ;

-- ----------------------------
-- Event structure for evt_trial_expire
-- ----------------------------
DROP EVENT IF EXISTS `evt_trial_expire`;
delimiter ;;
CREATE EVENT `evt_trial_expire`
ON SCHEDULE
EVERY '1' HOUR STARTS '2025-12-27 02:42:42'
DO UPDATE hunter_player_trials 
    SET status = 'failed'
    WHERE status = 'in_progress' 
    AND expires_at IS NOT NULL 
    AND expires_at < NOW()
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
