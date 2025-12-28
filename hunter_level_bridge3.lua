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
            -- Il Python gestirà automaticamente la richiesta dati in Open()
            cmdchat("HunterOpenUI")

            -- Mantieni la lettera aperta per click futuri
            send_letter("Hunter System")
        end

        -- ============================================================
        -- COMANDI CHAT
        -- ============================================================

        when chat."hunter_data" begin
            if pc.get_level() < hunter_level_bridge3.GetMinLevel() then
                syschat("Devi essere almeno livello " .. hunter_level_bridge3.GetMinLevel() .. ".")
                return
            end

            -- Recupera dati dal database MySQL
            local player_id = pc.get_player_id()
            -- Ordine query allineato a game.py __HunterPlayerData:
            -- name|total_points|spendable_points|daily_points|weekly_points|total_kills|daily_kills|weekly_kills|
            -- login_streak|total_fractures|total_chests|total_metins|total_bosses|daily_pos|weekly_pos
            local query = string.format(
                "SELECT player_name, total_glory, spendable_credits, daily_glory, weekly_glory, " ..
                "total_kills, daily_kills, weekly_kills, login_streak, " ..
                "total_fractures, total_chests, total_metins, total_bosses, " ..
                "daily_position, weekly_position " ..
                "FROM hunter_players WHERE player_id = %d", player_id
            )

            local result = mysql_query(query)

            if result and result[1] then
                local row = result[1]

                -- Calcola streak bonus basato su login_streak
                local login_streak = tonumber(row[9]) or 0
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
                local data_str = row[1] .. "|" .. row[2] .. "|" .. row[3] .. "|" .. row[4] .. "|" .. row[5] .. "|" ..
                                 row[6] .. "|" .. row[7] .. "|" .. row[8] .. "|" .. row[9] .. "|" .. streak_bonus .. "|" ..
                                 row[10] .. "|" .. row[11] .. "|" .. row[12] .. "|" .. row[13] .. "|0|" ..
                                 row[14] .. "|" .. row[15]

                cmdchat("HunterPlayerData " .. data_str)
            else
                -- Player non trovato nel database, crea record nuovo
                local player_name = pc.get_name()
                local insert_query = string.format(
                    "INSERT INTO hunter_players (player_id, player_name) VALUES (%d, '%s')",
                    player_id, player_name
                )
                mysql_query(insert_query)

                -- Invia dati iniziali (tutto a 0) - 17 campi allineati a game.py
                cmdchat("HunterPlayerData " .. player_name .. "|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0")
            end
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