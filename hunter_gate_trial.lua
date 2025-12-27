--[[
============================================================
HUNTER SYSTEM - GATE DUNGEON & RANK TRIAL
============================================================
Versione: 2.5 FIXED
NPC: 20019 = Guardiano Gate | 20020 = Maestro Prove
============================================================
--]]

quest hunter_gate_trial begin
    state start begin

        function get_config(key)
            local config = {
                ["gate_guardian_npc"] = 20019,
                ["trial_master_npc"] = 20020,
                ["gate_access_hours"] = 2,
                ["gate_death_penalty"] = 500,
                ["db_name"] = "srv1_hunabku",
            }
            return config[key]
        end
        
        function modulo(a, b)
            return a - math.floor(a / b) * b
        end

        function format_time(seconds)
            if not seconds or seconds <= 0 then
                return "00:00:00"
            end
            local h = math.floor(seconds / 3600)
            local rem_h = hunter_gate_trial.modulo(seconds, 3600)
            local m = math.floor(rem_h / 60)
            local s = hunter_gate_trial.modulo(seconds, 60)
            return string.format("%02d:%02d:%02d", h, m, s)
        end
        
        function format_time_days(seconds)
            if not seconds or seconds <= 0 then
                return "Scaduto"
            end
            local d = math.floor(seconds / 86400)
            local rem_d = hunter_gate_trial.modulo(seconds, 86400)
            local h = math.floor(rem_d / 3600)
            local rem_h = hunter_gate_trial.modulo(rem_d, 3600)
            local m = math.floor(rem_h / 60)
            if d > 0 then
                return string.format("%dg %02d:%02d", d, h, m)
            else
                return string.format("%02d:%02d:%02d", h, m, hunter_gate_trial.modulo(rem_h, 60))
            end
        end
        
        function clean_str(s)
            if not s then return "" end
            return string.gsub(tostring(s), " ", "+")
        end
        
        function get_rank_hex(color_code)
            local colors = {
                ["E"] = "808080", ["D"] = "00FF00", ["C"] = "00FFFF",
                ["B"] = "0066FF", ["A"] = "AA00FF", ["S"] = "FF6600", ["N"] = "FF0000",
                ["GREEN"] = "00FF00", ["BLUE"] = "0099FF", ["CYAN"] = "00FFFF",
                ["ORANGE"] = "FF6600", ["RED"] = "FF0000", ["GOLD"] = "FFD700",
                ["PURPLE"] = "9900FF", ["BLACKWHITE"] = "FFFFFF"
            }
            return colors[color_code] or "FFFFFF"
        end
        
        function get_player_rank()
            local pid = pc.get_player_id()
            local db = hunter_gate_trial.get_config("db_name")
            local q = "SELECT hunter_rank FROM " .. db .. ".hunter_quest_ranking WHERE player_id=" .. pid
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] then
                return d[1].hunter_rank or "E"
            end
            return "E"
        end
        
        function get_player_gloria()
            local pid = pc.get_player_id()
            local db = hunter_gate_trial.get_config("db_name")
            local q = "SELECT total_points FROM " .. db .. ".hunter_quest_ranking WHERE player_id=" .. pid
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] then
                return tonumber(d[1].total_points) or 0
            end
            return 0
        end
        
        function add_gloria(amount)
            local pid = pc.get_player_id()
            local db = hunter_gate_trial.get_config("db_name")
            if amount >= 0 then
                mysql_direct_query("UPDATE " .. db .. ".hunter_quest_ranking SET total_points = total_points + " .. amount .. ", daily_points = daily_points + " .. amount .. " WHERE player_id=" .. pid)
            else
                mysql_direct_query("UPDATE " .. db .. ".hunter_quest_ranking SET total_points = GREATEST(0, total_points + " .. amount .. ") WHERE player_id=" .. pid)
            end
        end
        
        function speak_color(msg, color)
            local rank = hunter_gate_trial.get_player_rank()
            cmdchat("HunterSystemSpeak " .. (color or rank) .. "|" .. hunter_gate_trial.clean_str(msg))
        end
        
        function show_gate_entry_effect(gate_name, color_code)
            cmdchat("HunterGateEntry " .. hunter_gate_trial.clean_str(gate_name) .. "|" .. color_code)
        end
        
        function show_gate_victory_effect(gate_name, gloria_earned)
            cmdchat("HunterGateVictory " .. hunter_gate_trial.clean_str(gate_name) .. "|" .. gloria_earned)
        end
        
        function show_gate_defeat_effect(gloria_penalty)
            cmdchat("HunterGateDefeat " .. gloria_penalty)
        end
        
        function show_trial_progress(progress_type, current, required)
            cmdchat("HunterTrialProgressPopup " .. progress_type .. "|" .. current .. "|" .. required)
        end
        
        function show_rank_up_effect(old_rank, new_rank)
            cmdchat("HunterRankUp " .. old_rank .. "|" .. new_rank)
        end
        
        function check_gate_access()
            local pid = pc.get_player_id()
            local db = hunter_gate_trial.get_config("db_name")
            
            -- Query con gestione errori
            local q = "SELECT ga.access_id, ga.gate_id, gc.gate_name, gc.color_code, "
            q = q .. "gc.dungeon_index, gc.boss_vnum, gc.duration_minutes, gc.gloria_reward, gc.gloria_penalty, "
            q = q .. "TIMESTAMPDIFF(SECOND, NOW(), ga.expires_at) as remaining_seconds "
            q = q .. "FROM " .. db .. ".hunter_gate_access ga "
            q = q .. "JOIN " .. db .. ".hunter_gate_config gc ON ga.gate_id = gc.gate_id "
            q = q .. "WHERE ga.player_id = " .. pid .. " "
            q = q .. "AND ga.status = 'pending' AND ga.expires_at > NOW() LIMIT 1"

            local c, d = 0, nil
            local ok, err = pcall(function()
                c, d = mysql_direct_query(q)
            end)
            
            -- Se errore SQL, ritorna has_access = false
            if not ok then
                syschat("[DEBUG] Errore SQL check_gate_access: " .. tostring(err))
                return { has_access = false, error = true }
            end
            
            if c and c > 0 and d and d[1] then
                return {
                    has_access = true,
                    access_id = tonumber(d[1].access_id) or 0,
                    gate_id = tonumber(d[1].gate_id) or 0,
                    gate_name = d[1].gate_name or "Gate Sconosciuto",
                    color_code = d[1].color_code or "RED",
                    dungeon_index = tonumber(d[1].dungeon_index) or 1,
                    boss_vnum = tonumber(d[1].boss_vnum) or 0,
                    duration_minutes = tonumber(d[1].duration_minutes) or 30,
                    gloria_reward = tonumber(d[1].gloria_reward) or 500,
                    gloria_penalty = tonumber(d[1].gloria_penalty) or 250,
                    remaining_seconds = tonumber(d[1].remaining_seconds) or 0
                }
            end
            
            return { has_access = false }
        end
        
        function send_gate_status()
            local access = hunter_gate_trial.check_gate_access()
            if access.has_access then
                local pkt = access.gate_id .. "|" ..
                            hunter_gate_trial.clean_str(access.gate_name) .. "|" ..
                            access.remaining_seconds .. "|" ..
                            access.color_code
                cmdchat("HunterGateStatus " .. pkt)
            else
                cmdchat("HunterGateStatus 0|NONE|0|NONE")
            end
        end
        
        function guardian_interaction()
            if pc.is_gm() then
                say_title("GM MENU Guardiano Gate")
                local gm_sel = select("Interazione Normale", "GM Resetta Accessi", "GM Simula Vittoria", "GM Simula Fallimento", "GM Grant Gate 1", "Chiudi")
                if gm_sel == 6 then return end
                if gm_sel == 2 then
                    local db = hunter_gate_trial.get_config("db_name")
                    mysql_direct_query("DELETE FROM " .. db .. ".hunter_gate_access WHERE player_id=" .. pc.get_player_id())
                    syschat("Accessi resettati.")
                    return
                elseif gm_sel == 3 then
                    pc.setqf("hgt_in_gate", 1)
                    pc.setqf("hgt_gate_id", 1)
                    pc.setqf("hgt_gate_start", get_time() - 300)
                    pc.setqf("hgt_gate_duration", 1800)
                    pc.setqf("hgt_gloria_reward", 750)
                    pc.setqf("hgt_gloria_penalty", 300)
                    hunter_gate_trial.complete_gate(true)
                    return
                elseif gm_sel == 4 then
                    pc.setqf("hgt_in_gate", 1)
                    pc.setqf("hgt_gate_id", 1)
                    pc.setqf("hgt_gate_start", get_time() - 300)
                    pc.setqf("hgt_gate_duration", 1800)
                    pc.setqf("hgt_gloria_reward", 500)
                    pc.setqf("hgt_gloria_penalty", 250)
                    hunter_gate_trial.complete_gate(false)
                    return
                elseif gm_sel == 5 then
                    local db = hunter_gate_trial.get_config("db_name")
                    mysql_direct_query("INSERT INTO " .. db .. ".hunter_gate_access (player_id, player_name, gate_id, expires_at, status) VALUES (" .. pc.get_player_id() .. ", '" .. pc.get_name() .. "', 1, DATE_ADD(NOW(), INTERVAL 2 HOUR), 'pending') ON DUPLICATE KEY UPDATE expires_at = DATE_ADD(NOW(), INTERVAL 2 HOUR), status = 'pending'")
                    syschat("Gate 1 concesso!")
                    hunter_gate_trial.send_gate_status()
                    return
                end
                -- Se gm_sel == 1, continua con interazione normale
            end
            
            local pid = pc.get_player_id()
            local pname = pc.get_name()
            local db = hunter_gate_trial.get_config("db_name")
            
            -- Prova a ottenere accesso con gestione errori
            local access = nil
            local ok, err = pcall(function()
                access = hunter_gate_trial.check_gate_access()
            end)
            
            -- Se errore o access nil, mostra messaggio sicuro
            if not ok or not access then
                say_title("GUARDIANO DEL GATE")
                say("")
                say("Il Sistema sta verificando il tuo status...")
                say("")
                say("Errore nel controllo accesso.")
                say("Contatta un GM se il problema persiste.")
                syschat("[DEBUG] Errore check_gate_access: " .. tostring(err))
                return
            end
            
            if not access.has_access then
                say_title("GUARDIANO DEL GATE")
                say("")
                say("Il Sistema non ti ha scelto.")
                say("")
                say("Solo coloro che il Sistema designa")
                say("possono varcare questa soglia.")
                say("")
                say("La tua arroganza sara punita...")
                
                
                cmdchat("HunterGateDefeat 500")
                
                notice_all("")
                notice_all("[GATE DUNGEON] " .. pname .. " ha tentato di entrare nel Gate senza permesso...")
                notice_all("Il Guardiano non perdona.")
                notice_all("")
                
                local penalty = hunter_gate_trial.get_config("gate_death_penalty")
                hunter_gate_trial.add_gloria(-penalty)
                
                local qlog = "INSERT INTO " .. db .. ".hunter_gate_history "
                qlog = qlog .. "(player_id, player_name, gate_id, gate_name, result, gloria_change) "
                qlog = qlog .. "VALUES (" .. pid .. ", '" .. pname .. "', 0, 'Accesso Negato', 'death', -" .. penalty .. ")"
                mysql_direct_query(qlog)
                
                pc.kill()
                return
            end
            
            say_title("GUARDIANO DEL GATE")
            say("")
            say("Il Sistema ti ha scelto.")
            say("")
            say("Gate: " .. access.gate_name)
            say("Tempo rimasto: " .. hunter_gate_trial.format_time(access.remaining_seconds))
            say("Durata dungeon: " .. access.duration_minutes .. " minuti")
            say("")
            say("Ricompensa: +" .. access.gloria_reward .. " Gloria")
            say("Penalita fallimento: -" .. access.gloria_penalty .. " Gloria")
            say("")
            
            local sel = select("Entra nel Gate", "Non sono pronto", "Apri Finestra Hunter", "Annulla")
            if sel == 1 then
                say_title("SISTEMA")
                say("")
                say("ATTENZIONE!")
                say("")
                say("Una volta entrato, hai " .. access.duration_minutes .. " minuti")
                say("per completare il dungeon.")
                say("")
                say("Se muori o il tempo scade, perderai Gloria!")
                say("")
                local confirm = select("ENTRA ORA", "Ci devo pensare")
                if confirm == 1 then
                    hunter_gate_trial.show_gate_entry_effect(access.gate_name, access.color_code)
                    
                    local qupd = "UPDATE " .. db .. ".hunter_gate_access "
                    qupd = qupd .. "SET status = 'entered', entered_at = NOW() "
                    qupd = qupd .. "WHERE access_id = " .. access.access_id
                    mysql_direct_query(qupd)
                    
                    pc.setqf("hgt_in_gate", 1)
                    pc.setqf("hgt_gate_id", access.gate_id)
                    pc.setqf("hgt_access_id", access.access_id)
                    pc.setqf("hgt_gate_boss_vnum", access.boss_vnum)
                    pc.setqf("hgt_gate_start", get_time())
                    pc.setqf("hgt_gate_duration", access.duration_minutes * 60)
                    pc.setqf("hgt_gloria_reward", access.gloria_reward)
                    pc.setqf("hgt_gloria_penalty", access.gloria_penalty)
                    pc.setqf("hgt_gate_name", access.gate_name)
                    pc.setqf("hgt_gate_color", access.color_code)
                    
                    notice_all("")
                    notice_all("[GATE DUNGEON] " .. pname .. " e entrato nel " .. access.gate_name .. "!")
                    notice_all("")
                    
                    cmdchat("HunterGateEnter " .. access.gate_id .. "|" .. access.duration_minutes)
                    hunter_gate_trial.speak_color("ACCESSO AL GATE CONCESSO!", access.color_code)
                    syschat("[SISTEMA] Teletrasporto al Gate in corso...")
                end
            elseif sel == 2 then
                say_title("GUARDIANO")
                say("")
                say("Saggio. Preparati bene prima di affrontare")
                say("le prove che ti attendono.")
                say("")
                say("Tempo rimasto: " .. hunter_gate_trial.format_time(access.remaining_seconds))
            elseif sel == 3 then
                hunter_gate_trial.open_gate_trial_window()
            end
        end
        
        function complete_gate(success)
            local pid = pc.get_player_id()
            local pname = pc.get_name()
            local db = hunter_gate_trial.get_config("db_name")
            
            local in_gate = pc.getqf("hgt_in_gate") or 0
            if in_gate ~= 1 then return end
            
            local gate_id = pc.getqf("hgt_gate_id") or 0
            local access_id = pc.getqf("hgt_access_id") or 0
            local start_time = pc.getqf("hgt_gate_start") or 0
            local duration = pc.getqf("hgt_gate_duration") or 1800
            local reward = pc.getqf("hgt_gloria_reward") or 500
            local penalty = pc.getqf("hgt_gloria_penalty") or 250
            
            pc.setqf("hgt_in_gate", 0)
            pc.setqf("hgt_gate_id", 0)
            pc.setqf("hgt_access_id", 0)
            
            local elapsed = get_time() - start_time
            local result = success and "completed" or "failed"
            
            local qg = "SELECT gate_name, color_code FROM " .. db .. ".hunter_gate_config WHERE gate_id=" .. gate_id
            local cg, dg = mysql_direct_query(qg)
            local gate_name = "Gate"
            local color = "BLUE"
            if cg > 0 and dg[1] then
                gate_name = dg[1].gate_name
                color = dg[1].color_code
            end
            
            local gloria_change = 0
            
            if success then
                gloria_change = reward
                
                if elapsed < (duration / 2) then
                    local time_bonus = math.floor(reward * 0.5)
                    gloria_change = gloria_change + time_bonus
                    hunter_gate_trial.speak_color("BONUS VELOCITA! +" .. time_bonus .. " Gloria extra!", "GOLD")
                end
                
                hunter_gate_trial.add_gloria(gloria_change)
                hunter_gate_trial.show_gate_victory_effect(gate_name, gloria_change)
                hunter_gate_trial.speak_color("GATE COMPLETATO! +" .. gloria_change .. " GLORIA", color)
                
                notice_all("")
                notice_all("============================================")
                notice_all("[GATE DUNGEON] COMPLETATO!")
                notice_all(pname .. " ha conquistato il " .. gate_name .. "!")
                notice_all("+" .. gloria_change .. " Gloria (Tempo: " .. hunter_gate_trial.format_time(elapsed) .. ")")
                notice_all("============================================")
                notice_all("")
                
                cmdchat("HunterGateComplete 1|" .. gloria_change)
            else
                gloria_change = -penalty
                hunter_gate_trial.add_gloria(-penalty)
                hunter_gate_trial.show_gate_defeat_effect(penalty)
                hunter_gate_trial.speak_color("GATE FALLITO! -" .. penalty .. " GLORIA", "RED")
                
                notice_all("")
                notice_all("============================================")
                notice_all("[GATE DUNGEON] FALLITO!")
                notice_all(pname .. " e caduto nel " .. gate_name .. "!")
                notice_all("-" .. penalty .. " Gloria")
                notice_all("============================================")
                notice_all("")
                
                cmdchat("HunterGateComplete 0|" .. penalty)
            end
            
            mysql_direct_query("UPDATE " .. db .. ".hunter_gate_access SET status='" .. result .. "', completed_at=NOW(), gloria_earned=" .. gloria_change .. " WHERE access_id=" .. access_id)
            
            local qlog = "INSERT INTO " .. db .. ".hunter_gate_history "
            qlog = qlog .. "(player_id, player_name, gate_id, gate_name, result, gloria_change, duration_seconds) "
            qlog = qlog .. "VALUES (" .. pid .. ", '" .. pname .. "', " .. gate_id .. ", '" .. gate_name .. "', '" .. result .. "', " .. gloria_change .. ", " .. elapsed .. ")"
            mysql_direct_query(qlog)
            
            hunter_gate_trial.send_gate_status()
        end
        
        function check_trial_available()
            local pid = pc.get_player_id()
            local db = hunter_gate_trial.get_config("db_name")
            local current_rank = hunter_gate_trial.get_player_rank()
            local current_points = hunter_gate_trial.get_player_gloria()
            
            if current_rank == "N" then
                return { available = false, message = "Hai raggiunto il rank massimo!", at_max = true }
            end
            
            local qt = "SELECT trial_id, trial_name, trial_description, to_rank, required_gloria, required_level, "
            qt = qt .. "required_boss_kills, boss_vnum_list, required_metin_kills, metin_vnum_list, "
            qt = qt .. "required_fracture_seals, required_chest_opens, required_daily_missions, "
            qt = qt .. "time_limit_hours, gloria_reward, title_reward, color_code "
            qt = qt .. "FROM " .. db .. ".hunter_rank_trials "
            qt = qt .. "WHERE from_rank = '" .. current_rank .. "' AND enabled = 1 LIMIT 1"
            
            local ct, dt = mysql_direct_query(qt)
            
            if ct == 0 or not dt[1] then
                return { available = false, message = "Nessuna prova disponibile per il tuo rank." }
            end
            
            local trial = dt[1]
            
            local qp = "SELECT status FROM " .. db .. ".hunter_player_trials WHERE player_id=" .. pid .. " AND trial_id=" .. trial.trial_id .. " ORDER BY started_at DESC LIMIT 1"
            local cp, dp = mysql_direct_query(qp)
            
            if cp > 0 and dp[1] then
                if dp[1].status == "completed" then
                    return { available = false, message = "Hai gia completato questa prova." }
                elseif dp[1].status == "in_progress" then
                    return { available = false, message = "Hai gia una prova in corso.", in_progress = true, trial_id = tonumber(trial.trial_id) }
                end
            end
            
            local req_gloria = tonumber(trial.required_gloria) or 0
            if current_points < req_gloria then
                return {
                    available = false,
                    message = "Gloria insufficiente. Richiesti: " .. req_gloria,
                    missing_gloria = req_gloria - current_points
                }
            end
            
            local req_level = tonumber(trial.required_level) or 1
            if pc.get_level() < req_level then
                return {
                    available = false,
                    message = "Livello insufficiente. Richiesto: " .. req_level,
                    missing_level = req_level - pc.get_level()
                }
            end
            
            return {
                available = true,
                trial_id = tonumber(trial.trial_id),
                trial_name = trial.trial_name,
                trial_description = trial.trial_description,
                to_rank = trial.to_rank,
                required = {
                    boss_kills = tonumber(trial.required_boss_kills) or 0,
                    metin_kills = tonumber(trial.required_metin_kills) or 0,
                    fracture_seals = tonumber(trial.required_fracture_seals) or 0,
                    chest_opens = tonumber(trial.required_chest_opens) or 0,
                    daily_missions = tonumber(trial.required_daily_missions) or 0
                },
                boss_vnum_list = trial.boss_vnum_list,
                metin_vnum_list = trial.metin_vnum_list,
                time_limit_hours = tonumber(trial.time_limit_hours),
                gloria_reward = tonumber(trial.gloria_reward) or 0,
                title_reward = trial.title_reward,
                color_code = trial.color_code
            }
        end
        
        function start_trial()
            local pid = pc.get_player_id()
            local pname = pc.get_name()
            local db = hunter_gate_trial.get_config("db_name")
            
            local check = hunter_gate_trial.check_trial_available()
            
            if not check.available then
                hunter_gate_trial.speak_color(check.message, "RED")
                return false
            end
            
            local trial_id = check.trial_id
            local time_limit = check.time_limit_hours
            
            local expires_sql = "NULL"
            if time_limit then
                expires_sql = "DATE_ADD(NOW(), INTERVAL " .. time_limit .. " HOUR)"
            end
            
            local qins = "INSERT INTO " .. db .. ".hunter_player_trials "
            qins = qins .. "(player_id, trial_id, status, started_at, expires_at, boss_kills, metin_kills, fracture_seals, chest_opens, daily_missions) "
            qins = qins .. "VALUES (" .. pid .. ", " .. trial_id .. ", 'in_progress', NOW(), " .. expires_sql .. ", 0, 0, 0, 0, 0) "
            qins = qins .. "ON DUPLICATE KEY UPDATE "
            qins = qins .. "status = 'in_progress', started_at = NOW(), expires_at = " .. expires_sql .. ", "
            qins = qins .. "boss_kills = 0, metin_kills = 0, fracture_seals = 0, chest_opens = 0, daily_missions = 0"
            
            mysql_direct_query(qins)
            
            pc.setqf("hgt_trial_id", trial_id)
            pc.setqf("hgt_trial_active", 1)
            pc.setqf("hgt_trial_old_rank", hunter_gate_trial.get_player_rank())
            
            notice_all("")
            notice_all("============================================")
            notice_all("[HUNTER SYSTEM] NUOVA PROVA INIZIATA!")
            notice_all(pname .. " ha iniziato la " .. check.trial_name .. "!")
            notice_all("Obiettivo: Diventare " .. check.to_rank .. "-RANK")
            notice_all("============================================")
            notice_all("")
            
            hunter_gate_trial.speak_color("PROVA INIZIATA: " .. check.trial_name, check.color_code)
            cmdchat("HunterTrialStart " .. trial_id .. "|" .. hunter_gate_trial.clean_str(check.trial_name) .. "|" .. check.to_rank .. "|" .. check.color_code)
            hunter_gate_trial.send_trial_status()
            
            clear_letter()
            
            return true
        end
        
        function get_trial_progress()
            local pid = pc.get_player_id()
            local db = hunter_gate_trial.get_config("db_name")
            local trial_id = pc.getqf("hgt_trial_id") or 0
            
            if trial_id == 0 then
                local q = "SELECT trial_id FROM " .. db .. ".hunter_player_trials WHERE player_id=" .. pid .. " AND status='in_progress' LIMIT 1"
                local c, d = mysql_direct_query(q)
                if c > 0 and d[1] then
                    trial_id = tonumber(d[1].trial_id)
                    pc.setqf("hgt_trial_id", trial_id)
                    pc.setqf("hgt_trial_active", 1)
                else
                    pc.setqf("hgt_trial_active", 0)
                    return nil
                end
            end
            
            local q = "SELECT pt.*, rt.trial_name, rt.to_rank, rt.required_boss_kills, rt.required_metin_kills, "
            q = q .. "rt.required_fracture_seals, rt.required_chest_opens, rt.required_daily_missions, "
            q = q .. "rt.boss_vnum_list, rt.metin_vnum_list, rt.gloria_reward, rt.title_reward, rt.color_code, "
            q = q .. "TIMESTAMPDIFF(SECOND, NOW(), pt.expires_at) as remaining_seconds "
            q = q .. "FROM " .. db .. ".hunter_player_trials pt "
            q = q .. "JOIN " .. db .. ".hunter_rank_trials rt ON pt.trial_id = rt.trial_id "
            q = q .. "WHERE pt.player_id = " .. pid .. " AND pt.trial_id = " .. trial_id .. " AND pt.status = 'in_progress'"

            local c, d = mysql_direct_query(q)
            
            if c > 0 and d[1] then
                local t = d[1]
                return {
                    trial_id = trial_id,
                    trial_name = t.trial_name,
                    to_rank = t.to_rank,
                    color_code = t.color_code,
                    current = {
                        boss_kills = tonumber(t.boss_kills) or 0,
                        metin_kills = tonumber(t.metin_kills) or 0,
                        fracture_seals = tonumber(t.fracture_seals) or 0,
                        chest_opens = tonumber(t.chest_opens) or 0,
                        daily_missions = tonumber(t.daily_missions) or 0
                    },
                    required = {
                        boss_kills = tonumber(t.required_boss_kills) or 0,
                        metin_kills = tonumber(t.required_metin_kills) or 0,
                        fracture_seals = tonumber(t.required_fracture_seals) or 0,
                        chest_opens = tonumber(t.required_chest_opens) or 0,
                        daily_missions = tonumber(t.required_daily_missions) or 0
                    },
                    boss_vnum_list = t.boss_vnum_list,
                    metin_vnum_list = t.metin_vnum_list,
                    remaining_seconds = tonumber(t.remaining_seconds),
                    gloria_reward = tonumber(t.gloria_reward) or 0,
                    title_reward = t.title_reward
                }
            end
            
            pc.setqf("hgt_trial_active", 0)
            return nil
        end
        
        function update_trial_progress(progress_type, vnum, amount)
            local pid = pc.get_player_id()
            local db = hunter_gate_trial.get_config("db_name")
            local trial_active = pc.getqf("hgt_trial_active") or 0
            
            if trial_active ~= 1 then return end
            
            amount = amount or 1
            vnum = vnum or 0
            local vnum_str = tostring(vnum)
            
            local progress = hunter_gate_trial.get_trial_progress()
            if not progress then return end
            
            local should_update = false
            local field_name = ""
            local popup_type = ""
            
            if progress_type == "boss_kill" then
                field_name = "boss_kills"
                popup_type = "boss"
                if not progress.boss_vnum_list or progress.boss_vnum_list == "" then
                    should_update = true
                else
                    -- FIX: Usa string.gfind invece di string.gmatch (Lua 5.0/5.1 compatibility)
                    for v in string.gfind(progress.boss_vnum_list, "([^,]+)") do
                        if v == vnum_str then should_update = true break end
                    end
                end
            elseif progress_type == "metin_kill" then
                field_name = "metin_kills"
                popup_type = "metin"
                if not progress.metin_vnum_list or progress.metin_vnum_list == "" then
                    should_update = true
                else
                    -- FIX: Usa string.gfind invece of string.gmatch (Lua 5.0/5.1 compatibility)
                    for v in string.gfind(progress.metin_vnum_list, "([^,]+)") do
                        if v == vnum_str then should_update = true break end
                    end
                end
            elseif progress_type == "fracture_seal" then
                field_name = "fracture_seals"
                popup_type = "fracture"
                should_update = true
            elseif progress_type == "chest_open" then
                field_name = "chest_opens"
                popup_type = "chest"
                should_update = true
            elseif progress_type == "daily_mission" then
                field_name = "daily_missions"
                popup_type = "mission"
                should_update = true
            end
            
            if should_update and field_name ~= "" then
                local qupd = "UPDATE " .. db .. ".hunter_player_trials SET " .. field_name .. " = " .. field_name .. " + " .. amount .. " "
                qupd = qupd .. "WHERE player_id=" .. pid .. " AND trial_id=" .. progress.trial_id .. " AND status='in_progress'"
                mysql_direct_query(qupd)
                
                local new_progress = hunter_gate_trial.get_trial_progress()
                if new_progress then
                    local current_val = 0
                    local required_val = 0
                    
                    if field_name == "boss_kills" then
                        current_val = new_progress.current.boss_kills
                        required_val = new_progress.required.boss_kills
                    elseif field_name == "metin_kills" then
                        current_val = new_progress.current.metin_kills
                        required_val = new_progress.required.metin_kills
                    elseif field_name == "fracture_seals" then
                        current_val = new_progress.current.fracture_seals
                        required_val = new_progress.required.fracture_seals
                    elseif field_name == "chest_opens" then
                        current_val = new_progress.current.chest_opens
                        required_val = new_progress.required.chest_opens
                    elseif field_name == "daily_missions" then
                        current_val = new_progress.current.daily_missions
                        required_val = new_progress.required.daily_missions
                    end
                    
                    hunter_gate_trial.show_trial_progress(popup_type, current_val, required_val)
                    
                    local pkt = new_progress.trial_id .. "|" ..
                                new_progress.current.boss_kills .. "/" .. new_progress.required.boss_kills .. "|" ..
                                new_progress.current.metin_kills .. "/" .. new_progress.required.metin_kills .. "|" ..
                                new_progress.current.fracture_seals .. "/" .. new_progress.required.fracture_seals .. "|" ..
                                new_progress.current.chest_opens .. "/" .. new_progress.required.chest_opens .. "|" ..
                                new_progress.current.daily_missions .. "/" .. new_progress.required.daily_missions
                    cmdchat("HunterTrialProgress " .. pkt)
                    
                    hunter_gate_trial.check_trial_complete()
                end
            end
        end
        
        function check_trial_complete()
            local pid = pc.get_player_id()
            local pname = pc.get_name()
            local db = hunter_gate_trial.get_config("db_name")
            
            local progress = hunter_gate_trial.get_trial_progress()
            if not progress then return false end
            
            local c = progress.current
            local r = progress.required
            
            if c.boss_kills >= r.boss_kills and
               c.metin_kills >= r.metin_kills and
               c.fracture_seals >= r.fracture_seals and
               c.chest_opens >= r.chest_opens and
               c.daily_missions >= r.daily_missions then
                
                local trial_id = progress.trial_id
                local old_rank = pc.getqf("hgt_trial_old_rank") or hunter_gate_trial.get_player_rank()
                local new_rank = progress.to_rank
                local gloria = progress.gloria_reward
                local title = progress.title_reward
                local pcolor = progress.color_code
                
                mysql_direct_query("UPDATE " .. db .. ".hunter_player_trials SET status='completed', completed_at=NOW() WHERE player_id=" .. pid .. " AND trial_id=" .. trial_id)
                mysql_direct_query("UPDATE " .. db .. ".hunter_quest_ranking SET hunter_rank='" .. new_rank .. "', current_rank='" .. new_rank .. "', total_points = total_points + " .. gloria .. " WHERE player_id=" .. pid)
                
                pc.setqf("hgt_trial_id", 0)
                pc.setqf("hgt_trial_active", 0)
                
                hunter_gate_trial.show_rank_up_effect(old_rank, new_rank)
                
                cmdchat("HunterTrialComplete " .. new_rank .. "|" .. gloria .. "|" .. hunter_gate_trial.clean_str(progress.trial_name))
                
                notice_all("")
                notice_all("================================================================")
                notice_all("[HUNTER SYSTEM] PROVA SUPERATA!")
                notice_all(pname .. " ha completato: " .. progress.trial_name)
                notice_all("================================================================")
                notice_all("NUOVO RANK: " .. new_rank .. "-RANK HUNTER")
                notice_all("Gloria: +" .. gloria)
                if title and title ~= "" then
                    notice_all("Titolo: " .. title)
                end
                notice_all("================================================================")
                notice_all("")
                
                hunter_gate_trial.speak_color("PROVA COMPLETATA! SEI ORA UN " .. new_rank .. "-RANK HUNTER!", pcolor)
                
                return true
            end
            
            return false
        end
        
        function send_trial_status()
            local progress = hunter_gate_trial.get_trial_progress()

            if progress then
                local remaining = progress.remaining_seconds or -1
                local pkt = progress.trial_id .. "|" ..
                            hunter_gate_trial.clean_str(progress.trial_name) .. "|" ..
                            progress.to_rank .. "|" ..
                            progress.color_code .. "|" ..
                            remaining .. "|" ..
                            progress.current.boss_kills .. "|" .. progress.required.boss_kills .. "|" ..
                            progress.current.metin_kills .. "|" .. progress.required.metin_kills .. "|" ..
                            progress.current.fracture_seals .. "|" .. progress.required.fracture_seals .. "|" ..
                            progress.current.chest_opens .. "|" .. progress.required.chest_opens .. "|" ..
                            progress.current.daily_missions .. "|" .. progress.required.daily_missions
                cmdchat("HunterTrialStatus " .. pkt)
            else
                cmdchat("HunterTrialStatus 0|NONE|E|NONE|-1|0|0|0|0|0|0|0|0|0|0")
            end
        end

        function open_gate_trial_window()
            hunter_gate_trial.send_gate_status()
            hunter_gate_trial.send_trial_status()
            cmdchat("HunterGateTrialOpen")
        end

        function trial_master_interaction()
            if pc.is_gm() then
                say_title("GM MENU Maestro Prove")
                local gm_sel = select("Interazione Normale", "GM Resetta Prova", "GM +1 Boss", "GM +1 Metin", "GM +1 Frattura/Baule/Daily", "GM Reset Rank", "Chiudi")
                
                if gm_sel == 7 then return end
                
                if gm_sel == 2 then
                    local db = hunter_gate_trial.get_config("db_name")
                    mysql_direct_query("DELETE FROM " .. db .. ".hunter_player_trials WHERE player_id=" .. pc.get_player_id())
                    pc.setqf("hgt_trial_id", 0)
                    pc.setqf("hgt_trial_active", 0)
                    syschat("Prova resettata.")
                    return
                elseif gm_sel == 3 then
                    hunter_gate_trial.update_trial_progress("boss_kill", 4035, 1)
                    syschat("+1 Boss Kill")
                    return
                elseif gm_sel == 4 then
                    hunter_gate_trial.update_trial_progress("metin_kill", 4700, 1)
                    syschat("+1 Metin Kill")
                    return
                elseif gm_sel == 5 then
                    hunter_gate_trial.update_trial_progress("fracture_seal", 0, 1)
                    hunter_gate_trial.update_trial_progress("chest_open", 0, 1)
                    hunter_gate_trial.update_trial_progress("daily_mission", 0, 1)
                    syschat("+1 Frattura, Baule, Missione")
                    return
                elseif gm_sel == 6 then
                    local db = hunter_gate_trial.get_config("db_name")
                    mysql_direct_query("UPDATE " .. db .. ".hunter_quest_ranking SET hunter_rank='E', current_rank='E' WHERE player_id=" .. pc.get_player_id())
                    syschat("Rank resettato a E.")
                    return
                end
            end
            
            local check = hunter_gate_trial.check_trial_available()
            local current_rank = hunter_gate_trial.get_player_rank()
            
            say_title("MAESTRO DELLE PROVE")
            say("")
            say("Bentornato, " .. current_rank .. "-Rank Hunter.")
            say("")
            
            if check.at_max then
                say("Hai raggiunto il rank massimo!")
                say("Sei un vero Monarca Nazionale.")
                say("")
                say("Non ci sono piu prove per te.")
                return
            end
            
            if check.in_progress then
                say("Hai gia una prova in corso!")
                say("")
                local progress = hunter_gate_trial.get_trial_progress()
                if progress then
                    say("Prova: " .. progress.trial_name)
                    say("Obiettivo: " .. progress.to_rank .. "-RANK")
                    say("")
                    say("Progresso:")
                    say("  Boss: " .. progress.current.boss_kills .. "/" .. progress.required.boss_kills)
                    say("  Metin: " .. progress.current.metin_kills .. "/" .. progress.required.metin_kills)
                    say("  Fratture: " .. progress.current.fracture_seals .. "/" .. progress.required.fracture_seals)
                    say("  Bauli: " .. progress.current.chest_opens .. "/" .. progress.required.chest_opens)
                    say("  Missioni: " .. progress.current.daily_missions .. "/" .. progress.required.daily_missions)
                    if progress.remaining_seconds and progress.remaining_seconds > 0 then
                        say("")
                        say("Tempo rimasto: " .. hunter_gate_trial.format_time_days(progress.remaining_seconds))
                    end
                end
                local sel = select("Mostra Progresso UI", "Annulla Prova", "Apri Finestra Hunter", "Chiudi")
                if sel == 1 then
                    hunter_gate_trial.open_gate_trial_window()
                elseif sel == 2 then
                    say_title("ATTENZIONE")
                    say("")
                    say("Vuoi davvero annullare la prova?")
                    say("Perderai tutto il progresso!")
                    say("")
                    local confirm = select("Si, annulla", "No, continua")
                    if confirm == 1 then
                        local db = hunter_gate_trial.get_config("db_name")
                        mysql_direct_query("UPDATE " .. db .. ".hunter_player_trials SET status='failed' WHERE player_id=" .. pc.get_player_id() .. " AND trial_id=" .. progress.trial_id)
                        pc.setqf("hgt_trial_id", 0)
                        pc.setqf("hgt_trial_active", 0)
                        hunter_gate_trial.speak_color("Prova annullata.", "RED")
                        hunter_gate_trial.send_trial_status()
                    end
                elseif sel == 3 then
                    hunter_gate_trial.open_gate_trial_window()
                end
                return
            end
            
            if not check.available then
                say(check.message)
                say("")
                if check.missing_gloria then
                    say("Ti mancano " .. check.missing_gloria .. " Gloria" .. ".")
                end
                if check.missing_level then
                    say("Ti mancano " .. check.missing_level .. " livelli" .. ".")
                end
                return
            end
            
            say("Una nuova prova ti attende!")
            say("")
            say("Prova: " .. check.trial_name)
            say("Obiettivo: Diventare " .. check.to_rank .. "-RANK")
            say("")
            say("Requisiti:")
            if check.required.boss_kills > 0 then
                say("  - Uccidi " .. check.required.boss_kills .. " Boss")
            end
            if check.required.metin_kills > 0 then
                say("  - Distruggi " .. check.required.metin_kills .. " Metin")
            end
            if check.required.fracture_seals > 0 then
                say("  - Sigilla " .. check.required.fracture_seals .. " Fratture")
            end
            if check.required.chest_opens > 0 then
                say("  - Apri " .. check.required.chest_opens .. " Bauli")
            end
            if check.required.daily_missions > 0 then
                say("  - Completa " .. check.required.daily_missions .. " Missioni Giornaliere")
            end
            
            say("")
            if check.time_limit_hours then
                say("Tempo limite: " .. check.time_limit_hours .. " ore")
            else
                say("Nessun limite di tempo")
            end
            
            say("")
            say("Ricompensa: +" .. check.gloria_reward .. " Gloria")
            if check.title_reward and check.title_reward ~= "" then
                say("Titolo: " .. check.title_reward)
            end
            
            say("")
            local sel = select("Inizia la Prova!", "Non sono pronto", "Apri Finestra Hunter")

            if sel == 1 then
                hunter_gate_trial.start_trial()
            elseif sel == 3 then
                hunter_gate_trial.open_gate_trial_window()
            end
        end
        
        function check_and_send_letter()
            if pc.getqf("hgt_trial_active") == 1 then return end
            if get_time() < (pc.getqf("hgt_last_check") or 0) + 60 then return end
            pc.setqf("hgt_last_check", get_time())
            
            local check = hunter_gate_trial.check_trial_available()
            if check.available then
                send_letter("Promozione Hunter Disponibile")
            end
        end
        
        when 20019.click begin
            hunter_gate_trial.guardian_interaction()
        end
        
        when 20020.click begin
            hunter_gate_trial.trial_master_interaction()
        end
        
        when button or info begin
            hunter_gate_trial.trial_master_interaction()
        end
        
        when login with pc.get_level() >= 5 begin
            cleartimer("hgt_login_check") 
            timer("hgt_login_check", 3)
        end
        
        when levelup begin
            hunter_gate_trial.check_and_send_letter()
        end
        
        when hgt_login_check.timer begin
            hunter_gate_trial.send_gate_status()
            hunter_gate_trial.send_trial_status()
            hunter_gate_trial.check_and_send_letter()
        end
        
        when kill begin
            local vnum = npc.get_race()

            -- CHECK GATE BOSS KILL (AUTO-COMPLETE)
            local in_gate = pc.getqf("hgt_in_gate") or 0
            if in_gate == 1 then
                local gate_boss_vnum = pc.getqf("hgt_gate_boss_vnum") or 0
                if gate_boss_vnum > 0 and vnum == gate_boss_vnum then
                    local start_time = pc.getqf("hgt_gate_start") or 0
                    local duration = pc.getqf("hgt_gate_duration") or 1800
                    local elapsed = get_time() - start_time

                    if elapsed <= duration then
                        hunter_gate_trial.speak_color("BOSS DEL GATE UCCISO!", "GOLD")
                        hunter_gate_trial.complete_gate(true)
                        return
                    else
                        hunter_gate_trial.speak_color("TEMPO SCADUTO! Il gate era gia fallito.", "RED")
                        hunter_gate_trial.complete_gate(false)
                        return
                    end
                end
            end

            -- CHECK TRIAL PROGRESS
            if pc.getqf("hgt_trial_active") == 1 then
                local boss_list = {
                    [4035] = true, [719] = true, [2771] = true, [768] = true,
                    [6790] = true, [6831] = true, [986] = true, [989] = true,
                    [4011] = true, [6830] = true, [4385] = true,
                }
                local metin_list = {
                    [4700] = true, [4701] = true, [4702] = true, [4703] = true,
                    [4704] = true, [4705] = true, [4706] = true, [4707] = true, [4708] = true,
                }

                if boss_list[vnum] then
                    hunter_gate_trial.update_trial_progress("boss_kill", vnum, 1)
                end
                if metin_list[vnum] then
                    hunter_gate_trial.update_trial_progress("metin_kill", vnum, 1)
                end
            else
                if get_time() > (pc.getqf("hgt_last_kill_check") or 0) + 300 then
                    pc.setqf("hgt_last_kill_check", get_time())
                    hunter_gate_trial.check_and_send_letter()
                end
            end
        end
        
    end
end
