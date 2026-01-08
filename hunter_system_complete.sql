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

 Date: 06/01/2026 15:20:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for hunter_achievements_claimed
-- ----------------------------
DROP TABLE IF EXISTS `hunter_achievements_claimed`;
CREATE TABLE `hunter_achievements_claimed`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `achievement_id` int NOT NULL,
  `claimed_at` datetime NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_player_achievement`(`player_id` ASC, `achievement_id` ASC) USING BTREE,
  INDEX `idx_player`(`player_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_achievements_claimed
-- ----------------------------

-- ----------------------------
-- Table structure for hunter_chest_loot
-- ----------------------------
DROP TABLE IF EXISTS `hunter_chest_loot`;
CREATE TABLE `hunter_chest_loot`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `chest_vnum` int NOT NULL COMMENT 'VNUM baule (63000-63007) o 0=tutti',
  `min_rank_tier` int NOT NULL DEFAULT 1 COMMENT 'Rank minimo baule (1=E, 7=N)',
  `loot_type` enum('GLORY','ITEM') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'ITEM',
  `item_vnum` int NULL DEFAULT 0 COMMENT 'VNUM item (se ITEM)',
  `item_quantity` int NULL DEFAULT 1,
  `glory_min` int NULL DEFAULT 0 COMMENT 'Gloria minima (se GLORY)',
  `glory_max` int NULL DEFAULT 0 COMMENT 'Gloria massima (se GLORY)',
  `drop_chance` int NOT NULL DEFAULT 5 COMMENT '% probabilita (1-100)',
  `name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'Jackpot',
  `is_jackpot` tinyint(1) NULL DEFAULT 1 COMMENT '1=mostra effetto jackpot',
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_chest_vnum`(`chest_vnum` ASC) USING BTREE,
  INDEX `idx_rank_tier`(`min_rank_tier` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_chest_loot
-- ----------------------------
INSERT INTO `hunter_chest_loot` VALUES (1, 0, 1, 'GLORY', 0, 0, 50, 150, 15, 'Jackpot Gloria Minore', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (2, 0, 3, 'GLORY', 0, 0, 100, 300, 10, 'Jackpot Gloria', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (3, 0, 5, 'GLORY', 0, 0, 200, 500, 8, 'Jackpot Gloria Maggiore', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (4, 0, 7, 'GLORY', 0, 0, 400, 1000, 5, 'MEGA JACKPOT GLORIA', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (5, 0, 2, 'ITEM', 50160, 1, 0, 0, 8, 'Scanner di Fratture', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (6, 0, 3, 'ITEM', 50162, 1, 0, 0, 6, 'Focus del Cacciatore', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (7, 0, 4, 'ITEM', 50163, 1, 0, 0, 4, 'Chiave Dimensionale', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (8, 0, 4, 'ITEM', 50167, 1, 0, 0, 5, 'Calibratore', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (9, 0, 5, 'ITEM', 50161, 1, 0, 0, 3, 'Stabilizzatore di Rango', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (10, 0, 5, 'ITEM', 50165, 1, 0, 0, 4, 'Segnale Emergenza', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (11, 0, 6, 'ITEM', 50164, 1, 0, 0, 2, 'Sigillo di Conquista', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (12, 0, 6, 'ITEM', 50166, 1, 0, 0, 2, 'Risonatore di Gruppo', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (13, 63006, 7, 'ITEM', 50168, 1, 0, 0, 1, 'Frammento di Monarca', 1, 1);
INSERT INTO `hunter_chest_loot` VALUES (14, 0, 1, 'ITEM', 80030, 2, 0, 0, 20, 'Buono 100 Gloria x2', 0, 1);
INSERT INTO `hunter_chest_loot` VALUES (15, 0, 3, 'ITEM', 80031, 1, 0, 0, 12, 'Buono 500 Gloria', 0, 1);
INSERT INTO `hunter_chest_loot` VALUES (16, 0, 5, 'ITEM', 80032, 1, 0, 0, 8, 'Buono 1000 Gloria', 1, 1);

-- ----------------------------
-- Table structure for hunter_chest_rewards
-- ----------------------------
DROP TABLE IF EXISTS `hunter_chest_rewards`;
CREATE TABLE `hunter_chest_rewards`  (
  `vnum` int NOT NULL COMMENT 'VNUM del baule (63000-63007)',
  `name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'Baule',
  `rank_tier` int NOT NULL DEFAULT 1 COMMENT '1=E, 2=D, 3=C, 4=B, 5=A, 6=S, 7=N',
  `glory_min` int NOT NULL DEFAULT 20 COMMENT 'Gloria minima',
  `glory_max` int NOT NULL DEFAULT 50 COMMENT 'Gloria massima',
  `item_vnum` int NULL DEFAULT 0 COMMENT 'Item bonus (0=nessuno)',
  `item_quantity` int NULL DEFAULT 1,
  `item_chance` int NULL DEFAULT 0 COMMENT '% probabilita item (0-100)',
  `color_code` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'GREEN',
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`vnum`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_chest_rewards
-- ----------------------------
INSERT INTO `hunter_chest_rewards` VALUES (63000, 'Cassa E-Rank', 1, 30, 60, 80030, 1, 30, 'GREEN', 1);
INSERT INTO `hunter_chest_rewards` VALUES (63001, 'Cassa D-Rank', 2, 50, 100, 80030, 2, 25, 'BLUE', 1);
INSERT INTO `hunter_chest_rewards` VALUES (63002, 'Cassa C-Rank', 3, 80, 150, 80031, 1, 20, 'ORANGE', 1);
INSERT INTO `hunter_chest_rewards` VALUES (63003, 'Cassa B-Rank', 4, 120, 220, 80031, 2, 15, 'RED', 1);
INSERT INTO `hunter_chest_rewards` VALUES (63004, 'Cassa A-Rank', 5, 170, 300, 80032, 1, 12, 'PURPLE', 1);
INSERT INTO `hunter_chest_rewards` VALUES (63005, 'Cassa S-Rank', 6, 240, 420, 80032, 2, 10, 'GOLD', 1);
INSERT INTO `hunter_chest_rewards` VALUES (63006, 'Cassa N-Rank', 7, 350, 600, 80040, 1, 8, 'BLACKWHITE', 1);
INSERT INTO `hunter_chest_rewards` VALUES (63007, 'Cassa ???-Rank', 1, 200, 800, 80040, 1, 50, 'PURPLE', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_event_participants
-- ----------------------------
INSERT INTO `hunter_event_participants` VALUES (1, 12, 4, '[GF]HunabKu', '2026-01-04 15:07:24');
INSERT INTO `hunter_event_participants` VALUES (2, 13, 1684, 'Pacifista', '2026-01-04 15:48:11');
INSERT INTO `hunter_event_participants` VALUES (3, 27, 4, '[GF]HunabKu', '2026-01-04 18:10:51');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_event_winners
-- ----------------------------
INSERT INTO `hunter_event_winners` VALUES (1, 12, 4, '[GF]HunabKu', 'first_rift', '900', '2026-01-04 15:07:24');
INSERT INTO `hunter_event_winners` VALUES (2, 27, 4, '[GF]HunabKu', 'first_rift', '2500', '2026-01-04 18:10:51');

-- ----------------------------
-- Table structure for hunter_fracture_defense_config
-- ----------------------------
DROP TABLE IF EXISTS `hunter_fracture_defense_config`;
CREATE TABLE `hunter_fracture_defense_config`  (
  `config_key` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `config_value` int NOT NULL,
  `description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`config_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_fracture_defense_config
-- ----------------------------
INSERT INTO `hunter_fracture_defense_config` VALUES ('check_distance', 20, 'Distanza massima dalla frattura (metri)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('check_interval', 2, 'Ogni quanti secondi controllare la posizione');
INSERT INTO `hunter_fracture_defense_config` VALUES ('defense_duration', 60, 'Durata difesa in secondi (fallback generico)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('defense_duration_A', 120, 'Durata difesa A-Rank (2 min)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('defense_duration_B', 90, 'Durata difesa B-Rank (1.5 min)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('defense_duration_C', 60, 'Durata difesa C-Rank (1 min)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('defense_duration_D', 60, 'Durata difesa D-Rank (1 min)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('defense_duration_E', 60, 'Durata difesa E-Rank (1 min)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('defense_duration_N', 180, 'Durata difesa N-Rank (3 min)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('defense_duration_S', 150, 'Durata difesa S-Rank (2.5 min)');
INSERT INTO `hunter_fracture_defense_config` VALUES ('party_all_required', 1, 'Se 1, tutti i membri party devono stare vicini');
INSERT INTO `hunter_fracture_defense_config` VALUES ('spawn_start_delay', 5, 'Secondi prima della prima ondata');

-- ----------------------------
-- Table structure for hunter_fracture_defense_waves
-- ----------------------------
DROP TABLE IF EXISTS `hunter_fracture_defense_waves`;
CREATE TABLE `hunter_fracture_defense_waves`  (
  `wave_id` int NOT NULL AUTO_INCREMENT,
  `rank_grade` varchar(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'E,D,C,B,A,S,N',
  `wave_number` int NOT NULL DEFAULT 1,
  `spawn_time` int NOT NULL DEFAULT 10,
  `mob_vnum` int NOT NULL,
  `mob_count` int NOT NULL DEFAULT 5,
  `spawn_radius` int NOT NULL DEFAULT 7,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`wave_id`) USING BTREE,
  INDEX `idx_rank_wave`(`rank_grade` ASC, `wave_number` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 56 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_fracture_defense_waves
-- ----------------------------
INSERT INTO `hunter_fracture_defense_waves` VALUES (1, 'E', 1, 5, 7125, 2, 6, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (2, 'E', 2, 25, 7129, 2, 6, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (3, 'E', 3, 45, 7133, 2, 6, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (4, 'D', 1, 5, 7127, 2, 7, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (5, 'D', 2, 20, 7131, 2, 7, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (6, 'D', 3, 35, 7135, 2, 7, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (7, 'D', 4, 45, 7137, 2, 7, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (8, 'C', 1, 5, 7126, 2, 7, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (9, 'C', 2, 18, 7130, 2, 7, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (10, 'C', 3, 30, 7134, 2, 7, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (11, 'C', 4, 45, 7140, 2, 7, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (12, 'B', 1, 5, 7128, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (13, 'B', 2, 18, 7132, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (14, 'B', 3, 32, 7136, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (15, 'B', 4, 46, 7138, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (16, 'B', 5, 60, 7128, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (17, 'B', 6, 75, 7136, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (18, 'A', 1, 5, 7126, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (19, 'A', 2, 17, 7128, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (20, 'A', 3, 30, 7130, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (21, 'A', 4, 43, 7132, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (22, 'A', 5, 56, 7134, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (23, 'A', 6, 69, 7136, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (24, 'A', 7, 82, 7140, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (25, 'A', 8, 95, 7140, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (26, 'A', 9, 105, 7141, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (27, 'S', 1, 5, 7141, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (28, 'S', 2, 17, 7126, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (29, 'S', 3, 29, 7142, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (30, 'S', 4, 41, 7130, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (31, 'S', 5, 53, 7143, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (32, 'S', 6, 65, 7134, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (33, 'S', 7, 77, 7144, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (34, 'S', 8, 89, 7141, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (35, 'S', 9, 101, 7142, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (36, 'S', 10, 113, 7143, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (37, 'S', 11, 125, 7144, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (38, 'S', 12, 135, 7141, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (39, 'N', 1, 5, 7141, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (40, 'N', 2, 17, 7142, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (41, 'N', 3, 29, 7143, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (42, 'N', 4, 41, 7144, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (43, 'N', 5, 53, 7141, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (44, 'N', 6, 65, 7142, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (45, 'N', 7, 77, 7143, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (46, 'N', 8, 89, 7144, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (47, 'N', 9, 101, 7141, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (48, 'N', 10, 113, 7142, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (49, 'N', 11, 125, 7143, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (50, 'N', 12, 137, 7144, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (51, 'N', 13, 149, 7141, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (52, 'N', 14, 161, 7142, 2, 8, 1);
INSERT INTO `hunter_fracture_defense_waves` VALUES (53, 'N', 15, 165, 7143, 2, 8, 1);

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
  INDEX `idx_expires`(`expires_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_gate_access
-- ----------------------------
INSERT INTO `hunter_gate_access` VALUES (13, 4, '[GF]HunabKu', 1, '2025-12-29 21:49:27', '2025-12-29 23:49:27', 'pending', NULL, NULL, 0);
INSERT INTO `hunter_gate_access` VALUES (14, 4, '[GF]HunabKu', 1, '2025-12-31 19:12:37', '2025-12-31 21:12:37', 'pending', NULL, NULL, 0);

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
  `boss_vnum` int NOT NULL DEFAULT 0 COMMENT 'VNUM del boss da uccidere (0 = nessun boss specifico)',
  `duration_minutes` int NOT NULL DEFAULT 30 COMMENT 'Tempo per completare',
  `cooldown_hours` int NOT NULL DEFAULT 24 COMMENT 'Cooldown personale',
  `gloria_reward` int NOT NULL DEFAULT 500,
  `gloria_penalty` int NOT NULL DEFAULT 250 COMMENT 'Se fallisci o scade timer',
  `max_daily_entries` int NOT NULL DEFAULT 1,
  `color_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'BLUE',
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`gate_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_gate_config
-- ----------------------------
INSERT INTO `hunter_gate_config` VALUES (1, 'Gate Primordiale', 'E', 'E', 30, 1, 4035, 30, 24, 300, 150, 1, 'GREEN', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (2, 'Gate Astrale', 'D', 'D', 50, 2, 6790, 25, 24, 500, 250, 1, 'BLUE', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (3, 'Gate Abissale', 'C', 'C', 70, 3, 6831, 25, 24, 800, 400, 1, 'ORANGE', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (4, 'Gate Cremisi', 'B', 'B', 85, 4, 986, 20, 24, 1200, 600, 1, 'RED', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (5, 'Gate Aureo', 'A', 'A', 100, 5, 989, 20, 24, 2000, 1000, 1, 'GOLD', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (6, 'Gate Infausto', 'S', 'S', 115, 6, 4385, 15, 24, 3500, 1750, 1, 'PURPLE', 1, '2025-12-27 02:42:41');
INSERT INTO `hunter_gate_config` VALUES (7, 'Gate del Giudizio', 'N', 'N', 130, 7, 4011, 15, 24, 5000, 2500, 1, 'BLACKWHITE', 1, '2025-12-27 02:42:41');

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
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_gate_history
-- ----------------------------
INSERT INTO `hunter_gate_history` VALUES (43, 4, '[GF]HunabKu', 1, 'Gate', 'failed', -250, 300, '2025-12-29 21:48:46');
INSERT INTO `hunter_gate_history` VALUES (44, 4, '[GF]HunabKu', 0, '', '', -250, 0, '2025-12-29 21:49:11');
INSERT INTO `hunter_gate_history` VALUES (45, 4, '[GF]HunabKu', 1, 'Gate', 'failed', -250, 300, '2025-12-29 23:19:07');
INSERT INTO `hunter_gate_history` VALUES (46, 4, '[GF]HunabKu', 1, 'Gate', 'completed', 1125, 300, '2025-12-29 23:19:16');
INSERT INTO `hunter_gate_history` VALUES (47, 4, '[GF]HunabKu', 1, 'Gate', 'failed', -250, 300, '2025-12-29 23:21:29');
INSERT INTO `hunter_gate_history` VALUES (48, 4, '[GF]HunabKu', 0, '', '', -250, 0, '2025-12-30 14:29:51');
INSERT INTO `hunter_gate_history` VALUES (49, 4, '[GF]HunabKu', 0, '', '', -250, 0, '2025-12-31 19:11:08');
INSERT INTO `hunter_gate_history` VALUES (50, 4, '[GF]HunabKu', 0, '', '', -250, 0, '2025-12-31 22:41:32');
INSERT INTO `hunter_gate_history` VALUES (51, 4, '[GF]HunabKu', 0, '', '', -250, 0, '2025-12-31 22:41:44');
INSERT INTO `hunter_gate_history` VALUES (52, 4, '[GF]HunabKu', 0, '', '', -250, 0, '2025-12-31 23:14:26');

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_gate_selection_config
-- ----------------------------
INSERT INTO `hunter_gate_selection_config` VALUES (1, 4, 5, 2, 'E', 30, 1000, '2025-12-28 02:42:42');

-- ----------------------------
-- Table structure for hunter_item_names
-- ----------------------------
DROP TABLE IF EXISTS `hunter_item_names`;
CREATE TABLE `hunter_item_names`  (
  `vnum` int NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`vnum`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hunter_item_names
-- ----------------------------
INSERT INTO `hunter_item_names` VALUES (50160, 'Scanner di Fratture');
INSERT INTO `hunter_item_names` VALUES (50161, 'Stabilizzatore di Rango');
INSERT INTO `hunter_item_names` VALUES (50162, 'Focus del Cacciatore');
INSERT INTO `hunter_item_names` VALUES (50163, 'Chiave Dimensionale');
INSERT INTO `hunter_item_names` VALUES (50164, 'Sigillo di Conquista');
INSERT INTO `hunter_item_names` VALUES (50165, 'Segnale di Emergenza');
INSERT INTO `hunter_item_names` VALUES (50166, 'Risonatore di Gruppo');
INSERT INTO `hunter_item_names` VALUES (50167, 'Calibratore Fratture');
INSERT INTO `hunter_item_names` VALUES (50168, 'Frammento di Monarca');
INSERT INTO `hunter_item_names` VALUES (63000, 'Baule Rango E');
INSERT INTO `hunter_item_names` VALUES (63001, 'Baule Rango D');
INSERT INTO `hunter_item_names` VALUES (63002, 'Baule Rango C');
INSERT INTO `hunter_item_names` VALUES (63003, 'Baule Rango B');
INSERT INTO `hunter_item_names` VALUES (63004, 'Baule Rango A');
INSERT INTO `hunter_item_names` VALUES (63005, 'Baule Rango S');
INSERT INTO `hunter_item_names` VALUES (63006, 'Baule Rango ???');
INSERT INTO `hunter_item_names` VALUES (63007, 'Baule Speciale');
INSERT INTO `hunter_item_names` VALUES (80030, 'Buono 100 Gloria');
INSERT INTO `hunter_item_names` VALUES (80031, 'Buono 500 Gloria');
INSERT INTO `hunter_item_names` VALUES (80032, 'Buono 1000 Gloria');

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
  `mission_name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `mission_type` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `target_vnum` int NULL DEFAULT 0,
  `target_count` int NOT NULL DEFAULT 10,
  `min_rank` varchar(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'E',
  `gloria_reward` int NOT NULL DEFAULT 100,
  `gloria_penalty` int NOT NULL DEFAULT 25,
  `time_limit_minutes` int NULL DEFAULT 1440,
  `enabled` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`mission_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

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
  `mission_slot` int NOT NULL DEFAULT 1,
  `mission_def_id` int NOT NULL,
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
  INDEX `idx_missions_player_date`(`player_id` ASC, `assigned_date` ASC) USING BTREE,
  CONSTRAINT `hunter_player_missions_ibfk_1` FOREIGN KEY (`mission_def_id`) REFERENCES `hunter_mission_definitions` (`mission_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_player_missions
-- ----------------------------
INSERT INTO `hunter_player_missions` VALUES (28, 4, 1, 18, '2025-12-27', 12, 12, 'completed', 190, 38, '2025-12-27 02:10:07');
INSERT INTO `hunter_player_missions` VALUES (29, 4, 2, 7, '2025-12-27', 25, 25, 'completed', 65, 13, '2025-12-27 01:59:25');
INSERT INTO `hunter_player_missions` VALUES (30, 4, 3, 9, '2025-12-27', 6, 20, 'failed', 110, 22, NULL);
INSERT INTO `hunter_player_missions` VALUES (31, 3900, 1, 7, '2025-12-27', 0, 25, 'failed', 65, 13, NULL);
INSERT INTO `hunter_player_missions` VALUES (32, 3900, 2, 2, '2025-12-27', 0, 15, 'failed', 75, 15, NULL);
INSERT INTO `hunter_player_missions` VALUES (33, 3900, 3, 6, '2025-12-27', 0, 10, 'failed', 70, 14, NULL);
INSERT INTO `hunter_player_missions` VALUES (34, 2, 1, 5, '2025-12-27', 0, 12, 'failed', 55, 11, NULL);
INSERT INTO `hunter_player_missions` VALUES (35, 2, 2, 18, '2025-12-27', 0, 12, 'failed', 190, 38, NULL);
INSERT INTO `hunter_player_missions` VALUES (36, 2, 3, 17, '2025-12-27', 0, 3, 'failed', 250, 50, NULL);
INSERT INTO `hunter_player_missions` VALUES (37, 2, 1, 9, '2025-12-28', 0, 20, 'active', 110, 22, NULL);
INSERT INTO `hunter_player_missions` VALUES (38, 2, 2, 12, '2025-12-28', 0, 18, 'active', 95, 19, NULL);
INSERT INTO `hunter_player_missions` VALUES (39, 2, 3, 15, '2025-12-28', 0, 1, 'active', 200, 40, NULL);
INSERT INTO `hunter_player_missions` VALUES (40, 4, 1, 27, '2025-12-28', 60, 60, 'completed', 280, 56, '2025-12-28 02:09:55');
INSERT INTO `hunter_player_missions` VALUES (41, 4, 2, 14, '2025-12-28', 30, 30, 'completed', 105, 21, '2025-12-28 01:49:03');
INSERT INTO `hunter_player_missions` VALUES (42, 4, 3, 16, '2025-12-28', 0, 15, 'active', 180, 36, NULL);
INSERT INTO `hunter_player_missions` VALUES (43, 4, 1, 2, '2025-12-29', 1, 15, 'active', 75, 15, NULL);
INSERT INTO `hunter_player_missions` VALUES (44, 4, 2, 4, '2025-12-29', 0, 8, 'active', 80, 16, NULL);
INSERT INTO `hunter_player_missions` VALUES (45, 4, 3, 21, '2025-12-29', 0, 20, 'active', 185, 37, NULL);
INSERT INTO `hunter_player_missions` VALUES (46, 4, 1, 47, '2025-12-30', 250, 250, 'completed', 1800, 360, '2025-12-30 02:15:34');
INSERT INTO `hunter_player_missions` VALUES (47, 4, 2, 21, '2025-12-30', 0, 20, 'active', 185, 37, NULL);
INSERT INTO `hunter_player_missions` VALUES (48, 4, 3, 49, '2025-12-30', 200, 200, 'completed', 1900, 380, '2025-12-30 02:15:06');
INSERT INTO `hunter_player_missions` VALUES (49, 994, 1, 3, '2025-12-30', 0, 20, 'active', 60, 12, NULL);
INSERT INTO `hunter_player_missions` VALUES (50, 994, 2, 2, '2025-12-30', 0, 15, 'active', 75, 15, NULL);
INSERT INTO `hunter_player_missions` VALUES (51, 994, 3, 4, '2025-12-30', 0, 8, 'active', 80, 16, NULL);
INSERT INTO `hunter_player_missions` VALUES (52, 2, 1, 16, '2025-12-30', 0, 15, 'active', 180, 36, NULL);
INSERT INTO `hunter_player_missions` VALUES (53, 2, 2, 21, '2025-12-30', 0, 20, 'active', 185, 37, NULL);
INSERT INTO `hunter_player_missions` VALUES (54, 2, 3, 2, '2025-12-30', 0, 15, 'active', 75, 15, NULL);
INSERT INTO `hunter_player_missions` VALUES (55, 4, 1, 23, '2025-12-31', 5, 5, 'completed', 400, 80, '2025-12-31 04:27:02');
INSERT INTO `hunter_player_missions` VALUES (56, 4, 2, 26, '2025-12-31', 2, 2, 'completed', 380, 76, '2025-12-31 04:26:58');
INSERT INTO `hunter_player_missions` VALUES (57, 4, 3, 32, '2025-12-31', 0, 2, 'active', 650, 130, NULL);
INSERT INTO `hunter_player_missions` VALUES (58, 4, 1, 46, '2026-01-01', 0, 8, 'active', 2200, 440, NULL);
INSERT INTO `hunter_player_missions` VALUES (59, 4, 2, 37, '2026-01-01', 0, 12, 'active', 1100, 220, NULL);
INSERT INTO `hunter_player_missions` VALUES (60, 4, 3, 7, '2026-01-01', 0, 25, 'active', 65, 13, NULL);
INSERT INTO `hunter_player_missions` VALUES (61, 4, 1, 26, '2026-01-04', 1, 2, 'active', 380, 76, NULL);
INSERT INTO `hunter_player_missions` VALUES (62, 4, 2, 6, '2026-01-04', 0, 10, 'active', 70, 14, NULL);
INSERT INTO `hunter_player_missions` VALUES (63, 4, 3, 39, '2026-01-04', 1, 5, 'active', 1200, 240, NULL);
INSERT INTO `hunter_player_missions` VALUES (64, 1684, 1, 5, '2026-01-04', 0, 12, 'active', 55, 11, NULL);
INSERT INTO `hunter_player_missions` VALUES (65, 1684, 2, 3, '2026-01-04', 0, 20, 'active', 60, 12, NULL);
INSERT INTO `hunter_player_missions` VALUES (66, 1684, 3, 7, '2026-01-04', 25, 25, 'completed', 65, 13, '2026-01-04 15:20:35');
INSERT INTO `hunter_player_missions` VALUES (67, 4, 1, 42, '2026-01-05', 0, 120, 'active', 950, 190, NULL);
INSERT INTO `hunter_player_missions` VALUES (68, 4, 2, 30, '2026-01-05', 0, 8, 'active', 700, 140, NULL);
INSERT INTO `hunter_player_missions` VALUES (69, 4, 3, 20, '2026-01-05', 0, 40, 'active', 170, 34, NULL);
INSERT INTO `hunter_player_missions` VALUES (70, 2, 1, 9, '2026-01-06', 0, 20, 'active', 110, 22, NULL);
INSERT INTO `hunter_player_missions` VALUES (71, 2, 2, 17, '2026-01-06', 0, 3, 'active', 250, 50, NULL);
INSERT INTO `hunter_player_missions` VALUES (72, 2, 3, 20, '2026-01-06', 0, 40, 'active', 170, 34, NULL);
INSERT INTO `hunter_player_missions` VALUES (73, 3901, 1, 6, '2026-01-06', 0, 10, 'active', 70, 14, NULL);
INSERT INTO `hunter_player_missions` VALUES (74, 3901, 2, 7, '2026-01-06', 25, 25, 'completed', 65, 13, '2026-01-06 12:00:32');
INSERT INTO `hunter_player_missions` VALUES (75, 3901, 3, 5, '2026-01-06', 0, 12, 'active', 55, 11, NULL);
INSERT INTO `hunter_player_missions` VALUES (76, 4, 1, 5, '2026-01-06', 0, 12, 'active', 55, 11, NULL);
INSERT INTO `hunter_player_missions` VALUES (77, 4, 2, 22, '2026-01-06', 0, 1, 'active', 350, 70, NULL);
INSERT INTO `hunter_player_missions` VALUES (78, 4, 3, 25, '2026-01-06', 0, 15, 'active', 300, 60, NULL);
INSERT INTO `hunter_player_missions` VALUES (79, 1684, 1, 3, '2026-01-06', 0, 20, 'active', 60, 12, NULL);
INSERT INTO `hunter_player_missions` VALUES (80, 1684, 2, 1, '2026-01-06', 0, 10, 'active', 50, 10, NULL);
INSERT INTO `hunter_player_missions` VALUES (81, 1684, 3, 7, '2026-01-06', 0, 25, 'active', 65, 13, NULL);

-- ----------------------------
-- Table structure for hunter_player_stats_snapshot
-- ----------------------------
DROP TABLE IF EXISTS `hunter_player_stats_snapshot`;
CREATE TABLE `hunter_player_stats_snapshot`  (
  `snapshot_id` bigint NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `player_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `snapshot_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'HOURLY, DAILY, SESSION',
  `kills_count` int NOT NULL DEFAULT 0,
  `glory_earned` int NOT NULL DEFAULT 0,
  `chests_opened` int NOT NULL DEFAULT 0,
  `fractures_completed` int NOT NULL DEFAULT 0,
  `defenses_won` int NOT NULL DEFAULT 0,
  `defenses_lost` int NOT NULL DEFAULT 0,
  `avg_kill_interval_ms` int NULL DEFAULT NULL COMMENT 'Intervallo medio tra kill in ms',
  `min_kill_interval_ms` int NULL DEFAULT NULL COMMENT 'Intervallo minimo (sospetto se troppo basso)',
  `session_duration_sec` int NULL DEFAULT NULL,
  `anomaly_score` int NOT NULL DEFAULT 0 COMMENT '0-100, alto = sospetto',
  `created_at` datetime NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`snapshot_id`) USING BTREE,
  INDEX `idx_player_type`(`player_id` ASC, `snapshot_type` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_anomaly`(`anomaly_score` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_player_stats_snapshot
-- ----------------------------

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
  INDEX `idx_player_status`(`player_id` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_player_trials
-- ----------------------------
INSERT INTO `hunter_player_trials` VALUES (18, 4, 1, 'completed', 3, 6, 0, 0, 0, '2025-12-30 11:41:12', '2025-12-30 11:46:42', NULL);
INSERT INTO `hunter_player_trials` VALUES (19, 4, 2, 'in_progress', 4, 0, 5, 2, 0, '2025-12-31 19:51:00', NULL, NULL);

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
INSERT INTO `hunter_quest_config` VALUES ('whatif_chance_percent', 10);
INSERT INTO `hunter_quest_config` VALUES ('speedkill_boss_bonus_pts', 200);
INSERT INTO `hunter_quest_config` VALUES ('speedkill_metin_bonus_pts', 80);
INSERT INTO `hunter_quest_config` VALUES ('streak_bonus_3days', 3);
INSERT INTO `hunter_quest_config` VALUES ('streak_bonus_7days', 7);
INSERT INTO `hunter_quest_config` VALUES ('streak_bonus_30days', 12);

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
  `force_power_rank` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`vnum`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_fractures
-- ----------------------------
INSERT INTO `hunter_quest_fractures` VALUES (16060, 'Frattura Primordiale', 'E-Rank', 'GREEN', 44, 0, 1, 0);
INSERT INTO `hunter_quest_fractures` VALUES (16061, 'Frattura Astrale', 'D-Rank', 'BLUE', 30, 2000, 1, 0);
INSERT INTO `hunter_quest_fractures` VALUES (16062, 'Frattura Abissale', 'C-Rank', 'ORANGE', 15, 10000, 1, 0);
INSERT INTO `hunter_quest_fractures` VALUES (16063, 'Frattura Cremisi', 'B-Rank', 'RED', 5, 0, 1, 100);
INSERT INTO `hunter_quest_fractures` VALUES (16064, 'Frattura Aurea', 'A-Rank', 'GOLD', 3, 0, 1, 200);
INSERT INTO `hunter_quest_fractures` VALUES (16065, 'Frattura Infausta', 'S-Rank', 'PURPLE', 2, 0, 1, 350);
INSERT INTO `hunter_quest_fractures` VALUES (16066, 'Frattura Instabile', 'N-Rank', 'BLACKWHITE', 1, 0, 1, 500);
INSERT INTO `hunter_quest_fractures` VALUES (16067, 'Frattura del Tesoro', 'A-Rank', 'GOLD', 0, 150000, 0, 0);
INSERT INTO `hunter_quest_fractures` VALUES (16068, 'Frattura Maledetta', 'S-Rank', 'PURPLE', 0, 500000, 0, 0);

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
  `penalty_active` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `penalty_expires` int UNSIGNED NOT NULL DEFAULT 0,
  `failed_missions` int UNSIGNED NOT NULL DEFAULT 0,
  `overtaken_by` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `overtaken_diff` int NULL DEFAULT 0,
  `overtaken_label` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`player_id`) USING BTREE,
  INDEX `idx_daily_points`(`daily_points` DESC) USING BTREE,
  INDEX `idx_weekly_points`(`weekly_points` DESC) USING BTREE,
  INDEX `idx_total_points`(`total_points` DESC) USING BTREE,
  INDEX `idx_ranking_pid`(`player_id` ASC) USING BTREE,
  INDEX `idx_ranking_daily`(`daily_points` DESC) USING BTREE,
  INDEX `idx_ranking_weekly`(`weekly_points` DESC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_ranking
-- ----------------------------
INSERT INTO `hunter_quest_ranking` VALUES (2, '[GF]Aelarion', 'C', 33901, 24000, 0, 17000, 300, 0, 100, 0, 0, 0, 0, 0, 0, 48, 0, 0, 'C', '2025-12-21 17:41:26', 0, 0, 0, NULL, 0, NULL);
INSERT INTO `hunter_quest_ranking` VALUES (4, '[GF]HunabKu', 'D', 1505467, 89628, 5040, 5040, 28, 28, 28, 0, 0, 0, 0, 0, 0, 24, 2, 18, 'D', '2025-12-30 11:39:29', 0, 0, 0, NULL, 0, NULL);
INSERT INTO `hunter_quest_ranking` VALUES (994, 'Spikelino', 'E', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 'E', '2025-12-30 12:08:31', 0, 0, 0, NULL, 0, NULL);
INSERT INTO `hunter_quest_ranking` VALUES (1684, 'Pacifista', 'E', 393, 393, 243, 243, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 'E', '2026-01-04 14:59:49', 0, 0, 0, NULL, 0, NULL);
INSERT INTO `hunter_quest_ranking` VALUES (3893, 'Potenza', 'E', 95, 95, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1, 0, 0, 'E', '2025-12-23 18:06:07', 0, 0, 0, '[GF]HunabKu', 1, 'ESPLORATORI');
INSERT INTO `hunter_quest_ranking` VALUES (3895, '123123123', 'E', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'E', '2025-12-25 12:02:22', 0, 0, 0, 'Pacifista', 1, 'ESPLORATORI');
INSERT INTO `hunter_quest_ranking` VALUES (3900, 'asdasdasd2', 'E', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'E', '2025-12-27 05:24:00', 0, 0, 0, 'Pacifista', 1, 'METIN');
INSERT INTO `hunter_quest_ranking` VALUES (3901, 'Spapum', 'E', 2915, 2915, 65, 65, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'E', '2026-01-06 12:00:19', 0, 0, 0, NULL, 0, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_shop
-- ----------------------------
INSERT INTO `hunter_quest_shop` VALUES (1, 80030, 1, 500, 'Buono 100 Punti', 1, 1);
INSERT INTO `hunter_quest_shop` VALUES (2, 80031, 1, 2500, 'Buono 500 Punti', 2, 1);
INSERT INTO `hunter_quest_shop` VALUES (3, 80032, 1, 5000, 'Buono 1000 Punti', 3, 1);
INSERT INTO `hunter_quest_shop` VALUES (4, 50163, 1, 25000, 'Chiave Dimensionale (Forza Baule)', 80, 1);
INSERT INTO `hunter_quest_shop` VALUES (5, 50168, 1, 50000, 'Frammento di Monarca (S-Rank + Focus)', 90, 1);
INSERT INTO `hunter_quest_shop` VALUES (6, 50160, 1, 1000, 'Scanner di Fratture (Evoca Subito)', 10, 1);
INSERT INTO `hunter_quest_shop` VALUES (7, 50162, 1, 2500, 'Focus del Cacciatore (+20% Gloria)', 20, 1);
INSERT INTO `hunter_quest_shop` VALUES (8, 50167, 1, 4000, 'Calibratore (Garantisce Rango C+)', 30, 1);
INSERT INTO `hunter_quest_shop` VALUES (9, 50161, 1, 7500, 'Stabilizzatore di Rango (Scegli Rank)', 40, 1);
INSERT INTO `hunter_quest_shop` VALUES (10, 50165, 1, 10000, 'Segnale d\'Emergenza (Forza Speed Kill)', 50, 1);
INSERT INTO `hunter_quest_shop` VALUES (11, 50164, 1, 12500, 'Sigillo di Conquista (Salta Difesa)', 60, 1);
INSERT INTO `hunter_quest_shop` VALUES (12, 50166, 1, 15000, 'Risonatore di Gruppo (Buff Party)', 70, 1);

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
INSERT INTO `hunter_quest_spawn_types` VALUES ('BAULE', 150, 0, 1);
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
  `rank_tier` int NOT NULL DEFAULT 1 COMMENT '1=E, 2=D, 3=C, 4=B, 5=A, 6=S, 7=N',
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`spawn_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_quest_spawns
-- ----------------------------
INSERT INTO `hunter_quest_spawns` VALUES (1, 63010, 'Metin Lv.45', 'SUPER_METIN', 35, 55, 25, 'GREEN', 1, 1);
INSERT INTO `hunter_quest_spawns` VALUES (2, 63011, 'Metin Lv.60', 'SUPER_METIN', 50, 70, 35, 'GREEN', 2, 1);
INSERT INTO `hunter_quest_spawns` VALUES (3, 63012, 'Metin Lv.75', 'SUPER_METIN', 65, 85, 50, 'BLUE', 2, 1);
INSERT INTO `hunter_quest_spawns` VALUES (4, 63013, 'Metin Lv.90', 'SUPER_METIN', 80, 100, 65, 'BLUE', 3, 1);
INSERT INTO `hunter_quest_spawns` VALUES (5, 63014, 'Metin Lv.95', 'SUPER_METIN', 85, 105, 80, 'ORANGE', 3, 1);
INSERT INTO `hunter_quest_spawns` VALUES (6, 63015, 'Metin Lv.115', 'SUPER_METIN', 105, 125, 100, 'ORANGE', 4, 1);
INSERT INTO `hunter_quest_spawns` VALUES (7, 63016, 'Metin Lv.135', 'SUPER_METIN', 125, 150, 125, 'RED', 4, 1);
INSERT INTO `hunter_quest_spawns` VALUES (8, 63017, 'Metin Lv.165', 'SUPER_METIN', 150, 180, 155, 'GOLD', 5, 1);
INSERT INTO `hunter_quest_spawns` VALUES (9, 63018, 'Metin Lv.200', 'SUPER_METIN', 180, 250, 190, 'PURPLE', 6, 1);
INSERT INTO `hunter_quest_spawns` VALUES (10, 4035, 'Funglash', 'BOSS', 65, 85, 10, 'GREEN', 1, 1);
INSERT INTO `hunter_quest_spawns` VALUES (11, 719, 'Thaloren', 'BOSS', 85, 105, 12, 'BLUE', 2, 1);
INSERT INTO `hunter_quest_spawns` VALUES (12, 2771, 'Yinlee', 'BOSS', 90, 110, 15, 'BLUE', 3, 1);
INSERT INTO `hunter_quest_spawns` VALUES (13, 768, 'Slubina', 'BOSS', 105, 125, 18, 'ORANGE', 3, 1);
INSERT INTO `hunter_quest_spawns` VALUES (14, 6790, 'Alastor', 'BOSS', 115, 135, 22, 'ORANGE', 4, 1);
INSERT INTO `hunter_quest_spawns` VALUES (15, 6831, 'Grimlor', 'BOSS', 125, 145, 28, 'RED', 4, 1);
INSERT INTO `hunter_quest_spawns` VALUES (16, 986, 'Branzhul', 'BOSS', 140, 160, 35, 'RED', 5, 1);
INSERT INTO `hunter_quest_spawns` VALUES (17, 989, 'Torgal', 'BOSS', 155, 175, 42, 'GOLD', 5, 1);
INSERT INTO `hunter_quest_spawns` VALUES (18, 4011, 'Nerzakar', 'BOSS', 175, 195, 50, 'GOLD', 6, 1);
INSERT INTO `hunter_quest_spawns` VALUES (19, 6830, 'Nozzera', 'BOSS', 190, 210, 60, 'PURPLE', 6, 1);
INSERT INTO `hunter_quest_spawns` VALUES (20, 4385, 'Velzahar', 'BOSS', 200, 250, 80, 'BLACKWHITE', 7, 1);
INSERT INTO `hunter_quest_spawns` VALUES (21, 63000, 'Cassa E-Rank', 'BAULE', 1, 250, 8, 'GREEN', 1, 1);
INSERT INTO `hunter_quest_spawns` VALUES (22, 63001, 'Cassa D-Rank', 'BAULE', 1, 250, 12, 'BLUE', 2, 1);
INSERT INTO `hunter_quest_spawns` VALUES (23, 63002, 'Cassa C-Rank', 'BAULE', 1, 250, 18, 'ORANGE', 3, 1);
INSERT INTO `hunter_quest_spawns` VALUES (24, 63003, 'Cassa B-Rank', 'BAULE', 1, 250, 25, 'RED', 4, 1);
INSERT INTO `hunter_quest_spawns` VALUES (25, 63004, 'Cassa A-Rank', 'BAULE', 1, 250, 35, 'PURPLE', 5, 1);
INSERT INTO `hunter_quest_spawns` VALUES (26, 63005, 'Cassa S-Rank', 'BAULE', 1, 250, 50, 'GOLD', 6, 1);
INSERT INTO `hunter_quest_spawns` VALUES (27, 63006, 'Cassa N-Rank', 'BAULE', 1, 250, 70, 'BLACKWHITE', 7, 1);
INSERT INTO `hunter_quest_spawns` VALUES (28, 63007, 'Cassa ???-Rank', 'BAULE', 1, 250, 90, 'PURPLE', 7, 1);
INSERT INTO `hunter_quest_spawns` VALUES (29, 63019, 'Metin Lv.???', 'SUPER_METIN', 180, 250, 300, 'BLACKWHITE', 7, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_rank_trials
-- ----------------------------
INSERT INTO `hunter_rank_trials` VALUES (1, 'E', 'D', 'Prova del Risvegliato', 'Dimostra di essere degno del rango D. Uccidi boss di basso livello e sigilla fratture primordiali.', 2000, 35, 3, '4035', 6, '4700,4701', 0, 'GREEN', 0, '63000', 0, 0, NULL, 500, NULL, NULL, 1, 'GREEN', 1);
INSERT INTO `hunter_rank_trials` VALUES (2, 'D', 'C', 'Prova del Cacciatore', 'Caccia boss più potenti e affronta fratture astrali. Solo i veri cacciatori sopravvivono.', 10000, 55, 5, '4035,719,2771', 10, '4701,4702,4703', 5, 'GREEN,BLUE', 5, NULL, 0, 0, NULL, 1000, NULL, NULL, 1, 'BLUE', 1);
INSERT INTO `hunter_rank_trials` VALUES (3, 'C', 'B', 'Prova del Veterano', 'Affronta le creature più pericolose. Solo i veterani possono aspirare al rango B.', 50000, 75, 10, '719,2771,768,6790', 20, '4702,4703,4704', 10, 'BLUE,ORANGE', 0, NULL, 15, 0, NULL, 2000, NULL, NULL, 1, 'ORANGE', 1);
INSERT INTO `hunter_rank_trials` VALUES (4, 'B', 'A', 'Risveglio Interiore', 'Il tuo potere interiore deve risvegliarsi. Affronta boss leggendari e fratture cremisi.', 150000, 95, 15, '6831,986,989', 30, '4704,4705,4706', 15, 'ORANGE,RED', 0, NULL, 0, 7, 168, 5000, NULL, NULL, 1, 'RED', 1);
INSERT INTO `hunter_rank_trials` VALUES (5, 'A', 'S', 'Ascensione Leggendaria', 'Solo i più potenti possono diventare leggende. Questa prova è brutale.', 500000, 115, 25, '989,4011,6830', 50, '4706,4707,4708', 25, 'RED,GOLD', 0, NULL, 0, 14, 336, 15000, 'Leggenda Vivente', NULL, 1, 'GOLD', 1);
INSERT INTO `hunter_rank_trials` VALUES (6, 'S', 'N', 'Il Giudizio Finale', 'La prova definitiva. Solo coloro che trascendono i limiti mortali possono diventare NATIONAL.', 1500000, 140, 50, '4011,6830,4385', 100, '4707,4708', 50, 'GOLD,PURPLE,BLACKWHITE', 20, '63003', 0, 30, 720, 50000, 'Monarca Nazionale', NULL, 1, 'BLACKWHITE', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_ranks
-- ----------------------------
INSERT INTO `hunter_ranks` VALUES (1, 'E', 'E-Rank', 'Risvegliato', 0, 2000, 'FF808080', 0, 0, 1);
INSERT INTO `hunter_ranks` VALUES (2, 'D', 'D-Rank', 'Apprendista', 2000, 10000, 'FF00AA00', 2, 0, 2);
INSERT INTO `hunter_ranks` VALUES (3, 'C', 'C-Rank', 'Cacciatore', 10000, 50000, 'FF00CCFF', 4, 0, 3);
INSERT INTO `hunter_ranks` VALUES (4, 'B', 'B-Rank', 'Veterano', 50000, 150000, 'FF0066FF', 6, 0, 4);
INSERT INTO `hunter_ranks` VALUES (5, 'A', 'A-Rank', 'Maestro', 150000, 500000, 'FFAA00FF', 9, 0, 5);
INSERT INTO `hunter_ranks` VALUES (6, 'S', 'S-Rank', 'Leggenda', 500000, 1500000, 'FFFF6600', 13, 0, 6);
INSERT INTO `hunter_ranks` VALUES (7, 'N', 'NATIONAL', 'Monarca Nazionale', 1500000, 5000000, 'FFFF0000', 18, 0, 7);
INSERT INTO `hunter_ranks` VALUES (8, '?', '???', 'Trascendente', 5000000, 999999999, 'FFFFFFFF', 35, 0, 8);

-- ----------------------------
-- Table structure for hunter_scheduled_events
-- ----------------------------
DROP TABLE IF EXISTS `hunter_scheduled_events`;
CREATE TABLE `hunter_scheduled_events`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `event_type` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `event_desc` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `start_hour` tinyint NOT NULL DEFAULT 0,
  `start_minute` tinyint NOT NULL DEFAULT 0,
  `duration_minutes` smallint NOT NULL DEFAULT 30,
  `days_active` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '1,2,3,4,5,6,7',
  `min_rank` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'E',
  `reward_glory_base` int NOT NULL DEFAULT 50,
  `reward_glory_winner` int NOT NULL DEFAULT 200,
  `color_scheme` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'GOLD',
  `priority` tinyint NULL DEFAULT 5,
  `enabled` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_enabled`(`enabled` ASC) USING BTREE,
  INDEX `idx_start_hour`(`start_hour` ASC) USING BTREE,
  INDEX `idx_days_active`(`days_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

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
-- Table structure for hunter_security_logs
-- ----------------------------
DROP TABLE IF EXISTS `hunter_security_logs`;
CREATE TABLE `hunter_security_logs`  (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `player_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `log_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'SPAWN, DEFENSE, REWARD, KILL, FRACTURE, CHEST, GLORY, SUSPICIOUS',
  `severity` enum('INFO','WARNING','ALERT','CRITICAL') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'INFO',
  `action` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Azione eseguita',
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'Dettagli JSON',
  `map_index` int NULL DEFAULT 0,
  `position_x` int NULL DEFAULT 0,
  `position_y` int NULL DEFAULT 0,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`log_id`) USING BTREE,
  INDEX `idx_player`(`player_id` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_type_severity`(`log_type` ASC, `severity` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` ASC) USING BTREE,
  INDEX `idx_severity`(`severity` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_security_logs
-- ----------------------------

-- ----------------------------
-- Table structure for hunter_suspicious_players
-- ----------------------------
DROP TABLE IF EXISTS `hunter_suspicious_players`;
CREATE TABLE `hunter_suspicious_players`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `player_id` int NOT NULL,
  `player_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `alert_count` int NOT NULL DEFAULT 1,
  `first_alert_at` datetime NOT NULL DEFAULT current_timestamp,
  `last_alert_at` datetime NOT NULL DEFAULT current_timestamp,
  `status` enum('MONITORING','WARNED','BANNED') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'MONITORING',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_player`(`player_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC, `alert_count` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of hunter_suspicious_players
-- ----------------------------

-- ----------------------------
-- Table structure for hunter_system_status
-- ----------------------------
DROP TABLE IF EXISTS `hunter_system_status`;
CREATE TABLE `hunter_system_status`  (
  `status_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_update` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`status_key`) USING BTREE,
  UNIQUE INDEX `status_key`(`status_key` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

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
  `text_key` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `text_value` varchar(500) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `category` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'general',
  `color_code` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`text_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = DYNAMIC;

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
-- View structure for v_hunter_daily_summary
-- ----------------------------
DROP VIEW IF EXISTS `v_hunter_daily_summary`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_hunter_daily_summary` AS select `hunter_security_logs`.`player_id` AS `player_id`,`hunter_security_logs`.`player_name` AS `player_name`,cast(`hunter_security_logs`.`created_at` as date) AS `log_date`,count(0) AS `total_logs`,sum(case when `hunter_security_logs`.`severity` = 'INFO' then 1 else 0 end) AS `info_count`,sum(case when `hunter_security_logs`.`severity` = 'WARNING' then 1 else 0 end) AS `warning_count`,sum(case when `hunter_security_logs`.`severity` = 'ALERT' then 1 else 0 end) AS `alert_count`,sum(case when `hunter_security_logs`.`severity` = 'CRITICAL' then 1 else 0 end) AS `critical_count`,sum(case when `hunter_security_logs`.`log_type` = 'SPAWN' then 1 else 0 end) AS `spawn_logs`,sum(case when `hunter_security_logs`.`log_type` = 'DEFENSE' then 1 else 0 end) AS `defense_logs`,sum(case when `hunter_security_logs`.`log_type` = 'REWARD' then 1 else 0 end) AS `reward_logs`,sum(case when `hunter_security_logs`.`log_type` = 'GLORY' then 1 else 0 end) AS `glory_logs` from `hunter_security_logs` group by `hunter_security_logs`.`player_id`,`hunter_security_logs`.`player_name`,cast(`hunter_security_logs`.`created_at` as date);

-- ----------------------------
-- View structure for v_hunter_suspicious_activity
-- ----------------------------
DROP VIEW IF EXISTS `v_hunter_suspicious_activity`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_hunter_suspicious_activity` AS select `l`.`log_id` AS `log_id`,`l`.`player_id` AS `player_id`,`l`.`player_name` AS `player_name`,`l`.`log_type` AS `log_type`,`l`.`severity` AS `severity`,`l`.`action` AS `action`,`l`.`details` AS `details`,`l`.`map_index` AS `map_index`,`l`.`position_x` AS `position_x`,`l`.`position_y` AS `position_y`,`l`.`created_at` AS `created_at`,`s`.`alert_count` AS `alert_count`,`s`.`status` AS `player_status` from (`hunter_security_logs` `l` left join `hunter_suspicious_players` `s` on(`l`.`player_id` = `s`.`player_id`)) where `l`.`severity` in ('WARNING','ALERT','CRITICAL') order by `l`.`created_at` desc;

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
        IF done THEN LEAVE read_loop; END IF;
        
        UPDATE hunter_quest_ranking 
        SET total_points = GREATEST(0, total_points - v_total_penalty)
        WHERE player_id = v_player_id;
        
        UPDATE hunter_player_missions 
        SET status = 'failed'
        WHERE player_id = v_player_id 
          AND assigned_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
          AND status = 'active';
    END LOOP;
    CLOSE cur;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_assign_daily_missions
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_assign_daily_missions`;
delimiter ;;
CREATE PROCEDURE `sp_assign_daily_missions`(IN p_player_id INT, IN p_rank VARCHAR(2), IN p_player_name VARCHAR(64))
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
    
    -- Controlla missioni esistenti oggi
    SELECT COUNT(*) INTO v_existing FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_date = v_today;
    
    -- Se ne ha meno di 3 (o 0), rigenera
    IF v_existing < 3 THEN
        DELETE FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_date = v_today;
        
        -- Slot 1
        SELECT mission_id, target_count, gloria_reward, gloria_penalty 
        INTO v_mission1_id, v_mission1_target, v_mission1_reward, v_mission1_penalty
        FROM hunter_mission_definitions WHERE enabled = 1 AND fn_rank_to_num(min_rank) <= v_player_rank_num
        ORDER BY RAND() LIMIT 1;
        
        -- Slot 2
        SELECT mission_id, target_count, gloria_reward, gloria_penalty 
        INTO v_mission2_id, v_mission2_target, v_mission2_reward, v_mission2_penalty
        FROM hunter_mission_definitions WHERE enabled = 1 AND fn_rank_to_num(min_rank) <= v_player_rank_num AND mission_id != IFNULL(v_mission1_id, -1)
        ORDER BY RAND() LIMIT 1;
        
        -- Slot 3
        SELECT mission_id, target_count, gloria_reward, gloria_penalty 
        INTO v_mission3_id, v_mission3_target, v_mission3_reward, v_mission3_penalty
        FROM hunter_mission_definitions WHERE enabled = 1 AND fn_rank_to_num(min_rank) <= v_player_rank_num AND mission_id != IFNULL(v_mission1_id, -1) AND mission_id != IFNULL(v_mission2_id, -1)
        ORDER BY RAND() LIMIT 1;
        
        IF v_mission1_id IS NOT NULL THEN
            INSERT INTO hunter_player_missions (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
            VALUES (p_player_id, 1, v_mission1_id, v_today, 0, v_mission1_target, 'active', v_mission1_reward, v_mission1_penalty);
        END IF;
        IF v_mission2_id IS NOT NULL THEN
            INSERT INTO hunter_player_missions (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
            VALUES (p_player_id, 2, v_mission2_id, v_today, 0, v_mission2_target, 'active', v_mission2_reward, v_mission2_penalty);
        END IF;
        IF v_mission3_id IS NOT NULL THEN
            INSERT INTO hunter_player_missions (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
            VALUES (p_player_id, 3, v_mission3_id, v_today, 0, v_mission3_target, 'active', v_mission3_reward, v_mission3_penalty);
        END IF;
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
-- Procedure structure for sp_distribute_party_glory
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_distribute_party_glory`;
delimiter ;;
CREATE PROCEDURE `sp_distribute_party_glory`(IN p_opener_id INT,
    IN p_opener_name VARCHAR(50),
    IN p_base_glory INT,
    IN p_source_type VARCHAR(50),
    IN p_source_name VARCHAR(100))
BEGIN
    DECLARE v_party_id INT DEFAULT 0;
    DECLARE v_member_count INT DEFAULT 0;
    DECLARE v_share_per_member INT DEFAULT 0;
    
    -- Trova il party_id del giocatore che ha aperto
    SELECT pid INTO v_party_id 
    FROM player.player 
    WHERE id = p_opener_id;
    
    -- Se non ha party (pid=0), assegna tutto a lui
    IF v_party_id IS NULL OR v_party_id = 0 THEN
        -- Assegna direttamente all'opener
        UPDATE srv1_hunabku.hunter_quest_ranking 
        SET total_points = total_points + p_base_glory,
            spendable_points = spendable_points + p_base_glory
        WHERE player_id = p_opener_id;
    ELSE
        -- Conta i membri del party
        SELECT COUNT(*) INTO v_member_count 
        FROM player.player 
        WHERE pid = v_party_id;
        
        IF v_member_count < 1 THEN SET v_member_count = 1; END IF;
        
        -- Calcola la quota per membro (divisione equa semplice)
        SET v_share_per_member = FLOOR(p_base_glory / v_member_count);
        IF v_share_per_member < 1 THEN SET v_share_per_member = 1; END IF;
        
        -- Inserisci ricompense pendenti per TUTTI i membri del party
        INSERT INTO srv1_hunabku.hunter_pending_rewards 
            (player_id, player_name, glory_amount, source_type, source_name, opener_id, opener_name)
        SELECT 
            p.id,
            p.name,
            v_share_per_member,
            p_source_type,
            p_source_name,
            p_opener_id,
            p_opener_name
        FROM player.player p
        WHERE p.pid = v_party_id;
        
        -- Assegna subito la gloria a tutti i membri del party
        UPDATE srv1_hunabku.hunter_quest_ranking r
        INNER JOIN player.player p ON r.player_id = p.id
        SET r.total_points = r.total_points + v_share_per_member,
            r.spendable_points = r.spendable_points + v_share_per_member
        WHERE p.pid = v_party_id;
        
        -- Marca le ricompense come consegnate
        UPDATE srv1_hunabku.hunter_pending_rewards
        SET claimed = 1, claimed_at = NOW()
        WHERE opener_id = p_opener_id 
        AND source_name = p_source_name
        AND claimed = 0;
    END IF;
    
    -- Ritorna il numero di membri che hanno ricevuto
    SELECT v_member_count AS members_rewarded, v_share_per_member AS glory_each;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_distribute_party_glory_merit
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_distribute_party_glory_merit`;
delimiter ;;
CREATE PROCEDURE `sp_distribute_party_glory_merit`(IN p_opener_id INT,
    IN p_opener_name VARCHAR(50),
    IN p_base_glory INT,
    IN p_source_type VARCHAR(50),
    IN p_source_name VARCHAR(100))
BEGIN
    DECLARE v_party_id INT DEFAULT 0;
    DECLARE v_total_power INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_pid INT;
    DECLARE v_pname VARCHAR(50);
    DECLARE v_points INT;
    DECLARE v_grade VARCHAR(5);
    DECLARE v_power INT;
    DECLARE v_share INT;
    DECLARE v_member_count INT DEFAULT 0;
    
    -- Cursore per iterare sui membri del party
    DECLARE member_cursor CURSOR FOR
        SELECT p.id, p.name, COALESCE(r.total_points, 0) as points
        FROM player.player p
        LEFT JOIN srv1_hunabku.hunter_quest_ranking r ON p.id = r.player_id
        WHERE p.pid = v_party_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Trova il party_id
    SELECT pid INTO v_party_id 
    FROM player.player 
    WHERE id = p_opener_id;
    
    -- Se non ha party, assegna tutto a lui
    IF v_party_id IS NULL OR v_party_id = 0 THEN
        UPDATE srv1_hunabku.hunter_quest_ranking 
        SET total_points = total_points + p_base_glory,
            spendable_points = spendable_points + p_base_glory
        WHERE player_id = p_opener_id;
        
        SELECT 1 AS members_rewarded, p_base_glory AS glory_each;
    ELSE
        -- Calcola il power totale del party
        SELECT SUM(
            CASE 
                WHEN COALESCE(r.total_points, 0) >= 100000 THEN 250  -- N
                WHEN COALESCE(r.total_points, 0) >= 50000 THEN 150   -- S
                WHEN COALESCE(r.total_points, 0) >= 20000 THEN 80    -- A
                WHEN COALESCE(r.total_points, 0) >= 8000 THEN 40     -- B
                WHEN COALESCE(r.total_points, 0) >= 3000 THEN 15     -- C
                WHEN COALESCE(r.total_points, 0) >= 500 THEN 5       -- D
                ELSE 1                                               -- E
            END
        ) INTO v_total_power
        FROM player.player p
        LEFT JOIN srv1_hunabku.hunter_quest_ranking r ON p.id = r.player_id
        WHERE p.pid = v_party_id;
        
        IF v_total_power < 1 THEN SET v_total_power = 1; END IF;
        
        -- Itera sui membri e distribuisci per meritocrazia
        OPEN member_cursor;
        
        read_loop: LOOP
            FETCH member_cursor INTO v_pid, v_pname, v_points;
            IF done THEN
                LEAVE read_loop;
            END IF;
            
            -- Calcola il power rank di questo membro
            SET v_power = CASE 
                WHEN v_points >= 100000 THEN 250
                WHEN v_points >= 50000 THEN 150
                WHEN v_points >= 20000 THEN 80
                WHEN v_points >= 8000 THEN 40
                WHEN v_points >= 3000 THEN 15
                WHEN v_points >= 500 THEN 5
                ELSE 1
            END;
            
            -- Calcola la quota basata sul power rank
            SET v_share = FLOOR((v_power * p_base_glory) / v_total_power);
            IF v_share < 1 THEN SET v_share = 1; END IF;
            
            -- Assegna la gloria
            UPDATE srv1_hunabku.hunter_quest_ranking 
            SET total_points = total_points + v_share,
                spendable_points = spendable_points + v_share
            WHERE player_id = v_pid;
            
            -- Se non esiste il record, crealo
            IF ROW_COUNT() = 0 THEN
                INSERT INTO srv1_hunabku.hunter_quest_ranking 
                    (player_id, player_name, total_points, spendable_points)
                VALUES (v_pid, v_pname, v_share, v_share)
                ON DUPLICATE KEY UPDATE
                    total_points = total_points + v_share,
                    spendable_points = spendable_points + v_share;
            END IF;
            
            -- Log nella tabella pending (per storico)
            INSERT INTO srv1_hunabku.hunter_pending_rewards 
                (player_id, player_name, glory_amount, source_type, source_name, opener_id, opener_name, claimed, claimed_at)
            VALUES (v_pid, v_pname, v_share, p_source_type, p_source_name, p_opener_id, p_opener_name, 1, NOW());
            
            SET v_member_count = v_member_count + 1;
        END LOOP;
        
        CLOSE member_cursor;
        
        SELECT v_member_count AS members_rewarded, p_base_glory AS total_glory;
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
-- Procedure structure for sp_get_party_notifications
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_party_notifications`;
delimiter ;;
CREATE PROCEDURE `sp_get_party_notifications`(IN p_player_id INT)
BEGIN
    -- Seleziona tutte le notifiche non ancora mostrate (max 5 alla volta)
    SELECT id, notification_type, source_name, glory_received, glory_total,
           actor_name, actor_rank, color_code, extra_data, created_at
    FROM srv1_hunabku.hunter_party_notifications
    WHERE player_id = p_player_id AND shown = 0
    ORDER BY created_at ASC
    LIMIT 5;
    
    -- Marca come mostrate
    UPDATE srv1_hunabku.hunter_party_notifications
    SET shown = 1, shown_at = NOW()
    WHERE player_id = p_player_id AND shown = 0
    LIMIT 5;
    
    -- Pulizia vecchie notifiche (oltre 1 ora)
    DELETE FROM srv1_hunabku.hunter_party_notifications
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 HOUR);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_activity
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_activity`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_activity`(IN p_player_id INT,
    IN p_player_name VARCHAR(24),
    IN p_activity_type VARCHAR(30),
    IN p_vnum INT,
    IN p_amount INT,
    IN p_metadata JSON)
BEGIN
    DECLARE v_base_points INT DEFAULT 0;
    DECLARE v_vnum_type VARCHAR(20) DEFAULT 'mob';
    DECLARE v_current_rank CHAR(1) DEFAULT 'E';
    DECLARE v_streak_bonus DECIMAL(5,2) DEFAULT 0;
    DECLARE v_event_mult DECIMAL(3,2) DEFAULT 1.00;
    DECLARE v_final_glory INT DEFAULT 0;
    DECLARE v_is_boss TINYINT DEFAULT 0;
    DECLARE v_is_metin TINYINT DEFAULT 0;
    DECLARE v_speed_kill_bonus TINYINT DEFAULT 0;
    
    INSERT INTO hunter_players (player_id, player_name, created_at)
    VALUES (p_player_id, p_player_name, NOW())
    ON DUPLICATE KEY UPDATE player_name = p_player_name;
    
    SELECT current_rank,
           CASE 
               WHEN login_streak >= 30 THEN 0.20
               WHEN login_streak >= 14 THEN 0.15
               WHEN login_streak >= 7 THEN 0.10
               WHEN login_streak >= 3 THEN 0.05
               ELSE 0
           END
    INTO v_current_rank, v_streak_bonus
    FROM hunter_players WHERE player_id = p_player_id;
    
    IF p_activity_type IN ('kill_mob', 'kill_boss', 'kill_metin') THEN
        SELECT COALESCE(base_points, 1), 
               COALESCE(vnum_type, 'mob'),
               COALESCE(event_multiplier, 1.00),
               COALESCE(speed_kill_bonus, 0)
        INTO v_base_points, v_vnum_type, v_event_mult, v_speed_kill_bonus
        FROM hunter_vnum_registry WHERE vnum = p_vnum;
        
        IF v_base_points = 0 THEN SET v_base_points = 1; END IF;
        SET v_is_boss = IF(v_vnum_type IN ('boss', 'super_boss'), 1, 0);
        SET v_is_metin = IF(v_vnum_type IN ('metin', 'super_metin'), 1, 0);
        SET v_final_glory = FLOOR(v_base_points * v_event_mult * (1 + v_streak_bonus));
        
        IF p_amount = 1 AND v_speed_kill_bonus = 1 THEN
            SET v_final_glory = v_final_glory * 2;
        END IF;
        
        UPDATE hunter_players SET
            pending_glory = pending_glory + v_final_glory,
            pending_kills = pending_kills + 1,
            total_bosses = total_bosses + v_is_boss,
            total_metins = total_metins + v_is_metin,
            trial_boss_kills = trial_boss_kills + IF(trial_id > 0, v_is_boss, 0),
            trial_metin_kills = trial_metin_kills + IF(trial_id > 0, v_is_metin, 0)
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'open_chest' THEN
        SELECT COALESCE(base_points, 50) INTO v_final_glory FROM hunter_vnum_registry WHERE vnum = p_vnum;
        IF v_final_glory = 0 THEN SET v_final_glory = 50; END IF;
        UPDATE hunter_players SET
            pending_glory = pending_glory + v_final_glory,
            total_chests = total_chests + 1,
            trial_chest_opens = trial_chest_opens + IF(trial_id > 0, 1, 0)
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'seal_fracture' THEN
        SET v_final_glory = p_amount;
        UPDATE hunter_players SET
            pending_glory = pending_glory + v_final_glory,
            total_fractures = total_fractures + 1,
            trial_fracture_seals = trial_fracture_seals + IF(trial_id > 0, 1, 0)
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'complete_mission' THEN
        SET v_final_glory = p_amount;
        UPDATE hunter_players SET
            pending_glory = pending_glory + v_final_glory,
            trial_daily_missions = trial_daily_missions + IF(trial_id > 0, 1, 0)
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'complete_trial' THEN
        SET v_final_glory = p_amount;
        UPDATE hunter_players SET
            pending_glory = pending_glory + v_final_glory,
            trial_id = 0, trial_boss_kills = 0, trial_metin_kills = 0,
            trial_fracture_seals = 0, trial_chest_opens = 0, trial_daily_missions = 0,
            trial_started_at = NULL, trial_expires_at = NULL
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'enter_gate' THEN
        UPDATE hunter_players SET
            gate_id = p_vnum,
            gate_entered_at = NOW(),
            gate_expires_at = DATE_ADD(NOW(), INTERVAL p_amount MINUTE)
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'complete_gate' THEN
        SET v_final_glory = p_amount;
        UPDATE hunter_players SET
            pending_glory = pending_glory + v_final_glory,
            gate_id = 0, gate_entered_at = NULL, gate_expires_at = NULL
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'fail_gate' THEN
        SET v_final_glory = -p_amount;
        UPDATE hunter_players SET
            total_glory = GREATEST(0, total_glory - p_amount),
            gate_id = 0, gate_entered_at = NULL, gate_expires_at = NULL
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'login_bonus' THEN
        UPDATE hunter_players SET
            login_streak = IF(last_login = DATE_SUB(CURDATE(), INTERVAL 1 DAY), login_streak + 1, 1),
            last_login = CURDATE()
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'convert_credits' THEN
        UPDATE hunter_players SET
            spendable_credits = spendable_credits + p_amount,
            total_glory = GREATEST(0, total_glory - (p_amount * 10))
        WHERE player_id = p_player_id;
        
    ELSEIF p_activity_type = 'shop_purchase' THEN
        UPDATE hunter_players SET
            spendable_credits = GREATEST(0, spendable_credits - p_amount)
        WHERE player_id = p_player_id;
    END IF;
    
    IF v_final_glory != 0 OR p_activity_type IN ('enter_gate', 'login_bonus', 'shop_purchase') THEN
        INSERT INTO hunter_activity_log (player_id, activity_type, vnum, glory_change, metadata)
        VALUES (p_player_id, p_activity_type, p_vnum, v_final_glory, p_metadata);
    END IF;
    
    SELECT v_final_glory AS glory_earned, v_vnum_type AS vnum_type, v_is_boss AS is_boss, v_is_metin AS is_metin;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_assign_missions
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_assign_missions`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_assign_missions`(IN p_player_id INT)
BEGIN
    DECLARE v_rank CHAR(1);
    DECLARE v_today DATE;
    DECLARE v_count INT;
    
    SET v_today = CURDATE();
    SELECT COUNT(*) INTO v_count FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_at = v_today;
    
    IF v_count > 0 THEN
        SELECT pm.slot, pm.mission_id, pm.current_progress, pm.status, m.mission_name, m.mission_type, 
               m.target_vnum, m.target_count, m.glory_reward, m.glory_penalty
        FROM hunter_player_missions pm JOIN hunter_missions m ON pm.mission_id = m.mission_id
        WHERE pm.player_id = p_player_id AND pm.assigned_at = v_today ORDER BY pm.slot;
    ELSE
        SELECT current_rank INTO v_rank FROM hunter_players WHERE player_id = p_player_id;
        
        INSERT INTO hunter_player_missions (player_id, slot, mission_id, assigned_at)
        SELECT p_player_id, 0, mission_id, v_today FROM hunter_missions
        WHERE is_active = 1 AND min_rank <= v_rank ORDER BY RAND() * weight DESC LIMIT 1;
        
        INSERT INTO hunter_player_missions (player_id, slot, mission_id, assigned_at)
        SELECT p_player_id, 1, mission_id, v_today FROM hunter_missions
        WHERE is_active = 1 AND min_rank <= v_rank AND mission_id NOT IN 
            (SELECT mission_id FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_at = v_today)
        ORDER BY RAND() * weight DESC LIMIT 1;
        
        INSERT INTO hunter_player_missions (player_id, slot, mission_id, assigned_at)
        SELECT p_player_id, 2, mission_id, v_today FROM hunter_missions
        WHERE is_active = 1 AND min_rank <= v_rank AND mission_id NOT IN 
            (SELECT mission_id FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_at = v_today)
        ORDER BY RAND() * weight DESC LIMIT 1;
        
        SELECT pm.slot, pm.mission_id, pm.current_progress, pm.status, m.mission_name, m.mission_type,
               m.target_vnum, m.target_count, m.glory_reward, m.glory_penalty
        FROM hunter_player_missions pm JOIN hunter_missions m ON pm.mission_id = m.mission_id
        WHERE pm.player_id = p_player_id AND pm.assigned_at = v_today ORDER BY pm.slot;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_daily_reset
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_daily_reset`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_daily_reset`()
BEGIN
    CALL sp_hunter_flush_pending();
    UPDATE hunter_players SET daily_glory = 0, daily_kills = 0, daily_position = 0;
    UPDATE hunter_player_missions SET status = 'failed' WHERE status = 'active' AND assigned_at < CURDATE();
    SELECT 'DAILY_RESET_COMPLETE' AS status;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_flush_pending
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_flush_pending`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_flush_pending`()
BEGIN
    UPDATE hunter_players SET
        total_glory = total_glory + pending_glory,
        daily_glory = daily_glory + pending_glory,
        weekly_glory = weekly_glory + pending_glory,
        total_kills = total_kills + pending_kills,
        daily_kills = daily_kills + pending_kills,
        weekly_kills = weekly_kills + pending_kills,
        pending_glory = 0, pending_kills = 0, last_flush = NOW()
    WHERE pending_glory > 0 OR pending_kills > 0;
    
    UPDATE hunter_players SET current_rank = 
        CASE 
            WHEN total_glory >= 1500000 THEN 'N'
            WHEN total_glory >= 500000 THEN 'S'
            WHEN total_glory >= 150000 THEN 'A'
            WHEN total_glory >= 50000 THEN 'B'
            WHEN total_glory >= 10000 THEN 'C'
            WHEN total_glory >= 2000 THEN 'D'
            ELSE 'E'
        END;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_get_active_events
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_get_active_events`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_get_active_events`()
BEGIN
    DECLARE v_day INT;
    DECLARE v_hour INT;
    
    SET v_day = DAYOFWEEK(NOW());
    SET v_hour = HOUR(NOW());
    
    SELECT event_id, event_name, event_type, glory_multiplier, min_rank, color_code, description
    FROM hunter_events
    WHERE is_active = 1
      AND FIND_IN_SET(v_day, days_active) > 0
      AND v_hour >= start_hour
      AND v_hour < (start_hour + CEIL(duration_minutes / 60));
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_get_player
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_get_player`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_get_player`(IN p_player_id INT)
BEGIN
    SELECT p.*, t.trial_name, t.to_rank, t.boss_kills_req, t.metin_kills_req,
           t.fracture_seals_req, t.chest_opens_req, t.daily_missions_req,
           t.glory_reward AS trial_glory_reward, t.color_code AS trial_color
    FROM hunter_players p
    LEFT JOIN hunter_trials t ON p.trial_id = t.trial_id
    WHERE p.player_id = p_player_id;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_get_ranking
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_get_ranking`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_get_ranking`(IN p_type VARCHAR(20), IN p_limit INT)
BEGIN
    IF p_type = 'daily' THEN
        SELECT player_name, daily_glory AS glory, daily_kills AS kills, current_rank
        FROM hunter_players WHERE daily_glory > 0 ORDER BY daily_glory DESC LIMIT p_limit;
    ELSEIF p_type = 'weekly' THEN
        SELECT player_name, weekly_glory AS glory, weekly_kills AS kills, current_rank
        FROM hunter_players WHERE weekly_glory > 0 ORDER BY weekly_glory DESC LIMIT p_limit;
    ELSE
        SELECT player_name, total_glory AS glory, total_kills AS kills, current_rank
        FROM hunter_players WHERE total_glory > 0 ORDER BY total_glory DESC LIMIT p_limit;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_log
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_log`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_log`(IN p_player_id INT,
    IN p_player_name VARCHAR(50),
    IN p_log_type VARCHAR(32),
    IN p_severity VARCHAR(16),
    IN p_action VARCHAR(64),
    IN p_details TEXT,
    IN p_map_index INT,
    IN p_pos_x INT,
    IN p_pos_y INT)
BEGIN
    INSERT INTO hunter_security_logs 
        (player_id, player_name, log_type, severity, action, details, map_index, position_x, position_y)
    VALUES 
        (p_player_id, p_player_name, p_log_type, p_severity, p_action, p_details, p_map_index, p_pos_x, p_pos_y);
    
    -- Se severity alta, aggiorna/inserisci in suspicious_players
    IF p_severity IN ('ALERT', 'CRITICAL') THEN
        INSERT INTO hunter_suspicious_players (player_id, player_name, reason, alert_count, first_alert_at, last_alert_at)
        VALUES (p_player_id, p_player_name, p_action, 1, NOW(), NOW())
        ON DUPLICATE KEY UPDATE 
            alert_count = alert_count + 1,
            last_alert_at = NOW(),
            reason = CONCAT(reason, ' | ', p_action);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_log_cleanup
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_log_cleanup`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_log_cleanup`()
BEGIN
    -- Elimina log INFO piu vecchi di 7 giorni
    DELETE FROM hunter_security_logs 
    WHERE severity = 'INFO' AND created_at < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    -- Elimina log WARNING piu vecchi di 30 giorni
    DELETE FROM hunter_security_logs 
    WHERE severity = 'WARNING' AND created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
    
    -- Mantieni ALERT e CRITICAL per 90 giorni
    DELETE FROM hunter_security_logs 
    WHERE severity IN ('ALERT', 'CRITICAL') AND created_at < DATE_SUB(NOW(), INTERVAL 90 DAY);
    
    -- Elimina snapshot piu vecchi di 30 giorni
    DELETE FROM hunter_player_stats_snapshot
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_start_trial
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_start_trial`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_start_trial`(IN p_player_id INT)
BEGIN
    DECLARE v_rank CHAR(1);
    DECLARE v_trial_id INT;
    DECLARE v_duration INT;
    
    SELECT current_rank INTO v_rank FROM hunter_players WHERE player_id = p_player_id;
    SELECT trial_id, duration_hours INTO v_trial_id, v_duration FROM hunter_trials WHERE from_rank = v_rank LIMIT 1;
    
    IF v_trial_id IS NOT NULL THEN
        UPDATE hunter_players SET
            trial_id = v_trial_id, trial_boss_kills = 0, trial_metin_kills = 0,
            trial_fracture_seals = 0, trial_chest_opens = 0, trial_daily_missions = 0,
            trial_started_at = NOW(), trial_expires_at = DATE_ADD(NOW(), INTERVAL v_duration HOUR)
        WHERE player_id = p_player_id;
        
        SELECT t.*, p.trial_expires_at FROM hunter_trials t
        JOIN hunter_players p ON p.trial_id = t.trial_id
        WHERE t.trial_id = v_trial_id AND p.player_id = p_player_id;
    ELSE
        SELECT 'NO_TRIAL' AS error;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_update_mission
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_update_mission`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_update_mission`(IN p_player_id INT,
    IN p_mission_type VARCHAR(20),
    IN p_vnum INT,
    IN p_increment INT)
BEGIN
    DECLARE v_today DATE;
    SET v_today = CURDATE();
    
    -- Aggiorna progresso per missioni attive che matchano il tipo
    UPDATE hunter_player_missions pm
    JOIN hunter_missions m ON pm.mission_id = m.mission_id
    SET pm.current_progress = pm.current_progress + p_increment,
        pm.status = CASE 
            WHEN pm.current_progress + p_increment >= m.target_count THEN 'completed'
            ELSE 'active'
        END,
        pm.completed_at = CASE
            WHEN pm.current_progress + p_increment >= m.target_count THEN NOW()
            ELSE NULL
        END
    WHERE pm.player_id = p_player_id
      AND pm.assigned_at = v_today
      AND pm.status = 'active'
      AND (
          m.mission_type = p_mission_type
          OR (m.mission_type = 'kill_any' AND p_mission_type IN ('kill_mob', 'kill_boss', 'kill_metin'))
          OR (m.mission_type = 'kill_vnum' AND m.target_vnum = p_vnum)
      );
    
    -- Ritorna stato missioni aggiornate
    SELECT pm.slot, pm.mission_id, pm.current_progress, pm.status, 
           m.mission_name, m.target_count, m.glory_reward, m.glory_penalty
    FROM hunter_player_missions pm
    JOIN hunter_missions m ON pm.mission_id = m.mission_id
    WHERE pm.player_id = p_player_id AND pm.assigned_at = v_today;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_hunter_weekly_reset
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_hunter_weekly_reset`;
delimiter ;;
CREATE PROCEDURE `sp_hunter_weekly_reset`()
BEGIN
    CALL sp_hunter_daily_reset();
    UPDATE hunter_players SET weekly_glory = 0, weekly_kills = 0, weekly_position = 0;
    SELECT 'WEEKLY_RESET_COMPLETE' AS status;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_notify_party_glory
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_notify_party_glory`;
delimiter ;;
CREATE PROCEDURE `sp_notify_party_glory`(IN p_actor_id INT,
    IN p_actor_name VARCHAR(50),
    IN p_actor_rank VARCHAR(10),
    IN p_notification_type VARCHAR(30),
    IN p_source_name VARCHAR(100),
    IN p_glory_total INT,
    IN p_color_code VARCHAR(20),
    IN p_extra_data VARCHAR(255))
BEGIN
    DECLARE v_party_id INT DEFAULT 0;
    DECLARE v_total_power INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_pid INT;
    DECLARE v_pname VARCHAR(50);
    DECLARE v_points INT;
    DECLARE v_power INT;
    DECLARE v_share INT;
    
    DECLARE member_cursor CURSOR FOR
        SELECT p.id, p.name, COALESCE(r.total_points, 0) as points
        FROM player.player p
        LEFT JOIN srv1_hunabku.hunter_quest_ranking r ON p.id = r.player_id
        WHERE p.pid = v_party_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Trova il party_id
    SELECT pid INTO v_party_id 
    FROM player.player 
    WHERE id = p_actor_id;
    
    -- Se non ha party, notifica solo a lui
    IF v_party_id IS NULL OR v_party_id = 0 THEN
        INSERT INTO srv1_hunabku.hunter_party_notifications 
            (player_id, notification_type, source_name, glory_received, glory_total, 
             actor_name, actor_rank, color_code, extra_data)
        VALUES (p_actor_id, p_notification_type, p_source_name, p_glory_total, p_glory_total,
                p_actor_name, p_actor_rank, p_color_code, p_extra_data);
    ELSE
        -- Calcola power totale per meritocrazia
        SELECT SUM(
            CASE 
                WHEN COALESCE(r.total_points, 0) >= 100000 THEN 250
                WHEN COALESCE(r.total_points, 0) >= 50000 THEN 150
                WHEN COALESCE(r.total_points, 0) >= 20000 THEN 80
                WHEN COALESCE(r.total_points, 0) >= 8000 THEN 40
                WHEN COALESCE(r.total_points, 0) >= 3000 THEN 15
                WHEN COALESCE(r.total_points, 0) >= 500 THEN 5
                ELSE 1
            END
        ) INTO v_total_power
        FROM player.player p
        LEFT JOIN srv1_hunabku.hunter_quest_ranking r ON p.id = r.player_id
        WHERE p.pid = v_party_id;
        
        IF v_total_power < 1 THEN SET v_total_power = 1; END IF;
        
        -- Crea notifica per ogni membro del party
        OPEN member_cursor;
        
        notify_loop: LOOP
            FETCH member_cursor INTO v_pid, v_pname, v_points;
            IF done THEN
                LEAVE notify_loop;
            END IF;
            
            -- Calcola la quota di gloria per questo membro
            SET v_power = CASE 
                WHEN v_points >= 100000 THEN 250
                WHEN v_points >= 50000 THEN 150
                WHEN v_points >= 20000 THEN 80
                WHEN v_points >= 8000 THEN 40
                WHEN v_points >= 3000 THEN 15
                WHEN v_points >= 500 THEN 5
                ELSE 1
            END;
            
            SET v_share = FLOOR((v_power * p_glory_total) / v_total_power);
            IF v_share < 1 THEN SET v_share = 1; END IF;
            
            -- Inserisci notifica
            INSERT INTO srv1_hunabku.hunter_party_notifications 
                (player_id, notification_type, source_name, glory_received, glory_total, 
                 actor_name, actor_rank, color_code, extra_data)
            VALUES (v_pid, p_notification_type, p_source_name, v_share, p_glory_total,
                    p_actor_name, p_actor_rank, p_color_code, p_extra_data);
        END LOOP;
        
        CLOSE member_cursor;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_party_glory_complete
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_party_glory_complete`;
delimiter ;;
CREATE PROCEDURE `sp_party_glory_complete`(IN p_actor_id INT,
    IN p_actor_name VARCHAR(50),
    IN p_base_glory INT,
    IN p_source_type VARCHAR(30),
    IN p_source_name VARCHAR(100),
    IN p_color_code VARCHAR(20),
    IN p_extra_data VARCHAR(255))
BEGIN
    DECLARE v_party_id INT DEFAULT 0;
    DECLARE v_total_power INT DEFAULT 0;
    DECLARE v_actor_rank VARCHAR(10) DEFAULT 'E';
    DECLARE v_actor_points INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_pid INT;
    DECLARE v_pname VARCHAR(50);
    DECLARE v_points INT;
    DECLARE v_power INT;
    DECLARE v_share INT;
    DECLARE v_member_count INT DEFAULT 0;
    
    DECLARE member_cursor CURSOR FOR
        SELECT p.id, p.name, COALESCE(r.total_points, 0) as points
        FROM player.player p
        LEFT JOIN srv1_hunabku.hunter_quest_ranking r ON p.id = r.player_id
        WHERE p.pid = v_party_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Ottieni rank dell'attore
    SELECT COALESCE(total_points, 0) INTO v_actor_points
    FROM srv1_hunabku.hunter_quest_ranking
    WHERE player_id = p_actor_id;
    
    SET v_actor_rank = CASE 
        WHEN v_actor_points >= 100000 THEN 'N'
        WHEN v_actor_points >= 50000 THEN 'S'
        WHEN v_actor_points >= 20000 THEN 'A'
        WHEN v_actor_points >= 8000 THEN 'B'
        WHEN v_actor_points >= 3000 THEN 'C'
        WHEN v_actor_points >= 500 THEN 'D'
        ELSE 'E'
    END;
    
    -- Trova il party_id
    SELECT pid INTO v_party_id 
    FROM player.player 
    WHERE id = p_actor_id;
    
    -- === SOLO PLAYER (no party) ===
    IF v_party_id IS NULL OR v_party_id = 0 THEN
        -- Assegna gloria
        UPDATE srv1_hunabku.hunter_quest_ranking 
        SET total_points = total_points + p_base_glory,
            spendable_points = spendable_points + p_base_glory
        WHERE player_id = p_actor_id;
        
        -- Crea notifica
        INSERT INTO srv1_hunabku.hunter_party_notifications 
            (player_id, notification_type, source_name, glory_received, glory_total, 
             actor_name, actor_rank, color_code, extra_data)
        VALUES (p_actor_id, p_source_type, p_source_name, p_base_glory, p_base_glory,
                p_actor_name, v_actor_rank, p_color_code, p_extra_data);
        
        SELECT 1 AS members_rewarded, p_base_glory AS glory_each, v_actor_rank AS actor_rank;
    
    -- === PARTY MODE ===
    ELSE
        -- Calcola power totale
        SELECT SUM(
            CASE 
                WHEN COALESCE(r.total_points, 0) >= 100000 THEN 250
                WHEN COALESCE(r.total_points, 0) >= 50000 THEN 150
                WHEN COALESCE(r.total_points, 0) >= 20000 THEN 80
                WHEN COALESCE(r.total_points, 0) >= 8000 THEN 40
                WHEN COALESCE(r.total_points, 0) >= 3000 THEN 15
                WHEN COALESCE(r.total_points, 0) >= 500 THEN 5
                ELSE 1
            END
        ) INTO v_total_power
        FROM player.player p
        LEFT JOIN srv1_hunabku.hunter_quest_ranking r ON p.id = r.player_id
        WHERE p.pid = v_party_id;
        
        IF v_total_power < 1 THEN SET v_total_power = 1; END IF;
        
        -- Itera e distribuisci + notifica
        OPEN member_cursor;
        
        party_loop: LOOP
            FETCH member_cursor INTO v_pid, v_pname, v_points;
            IF done THEN
                LEAVE party_loop;
            END IF;
            
            -- Power di questo membro
            SET v_power = CASE 
                WHEN v_points >= 100000 THEN 250
                WHEN v_points >= 50000 THEN 150
                WHEN v_points >= 20000 THEN 80
                WHEN v_points >= 8000 THEN 40
                WHEN v_points >= 3000 THEN 15
                WHEN v_points >= 500 THEN 5
                ELSE 1
            END;
            
            -- Quota gloria
            SET v_share = FLOOR((v_power * p_base_glory) / v_total_power);
            IF v_share < 1 THEN SET v_share = 1; END IF;
            
            -- Assegna gloria
            INSERT INTO srv1_hunabku.hunter_quest_ranking 
                (player_id, player_name, total_points, spendable_points)
            VALUES (v_pid, v_pname, v_share, v_share)
            ON DUPLICATE KEY UPDATE
                total_points = total_points + v_share,
                spendable_points = spendable_points + v_share;
            
            -- Crea notifica
            INSERT INTO srv1_hunabku.hunter_party_notifications 
                (player_id, notification_type, source_name, glory_received, glory_total, 
                 actor_name, actor_rank, color_code, extra_data)
            VALUES (v_pid, p_source_type, p_source_name, v_share, p_base_glory,
                    p_actor_name, v_actor_rank, p_color_code, p_extra_data);
            
            -- Log storico
            INSERT INTO srv1_hunabku.hunter_pending_rewards 
                (player_id, player_name, glory_amount, source_type, source_name, 
                 opener_id, opener_name, claimed, claimed_at)
            VALUES (v_pid, v_pname, v_share, p_source_type, p_source_name, 
                    p_actor_id, p_actor_name, 1, NOW());
            
            SET v_member_count = v_member_count + 1;
        END LOOP;
        
        CLOSE member_cursor;
        
        SELECT v_member_count AS members_rewarded, p_base_glory AS total_glory, v_actor_rank AS actor_rank;
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
    DECLARE v_existing_status VARCHAR(20);

    -- Trova la prova disponibile per il rank attuale
    SELECT trial_id, trial_name, required_gloria, required_level, time_limit_hours
    INTO p_trial_id, p_trial_name, v_required_gloria, v_required_level, v_time_limit
    FROM hunter_rank_trials
    WHERE from_rank = p_current_rank AND enabled = 1
    LIMIT 1;
    
    IF p_trial_id IS NULL THEN
        SET p_success = 0;
        SET p_message = 'Nessuna prova disponibile per il tuo rank.';
    ELSE
        -- Controlla se il giocatore ha GIA' una riga per questa prova
        SELECT status INTO v_existing_status
        FROM hunter_player_trials
        WHERE player_id = p_player_id AND trial_id = p_trial_id;
        
        -- Se la prova è già in corso o completata, non fare nulla e esci
        IF v_existing_status = 'in_progress' OR v_existing_status = 'completed' THEN
            SET p_success = 0;
            SET p_message = 'Prova già in corso o completata.';
        ELSE
            -- Controlla i requisiti solo se la prova non è attiva
            SELECT total_points INTO v_player_gloria FROM hunter_quest_ranking WHERE player_id = p_player_id;
            
            -- Ottieni il livello del giocatore (questo richiede un modo per passarlo o assumerlo)
            -- Per ora, omettiamo il controllo del livello qui e lo lasciamo alla quest LUA
            
            IF v_player_gloria < v_required_gloria THEN
                SET p_success = 0;
                SET p_message = CONCAT('Gloria insufficiente. Richiesti: ', v_required_gloria);
            ELSE
                -- INIZIA LA PROVA: Usa INSERT IGNORE per creare la riga solo se non esiste.
                -- Se esiste (ma è 'failed' o altro), l'UPDATE successivo la resetterà.
                
                INSERT INTO hunter_player_trials (player_id, trial_id, status, started_at, expires_at, boss_kills, metin_kills, fracture_seals, chest_opens, daily_missions)
                VALUES (p_player_id, p_trial_id, 'in_progress', NOW(), 
                        IF(v_time_limit IS NOT NULL, DATE_ADD(NOW(), INTERVAL v_time_limit HOUR), NULL),
                        0, 0, 0, 0, 0)
                ON DUPLICATE KEY UPDATE 
                    status = 'in_progress', 
                    started_at = NOW(),
                    expires_at = IF(v_time_limit IS NOT NULL, DATE_ADD(NOW(), INTERVAL v_time_limit HOUR), NULL),
                    boss_kills = 0, 
                    metin_kills = 0, 
                    fracture_seals = 0, 
                    chest_opens = 0, 
                    daily_missions = 0;

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
-- Event structure for evt_expire_trials
-- ----------------------------
DROP EVENT IF EXISTS `evt_expire_trials`;
delimiter ;;
CREATE EVENT `evt_expire_trials`
ON SCHEDULE
EVERY '1' HOUR STARTS '2025-12-29 15:17:44'
DO BEGIN
    UPDATE hunter_player_trials 
    SET status = 'expired' 
    WHERE status = 'in_progress' 
    AND expires_at < NOW();
    
    DELETE FROM hunter_player_missions 
    WHERE assigned_date < CURDATE() - INTERVAL 7 DAY;
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
-- Event structure for evt_hunter_log_cleanup
-- ----------------------------
DROP EVENT IF EXISTS `evt_hunter_log_cleanup`;
delimiter ;;
CREATE EVENT `evt_hunter_log_cleanup`
ON SCHEDULE
EVERY '1' WEEK STARTS '2026-01-07 04:00:00'
DO CALL sp_hunter_log_cleanup()
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


-- ============================================================
-- TRANSLATION SYSTEM TABLES
-- Multi-language support for Hunter Terminal
-- ============================================================

-- ----------------------------
-- Table: hunter_translations
-- ----------------------------
DROP TABLE IF EXISTS `hunter_translations`;
CREATE TABLE `hunter_translations` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `translation_key` VARCHAR(100) NOT NULL,
    `lang_code` VARCHAR(5) NOT NULL,
    `text_value` TEXT NOT NULL,
    `color_code` VARCHAR(10) DEFAULT NULL,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_key_lang` (`translation_key` ASC, `lang_code` ASC) USING BTREE,
    INDEX `idx_lang` (`lang_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table: hunter_player_settings
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
-- ----------------------------
DROP TABLE IF EXISTS `hunter_languages`;
CREATE TABLE `hunter_languages` (
    `lang_code` VARCHAR(5) NOT NULL,
    `lang_name` VARCHAR(50) NOT NULL,
    `lang_name_en` VARCHAR(50) NOT NULL,
    `flag_icon` VARCHAR(20) DEFAULT NULL,
    `display_order` INT NOT NULL DEFAULT 0,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`lang_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Languages data
-- ----------------------------
INSERT INTO `hunter_languages` VALUES ('it', 'Italiano', 'Italian', 'flag_it', 1, 1);
INSERT INTO `hunter_languages` VALUES ('en', 'English', 'English', 'flag_en', 2, 1);
INSERT INTO `hunter_languages` VALUES ('de', 'Deutsch', 'German', 'flag_de', 3, 1);
INSERT INTO `hunter_languages` VALUES ('es', 'Espanol', 'Spanish', 'flag_es', 4, 1);
INSERT INTO `hunter_languages` VALUES ('fr', 'Francais', 'French', 'flag_fr', 5, 1);
INSERT INTO `hunter_languages` VALUES ('pt', 'Portugues', 'Portuguese', 'flag_pt', 6, 1);

-- ============================================================
-- TRANSLATIONS DATA (6 Languages)
-- ============================================================

-- ═══════════════════════════════════════════════════════════════════════════════
-- UI TABS
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('UI_TAB_STATS', 'it', 'Stats'),
('UI_TAB_STATS', 'en', 'Stats'),
('UI_TAB_STATS', 'de', 'Stats'),
('UI_TAB_STATS', 'es', 'Stats'),
('UI_TAB_STATS', 'fr', 'Stats'),
('UI_TAB_STATS', 'pt', 'Stats'),

('UI_TAB_RANK', 'it', 'Rank'),
('UI_TAB_RANK', 'en', 'Rank'),
('UI_TAB_RANK', 'de', 'Rang'),
('UI_TAB_RANK', 'es', 'Rango'),
('UI_TAB_RANK', 'fr', 'Rang'),
('UI_TAB_RANK', 'pt', 'Rank'),

('UI_TAB_SHOP', 'it', 'Shop'),
('UI_TAB_SHOP', 'en', 'Shop'),
('UI_TAB_SHOP', 'de', 'Shop'),
('UI_TAB_SHOP', 'es', 'Tienda'),
('UI_TAB_SHOP', 'fr', 'Boutique'),
('UI_TAB_SHOP', 'pt', 'Loja'),

('UI_TAB_ACHIEV', 'it', 'Achiev'),
('UI_TAB_ACHIEV', 'en', 'Achiev'),
('UI_TAB_ACHIEV', 'de', 'Erfolge'),
('UI_TAB_ACHIEV', 'es', 'Logros'),
('UI_TAB_ACHIEV', 'fr', 'Succès'),
('UI_TAB_ACHIEV', 'pt', 'Conquistas'),

('UI_TAB_EVENTS', 'it', 'Eventi'),
('UI_TAB_EVENTS', 'en', 'Events'),
('UI_TAB_EVENTS', 'de', 'Events'),
('UI_TAB_EVENTS', 'es', 'Eventos'),
('UI_TAB_EVENTS', 'fr', 'Événements'),
('UI_TAB_EVENTS', 'pt', 'Eventos'),

('UI_TAB_GUIDE', 'it', 'Guida'),
('UI_TAB_GUIDE', 'en', 'Guide'),
('UI_TAB_GUIDE', 'de', 'Anleitung'),
('UI_TAB_GUIDE', 'es', 'Guía'),
('UI_TAB_GUIDE', 'fr', 'Guide'),
('UI_TAB_GUIDE', 'pt', 'Guia')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- STATS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('STATS_TITLE', 'it', 'STATISTICHE PERSONALI'),
('STATS_TITLE', 'en', 'PERSONAL STATISTICS'),
('STATS_TITLE', 'de', 'PERSÖNLICHE STATISTIKEN'),
('STATS_TITLE', 'es', 'ESTADÍSTICAS PERSONALES'),
('STATS_TITLE', 'fr', 'STATISTIQUES PERSONNELLES'),
('STATS_TITLE', 'pt', 'ESTATÍSTICAS PESSOAIS'),

('STATS_RANK', 'it', 'Rango:'),
('STATS_RANK', 'en', 'Rank:'),
('STATS_RANK', 'de', 'Rang:'),
('STATS_RANK', 'es', 'Rango:'),
('STATS_RANK', 'fr', 'Rang:'),
('STATS_RANK', 'pt', 'Rank:'),

('STATS_PROGRESS', 'it', 'Progresso:'),
('STATS_PROGRESS', 'en', 'Progress:'),
('STATS_PROGRESS', 'de', 'Fortschritt:'),
('STATS_PROGRESS', 'es', 'Progreso:'),
('STATS_PROGRESS', 'fr', 'Progression:'),
('STATS_PROGRESS', 'pt', 'Progresso:'),

('STATS_REWARDS_AVAILABLE', 'it', 'Ricompense disponibili:'),
('STATS_REWARDS_AVAILABLE', 'en', 'Available rewards:'),
('STATS_REWARDS_AVAILABLE', 'de', 'Verfügbare Belohnungen:'),
('STATS_REWARDS_AVAILABLE', 'es', 'Recompensas disponibles:'),
('STATS_REWARDS_AVAILABLE', 'fr', 'Récompenses disponibles:'),
('STATS_REWARDS_AVAILABLE', 'pt', 'Recompensas disponíveis:'),

('BTN_CLAIM', 'it', 'Riscuoti'),
('BTN_CLAIM', 'en', 'Claim'),
('BTN_CLAIM', 'de', 'Einlösen'),
('BTN_CLAIM', 'es', 'Reclamar'),
('BTN_CLAIM', 'fr', 'Récupérer'),
('BTN_CLAIM', 'pt', 'Resgatar'),

('STATS_TODAY', 'it', 'OGGI'),
('STATS_TODAY', 'en', 'TODAY'),
('STATS_TODAY', 'de', 'HEUTE'),
('STATS_TODAY', 'es', 'HOY'),
('STATS_TODAY', 'fr', 'AUJOURD''HUI'),
('STATS_TODAY', 'pt', 'HOJE'),

('STATS_TOTAL', 'it', 'TOTALE'),
('STATS_TOTAL', 'en', 'TOTAL'),
('STATS_TOTAL', 'de', 'GESAMT'),
('STATS_TOTAL', 'es', 'TOTAL'),
('STATS_TOTAL', 'fr', 'TOTAL'),
('STATS_TOTAL', 'pt', 'TOTAL'),

('STATS_KILLS', 'it', 'Kills:'),
('STATS_KILLS', 'en', 'Kills:'),
('STATS_KILLS', 'de', 'Kills:'),
('STATS_KILLS', 'es', 'Asesinatos:'),
('STATS_KILLS', 'fr', 'Éliminations:'),
('STATS_KILLS', 'pt', 'Abates:'),

('STATS_GLORY', 'it', 'Gloria:'),
('STATS_GLORY', 'en', 'Glory:'),
('STATS_GLORY', 'de', 'Ruhm:'),
('STATS_GLORY', 'es', 'Gloria:'),
('STATS_GLORY', 'fr', 'Gloire:'),
('STATS_GLORY', 'pt', 'Glória:'),

('STATS_ECONOMY', 'it', 'ECONOMIA'),
('STATS_ECONOMY', 'en', 'ECONOMY'),
('STATS_ECONOMY', 'de', 'WIRTSCHAFT'),
('STATS_ECONOMY', 'es', 'ECONOMÍA'),
('STATS_ECONOMY', 'fr', 'ÉCONOMIE'),
('STATS_ECONOMY', 'pt', 'ECONOMIA'),

('STATS_SPENDABLE', 'it', 'Spendibile:'),
('STATS_SPENDABLE', 'en', 'Spendable:'),
('STATS_SPENDABLE', 'de', 'Ausgaben:'),
('STATS_SPENDABLE', 'es', 'Disponible:'),
('STATS_SPENDABLE', 'fr', 'Dépensable:'),
('STATS_SPENDABLE', 'pt', 'Gastável:'),

('STATS_RECORDS', 'it', 'RECORD'),
('STATS_RECORDS', 'en', 'RECORDS'),
('STATS_RECORDS', 'de', 'REKORDE'),
('STATS_RECORDS', 'es', 'RÉCORDS'),
('STATS_RECORDS', 'fr', 'RECORDS'),
('STATS_RECORDS', 'pt', 'RECORDES'),

('STATS_FRACTURES', 'it', 'Fratture:'),
('STATS_FRACTURES', 'en', 'Fractures:'),
('STATS_FRACTURES', 'de', 'Brüche:'),
('STATS_FRACTURES', 'es', 'Fracturas:'),
('STATS_FRACTURES', 'fr', 'Fractures:'),
('STATS_FRACTURES', 'pt', 'Fraturas:'),

('STATS_CHESTS', 'it', 'Bauli:'),
('STATS_CHESTS', 'en', 'Chests:'),
('STATS_CHESTS', 'de', 'Truhen:'),
('STATS_CHESTS', 'es', 'Cofres:'),
('STATS_CHESTS', 'fr', 'Coffres:'),
('STATS_CHESTS', 'pt', 'Baús:')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- SHOP TAB
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('SHOP_TITLE', 'it', '[ MERCANTE HUNTER ]'),
('SHOP_TITLE', 'en', '[ HUNTER MERCHANT ]'),
('SHOP_TITLE', 'de', '[ JÄGER HÄNDLER ]'),
('SHOP_TITLE', 'es', '[ MERCADER CAZADOR ]'),
('SHOP_TITLE', 'fr', '[ MARCHAND CHASSEUR ]'),
('SHOP_TITLE', 'pt', '[ MERCADOR CAÇADOR ]'),

('SHOP_GLORY_AVAILABLE', 'it', 'Gloria disponibile:'),
('SHOP_GLORY_AVAILABLE', 'en', 'Available Glory:'),
('SHOP_GLORY_AVAILABLE', 'de', 'Verfügbarer Ruhm:'),
('SHOP_GLORY_AVAILABLE', 'es', 'Gloria disponible:'),
('SHOP_GLORY_AVAILABLE', 'fr', 'Gloire disponible:'),
('SHOP_GLORY_AVAILABLE', 'pt', 'Glória disponível:'),

('SHOP_EMPTY', 'it', 'Negozio vuoto.'),
('SHOP_EMPTY', 'en', 'Shop empty.'),
('SHOP_EMPTY', 'de', 'Laden leer.'),
('SHOP_EMPTY', 'es', 'Tienda vacía.'),
('SHOP_EMPTY', 'fr', 'Boutique vide.'),
('SHOP_EMPTY', 'pt', 'Loja vazia.'),

('SHOP_PRICE', 'it', 'Prezzo:'),
('SHOP_PRICE', 'en', 'Price:'),
('SHOP_PRICE', 'de', 'Preis:'),
('SHOP_PRICE', 'es', 'Precio:'),
('SHOP_PRICE', 'fr', 'Prix:'),
('SHOP_PRICE', 'pt', 'Preço:'),

('GLORY', 'it', 'Gloria'),
('GLORY', 'en', 'Glory'),
('GLORY', 'de', 'Ruhm'),
('GLORY', 'es', 'Gloria'),
('GLORY', 'fr', 'Gloire'),
('GLORY', 'pt', 'Glória'),

('BTN_BUY', 'it', 'Acquista'),
('BTN_BUY', 'en', 'Buy'),
('BTN_BUY', 'de', 'Kaufen'),
('BTN_BUY', 'es', 'Comprar'),
('BTN_BUY', 'fr', 'Acheter'),
('BTN_BUY', 'pt', 'Comprar')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- RANKING TAB
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('RANK_TITLE', 'it', 'SALA DELLE LEGGENDE'),
('RANK_TITLE', 'en', 'HALL OF LEGENDS'),
('RANK_TITLE', 'de', 'HALLE DER LEGENDEN'),
('RANK_TITLE', 'es', 'SALA DE LEYENDAS'),
('RANK_TITLE', 'fr', 'SALLE DES LÉGENDES'),
('RANK_TITLE', 'pt', 'SALÃO DAS LENDAS'),

('RANK_PERIOD', 'it', 'Periodo:'),
('RANK_PERIOD', 'en', 'Period:'),
('RANK_PERIOD', 'de', 'Zeitraum:'),
('RANK_PERIOD', 'es', 'Período:'),
('RANK_PERIOD', 'fr', 'Période:'),
('RANK_PERIOD', 'pt', 'Período:'),

('RANK_TODAY', 'it', 'Oggi'),
('RANK_TODAY', 'en', 'Today'),
('RANK_TODAY', 'de', 'Heute'),
('RANK_TODAY', 'es', 'Hoy'),
('RANK_TODAY', 'fr', 'Aujourd''hui'),
('RANK_TODAY', 'pt', 'Hoje'),

('RANK_WEEK', 'it', 'Settimana'),
('RANK_WEEK', 'en', 'Week'),
('RANK_WEEK', 'de', 'Woche'),
('RANK_WEEK', 'es', 'Semana'),
('RANK_WEEK', 'fr', 'Semaine'),
('RANK_WEEK', 'pt', 'Semana'),

('RANK_ALWAYS', 'it', 'Sempre'),
('RANK_ALWAYS', 'en', 'Always'),
('RANK_ALWAYS', 'de', 'Immer'),
('RANK_ALWAYS', 'es', 'Siempre'),
('RANK_ALWAYS', 'fr', 'Toujours'),
('RANK_ALWAYS', 'pt', 'Sempre'),

('RANK_TYPE', 'it', 'Tipo:'),
('RANK_TYPE', 'en', 'Type:'),
('RANK_TYPE', 'de', 'Typ:'),
('RANK_TYPE', 'es', 'Tipo:'),
('RANK_TYPE', 'fr', 'Type:'),
('RANK_TYPE', 'pt', 'Tipo:'),

('FRACTURES', 'it', 'Fratture'),
('FRACTURES', 'en', 'Fractures'),
('FRACTURES', 'de', 'Brüche'),
('FRACTURES', 'es', 'Fracturas'),
('FRACTURES', 'fr', 'Fractures'),
('FRACTURES', 'pt', 'Fraturas'),

('CHESTS', 'it', 'Bauli'),
('CHESTS', 'en', 'Chests'),
('CHESTS', 'de', 'Truhen'),
('CHESTS', 'es', 'Cofres'),
('CHESTS', 'fr', 'Coffres'),
('CHESTS', 'pt', 'Baús'),

('RANK_YOU', 'it', 'TU:'),
('RANK_YOU', 'en', 'YOU:'),
('RANK_YOU', 'de', 'DU:'),
('RANK_YOU', 'es', 'TÚ:'),
('RANK_YOU', 'fr', 'VOUS:'),
('RANK_YOU', 'pt', 'VOCÊ:'),

('RANK_NO_DATA', 'it', 'Nessun dato disponibile.'),
('RANK_NO_DATA', 'en', 'No data available.'),
('RANK_NO_DATA', 'de', 'Keine Daten verfügbar.'),
('RANK_NO_DATA', 'es', 'No hay datos disponibles.'),
('RANK_NO_DATA', 'fr', 'Aucune donnée disponible.'),
('RANK_NO_DATA', 'pt', 'Nenhum dado disponível.'),

('RANK_PLAY_TO_CLIMB', 'it', 'Gioca per scalare la classifica!'),
('RANK_PLAY_TO_CLIMB', 'en', 'Play to climb the ranking!'),
('RANK_PLAY_TO_CLIMB', 'de', 'Spiele, um aufzusteigen!'),
('RANK_PLAY_TO_CLIMB', 'es', '¡Juega para subir en el ranking!'),
('RANK_PLAY_TO_CLIMB', 'fr', 'Jouez pour monter au classement!'),
('RANK_PLAY_TO_CLIMB', 'pt', 'Jogue para subir no ranking!'),

('RANK_HUNTER', 'it', 'Cacciatore'),
('RANK_HUNTER', 'en', 'Hunter'),
('RANK_HUNTER', 'de', 'Jäger'),
('RANK_HUNTER', 'es', 'Cazador'),
('RANK_HUNTER', 'fr', 'Chasseur'),
('RANK_HUNTER', 'pt', 'Caçador'),

('RANK_VALUE', 'it', 'Valore'),
('RANK_VALUE', 'en', 'Value'),
('RANK_VALUE', 'de', 'Wert'),
('RANK_VALUE', 'es', 'Valor'),
('RANK_VALUE', 'fr', 'Valeur'),
('RANK_VALUE', 'pt', 'Valor')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ACHIEVEMENTS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('ACHIEV_TITLE', 'it', 'TRAGUARDI'),
('ACHIEV_TITLE', 'en', 'ACHIEVEMENTS'),
('ACHIEV_TITLE', 'de', 'ERFOLGE'),
('ACHIEV_TITLE', 'es', 'LOGROS'),
('ACHIEV_TITLE', 'fr', 'SUCCÈS'),
('ACHIEV_TITLE', 'pt', 'CONQUISTAS'),

('ACHIEV_NONE', 'it', 'Nessun traguardo.'),
('ACHIEV_NONE', 'en', 'No achievements.'),
('ACHIEV_NONE', 'de', 'Keine Erfolge.'),
('ACHIEV_NONE', 'es', 'Sin logros.'),
('ACHIEV_NONE', 'fr', 'Aucun succès.'),
('ACHIEV_NONE', 'pt', 'Sem conquistas.'),

('BTN_CLAIM_REWARD', 'it', 'Riscuoti'),
('BTN_CLAIM_REWARD', 'en', 'Claim'),
('BTN_CLAIM_REWARD', 'de', 'Einlösen'),
('BTN_CLAIM_REWARD', 'es', 'Reclamar'),
('BTN_CLAIM_REWARD', 'fr', 'Récupérer'),
('BTN_CLAIM_REWARD', 'pt', 'Resgatar'),

('BTN_DONE', 'it', 'Fatto'),
('BTN_DONE', 'en', 'Done'),
('BTN_DONE', 'de', 'Fertig'),
('BTN_DONE', 'es', 'Hecho'),
('BTN_DONE', 'fr', 'Fait'),
('BTN_DONE', 'pt', 'Feito'),

('BTN_VIEW', 'it', 'Vedi'),
('BTN_VIEW', 'en', 'View'),
('BTN_VIEW', 'de', 'Ansehen'),
('BTN_VIEW', 'es', 'Ver'),
('BTN_VIEW', 'fr', 'Voir'),
('BTN_VIEW', 'pt', 'Ver')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- EVENTS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('MISSION_STATUS', 'it', 'Stato:'),
('MISSION_STATUS', 'en', 'Status:'),
('MISSION_STATUS', 'de', 'Status:'),
('MISSION_STATUS', 'es', 'Estado:'),
('MISSION_STATUS', 'fr', 'Statut:'),
('MISSION_STATUS', 'pt', 'Status:'),

('COMPLETE', 'it', 'complete'),
('COMPLETE', 'en', 'complete'),
('COMPLETE', 'de', 'abgeschlossen'),
('COMPLETE', 'es', 'completas'),
('COMPLETE', 'fr', 'terminées'),
('COMPLETE', 'pt', 'completas'),

('BONUS_ACTIVE', 'it', 'BONUS x1.5 ATTIVO!'),
('BONUS_ACTIVE', 'en', 'BONUS x1.5 ACTIVE!'),
('BONUS_ACTIVE', 'de', 'BONUS x1.5 AKTIV!'),
('BONUS_ACTIVE', 'es', '¡BONUS x1.5 ACTIVO!'),
('BONUS_ACTIVE', 'fr', 'BONUS x1.5 ACTIF!'),
('BONUS_ACTIVE', 'pt', 'BÔNUS x1.5 ATIVO!'),

('NO_MISSION_TODAY', 'it', 'Nessuna missione assegnata oggi.'),
('NO_MISSION_TODAY', 'en', 'No missions assigned today.'),
('NO_MISSION_TODAY', 'de', 'Heute keine Missionen zugewiesen.'),
('NO_MISSION_TODAY', 'es', 'No hay misiones asignadas hoy.'),
('NO_MISSION_TODAY', 'fr', 'Aucune mission assignée aujourd''hui.'),
('NO_MISSION_TODAY', 'pt', 'Nenhuma missão atribuída hoje.'),

('MISSION_ON_LOGIN', 'it', 'Le missioni vengono assegnate al login.'),
('MISSION_ON_LOGIN', 'en', 'Missions are assigned at login.'),
('MISSION_ON_LOGIN', 'de', 'Missionen werden beim Login zugewiesen.'),
('MISSION_ON_LOGIN', 'es', 'Las misiones se asignan al iniciar sesión.'),
('MISSION_ON_LOGIN', 'fr', 'Les missions sont assignées à la connexion.'),
('MISSION_ON_LOGIN', 'pt', 'As missões são atribuídas no login.'),

('ALL_COMPLETE', 'it', 'Tutte complete:'),
('ALL_COMPLETE', 'en', 'All complete:'),
('ALL_COMPLETE', 'de', 'Alle abgeschlossen:'),
('ALL_COMPLETE', 'es', 'Todas completas:'),
('ALL_COMPLETE', 'fr', 'Toutes terminées:'),
('ALL_COMPLETE', 'pt', 'Todas completas:'),

('BONUS_50_GLORY', 'it', '+50% Gloria Bonus!'),
('BONUS_50_GLORY', 'en', '+50% Glory Bonus!'),
('BONUS_50_GLORY', 'de', '+50% Ruhm Bonus!'),
('BONUS_50_GLORY', 'es', '+50% Bono de Gloria!'),
('BONUS_50_GLORY', 'fr', '+50% Bonus Gloire!'),
('BONUS_50_GLORY', 'pt', '+50% Bônus de Glória!'),

('NOT_COMPLETE', 'it', 'Non complete:'),
('NOT_COMPLETE', 'en', 'Not complete:'),
('NOT_COMPLETE', 'de', 'Nicht abgeschlossen:'),
('NOT_COMPLETE', 'es', 'No completas:'),
('NOT_COMPLETE', 'fr', 'Non terminées:'),
('NOT_COMPLETE', 'pt', 'Não completas:'),

('PENALTY_GLORY', 'it', 'Penalita'' Gloria'),
('PENALTY_GLORY', 'en', 'Glory Penalty'),
('PENALTY_GLORY', 'de', 'Ruhm Strafe'),
('PENALTY_GLORY', 'es', 'Penalización de Gloria'),
('PENALTY_GLORY', 'fr', 'Pénalité de Gloire'),
('PENALTY_GLORY', 'pt', 'Penalidade de Glória'),

('EVENTS_TODAY', 'it', 'EVENTI DEL GIORNO'),
('EVENTS_TODAY', 'en', 'TODAY''S EVENTS'),
('EVENTS_TODAY', 'de', 'HEUTIGE EVENTS'),
('EVENTS_TODAY', 'es', 'EVENTOS DE HOY'),
('EVENTS_TODAY', 'fr', 'ÉVÉNEMENTS DU JOUR'),
('EVENTS_TODAY', 'pt', 'EVENTOS DE HOJE'),

('BTN_OPEN_EVENTS', 'it', 'Apri Eventi'),
('BTN_OPEN_EVENTS', 'en', 'Open Events'),
('BTN_OPEN_EVENTS', 'de', 'Events öffnen'),
('BTN_OPEN_EVENTS', 'es', 'Abrir Eventos'),
('BTN_OPEN_EVENTS', 'fr', 'Ouvrir Événements'),
('BTN_OPEN_EVENTS', 'pt', 'Abrir Eventos'),

('EVENT_IN_PROGRESS', 'it', 'EVENTO IN CORSO!'),
('EVENT_IN_PROGRESS', 'en', 'EVENT IN PROGRESS!'),
('EVENT_IN_PROGRESS', 'de', 'EVENT LÄUFT!'),
('EVENT_IN_PROGRESS', 'es', '¡EVENTO EN CURSO!'),
('EVENT_IN_PROGRESS', 'fr', 'ÉVÉNEMENT EN COURS!'),
('EVENT_IN_PROGRESS', 'pt', 'EVENTO EM ANDAMENTO!'),

('NO_ACTIVE_EVENT', 'it', 'Nessun evento attivo al momento'),
('NO_ACTIVE_EVENT', 'en', 'No active event at the moment'),
('NO_ACTIVE_EVENT', 'de', 'Momentan kein aktives Event'),
('NO_ACTIVE_EVENT', 'es', 'No hay evento activo en este momento'),
('NO_ACTIVE_EVENT', 'fr', 'Aucun événement actif actuellement'),
('NO_ACTIVE_EVENT', 'pt', 'Nenhum evento ativo no momento'),

('SCHEDULED_EVENTS_TODAY', 'it', 'Eventi Programmati Oggi:'),
('SCHEDULED_EVENTS_TODAY', 'en', 'Scheduled Events Today:'),
('SCHEDULED_EVENTS_TODAY', 'de', 'Geplante Events Heute:'),
('SCHEDULED_EVENTS_TODAY', 'es', 'Eventos Programados Hoy:'),
('SCHEDULED_EVENTS_TODAY', 'fr', 'Événements Programmés Aujourd''hui:'),
('SCHEDULED_EVENTS_TODAY', 'pt', 'Eventos Programados Hoje:'),

('NO_SCHEDULED_EVENT', 'it', 'Nessun evento programmato oggi.'),
('NO_SCHEDULED_EVENT', 'en', 'No scheduled events today.'),
('NO_SCHEDULED_EVENT', 'de', 'Keine geplanten Events heute.'),
('NO_SCHEDULED_EVENT', 'es', 'No hay eventos programados hoy.'),
('NO_SCHEDULED_EVENT', 'fr', 'Aucun événement programmé aujourd''hui.'),
('NO_SCHEDULED_EVENT', 'pt', 'Nenhum evento programado hoje.'),

('COL_STATUS', 'it', 'Stato'),
('COL_STATUS', 'en', 'Status'),
('COL_STATUS', 'de', 'Status'),
('COL_STATUS', 'es', 'Estado'),
('COL_STATUS', 'fr', 'Statut'),
('COL_STATUS', 'pt', 'Status'),

('COL_EVENT', 'it', 'Evento'),
('COL_EVENT', 'en', 'Event'),
('COL_EVENT', 'de', 'Event'),
('COL_EVENT', 'es', 'Evento'),
('COL_EVENT', 'fr', 'Événement'),
('COL_EVENT', 'pt', 'Evento'),

('COL_TIME', 'it', 'Orario'),
('COL_TIME', 'en', 'Time'),
('COL_TIME', 'de', 'Zeit'),
('COL_TIME', 'es', 'Hora'),
('COL_TIME', 'fr', 'Heure'),
('COL_TIME', 'pt', 'Horário'),

('MORE_EVENTS', 'it', '... e altri %d eventi (clicca ''Apri Eventi'')'),
('MORE_EVENTS', 'en', '... and %d more events (click ''Open Events'')'),
('MORE_EVENTS', 'de', '... und %d weitere Events (klicke ''Events öffnen'')'),
('MORE_EVENTS', 'es', '... y %d eventos más (haz clic en ''Abrir Eventos'')'),
('MORE_EVENTS', 'fr', '... et %d autres événements (cliquez ''Ouvrir Événements'')'),
('MORE_EVENTS', 'pt', '... e mais %d eventos (clique ''Abrir Eventos'')'),

('RESET_TIMES', 'it', 'ORARI RESET:'),
('RESET_TIMES', 'en', 'RESET TIMES:'),
('RESET_TIMES', 'de', 'RESET-ZEITEN:'),
('RESET_TIMES', 'es', 'HORARIOS DE REINICIO:'),
('RESET_TIMES', 'fr', 'HEURES DE RÉINITIALISATION:'),
('RESET_TIMES', 'pt', 'HORÁRIOS DE RESET:'),

('RESET_MISSIONS', 'it', 'Missioni: Ogni giorno alle 00:05'),
('RESET_MISSIONS', 'en', 'Missions: Every day at 00:05'),
('RESET_MISSIONS', 'de', 'Missionen: Täglich um 00:05'),
('RESET_MISSIONS', 'es', 'Misiones: Cada día a las 00:05'),
('RESET_MISSIONS', 'fr', 'Missions: Tous les jours à 00h05'),
('RESET_MISSIONS', 'pt', 'Missões: Todo dia às 00:05'),

('RESET_EVENTS', 'it', 'Eventi: In base al calendario'),
('RESET_EVENTS', 'en', 'Events: Based on calendar'),
('RESET_EVENTS', 'de', 'Events: Nach Kalender'),
('RESET_EVENTS', 'es', 'Eventos: Según el calendario'),
('RESET_EVENTS', 'fr', 'Événements: Selon le calendrier'),
('RESET_EVENTS', 'pt', 'Eventos: Conforme o calendário')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- GUIDE - RANKS
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('RANK_E_NAME', 'it', 'Risvegliato'),
('RANK_E_NAME', 'en', 'Awakened'),
('RANK_E_NAME', 'de', 'Erwachter'),
('RANK_E_NAME', 'es', 'Despertado'),
('RANK_E_NAME', 'fr', 'Éveillé'),
('RANK_E_NAME', 'pt', 'Despertado'),

('RANK_E_DESC', 'it', 'Hai appena scoperto i tuoi poteri.'),
('RANK_E_DESC', 'en', 'You have just discovered your powers.'),
('RANK_E_DESC', 'de', 'Du hast gerade deine Kräfte entdeckt.'),
('RANK_E_DESC', 'es', 'Acabas de descubrir tus poderes.'),
('RANK_E_DESC', 'fr', 'Vous venez de découvrir vos pouvoirs.'),
('RANK_E_DESC', 'pt', 'Você acabou de descobrir seus poderes.'),

('RANK_D_NAME', 'it', 'Apprendista'),
('RANK_D_NAME', 'en', 'Apprentice'),
('RANK_D_NAME', 'de', 'Lehrling'),
('RANK_D_NAME', 'es', 'Aprendiz'),
('RANK_D_NAME', 'fr', 'Apprenti'),
('RANK_D_NAME', 'pt', 'Aprendiz'),

('RANK_D_DESC', 'it', 'Inizi a padroneggiare le basi.'),
('RANK_D_DESC', 'en', 'You are starting to master the basics.'),
('RANK_D_DESC', 'de', 'Du beginnst die Grundlagen zu beherrschen.'),
('RANK_D_DESC', 'es', 'Empiezas a dominar los fundamentos.'),
('RANK_D_DESC', 'fr', 'Vous commencez à maîtriser les bases.'),
('RANK_D_DESC', 'pt', 'Você está começando a dominar o básico.'),

('RANK_C_NAME', 'it', 'Cacciatore'),
('RANK_C_NAME', 'en', 'Hunter'),
('RANK_C_NAME', 'de', 'Jäger'),
('RANK_C_NAME', 'es', 'Cazador'),
('RANK_C_NAME', 'fr', 'Chasseur'),
('RANK_C_NAME', 'pt', 'Caçador'),

('RANK_C_DESC', 'it', 'Sei un vero Cacciatore ora.'),
('RANK_C_DESC', 'en', 'You are a true Hunter now.'),
('RANK_C_DESC', 'de', 'Du bist jetzt ein echter Jäger.'),
('RANK_C_DESC', 'es', 'Ahora eres un verdadero Cazador.'),
('RANK_C_DESC', 'fr', 'Vous êtes un vrai Chasseur maintenant.'),
('RANK_C_DESC', 'pt', 'Você é um verdadeiro Caçador agora.'),

('RANK_B_NAME', 'it', 'Veterano'),
('RANK_B_NAME', 'en', 'Veteran'),
('RANK_B_NAME', 'de', 'Veteran'),
('RANK_B_NAME', 'es', 'Veterano'),
('RANK_B_NAME', 'fr', 'Vétéran'),
('RANK_B_NAME', 'pt', 'Veterano'),

('RANK_B_DESC', 'it', 'I mostri tremano al tuo passaggio.'),
('RANK_B_DESC', 'en', 'Monsters tremble at your passage.'),
('RANK_B_DESC', 'de', 'Monster zittern bei deinem Vorbeigehen.'),
('RANK_B_DESC', 'es', 'Los monstruos tiemblan a tu paso.'),
('RANK_B_DESC', 'fr', 'Les monstres tremblent à votre passage.'),
('RANK_B_DESC', 'pt', 'Os monstros tremem com sua passagem.'),

('RANK_A_NAME', 'it', 'Maestro'),
('RANK_A_NAME', 'en', 'Master'),
('RANK_A_NAME', 'de', 'Meister'),
('RANK_A_NAME', 'es', 'Maestro'),
('RANK_A_NAME', 'fr', 'Maître'),
('RANK_A_NAME', 'pt', 'Mestre'),

('RANK_A_DESC', 'it', 'Solo i migliori arrivano qui.'),
('RANK_A_DESC', 'en', 'Only the best reach here.'),
('RANK_A_DESC', 'de', 'Nur die Besten kommen hierher.'),
('RANK_A_DESC', 'es', 'Solo los mejores llegan aquí.'),
('RANK_A_DESC', 'fr', 'Seuls les meilleurs arrivent ici.'),
('RANK_A_DESC', 'pt', 'Apenas os melhores chegam aqui.'),

('RANK_S_NAME', 'it', 'Leggenda'),
('RANK_S_NAME', 'en', 'Legend'),
('RANK_S_NAME', 'de', 'Legende'),
('RANK_S_NAME', 'es', 'Leyenda'),
('RANK_S_NAME', 'fr', 'Légende'),
('RANK_S_NAME', 'pt', 'Lenda'),

('RANK_S_DESC', 'it', 'Il tuo nome e'' conosciuto ovunque.'),
('RANK_S_DESC', 'en', 'Your name is known everywhere.'),
('RANK_S_DESC', 'de', 'Dein Name ist überall bekannt.'),
('RANK_S_DESC', 'es', 'Tu nombre es conocido en todas partes.'),
('RANK_S_DESC', 'fr', 'Votre nom est connu partout.'),
('RANK_S_DESC', 'pt', 'Seu nome é conhecido em todo lugar.'),

('RANK_N_NAME', 'it', 'Monarca Nazionale'),
('RANK_N_NAME', 'en', 'National Monarch'),
('RANK_N_NAME', 'de', 'Nationaler Monarch'),
('RANK_N_NAME', 'es', 'Monarca Nacional'),
('RANK_N_NAME', 'fr', 'Monarque National'),
('RANK_N_NAME', 'pt', 'Monarca Nacional'),

('RANK_N_DESC', 'it', 'Hai raggiunto l''apice del potere!'),
('RANK_N_DESC', 'en', 'You have reached the pinnacle of power!'),
('RANK_N_DESC', 'de', 'Du hast den Gipfel der Macht erreicht!'),
('RANK_N_DESC', 'es', '¡Has alcanzado la cima del poder!'),
('RANK_N_DESC', 'fr', 'Vous avez atteint le sommet du pouvoir!'),
('RANK_N_DESC', 'pt', 'Você alcançou o auge do poder!')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- GUIDE - GLORY
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('GUIDE_GLORY_TITLE', 'it', 'COME GUADAGNARE GLORIA'),
('GUIDE_GLORY_TITLE', 'en', 'HOW TO EARN GLORY'),
('GUIDE_GLORY_TITLE', 'de', 'WIE MAN RUHM VERDIENT'),
('GUIDE_GLORY_TITLE', 'es', 'CÓMO GANAR GLORIA'),
('GUIDE_GLORY_TITLE', 'fr', 'COMMENT GAGNER DE LA GLOIRE'),
('GUIDE_GLORY_TITLE', 'pt', 'COMO GANHAR GLÓRIA'),

('WARNING', 'it', 'ATTENZIONE!'),
('WARNING', 'en', 'WARNING!'),
('WARNING', 'de', 'ACHTUNG!'),
('WARNING', 'es', '¡ATENCIÓN!'),
('WARNING', 'fr', 'ATTENTION!'),
('WARNING', 'pt', 'ATENÇÃO!'),

('GLORY_WARNING1', 'it', 'I mostri, metin e boss NORMALI NON danno Gloria!'),
('GLORY_WARNING1', 'en', 'NORMAL monsters, metins and bosses do NOT give Glory!'),
('GLORY_WARNING1', 'de', 'NORMALE Monster, Metins und Bosse geben KEINEN Ruhm!'),
('GLORY_WARNING1', 'es', '¡Los monstruos, metins y jefes NORMALES NO dan Gloria!'),
('GLORY_WARNING1', 'fr', 'Les monstres, métins et boss NORMAUX ne donnent PAS de Gloire!'),
('GLORY_WARNING1', 'pt', 'Monstros, metins e chefes NORMAIS NÃO dão Glória!'),

('GLORY_WARNING2', 'it', 'Ottieni Gloria SOLO da:'),
('GLORY_WARNING2', 'en', 'Get Glory ONLY from:'),
('GLORY_WARNING2', 'de', 'Erhalte Ruhm NUR von:'),
('GLORY_WARNING2', 'es', 'Obtén Gloria SOLO de:'),
('GLORY_WARNING2', 'fr', 'Obtenez de la Gloire UNIQUEMENT de:'),
('GLORY_WARNING2', 'pt', 'Obtenha Glória SOMENTE de:'),

('GLORY_METHOD_FRACTURES', 'it', 'Fratture Dimensionali'),
('GLORY_METHOD_FRACTURES', 'en', 'Dimensional Fractures'),
('GLORY_METHOD_FRACTURES', 'de', 'Dimensionale Brüche'),
('GLORY_METHOD_FRACTURES', 'es', 'Fracturas Dimensionales'),
('GLORY_METHOD_FRACTURES', 'fr', 'Fractures Dimensionnelles'),
('GLORY_METHOD_FRACTURES', 'pt', 'Fraturas Dimensionais'),

('GLORY_METHOD_FRACTURES_DESC', 'it', 'Boss/Metin DENTRO le fratture (base pts)'),
('GLORY_METHOD_FRACTURES_DESC', 'en', 'Boss/Metin INSIDE fractures (base pts)'),
('GLORY_METHOD_FRACTURES_DESC', 'de', 'Boss/Metin IN Brüchen (Basispunkte)'),
('GLORY_METHOD_FRACTURES_DESC', 'es', 'Boss/Metin DENTRO de fracturas (pts base)'),
('GLORY_METHOD_FRACTURES_DESC', 'fr', 'Boss/Métin DANS les fractures (pts base)'),
('GLORY_METHOD_FRACTURES_DESC', 'pt', 'Boss/Metin DENTRO das fraturas (pts base)'),

('GLORY_METHOD_MISSIONS', 'it', 'Missioni Giornaliere'),
('GLORY_METHOD_MISSIONS', 'en', 'Daily Missions'),
('GLORY_METHOD_MISSIONS', 'de', 'Tägliche Missionen'),
('GLORY_METHOD_MISSIONS', 'es', 'Misiones Diarias'),
('GLORY_METHOD_MISSIONS', 'fr', 'Missions Quotidiennes'),
('GLORY_METHOD_MISSIONS', 'pt', 'Missões Diárias'),

('GLORY_METHOD_MISSIONS_DESC', 'it', '3 missioni al giorno (reward scala col Rank)'),
('GLORY_METHOD_MISSIONS_DESC', 'en', '3 missions per day (reward scales with Rank)'),
('GLORY_METHOD_MISSIONS_DESC', 'de', '3 Missionen pro Tag (Belohnung skaliert mit Rang)'),
('GLORY_METHOD_MISSIONS_DESC', 'es', '3 misiones por día (recompensa escala con Rango)'),
('GLORY_METHOD_MISSIONS_DESC', 'fr', '3 missions par jour (récompense selon le Rang)'),
('GLORY_METHOD_MISSIONS_DESC', 'pt', '3 missões por dia (recompensa escala com Rank)'),

('GLORY_METHOD_EMERGENCY', 'it', 'Emergency Quest'),
('GLORY_METHOD_EMERGENCY', 'en', 'Emergency Quest'),
('GLORY_METHOD_EMERGENCY', 'de', 'Notfall-Quest'),
('GLORY_METHOD_EMERGENCY', 'es', 'Misión de Emergencia'),
('GLORY_METHOD_EMERGENCY', 'fr', 'Quête d''Urgence'),
('GLORY_METHOD_EMERGENCY', 'pt', 'Missão de Emergência'),

('GLORY_METHOD_EMERGENCY_DESC', 'it', '40% chance dopo ~500 kill normali'),
('GLORY_METHOD_EMERGENCY_DESC', 'en', '40% chance after ~500 normal kills'),
('GLORY_METHOD_EMERGENCY_DESC', 'de', '40% Chance nach ~500 normalen Kills'),
('GLORY_METHOD_EMERGENCY_DESC', 'es', '40% de probabilidad después de ~500 kills normales'),
('GLORY_METHOD_EMERGENCY_DESC', 'fr', '40% de chance après ~500 kills normaux'),
('GLORY_METHOD_EMERGENCY_DESC', 'pt', '40% de chance após ~500 kills normais'),

('GLORY_METHOD_EVENTS', 'it', 'Eventi Programmati'),
('GLORY_METHOD_EVENTS', 'en', 'Scheduled Events'),
('GLORY_METHOD_EVENTS', 'de', 'Geplante Events'),
('GLORY_METHOD_EVENTS', 'es', 'Eventos Programados'),
('GLORY_METHOD_EVENTS', 'fr', 'Événements Programmés'),
('GLORY_METHOD_EVENTS', 'pt', 'Eventos Programados'),

('GLORY_METHOD_EVENTS_DESC', 'it', 'Glory Rush, Metin Frenzy, Boss Massacre...'),
('GLORY_METHOD_EVENTS_DESC', 'en', 'Glory Rush, Metin Frenzy, Boss Massacre...'),
('GLORY_METHOD_EVENTS_DESC', 'de', 'Glory Rush, Metin Frenzy, Boss Massacre...'),
('GLORY_METHOD_EVENTS_DESC', 'es', 'Glory Rush, Metin Frenzy, Boss Massacre...'),
('GLORY_METHOD_EVENTS_DESC', 'fr', 'Glory Rush, Metin Frenzy, Boss Massacre...'),
('GLORY_METHOD_EVENTS_DESC', 'pt', 'Glory Rush, Metin Frenzy, Boss Massacre...'),

('GLORY_METHOD_STREAK', 'it', 'Streak Login'),
('GLORY_METHOD_STREAK', 'en', 'Login Streak'),
('GLORY_METHOD_STREAK', 'de', 'Login-Serie'),
('GLORY_METHOD_STREAK', 'es', 'Racha de Login'),
('GLORY_METHOD_STREAK', 'fr', 'Série de Connexion'),
('GLORY_METHOD_STREAK', 'pt', 'Sequência de Login'),

('GLORY_METHOD_STREAK_DESC', 'it', '3gg=+5%, 7gg=+10%, 30gg=+20% Gloria'),
('GLORY_METHOD_STREAK_DESC', 'en', '3d=+5%, 7d=+10%, 30d=+20% Glory'),
('GLORY_METHOD_STREAK_DESC', 'de', '3T=+5%, 7T=+10%, 30T=+20% Ruhm'),
('GLORY_METHOD_STREAK_DESC', 'es', '3d=+5%, 7d=+10%, 30d=+20% Gloria'),
('GLORY_METHOD_STREAK_DESC', 'fr', '3j=+5%, 7j=+10%, 30j=+20% Gloire'),
('GLORY_METHOD_STREAK_DESC', 'pt', '3d=+5%, 7d=+10%, 30d=+20% Glória'),

('GLORY_METHOD_CHESTS', 'it', 'Bauli Hunter'),
('GLORY_METHOD_CHESTS', 'en', 'Hunter Chests'),
('GLORY_METHOD_CHESTS', 'de', 'Jäger-Truhen'),
('GLORY_METHOD_CHESTS', 'es', 'Cofres de Cazador'),
('GLORY_METHOD_CHESTS', 'fr', 'Coffres de Chasseur'),
('GLORY_METHOD_CHESTS', 'pt', 'Baús de Caçador'),

('GLORY_METHOD_CHESTS_DESC', 'it', 'Bauli spawn nelle mappe normali'),
('GLORY_METHOD_CHESTS_DESC', 'en', 'Chests spawn in normal maps'),
('GLORY_METHOD_CHESTS_DESC', 'de', 'Truhen spawnen in normalen Karten'),
('GLORY_METHOD_CHESTS_DESC', 'es', 'Cofres aparecen en mapas normales'),
('GLORY_METHOD_CHESTS_DESC', 'fr', 'Coffres apparaissent dans les cartes normales'),
('GLORY_METHOD_CHESTS_DESC', 'pt', 'Baús aparecem em mapas normais'),

('GLORY_METHOD_SPEEDKILL', 'it', 'Speed Kill Bonus'),
('GLORY_METHOD_SPEEDKILL', 'en', 'Speed Kill Bonus'),
('GLORY_METHOD_SPEEDKILL', 'de', 'Speed Kill Bonus'),
('GLORY_METHOD_SPEEDKILL', 'es', 'Bono de Kill Rápido'),
('GLORY_METHOD_SPEEDKILL', 'fr', 'Bonus Kill Rapide'),
('GLORY_METHOD_SPEEDKILL', 'pt', 'Bônus de Kill Rápido'),

('GLORY_METHOD_SPEEDKILL_DESC', 'it', 'Boss 60s, Metin 300s = doppia Gloria'),
('GLORY_METHOD_SPEEDKILL_DESC', 'en', 'Boss 60s, Metin 300s = double Glory'),
('GLORY_METHOD_SPEEDKILL_DESC', 'de', 'Boss 60s, Metin 300s = doppelter Ruhm'),
('GLORY_METHOD_SPEEDKILL_DESC', 'es', 'Boss 60s, Metin 300s = doble Gloria'),
('GLORY_METHOD_SPEEDKILL_DESC', 'fr', 'Boss 60s, Métin 300s = double Gloire'),
('GLORY_METHOD_SPEEDKILL_DESC', 'pt', 'Boss 60s, Metin 300s = Glória em dobro'),

('HOW_IT_WORKS', 'it', 'COME FUNZIONA:'),
('HOW_IT_WORKS', 'en', 'HOW IT WORKS:'),
('HOW_IT_WORKS', 'de', 'WIE ES FUNKTIONIERT:'),
('HOW_IT_WORKS', 'es', 'CÓMO FUNCIONA:'),
('HOW_IT_WORKS', 'fr', 'COMMENT ÇA MARCHE:'),
('HOW_IT_WORKS', 'pt', 'COMO FUNCIONA:')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISSIONS WINDOW (hunter_missions.py)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('DAILY_MISSIONS_TITLE', 'it', '< MISSIONI GIORNALIERE >'),
('DAILY_MISSIONS_TITLE', 'en', '< DAILY MISSIONS >'),
('DAILY_MISSIONS_TITLE', 'de', '< TÄGLICHE MISSIONEN >'),
('DAILY_MISSIONS_TITLE', 'es', '< MISIONES DIARIAS >'),
('DAILY_MISSIONS_TITLE', 'fr', '< MISSIONS QUOTIDIENNES >'),
('DAILY_MISSIONS_TITLE', 'pt', '< MISSÕES DIÁRIAS >'),

('BONUS', 'it', 'BONUS'),
('BONUS', 'en', 'BONUS'),
('BONUS', 'de', 'BONUS'),
('BONUS', 'es', 'BONUS'),
('BONUS', 'fr', 'BONUS'),
('BONUS', 'pt', 'BÔNUS'),

('BONUS_DESC', 'it', 'Completa tutte: Gloria x1.5 fino al reset!'),
('BONUS_DESC', 'en', 'Complete all: Glory x1.5 until reset!'),
('BONUS_DESC', 'de', 'Alle abschließen: Ruhm x1.5 bis zum Reset!'),
('BONUS_DESC', 'es', '¡Completa todas: Gloria x1.5 hasta el reinicio!'),
('BONUS_DESC', 'fr', 'Terminer toutes: Gloire x1.5 jusqu''au reset!'),
('BONUS_DESC', 'pt', 'Complete todas: Glória x1.5 até o reset!'),

('MALUS', 'it', 'MALUS'),
('MALUS', 'en', 'PENALTY'),
('MALUS', 'de', 'STRAFE'),
('MALUS', 'es', 'PENALIZACIÓN'),
('MALUS', 'fr', 'PÉNALITÉ'),
('MALUS', 'pt', 'PENALIDADE'),

('MALUS_DESC', 'it', 'Non completare: -Gloria (vedi penalita)'),
('MALUS_DESC', 'en', 'Not completing: -Glory (see penalty)'),
('MALUS_DESC', 'de', 'Nicht abschließen: -Ruhm (siehe Strafe)'),
('MALUS_DESC', 'es', 'No completar: -Gloria (ver penalización)'),
('MALUS_DESC', 'fr', 'Ne pas terminer: -Gloire (voir pénalité)'),
('MALUS_DESC', 'pt', 'Não completar: -Glória (ver penalidade)'),

('RESET_INFO', 'it', 'Reset giornaliero alle 05:00'),
('RESET_INFO', 'en', 'Daily reset at 05:00'),
('RESET_INFO', 'de', 'Täglicher Reset um 05:00'),
('RESET_INFO', 'es', 'Reinicio diario a las 05:00'),
('RESET_INFO', 'fr', 'Réinitialisation quotidienne à 05h00'),
('RESET_INFO', 'pt', 'Reset diário às 05:00'),

('WAITING', 'it', 'In attesa...'),
('WAITING', 'en', 'Waiting...'),
('WAITING', 'de', 'Warten...'),
('WAITING', 'es', 'Esperando...'),
('WAITING', 'fr', 'En attente...'),
('WAITING', 'pt', 'Aguardando...'),

('NO_MISSION', 'it', 'Nessuna missione'),
('NO_MISSION', 'en', 'No mission'),
('NO_MISSION', 'de', 'Keine Mission'),
('NO_MISSION', 'es', 'Sin misión'),
('NO_MISSION', 'fr', 'Aucune mission'),
('NO_MISSION', 'pt', 'Sem missão'),

('BONUS_GLORY_ACTIVE', 'it', '>>> BONUS GLORIA x1.5 ATTIVO! <<<'),
('BONUS_GLORY_ACTIVE', 'en', '>>> GLORY BONUS x1.5 ACTIVE! <<<'),
('BONUS_GLORY_ACTIVE', 'de', '>>> RUHM BONUS x1.5 AKTIV! <<<'),
('BONUS_GLORY_ACTIVE', 'es', '>>> ¡BONUS DE GLORIA x1.5 ACTIVO! <<<'),
('BONUS_GLORY_ACTIVE', 'fr', '>>> BONUS GLOIRE x1.5 ACTIF! <<<'),
('BONUS_GLORY_ACTIVE', 'pt', '>>> BÔNUS DE GLÓRIA x1.5 ATIVO! <<<'),

('BONUS_ACTIVE_DESC', 'it', 'ATTIVO! Gloria x1.5 fino alle 05:00!'),
('BONUS_ACTIVE_DESC', 'en', 'ACTIVE! Glory x1.5 until 05:00!'),
('BONUS_ACTIVE_DESC', 'de', 'AKTIV! Ruhm x1.5 bis 05:00!'),
('BONUS_ACTIVE_DESC', 'es', '¡ACTIVO! Gloria x1.5 hasta las 05:00!'),
('BONUS_ACTIVE_DESC', 'fr', 'ACTIF! Gloire x1.5 jusqu''à 05h00!'),
('BONUS_ACTIVE_DESC', 'pt', 'ATIVO! Glória x1.5 até às 05:00!'),

('MISSION', 'it', 'MISSIONE'),
('MISSION', 'en', 'MISSION'),
('MISSION', 'de', 'MISSION'),
('MISSION', 'es', 'MISIÓN'),
('MISSION', 'fr', 'MISSION'),
('MISSION', 'pt', 'MISSÃO'),

('MISSION_COMPLETED_TITLE', 'it', '< MISSIONE COMPLETATA >'),
('MISSION_COMPLETED_TITLE', 'en', '< MISSION COMPLETED >'),
('MISSION_COMPLETED_TITLE', 'de', '< MISSION ABGESCHLOSSEN >'),
('MISSION_COMPLETED_TITLE', 'es', '< MISIÓN COMPLETADA >'),
('MISSION_COMPLETED_TITLE', 'fr', '< MISSION TERMINÉE >'),
('MISSION_COMPLETED_TITLE', 'pt', '< MISSÃO COMPLETA >'),

('ALL_MISSIONS_COMPLETE_TITLE', 'it', '=== TUTTE LE MISSIONI COMPLETE ==='),
('ALL_MISSIONS_COMPLETE_TITLE', 'en', '=== ALL MISSIONS COMPLETE ==='),
('ALL_MISSIONS_COMPLETE_TITLE', 'de', '=== ALLE MISSIONEN ABGESCHLOSSEN ==='),
('ALL_MISSIONS_COMPLETE_TITLE', 'es', '=== TODAS LAS MISIONES COMPLETAS ==='),
('ALL_MISSIONS_COMPLETE_TITLE', 'fr', '=== TOUTES LES MISSIONS TERMINÉES ==='),
('ALL_MISSIONS_COMPLETE_TITLE', 'pt', '=== TODAS AS MISSÕES COMPLETAS ==='),

('COMPLETION_BONUS', 'it', 'BONUS COMPLETAMENTO x1.5'),
('COMPLETION_BONUS', 'en', 'COMPLETION BONUS x1.5'),
('COMPLETION_BONUS', 'de', 'ABSCHLUSS BONUS x1.5'),
('COMPLETION_BONUS', 'es', 'BONUS DE COMPLETAR x1.5'),
('COMPLETION_BONUS', 'fr', 'BONUS DE COMPLÉTION x1.5'),
('COMPLETION_BONUS', 'pt', 'BÔNUS DE CONCLUSÃO x1.5'),

('GREAT_WORK_HUNTER', 'it', 'Ottimo lavoro, Cacciatore!'),
('GREAT_WORK_HUNTER', 'en', 'Great work, Hunter!'),
('GREAT_WORK_HUNTER', 'de', 'Gute Arbeit, Jäger!'),
('GREAT_WORK_HUNTER', 'es', '¡Buen trabajo, Cazador!'),
('GREAT_WORK_HUNTER', 'fr', 'Excellent travail, Chasseur!'),
('GREAT_WORK_HUNTER', 'pt', 'Ótimo trabalho, Caçador!'),

('GLORY_BONUS', 'it', 'GLORIA BONUS'),
('GLORY_BONUS', 'en', 'GLORY BONUS'),
('GLORY_BONUS', 'de', 'RUHM BONUS'),
('GLORY_BONUS', 'es', 'BONUS DE GLORIA'),
('GLORY_BONUS', 'fr', 'BONUS GLOIRE'),
('GLORY_BONUS', 'pt', 'BÔNUS DE GLÓRIA'),

('FRACTURE_BONUS_50', 'it', 'BONUS FRATTURE +50% PER IL RESTO DEL GIORNO!'),
('FRACTURE_BONUS_50', 'en', 'FRACTURE BONUS +50% FOR THE REST OF THE DAY!'),
('FRACTURE_BONUS_50', 'de', 'BRUCH BONUS +50% FÜR DEN REST DES TAGES!'),
('FRACTURE_BONUS_50', 'es', '¡BONUS DE FRACTURAS +50% POR EL RESTO DEL DÍA!'),
('FRACTURE_BONUS_50', 'fr', 'BONUS FRACTURES +50% POUR LE RESTE DE LA JOURNÉE!'),
('FRACTURE_BONUS_50', 'pt', 'BÔNUS DE FRATURAS +50% PELO RESTO DO DIA!'),

('TODAY_EVENTS_TITLE', 'it', '< EVENTI DI OGGI >'),
('TODAY_EVENTS_TITLE', 'en', '< TODAY''S EVENTS >'),
('TODAY_EVENTS_TITLE', 'de', '< HEUTIGE EVENTS >'),
('TODAY_EVENTS_TITLE', 'es', '< EVENTOS DE HOY >'),
('TODAY_EVENTS_TITLE', 'fr', '< ÉVÉNEMENTS D''AUJOURD''HUI >'),
('TODAY_EVENTS_TITLE', 'pt', '< EVENTOS DE HOJE >'),

('NO_EVENTS_TODAY', 'it', 'Nessun evento programmato oggi'),
('NO_EVENTS_TODAY', 'en', 'No events scheduled today'),
('NO_EVENTS_TODAY', 'de', 'Heute keine Events geplant'),
('NO_EVENTS_TODAY', 'es', 'No hay eventos programados hoy'),
('NO_EVENTS_TODAY', 'fr', 'Aucun événement programmé aujourd''hui'),
('NO_EVENTS_TODAY', 'pt', 'Nenhum evento programado hoje'),

('AUTO_REGISTRATION', 'it', 'ISCRIZIONE AUTOMATICA'),
('AUTO_REGISTRATION', 'en', 'AUTOMATIC REGISTRATION'),
('AUTO_REGISTRATION', 'de', 'AUTOMATISCHE ANMELDUNG'),
('AUTO_REGISTRATION', 'es', 'INSCRIPCIÓN AUTOMÁTICA'),
('AUTO_REGISTRATION', 'fr', 'INSCRIPTION AUTOMATIQUE'),
('AUTO_REGISTRATION', 'pt', 'INSCRIÇÃO AUTOMÁTICA'),

('AUTO_REG_INFO1', 'it', 'Conquista fratture, uccidi boss o metinpietra'),
('AUTO_REG_INFO1', 'en', 'Conquer fractures, kill bosses or metinstones'),
('AUTO_REG_INFO1', 'de', 'Erobere Brüche, töte Bosse oder Metinsteine'),
('AUTO_REG_INFO1', 'es', 'Conquista fracturas, mata jefes o metinpiedras'),
('AUTO_REG_INFO1', 'fr', 'Conquérez des fractures, tuez des boss ou des métinpierres'),
('AUTO_REG_INFO1', 'pt', 'Conquiste fraturas, mate chefes ou metinpedras'),

('AUTO_REG_INFO2', 'it', 'per iscriverti automaticamente e partecipare!'),
('AUTO_REG_INFO2', 'en', 'to automatically register and participate!'),
('AUTO_REG_INFO2', 'de', 'um dich automatisch anzumelden und teilzunehmen!'),
('AUTO_REG_INFO2', 'es', '¡para inscribirte automáticamente y participar!'),
('AUTO_REG_INFO2', 'fr', 'pour vous inscrire automatiquement et participer!'),
('AUTO_REG_INFO2', 'pt', 'para se inscrever automaticamente e participar!')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- COMMON BUTTONS AND LABELS
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('POINTS', 'it', 'punti'),
('POINTS', 'en', 'points'),
('POINTS', 'de', 'Punkte'),
('POINTS', 'es', 'puntos'),
('POINTS', 'fr', 'points'),
('POINTS', 'pt', 'pontos'),

('PENALTY', 'it', 'Penalita'''),
('PENALTY', 'en', 'Penalty'),
('PENALTY', 'de', 'Strafe'),
('PENALTY', 'es', 'Penalización'),
('PENALTY', 'fr', 'Pénalité'),
('PENALTY', 'pt', 'Penalidade'),

('ALL_DAYS', 'it', 'Tutti'),
('ALL_DAYS', 'en', 'All'),
('ALL_DAYS', 'de', 'Alle'),
('ALL_DAYS', 'es', 'Todos'),
('ALL_DAYS', 'fr', 'Tous'),
('ALL_DAYS', 'pt', 'Todos'),

('DAYS', 'it', 'Giorni:'),
('DAYS', 'en', 'Days:'),
('DAYS', 'de', 'Tage:'),
('DAYS', 'es', 'Días:'),
('DAYS', 'fr', 'Jours:'),
('DAYS', 'pt', 'Dias:'),

('PRIORITY', 'it', 'Priorità:'),
('PRIORITY', 'en', 'Priority:'),
('PRIORITY', 'de', 'Priorität:'),
('PRIORITY', 'es', 'Prioridad:'),
('PRIORITY', 'fr', 'Priorité:'),
('PRIORITY', 'pt', 'Prioridade:'),

('NO_SCHEDULED_EVENTS', 'it', 'Nessun evento programmato trovato.'),
('NO_SCHEDULED_EVENTS', 'en', 'No scheduled events found.'),
('NO_SCHEDULED_EVENTS', 'de', 'Keine geplanten Events gefunden.'),
('NO_SCHEDULED_EVENTS', 'es', 'No se encontraron eventos programados.'),
('NO_SCHEDULED_EVENTS', 'fr', 'Aucun événement programmé trouvé.'),
('NO_SCHEDULED_EVENTS', 'pt', 'Nenhum evento programado encontrado.'),

('QUESTION_PREFIX', 'it', 'D:'),
('QUESTION_PREFIX', 'en', 'Q:'),
('QUESTION_PREFIX', 'de', 'F:'),
('QUESTION_PREFIX', 'es', 'P:'),
('QUESTION_PREFIX', 'fr', 'Q:'),
('QUESTION_PREFIX', 'pt', 'P:'),

('ANSWER_PREFIX', 'it', 'R:'),
('ANSWER_PREFIX', 'en', 'A:'),
('ANSWER_PREFIX', 'de', 'A:'),
('ANSWER_PREFIX', 'es', 'R:'),
('ANSWER_PREFIX', 'fr', 'R:'),
('ANSWER_PREFIX', 'pt', 'R:')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- FAQ TRANSLATIONS (Sample - you can add more as needed)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('FAQ_TITLE', 'it', 'DOMANDE FREQUENTI (FAQ)'),
('FAQ_TITLE', 'en', 'FREQUENTLY ASKED QUESTIONS (FAQ)'),
('FAQ_TITLE', 'de', 'HÄUFIG GESTELLTE FRAGEN (FAQ)'),
('FAQ_TITLE', 'es', 'PREGUNTAS FRECUENTES (FAQ)'),
('FAQ_TITLE', 'fr', 'FOIRE AUX QUESTIONS (FAQ)'),
('FAQ_TITLE', 'pt', 'PERGUNTAS FREQUENTES (FAQ)'),

('FAQ_Q1', 'it', 'Come attivo il sistema Hunter?'),
('FAQ_Q1', 'en', 'How do I activate the Hunter system?'),
('FAQ_Q1', 'de', 'Wie aktiviere ich das Hunter-System?'),
('FAQ_Q1', 'es', '¿Cómo activo el sistema Hunter?'),
('FAQ_Q1', 'fr', 'Comment activer le système Hunter?'),
('FAQ_Q1', 'pt', 'Como ativo o sistema Hunter?'),

('FAQ_A1', 'it', 'Raggiungi il livello 30 per attivare il sistema automaticamente.'),
('FAQ_A1', 'en', 'Reach level 30 to activate the system automatically.'),
('FAQ_A1', 'de', 'Erreiche Level 30, um das System automatisch zu aktivieren.'),
('FAQ_A1', 'es', 'Alcanza el nivel 30 para activar el sistema automáticamente.'),
('FAQ_A1', 'fr', 'Atteignez le niveau 30 pour activer le système automatiquement.'),
('FAQ_A1', 'pt', 'Alcance o nível 30 para ativar o sistema automaticamente.'),

('FAQ_Q3', 'it', 'I mostri normali danno Gloria?'),
('FAQ_Q3', 'en', 'Do normal monsters give Glory?'),
('FAQ_Q3', 'de', 'Geben normale Monster Ruhm?'),
('FAQ_Q3', 'es', '¿Los monstruos normales dan Gloria?'),
('FAQ_Q3', 'fr', 'Les monstres normaux donnent-ils de la Gloire?'),
('FAQ_Q3', 'pt', 'Os monstros normais dão Glória?'),

('FAQ_A3', 'it', 'NO! Solo Fratture, Missioni, Emergency Quest ed Eventi danno Gloria!'),
('FAQ_A3', 'en', 'NO! Only Fractures, Missions, Emergency Quests and Events give Glory!'),
('FAQ_A3', 'de', 'NEIN! Nur Brüche, Missionen, Notfall-Quests und Events geben Ruhm!'),
('FAQ_A3', 'es', '¡NO! ¡Solo Fracturas, Misiones, Misiones de Emergencia y Eventos dan Gloria!'),
('FAQ_A3', 'fr', 'NON! Seules les Fractures, Missions, Quêtes d''Urgence et Événements donnent de la Gloire!'),
('FAQ_A3', 'pt', 'NÃO! Apenas Fraturas, Missões, Missões de Emergência e Eventos dão Glória!')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- GUIDE SECTIONS TITLES
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('GUIDE_MISSIONS_TITLE', 'it', 'MISSIONI GIORNALIERE'),
('GUIDE_MISSIONS_TITLE', 'en', 'DAILY MISSIONS'),
('GUIDE_MISSIONS_TITLE', 'de', 'TÄGLICHE MISSIONEN'),
('GUIDE_MISSIONS_TITLE', 'es', 'MISIONES DIARIAS'),
('GUIDE_MISSIONS_TITLE', 'fr', 'MISSIONS QUOTIDIENNES'),
('GUIDE_MISSIONS_TITLE', 'pt', 'MISSÕES DIÁRIAS'),

('GUIDE_EVENTS_TITLE', 'it', 'EVENTI PROGRAMMATI 24H'),
('GUIDE_EVENTS_TITLE', 'en', 'SCHEDULED EVENTS 24H'),
('GUIDE_EVENTS_TITLE', 'de', '24H GEPLANTE EVENTS'),
('GUIDE_EVENTS_TITLE', 'es', 'EVENTOS PROGRAMADOS 24H'),
('GUIDE_EVENTS_TITLE', 'fr', 'ÉVÉNEMENTS PROGRAMMÉS 24H'),
('GUIDE_EVENTS_TITLE', 'pt', 'EVENTOS PROGRAMADOS 24H'),

('GUIDE_SHOP_TITLE', 'it', 'MERCANTE HUNTER'),
('GUIDE_SHOP_TITLE', 'en', 'HUNTER MERCHANT'),
('GUIDE_SHOP_TITLE', 'de', 'JÄGER HÄNDLER'),
('GUIDE_SHOP_TITLE', 'es', 'MERCADER CAZADOR'),
('GUIDE_SHOP_TITLE', 'fr', 'MARCHAND CHASSEUR'),
('GUIDE_SHOP_TITLE', 'pt', 'MERCADOR CAÇADOR'),

('COMMANDS_TITLE', 'it', 'COMANDI E SCORCIATOIE:'),
('COMMANDS_TITLE', 'en', 'COMMANDS AND SHORTCUTS:'),
('COMMANDS_TITLE', 'de', 'BEFEHLE UND TASTENKÜRZEL:'),
('COMMANDS_TITLE', 'es', 'COMANDOS Y ATAJOS:'),
('COMMANDS_TITLE', 'fr', 'COMMANDES ET RACCOURCIS:'),
('COMMANDS_TITLE', 'pt', 'COMANDOS E ATALHOS:')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVER-SIDE MESSAGES (Lua syschat, notice_all, etc.)
-- ═══════════════════════════════════════════════════════════════════════════════

-- EMERGENCY SYSTEM
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('EMERG_COMPLETED_TITLE', 'it', '[!!!] SFIDA EMERGENZA COMPLETATA [!!!]'),
('EMERG_COMPLETED_TITLE', 'en', '[!!!] EMERGENCY CHALLENGE COMPLETED [!!!]'),
('EMERG_COMPLETED_TITLE', 'de', '[!!!] NOTFALL-HERAUSFORDERUNG ABGESCHLOSSEN [!!!]'),
('EMERG_COMPLETED_TITLE', 'es', '[!!!] DESAFIO DE EMERGENCIA COMPLETADO [!!!]'),
('EMERG_COMPLETED_TITLE', 'fr', '[!!!] DEFI D''URGENCE COMPLETE [!!!]'),
('EMERG_COMPLETED_TITLE', 'pt', '[!!!] DESAFIO DE EMERGENCIA COMPLETO [!!!]'),

('EMERG_REWARD', 'it', 'Gloria Ricompensa: +{PTS}'),
('EMERG_REWARD', 'en', 'Glory Reward: +{PTS}'),
('EMERG_REWARD', 'de', 'Ruhm Belohnung: +{PTS}'),
('EMERG_REWARD', 'es', 'Recompensa de Gloria: +{PTS}'),
('EMERG_REWARD', 'fr', 'Recompense de Gloire: +{PTS}'),
('EMERG_REWARD', 'pt', 'Recompensa de Gloria: +{PTS}'),

('EMERG_TOTAL', 'it', '>>> TOTALE: +{PTS} Gloria <<<'),
('EMERG_TOTAL', 'en', '>>> TOTAL: +{PTS} Glory <<<'),
('EMERG_TOTAL', 'de', '>>> GESAMT: +{PTS} Ruhm <<<'),
('EMERG_TOTAL', 'es', '>>> TOTAL: +{PTS} Gloria <<<'),
('EMERG_TOTAL', 'fr', '>>> TOTAL: +{PTS} Gloire <<<'),
('EMERG_TOTAL', 'pt', '>>> TOTAL: +{PTS} Gloria <<<'),

('EMERG_VICTORY_MSG', 'it', '[VITTORIA] SFIDA SUPERATA! +{PTS} GLORIA EXTRA'),
('EMERG_VICTORY_MSG', 'en', '[VICTORY] CHALLENGE PASSED! +{PTS} EXTRA GLORY'),
('EMERG_VICTORY_MSG', 'de', '[SIEG] HERAUSFORDERUNG BESTANDEN! +{PTS} EXTRA RUHM'),
('EMERG_VICTORY_MSG', 'es', '[VICTORIA] DESAFIO SUPERADO! +{PTS} GLORIA EXTRA'),
('EMERG_VICTORY_MSG', 'fr', '[VICTOIRE] DEFI REUSSI! +{PTS} GLOIRE EN PLUS'),
('EMERG_VICTORY_MSG', 'pt', '[VITORIA] DESAFIO SUPERADO! +{PTS} GLORIA EXTRA'),

('EMERG_COMPLETED', 'it', 'SFIDA COMPLETATA!'),
('EMERG_COMPLETED', 'en', 'CHALLENGE COMPLETED!'),
('EMERG_COMPLETED', 'de', 'HERAUSFORDERUNG ABGESCHLOSSEN!'),
('EMERG_COMPLETED', 'es', 'DESAFIO COMPLETADO!'),
('EMERG_COMPLETED', 'fr', 'DEFI COMPLETE!'),
('EMERG_COMPLETED', 'pt', 'DESAFIO COMPLETO!')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- EVENT SYSTEM
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('EVENT', 'it', 'EVENTO'),
('EVENT', 'en', 'EVENT'),
('EVENT', 'de', 'EVENT'),
('EVENT', 'es', 'EVENTO'),
('EVENT', 'fr', 'EVENEMENT'),
('EVENT', 'pt', 'EVENTO'),

('EVENT_FIRST_WIN', 'it', 'SEI IL PRIMO! HAI VINTO +{PTS} GLORIA!'),
('EVENT_FIRST_WIN', 'en', 'YOU ARE FIRST! YOU WON +{PTS} GLORY!'),
('EVENT_FIRST_WIN', 'de', 'DU BIST ERSTER! DU HAST +{PTS} RUHM GEWONNEN!'),
('EVENT_FIRST_WIN', 'es', 'ERES EL PRIMERO! GANASTE +{PTS} GLORIA!'),
('EVENT_FIRST_WIN', 'fr', 'TU ES PREMIER! TU AS GAGNE +{PTS} GLOIRE!'),
('EVENT_FIRST_WIN', 'pt', 'VOCE E O PRIMEIRO! GANHOU +{PTS} GLORIA!'),

('EVENT_FIRST_RIFT_TITLE', 'it', '[!] PRIMO A CONQUISTARE LA FRATTURA [!]'),
('EVENT_FIRST_RIFT_TITLE', 'en', '[!] FIRST TO CONQUER THE RIFT [!]'),
('EVENT_FIRST_RIFT_TITLE', 'de', '[!] ERSTER DER DIE FRAKTUR EROBERT [!]'),
('EVENT_FIRST_RIFT_TITLE', 'es', '[!] PRIMERO EN CONQUISTAR LA FRACTURA [!]'),
('EVENT_FIRST_RIFT_TITLE', 'fr', '[!] PREMIER A CONQUERIR LA FAILLE [!]'),
('EVENT_FIRST_RIFT_TITLE', 'pt', '[!] PRIMEIRO A CONQUISTAR A FRATURA [!]'),

('EVENT_PRIZE', 'it', 'Premio: +{PTS} Gloria!'),
('EVENT_PRIZE', 'en', 'Prize: +{PTS} Glory!'),
('EVENT_PRIZE', 'de', 'Preis: +{PTS} Ruhm!'),
('EVENT_PRIZE', 'es', 'Premio: +{PTS} Gloria!'),
('EVENT_PRIZE', 'fr', 'Prix: +{PTS} Gloire!'),
('EVENT_PRIZE', 'pt', 'Premio: +{PTS} Gloria!'),

('EVENT_FIRST_RIFT_ANNOUNCE', 'it', '{NAME} e'' il PRIMO a conquistare una frattura!'),
('EVENT_FIRST_RIFT_ANNOUNCE', 'en', '{NAME} is the FIRST to conquer a rift!'),
('EVENT_FIRST_RIFT_ANNOUNCE', 'de', '{NAME} ist der ERSTE der eine Fraktur erobert!'),
('EVENT_FIRST_RIFT_ANNOUNCE', 'es', '{NAME} es el PRIMERO en conquistar una fractura!'),
('EVENT_FIRST_RIFT_ANNOUNCE', 'fr', '{NAME} est le PREMIER a conquerir une faille!'),
('EVENT_FIRST_RIFT_ANNOUNCE', 'pt', '{NAME} e o PRIMEIRO a conquistar uma fratura!'),

('EVENT_FIRST_WINNER_TITLE', 'it', '[!!!] PRIMO CLASSIFICATO EVENTO [!!!]'),
('EVENT_FIRST_WINNER_TITLE', 'en', '[!!!] FIRST PLACE EVENT WINNER [!!!]'),
('EVENT_FIRST_WINNER_TITLE', 'de', '[!!!] ERSTER PLATZ EVENT GEWINNER [!!!]'),
('EVENT_FIRST_WINNER_TITLE', 'es', '[!!!] PRIMER CLASIFICADO EVENTO [!!!]'),
('EVENT_FIRST_WINNER_TITLE', 'fr', '[!!!] PREMIER CLASSE EVENEMENT [!!!]'),
('EVENT_FIRST_WINNER_TITLE', 'pt', '[!!!] PRIMEIRO CLASSIFICADO EVENTO [!!!]'),

('EVENT_YOU_WERE_FIRST', 'it', 'Sei stato il PRIMO!'),
('EVENT_YOU_WERE_FIRST', 'en', 'You were the FIRST!'),
('EVENT_YOU_WERE_FIRST', 'de', 'Du warst der ERSTE!'),
('EVENT_YOU_WERE_FIRST', 'es', 'Fuiste el PRIMERO!'),
('EVENT_YOU_WERE_FIRST', 'fr', 'Tu etais le PREMIER!'),
('EVENT_YOU_WERE_FIRST', 'pt', 'Voce foi o PRIMEIRO!'),

('EVENT_GLORY_PRIZE', 'it', 'Premio Gloria: +{PTS}'),
('EVENT_GLORY_PRIZE', 'en', 'Glory Prize: +{PTS}'),
('EVENT_GLORY_PRIZE', 'de', 'Ruhm Preis: +{PTS}'),
('EVENT_GLORY_PRIZE', 'es', 'Premio Gloria: +{PTS}'),
('EVENT_GLORY_PRIZE', 'fr', 'Prix Gloire: +{PTS}'),
('EVENT_GLORY_PRIZE', 'pt', 'Premio Gloria: +{PTS}'),

('EVENT_TOTAL', 'it', '>>> TOTALE: +{PTS} Gloria <<<'),
('EVENT_TOTAL', 'en', '>>> TOTAL: +{PTS} Glory <<<'),
('EVENT_TOTAL', 'de', '>>> GESAMT: +{PTS} Ruhm <<<'),
('EVENT_TOTAL', 'es', '>>> TOTAL: +{PTS} Gloria <<<'),
('EVENT_TOTAL', 'fr', '>>> TOTAL: +{PTS} Gloire <<<'),
('EVENT_TOTAL', 'pt', '>>> TOTAL: +{PTS} Gloria <<<'),

('EVENT_FIRST_BOSS_ANNOUNCE', 'it', '{NAME} e'' il PRIMO a uccidere un boss! +{PTS} Gloria!'),
('EVENT_FIRST_BOSS_ANNOUNCE', 'en', '{NAME} is the FIRST to kill a boss! +{PTS} Glory!'),
('EVENT_FIRST_BOSS_ANNOUNCE', 'de', '{NAME} ist der ERSTE der einen Boss totet! +{PTS} Ruhm!'),
('EVENT_FIRST_BOSS_ANNOUNCE', 'es', '{NAME} es el PRIMERO en matar un jefe! +{PTS} Gloria!'),
('EVENT_FIRST_BOSS_ANNOUNCE', 'fr', '{NAME} est le PREMIER a tuer un boss! +{PTS} Gloire!'),
('EVENT_FIRST_BOSS_ANNOUNCE', 'pt', '{NAME} e o PRIMEIRO a matar um chefe! +{PTS} Gloria!'),

('HUNTER_LOTTERY', 'it', 'HUNTER ESTRAZIONE'),
('HUNTER_LOTTERY', 'en', 'HUNTER LOTTERY'),
('HUNTER_LOTTERY', 'de', 'JAGER VERLOSUNG'),
('HUNTER_LOTTERY', 'es', 'SORTEO CAZADOR'),
('HUNTER_LOTTERY', 'fr', 'TIRAGE CHASSEUR'),
('HUNTER_LOTTERY', 'pt', 'SORTEIO CACADOR'),

('EVENT_LOTTERY_WIN', 'it', '{NAME} ha vinto +{PTS} Gloria!'),
('EVENT_LOTTERY_WIN', 'en', '{NAME} won +{PTS} Glory!'),
('EVENT_LOTTERY_WIN', 'de', '{NAME} hat +{PTS} Ruhm gewonnen!'),
('EVENT_LOTTERY_WIN', 'es', '{NAME} gano +{PTS} Gloria!'),
('EVENT_LOTTERY_WIN', 'fr', '{NAME} a gagne +{PTS} Gloire!'),
('EVENT_LOTTERY_WIN', 'pt', '{NAME} ganhou +{PTS} Gloria!'),

('EVENT_CONGRATS', 'it', 'Congratulazioni al vincitore dell''evento {EVENT}!'),
('EVENT_CONGRATS', 'en', 'Congratulations to the winner of {EVENT} event!'),
('EVENT_CONGRATS', 'de', 'Herzlichen Gluckwunsch an den Gewinner des {EVENT} Events!'),
('EVENT_CONGRATS', 'es', 'Felicitaciones al ganador del evento {EVENT}!'),
('EVENT_CONGRATS', 'fr', 'Felicitations au gagnant de l''evenement {EVENT}!'),
('EVENT_CONGRATS', 'pt', 'Parabens ao vencedor do evento {EVENT}!'),

('EVENT_LOTTERY_TITLE', 'it', '[!!!] HAI VINTO L''ESTRAZIONE! [!!!]'),
('EVENT_LOTTERY_TITLE', 'en', '[!!!] YOU WON THE LOTTERY! [!!!]'),
('EVENT_LOTTERY_TITLE', 'de', '[!!!] DU HAST DIE VERLOSUNG GEWONNEN! [!!!]'),
('EVENT_LOTTERY_TITLE', 'es', '[!!!] GANASTE EL SORTEO! [!!!]'),
('EVENT_LOTTERY_TITLE', 'fr', '[!!!] TU AS GAGNE LE TIRAGE! [!!!]'),
('EVENT_LOTTERY_TITLE', 'pt', '[!!!] VOCE GANHOU O SORTEIO! [!!!]'),

('EVENT_LOTTERY_EXTRACTED', 'it', 'Sei stato estratto tra i partecipanti!'),
('EVENT_LOTTERY_EXTRACTED', 'en', 'You were drawn among the participants!'),
('EVENT_LOTTERY_EXTRACTED', 'de', 'Du wurdest unter den Teilnehmern ausgelost!'),
('EVENT_LOTTERY_EXTRACTED', 'es', 'Fuiste sorteado entre los participantes!'),
('EVENT_LOTTERY_EXTRACTED', 'fr', 'Tu as ete tire au sort parmi les participants!'),
('EVENT_LOTTERY_EXTRACTED', 'pt', 'Voce foi sorteado entre os participantes!')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- DEFENSE SYSTEM
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('DEFENSE_PARTY_START', 'it', '[HUNTER] DIFESA INIZIATA! Uccidete {MOBS} mob in {SECONDS} secondi!'),
('DEFENSE_PARTY_START', 'en', '[HUNTER] DEFENSE STARTED! Kill {MOBS} mobs in {SECONDS} seconds!'),
('DEFENSE_PARTY_START', 'de', '[HUNTER] VERTEIDIGUNG GESTARTET! Totet {MOBS} Mobs in {SECONDS} Sekunden!'),
('DEFENSE_PARTY_START', 'es', '[HUNTER] DEFENSA INICIADA! Mata {MOBS} mobs en {SECONDS} segundos!'),
('DEFENSE_PARTY_START', 'fr', '[HUNTER] DEFENSE COMMENCEE! Tuez {MOBS} mobs en {SECONDS} secondes!'),
('DEFENSE_PARTY_START', 'pt', '[HUNTER] DEFESA INICIADA! Mate {MOBS} mobs em {SECONDS} segundos!'),

('DEFENSE_SUCCESS', 'it', '[HUNTER] DIFESA COMPLETATA CON SUCCESSO!'),
('DEFENSE_SUCCESS', 'en', '[HUNTER] DEFENSE COMPLETED SUCCESSFULLY!'),
('DEFENSE_SUCCESS', 'de', '[HUNTER] VERTEIDIGUNG ERFOLGREICH ABGESCHLOSSEN!'),
('DEFENSE_SUCCESS', 'es', '[HUNTER] DEFENSA COMPLETADA CON EXITO!'),
('DEFENSE_SUCCESS', 'fr', '[HUNTER] DEFENSE TERMINEE AVEC SUCCES!'),
('DEFENSE_SUCCESS', 'pt', '[HUNTER] DEFESA COMPLETA COM SUCESSO!'),

('DEFENSE_FAILED_DESTROYED', 'it', '[HUNTER] DIFESA FALLITA! {REASON} - La Frattura Rank {RANK} e'' stata DISTRUTTA!'),
('DEFENSE_FAILED_DESTROYED', 'en', '[HUNTER] DEFENSE FAILED! {REASON} - The {RANK} Rank Rift has been DESTROYED!'),
('DEFENSE_FAILED_DESTROYED', 'de', '[HUNTER] VERTEIDIGUNG FEHLGESCHLAGEN! {REASON} - Die {RANK} Rang Fraktur wurde ZERSTORT!'),
('DEFENSE_FAILED_DESTROYED', 'es', '[HUNTER] DEFENSA FALLIDA! {REASON} - La Fractura Rango {RANK} ha sido DESTRUIDA!'),
('DEFENSE_FAILED_DESTROYED', 'fr', '[HUNTER] DEFENSE ECHOUEE! {REASON} - La Faille Rang {RANK} a ete DETRUITE!'),
('DEFENSE_FAILED_DESTROYED', 'pt', '[HUNTER] DEFESA FALHOU! {REASON} - A Fratura Rank {RANK} foi DESTRUIDA!'),

('DEFENSE_FAILED_RETRY', 'it', '[HUNTER] DIFESA FALLITA! {REASON} - La Frattura Rank {RANK} e'' ancora li, puoi riprovare!'),
('DEFENSE_FAILED_RETRY', 'en', '[HUNTER] DEFENSE FAILED! {REASON} - The {RANK} Rank Rift is still there, you can retry!'),
('DEFENSE_FAILED_RETRY', 'de', '[HUNTER] VERTEIDIGUNG FEHLGESCHLAGEN! {REASON} - Die {RANK} Rang Fraktur ist noch da, du kannst es erneut versuchen!'),
('DEFENSE_FAILED_RETRY', 'es', '[HUNTER] DEFENSA FALLIDA! {REASON} - La Fractura Rango {RANK} sigue ahi, puedes reintentar!'),
('DEFENSE_FAILED_RETRY', 'fr', '[HUNTER] DEFENSE ECHOUEE! {REASON} - La Faille Rang {RANK} est toujours la, tu peux reessayer!'),
('DEFENSE_FAILED_RETRY', 'pt', '[HUNTER] DEFESA FALHOU! {REASON} - A Fratura Rank {RANK} ainda esta la, voce pode tentar novamente!'),

('DEFENSE_FAILED', 'it', 'DIFESA FALLITA!'),
('DEFENSE_FAILED', 'en', 'DEFENSE FAILED!'),
('DEFENSE_FAILED', 'de', 'VERTEIDIGUNG FEHLGESCHLAGEN!'),
('DEFENSE_FAILED', 'es', 'DEFENSA FALLIDA!'),
('DEFENSE_FAILED', 'fr', 'DEFENSE ECHOUEE!'),
('DEFENSE_FAILED', 'pt', 'DEFESA FALHOU!'),

('DEFENSE_DESTROYED', 'it', 'La Frattura {RANK} e'' stata DISTRUTTA!'),
('DEFENSE_DESTROYED', 'en', 'The {RANK} Rift has been DESTROYED!'),
('DEFENSE_DESTROYED', 'de', 'Die {RANK} Fraktur wurde ZERSTORT!'),
('DEFENSE_DESTROYED', 'es', 'La Fractura {RANK} ha sido DESTRUIDA!'),
('DEFENSE_DESTROYED', 'fr', 'La Faille {RANK} a ete DETRUITE!'),
('DEFENSE_DESTROYED', 'pt', 'A Fratura {RANK} foi DESTRUIDA!'),

('DEFENSE_HIGH_RANK_WARNING1', 'it', 'Le fratture di Rank B e superiori'),
('DEFENSE_HIGH_RANK_WARNING1', 'en', 'Rank B and higher rifts'),
('DEFENSE_HIGH_RANK_WARNING1', 'de', 'Rang B und hohere Frakturen'),
('DEFENSE_HIGH_RANK_WARNING1', 'es', 'Las fracturas de Rango B y superiores'),
('DEFENSE_HIGH_RANK_WARNING1', 'fr', 'Les failles de Rang B et superieur'),
('DEFENSE_HIGH_RANK_WARNING1', 'pt', 'As fraturas de Rank B e superiores'),

('DEFENSE_HIGH_RANK_WARNING2', 'it', 'vengono distrutte se fallisci la difesa.'),
('DEFENSE_HIGH_RANK_WARNING2', 'en', 'are destroyed if you fail the defense.'),
('DEFENSE_HIGH_RANK_WARNING2', 'de', 'werden zerstort wenn du die Verteidigung nicht schaffst.'),
('DEFENSE_HIGH_RANK_WARNING2', 'es', 'son destruidas si fallas la defensa.'),
('DEFENSE_HIGH_RANK_WARNING2', 'fr', 'sont detruites si tu echoues la defense.'),
('DEFENSE_HIGH_RANK_WARNING2', 'pt', 'sao destruidas se voce falhar na defesa.'),

('DEFENSE_SORRY', 'it', 'Mi dispiace, Hunter. Buona caccia!'),
('DEFENSE_SORRY', 'en', 'Sorry, Hunter. Good hunting!'),
('DEFENSE_SORRY', 'de', 'Tut mir leid, Jager. Gute Jagd!'),
('DEFENSE_SORRY', 'es', 'Lo siento, Cazador. Buena caza!'),
('DEFENSE_SORRY', 'fr', 'Desole, Chasseur. Bonne chasse!'),
('DEFENSE_SORRY', 'pt', 'Desculpe, Cacador. Boa caca!'),

('DEFENSE_STILL_AVAILABLE', 'it', 'La Frattura {RANK} e'' ancora disponibile.'),
('DEFENSE_STILL_AVAILABLE', 'en', 'The {RANK} Rift is still available.'),
('DEFENSE_STILL_AVAILABLE', 'de', 'Die {RANK} Fraktur ist noch verfugbar.'),
('DEFENSE_STILL_AVAILABLE', 'es', 'La Fractura {RANK} aun esta disponible.'),
('DEFENSE_STILL_AVAILABLE', 'fr', 'La Faille {RANK} est encore disponible.'),
('DEFENSE_STILL_AVAILABLE', 'pt', 'A Fratura {RANK} ainda esta disponivel.'),

('DEFENSE_CAN_RETRY', 'it', 'Puoi riprovare la difesa!'),
('DEFENSE_CAN_RETRY', 'en', 'You can retry the defense!'),
('DEFENSE_CAN_RETRY', 'de', 'Du kannst die Verteidigung erneut versuchen!'),
('DEFENSE_CAN_RETRY', 'es', 'Puedes reintentar la defensa!'),
('DEFENSE_CAN_RETRY', 'fr', 'Tu peux reessayer la defense!'),
('DEFENSE_CAN_RETRY', 'pt', 'Voce pode tentar a defesa novamente!')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ITEM MESSAGES (hunter_items.lua)
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('ITEM_SCANNER_ACTIVE', 'it', 'Scanner in funzione... Frattura rilevata!'),
('ITEM_SCANNER_ACTIVE', 'en', 'Scanner active... Rift detected!'),
('ITEM_SCANNER_ACTIVE', 'de', 'Scanner aktiv... Fraktur entdeckt!'),
('ITEM_SCANNER_ACTIVE', 'es', 'Escaner activo... Fractura detectada!'),
('ITEM_SCANNER_ACTIVE', 'fr', 'Scanner actif... Faille detectee!'),
('ITEM_SCANNER_ACTIVE', 'pt', 'Scanner ativo... Fratura detectada!'),

('ITEM_STABILIZER_TITLE', 'it', 'STABILIZZATORE DI RANGO'),
('ITEM_STABILIZER_TITLE', 'en', 'RANK STABILIZER'),
('ITEM_STABILIZER_TITLE', 'de', 'RANG STABILISATOR'),
('ITEM_STABILIZER_TITLE', 'es', 'ESTABILIZADOR DE RANGO'),
('ITEM_STABILIZER_TITLE', 'fr', 'STABILISATEUR DE RANG'),
('ITEM_STABILIZER_TITLE', 'pt', 'ESTABILIZADOR DE RANK'),

('ITEM_STABILIZER_DESC1', 'it', 'L''artefatto risuona, pronto a piegare la realta''.'),
('ITEM_STABILIZER_DESC1', 'en', 'The artifact resonates, ready to bend reality.'),
('ITEM_STABILIZER_DESC1', 'de', 'Das Artefakt resoniert, bereit die Realitat zu biegen.'),
('ITEM_STABILIZER_DESC1', 'es', 'El artefacto resuena, listo para doblar la realidad.'),
('ITEM_STABILIZER_DESC1', 'fr', 'L''artefact resonne, pret a plier la realite.'),
('ITEM_STABILIZER_DESC1', 'pt', 'O artefato ressoa, pronto para dobrar a realidade.'),

('ITEM_STABILIZER_DESC2', 'it', 'Focalizzati sull''energia che desideri richiamare.'),
('ITEM_STABILIZER_DESC2', 'en', 'Focus on the energy you wish to summon.'),
('ITEM_STABILIZER_DESC2', 'de', 'Fokussiere auf die Energie die du beschworen mochtest.'),
('ITEM_STABILIZER_DESC2', 'es', 'Concentrate en la energia que deseas invocar.'),
('ITEM_STABILIZER_DESC2', 'fr', 'Concentre-toi sur l''energie que tu souhaites invoquer.'),
('ITEM_STABILIZER_DESC2', 'pt', 'Foque na energia que voce deseja invocar.'),

('ITEM_NO_FRACTURES', 'it', 'Nessuna frattura disponibile nei registri.'),
('ITEM_NO_FRACTURES', 'en', 'No rifts available in the registry.'),
('ITEM_NO_FRACTURES', 'de', 'Keine Frakturen in den Registern verfugbar.'),
('ITEM_NO_FRACTURES', 'es', 'No hay fracturas disponibles en los registros.'),
('ITEM_NO_FRACTURES', 'fr', 'Aucune faille disponible dans les registres.'),
('ITEM_NO_FRACTURES', 'pt', 'Nenhuma fratura disponivel nos registros.'),

('RANK', 'it', 'Rango'),
('RANK', 'en', 'Rank'),
('RANK', 'de', 'Rang'),
('RANK', 'es', 'Rango'),
('RANK', 'fr', 'Rang'),
('RANK', 'pt', 'Rank'),

('CANCEL', 'it', 'Annulla'),
('CANCEL', 'en', 'Cancel'),
('CANCEL', 'de', 'Abbrechen'),
('CANCEL', 'es', 'Cancelar'),
('CANCEL', 'fr', 'Annuler'),
('CANCEL', 'pt', 'Cancelar'),

('ITEM_FRACTURE_SUMMONED', 'it', 'Frattura {RANK} evocata!'),
('ITEM_FRACTURE_SUMMONED', 'en', '{RANK} Rift summoned!'),
('ITEM_FRACTURE_SUMMONED', 'de', '{RANK} Fraktur beschworen!'),
('ITEM_FRACTURE_SUMMONED', 'es', 'Fractura {RANK} invocada!'),
('ITEM_FRACTURE_SUMMONED', 'fr', 'Faille {RANK} invoquee!'),
('ITEM_FRACTURE_SUMMONED', 'pt', 'Fratura {RANK} invocada!'),

('ITEM_FOCUS_SPEAK', 'it', 'I tuoi sensi si acuiscono. Il flusso di Gloria dalla prossima minaccia sara'' amplificato.'),
('ITEM_FOCUS_SPEAK', 'en', 'Your senses sharpen. Glory flow from the next threat will be amplified.'),
('ITEM_FOCUS_SPEAK', 'de', 'Deine Sinne verscharfen sich. Der Ruhmfluss von der nachsten Bedrohung wird verstarkt.'),
('ITEM_FOCUS_SPEAK', 'es', 'Tus sentidos se agudizan. El flujo de Gloria de la proxima amenaza sera amplificado.'),
('ITEM_FOCUS_SPEAK', 'fr', 'Tes sens s''aiguisent. Le flux de Gloire de la prochaine menace sera amplifie.'),
('ITEM_FOCUS_SPEAK', 'pt', 'Seus sentidos se aguçam. O fluxo de Gloria da proxima ameaca sera amplificado.'),

('ITEM_FOCUS_SYSCHAT', 'it', 'Effetto Focus attivo: la tua percezione delle ricompense e'' aumentata.'),
('ITEM_FOCUS_SYSCHAT', 'en', 'Focus effect active: your reward perception is increased.'),
('ITEM_FOCUS_SYSCHAT', 'de', 'Fokus Effekt aktiv: Deine Belohnungswahrnehmung ist erhoht.'),
('ITEM_FOCUS_SYSCHAT', 'es', 'Efecto Foco activo: tu percepcion de recompensas ha aumentado.'),
('ITEM_FOCUS_SYSCHAT', 'fr', 'Effet Focus actif: ta perception des recompenses est augmentee.'),
('ITEM_FOCUS_SYSCHAT', 'pt', 'Efeito Foco ativo: sua percepcao de recompensas foi aumentada.'),

('ITEM_DIMKEY_SPEAK', 'it', 'La Chiave Dimensionale si attiva... Il prossimo baule rivelera'' i suoi tesori nascosti!'),
('ITEM_DIMKEY_SPEAK', 'en', 'The Dimensional Key activates... The next chest will reveal its hidden treasures!'),
('ITEM_DIMKEY_SPEAK', 'de', 'Der Dimensionsschlussel aktiviert sich... Die nachste Truhe wird ihre verborgenen Schatze enthullen!'),
('ITEM_DIMKEY_SPEAK', 'es', 'La Llave Dimensional se activa... El proximo cofre revelara sus tesoros ocultos!'),
('ITEM_DIMKEY_SPEAK', 'fr', 'La Cle Dimensionnelle s''active... Le prochain coffre revelera ses tresors caches!'),
('ITEM_DIMKEY_SPEAK', 'pt', 'A Chave Dimensional se ativa... O proximo bau revelara seus tesouros escondidos!'),

('ITEM_DIMKEY_SYSCHAT', 'it', 'Il prossimo baule garantira'' un bonus Gloria extra!'),
('ITEM_DIMKEY_SYSCHAT', 'en', 'The next chest will guarantee extra Glory bonus!'),
('ITEM_DIMKEY_SYSCHAT', 'de', 'Die nachste Truhe wird einen extra Ruhm Bonus garantieren!'),
('ITEM_DIMKEY_SYSCHAT', 'es', 'El proximo cofre garantizara un bonus de Gloria extra!'),
('ITEM_DIMKEY_SYSCHAT', 'fr', 'Le prochain coffre garantira un bonus de Gloire supplementaire!'),
('ITEM_DIMKEY_SYSCHAT', 'pt', 'O proximo bau garantira um bonus de Gloria extra!'),

('ITEM_SEAL_SPEAK', 'it', 'Il Sigillo pulsa con potere... La prossima Frattura che toccherai verra'' immediatamente soggiogata.'),
('ITEM_SEAL_SPEAK', 'en', 'The Seal pulses with power... The next Rift you touch will be immediately subdued.'),
('ITEM_SEAL_SPEAK', 'de', 'Das Siegel pulsiert mit Kraft... Die nachste Fraktur die du beruhrst wird sofort unterworfen.'),
('ITEM_SEAL_SPEAK', 'es', 'El Sello pulsa con poder... La proxima Fractura que toques sera inmediatamente sometida.'),
('ITEM_SEAL_SPEAK', 'fr', 'Le Sceau pulse de pouvoir... La prochaine Faille que tu touches sera immediatement soumise.'),
('ITEM_SEAL_SPEAK', 'pt', 'O Selo pulsa com poder... A proxima Fratura que voce tocar sera imediatamente subjugada.'),

('ITEM_SEAL_SYSCHAT', 'it', 'L''energia del Sigillo ti permettera'' di saltare la fase di difesa.'),
('ITEM_SEAL_SYSCHAT', 'en', 'The Seal''s energy will allow you to skip the defense phase.'),
('ITEM_SEAL_SYSCHAT', 'de', 'Die Energie des Siegels ermoglicht es dir die Verteidigungsphase zu uberspringen.'),
('ITEM_SEAL_SYSCHAT', 'es', 'La energia del Sello te permitira saltarte la fase de defensa.'),
('ITEM_SEAL_SYSCHAT', 'fr', 'L''energie du Sceau te permettra de sauter la phase de defense.'),
('ITEM_SEAL_SYSCHAT', 'pt', 'A energia do Selo permitira que voce pule a fase de defesa.'),

('ITEM_SIGNAL_SPEAK', 'it', 'Il segnale inviato al Sistema. La prossima minaccia sara'' designata come bersaglio ad alta priorita''.'),
('ITEM_SIGNAL_SPEAK', 'en', 'Signal sent to the System. The next threat will be designated as high priority target.'),
('ITEM_SIGNAL_SPEAK', 'de', 'Signal an das System gesendet. Die nachste Bedrohung wird als hochprioritares Ziel markiert.'),
('ITEM_SIGNAL_SPEAK', 'es', 'Senal enviada al Sistema. La proxima amenaza sera designada como objetivo de alta prioridad.'),
('ITEM_SIGNAL_SPEAK', 'fr', 'Signal envoye au Systeme. La prochaine menace sera designee comme cible haute priorite.'),
('ITEM_SIGNAL_SPEAK', 'pt', 'Sinal enviado ao Sistema. A proxima ameaca sera designada como alvo de alta prioridade.'),

('ITEM_SIGNAL_SYSCHAT', 'it', 'Una Missione d''Emergenza verra'' attivata contro il prossimo bersaglio Elite.'),
('ITEM_SIGNAL_SYSCHAT', 'en', 'An Emergency Mission will be activated against the next Elite target.'),
('ITEM_SIGNAL_SYSCHAT', 'de', 'Eine Notfallmission wird gegen das nachste Elite Ziel aktiviert.'),
('ITEM_SIGNAL_SYSCHAT', 'es', 'Una Mision de Emergencia sera activada contra el proximo objetivo Elite.'),
('ITEM_SIGNAL_SYSCHAT', 'fr', 'Une Mission d''Urgence sera activee contre la prochaine cible Elite.'),
('ITEM_SIGNAL_SYSCHAT', 'pt', 'Uma Missao de Emergencia sera ativada contra o proximo alvo Elite.'),

('ITEM_RESONATOR_NOPARTY', 'it', 'Devi essere in un party per usare questo oggetto!'),
('ITEM_RESONATOR_NOPARTY', 'en', 'You must be in a party to use this item!'),
('ITEM_RESONATOR_NOPARTY', 'de', 'Du musst in einer Gruppe sein um diesen Gegenstand zu benutzen!'),
('ITEM_RESONATOR_NOPARTY', 'es', 'Debes estar en un grupo para usar este objeto!'),
('ITEM_RESONATOR_NOPARTY', 'fr', 'Tu dois etre dans un groupe pour utiliser cet objet!'),
('ITEM_RESONATOR_NOPARTY', 'pt', 'Voce deve estar em um grupo para usar este item!'),

('ITEM_RESONATOR_SPEAK', 'it', 'RISONANZA DI GRUPPO ATTIVATA! +20% Gloria per il party sulla prossima kill elite!'),
('ITEM_RESONATOR_SPEAK', 'en', 'GROUP RESONANCE ACTIVATED! +20% Glory for party on next elite kill!'),
('ITEM_RESONATOR_SPEAK', 'de', 'GRUPPENRESONANZ AKTIVIERT! +20% Ruhm fur die Gruppe beim nachsten Elite Kill!'),
('ITEM_RESONATOR_SPEAK', 'es', 'RESONANCIA DE GRUPO ACTIVADA! +20% Gloria para el grupo en la proxima muerte elite!'),
('ITEM_RESONATOR_SPEAK', 'fr', 'RESONANCE DE GROUPE ACTIVEE! +20% Gloire pour le groupe sur le prochain kill elite!'),
('ITEM_RESONATOR_SPEAK', 'pt', 'RESSONANCIA DE GRUPO ATIVADA! +20% Gloria para o grupo na proxima morte elite!'),

('ITEM_RESONATOR_SYSCHAT', 'it', 'Risonatore attivato! Il party riceve +20% Gloria sulla prossima kill elite!'),
('ITEM_RESONATOR_SYSCHAT', 'en', 'Resonator activated! Party receives +20% Glory on next elite kill!'),
('ITEM_RESONATOR_SYSCHAT', 'de', 'Resonator aktiviert! Gruppe erhalt +20% Ruhm beim nachsten Elite Kill!'),
('ITEM_RESONATOR_SYSCHAT', 'es', 'Resonador activado! El grupo recibe +20% Gloria en la proxima muerte elite!'),
('ITEM_RESONATOR_SYSCHAT', 'fr', 'Resonateur active! Le groupe recoit +20% Gloire sur le prochain kill elite!'),
('ITEM_RESONATOR_SYSCHAT', 'pt', 'Ressoador ativado! O grupo recebe +20% Gloria na proxima morte elite!'),

('ITEM_CALIBRATOR_SPEAK', 'it', 'Il Calibratore altera le costanti. Le anomalie di basso livello verranno filtrate dal prossimo scan.'),
('ITEM_CALIBRATOR_SPEAK', 'en', 'The Calibrator alters constants. Low level anomalies will be filtered from the next scan.'),
('ITEM_CALIBRATOR_SPEAK', 'de', 'Der Kalibrator verandert Konstanten. Niedrige Anomalien werden beim nachsten Scan gefiltert.'),
('ITEM_CALIBRATOR_SPEAK', 'es', 'El Calibrador altera las constantes. Las anomalias de bajo nivel seran filtradas del proximo escaneo.'),
('ITEM_CALIBRATOR_SPEAK', 'fr', 'Le Calibrateur modifie les constantes. Les anomalies de bas niveau seront filtrees du prochain scan.'),
('ITEM_CALIBRATOR_SPEAK', 'pt', 'O Calibrador altera as constantes. As anomalias de baixo nivel serao filtradas do proximo scan.'),

('ITEM_CALIBRATOR_SYSCHAT', 'it', 'Il Calibratore e'' attivo: la prossima frattura casuale sara'' di Rango C o superiore.'),
('ITEM_CALIBRATOR_SYSCHAT', 'en', 'Calibrator is active: the next random rift will be Rank C or higher.'),
('ITEM_CALIBRATOR_SYSCHAT', 'de', 'Kalibrator ist aktiv: die nachste zufallige Fraktur wird Rang C oder hoher sein.'),
('ITEM_CALIBRATOR_SYSCHAT', 'es', 'El Calibrador esta activo: la proxima fractura aleatoria sera de Rango C o superior.'),
('ITEM_CALIBRATOR_SYSCHAT', 'fr', 'Le Calibrateur est actif: la prochaine faille aleatoire sera de Rang C ou superieur.'),
('ITEM_CALIBRATOR_SYSCHAT', 'pt', 'O Calibrador esta ativo: a proxima fratura aleatoria sera Rank C ou superior.'),

('ITEM_MONARCH_DETECTED', 'it', 'Potere assoluto. Una Frattura {RANK} squarcia la realta''.'),
('ITEM_MONARCH_DETECTED', 'en', 'Absolute power. A {RANK} Rift tears through reality.'),
('ITEM_MONARCH_DETECTED', 'de', 'Absolute Macht. Eine {RANK} Fraktur zerreist die Realitat.'),
('ITEM_MONARCH_DETECTED', 'es', 'Poder absoluto. Una Fractura {RANK} desgarra la realidad.'),
('ITEM_MONARCH_DETECTED', 'fr', 'Pouvoir absolu. Une Faille {RANK} dechire la realite.'),
('ITEM_MONARCH_DETECTED', 'pt', 'Poder absoluto. Uma Fratura {RANK} rasga a realidade.'),

('FOCUS_ACTIVE', 'it', 'FOCUS ATTIVO.'),
('FOCUS_ACTIVE', 'en', 'FOCUS ACTIVE.'),
('FOCUS_ACTIVE', 'de', 'FOKUS AKTIV.'),
('FOCUS_ACTIVE', 'es', 'FOCO ACTIVO.'),
('FOCUS_ACTIVE', 'fr', 'FOCUS ACTIF.'),
('FOCUS_ACTIVE', 'pt', 'FOCO ATIVO.'),

('ITEM_NO_SRANK', 'it', 'Nessuna Frattura di Rango S trovata nei registri del Sistema.'),
('ITEM_NO_SRANK', 'en', 'No S-Rank Rift found in System registry.'),
('ITEM_NO_SRANK', 'de', 'Keine S-Rang Fraktur im Systemregister gefunden.'),
('ITEM_NO_SRANK', 'es', 'No se encontro ninguna Fractura Rango S en los registros del Sistema.'),
('ITEM_NO_SRANK', 'fr', 'Aucune Faille Rang S trouvee dans les registres du Systeme.'),
('ITEM_NO_SRANK', 'pt', 'Nenhuma Fratura Rank S encontrada nos registros do Sistema.')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- ADDITIONAL SERVER-SIDE MESSAGES (Glory, Shop, Achievements, etc.)
-- ═══════════════════════════════════════════════════════════════════════════════

-- COMMON WORDS
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('GLORY', 'it', 'Gloria'),
('GLORY', 'en', 'Glory'),
('GLORY', 'de', 'Ruhm'),
('GLORY', 'es', 'Gloria'),
('GLORY', 'fr', 'Gloire'),
('GLORY', 'pt', 'Gloria'),

('TOTAL', 'it', 'TOTALE'),
('TOTAL', 'en', 'TOTAL'),
('TOTAL', 'de', 'GESAMT'),
('TOTAL', 'es', 'TOTAL'),
('TOTAL', 'fr', 'TOTAL'),
('TOTAL', 'pt', 'TOTAL'),

('SYSTEM', 'it', 'SISTEMA'),
('SYSTEM', 'en', 'SYSTEM'),
('SYSTEM', 'de', 'SYSTEM'),
('SYSTEM', 'es', 'SISTEMA'),
('SYSTEM', 'fr', 'SYSTEME'),
('SYSTEM', 'pt', 'SISTEMA'),

('KILLED', 'it', 'ucciso'),
('KILLED', 'en', 'killed'),
('KILLED', 'de', 'getotet'),
('KILLED', 'es', 'matado'),
('KILLED', 'fr', 'tue'),
('KILLED', 'pt', 'morto'),

('COMPLETED', 'it', 'completato'),
('COMPLETED', 'en', 'completed'),
('COMPLETED', 'de', 'abgeschlossen'),
('COMPLETED', 'es', 'completado'),
('COMPLETED', 'fr', 'complete'),
('COMPLETED', 'pt', 'completo'),

('REWARD', 'it', 'RICOMPENSA'),
('REWARD', 'en', 'REWARD'),
('REWARD', 'de', 'BELOHNUNG'),
('REWARD', 'es', 'RECOMPENSA'),
('REWARD', 'fr', 'RECOMPENSE'),
('REWARD', 'pt', 'RECOMPENSA'),

('ACHIEVEMENT', 'it', 'TRAGUARDO'),
('ACHIEVEMENT', 'en', 'ACHIEVEMENT'),
('ACHIEVEMENT', 'de', 'ERFOLG'),
('ACHIEVEMENT', 'es', 'LOGRO'),
('ACHIEVEMENT', 'fr', 'SUCCES'),
('ACHIEVEMENT', 'pt', 'CONQUISTA'),

('LOTTERY', 'it', 'ESTRAZIONE'),
('LOTTERY', 'en', 'LOTTERY'),
('LOTTERY', 'de', 'VERLOSUNG'),
('LOTTERY', 'es', 'SORTEO'),
('LOTTERY', 'fr', 'TIRAGE'),
('LOTTERY', 'pt', 'SORTEIO'),

('RESONANCE', 'it', 'RISONANZA'),
('RESONANCE', 'en', 'RESONANCE'),
('RESONANCE', 'de', 'RESONANZ'),
('RESONANCE', 'es', 'RESONANCIA'),
('RESONANCE', 'fr', 'RESONANCE'),
('RESONANCE', 'pt', 'RESSONANCIA')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- GLORY DETAILS
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('GLORY_DETAIL_HEADER', 'it', '========== DETTAGLIO GLORIA ========='),
('GLORY_DETAIL_HEADER', 'en', '========== GLORY DETAILS ========='),
('GLORY_DETAIL_HEADER', 'de', '========== RUHM DETAILS ========='),
('GLORY_DETAIL_HEADER', 'es', '========== DETALLE DE GLORIA ========='),
('GLORY_DETAIL_HEADER', 'fr', '========== DETAILS GLOIRE ========='),
('GLORY_DETAIL_HEADER', 'pt', '========== DETALHES DE GLORIA ========='),

('GLORY_DETAIL_FOOTER', 'it', '======================================'),
('GLORY_DETAIL_FOOTER', 'en', '======================================'),
('GLORY_DETAIL_FOOTER', 'de', '======================================'),
('GLORY_DETAIL_FOOTER', 'es', '======================================'),
('GLORY_DETAIL_FOOTER', 'fr', '======================================'),
('GLORY_DETAIL_FOOTER', 'pt', '======================================'),

('GLORY_BASE', 'it', 'Gloria Base'),
('GLORY_BASE', 'en', 'Base Glory'),
('GLORY_BASE', 'de', 'Basis Ruhm'),
('GLORY_BASE', 'es', 'Gloria Base'),
('GLORY_BASE', 'fr', 'Gloire de Base'),
('GLORY_BASE', 'pt', 'Gloria Base'),

('GLORY_EXTRA', 'it', 'Gloria Extra'),
('GLORY_EXTRA', 'en', 'Extra Glory'),
('GLORY_EXTRA', 'de', 'Extra Ruhm'),
('GLORY_EXTRA', 'es', 'Gloria Extra'),
('GLORY_EXTRA', 'fr', 'Gloire Bonus'),
('GLORY_EXTRA', 'pt', 'Gloria Extra'),

('MERITOCRACY_DIST', 'it', '--- Distribuzione per Meritocrazia (Power Rank) ---'),
('MERITOCRACY_DIST', 'en', '--- Meritocracy Distribution (Power Rank) ---'),
('MERITOCRACY_DIST', 'de', '--- Leistungsbasierte Verteilung (Power Rank) ---'),
('MERITOCRACY_DIST', 'es', '--- Distribucion por Meritocracia (Power Rank) ---'),
('MERITOCRACY_DIST', 'fr', '--- Distribution par Meritocratie (Power Rank) ---'),
('MERITOCRACY_DIST', 'pt', '--- Distribuicao por Meritocracia (Power Rank) ---')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- EVENT MESSAGES
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('EVENT_REGISTERED', 'it', 'Sei iscritto all''estrazione finale!'),
('EVENT_REGISTERED', 'en', 'You are registered for the final draw!'),
('EVENT_REGISTERED', 'de', 'Du bist fur die Endauslosung registriert!'),
('EVENT_REGISTERED', 'es', 'Estas inscrito en el sorteo final!'),
('EVENT_REGISTERED', 'fr', 'Tu es inscrit au tirage final!'),
('EVENT_REGISTERED', 'pt', 'Voce esta inscrito no sorteio final!'),

('EVENT_LOTTERY_END', 'it', 'Sorteggio a fine evento: +{PTS} Gloria!'),
('EVENT_LOTTERY_END', 'en', 'Draw at event end: +{PTS} Glory!'),
('EVENT_LOTTERY_END', 'de', 'Auslosung am Eventende: +{PTS} Ruhm!'),
('EVENT_LOTTERY_END', 'es', 'Sorteo al final del evento: +{PTS} Gloria!'),
('EVENT_LOTTERY_END', 'fr', 'Tirage en fin d''evenement: +{PTS} Gloire!'),
('EVENT_LOTTERY_END', 'pt', 'Sorteio no final do evento: +{PTS} Gloria!'),

('EVENT_ENDED', 'it', 'L''evento {EVENT} e'' terminato!'),
('EVENT_ENDED', 'en', 'The {EVENT} event has ended!'),
('EVENT_ENDED', 'de', 'Das {EVENT} Event ist beendet!'),
('EVENT_ENDED', 'es', 'El evento {EVENT} ha terminado!'),
('EVENT_ENDED', 'fr', 'L''evenement {EVENT} est termine!'),
('EVENT_ENDED', 'pt', 'O evento {EVENT} terminou!'),

('LOTTERY_IN_PROGRESS', 'it', 'Sorteggio vincitore in corso...'),
('LOTTERY_IN_PROGRESS', 'en', 'Winner draw in progress...'),
('LOTTERY_IN_PROGRESS', 'de', 'Gewinnerauslosung lauft...'),
('LOTTERY_IN_PROGRESS', 'es', 'Sorteo del ganador en curso...'),
('LOTTERY_IN_PROGRESS', 'fr', 'Tirage du gagnant en cours...'),
('LOTTERY_IN_PROGRESS', 'pt', 'Sorteio do vencedor em andamento...'),

('NO_PARTICIPANTS', 'it', 'Nessun partecipante oggi. Nessun vincitore.'),
('NO_PARTICIPANTS', 'en', 'No participants today. No winner.'),
('NO_PARTICIPANTS', 'de', 'Keine Teilnehmer heute. Kein Gewinner.'),
('NO_PARTICIPANTS', 'es', 'Sin participantes hoy. Sin ganador.'),
('NO_PARTICIPANTS', 'fr', 'Aucun participant aujourd''hui. Pas de gagnant.'),
('NO_PARTICIPANTS', 'pt', 'Nenhum participante hoje. Nenhum vencedor.')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- SPEED KILL & RESONANCE
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('SPEEDKILL_ACTIVATED', 'it', 'SPEED KILL ATTIVATO! Uccidi in 60s per x2 Gloria!'),
('SPEEDKILL_ACTIVATED', 'en', 'SPEED KILL ACTIVATED! Kill in 60s for x2 Glory!'),
('SPEEDKILL_ACTIVATED', 'de', 'SPEED KILL AKTIVIERT! Tote in 60s fur x2 Ruhm!'),
('SPEEDKILL_ACTIVATED', 'es', 'SPEED KILL ACTIVADO! Mata en 60s para x2 Gloria!'),
('SPEEDKILL_ACTIVATED', 'fr', 'SPEED KILL ACTIVE! Tue en 60s pour x2 Gloire!'),
('SPEEDKILL_ACTIVATED', 'pt', 'SPEED KILL ATIVADO! Mate em 60s para x2 Gloria!'),

('RESONANCE_BONUS', 'it', '+20% Gloria di Gruppo! (+{BONUS})'),
('RESONANCE_BONUS', 'en', '+20% Group Glory! (+{BONUS})'),
('RESONANCE_BONUS', 'de', '+20% Gruppen Ruhm! (+{BONUS})'),
('RESONANCE_BONUS', 'es', '+20% Gloria de Grupo! (+{BONUS})'),
('RESONANCE_BONUS', 'fr', '+20% Gloire de Groupe! (+{BONUS})'),
('RESONANCE_BONUS', 'pt', '+20% Gloria de Grupo! (+{BONUS})')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- CHEST MESSAGES
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('DIMKEY_TREASURE', 'it', 'Tesoro nascosto rivelato!'),
('DIMKEY_TREASURE', 'en', 'Hidden treasure revealed!'),
('DIMKEY_TREASURE', 'de', 'Verborgener Schatz enthullt!'),
('DIMKEY_TREASURE', 'es', 'Tesoro oculto revelado!'),
('DIMKEY_TREASURE', 'fr', 'Tresor cache revele!'),
('DIMKEY_TREASURE', 'pt', 'Tesouro escondido revelado!'),

('CHEST_OPENED', 'it', 'Hai aperto {NAME} - +{PTS} Gloria'),
('CHEST_OPENED', 'en', 'You opened {NAME} - +{PTS} Glory'),
('CHEST_OPENED', 'de', 'Du hast {NAME} geoffnet - +{PTS} Ruhm'),
('CHEST_OPENED', 'es', 'Abriste {NAME} - +{PTS} Gloria'),
('CHEST_OPENED', 'fr', 'Tu as ouvert {NAME} - +{PTS} Gloire'),
('CHEST_OPENED', 'pt', 'Voce abriu {NAME} - +{PTS} Gloria'),

('CHEST_OPENED_ITEM', 'it', 'BAULE APERTO: OTTENUTO {ITEM}'),
('CHEST_OPENED_ITEM', 'en', 'CHEST OPENED: OBTAINED {ITEM}'),
('CHEST_OPENED_ITEM', 'de', 'TRUHE GEOFFNET: {ITEM} ERHALTEN'),
('CHEST_OPENED_ITEM', 'es', 'COFRE ABIERTO: OBTENIDO {ITEM}'),
('CHEST_OPENED_ITEM', 'fr', 'COFFRE OUVERT: {ITEM} OBTENU'),
('CHEST_OPENED_ITEM', 'pt', 'BAU ABERTO: OBTIDO {ITEM}')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- SHOP MESSAGES
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('SHOP_NOT_AVAILABLE', 'it', 'Oggetto non disponibile.'),
('SHOP_NOT_AVAILABLE', 'en', 'Item not available.'),
('SHOP_NOT_AVAILABLE', 'de', 'Gegenstand nicht verfugbar.'),
('SHOP_NOT_AVAILABLE', 'es', 'Objeto no disponible.'),
('SHOP_NOT_AVAILABLE', 'fr', 'Objet non disponible.'),
('SHOP_NOT_AVAILABLE', 'pt', 'Item nao disponivel.'),

('SHOP_NOT_HUNTER', 'it', 'Non sei un Hunter!'),
('SHOP_NOT_HUNTER', 'en', 'You are not a Hunter!'),
('SHOP_NOT_HUNTER', 'de', 'Du bist kein Jager!'),
('SHOP_NOT_HUNTER', 'es', 'No eres un Cazador!'),
('SHOP_NOT_HUNTER', 'fr', 'Tu n''es pas un Chasseur!'),
('SHOP_NOT_HUNTER', 'pt', 'Voce nao e um Cacador!'),

('SHOP_INSUFFICIENT', 'it', 'Gloria insufficiente! Hai {HAVE}, serve {NEED}'),
('SHOP_INSUFFICIENT', 'en', 'Insufficient Glory! You have {HAVE}, need {NEED}'),
('SHOP_INSUFFICIENT', 'de', 'Nicht genug Ruhm! Du hast {HAVE}, brauchst {NEED}'),
('SHOP_INSUFFICIENT', 'es', 'Gloria insuficiente! Tienes {HAVE}, necesitas {NEED}'),
('SHOP_INSUFFICIENT', 'fr', 'Gloire insuffisante! Tu as {HAVE}, besoin {NEED}'),
('SHOP_INSUFFICIENT', 'pt', 'Gloria insuficiente! Voce tem {HAVE}, precisa {NEED}'),

('SHOP_INV_FULL', 'it', 'Inventario pieno!'),
('SHOP_INV_FULL', 'en', 'Inventory full!'),
('SHOP_INV_FULL', 'de', 'Inventar voll!'),
('SHOP_INV_FULL', 'es', 'Inventario lleno!'),
('SHOP_INV_FULL', 'fr', 'Inventaire plein!'),
('SHOP_INV_FULL', 'pt', 'Inventario cheio!'),

('SHOP_PURCHASED', 'it', 'Acquistato: {ITEM} x{COUNT}'),
('SHOP_PURCHASED', 'en', 'Purchased: {ITEM} x{COUNT}'),
('SHOP_PURCHASED', 'de', 'Gekauft: {ITEM} x{COUNT}'),
('SHOP_PURCHASED', 'es', 'Comprado: {ITEM} x{COUNT}'),
('SHOP_PURCHASED', 'fr', 'Achete: {ITEM} x{COUNT}'),
('SHOP_PURCHASED', 'pt', 'Comprado: {ITEM} x{COUNT}'),

('SPENDABLE_GLORY', 'it', 'Gloria Spendibile'),
('SPENDABLE_GLORY', 'en', 'Spendable Glory'),
('SPENDABLE_GLORY', 'de', 'Verfugbarer Ruhm'),
('SPENDABLE_GLORY', 'es', 'Gloria Gastable'),
('SPENDABLE_GLORY', 'fr', 'Gloire Depensable'),
('SPENDABLE_GLORY', 'pt', 'Gloria Gastavel')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ACHIEVEMENT MESSAGES
INSERT INTO hunter_translations (translation_key, lang_code, text_value) VALUES
('ACH_NOT_FOUND', 'it', 'Non trovato.'),
('ACH_NOT_FOUND', 'en', 'Not found.'),
('ACH_NOT_FOUND', 'de', 'Nicht gefunden.'),
('ACH_NOT_FOUND', 'es', 'No encontrado.'),
('ACH_NOT_FOUND', 'fr', 'Non trouve.'),
('ACH_NOT_FOUND', 'pt', 'Nao encontrado.'),

('ACH_ALREADY_CLAIMED', 'it', 'Gia'' riscosso!'),
('ACH_ALREADY_CLAIMED', 'en', 'Already claimed!'),
('ACH_ALREADY_CLAIMED', 'de', 'Bereits eingelost!'),
('ACH_ALREADY_CLAIMED', 'es', 'Ya reclamado!'),
('ACH_ALREADY_CLAIMED', 'fr', 'Deja reclame!'),
('ACH_ALREADY_CLAIMED', 'pt', 'Ja resgatado!'),

('ACH_NOT_HUNTER', 'it', 'Non sei un Hunter!'),
('ACH_NOT_HUNTER', 'en', 'You are not a Hunter!'),
('ACH_NOT_HUNTER', 'de', 'Du bist kein Jager!'),
('ACH_NOT_HUNTER', 'es', 'No eres un Cazador!'),
('ACH_NOT_HUNTER', 'fr', 'Tu n''es pas un Chasseur!'),
('ACH_NOT_HUNTER', 'pt', 'Voce nao e um Cacador!'),

('ACH_NOT_UNLOCKED', 'it', 'Non ancora sbloccato! {PROG}/{REQ}'),
('ACH_NOT_UNLOCKED', 'en', 'Not yet unlocked! {PROG}/{REQ}'),
('ACH_NOT_UNLOCKED', 'de', 'Noch nicht freigeschaltet! {PROG}/{REQ}'),
('ACH_NOT_UNLOCKED', 'es', 'Aun no desbloqueado! {PROG}/{REQ}'),
('ACH_NOT_UNLOCKED', 'fr', 'Pas encore debloque! {PROG}/{REQ}'),
('ACH_NOT_UNLOCKED', 'pt', 'Ainda nao desbloqueado! {PROG}/{REQ}'),

('ACH_INV_FULL', 'it', 'Inventario pieno!'),
('ACH_INV_FULL', 'en', 'Inventory full!'),
('ACH_INV_FULL', 'de', 'Inventar voll!'),
('ACH_INV_FULL', 'es', 'Inventario lleno!'),
('ACH_INV_FULL', 'fr', 'Inventaire plein!'),
('ACH_INV_FULL', 'pt', 'Inventario cheio!'),

('ACH_RECEIVED', 'it', 'Ricevuto x{COUNT} oggetto!'),
('ACH_RECEIVED', 'en', 'Received x{COUNT} item!'),
('ACH_RECEIVED', 'de', 'x{COUNT} Gegenstand erhalten!'),
('ACH_RECEIVED', 'es', 'Recibido x{COUNT} objeto!'),
('ACH_RECEIVED', 'fr', 'Recu x{COUNT} objet!'),
('ACH_RECEIVED', 'pt', 'Recebido x{COUNT} item!'),

('SMART_INV_FULL', 'it', 'Inventario pieno! Riscossi {COUNT} traguardi.'),
('SMART_INV_FULL', 'en', 'Inventory full! Claimed {COUNT} achievements.'),
('SMART_INV_FULL', 'de', 'Inventar voll! {COUNT} Erfolge eingelost.'),
('SMART_INV_FULL', 'es', 'Inventario lleno! Reclamados {COUNT} logros.'),
('SMART_INV_FULL', 'fr', 'Inventaire plein! {COUNT} succes reclames.'),
('SMART_INV_FULL', 'pt', 'Inventario cheio! {COUNT} conquistas resgatadas.'),

('SMART_CLAIMED', 'it', 'Riscossi {COUNT} traguardi!'),
('SMART_CLAIMED', 'en', 'Claimed {COUNT} achievements!'),
('SMART_CLAIMED', 'de', '{COUNT} Erfolge eingelost!'),
('SMART_CLAIMED', 'es', 'Reclamados {COUNT} logros!'),
('SMART_CLAIMED', 'fr', '{COUNT} succes reclames!'),
('SMART_CLAIMED', 'pt', '{COUNT} conquistas resgatadas!'),

('SMART_NONE', 'it', 'Nessun traguardo da riscuotere.'),
('SMART_NONE', 'en', 'No achievements to claim.'),
('SMART_NONE', 'de', 'Keine Erfolge zum Einlosen.'),
('SMART_NONE', 'es', 'Ningun logro para reclamar.'),
('SMART_NONE', 'fr', 'Aucun succes a reclamer.'),
('SMART_NONE', 'pt', 'Nenhuma conquista para resgatar.'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Mission Completion Messages
-- ═══════════════════════════════════════════════════════════════════════════════

('MISSION_COMPLETED', 'it', 'MISSIONE COMPLETATA'),
('MISSION_COMPLETED', 'en', 'MISSION COMPLETED'),
('MISSION_COMPLETED', 'de', 'MISSION ABGESCHLOSSEN'),
('MISSION_COMPLETED', 'es', 'MISION COMPLETADA'),
('MISSION_COMPLETED', 'fr', 'MISSION ACCOMPLIE'),
('MISSION_COMPLETED', 'pt', 'MISSAO COMPLETA'),

('COMPLETE', 'it', 'complete'),
('COMPLETE', 'en', 'complete'),
('COMPLETE', 'de', 'abgeschlossen'),
('COMPLETE', 'es', 'completas'),
('COMPLETE', 'fr', 'terminees'),
('COMPLETE', 'pt', 'completas'),

('MISSION_COMPLETE_SPEAK', 'it', 'MISSIONE COMPLETATA! +{REWARD} GLORIA'),
('MISSION_COMPLETE_SPEAK', 'en', 'MISSION COMPLETED! +{REWARD} GLORY'),
('MISSION_COMPLETE_SPEAK', 'de', 'MISSION ABGESCHLOSSEN! +{REWARD} RUHM'),
('MISSION_COMPLETE_SPEAK', 'es', 'MISION COMPLETADA! +{REWARD} GLORIA'),
('MISSION_COMPLETE_SPEAK', 'fr', 'MISSION ACCOMPLIE! +{REWARD} GLOIRE'),
('MISSION_COMPLETE_SPEAK', 'pt', 'MISSAO COMPLETA! +{REWARD} GLORIA'),

('ALL_MISSIONS_COMPLETE', 'it', 'TUTTE LE MISSIONI COMPLETE!'),
('ALL_MISSIONS_COMPLETE', 'en', 'ALL MISSIONS COMPLETE!'),
('ALL_MISSIONS_COMPLETE', 'de', 'ALLE MISSIONEN ABGESCHLOSSEN!'),
('ALL_MISSIONS_COMPLETE', 'es', 'TODAS LAS MISIONES COMPLETADAS!'),
('ALL_MISSIONS_COMPLETE', 'fr', 'TOUTES LES MISSIONS TERMINEES!'),
('ALL_MISSIONS_COMPLETE', 'pt', 'TODAS AS MISSOES COMPLETAS!'),

('GLORY_FROM_MISSIONS', 'it', 'Gloria dalle Missioni:'),
('GLORY_FROM_MISSIONS', 'en', 'Glory from Missions:'),
('GLORY_FROM_MISSIONS', 'de', 'Ruhm aus Missionen:'),
('GLORY_FROM_MISSIONS', 'es', 'Gloria de Misiones:'),
('GLORY_FROM_MISSIONS', 'fr', 'Gloire des Missions:'),
('GLORY_FROM_MISSIONS', 'pt', 'Gloria das Missoes:'),

('MISSION', 'it', 'Missione'),
('MISSION', 'en', 'Mission'),
('MISSION', 'de', 'Mission'),
('MISSION', 'es', 'Mision'),
('MISSION', 'fr', 'Mission'),
('MISSION', 'pt', 'Missao'),

('TOTAL_MISSIONS', 'it', 'Totale Missioni'),
('TOTAL_MISSIONS', 'en', 'Total Missions'),
('TOTAL_MISSIONS', 'de', 'Missionen Gesamt'),
('TOTAL_MISSIONS', 'es', 'Total Misiones'),
('TOTAL_MISSIONS', 'fr', 'Total Missions'),
('TOTAL_MISSIONS', 'pt', 'Total Missoes'),

('BONUS_50_COMPLETION', 'it', 'BONUS 50% COMPLETAMENTO'),
('BONUS_50_COMPLETION', 'en', 'BONUS 50% COMPLETION'),
('BONUS_50_COMPLETION', 'de', 'BONUS 50% ABSCHLUSS'),
('BONUS_50_COMPLETION', 'es', 'BONUS 50% COMPLETADO'),
('BONUS_50_COMPLETION', 'fr', 'BONUS 50% ACHEVEMENT'),
('BONUS_50_COMPLETION', 'pt', 'BONUS 50% CONCLUSAO'),

('GLORY_EXTRA', 'it', 'Gloria Extra'),
('GLORY_EXTRA', 'en', 'Extra Glory'),
('GLORY_EXTRA', 'de', 'Extra Ruhm'),
('GLORY_EXTRA', 'es', 'Gloria Extra'),
('GLORY_EXTRA', 'fr', 'Gloire Supplementaire'),
('GLORY_EXTRA', 'pt', 'Gloria Extra'),

('TOTAL_EARNED', 'it', 'TOTALE GUADAGNATO'),
('TOTAL_EARNED', 'en', 'TOTAL EARNED'),
('TOTAL_EARNED', 'de', 'GESAMT VERDIENT'),
('TOTAL_EARNED', 'es', 'TOTAL GANADO'),
('TOTAL_EARNED', 'fr', 'TOTAL GAGNE'),
('TOTAL_EARNED', 'pt', 'TOTAL GANHO'),

('ACTIVATED', 'it', 'ATTIVATO'),
('ACTIVATED', 'en', 'ACTIVATED'),
('ACTIVATED', 'de', 'AKTIVIERT'),
('ACTIVATED', 'es', 'ACTIVADO'),
('ACTIVATED', 'fr', 'ACTIVE'),
('ACTIVATED', 'pt', 'ATIVADO'),

('FRACTURE_BONUS', 'it', 'Bonus Fratture +50%'),
('FRACTURE_BONUS', 'en', 'Fracture Bonus +50%'),
('FRACTURE_BONUS', 'de', 'Bruch Bonus +50%'),
('FRACTURE_BONUS', 'es', 'Bonus Fracturas +50%'),
('FRACTURE_BONUS', 'fr', 'Bonus Fractures +50%'),
('FRACTURE_BONUS', 'pt', 'Bonus Fraturas +50%'),

('VALID_UNTIL_RESET', 'it', 'valido fino al reset di mezzanotte'),
('VALID_UNTIL_RESET', 'en', 'valid until midnight reset'),
('VALID_UNTIL_RESET', 'de', 'gultig bis Mitternacht-Reset'),
('VALID_UNTIL_RESET', 'es', 'valido hasta el reinicio de medianoche'),
('VALID_UNTIL_RESET', 'fr', 'valide jusqu''a la reinitialisation de minuit'),
('VALID_UNTIL_RESET', 'pt', 'valido ate o reset da meia-noite'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Wave and Defense Notifications
-- ═══════════════════════════════════════════════════════════════════════════════

('WAVE_NOTIFICATION', 'it', 'ONDATA {WAVE}! +{MOBS} mob!'),
('WAVE_NOTIFICATION', 'en', 'WAVE {WAVE}! +{MOBS} mobs!'),
('WAVE_NOTIFICATION', 'de', 'WELLE {WAVE}! +{MOBS} Mobs!'),
('WAVE_NOTIFICATION', 'es', 'OLEADA {WAVE}! +{MOBS} mobs!'),
('WAVE_NOTIFICATION', 'fr', 'VAGUE {WAVE}! +{MOBS} mobs!'),
('WAVE_NOTIFICATION', 'pt', 'ONDA {WAVE}! +{MOBS} mobs!'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Calibrator and Conflict Messages
-- ═══════════════════════════════════════════════════════════════════════════════

('CALIBRATOR', 'it', 'CALIBRATORE'),
('CALIBRATOR', 'en', 'CALIBRATOR'),
('CALIBRATOR', 'de', 'KALIBRATOR'),
('CALIBRATOR', 'es', 'CALIBRADOR'),
('CALIBRATOR', 'fr', 'CALIBREUR'),
('CALIBRATOR', 'pt', 'CALIBRADOR'),

('CALIBRATOR_ACTIVE_MSG', 'it', 'Filtro attivo: Rango C+ garantito!'),
('CALIBRATOR_ACTIVE_MSG', 'en', 'Filter active: Rank C+ guaranteed!'),
('CALIBRATOR_ACTIVE_MSG', 'de', 'Filter aktiv: Rang C+ garantiert!'),
('CALIBRATOR_ACTIVE_MSG', 'es', 'Filtro activo: Rango C+ garantizado!'),
('CALIBRATOR_ACTIVE_MSG', 'fr', 'Filtre actif: Rang C+ garanti!'),
('CALIBRATOR_ACTIVE_MSG', 'pt', 'Filtro ativo: Rank C+ garantido!'),

('CONFLICT', 'it', 'CONFLITTO'),
('CONFLICT', 'en', 'CONFLICT'),
('CONFLICT', 'de', 'KONFLIKT'),
('CONFLICT', 'es', 'CONFLICTO'),
('CONFLICT', 'fr', 'CONFLIT'),
('CONFLICT', 'pt', 'CONFLITO'),

('CONFLICT_EMERGENCY', 'it', 'Completa prima l''Emergency Quest in corso!'),
('CONFLICT_EMERGENCY', 'en', 'Complete the ongoing Emergency Quest first!'),
('CONFLICT_EMERGENCY', 'de', 'Schliesse zuerst die laufende Notfall-Quest ab!'),
('CONFLICT_EMERGENCY', 'es', 'Completa primero la mision de emergencia en curso!'),
('CONFLICT_EMERGENCY', 'fr', 'Terminez d''abord la quete d''urgence en cours!'),
('CONFLICT_EMERGENCY', 'pt', 'Complete primeiro a Quest de Emergencia em andamento!'),

('CONFLICT_DEFENSE', 'it', 'Stai gia'' difendendo un''altra frattura!'),
('CONFLICT_DEFENSE', 'en', 'You are already defending another fracture!'),
('CONFLICT_DEFENSE', 'de', 'Du verteidigst bereits einen anderen Bruch!'),
('CONFLICT_DEFENSE', 'es', 'Ya estas defendiendo otra fractura!'),
('CONFLICT_DEFENSE', 'fr', 'Vous defendez deja une autre fracture!'),
('CONFLICT_DEFENSE', 'pt', 'Voce ja esta defendendo outra fratura!'),

('ERROR', 'it', 'ERRORE'),
('ERROR', 'en', 'ERROR'),
('ERROR', 'de', 'FEHLER'),
('ERROR', 'es', 'ERROR'),
('ERROR', 'fr', 'ERREUR'),
('ERROR', 'pt', 'ERRO'),

('ERROR_IDENTIFY_FRACTURE', 'it', 'Impossibile identificare la frattura!'),
('ERROR_IDENTIFY_FRACTURE', 'en', 'Unable to identify the fracture!'),
('ERROR_IDENTIFY_FRACTURE', 'de', 'Bruch kann nicht identifiziert werden!'),
('ERROR_IDENTIFY_FRACTURE', 'es', 'No se puede identificar la fractura!'),
('ERROR_IDENTIFY_FRACTURE', 'fr', 'Impossible d''identifier la fracture!'),
('ERROR_IDENTIFY_FRACTURE', 'pt', 'Impossivel identificar a fratura!'),

('SEAL_OF_CONQUEST', 'it', 'SIGILLO DI CONQUISTA'),
('SEAL_OF_CONQUEST', 'en', 'SEAL OF CONQUEST'),
('SEAL_OF_CONQUEST', 'de', 'SIEGEL DER EROBERUNG'),
('SEAL_OF_CONQUEST', 'es', 'SELLO DE CONQUISTA'),
('SEAL_OF_CONQUEST', 'fr', 'SCEAU DE CONQUETE'),
('SEAL_OF_CONQUEST', 'pt', 'SELO DE CONQUISTA'),

('SEAL_INSTANT_OPEN', 'it', 'La frattura si apre istantaneamente!'),
('SEAL_INSTANT_OPEN', 'en', 'The fracture opens instantly!'),
('SEAL_INSTANT_OPEN', 'de', 'Der Bruch offnet sich sofort!'),
('SEAL_INSTANT_OPEN', 'es', 'La fractura se abre instantaneamente!'),
('SEAL_INSTANT_OPEN', 'fr', 'La fracture s''ouvre instantanement!'),
('SEAL_INSTANT_OPEN', 'pt', 'A fratura se abre instantaneamente!'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Trial and Rank Messages
-- ═══════════════════════════════════════════════════════════════════════════════

('TRIAL_COMPLETE_RANK', 'it', 'PROVA COMPLETATA! Sei stato promosso al rango {RANK}!'),
('TRIAL_COMPLETE_RANK', 'en', 'TRIAL COMPLETED! You have been promoted to rank {RANK}!'),
('TRIAL_COMPLETE_RANK', 'de', 'PRUFUNG ABGESCHLOSSEN! Du wurdest in den Rang {RANK} befordert!'),
('TRIAL_COMPLETE_RANK', 'es', 'PRUEBA COMPLETADA! Has sido ascendido al rango {RANK}!'),
('TRIAL_COMPLETE_RANK', 'fr', 'EPREUVE TERMINEE! Vous avez ete promu au rang {RANK}!'),
('TRIAL_COMPLETE_RANK', 'pt', 'PROVA CONCLUIDA! Voce foi promovido ao rank {RANK}!'),

('TRIAL_REWARD', 'it', 'Ricompensa: +{REWARD} Gloria'),
('TRIAL_REWARD', 'en', 'Reward: +{REWARD} Glory'),
('TRIAL_REWARD', 'de', 'Belohnung: +{REWARD} Ruhm'),
('TRIAL_REWARD', 'es', 'Recompensa: +{REWARD} Gloria'),
('TRIAL_REWARD', 'fr', 'Recompense: +{REWARD} Gloire'),
('TRIAL_REWARD', 'pt', 'Recompensa: +{REWARD} Gloria'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Warning and Reminder Messages
-- ═══════════════════════════════════════════════════════════════════════════════

('WARNING', 'it', 'ATTENZIONE'),
('WARNING', 'en', 'WARNING'),
('WARNING', 'de', 'ACHTUNG'),
('WARNING', 'es', 'ATENCION'),
('WARNING', 'fr', 'ATTENTION'),
('WARNING', 'pt', 'ATENCAO'),

('WARNING_INCOMPLETE_MISSIONS', 'it', 'Hai {COUNT} missioni incomplete!'),
('WARNING_INCOMPLETE_MISSIONS', 'en', 'You have {COUNT} incomplete missions!'),
('WARNING_INCOMPLETE_MISSIONS', 'de', 'Du hast {COUNT} unvollstandige Missionen!'),
('WARNING_INCOMPLETE_MISSIONS', 'es', 'Tienes {COUNT} misiones incompletas!'),
('WARNING_INCOMPLETE_MISSIONS', 'fr', 'Vous avez {COUNT} missions incompletes!'),
('WARNING_INCOMPLETE_MISSIONS', 'pt', 'Voce tem {COUNT} missoes incompletas!'),

('RESET_IN_HOURS', 'it', 'Reset tra {HOURS} ore'),
('RESET_IN_HOURS', 'en', 'Reset in {HOURS} hours'),
('RESET_IN_HOURS', 'de', 'Reset in {HOURS} Stunden'),
('RESET_IN_HOURS', 'es', 'Reinicio en {HOURS} horas'),
('RESET_IN_HOURS', 'fr', 'Reinitialisation dans {HOURS} heures'),
('RESET_IN_HOURS', 'pt', 'Reset em {HOURS} horas'),

('COMPLETE_TO_AVOID_PENALTY', 'it', 'Completa per evitare penalita''!'),
('COMPLETE_TO_AVOID_PENALTY', 'en', 'Complete to avoid penalty!'),
('COMPLETE_TO_AVOID_PENALTY', 'de', 'Abschliessen, um Strafe zu vermeiden!'),
('COMPLETE_TO_AVOID_PENALTY', 'es', 'Completa para evitar penalizacion!'),
('COMPLETE_TO_AVOID_PENALTY', 'fr', 'Terminez pour eviter une penalite!'),
('COMPLETE_TO_AVOID_PENALTY', 'pt', 'Complete para evitar penalidade!'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Awakening Notice
-- ═══════════════════════════════════════════════════════════════════════════════

('AWAKENING_NOTICE', 'it', '{PLAYER} ha risvegliato: {MOB} ({RANK}){LOCATION}'),
('AWAKENING_NOTICE', 'en', '{PLAYER} has awakened: {MOB} ({RANK}){LOCATION}'),
('AWAKENING_NOTICE', 'de', '{PLAYER} hat erweckt: {MOB} ({RANK}){LOCATION}'),
('AWAKENING_NOTICE', 'es', '{PLAYER} ha despertado: {MOB} ({RANK}){LOCATION}'),
('AWAKENING_NOTICE', 'fr', '{PLAYER} a reveille: {MOB} ({RANK}){LOCATION}'),
('AWAKENING_NOTICE', 'pt', '{PLAYER} despertou: {MOB} ({RANK}){LOCATION}'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Glory Detail Messages
-- ═══════════════════════════════════════════════════════════════════════════════

('GLORY_DETAIL', 'it', 'DETTAGLIO GLORIA'),
('GLORY_DETAIL', 'en', 'GLORY DETAIL'),
('GLORY_DETAIL', 'de', 'RUHM-DETAILS'),
('GLORY_DETAIL', 'es', 'DETALLE DE GLORIA'),
('GLORY_DETAIL', 'fr', 'DETAIL DE GLOIRE'),
('GLORY_DETAIL', 'pt', 'DETALHE DE GLORIA'),

('BASE_GLORY', 'it', 'Gloria Base'),
('BASE_GLORY', 'en', 'Base Glory'),
('BASE_GLORY', 'de', 'Basis Ruhm'),
('BASE_GLORY', 'es', 'Gloria Base'),
('BASE_GLORY', 'fr', 'Gloire de Base'),
('BASE_GLORY', 'pt', 'Gloria Base'),

('TOTAL', 'it', 'TOTALE'),
('TOTAL', 'en', 'TOTAL'),
('TOTAL', 'de', 'GESAMT'),
('TOTAL', 'es', 'TOTAL'),
('TOTAL', 'fr', 'TOTAL'),
('TOTAL', 'pt', 'TOTAL'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Language and System Messages
-- ═══════════════════════════════════════════════════════════════════════════════

('LANGUAGE_CHANGED', 'it', 'Lingua cambiata!'),
('LANGUAGE_CHANGED', 'en', 'Language changed!'),
('LANGUAGE_CHANGED', 'de', 'Sprache geandert!'),
('LANGUAGE_CHANGED', 'es', 'Idioma cambiado!'),
('LANGUAGE_CHANGED', 'fr', 'Langue modifiee!'),
('LANGUAGE_CHANGED', 'pt', 'Idioma alterado!'),

('CACHE_RESET', 'it', 'Cache traduzioni resettata!'),
('CACHE_RESET', 'en', 'Translations cache reset!'),
('CACHE_RESET', 'de', 'Ubersetzungs-Cache zuruckgesetzt!'),
('CACHE_RESET', 'es', 'Cache de traducciones reiniciada!'),
('CACHE_RESET', 'fr', 'Cache des traductions reinitialisee!'),
('CACHE_RESET', 'pt', 'Cache de traducoes resetada!'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Fracture and Defense Messages (lowercase keys - legacy)
-- ═══════════════════════════════════════════════════════════════════════════════

('fracture_detected', 'it', 'ATTENZIONE: FRATTURA {RANK} RILEVATA.'),
('fracture_detected', 'en', 'WARNING: {RANK} FRACTURE DETECTED.'),
('fracture_detected', 'de', 'ACHTUNG: {RANK} BRUCH ENTDECKT.'),
('fracture_detected', 'es', 'ATENCION: FRACTURA {RANK} DETECTADA.'),
('fracture_detected', 'fr', 'ATTENTION: FRACTURE {RANK} DETECTEE.'),
('fracture_detected', 'pt', 'ATENCAO: FRATURA {RANK} DETECTADA.'),

('defense_start', 'it', 'UCCIDI TUTTI I MOB! Hai {SECONDS} secondi!'),
('defense_start', 'en', 'KILL ALL MOBS! You have {SECONDS} seconds!'),
('defense_start', 'de', 'TOTE ALLE MOBS! Du hast {SECONDS} Sekunden!'),
('defense_start', 'es', 'MATA A TODOS LOS MOBS! Tienes {SECONDS} segundos!'),
('defense_start', 'fr', 'TUEZ TOUS LES MOBS! Vous avez {SECONDS} secondes!'),
('defense_start', 'pt', 'MATE TODOS OS MOBS! Voce tem {SECONDS} segundos!'),

('defense_wave_spawn', 'it', 'ONDATA {WAVE}! DIFENDITI!'),
('defense_wave_spawn', 'en', 'WAVE {WAVE}! DEFEND YOURSELF!'),
('defense_wave_spawn', 'de', 'WELLE {WAVE}! VERTEIDIGE DICH!'),
('defense_wave_spawn', 'es', 'OLEADA {WAVE}! DEFIENDETE!'),
('defense_wave_spawn', 'fr', 'VAGUE {WAVE}! DEFENDEZ-VOUS!'),
('defense_wave_spawn', 'pt', 'ONDA {WAVE}! DEFENDA-SE!'),

('defense_success_click', 'it', 'FRATTURA CONQUISTATA! Hai 5 minuti per aprirla!'),
('defense_success_click', 'en', 'FRACTURE CONQUERED! You have 5 minutes to open it!'),
('defense_success_click', 'de', 'BRUCH EROBERT! Du hast 5 Minuten zum Offnen!'),
('defense_success_click', 'es', 'FRACTURA CONQUISTADA! Tienes 5 minutos para abrirla!'),
('defense_success_click', 'fr', 'FRACTURE CONQUISE! Vous avez 5 minutes pour l''ouvrir!'),
('defense_success_click', 'pt', 'FRATURA CONQUISTADA! Voce tem 5 minutos para abri-la!'),

('defense_failed_destroyed', 'it', 'DIFESA FALLITA! Le fratture di questo Rank vengono DISTRUTTE se fallisci!'),
('defense_failed_destroyed', 'en', 'DEFENSE FAILED! Fractures of this Rank are DESTROYED if you fail!'),
('defense_failed_destroyed', 'de', 'VERTEIDIGUNG FEHLGESCHLAGEN! Bruche dieses Rangs werden ZERSTORT wenn du versagst!'),
('defense_failed_destroyed', 'es', 'DEFENSA FALLIDA! Las fracturas de este Rango se DESTRUYEN si fallas!'),
('defense_failed_destroyed', 'fr', 'DEFENSE ECHOUEE! Les fractures de ce Rang sont DETRUITES si vous echouez!'),
('defense_failed_destroyed', 'pt', 'DEFESA FALHOU! Fraturas deste Rank sao DESTRUIDAS se voce falhar!'),

('defense_failed_retry', 'it', 'DIFESA FALLITA! La frattura e'' ancora li, puoi riprovare!'),
('defense_failed_retry', 'en', 'DEFENSE FAILED! The fracture is still there, you can retry!'),
('defense_failed_retry', 'de', 'VERTEIDIGUNG FEHLGESCHLAGEN! Der Bruch ist noch da, du kannst es erneut versuchen!'),
('defense_failed_retry', 'es', 'DEFENSA FALLIDA! La fractura sigue ahi, puedes reintentar!'),
('defense_failed_retry', 'fr', 'DEFENSE ECHOUEE! La fracture est toujours la, vous pouvez reessayer!'),
('defense_failed_retry', 'pt', 'DEFESA FALHOU! A fratura ainda esta la, voce pode tentar novamente!'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Mission Messages (lowercase keys - legacy)
-- ═══════════════════════════════════════════════════════════════════════════════

('mission_all_complete', 'it', 'TUTTE LE MISSIONI COMPLETE! BONUS x1.5!'),
('mission_all_complete', 'en', 'ALL MISSIONS COMPLETE! BONUS x1.5!'),
('mission_all_complete', 'de', 'ALLE MISSIONEN ABGESCHLOSSEN! BONUS x1.5!'),
('mission_all_complete', 'es', 'TODAS LAS MISIONES COMPLETAS! BONUS x1.5!'),
('mission_all_complete', 'fr', 'TOUTES LES MISSIONS TERMINEES! BONUS x1.5!'),
('mission_all_complete', 'pt', 'TODAS AS MISSOES COMPLETAS! BONUS x1.5!'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Combat and Kill Messages (lowercase keys - legacy)
-- ═══════════════════════════════════════════════════════════════════════════════

('speedkill_success', 'it', 'SPEED KILL! GLORIA x2!'),
('speedkill_success', 'en', 'SPEED KILL! GLORY x2!'),
('speedkill_success', 'de', 'SPEED KILL! RUHM x2!'),
('speedkill_success', 'es', 'SPEED KILL! GLORIA x2!'),
('speedkill_success', 'fr', 'SPEED KILL! GLOIRE x2!'),
('speedkill_success', 'pt', 'SPEED KILL! GLORIA x2!'),

('target_eliminated', 'it', 'BERSAGLIO ELIMINATO: {NAME} | +{POINTS} GLORIA'),
('target_eliminated', 'en', 'TARGET ELIMINATED: {NAME} | +{POINTS} GLORY'),
('target_eliminated', 'de', 'ZIEL ELIMINIERT: {NAME} | +{POINTS} RUHM'),
('target_eliminated', 'es', 'OBJETIVO ELIMINADO: {NAME} | +{POINTS} GLORIA'),
('target_eliminated', 'fr', 'CIBLE ELIMINEE: {NAME} | +{POINTS} GLOIRE'),
('target_eliminated', 'pt', 'ALVO ELIMINADO: {NAME} | +{POINTS} GLORIA'),

('chest_bonus', 'it', 'Incredibile! Il baule conteneva anche {POINTS} Gloria!'),
('chest_bonus', 'en', 'Incredible! The chest also contained {POINTS} Glory!'),
('chest_bonus', 'de', 'Unglaublich! Die Truhe enthielt auch {POINTS} Ruhm!'),
('chest_bonus', 'es', 'Increible! El cofre tambien contenia {POINTS} Gloria!'),
('chest_bonus', 'fr', 'Incroyable! Le coffre contenait aussi {POINTS} Gloire!'),
('chest_bonus', 'pt', 'Incrivel! O bau tambem continha {POINTS} Gloria!'),

('spawn_chest_detected', 'it', 'BAULE DEL TESORO RILEVATO!'),
('spawn_chest_detected', 'en', 'TREASURE CHEST DETECTED!'),
('spawn_chest_detected', 'de', 'SCHATZTRUHE ENTDECKT!'),
('spawn_chest_detected', 'es', 'COFRE DEL TESORO DETECTADO!'),
('spawn_chest_detected', 'fr', 'COFFRE AU TRESOR DETECTE!'),
('spawn_chest_detected', 'pt', 'BAU DO TESOURO DETECTADO!'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Shop Messages (lowercase keys - legacy)
-- ═══════════════════════════════════════════════════════════════════════════════

('shop_title', 'it', 'MERCANTE HUNTER'),
('shop_title', 'en', 'HUNTER MERCHANT'),
('shop_title', 'de', 'HUNTER HANDLER'),
('shop_title', 'es', 'MERCADER HUNTER'),
('shop_title', 'fr', 'MARCHAND HUNTER'),
('shop_title', 'pt', 'MERCADOR HUNTER'),

('shop_ask', 'it', 'Vuoi acquistare questo oggetto?'),
('shop_ask', 'en', 'Do you want to buy this item?'),
('shop_ask', 'de', 'Mochtest du diesen Gegenstand kaufen?'),
('shop_ask', 'es', 'Quieres comprar este objeto?'),
('shop_ask', 'fr', 'Voulez-vous acheter cet objet?'),
('shop_ask', 'pt', 'Quer comprar este item?'),

('shop_opt_confirm', 'it', 'Conferma Acquisto'),
('shop_opt_confirm', 'en', 'Confirm Purchase'),
('shop_opt_confirm', 'de', 'Kauf Bestatigen'),
('shop_opt_confirm', 'es', 'Confirmar Compra'),
('shop_opt_confirm', 'fr', 'Confirmer l''Achat'),
('shop_opt_confirm', 'pt', 'Confirmar Compra'),

('shop_opt_cancel', 'it', 'Annulla'),
('shop_opt_cancel', 'en', 'Cancel'),
('shop_opt_cancel', 'de', 'Abbrechen'),
('shop_opt_cancel', 'es', 'Cancelar'),
('shop_opt_cancel', 'fr', 'Annuler'),
('shop_opt_cancel', 'pt', 'Cancelar'),

('shop_success', 'it', 'TRANSAZIONE COMPLETATA. -{POINTS} GLORIA'),
('shop_success', 'en', 'TRANSACTION COMPLETED. -{POINTS} GLORY'),
('shop_success', 'de', 'TRANSAKTION ABGESCHLOSSEN. -{POINTS} RUHM'),
('shop_success', 'es', 'TRANSACCION COMPLETADA. -{POINTS} GLORIA'),
('shop_success', 'fr', 'TRANSACTION TERMINEE. -{POINTS} GLOIRE'),
('shop_success', 'pt', 'TRANSACAO CONCLUIDA. -{POINTS} GLORIA'),

('shop_error_funds', 'it', 'ERRORE: GLORIA INSUFFICIENTE.'),
('shop_error_funds', 'en', 'ERROR: INSUFFICIENT GLORY.'),
('shop_error_funds', 'de', 'FEHLER: NICHT GENUG RUHM.'),
('shop_error_funds', 'es', 'ERROR: GLORIA INSUFICIENTE.'),
('shop_error_funds', 'fr', 'ERREUR: GLOIRE INSUFFISANTE.'),
('shop_error_funds', 'pt', 'ERRO: GLORIA INSUFICIENTE.'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Rank and Rewards Messages (lowercase keys - legacy)
-- ═══════════════════════════════════════════════════════════════════════════════

('pending_rewards', 'it', 'RICOMPENSE IN ATTESA. CONTROLLA IL TERMINALE.'),
('pending_rewards', 'en', 'REWARDS PENDING. CHECK THE TERMINAL.'),
('pending_rewards', 'de', 'BELOHNUNGEN AUSSTEHEND. PRUFE DAS TERMINAL.'),
('pending_rewards', 'es', 'RECOMPENSAS PENDIENTES. REVISA EL TERMINAL.'),
('pending_rewards', 'fr', 'RECOMPENSES EN ATTENTE. VERIFIEZ LE TERMINAL.'),
('pending_rewards', 'pt', 'RECOMPENSAS PENDENTES. VERIFIQUE O TERMINAL.'),

('rank_up_global', 'it', '{NAME} e'' salito al rango [{RANK}-RANK]!'),
('rank_up_global', 'en', '{NAME} has risen to rank [{RANK}-RANK]!'),
('rank_up_global', 'de', '{NAME} ist zum Rang [{RANK}-RANK] aufgestiegen!'),
('rank_up_global', 'es', '{NAME} ha subido al rango [{RANK}-RANK]!'),
('rank_up_global', 'fr', '{NAME} est monte au rang [{RANK}-RANK]!'),
('rank_up_global', 'pt', '{NAME} subiu para o rank [{RANK}-RANK]!'),

('rank_up_msg', 'it', 'RANK UP! Sei ora un {RANK}-RANK Hunter!'),
('rank_up_msg', 'en', 'RANK UP! You are now a {RANK}-RANK Hunter!'),
('rank_up_msg', 'de', 'RANG AUFSTIEG! Du bist jetzt ein {RANK}-RANG Hunter!'),
('rank_up_msg', 'es', 'SUBIDA DE RANGO! Ahora eres un Hunter {RANK}-RANK!'),
('rank_up_msg', 'fr', 'RANG SUPERIEUR! Vous etes maintenant un Hunter {RANK}-RANG!'),
('rank_up_msg', 'pt', 'SUBIU DE RANK! Voce agora e um Hunter {RANK}-RANK!'),

('reward_type_daily', 'it', 'Giornaliera'),
('reward_type_daily', 'en', 'Daily'),
('reward_type_daily', 'de', 'Taglich'),
('reward_type_daily', 'es', 'Diaria'),
('reward_type_daily', 'fr', 'Quotidienne'),
('reward_type_daily', 'pt', 'Diaria'),

('reward_type_weekly', 'it', 'Settimanale'),
('reward_type_weekly', 'en', 'Weekly'),
('reward_type_weekly', 'de', 'Wochentlich'),
('reward_type_weekly', 'es', 'Semanal'),
('reward_type_weekly', 'fr', 'Hebdomadaire'),
('reward_type_weekly', 'pt', 'Semanal'),

('reward_claimed', 'it', '{PLAYER} ha riscosso il premio Top Classifica {TYPE}!'),
('reward_claimed', 'en', '{PLAYER} has claimed the Top {TYPE} Ranking prize!'),
('reward_claimed', 'de', '{PLAYER} hat den Top {TYPE} Ranglisten-Preis beansprucht!'),
('reward_claimed', 'es', '{PLAYER} ha reclamado el premio Top Clasificacion {TYPE}!'),
('reward_claimed', 'fr', '{PLAYER} a reclame le prix Top Classement {TYPE}!'),
('reward_claimed', 'pt', '{PLAYER} resgatou o premio Top Ranking {TYPE}!'),

('achievements_unlocked', 'it', 'TRAGUARDI SBLOCCATI: {COUNT}'),
('achievements_unlocked', 'en', 'ACHIEVEMENTS UNLOCKED: {COUNT}'),
('achievements_unlocked', 'de', 'ERFOLGE FREIGESCHALTET: {COUNT}'),
('achievements_unlocked', 'es', 'LOGROS DESBLOQUEADOS: {COUNT}'),
('achievements_unlocked', 'fr', 'SUCCES DEBLOQUES: {COUNT}'),
('achievements_unlocked', 'pt', 'CONQUISTAS DESBLOQUEADAS: {COUNT}'),

-- ═══════════════════════════════════════════════════════════════════════════════
-- Rankings and Reset Messages (lowercase keys - legacy)
-- ═══════════════════════════════════════════════════════════════════════════════

('winners_title_daily', 'it', '* VINCITORI CLASSIFICA GIORNALIERA *'),
('winners_title_daily', 'en', '* DAILY RANKING WINNERS *'),
('winners_title_daily', 'de', '* TAGLICHE RANGLISTEN GEWINNER *'),
('winners_title_daily', 'es', '* GANADORES CLASIFICACION DIARIA *'),
('winners_title_daily', 'fr', '* GAGNANTS CLASSEMENT QUOTIDIEN *'),
('winners_title_daily', 'pt', '* VENCEDORES RANKING DIARIO *'),

('winners_title_weekly', 'it', '** VINCITORI CLASSIFICA SETTIMANALE **'),
('winners_title_weekly', 'en', '** WEEKLY RANKING WINNERS **'),
('winners_title_weekly', 'de', '** WOCHENTLICHE RANGLISTEN GEWINNER **'),
('winners_title_weekly', 'es', '** GANADORES CLASIFICACION SEMANAL **'),
('winners_title_weekly', 'fr', '** GAGNANTS CLASSEMENT HEBDOMADAIRE **'),
('winners_title_weekly', 'pt', '** VENCEDORES RANKING SEMANAL **'),

('winners_title_kill', 'it', '* VINCITORI CLASSIFICA KILL GIORNALIERA *'),
('winners_title_kill', 'en', '* DAILY KILL RANKING WINNERS *'),
('winners_title_kill', 'de', '* TAGLICHE KILL-RANGLISTEN GEWINNER *'),
('winners_title_kill', 'es', '* GANADORES CLASIFICACION KILLS DIARIA *'),
('winners_title_kill', 'fr', '* GAGNANTS CLASSEMENT KILLS QUOTIDIEN *'),
('winners_title_kill', 'pt', '* VENCEDORES RANKING KILLS DIARIO *'),

('winners_sep_daily', 'it', '======================================'),
('winners_sep_daily', 'en', '======================================'),
('winners_sep_daily', 'de', '======================================'),
('winners_sep_daily', 'es', '======================================'),
('winners_sep_daily', 'fr', '======================================'),
('winners_sep_daily', 'pt', '======================================'),

('winners_sep_weekly', 'it', '======================================'),
('winners_sep_weekly', 'en', '======================================'),
('winners_sep_weekly', 'de', '======================================'),
('winners_sep_weekly', 'es', '======================================'),
('winners_sep_weekly', 'fr', '======================================'),
('winners_sep_weekly', 'pt', '======================================'),

('winners_sep_kill', 'it', '======================================'),
('winners_sep_kill', 'en', '======================================'),
('winners_sep_kill', 'de', '======================================'),
('winners_sep_kill', 'es', '======================================'),
('winners_sep_kill', 'fr', '======================================'),
('winners_sep_kill', 'pt', '======================================'),

('reset_daily', 'it', 'Classifica Giornaliera Resettata! La corsa al potere ricomincia.'),
('reset_daily', 'en', 'Daily Ranking Reset! The race for power begins again.'),
('reset_daily', 'de', 'Tagliche Rangliste Zuruckgesetzt! Das Rennen um die Macht beginnt erneut.'),
('reset_daily', 'es', 'Clasificacion Diaria Reiniciada! La carrera por el poder comienza de nuevo.'),
('reset_daily', 'fr', 'Classement Quotidien Reinitialise! La course au pouvoir recommence.'),
('reset_daily', 'pt', 'Ranking Diario Resetado! A corrida pelo poder recomeca.'),

('reset_weekly', 'it', 'Classifica Settimanale Resettata! I premi sono stati distribuiti.'),
('reset_weekly', 'en', 'Weekly Ranking Reset! Prizes have been distributed.'),
('reset_weekly', 'de', 'Wochentliche Rangliste Zuruckgesetzt! Preise wurden verteilt.'),
('reset_weekly', 'es', 'Clasificacion Semanal Reiniciada! Los premios han sido distribuidos.'),
('reset_weekly', 'fr', 'Classement Hebdomadaire Reinitialise! Les prix ont ete distribues.'),
('reset_weekly', 'pt', 'Ranking Semanal Resetado! Os premios foram distribuidos.')

ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- End of translation file
-- ═══════════════════════════════════════════════════════════════════════════════

SET FOREIGN_KEY_CHECKS = 1;
