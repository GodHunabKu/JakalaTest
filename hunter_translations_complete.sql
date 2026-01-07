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
('SMART_NONE', 'pt', 'Nenhuma conquista para resgatar.')
ON DUPLICATE KEY UPDATE text_value = VALUES(text_value);

-- ═══════════════════════════════════════════════════════════════════════════════
-- End of translation file
-- ═══════════════════════════════════════════════════════════════════════════════
