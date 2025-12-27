quest hunter_test_npc begin
    state start begin
        
        -- ============================================================
        -- NPC 9010 - TEST EFFETTI HUNTER SYSTEM
        -- Compatibile con sistema esistente + nuovi effetti
        -- NO WAIT() - usa cmdchat diretti
        -- ============================================================
        
        when 9010.click begin
            
            local function clean_str(str)
                if str == nil then return "" end
                return string.gsub(tostring(str), " ", "+")
            end
            
            if not pc.is_gm() then
                say_title("Accesso Negato")
                say("")
                say("Solo i Game Master possono accedere.")
                return
            end
            
            say_title("HUNTER TEST CENTER")
            say("")
            say("Player: " .. pc.get_name())
            say("")
            
            local main_sel = select(
                "1. EFFETTI GATE",
                "2. EFFETTI TRIAL",
                "3. RISVEGLI (Awakening)",
                "4. RANK UP",
                "5. SYSTEM SPEAK",
                "6. DEBUG DATABASE",
                "Chiudi"
            )

            -- [1] EFFETTI GATE
            if main_sel == 1 then
                say_title("EFFETTI GATE")
                say("")
                
                local fx = select(
                    "Gate Entry (Occhi Demoniaci)",
                    "Gate Victory (Esplosione Oro)",
                    "Gate Defeat (Schermo Rotto)",
                    "Indietro"
                )

                if fx == 1 then
                    cmdchat("HunterGateEntry Gate+dell+Ombra|RED")
                    say("Inviato: HunterGateEntry")
                    say("Effetto occhi demoniaci!")
                elseif fx == 2 then
                    cmdchat("HunterGateVictory Gate+Conquistato|750")
                    say("Inviato: HunterGateVictory")
                    say("Effetto vittoria dorata!")
                elseif fx == 3 then
                    cmdchat("HunterGateDefeat 300")
                    say("Inviato: HunterGateDefeat")
                    say("Effetto schermo rotto!")
                end

            -- [2] EFFETTI TRIAL
            elseif main_sel == 2 then
                say_title("EFFETTI TRIAL")
                say("")
                
                local fx = select(
                    "Progress Popup - Boss",
                    "Progress Popup - Metin",
                    "Progress Popup - Frattura",
                    "Progress Popup - Baule",
                    "Progress Popup - Missione",
                    "Indietro"
                )

                if fx == 1 then
                    cmdchat("HunterTrialProgressPopup boss|3|5")
                    say("Popup Boss 3/5")
                elseif fx == 2 then
                    cmdchat("HunterTrialProgressPopup metin|7|10")
                    say("Popup Metin 7/10")
                elseif fx == 3 then
                    cmdchat("HunterTrialProgressPopup fracture|2|3")
                    say("Popup Frattura 2/3")
                elseif fx == 4 then
                    cmdchat("HunterTrialProgressPopup chest|4|5")
                    say("Popup Baule 4/5")
                elseif fx == 5 then
                    cmdchat("HunterTrialProgressPopup mission|1|3")
                    say("Popup Missione 1/3")
                end

            -- [3] RISVEGLI (Awakening)
            elseif main_sel == 3 then
                say_title("RISVEGLI")
                say("")
                
                local fx = select(
                    "Lv.5 - Risveglio Iniziale",
                    "Lv.30 - Risveglio Hunter",
                    "Lv.50 - Meta Cammino",
                    "Lv.100 - CENTENARIO",
                    "Lv.130 - LEGGENDA VIVENTE",
                    "Indietro"
                )

                if fx == 1 then
                    cmdchat("HunterAwakening 5")
                    say("Risveglio Lv.5!")
                elseif fx == 2 then
                    cmdchat("HunterAwakening 30")
                    say("Risveglio Lv.30!")
                elseif fx == 3 then
                    cmdchat("HunterAwakening 50")
                    say("Risveglio Lv.50!")
                elseif fx == 4 then
                    cmdchat("HunterAwakening 100")
                    say("Risveglio Lv.100!")
                elseif fx == 5 then
                    cmdchat("HunterAwakening 130")
                    say("Risveglio Lv.130!")
                end

            -- [4] RANK UP
            elseif main_sel == 4 then
                say_title("RANK UP")
                say("")
                
                local fx = select(
                    "E -> D",
                    "D -> C",
                    "C -> B",
                    "B -> A",
                    "A -> S",
                    "S -> N",
                    "Indietro"
                )

                local ranks = {
                    {"E", "D"},
                    {"D", "C"},
                    {"C", "B"},
                    {"B", "A"},
                    {"A", "S"},
                    {"S", "N"}
                }

                if fx >= 1 and fx <= 6 then
                    local old = ranks[fx][1]
                    local new = ranks[fx][2]
                    cmdchat("HunterRankUp " .. old .. "|" .. new)
                    say("Rank Up: " .. old .. " -> " .. new)
                end

            -- [5] SYSTEM SPEAK
            elseif main_sel == 5 then
                say_title("SYSTEM SPEAK")
                say("")
                
                local fx = select(
                    "Messaggio E-Rank (Grigio)",
                    "Messaggio D-Rank (Verde)",
                    "Messaggio C-Rank (Cyan)",
                    "Messaggio B-Rank (Blu)",
                    "Messaggio A-Rank (Viola)",
                    "Messaggio S-Rank (Arancio)",
                    "Messaggio N-Rank (Rosso)",
                    "Indietro"
                )

                local ranks = {"E", "D", "C", "B", "A", "S", "N"}
                if fx >= 1 and fx <= 7 then
                    local r = ranks[fx]
                    cmdchat("HunterSystemSpeak " .. r .. "|Messaggio+di+test+" .. r .. "-Rank")
                    say("System Speak " .. r .. "-Rank inviato!")
                end

            -- [6] DEBUG DATABASE
            elseif main_sel == 6 then
                say_title("DEBUG DATABASE")
                say("")
                
                local pid = pc.get_player_id()
                local db = "srv1_hunabku"
                
                local dsel = select(
                    "Info Player Ranking",
                    "Reset Rank a E",
                    "Aggiungi +1000 Gloria",
                    "Indietro"
                )

                if dsel == 1 then
                    local c, d = mysql_direct_query("SELECT total_points, hunter_rank FROM " .. db .. ".hunter_quest_ranking WHERE player_id=" .. pid)
                    if c > 0 and d[1] then
                        say("Punti: " .. (d[1].total_points or 0))
                        say("Rank: " .. (d[1].hunter_rank or "E"))
                    else
                        say("Non trovato nel ranking!")
                    end
                elseif dsel == 2 then
                    mysql_direct_query("UPDATE " .. db .. ".hunter_quest_ranking SET hunter_rank='E', current_rank='E' WHERE player_id=" .. pid)
                    say("Rank resettato a E!")
                elseif dsel == 3 then
                    mysql_direct_query("UPDATE " .. db .. ".hunter_quest_ranking SET total_points = total_points + 1000 WHERE player_id=" .. pid)
                    say("+1000 Gloria!")
                end
            end

        end
    end
end
