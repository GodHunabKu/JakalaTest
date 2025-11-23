/*
 Navicat Premium Data Transfer

 Source Server         : ONE UFFICIALE
 Source Server Type    : MySQL
 Source Server Version : 101114 (10.11.14-MariaDB)
 Source Host           : 81.180.203.241:3306
 Source Schema         : site

 Target Server Type    : MySQL
 Target Server Version : 101114 (10.11.14-MariaDB)
 File Encoding         : 65001

 Date: 22/11/2025 12:15:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for shop_categories
-- ----------------------------
DROP TABLE IF EXISTS `shop_categories`;
CREATE TABLE `shop_categories`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `master_category_id` int NOT NULL DEFAULT 0,
  `position` smallint UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of shop_categories
-- ----------------------------
INSERT INTO `shop_categories` VALUES (1, 'Cavalcature - Cuccioli Pet', 1, 0, 12, NULL, NULL);
INSERT INTO `shop_categories` VALUES (2, 'Estetiche', 1, 0, 13, NULL, NULL);
INSERT INTO `shop_categories` VALUES (3, 'Sistema delle Rune', 1, 25, 2, NULL, NULL);
INSERT INTO `shop_categories` VALUES (4, 'Sistema delle Cinture', 1, 25, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (5, 'Biglietto Pacchetto [VIP]', 1, 0, 2, NULL, NULL);
INSERT INTO `shop_categories` VALUES (6, 'Generici', 1, 32, 3, NULL, NULL);
INSERT INTO `shop_categories` VALUES (7, 'Set Etereo (Primo) - (Livello 75)', 1, 23, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (8, 'Set Rovente (Secondo) - (Livello 95)', 1, 23, 1, NULL, NULL);
INSERT INTO `shop_categories` VALUES (9, 'Set Divino (Primo) - (Livello 85)', 1, 24, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (10, 'Set Celestiale (Secondo) - (Livello 127)', 1, 24, 1, NULL, NULL);
INSERT INTO `shop_categories` VALUES (14, 'Sistema degli Spiriti', 1, 25, 3, NULL, NULL);
INSERT INTO `shop_categories` VALUES (15, 'Sistema delle Anime', 1, 25, 1, NULL, NULL);
INSERT INTO `shop_categories` VALUES (16, 'Set Drago Oscuro (Semi Finale) - (Livello 155)', 1, 23, 2, NULL, NULL);
INSERT INTO `shop_categories` VALUES (17, 'Set Glaciale (Semi Finale) - (Livello 180)', 1, 24, 2, NULL, NULL);
INSERT INTO `shop_categories` VALUES (18, 'Buoni Monete', 1, 0, 14, NULL, NULL);
INSERT INTO `shop_categories` VALUES (20, 'Sistema dei Titoli', 1, 25, 4, NULL, NULL);
INSERT INTO `shop_categories` VALUES (23, 'Equipaggiamenti PVM', 1, 0, 1, NULL, NULL);
INSERT INTO `shop_categories` VALUES (24, 'Equipaggiamenti PVP', 1, 0, 2, NULL, NULL);
INSERT INTO `shop_categories` VALUES (25, 'Sistemi/Accessori', 1, 0, 2, NULL, NULL);
INSERT INTO `shop_categories` VALUES (26, 'Sistema degli Anelli Speciali', 1, 25, 5, NULL, NULL);
INSERT INTO `shop_categories` VALUES (27, 'Sistema degli Anelli del Potere', 1, 25, 5, NULL, NULL);
INSERT INTO `shop_categories` VALUES (28, 'Evento: Oggetti Natalizi', 0, 0, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (29, 'Pietre Grado Ancestrali Finali', 1, 0, 6, NULL, NULL);
INSERT INTO `shop_categories` VALUES (30, 'Set Drago Elite (SemiFinale) - (Livello 200)', 1, 23, 4, NULL, NULL);
INSERT INTO `shop_categories` VALUES (31, 'Set Divino Elite (Finale) - (Livello 220)', 1, 24, 4, NULL, NULL);
INSERT INTO `shop_categories` VALUES (32, 'Oggetti Generali', 1, 0, 6, NULL, NULL);
INSERT INTO `shop_categories` VALUES (33, 'UPP', 1, 32, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (34, 'Gira Bonus', 1, 32, 1, NULL, NULL);
INSERT INTO `shop_categories` VALUES (36, 'Oggetti Pasquali', 0, 0, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (37, 'Biglietto Pacchetto PREMIUM', 1, 0, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (38, 'Oggetti SUMMER', 0, 0, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (39, 'Pet Summer', 0, 38, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (40, 'Cavalcature Summer', 0, 38, 1, NULL, NULL);
INSERT INTO `shop_categories` VALUES (41, 'Skin Armi Summer', 0, 38, 2, NULL, NULL);
INSERT INTO `shop_categories` VALUES (42, 'Capigliatura-Costume-Ali Summer', 0, 38, 3, NULL, NULL);
INSERT INTO `shop_categories` VALUES (43, 'Oggetti Speciali', 1, 0, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (44, 'Oggetti Halloween', 0, 0, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (45, 'Oggetti Nuovi Espansione 220+', 1, 0, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (46, 'Set Millenario (Finale PVM) - (Livello 230)', 1, 45, 0, NULL, NULL);
INSERT INTO `shop_categories` VALUES (47, 'Sistema degli Emblemi', 1, 45, 1, NULL, NULL);
INSERT INTO `shop_categories` VALUES (48, 'Sistema delle Reliquie', 1, 45, 2, NULL, NULL);
INSERT INTO `shop_categories` VALUES (49, 'Rune Ancestrali', 1, 45, 3, NULL, NULL);
INSERT INTO `shop_categories` VALUES (50, 'Anime Ancestrali', 1, 45, 3, NULL, NULL);
INSERT INTO `shop_categories` VALUES (51, 'Cinture Ancestrali', 1, 45, 4, NULL, NULL);
INSERT INTO `shop_categories` VALUES (52, 'Nuova Categoria Pietre Ancestrali', 1, 45, 5, NULL, NULL);
INSERT INTO `shop_categories` VALUES (53, 'Altro/UPP', 1, 45, 6, NULL, NULL);
INSERT INTO `shop_categories` VALUES (54, 'Evento Mondo Magico: Oggetti', 0, 0, 0, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
