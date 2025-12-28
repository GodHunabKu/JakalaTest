quest hunter_level_bridge3 begin
    state start begin
        
        -- Configurazione rapida livello minimo
        function GetMinLevel()
            return 30
        end

        -- ============================================================
        -- LOGIN
        -- ============================================================
        when login begin
            local min_lvl = hunter_level_bridge3.GetMinLevel()

            if pc.get_level() >= min_lvl then
                if HUNTER and HUNTER.Init then HUNTER.Init() end
                if HUNTER and HUNTER.OnLogin then HUNTER.OnLogin(pc.get_player_id()) end
                loop_timer("hunter_flush", 300)

                -- Invia messaggio di benvenuto con rank e streak
                hunter_level_bridge3.send_welcome_message()
            end
        end
        
        -- ============================================================
        -- LOGOUT
        -- ============================================================
        when logout begin
            if pc.get_level() >= hunter_level_bridge3.GetMinLevel() then
                if HUNTER and HUNTER.OnLogout then HUNTER.OnLogout(pc.get_player_id()) end

                -- Cleanup timer e flag per evitare "QUEST NOT END RUNNING"
                clear_server_timer("fracture_check_position", pc.get_player_id())
                clear_server_timer("fracture_spawn_wave", pc.get_player_id())
                pc.setqf("fracture_def_active", 0)
            end
        end
        
        -- ============================================================
        -- KILL
        -- ============================================================
        when kill begin
            if pc.get_level() < hunter_level_bridge3.GetMinLevel() then return end
            
            local mob_vnum = npc.get_race()
            if mob_vnum == 0 then return end
            
            if HUNTER and HUNTER.OnKill then HUNTER.OnKill(pc.get_player_id(), mob_vnum) end
            if HUNTER and HUNTER.UpdateEmergency then HUNTER.UpdateEmergency(pc.get_player_id(), mob_vnum) end
            if HUNTER and HUNTER.UpdateMissionProgress then HUNTER.UpdateMissionProgress(pc.get_player_id(), mob_vnum) end
        end
        
        -- ============================================================
        -- LEVEL UP
        -- ============================================================
        when levelup begin
            local min_lvl = hunter_level_bridge3.GetMinLevel()
            
            if pc.get_level() == min_lvl then
                if HUNTER and HUNTER.Init then HUNTER.Init() end
                if HUNTER and HUNTER.OnLogin then HUNTER.OnLogin(pc.get_player_id()) end
                cmdchat("HunterActivation " .. pc.get_name())
                syschat("Hai sbloccato il Sistema Hunter! Premi 'J' o apri il menu per accedere.")
                loop_timer("hunter_flush", 300)
            end
        end
        
        -- ============================================================
        -- TIMER
        -- ============================================================
        when hunter_flush.timer begin
            if HUNTER and HUNTER.OnFlushTimer then HUNTER.OnFlushTimer() end
        end
        
        -- ============================================================
        -- QUEST LETTER (Metodo alternativo per aprire UI)
        -- ============================================================

        when letter begin
            -- Mostra lettera solo se livello sufficiente
            if pc.get_level() >= hunter_level_bridge3.GetMinLevel() then
                send_letter("Hunter System")
            end
        end

        when button or info begin
            -- Quando si clicca sulla lettera:

            -- Apri l'interfaccia Hunter
            cmdchat("HunterOpenUI")

            -- Invia TUTTI i dati al client (ranking, shop, achievements, player data)
            hunter_level_bridge3.send_all_data()

            -- Mantieni la lettera aperta per click futuri
            send_letter("Hunter System")
        end

        -- ============================================================
        -- FUNZIONI INVIO DATI AL CLIENT
        -- ============================================================

        function send_player_data()
            local pid = pc.get_player_id()
            local query = string.format(
                "SELECT player_name, total_glory, spendable_credits, daily_glory, weekly_glory, " ..
                "total_kills, daily_kills, weekly_kills, login_streak, " ..
                "total_fractures, total_chests, total_metins, total_bosses, " ..
                "daily_position, weekly_position " ..
                "FROM hunter_players WHERE player_id = %d", pid
            )

            local count, result = mysql_direct_query(query)

            -- Debug logging
            syschat(string.format("[HUNTER DEBUG] Player ID: %d, Query result count: %d", pid, count or 0))

            if count > 0 and result[1] then
                local row = result[1]
                syschat(string.format("[HUNTER DEBUG] Data trovati: Glory=%s, Kills=%s", tostring(row[2]), tostring(row[6])))

                -- IMPORTANTE: mysql_direct_query restituisce array numerici, NON table con nomi campi
                -- Ordine SELECT: player_name, total_glory, spendable_credits, daily_glory, weekly_glory,
                --                total_kills, daily_kills, weekly_kills, login_streak,
                --                total_fractures, total_chests, total_metins, total_bosses,
                --                daily_position, weekly_position

                -- Calcola streak bonus basato su login_streak
                local login_streak = tonumber(row[9]) or 0  -- login_streak è il 9° campo
                local streak_bonus = 0
                if login_streak >= 30 then streak_bonus = 20
                elseif login_streak >= 14 then streak_bonus = 15
                elseif login_streak >= 7 then streak_bonus = 10
                elseif login_streak >= 3 then streak_bonus = 5
                end

                -- Formato game.py: name|total_points|spendable_points|daily_points|weekly_points|
                --                  total_kills|daily_kills|weekly_kills|login_streak|streak_bonus|
                --                  total_fractures|total_chests|total_metins|pending_daily_reward|
                --                  pending_weekly_reward|daily_pos|weekly_pos
                local data_str = (row[1] or pc.get_name()) .. "|" ..  -- player_name
                                 (tonumber(row[2]) or 0) .. "|" ..     -- total_glory
                                 (tonumber(row[3]) or 0) .. "|" ..     -- spendable_credits
                                 (tonumber(row[4]) or 0) .. "|" ..     -- daily_glory
                                 (tonumber(row[5]) or 0) .. "|" ..     -- weekly_glory
                                 (tonumber(row[6]) or 0) .. "|" ..     -- total_kills
                                 (tonumber(row[7]) or 0) .. "|" ..     -- daily_kills
                                 (tonumber(row[8]) or 0) .. "|" ..     -- weekly_kills
                                 login_streak .. "|" .. streak_bonus .. "|" ..
                                 (tonumber(row[10]) or 0) .. "|" ..    -- total_fractures
                                 (tonumber(row[11]) or 0) .. "|" ..    -- total_chests
                                 (tonumber(row[12]) or 0) .. "|" ..    -- total_metins
                                 (tonumber(row[13]) or 0) .. "|0|" ..  -- total_bosses
                                 (tonumber(row[14]) or 0) .. "|" ..    -- daily_position
                                 (tonumber(row[15]) or 0)              -- weekly_position

                syschat("[HUNTER DEBUG] Invio dati player al client...")
                cmdchat("HunterPlayerData " .. data_str)
                syschat("[HUNTER DEBUG] Comando inviato!")
            else
                -- Player non trovato nel database, crea record nuovo
                syschat(string.format("[HUNTER DEBUG] Player ID %d non trovato, creo nuovo record...", pid))
                local player_name = pc.get_name()
                local insert_query = string.format(
                    "INSERT INTO hunter_players (player_id, player_name) VALUES (%d, '%s')",
                    pid, mysql_escape_string(player_name)
                )
                mysql_direct_query(insert_query)

                -- Invia dati iniziali (tutto a 0) - 17 campi allineati a game.py
                syschat("[HUNTER DEBUG] Invio dati iniziali (tutto a 0)...")
                cmdchat("HunterPlayerData " .. player_name .. "|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0")
            end
        end

        function send_all_data()
            -- Invia tutti i dati necessari per popolare l'intera UI
            hunter_level_bridge3.send_player_data()
            hunter_level_bridge3.send_ranking("daily")
            hunter_level_bridge3.send_ranking("weekly")
            hunter_level_bridge3.send_ranking("total")
            hunter_level_bridge3.send_shop()
            hunter_level_bridge3.send_achievements()
        end

        function send_ranking(rtype)
            local col = "total_glory"
            local cmd = "HunterRankingTotal"

            if rtype == "daily" then
                col = "daily_glory"
                cmd = "HunterRankingDaily"
            elseif rtype == "weekly" then
                col = "weekly_glory"
                cmd = "HunterRankingWeekly"
            end

            local query = string.format(
                "SELECT player_name, %s as glory FROM hunter_players WHERE %s > 0 ORDER BY %s DESC LIMIT 10",
                col, col, col
            )

            local count, result = mysql_direct_query(query)
            local data_str = ""

            if count > 0 then
                for i = 1, count do
                    local row = result[i]
                    if data_str ~= "" then data_str = data_str .. ";" end
                    -- row[1] = player_name, row[2] = glory
                    data_str = data_str .. (row[1] or "Unknown") .. "," .. (tonumber(row[2]) or 0) .. ",0"
                end
            end

            if data_str == "" then
                cmdchat(cmd .. " EMPTY")
            else
                cmdchat(cmd .. " " .. data_str)
            end
        end

        function send_shop()
            -- Query shop items from database
            local query = "SELECT item_id, item_vnum, item_count, price_credits, min_rank FROM hunter_shop WHERE is_active = 1 ORDER BY price_credits ASC"
            local count, result = mysql_direct_query(query)

            if count > 0 then
                local entries = {}
                for i = 1, count do
                    local row = result[i]
                    -- row[1]=item_id, row[2]=item_vnum, row[3]=item_count, row[4]=price_credits, row[5]=min_rank
                    -- Format corretto per game.py: id,vnum,count,price,name
                    local item_name = "Hunter+Item+" .. (tonumber(row[2]) or 0)
                    local entry = (tonumber(row[1]) or 0) .. "," ..
                                  (tonumber(row[2]) or 0) .. "," ..
                                  (tonumber(row[3]) or 1) .. "," ..
                                  (tonumber(row[4]) or 0) .. "," ..
                                  item_name
                    table.insert(entries, entry)
                end
                cmdchat("HunterShopItems " .. table.concat(entries, ";"))
            else
                cmdchat("HunterShopItems EMPTY")
            end
        end

        function send_achievements()
            -- Query achievements from database with player progress
            local pid = pc.get_player_id()

            -- First get player stats
            local stats_query = string.format(
                "SELECT total_kills, total_glory FROM hunter_players WHERE player_id = %d", pid
            )
            local stats_count, stats_result = mysql_direct_query(stats_query)

            local total_kills = 0
            local total_glory = 0
            if stats_count > 0 and stats_result[1] then
                -- stats_result: row[1]=total_kills, row[2]=total_glory
                total_kills = tonumber(stats_result[1][1]) or 0
                total_glory = tonumber(stats_result[1][2]) or 0
            end

            -- Get achievements config
            local query = "SELECT id, name, type, requirement, reward_vnum, reward_count FROM hunter_quest_achievements_config WHERE enabled = 1 ORDER BY type, requirement ASC"
            local count, result = mysql_direct_query(query)

            if count > 0 then
                local entries = {}
                for i = 1, count do
                    local row = result[i]
                    -- row[1]=id, row[2]=name, row[3]=type, row[4]=requirement, row[5]=reward_vnum, row[6]=reward_count
                    local ach_type = tonumber(row[3]) or 1
                    local requirement = tonumber(row[4]) or 0
                    local current_progress = 0
                    local status = "locked"

                    -- Type 1 = Kill count, Type 2 = Glory points
                    if ach_type == 1 then
                        current_progress = total_kills
                    else
                        current_progress = total_glory
                    end

                    -- Check if unlocked
                    local unlocked = 0
                    local claimed = 0
                    if current_progress >= requirement then
                        unlocked = 1
                    end

                    -- Format corretto per game.py: id,name,type,requirement,progress,unlocked,claimed
                    -- Separatore campi = "," | Separatore entries = ";"
                    local name_clean = string.gsub(row[2] or "Achievement", " ", "+")
                    local entry = (tonumber(row[1]) or 0) .. "," ..
                                  name_clean .. "," ..
                                  ach_type .. "," ..
                                  requirement .. "," ..
                                  current_progress .. "," ..
                                  unlocked .. "," ..
                                  claimed
                    table.insert(entries, entry)
                end
                cmdchat("HunterAchievements " .. table.concat(entries, ";"))
            else
                cmdchat("HunterAchievements EMPTY")
            end
        end

        -- ============================================================
        -- WELCOME MESSAGE ON LOGIN
        -- ============================================================

        function send_welcome_message()
            local pid = pc.get_player_id()
            local query = string.format(
                "SELECT player_name, current_rank, login_streak, total_glory FROM hunter_players WHERE player_id = %d", pid
            )
            local count, result = mysql_direct_query(query)

            if count > 0 and result[1] then
                local row = result[1]
                -- row[1]=player_name, row[2]=current_rank, row[3]=login_streak, row[4]=total_glory
                local rank = row[2] or "E"
                local streak = tonumber(row[3]) or 0
                local glory = tonumber(row[4]) or 0
                local name = row[1] or pc.get_name()

                -- Rank color mapping
                local rank_colors = {
                    E = "808080",  -- Gray
                    D = "00FF00",  -- Green
                    C = "0099FF",  -- Blue
                    B = "FF9900",  -- Orange
                    A = "FF0000",  -- Red
                    S = "FFD700",  -- Gold
                    N = "FF00FF"   -- Purple
                }

                local color = rank_colors[rank] or "FFFFFF"

                -- Messaggi epici stile Solo Leveling (senza wait per evitare quest hang)
                syschat(string.format("|cff%s====================================================|r", color))
                syschat(string.format("|cff%s            *** HUNTER SYSTEM v36.0 ***|r", color))
                syschat(string.format("|cff%s====================================================|r", color))
                syschat(string.format("|cffFFFFFF   Cacciatore: %s|r", name))
                syschat(string.format("|cff%s   Rank: [%s-RANK]|r", color, rank))

                -- Rank-based motivational quote
                local rank_quotes = {
                    E = "Ogni leggenda inizia da qui.",
                    D = "Stai emergendo dall'oscurita.",
                    C = "Il tuo nome inizia a circolare.",
                    B = "Pochi raggiungono questo livello.",
                    A = "Sei tra l'elite dei Cacciatori.",
                    S = "Il Sistema riconosce la tua supremazia.",
                    N = "Hai trasceso i limiti umani."
                }
                syschat(string.format("|cff888888   '%s'|r", rank_quotes[rank] or ""))
                syschat("|cffFFD700----------------------------------------------------|r")
                syschat(string.format("|cffFFFFFF   Gloria Totale: %d|r", glory))

                -- Streak bonus message con messaggi più epici
                if streak >= 30 then
                    syschat("|cffFF0000   !! STREAK x30 GIORNI !!|r")
                    syschat("|cffFFD700   BONUS MASSIMO: +20% Gloria|r")
                    syschat("|cffFFFFFF   'Una dedizione senza precedenti.'|r")
                    cmdchat("HunterSystemSpeak [IMMORTALE]_30_giorni_consecutivi!_Leggenda_vivente.")
                elseif streak >= 14 then
                    syschat("|cffFF9900   STREAK x14 GIORNI|r")
                    syschat("|cffFFFFFF   Bonus: +15% Gloria|r")
                    cmdchat("HunterSystemSpeak [STREAK]_14_giorni._Il_Sistema_e_impressionato.")
                elseif streak >= 7 then
                    syschat("|cff00FF00   STREAK x7 GIORNI|r")
                    syschat("|cffFFFFFF   Bonus: +10% Gloria|r")
                    cmdchat("HunterSystemSpeak [STREAK]_7_giorni!_Determinazione_assoluta.")
                elseif streak >= 3 then
                    syschat("|cff0099FF   STREAK x3 GIORNI|r")
                    syschat("|cffFFFFFF   Bonus: +5% Gloria|r")
                    cmdchat("HunterSystemSpeak Streak_attivo!_Continua_cosi.")
                else
                    syschat("|cffFFFFFF   Streak: " .. streak .. " giorni|r")
                end

                -- Query login message from database based on streak
                local msg_query = string.format(
                    "SELECT message_text FROM hunter_login_messages WHERE day_number = %d", streak
                )
                local msg_count, msg_result = mysql_direct_query(msg_query)

                if msg_count > 0 and msg_result[1] then
                    local message = msg_result[1][1] or ""  -- row[1] = message_text
                    message = string.gsub(message, "_", " ")
                    syschat(string.format("|cff%s   >> %s|r", color, message))
                end

                syschat("|cffFFD700----------------------------------------------------|r")
                syschat("|cffFFFFFF   Il Sistema monitora ogni tua azione.|r")
                syschat("|cffFFFFFF   Ogni nemico abbattuto ti avvicina alla gloria.|r")
                syschat(string.format("|cff%s====================================================|r", color))
                syschat("|cff00FFFF   [Y] - Apri Hunter Terminal|r")
                syschat(string.format("|cff%s====================================================|r", color))

                -- Message speak finale
                cmdchat("HunterSystemSpeak Bentornato,_" .. name .. "._Il_Sistema_ti_osserva.")
            end
        end

        -- ============================================================
        -- CLICK FRATTURE (when 16060.click ecc.)
        -- ============================================================

        when 16060.click or 16061.click or 16062.click or 16063.click or 16064.click or 16065.click or 16066.click begin
            local vnum = npc.get_race()

            -- Mappa VNUM fratture a rank
            local fracture_ranks = {
                [16060] = "E",
                [16061] = "D",
                [16062] = "C",
                [16063] = "B",
                [16064] = "A",
                [16065] = "S",
                [16066] = "N"
            }

            local rank = fracture_ranks[vnum] or "E"
            local pid = pc.get_player_id()

            -- Verifica rank player
            local query = string.format(
                "SELECT current_rank, total_glory FROM hunter_players WHERE player_id = %d", pid
            )
            local count, result = mysql_direct_query(query)

            if count == 0 or not result[1] then
                syschat("[HUNTER] Errore: dati player non trovati.")
                return
            end

            -- row[1]=current_rank, row[2]=total_glory
            local player_rank = result[1][1] or "E"
            local glory = tonumber(result[1][2]) or 0

            -- Rank order: E < D < C < B < A < S < N
            local rank_order = {E=1, D=2, C=3, B=4, A=5, S=6, N=7}
            local player_rank_level = rank_order[player_rank] or 1
            local fracture_rank_level = rank_order[rank] or 1

            -- Rank color mapping
            local rank_colors = {
                E = "|cff808080",  -- Gray
                D = "|cff00FF00",  -- Green
                C = "|cff0099FF",  -- Blue
                B = "|cffFF9900",  -- Orange
                A = "|cffFF0000",  -- Red
                S = "|cffFFD700",  -- Gold
                N = "|cffFF00FF"   -- Purple
            }

            local color = rank_colors[rank] or "|cffFFFFFF"

            syschat("========================================")
            syschat(color .. "[FRATTURA RANK " .. rank .. " RILEVATA]|r")
            syschat("========================================")

            -- Verifica se il player può accedere
            if player_rank_level < fracture_rank_level then
                -- Query fracture voice message from database
                local voice_query = string.format(
                    "SELECT text_value FROM hunter_texts WHERE text_key = 'fracture_voice_no_%s'",
                    rank_colors[rank]:gsub("|cff", ""):gsub("|r", "")  -- Extract color code
                )

                -- Fallback messages
                local denial_messages = {
                    E = "Non sei ancora degno.",
                    D = "Il cosmo ti rifiuta.",
                    C = "L'oscurita ti divorerebbe.",
                    B = "Troppo debole. Saresti solo cibo.",
                    A = "L'oro non brilla per i deboli.",
                    S = "Il fato ti ha gia condannato.",
                    N = "Non sei pronto per essere giudicato."
                }

                syschat(color .. "[VOCE FRATTURA]: " .. (denial_messages[rank] or "Torna quando sarai piu forte.") .. "|r")
                syschat("|cffFFFFFFRank richiesto: " .. rank .. " (Tuo rank: " .. player_rank .. ")|r")
                syschat("========================================")
                return
            end

            -- Player può entrare
            local acceptance_messages = {
                E = "L'energia primordiale ti chiama...",
                D = "Le stelle hanno scelto te.",
                C = "L'abisso ti fissa... e tu fissi l'abisso.",
                B = "Il sangue chiama sangue.",
                A = "La gloria attende chi osa.",
                S = "Il destino e scritto. Cambialo.",
                N = "Il Giudizio Finale ti attende."
            }

            syschat(color .. "[VOCE FRATTURA]: " .. (acceptance_messages[rank] or "Entra, se osi...") .. "|r")

            say("Questa frattura emana energia " .. rank .. "-Rank.")
            say("Vuoi iniziare la difesa?")
            say("")

            local choice = select("Inizia Difesa", "Chiudi")

            if choice == 1 then
                syschat(color .. "[SISTEMA] DIFESA FRATTURA INIZIATA!|r")
                syschat("|cffFFFFFFRimani vicino alla frattura per 60 secondi!|r")
                cmdchat("HunterSystemSpeak Difesa_Frattura_" .. rank .. "_iniziata!_Resisti!")

                -- Avvia sistema difesa (placeholder - richiede timer e spawn system)
                hunter_level_bridge3.start_fracture_defense(rank, vnum)
            end
        end

        function start_fracture_defense(rank, fracture_vnum)
            local pid = pc.get_player_id()

            -- Salva posizione player (NON npc!) e informazioni difesa
            pc.setqf("fracture_def_active", 1)
            pc.setqf("fracture_def_rank", string.byte(rank))  -- Salva come numero ASCII
            pc.setqf("fracture_def_start", get_time())
            pc.setqf("fracture_def_x", pc.get_x())  -- Posizione X del player
            pc.setqf("fracture_def_y", pc.get_y())  -- Posizione Y del player
            pc.setqf("fracture_def_wave", 0)
            pc.setqf("fracture_def_killed", 0)

            -- Query configurazione difesa
            local cfg_query = "SELECT config_value FROM hunter_fracture_defense_config WHERE config_key IN ('defense_duration', 'check_distance', 'spawn_start_delay') ORDER BY config_key"
            local cfg_count, cfg_result = mysql_direct_query(cfg_query)

            local defense_duration = 60
            local check_distance = 10
            local spawn_delay = 5

            if cfg_count > 0 then
                -- cfg_result[i][1] = config_value
                defense_duration = tonumber(cfg_result[1][1]) or 60
                if cfg_count > 1 then
                    check_distance = tonumber(cfg_result[2][1]) or 10
                end
                if cfg_count > 2 then
                    spawn_delay = tonumber(cfg_result[3][1]) or 5
                end
            end

            pc.setqf("fracture_def_duration", defense_duration)
            pc.setqf("fracture_def_distance", check_distance)

            -- Messaggi iniziali stile Solo Leveling
            syschat("|cffFFD700========================================|r")
            syschat("|cffFF0000[SISTEMA] DIFESA FRATTURA INIZIATA|r")
            syschat("|cffFFD700========================================|r")
            syschat("|cffFFFFFFDurata: " .. defense_duration .. " secondi|r")
            syschat("|cffFFFFFFDistanza massima: " .. check_distance .. " metri|r")
            syschat("|cffFF6600Prima ondata in " .. spawn_delay .. " secondi...|r")
            cmdchat("HunterSystemSpeak [DIFESA_INIZIATA]_Proteggere_la_frattura!")

            -- Avvia timer verifica posizione (ogni 2 secondi)
            server.timer("fracture_check_position", 2)

            -- Avvia timer prima ondata
            server.timer("fracture_spawn_wave", spawn_delay)
        end

        -- Timer verifica posizione player
        when fracture_check_position.timer begin
            if pc.getqf("fracture_def_active") == 0 then
                return  -- Difesa non attiva
            end

            local frac_x = pc.getqf("fracture_def_x")
            local frac_y = pc.getqf("fracture_def_y")
            local player_x = pc.get_local_x()
            local player_y = pc.get_local_y()
            local max_dist = pc.getqf("fracture_def_distance") * 100  -- Converti in unità gioco

            -- Calcola distanza
            local dx = player_x - frac_x
            local dy = player_y - frac_y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance > max_dist then
                -- Player troppo lontano - difesa fallita
                syschat("|cffFF0000[DIFESA FALLITA] Ti sei allontanato troppo!|r")
                cmdchat("HunterSystemSpeak DIFESA_FALLITA!_Sei_fuggito_dalla_battaglia.")
                pc.setqf("fracture_def_active", 0)
                return
            end

            -- Verifica se il tempo è scaduto
            local start_time = pc.getqf("fracture_def_start")
            local duration = pc.getqf("fracture_def_duration")
            local elapsed = get_time() - start_time

            if elapsed >= duration then
                -- Difesa completata!
                hunter_level_bridge3.complete_fracture_defense()
                return
            end

            -- Continua il timer
            server.timer("fracture_check_position", 2)
        end

        -- Timer spawn waves
        when fracture_spawn_wave.timer begin
            if pc.getqf("fracture_def_active") == 0 then
                return  -- Difesa non attiva
            end

            local current_wave = pc.getqf("fracture_def_wave") + 1
            local rank_ascii = pc.getqf("fracture_def_rank")
            local rank = string.char(rank_ascii)

            -- Query ondata corrente
            local query = string.format(
                "SELECT mob_vnum, mob_count, spawn_radius, spawn_time FROM hunter_fracture_defense_waves WHERE rank_grade = '%s' AND wave_number = %d AND enabled = 1",
                rank, current_wave
            )
            local count, result = mysql_direct_query(query)

            if count > 0 and result[1] then
                local wave = result[1]
                -- wave[1]=mob_vnum, wave[2]=mob_count, wave[3]=spawn_radius, wave[4]=spawn_time
                local mob_vnum = tonumber(wave[1]) or 101
                local mob_count = tonumber(wave[2]) or 5
                local radius = tonumber(wave[3]) or 7
                local current_spawn_time = tonumber(wave[4]) or 5
                local next_spawn_time = 15  -- Default 15 secondi tra ondate

                -- Ottieni prossimo spawn time se c'è un'altra ondata
                local next_query = string.format(
                    "SELECT spawn_time FROM hunter_fracture_defense_waves WHERE rank_grade = '%s' AND wave_number = %d AND enabled = 1",
                    rank, current_wave + 1
                )
                local next_count, next_result = mysql_direct_query(next_query)
                if next_count > 0 and next_result[1] then
                    next_spawn_time = tonumber(next_result[1][1]) - current_spawn_time  -- next_result[1][1] = spawn_time
                end

                -- Spawn mob intorno al player
                syschat("|cffFF6600[ONDATA " .. current_wave .. "] Spawning " .. mob_count .. " nemici!|r")
                cmdchat("HunterSystemSpeak ONDATA_" .. current_wave .. "!_Eliminali_tutti!")

                for i = 1, mob_count do
                    local angle = (math.pi * 2 / mob_count) * i
                    local spawn_x = pc.get_local_x() + math.cos(angle) * radius * 100
                    local spawn_y = pc.get_local_y() + math.sin(angle) * radius * 100
                    mob.spawn(mob_vnum, spawn_x, spawn_y, 0, 1, 0)
                end

                pc.setqf("fracture_def_wave", current_wave)

                -- Schedula prossima ondata se esiste
                if next_count > 0 then
                    server.timer("fracture_spawn_wave", next_spawn_time)
                end
            end
        end

        function complete_fracture_defense()
            local rank_ascii = pc.getqf("fracture_def_rank")
            local rank = string.char(rank_ascii)

            -- Reset flag
            pc.setqf("fracture_def_active", 0)

            -- Calcola ricompensa in base al rank
            local glory_rewards = {
                E = 300,
                D = 500,
                C = 800,
                B = 1200,
                A = 2000,
                S = 3500,
                N = 5000
            }

            local glory_reward = glory_rewards[rank] or 300

            -- Aggiorna database
            local pid = pc.get_player_id()
            local update_query = string.format(
                "UPDATE hunter_players SET total_glory = total_glory + %d, daily_glory = daily_glory + %d, weekly_glory = weekly_glory + %d, total_fractures = total_fractures + 1 WHERE player_id = %d",
                glory_reward, glory_reward, glory_reward, pid
            )
            mysql_direct_query(update_query)

            -- Messaggi vittoria stile Solo Leveling
            syschat("|cffFFD700========================================|r")
            syschat("|cff00FF00[DIFESA COMPLETATA]|r")
            syschat("|cffFFD700========================================|r")
            syschat("|cffFFFFFFFrattura Rank " .. rank .. " sigillata!|r")
            syschat("|cffFFD700++" .. glory_reward .. " GLORIA|r")
            syschat("|cffFFD700========================================|r")
            cmdchat("HunterSystemSpeak FRATTURA_SIGILLATA!_+" .. glory_reward .. "_Gloria!")

            -- Reinvia dati aggiornati al client
            hunter_level_bridge3.send_player_data()
        end

        -- ============================================================
        -- COMANDI CHAT
        -- ============================================================

        when chat."hunter_data" begin
            if pc.get_level() < hunter_level_bridge3.GetMinLevel() then
                syschat("Devi essere almeno livello " .. hunter_level_bridge3.GetMinLevel() .. ".")
                return
            end

            -- Invia i dati del player
            hunter_level_bridge3.send_player_data()
        end
        
        -- Nota come qui sotto ora uso hunter_level_bridge3
        when chat."hunter_ranking" with pc.get_level() >= hunter_level_bridge3.GetMinLevel() begin
            local ranking_type = input("Tipo classifica (daily/weekly/total):")
            if ranking_type == "" or ranking_type == nil then ranking_type = "daily" end
            if HUNTER and HUNTER.SendRanking then HUNTER.SendRanking(pc.get_player_id(), ranking_type) end
        end
        
        when chat."hunter_missions" with pc.get_level() >= hunter_level_bridge3.GetMinLevel() begin
            if HUNTER and HUNTER.GetMissions then
                local missions = HUNTER.GetMissions(pc.get_player_id())
                if missions then
                    for _, m in ipairs(missions) do
                        local m_name = string.gsub(m.mission_name, " ", "+")
                        cmdchat("HunterMissionData " .. m.slot .. "|" .. m_name .. "|" .. m.mission_type .. "|" .. m.current_progress .. "|" .. m.target_count .. "|" .. m.glory_reward .. "|" .. m.glory_penalty .. "|" .. m.status)
                    end
                end
            end
        end
        
        when chat."hunter_trial_start" with pc.get_level() >= hunter_level_bridge3.GetMinLevel() begin
            if HUNTER and HUNTER.StartTrial then HUNTER.StartTrial(pc.get_player_id()) end
        end
        
        when chat."hunter_gate" with pc.get_level() >= hunter_level_bridge3.GetMinLevel() begin
            local gate_id = tonumber(input("ID Gate:"))
            if gate_id and gate_id > 0 then
                if HUNTER and HUNTER.EnterGate then HUNTER.EnterGate(pc.get_player_id(), gate_id) end
            end
        end
        
        when chat."hunter_convert" with pc.get_level() >= hunter_level_bridge3.GetMinLevel() begin
            local amount_str = input("Quantita crediti:")
            local amount = tonumber(amount_str)
            if amount and amount > 0 then
                if HUNTER and HUNTER.ProcessActivity then HUNTER.ProcessActivity(pc.get_player_id(), "convert_credits", 0, amount, nil) end
            else
                syschat("Quantita non valida.")
            end
        end
        
        when chat."hunter_shop" with pc.get_level() >= hunter_level_bridge3.GetMinLevel() begin
            if HUNTER and HUNTER.Query then
                local items = HUNTER.Query("SELECT * FROM hunter_shop WHERE is_active = 1")
                if items and items[1] then
                    local entries = {}
                    for _, item in ipairs(items) do
                        local vnum = tonumber(item.item_vnum)
                        local name_raw = item_name(vnum)
                        local name_clean = "Item_" .. vnum
                        if name_raw then name_clean = string.gsub(name_raw, " ", "+") end
                        table.insert(entries, item.item_id .. "," .. item.item_vnum .. "," .. item.item_count .. "," .. item.price_credits .. "," .. name_clean)
                    end
                    cmdchat("HunterShopItems " .. table.concat(entries, ";"))
                else
                    syschat("Nessun oggetto disponibile.")
                end
            end
        end
        
        when chat."hunter_buy" with pc.get_level() >= hunter_level_bridge3.GetMinLevel() begin
            local item_id = tonumber(input("ID Item:"))
            if item_id and item_id > 0 then
                if HUNTER and HUNTER.ShopBuy then HUNTER.ShopBuy(pc.get_player_id(), item_id) end
            end
        end
        
    end
end