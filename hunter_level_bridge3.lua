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

            -- Invia TUTTI i dati al client (come nella vecchia versione)
            hunter_level_bridge3.send_player_data()

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

            if count > 0 and result[1] then
                local row = result[1]

                -- Calcola streak bonus basato su login_streak
                local login_streak = tonumber(row.login_streak) or 0
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
                local data_str = (row.player_name or pc.get_name()) .. "|" ..
                                 (tonumber(row.total_glory) or 0) .. "|" ..
                                 (tonumber(row.spendable_credits) or 0) .. "|" ..
                                 (tonumber(row.daily_glory) or 0) .. "|" ..
                                 (tonumber(row.weekly_glory) or 0) .. "|" ..
                                 (tonumber(row.total_kills) or 0) .. "|" ..
                                 (tonumber(row.daily_kills) or 0) .. "|" ..
                                 (tonumber(row.weekly_kills) or 0) .. "|" ..
                                 login_streak .. "|" .. streak_bonus .. "|" ..
                                 (tonumber(row.total_fractures) or 0) .. "|" ..
                                 (tonumber(row.total_chests) or 0) .. "|" ..
                                 (tonumber(row.total_metins) or 0) .. "|" ..
                                 (tonumber(row.total_bosses) or 0) .. "|0|" ..
                                 (tonumber(row.daily_position) or 0) .. "|" ..
                                 (tonumber(row.weekly_position) or 0)

                cmdchat("HunterPlayerData " .. data_str)
            else
                -- Player non trovato nel database, crea record nuovo
                local player_name = pc.get_name()
                local insert_query = string.format(
                    "INSERT INTO hunter_players (player_id, player_name) VALUES (%d, '%s')",
                    pid, mysql_escape_string(player_name)
                )
                mysql_direct_query(insert_query)

                -- Invia dati iniziali (tutto a 0) - 17 campi allineati a game.py
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
                    data_str = data_str .. (row.player_name or "Unknown") .. "," .. (tonumber(row.glory) or 0) .. ",0"
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
                    -- Format: item_id,item_vnum,item_count,price_credits,min_rank
                    local entry = (tonumber(row.item_id) or 0) .. "," ..
                                  (tonumber(row.item_vnum) or 0) .. "," ..
                                  (tonumber(row.item_count) or 1) .. "," ..
                                  (tonumber(row.price_credits) or 0) .. "," ..
                                  (row.min_rank or "E")
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
                total_kills = tonumber(stats_result[1].total_kills) or 0
                total_glory = tonumber(stats_result[1].total_glory) or 0
            end

            -- Get achievements config
            local query = "SELECT id, name, type, requirement, reward_vnum, reward_count FROM hunter_quest_achievements_config WHERE enabled = 1 ORDER BY type, requirement ASC"
            local count, result = mysql_direct_query(query)

            if count > 0 then
                local entries = {}
                for i = 1, count do
                    local row = result[i]
                    local ach_type = tonumber(row.type) or 1
                    local requirement = tonumber(row.requirement) or 0
                    local current_progress = 0
                    local status = "locked"

                    -- Type 1 = Kill count, Type 2 = Glory points
                    if ach_type == 1 then
                        current_progress = total_kills
                    else
                        current_progress = total_glory
                    end

                    -- Check if unlocked
                    if current_progress >= requirement then
                        status = "unlocked"
                    end

                    -- Format: id|name|type|requirement|current_progress|reward_vnum|reward_count|status
                    local name_clean = string.gsub(row.name or "Achievement", " ", "_")
                    local entry = (tonumber(row.id) or 0) .. "|" ..
                                  name_clean .. "|" ..
                                  ach_type .. "|" ..
                                  requirement .. "|" ..
                                  current_progress .. "|" ..
                                  (tonumber(row.reward_vnum) or 0) .. "|" ..
                                  (tonumber(row.reward_count) or 0) .. "|" ..
                                  status
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
                local rank = row.current_rank or "E"
                local streak = tonumber(row.login_streak) or 0
                local glory = tonumber(row.total_glory) or 0
                local name = row.player_name or pc.get_name()

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

                -- Invia messaggio di benvenuto base
                syschat(string.format("|cff%s========================================|r", color))
                syschat(string.format("|cff%s[HUNTER SYSTEM] Benvenuto, %s|r", color, name))
                syschat(string.format("|cff%s[RANK %s] Gloria: %d|r", color, rank, glory))

                -- Streak bonus message
                if streak >= 30 then
                    syschat("|cffFFD700[STREAK x30] BONUS MASSIMO +20% Gloria!|r")
                    cmdchat("HunterSystemSpeak [STREAK_MASTER]_30_giorni_consecutivi!_Leggenda_vivente.")
                elseif streak >= 14 then
                    syschat("|cffFF9900[STREAK x14] BONUS +15% Gloria!|r")
                    cmdchat("HunterSystemSpeak [STREAK]_14_giorni_di_dedizione._Impressionante.")
                elseif streak >= 7 then
                    syschat("|cff00FF00[STREAK x7] BONUS +10% Gloria!|r")
                    cmdchat("HunterSystemSpeak [STREAK]_7_giorni!_Il_Sistema_ti_osserva.")
                elseif streak >= 3 then
                    syschat("|cff0099FF[STREAK x3] BONUS +5% Gloria|r")
                    cmdchat("HunterSystemSpeak Streak_di_3_giorni._Continua_cosi!")
                end

                -- Query login message from database based on streak
                local msg_query = string.format(
                    "SELECT message_text FROM hunter_login_messages WHERE day_number = %d", streak
                )
                local msg_count, msg_result = mysql_direct_query(msg_query)

                if msg_count > 0 and msg_result[1] then
                    local message = msg_result[1].message_text or ""
                    message = string.gsub(message, "_", " ")
                    syschat("|cffFFFFFF" .. message .. "|r")
                end

                syschat(string.format("|cff%s========================================|r", color))
                syschat("|cff00FFFF[Y] - Apri Hunter Terminal|r")
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

            local player_rank = result[1].current_rank or "E"
            local glory = tonumber(result[1].total_glory) or 0

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
            -- Placeholder per sistema difesa completo
            -- Questo richiederebbe:
            -- 1. Timer per verificare posizione player
            -- 2. Spawn waves da database hunter_fracture_defense_waves
            -- 3. Verifica distanza dalla frattura
            -- 4. Ricompensa finale

            local pid = pc.get_player_id()

            syschat("[HUNTER] Sistema difesa frattura avviato!")
            syschat("[HUNTER] Funzionalita complete in sviluppo:")
            syschat("  - Spawn automatico ondate mob")
            syschat("  - Verifica posizione ogni 2 secondi")
            syschat("  - Ricompensa gloria al completamento")

            -- Per ora, invia un messaggio di placeholder
            cmdchat("HunterSystemSpeak Sistema_difesa_fratture_in_sviluppo.")
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