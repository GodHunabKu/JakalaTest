-- ═══════════════════════════════════════════════════════════════════════════════
-- HUNTER TERMINAL - COMPLETE TRANSLATIONS DATABASE
-- Tutte le traduzioni per il sistema multi-lingua
-- ═══════════════════════════════════════════════════════════════════════════════

-- Pulisci tabella esistente (opzionale, decommentare se necessario)
-- TRUNCATE TABLE hunter_translations;

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
-- End of translation file
-- ═══════════════════════════════════════════════════════════════════════════════
