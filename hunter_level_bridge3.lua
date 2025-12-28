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
            -- Placeholder: invia lista vuota per ora
            -- Puoi popolare hunter_shop table nel DB se vuoi oggetti vendibili
            cmdchat("HunterShopItems EMPTY")
        end

        function send_achievements()
            -- Placeholder: invia lista vuota per ora
            -- Puoi popolare hunter_achievements table nel DB
            cmdchat("HunterAchievements EMPTY")
        end

        -- ============================================================
        -- CLICK FRATTURE (when 16060.click ecc.)
        -- ============================================================

        when 16060.click or 16061.click or 16062.click or 16063.click or 16064.click or 16065.click or 16066.click begin
            local vnum = npc.get_race()
            syschat("[HUNTER] Frattura rilevata! VNUM: " .. vnum)
            syschat("[HUNTER] Sistema Gate non ancora implementato completamente.")
            syschat("[HUNTER] Il sistema completo arriverà nelle prossime versioni.")
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