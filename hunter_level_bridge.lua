quest hunter_level_bridge begin
    state start begin
    
        -- ============================================================
        -- HUNTER LEVEL SYSTEM v36.0 (Updated + Gate Lock System)
        -- - 90% Chance What-If Hype Window
        -- - 10% Chance Classic Quest Window
        -- - Gate Locking & Claim System (Niente Ninja Looting)
        -- ============================================================
        
        -- ============================================================
        -- 1. UTILITY & CONFIG
        -- ============================================================
        
        function get_temp_gate_data(pid)
            if not _G.hunter_temp_gate_data then
                _G.hunter_temp_gate_data = {}
            end
            return _G.hunter_temp_gate_data[pid] or {}
        end
        
        function set_temp_gate_data(pid, data)
            if not _G.hunter_temp_gate_data then
                _G.hunter_temp_gate_data = {}
            end
            _G.hunter_temp_gate_data[pid] = data
        end
        
        function clean_str(str)
            if str == nil then return "" end
            local result = string.gsub(tostring(str), " ", "+")
            return result
        end

        -- SECURITY: SQL Escape (protezione SQL Injection)
        function sql_escape(str)
            if str == nil then return "" end
            -- Rimuove caratteri pericolosi: ', ", \, ;, --, #
            str = string.gsub(tostring(str), "'", "")
            str = string.gsub(str, '"', "")
            str = string.gsub(str, "\\", "")
            str = string.gsub(str, ";", "")
            str = string.gsub(str, "--", "")
            str = string.gsub(str, "#", "")
            return str
        end

        -- SECURITY: Valida rank per prevenire SQL injection
        function validate_rank(rank)
            local valid_ranks = {E=true, D=true, C=true, B=true, A=true, S=true, N=true}
            if rank and valid_ranks[rank] then
                return rank
            end
            return "E"
        end

        -- ============================================================
        -- PERFORMANCE: CACHE MOB ELITE (NO QUERY SU OGNI KILL!)
        -- ============================================================

        -- Cache globale dei mob elite (caricata una volta all'avvio)
        function load_elite_cache()
            if not _G.hunter_elite_cache then
                _G.hunter_elite_cache = {}
                _G.hunter_elite_data = {}  -- Dati completi mob
                _G.hunter_cache_loaded = get_time()
            end

            -- Ricarica solo se passati più di 3600 secondi (1 ora) o se vuota
            local now = get_time()
            if _G.hunter_cache_loaded and (now - _G.hunter_cache_loaded < 3600) and next(_G.hunter_elite_cache) then
                return  -- Cache ancora valida
            end

            -- Carica tutti i mob elite enabled dal DB
            local c, d = mysql_direct_query("SELECT vnum, name, type_name, base_points, rank_color FROM srv1_hunabku.hunter_quest_spawns WHERE enabled=1")

            if c > 0 then
                _G.hunter_elite_cache = {}
                _G.hunter_elite_data = {}

                for i = 1, c do
                    local vnum = tonumber(d[i].vnum)
                    _G.hunter_elite_cache[vnum] = true  -- Per check veloce is_elite
                    _G.hunter_elite_data[vnum] = {
                        name = d[i].name,
                        type_name = d[i].type_name,
                        base_points = tonumber(d[i].base_points) or 100,
                        rank_color = d[i].rank_color or "BLUE"
                    }
                end

                _G.hunter_cache_loaded = now
            end
        end

        -- PERFORMANCE: CACHE DEFENSE WAVES (NO QUERY OGNI SECONDO!)
        function load_defense_waves_cache(rank_grade)
            -- SECURITY: Valida rank
            rank_grade = hunter_level_bridge.validate_rank(rank_grade)

            -- Inizializza cache se non esiste
            if not _G.hunter_defense_waves_cache then
                _G.hunter_defense_waves_cache = {}
            end

            -- Se cache per questo rank già caricata, ritorna
            if _G.hunter_defense_waves_cache[rank_grade] then
                return  -- Cache già presente
            end

            -- Carica TUTTE le wave per questo rank in UNA query
            local q = "SELECT wave_number, spawn_time, mob_vnum, mob_count, spawn_radius FROM srv1_hunabku.hunter_fracture_defense_waves "
            q = q .. "WHERE rank_grade='" .. rank_grade .. "' AND enabled=1 ORDER BY wave_number"
            local c, d = mysql_direct_query(q)

            if c > 0 then
                _G.hunter_defense_waves_cache[rank_grade] = {}

                for i = 1, c do
                    local wave_num = tonumber(d[i].wave_number)
                    local spawn_time = tonumber(d[i].spawn_time)
                    local mob_vnum = tonumber(d[i].mob_vnum)
                    local mob_count = tonumber(d[i].mob_count)
                    local spawn_radius = tonumber(d[i].spawn_radius) or 7

                    -- Crea entry per wave
                    if not _G.hunter_defense_waves_cache[rank_grade][wave_num] then
                        _G.hunter_defense_waves_cache[rank_grade][wave_num] = {
                            spawn_time = spawn_time,
                            mobs = {}
                        }
                    end

                    -- Aggiungi mob a questa wave (può avere più tipi di mob)
                    table.insert(_G.hunter_defense_waves_cache[rank_grade][wave_num].mobs, {
                        vnum = mob_vnum,
                        count = mob_count,
                        radius = spawn_radius
                    })
                end
            end
        end

        -- PERFORMANCE: BATCH RANKING UPDATES (NO UPDATE SU OGNI KILL!)
        -- Accumula i punti in quest flags, poi salva tutto insieme su logout/timer
        function flush_ranking_updates()
            local pid = pc.get_player_id()

            -- Leggi accumulatori dalle quest flags
            local pending_total_pts = pc.getqf("hq_pending_total_pts") or 0
            local pending_spendable_pts = pc.getqf("hq_pending_spendable_pts") or 0
            local pending_daily_pts = pc.getqf("hq_pending_daily_pts") or 0
            local pending_weekly_pts = pc.getqf("hq_pending_weekly_pts") or 0
            local pending_total_kills = pc.getqf("hq_pending_total_kills") or 0
            local pending_daily_kills = pc.getqf("hq_pending_daily_kills") or 0
            local pending_weekly_kills = pc.getqf("hq_pending_weekly_kills") or 0
            local pending_metins = pc.getqf("hq_pending_metins") or 0
            local pending_chests = pc.getqf("hq_pending_chests") or 0
            local pending_fractures = pc.getqf("hq_pending_fractures") or 0

            -- Se non c'è nulla da salvare, esci
            if pending_total_pts == 0 and pending_total_kills == 0 and pending_metins == 0 and pending_chests == 0 and pending_fractures == 0 then
                return
            end

            -- SALVA TUTTO IN UNA QUERY (invece di 100+ query separate!)
            local q = "UPDATE srv1_hunabku.hunter_quest_ranking SET "
            q = q .. "total_points = total_points + " .. pending_total_pts .. ", "
            q = q .. "spendable_points = spendable_points + " .. pending_spendable_pts .. ", "
            q = q .. "daily_points = daily_points + " .. pending_daily_pts .. ", "
            q = q .. "weekly_points = weekly_points + " .. pending_weekly_pts .. ", "
            q = q .. "total_kills = total_kills + " .. pending_total_kills .. ", "
            q = q .. "daily_kills = daily_kills + " .. pending_daily_kills .. ", "
            q = q .. "weekly_kills = weekly_kills + " .. pending_weekly_kills .. ", "
            q = q .. "total_metins = total_metins + " .. pending_metins .. ", "
            q = q .. "total_chests = total_chests + " .. pending_chests .. ", "
            q = q .. "total_fractures = total_fractures + " .. pending_fractures .. " "
            q = q .. "WHERE player_id = " .. pid

            mysql_direct_query(q)

            -- Reset accumulatori dopo il salvataggio
            pc.setqf("hq_pending_total_pts", 0)
            pc.setqf("hq_pending_spendable_pts", 0)
            pc.setqf("hq_pending_daily_pts", 0)
            pc.setqf("hq_pending_weekly_pts", 0)
            pc.setqf("hq_pending_total_kills", 0)
            pc.setqf("hq_pending_daily_kills", 0)
            pc.setqf("hq_pending_weekly_kills", 0)
            pc.setqf("hq_pending_metins", 0)
            pc.setqf("hq_pending_chests", 0)
            pc.setqf("hq_pending_fractures", 0)
        end

        -- PERFORMANCE: Aggiungi punti agli accumulatori (NO DB UPDATE immediato!)
        function add_pending_points(total_pts, daily_pts, weekly_pts)
            total_pts = tonumber(total_pts) or 0
            daily_pts = tonumber(daily_pts) or total_pts
            weekly_pts = tonumber(weekly_pts) or total_pts

            pc.setqf("hq_pending_total_pts", (pc.getqf("hq_pending_total_pts") or 0) + total_pts)
            pc.setqf("hq_pending_spendable_pts", (pc.getqf("hq_pending_spendable_pts") or 0) + total_pts)
            pc.setqf("hq_pending_daily_pts", (pc.getqf("hq_pending_daily_pts") or 0) + daily_pts)
            pc.setqf("hq_pending_weekly_pts", (pc.getqf("hq_pending_weekly_pts") or 0) + weekly_pts)
        end

        -- PERFORMANCE: Aggiungi kill agli accumulatori
        function add_pending_kill()
            pc.setqf("hq_pending_total_kills", (pc.getqf("hq_pending_total_kills") or 0) + 1)
            pc.setqf("hq_pending_daily_kills", (pc.getqf("hq_pending_daily_kills") or 0) + 1)
            pc.setqf("hq_pending_weekly_kills", (pc.getqf("hq_pending_weekly_kills") or 0) + 1)
        end

        -- Helper function per formattare l'ora
        function format_time(h, m)
            local hh = tostring(h)
            local mm = tostring(m)
            if tonumber(h) < 10 then hh = "0" .. h end
            if tonumber(m) < 10 then mm = "0" .. m end
            return hh .. ":" .. mm
        end
        
        function modulo(a, b)
            return a - math.floor(a / b) * b
        end
        
        function get_hour_from_ts(ts)
            local t = os.date("*t", ts)
            return t.hour
        end
        
        function get_min_from_ts(ts)
            local t = os.date("*t", ts)
            return t.min
        end
        
        function get_sec_from_ts(ts)
            local t = os.date("*t", ts)
            return t.sec
        end
        
        function get_dow_from_ts(ts)
            local t = os.date("*t", ts)
            local wday = t.wday - 1
            return wday
        end
        
        function get_day_db_from_ts(ts)
            local t = os.date("*t", ts)
            local wday = t.wday - 1
            if wday == 0 then return 7 end
            return wday
        end
        
        function is_leap_year(y)
            local mod400 = y - math.floor(y / 400) * 400
            local mod100 = y - math.floor(y / 100) * 100
            local mod4 = y - math.floor(y / 4) * 4
            if mod400 == 0 then return true end
            if mod100 == 0 then return false end
            if mod4 == 0 then return true end
            return false
        end
        
        function get_today_date()
            local ts = get_time()
            local days = math.floor(ts / 86400)
            local year = 1970
            local remaining_days = days
            while remaining_days >= 365 do
                local leap = 0
                if hunter_level_bridge.is_leap_year(year) then leap = 1 end
                local days_in_year = 365 + leap
                if remaining_days >= days_in_year then
                    remaining_days = remaining_days - days_in_year
                    year = year + 1
                else
                    break
                end
            end
            local month_days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
            if hunter_level_bridge.is_leap_year(year) then
                month_days[2] = 29
            end
            local month = 1
            for m = 1, 12 do
                if remaining_days < month_days[m] then
                    month = m
                    break
                end
                remaining_days = remaining_days - month_days[m]
            end
            local day = remaining_days + 1
            local y = tostring(year)
            local mo = ""
            if month < 10 then mo = "0" .. month else mo = tostring(month) end
            local d = ""
            if day < 10 then d = "0" .. day else d = tostring(day) end
            return y .. "-" .. mo .. "-" .. d
        end

        function get_rank_letter(rank_num)
            local letters = {"E", "D", "C", "B", "A", "S", "N"}
            return letters[rank_num + 1] or "E"
        end
        
        function get_rank_index(points)
            local N = tonumber(hunter_level_bridge.get_config("rank_threshold_N")) or 1500000
            local S = tonumber(hunter_level_bridge.get_config("rank_threshold_S")) or 500000
            local A = tonumber(hunter_level_bridge.get_config("rank_threshold_A")) or 150000
            local B = tonumber(hunter_level_bridge.get_config("rank_threshold_B")) or 50000
            local C = tonumber(hunter_level_bridge.get_config("rank_threshold_C")) or 10000
            local D = tonumber(hunter_level_bridge.get_config("rank_threshold_D")) or 2000

            if points >= N then return 6
            elseif points >= S then return 5
            elseif points >= A then return 4
            elseif points >= B then return 3
            elseif points >= C then return 2
            elseif points >= D then return 1
            else return 0 end
        end
        
        function hunter_speak(msg)
            if msg == nil then return end
            local rank_num = pc.getqf("hq_rank_num")
            if not rank_num or rank_num == 0 then
                local pid = pc.get_player_id()
                local c, d = mysql_direct_query("SELECT total_points FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
                if c > 0 and d[1] then
                    local pts = tonumber(d[1].total_points) or 0
                    rank_num = hunter_level_bridge.get_rank_index(pts)
                    pc.setqf("hq_rank_num", rank_num)
                else
                    rank_num = 0
                end
            end
            local rank_key = hunter_level_bridge.get_rank_letter(rank_num)
            cmdchat("HunterSystemSpeak " .. rank_key .. "|" .. hunter_level_bridge.clean_str(msg))
        end
        
        function hunter_speak_color(msg, color_code)
            if msg == nil then return end
            cmdchat("HunterSystemSpeak " .. (color_code or "BLUE") .. "|" .. hunter_level_bridge.clean_str(msg))
        end
        
        function start_emergency(title, seconds, mob_vnum, count)
            pc.setqf("hq_emerg_active", 1)
            pc.setqf("hq_emerg_vnum", mob_vnum)
            pc.setqf("hq_emerg_req", count)
            pc.setqf("hq_emerg_cur", 0)
            pc.setqf("hq_emerg_expire", get_time() + seconds)
            
            cmdchat("HunterEmergency " .. hunter_level_bridge.clean_str(title) .. "|" .. seconds .. "|" .. mob_vnum .. "|" .. count)
            
            cleartimer("hunter_emerg_tmr")
            loop_timer("hunter_emerg_tmr", 1)
        end

        function update_emergency(current_count)
            cmdchat("HunterEmergencyUpdate " .. current_count)
        end

        function end_emergency(status)
            pc.setqf("hq_emerg_active", 0)
            cleartimer("hunter_emerg_tmr")
            
            local s_str = "FAIL"
            if status == "SUCCESS" then s_str = "SUCCESS" end
            cmdchat("HunterEmergencyClose " .. s_str)
            
            if status == "SUCCESS" then
                local bonus_pts = pc.getqf("hq_emerg_reward_pts") or 50
                local reward_vnum = pc.getqf("hq_emerg_reward_vnum") or 0
                local reward_count = pc.getqf("hq_emerg_reward_count") or 0
                
                if bonus_pts > 0 then
                    mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET total_points=total_points+"..bonus_pts..", spendable_points=spendable_points+"..bonus_pts.." WHERE player_id="..pc.get_player_id())
                end
                
                if reward_vnum > 0 and reward_count > 0 then
                    pc.give_item2(reward_vnum, reward_count)
                    local msg = hunter_level_bridge.get_text("emergency_bonus_item", {ITEM = hunter_level_bridge.item_name(reward_vnum), COUNT = reward_count}) or ("BONUS: " .. hunter_level_bridge.item_name(reward_vnum) .. " x" .. reward_count)
                    hunter_level_bridge.hunter_speak(msg)
                end
                
                local msg = hunter_level_bridge.get_text("emergency_complete", {POINTS = bonus_pts}) or ("MISSIONE COMPLETATA! +" .. bonus_pts .. " GLORIA")
                hunter_level_bridge.hunter_speak(msg)
                hunter_level_bridge.send_player_data()
            else
                local msg = hunter_level_bridge.get_text("emergency_failed") or "MISSIONE FALLITA."
                hunter_level_bridge.hunter_speak(msg)
            end
            
            pc.setqf("hq_emerg_reward_pts", 0)
            pc.setqf("hq_emerg_reward_vnum", 0)
            pc.setqf("hq_emerg_reward_count", 0)
        end

        function notify_rival(name, points, label)
            cmdchat("HunterRivalAlert " .. hunter_level_bridge.clean_str(name) .. "|" .. points .. "|" .. hunter_level_bridge.clean_str(label))
        end

        function ask_choice_color(qid, text, opt1, opt2, opt3, color_code)
            local cmd = "HunterWhatIf " .. qid .. "|" .. hunter_level_bridge.clean_str(text) .. "|" .. hunter_level_bridge.clean_str(opt1) .. "|" .. hunter_level_bridge.clean_str(opt2)
            local o3_str = ""
            if opt3 and opt3 ~= "" then
                o3_str = hunter_level_bridge.clean_str(opt3)
            end
            cmd = cmd .. "|" .. o3_str
            cmd = cmd .. "|" .. color_code
            cmdchat(cmd)
        end
        
        function get_config(key)
            local q = "SELECT config_value FROM srv1_hunabku.hunter_quest_config WHERE config_key='" .. key .. "' LIMIT 1"
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] then return tonumber(d[1].config_value) or 0 end
            return 0
        end
        
        function get_rank_bonus(points)
            local q = "SELECT bonus_gloria FROM srv1_hunabku.hunter_ranks WHERE min_points <= " .. points .. " ORDER BY min_points DESC LIMIT 1"
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] then
                return tonumber(d[1].bonus_gloria) or 0
            end
            return 0
        end

        function get_trial_gloria_multiplier()
            local pid = pc.get_player_id()
            local q = "SELECT COUNT(*) as cnt FROM srv1_hunabku.hunter_player_trials WHERE player_id=" .. pid .. " AND status='in_progress' LIMIT 1"
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] and tonumber(d[1].cnt) > 0 then
                return 0.5
            end
            return 1.0
        end

        function get_streak_message(day_number)
            local q = "SELECT message_text FROM srv1_hunabku.hunter_login_messages WHERE day_number = " .. day_number .. " LIMIT 1"
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] then
                local msg = d[1].message_text
                if msg then return string.gsub(msg, "_", " ") end
            end
            q = "SELECT message_text FROM srv1_hunabku.hunter_login_messages WHERE day_number <= " .. day_number .. " ORDER BY day_number DESC LIMIT 1"
            c, d = mysql_direct_query(q)
            if c > 0 and d[1] then
                local msg = d[1].message_text
                if msg then return string.gsub(msg, "_", " ") end
            end
            return nil
        end
        
        function get_text(key, replacements)
            local q = "SELECT text_value FROM srv1_hunabku.hunter_texts WHERE text_key='" .. key .. "' AND enabled=1 LIMIT 1"
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] then
                local txt = d[1].text_value
                if replacements then
                    for k, v in pairs(replacements) do
                        txt = string.gsub(txt, "{" .. k .. "}", tostring(v))
                    end
                end
                return txt
            end
            return nil
        end
        
        function get_text_colored(key, replacements)
            local q = "SELECT text_value, color_code FROM srv1_hunabku.hunter_texts WHERE text_key='" .. key .. "' AND enabled=1 LIMIT 1"
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] then
                local txt = d[1].text_value
                local color = d[1].color_code
                if replacements then
                    for k, v in pairs(replacements) do
                        txt = string.gsub(txt, "{" .. k .. "}", tostring(v))
                    end
                end
                if color and color ~= "" then
                    return "|cff" .. color .. txt .. "|r"
                end
                return txt
            end
            return nil
        end
        
        function get_fracture_voice(color_code, has_points)
            local key = "fracture_voice_" .. (has_points and "ok_" or "no_") .. color_code
            local txt = hunter_level_bridge.get_text(key)
            if txt then return txt end
            if has_points then
                return "Il portale si apre davanti a te..."
            else
                return "Non sei ancora degno."
            end
        end
        
        function item_name(vnum)
            return "Item"
        end
        
        function get_active_event()
            local event = hunter_level_bridge.get_current_scheduled_event()
            
            if event then
                local name = event.event_name or "Evento"
                local etype = event.event_type or "glory_rush"
                local glory = tonumber(event.reward_glory_base) or 50
                local desc = event.event_desc or ""
                
                local mult = 1.0
                local apply_to = "points"
                
                if etype == "glory_rush" then
                    mult = 2.0
                    apply_to = "points"
                    desc = "Gloria x2"
                elseif etype == "first_rift" or etype == "rift_hunt" then
                    mult = 1.5
                    apply_to = "chance"
                    desc = "Fratture +50"
                elseif etype == "double_spawn" then
                    mult = 2.0
                    apply_to = "chance"
                    desc = "Spawn x2"
                elseif etype == "super_metin" or etype == "metin_frenzy" then
                    mult = 1.5
                    apply_to = "chance"
                    desc = "Metin +50"
                elseif etype == "first_boss" or etype == "boss_massacre" then
                    mult = 1.5
                    apply_to = "points"
                    desc = "Boss Glory +50"
                end
                
                return name, mult, apply_to, desc
            end
            
            return nil, 1.0, nil, nil
        end
        
        function get_current_scheduled_event()
            local t = os.date("*t")
            local wday = t.wday - 1
            local day_db = wday
            if wday == 0 then day_db = 7 end
            
            local current_hour = t.hour
            local current_minute = t.min
            local current_total = current_hour * 60 + current_minute
            
            local q = "SELECT id, event_name, event_type, event_desc, start_hour, start_minute, duration_minutes, min_rank, reward_glory_base, reward_glory_winner, color_scheme FROM srv1_hunabku.hunter_scheduled_events WHERE enabled=1 AND FIND_IN_SET(" .. day_db .. ", days_active) > 0 ORDER BY start_hour, start_minute"
            
            local c, d = mysql_direct_query(q)
            
            if c > 0 then
                for i = 1, c do
                    local e = d[i]
                    local start_hour = tonumber(e.start_hour) or 0
                    local start_minute = tonumber(e.start_minute) or 0
                    local duration = tonumber(e.duration_minutes) or 30
                    
                    local start_total = start_hour * 60 + start_minute
                    local end_total = start_total + duration
                    
                    if current_total >= start_total and current_total < end_total then
                        return e
                    end
                end
            end
            
            return nil
        end
        
        -- PERFORMANCE OPTIMIZED: Usa cache invece di query SQL!
        function is_elite_mob(vnum)
            -- Assicura che la cache sia caricata
            if not _G.hunter_elite_cache or not next(_G.hunter_elite_cache) then
                hunter_level_bridge.load_elite_cache()
            end

            -- Check in RAM (VELOCE!)
            return _G.hunter_elite_cache[vnum] == true
        end

        -- PERFORMANCE OPTIMIZED: Usa cache invece di query SQL!
        function get_mob_info(vnum)
            -- Assicura che la cache sia caricata
            if not _G.hunter_elite_data or not next(_G.hunter_elite_data) then
                hunter_level_bridge.load_elite_cache()
            end

            -- Ritorna dati dalla cache
            return _G.hunter_elite_data[vnum]
        end

        -- ============================================================
        -- 2. LOGIN & INITIALIZATION
        -- ============================================================
        
        when levelup with pc.get_level() == 5 begin
            cmdchat("HunterAwakening " .. hunter_level_bridge.clean_str(pc.get_name()))
            timer("hq_lv5_msg1", 2)
            timer("hq_lv5_msg2", 5)
            timer("hq_lv5_msg3", 8)
        end
        
        when hq_lv5_msg1.timer begin
            local t1 = hunter_level_bridge.get_text_colored("lv5_line1a") or "|cffFF0000========================================|r"
            local t2 = hunter_level_bridge.get_text_colored("lv5_line1b") or "|cffFF0000   ! ! ! ANOMALIA RILEVATA ! ! !|r"
            local t3 = hunter_level_bridge.get_text_colored("lv5_line1c") or "|cffFF0000========================================|r"
            syschat(t1)
            syschat(t2)
            syschat(t3)
        end
        
        when hq_lv5_msg2.timer begin
            syschat("")
            local t1 = hunter_level_bridge.get_text_colored("lv5_line2a") or "|cff888888   Il Sistema ti ha notato...|r"
            local t2 = hunter_level_bridge.get_text_colored("lv5_line2b") or "|cff888888   Qualcosa si sta risvegliando.|r"
            syschat(t1)
            syschat(t2)
        end
        
        when hq_lv5_msg3.timer begin
            syschat("")
            local t1 = hunter_level_bridge.get_text_colored("lv5_line3a") or "|cffFFD700   Raggiungi il livello 30...|r"
            local t2 = hunter_level_bridge.get_text_colored("lv5_line3b") or "|cffFFD700   ...e scoprirai la verita.|r"
            syschat(t1)
            syschat(t2)
            syschat("")
        end
        
        when levelup with pc.get_level() == 30 begin
            local pid = pc.get_player_id()
            local pname = mysql_escape_string(pc.get_name())
            local chk, _ = mysql_direct_query("SELECT player_id FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            if chk == 0 then 
                mysql_direct_query("INSERT INTO srv1_hunabku.hunter_quest_ranking (player_id, player_name, total_points, spendable_points) VALUES (" .. pid .. ", '" .. pname .. "', 0, 0)")
            end
            
            cmdchat("HunterActivation " .. hunter_level_bridge.clean_str(pc.get_name()))
            timer("hq_lv30_msg1", 2)
            timer("hq_lv30_msg2", 5)
            timer("hq_lv30_msg3", 8)
            timer("hq_lv30_msg4", 11)
        end
        
        when hq_lv30_msg1.timer begin
            local t1 = hunter_level_bridge.get_text_colored("lv30_line1a") or "|cff0099FF========================================|r"
            local t2 = hunter_level_bridge.get_text_colored("lv30_line1b") or "|cff0099FF       [ S Y S T E M ]|r"
            local t3 = hunter_level_bridge.get_text_colored("lv30_line1c") or "|cff0099FF========================================|r"
            syschat(t1)
            syschat(t2)
            syschat(t3)
        end
        
        when hq_lv30_msg2.timer begin
            syschat("")
            local t1 = hunter_level_bridge.get_text_colored("lv30_line2a") or "|cffFFD700   HUNTER SYSTEM ATTIVATO|r"
            local t2 = hunter_level_bridge.get_text("lv30_line2b", {NAME = pc.get_name()}) or ("   Benvenuto, " .. pc.get_name())
            syschat(t1)
            syschat("|cffFFFFFF" .. t2 .. "|r")
        end
        
        when hq_lv30_msg3.timer begin
            syschat("")
            local t1 = hunter_level_bridge.get_text_colored("lv30_line3a") or "|cff00FF00   >> Da oggi lotterai per la Gloria!|r"
            local t2 = hunter_level_bridge.get_text_colored("lv30_line3b") or "|cff00FF00   >> Fratture, Classifiche, Tesori...|r"
            local t3 = hunter_level_bridge.get_text_colored("lv30_line3c") or "|cff00FF00   >> Ti attendono.|r"
            syschat(t1)
            syschat(t2)
            syschat(t3)
        end
        
        when hq_lv30_msg4.timer begin
            syschat("")
            local t1 = hunter_level_bridge.get_text_colored("lv30_line4a") or "|cffFF6600   A R I S E|r"
            local t2 = hunter_level_bridge.get_text_colored("lv30_line4b") or "|cffFFFFFF   Il tuo viaggio come Hunter inizia ORA.|r"
            local t3 = hunter_level_bridge.get_text_colored("lv30_line4c") or "|cff00FFFF   [Y] - Apri Hunter Terminal|r"
            local t4 = hunter_level_bridge.get_text_colored("lv30_line1c") or "|cff0099FF========================================|r"
            syschat(t1)
            syschat(t2)
            syschat("")
            syschat(t3)
            syschat(t4)
        end
        
        when login with pc.get_level() >= 5 begin
            local pid = pc.get_player_id()
            local pname = mysql_escape_string(pc.get_name())
            local chk, res = mysql_direct_query("SELECT player_id, total_points FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            if chk == 0 then 
                mysql_direct_query("INSERT INTO srv1_hunabku.hunter_quest_ranking (player_id, player_name, total_points, spendable_points) VALUES (" .. pid .. ", '" .. pname .. "', 0, 0)")
            else 
                mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET player_name='" .. pname .. "' WHERE player_id=" .. pid) 
            end
            
            local total_pts = 0
            if chk > 0 and res[1] then
                total_pts = tonumber(res[1].total_points) or 0
            end
            
            local rank_num = hunter_level_bridge.get_rank_index(total_pts)
            pc.setqf("hq_rank_num", rank_num)
            pc.setqf("hq_welcome_pts", total_pts)
            
            local last_logout = pc.getqf("hq_last_logout") or 0
            local current_time = get_time()
            local offline_seconds = current_time - last_logout
            local welcome_threshold = hunter_level_bridge.get_config("welcome_offline_seconds") or 120
            local show_welcome = (offline_seconds >= welcome_threshold)
            
            hunter_level_bridge.check_login_streak()
            hunter_level_bridge.check_pending_rewards()
            hunter_level_bridge.assign_daily_missions()
            hunter_level_bridge.send_today_events(false)
            hunter_level_bridge.check_active_event_notify()
            
            if pc.getqf("hq_intro") == 0 then 
                pc.setqf("hq_intro", 1)
                hunter_level_bridge.show_awakening_sequence(pname)
            elseif show_welcome then
                cmdchat("HunterSystemInit")
                timer("hq_welcome_msg", 4)
            end
            
            cleartimer("hunter_update_timer")
            local timer_update = hunter_level_bridge.get_config("timer_update_stats") or 60
            loop_timer("hunter_update_timer", timer_update)
            cleartimer("hunter_tips_timer")
            local timer_tips = hunter_level_bridge.get_config("timer_tips_random") or 90
            loop_timer("hunter_tips_timer", timer_tips)
            cleartimer("hunter_reset_check")
            local timer_reset = hunter_level_bridge.get_config("timer_reset_check") or 60
            loop_timer("hunter_reset_check", timer_reset)
            
            pc.setqf("hq_emerg_active", 0)
        end
        
        when logout begin
            local pid = pc.get_player_id()

            -- PERFORMANCE: Salva accumulatori ranking PRIMA del logout (CRITICO!)
            hunter_level_bridge.flush_ranking_updates()

            -- Salva tempo logout
            pc.setqf("hq_last_logout", get_time())

            -- MEMORY LEAK FIX: Pulisci tabelle globali per questo player
            if _G.hunter_temp_gate_data then
                _G.hunter_temp_gate_data[pid] = nil
            end
            if hunter_defense_data then
                hunter_defense_data[pid] = nil
            end

            -- NOTA: La cache waves (_G.hunter_defense_waves_cache) è condivisa tra tutti i player
            -- Non va pulita al logout, viene riutilizzata da tutti
        end
        
        when hq_welcome_msg.timer begin
            local pts = pc.getqf("hq_welcome_pts") or 0
            hunter_level_bridge.show_rank_welcome(pc.get_name(), pts)
        end
        
        function show_awakening_sequence(name)
            cmdchat("HunterAwakening " .. hunter_level_bridge.clean_str(name))
            timer("hq_awaken_1", 1)
            timer("hq_awaken_2", 3)
            timer("hq_awaken_3", 5)
            timer("hq_awaken_4", 7)
            timer("hq_awaken_5", 9)
        end
        
        when hq_awaken_1.timer begin
            local speak = hunter_level_bridge.get_text("awaken1_speak") or "[SYSTEM] SCANSIONE BIOLOGICA IN CORSO..."
            cmdchat("HunterSystemSpeak E|" .. hunter_level_bridge.clean_str(speak))
            local t1 = hunter_level_bridge.get_text_colored("awaken1_line1") or "|cff00FFFF========================================|r"
            local t2 = hunter_level_bridge.get_text_colored("awaken1_line2") or "|cffFFFFFF        ...ANALISI IN CORSO...|r"
            local t3 = hunter_level_bridge.get_text_colored("awaken1_line3") or "|cff00FFFF========================================|r"
            syschat(t1)
            syschat(t2)
            syschat(t3)
        end
        
        when hq_awaken_2.timer begin
            local speak = hunter_level_bridge.get_text("awaken2_speak") or "[SYSTEM] COMPATIBILITA CONFERMATA."
            cmdchat("HunterSystemSpeak E|" .. hunter_level_bridge.clean_str(speak))
            syschat("")
            local t1 = hunter_level_bridge.get_text_colored("awaken2_line1") or "|cff00FF00   >> COMPATIBILITA: 100 pct <<|r"
            local t2 = hunter_level_bridge.get_text_colored("awaken2_line2") or "|cff00FF00   >> REQUISITI: SODDISFATTI <<|r"
            syschat(t1)
            syschat(t2)
        end
        
        when hq_awaken_3.timer begin
            local speak = hunter_level_bridge.get_text("awaken3_speak") or "[SYSTEM] NUOVO CACCIATORE REGISTRATO."
            cmdchat("HunterSystemSpeak E|" .. hunter_level_bridge.clean_str(speak))
            syschat("")
            local t1 = hunter_level_bridge.get_text("awaken3_line1", {NAME = pc.get_name()}) or ("   NOME: " .. pc.get_name())
            local t2 = hunter_level_bridge.get_text_colored("awaken3_line2") or "|cff808080   RANGO INIZIALE: [E-RANK]|r"
            syschat("|cffFFD700" .. t1 .. "|r")
            syschat(t2)
        end
        
        when hq_awaken_4.timer begin
            syschat("")
            local t1 = hunter_level_bridge.get_text_colored("awaken4_line1") or "|cffFF0000========================================|r"
            local t2 = hunter_level_bridge.get_text_colored("awaken4_line2") or "|cffFF6600   !! RISVEGLIO COMPLETATO !!|r"
            local t3 = hunter_level_bridge.get_text_colored("awaken4_line3") or "|cffFF0000========================================|r"
            syschat(t1)
            syschat(t2)
            syschat(t3)
            local speak = hunter_level_bridge.get_text("awaken4_speak", {NAME = pc.get_name()}) or ("RISVEGLIO COMPLETATO. BENVENUTO, " .. pc.get_name() .. ".")
            cmdchat("HunterSystemSpeak E|" .. hunter_level_bridge.clean_str(speak))
        end
        
        when hq_awaken_5.timer begin
            syschat("")
            local t1 = hunter_level_bridge.get_text_colored("awaken5_line1") or "|cffFFD700====================================================|r"
            local t2 = hunter_level_bridge.get_text_colored("awaken5_line2") or "|cff00FFFF        *** HUNTER SYSTEM v36.0 ATTIVATO ***|r"
            local t3 = hunter_level_bridge.get_text_colored("awaken5_line3") or "|cffFFD700====================================================|r"
            local t4 = hunter_level_bridge.get_text_colored("awaken5_line4") or "|cffFFFFFF   Il Sistema ti ha scelto. Da questo momento:|r"
            local t5 = hunter_level_bridge.get_text_colored("awaken5_line5") or "|cff00FF00   >> Ogni nemico cadra sotto la tua lama|r"
            local t6 = hunter_level_bridge.get_text_colored("awaken5_line6") or "|cff00FF00   >> Ogni vittoria sara registrata|r"
            local t7 = hunter_level_bridge.get_text_colored("awaken5_line7") or "|cff00FF00   >> Ogni rank sara conquistato|r"
            local t8 = hunter_level_bridge.get_text_colored("awaken5_line8") or "|cffFFAA00   'Inizia con un solo passo...'|r"
            local t9 = hunter_level_bridge.get_text_colored("awaken5_line9") or "|cffFFAA00   'Finisci come una Leggenda.'|r"
            local t10 = hunter_level_bridge.get_text_colored("awaken5_line10") or "|cff00FF00   [Y] - Apri Hunter Terminal|r"
            syschat(t1)
            syschat(t2)
            syschat(t3)
            syschat("")
            syschat(t4)
            syschat(t5)
            syschat(t6)
            syschat(t7)
            syschat("")
            syschat(t8)
            syschat(t9)
            syschat("")
            syschat(t10)
            syschat(t1)
        end
        
        function show_rank_welcome(name, points)
            local rank_key = hunter_level_bridge.get_rank_key(points)
            local rank_data = hunter_level_bridge.get_rank_data(rank_key)
            cmdchat("HunterWelcome " .. rank_key .. "|" .. hunter_level_bridge.clean_str(name) .. "|" .. points)
            syschat("")
            syschat(rank_data.border)
            syschat(rank_data.title_line)
            syschat(rank_data.border)
            syschat("")
            syschat(rank_data.welcome_line1)
            syschat(rank_data.welcome_line2)
            syschat(rank_data.welcome_line3)
            syschat("")
            syschat(rank_data.stats_line)
            syschat("")
            syschat(rank_data.quote)
            syschat(rank_data.border)
        end
        
        function get_rank_key(points)
            local N = tonumber(hunter_level_bridge.get_config("rank_threshold_N")) or 1500000
            local S = tonumber(hunter_level_bridge.get_config("rank_threshold_S")) or 500000
            local A = tonumber(hunter_level_bridge.get_config("rank_threshold_A")) or 150000
            local B = tonumber(hunter_level_bridge.get_config("rank_threshold_B")) or 50000
            local C = tonumber(hunter_level_bridge.get_config("rank_threshold_C")) or 10000
            local D = tonumber(hunter_level_bridge.get_config("rank_threshold_D")) or 2000

            if points >= N then return "N"
            elseif points >= S then return "S"
            elseif points >= A then return "A"
            elseif points >= B then return "B"
            elseif points >= C then return "C"
            elseif points >= D then return "D"
            else return "E" end
        end

        function get_rank_data(rank_key)
            local border = hunter_level_bridge.get_text_colored("welcome_" .. rank_key .. "_border")
            local title = hunter_level_bridge.get_text_colored("welcome_" .. rank_key .. "_title")
            local line1 = hunter_level_bridge.get_text_colored("welcome_" .. rank_key .. "_line1")
            local line2 = hunter_level_bridge.get_text_colored("welcome_" .. rank_key .. "_line2")
            local line3 = hunter_level_bridge.get_text_colored("welcome_" .. rank_key .. "_line3")
            local stats = hunter_level_bridge.get_text_colored("welcome_" .. rank_key .. "_stats")
            local quote = hunter_level_bridge.get_text_colored("welcome_" .. rank_key .. "_quote")
            
            local fallback = {
                ["E"] = {
                    border = "|cff808080====================================================|r",
                    title_line = "|cff808080              [E-RANK] RISVEGLIATO|r",
                    welcome_line1 = "|cffAAAAAA   Bentornato nel Sistema, Cacciatore.|r",
                    welcome_line2 = "|cffAAAAAA   La strada e lunga, ma ogni viaggio|r",
                    welcome_line3 = "|cffAAAAAA   inizia con un singolo passo.|r",
                    stats_line = "|cff808080   >> Status: ATTIVO | Minacce: IN ATTESA <<|r",
                    quote = "|cff808080   'Il debole di oggi... il forte di domani.'|r"
                }
            }
            local fb = fallback["E"]
            
            return {
                border = border or fb.border,
                title_line = title or fb.title_line,
                welcome_line1 = line1 or fb.welcome_line1,
                welcome_line2 = line2 or fb.welcome_line2,
                welcome_line3 = line3 or fb.welcome_line3,
                stats_line = stats or fb.stats_line,
                quote = quote or fb.quote
            }
        end
        
        when hunter_reset_check.timer begin
            local ts = get_time()
            local hour = hunter_level_bridge.get_hour_from_ts(ts)
            local min = hunter_level_bridge.get_min_from_ts(ts)
            local dow = hunter_level_bridge.get_dow_from_ts(ts)
            
            if hour >= 22 then
                hunter_level_bridge.check_missions_reminder()
            end
            
            if hour == 0 and min == 0 then
                local last_daily = game.get_event_flag("hunter_last_daily_reset") or 0
                local today = math.floor(get_time() / 86400)
                if last_daily < today then
                    game.set_event_flag("hunter_last_daily_reset", today)
                    hunter_level_bridge.announce_daily_winners()
                    hunter_level_bridge.process_daily_reset()
                end
                
                if dow == 1 then
                    local last_weekly = game.get_event_flag("hunter_last_weekly_reset") or 0
                    local this_week = math.floor(get_time() / 604800)
                    if last_weekly < this_week then
                        game.set_event_flag("hunter_last_weekly_reset", this_week)
                        hunter_level_bridge.announce_weekly_winners()
                        hunter_level_bridge.process_weekly_reset()
                    end
                end
            end
        end
        
        -- PERFORMANCE: Timer automatico DISABILITATO!
        -- Dati ora vengono inviati SOLO quando il player apre la UI, non ogni 60s
        when hunter_update_timer.timer begin
            -- SOLO check overtake (leggero), no invio dati pesanti
            hunter_level_bridge.check_if_overtaken()
            -- send_player_data() ora viene chiamato solo da /hunter_open
            -- send_timers() ora viene chiamato solo da /hunter_open
            -- send_event() ora viene chiamato solo da /hunter_open
        end
        
        when hunter_emerg_tmr.timer begin
            if pc.getqf("hq_emerg_active") == 1 then
                local expire = pc.getqf("hq_emerg_expire") or 0
                if get_time() > expire then
                    hunter_level_bridge.end_emergency("FAIL")
                end
            else
                cleartimer("hunter_emerg_tmr")
            end
        end
        
        when hunter_tips_timer.timer begin
            local last = game.get_event_flag("hunter_last_tip_time") or 0
            if get_time() - last < 10 then return end
            local c, d = mysql_direct_query("SELECT tip_text FROM srv1_hunabku.hunter_quest_tips ORDER BY RAND() LIMIT 1")
            if c > 0 and d[1] then 
                notice_all("|cffFFD700[HUNTER TIP]|r " .. d[1].tip_text)
                game.set_event_flag("hunter_last_tip_time", get_time()) 
            end
        end
        
        function check_login_streak()
            local today = math.floor(get_time() / 86400)
            local last_login = pc.getqf("hq_last_login_day") or 0
            local streak = pc.getqf("hq_login_streak") or 0
            if today > last_login + 1 then 
                streak = 1 
            elseif today == last_login + 1 then 
                streak = streak + 1 
            end
            pc.setqf("hq_login_streak", streak)
            pc.setqf("hq_last_login_day", today)
            
            local days_tier3 = tonumber(hunter_level_bridge.get_config("streak_days_tier3")) or 30
            local bonus_tier3 = tonumber(hunter_level_bridge.get_config("streak_bonus_30days")) or 20
            local days_tier2 = tonumber(hunter_level_bridge.get_config("streak_days_tier2")) or 7
            local bonus_tier2 = tonumber(hunter_level_bridge.get_config("streak_bonus_7days")) or 10
            local days_tier1 = tonumber(hunter_level_bridge.get_config("streak_days_tier1")) or 3
            local bonus_tier1 = tonumber(hunter_level_bridge.get_config("streak_bonus_3days")) or 5

            local bonus = 0
            if streak >= days_tier3 then
                bonus = bonus_tier3
            elseif streak >= days_tier2 then
                bonus = bonus_tier2
            elseif streak >= days_tier1 then
                bonus = bonus_tier1
            end
            pc.setqf("hq_streak_bonus", bonus)
            if streak > 1 then
                local db_msg = hunter_level_bridge.get_streak_message(streak)
                if db_msg then
                    hunter_level_bridge.hunter_speak(db_msg)
                else
                    hunter_level_bridge.hunter_speak("STREAK GIORNALIERA: " .. streak .. " GIORNI. BONUS: " .. bonus .. " pct")
                end
            end
        end
        
        function check_pending_rewards()
            local pid = pc.get_player_id()
            local c, d = mysql_direct_query("SELECT pending_daily_reward, pending_weekly_reward FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            if c > 0 and d[1] then
                if (tonumber(d[1].pending_daily_reward) or 0) > 0 or (tonumber(d[1].pending_weekly_reward) or 0) > 0 then
                    local msg = hunter_level_bridge.get_text("pending_rewards") or "RICOMPENSE IN ATTESA. CONTROLLA IL TERMINALE."
                    hunter_level_bridge.hunter_speak(msg)
                end
            end
        end
        
        function check_if_overtaken()
            local pid = pc.get_player_id()
            local c, d = mysql_direct_query("SELECT overtaken_by, overtaken_diff, overtaken_label FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid .. " AND overtaken_by IS NOT NULL AND overtaken_by != ''")
            if c > 0 and d[1] and d[1].overtaken_by and d[1].overtaken_by ~= "" then
                local by_name = d[1].overtaken_by
                local diff = tonumber(d[1].overtaken_diff) or 0
                local label = d[1].overtaken_label or "Gloria"
                cmdchat("HunterRivalAlert " .. hunter_level_bridge.clean_str(by_name) .. "|" .. diff .. "|" .. hunter_level_bridge.clean_str(label) .. "|SUPERATO")
                mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET overtaken_by=NULL, overtaken_diff=0, overtaken_label=NULL WHERE player_id=" .. pid)
            end
        end

        function check_rank_up(old_points, new_points)
            local old_rank = hunter_level_bridge.get_rank_index(old_points)
            local new_rank = hunter_level_bridge.get_rank_index(new_points)
            
            if new_rank > old_rank then
                local new_letter = hunter_level_bridge.get_rank_letter(new_rank)
                local pid = pc.get_player_id()
                
                cmdchat("HunterRankUp " .. hunter_level_bridge.get_rank_letter(old_rank) .. "|" .. new_letter)
                pc.setqf("hq_rank_num", new_rank)

                -- PERFORMANCE: Salva tutti i punti accumulati PRIMA del rank up!
                hunter_level_bridge.flush_ranking_updates()

                -- *** FIX: Aggiorna anche il rank nel DATABASE ***
                mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET hunter_rank='" .. new_letter .. "', current_rank='" .. new_letter .. "' WHERE player_id=" .. pid)
                
                if new_rank >= 4 then
                    notice_all("")
                    local global_msg = hunter_level_bridge.get_text("rank_up_global", {NAME = pc.get_name(), RANK = new_letter}) or ("|cffFFD700[RANK UP]|r |cffFFFFFF" .. pc.get_name() .. "|r e' salito al rango [" .. new_letter .. "-RANK]!")
                    notice_all(global_msg)
                    notice_all("")
                end
                
                local msg = hunter_level_bridge.get_text("rank_up_msg", {RANK = new_letter}) or ("RANK UP! Sei ora un " .. new_letter .. "-RANK Hunter!")
                hunter_level_bridge.hunter_speak(msg)
            end
        end
        
        function check_overtake(pid, pname, col_name, added_val, label_nice)
            local RIVAL_RANGES = {
                ["daily_points"]    = tonumber(hunter_level_bridge.get_config("rival_range_daily")) or 500,
                ["weekly_points"]   = tonumber(hunter_level_bridge.get_config("rival_range_weekly")) or 2000,
                ["total_metins"]    = tonumber(hunter_level_bridge.get_config("rival_range_metins")) or 50,
                ["total_chests"]    = tonumber(hunter_level_bridge.get_config("rival_range_chests")) or 50,
                ["total_fractures"] = tonumber(hunter_level_bridge.get_config("rival_range_fractures")) or 20,
                ["total_points"]    = tonumber(hunter_level_bridge.get_config("rival_range_total")) or 50000,
            }
            local limit = RIVAL_RANGES[col_name] or 50000
            local q_me = "SELECT " .. col_name .. " FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid
            local cm, dm = mysql_direct_query(q_me)
            local my_score = 0
            if cm > 0 and dm[1] then my_score = tonumber(dm[1][col_name]) or 0 end
            local new_score = my_score + added_val
            
            local q_above = "SELECT player_id, player_name, " .. col_name .. " as score FROM srv1_hunabku.hunter_quest_ranking WHERE " .. col_name .. " > " .. new_score .. " ORDER BY " .. col_name .. " ASC LIMIT 1"
            local ca, da = mysql_direct_query(q_above)
            if ca > 0 and da[1] then
                local diff = tonumber(da[1].score) - new_score
                if diff > 0 and diff < limit then
                    hunter_level_bridge.notify_rival(da[1].player_name, diff, label_nice)
                end
            end
            
            local q_below = "SELECT player_id, player_name, " .. col_name .. " as score FROM srv1_hunabku.hunter_quest_ranking WHERE " .. col_name .. " < " .. new_score .. " AND " .. col_name .. " >= " .. my_score .. " AND player_id != " .. pid .. " ORDER BY " .. col_name .. " DESC LIMIT 1"
            local cb, db = mysql_direct_query(q_below)
            if cb > 0 and db[1] then
                local overtaken_id = tonumber(db[1].player_id)
                local overtaken_name = db[1].player_name
                local his_score = tonumber(db[1].score)
                local diff = new_score - his_score
                if diff < limit then
                    mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET overtaken_by='" .. mysql_escape_string(pname) .. "', overtaken_diff=" .. diff .. ", overtaken_label='" .. mysql_escape_string(label_nice) .. "' WHERE player_id=" .. overtaken_id)
                    local q_pos = "SELECT COUNT(*) as pos FROM srv1_hunabku.hunter_quest_ranking WHERE " .. col_name .. " > " .. new_score
                    local cp, dp = mysql_direct_query(q_pos)
                    local new_pos = 99
                    if cp > 0 and dp[1] then new_pos = tonumber(dp[1].pos) + 1 end
                    if col_name == "daily_points" or col_name == "weekly_points" then
                        cmdchat("HunterOvertake " .. hunter_level_bridge.clean_str(overtaken_name) .. "|" .. new_pos)
                    end
                end
            end
        end

        -- ============================================================
        -- 4. KILL HANDLER
        -- ============================================================
        
        when kill with not npc.is_pc() and pc.get_level() >= 5 begin
            local vnum = npc.get_race()
            hunter_level_bridge.on_emergency_kill(vnum)
            hunter_level_bridge.on_defense_mob_kill()
            hunter_level_bridge.on_mob_kill(vnum)
            if hunter_level_bridge.is_elite_mob(vnum) then
                hunter_level_bridge.process_elite_kill(vnum)
            else
                hunter_level_bridge.process_normal_kill()
            end
        end
        
        function on_emergency_kill(vnum)
            if pc.getqf("hq_emerg_active") == 1 then
                local req_vnum = pc.getqf("hq_emerg_vnum")
                if req_vnum == 0 or req_vnum == vnum then
                    local current = pc.getqf("hq_emerg_cur") + 1
                    local required = pc.getqf("hq_emerg_req")
                    pc.setqf("hq_emerg_cur", current)
                    hunter_level_bridge.update_emergency(current)

                    if current >= required then
                        hunter_level_bridge.end_emergency("SUCCESS")
                    end
                end
            end
        end

        function on_defense_mob_kill()
            if pc.getqf("hq_defense_active") ~= 1 then return end
            local killed = pc.getqf("hq_defense_mob_killed") or 0
            killed = killed + 1
            pc.setqf("hq_defense_mob_killed", killed)

            local total = pc.getqf("hq_defense_mob_total") or 0
            if killed >= total and total > 0 then
                local start_time = pc.getqf("hq_defense_start") or 0
                local elapsed = get_time() - start_time
                local duration = hunter_level_bridge.get_defense_config("defense_duration", 60)
                if elapsed < duration then
                    hunter_level_bridge.complete_defense_success()
                end
            end
        end

        function process_elite_kill(vnum)
            local mob_info = hunter_level_bridge.get_mob_info(vnum)
            if not mob_info then return end
            
            local pid = pc.get_player_id()
            local pname = pc.get_name()
            local base_pts = mob_info.base_points
            
            local speedkill_active = pc.getqf("hq_speedkill_active") or 0
            local speedkill_vnum = pc.getqf("hq_speedkill_vnum") or 0

            if speedkill_active == 1 and speedkill_vnum == vnum then
                local start_time = pc.getqf("hq_speedkill_start") or 0
                local duration = pc.getqf("hq_speedkill_duration") or 300
                local elapsed = get_time() - start_time

                if elapsed <= duration then
                    base_pts = base_pts * 2
                    pc.setqf("hq_speedkill_active", 0)
                    cleartimer("hq_speedkill_timer")
                    cmdchat("HunterSpeedKillEnd 1")
                    local msg = hunter_level_bridge.get_text("speedkill_success") or "SPEED KILL! GLORIA x2!"
                    hunter_level_bridge.hunter_speak_color(msg, "GOLD")
                else
                    pc.setqf("hq_speedkill_active", 0)
                    cleartimer("hq_speedkill_timer")
                    cmdchat("HunterSpeedKillEnd 0")
                end
            end
            
            local streak_bonus = pc.getqf("hq_streak_bonus") or 0
            if streak_bonus > 0 then 
                base_pts = base_pts + math.floor(base_pts * streak_bonus / 100) 
            end
            
            local player_pts = pc.getqf("hq_total_points") or 0
            local rank_bonus = hunter_level_bridge.get_rank_bonus(player_pts)
            if rank_bonus > 0 then
                base_pts = base_pts + math.floor(base_pts * rank_bonus / 100)
            end
            
            local evt_name, evt_mult, evt_type = hunter_level_bridge.get_active_event()
            if evt_type == "points" then
                base_pts = math.floor(base_pts * evt_mult)
                syschat("|cffFFD700[EVENTO ATTIVO]|r Gloria x" .. evt_mult .. "!")
            end

            local trial_mult = hunter_level_bridge.get_trial_gloria_multiplier()
            if trial_mult < 1.0 then
                local original_pts = base_pts
                base_pts = math.floor(base_pts * trial_mult)
                local reduced = original_pts - base_pts
                syschat("|cffFF6600[PROVA D'ESAME]|r -" .. reduced .. " Gloria (-50% fino a completamento prova)")
            end

            hunter_level_bridge.check_overtake(pid, pname, "daily_points", base_pts, "GIORNALIERA")
            hunter_level_bridge.check_overtake(pid, pname, "weekly_points", base_pts, "SETTIMANALE")

            local old_total_pts = pc.getqf("hq_total_points") or 0

            -- PERFORMANCE: Accumula in quest flags invece di UPDATE immediato!
            hunter_level_bridge.add_pending_points(base_pts, base_pts, base_pts)
            hunter_level_bridge.add_pending_kill()

            pc.setqf("hq_total_kills", (pc.getqf("hq_total_kills") or 0) + 1)
            local new_total_pts = old_total_pts + base_pts
            pc.setqf("hq_total_points", new_total_pts)

            -- Check se il giocatore è salito di rank
            hunter_level_bridge.check_rank_up(old_total_pts, new_total_pts)

            if mob_info.type_name == "SUPER_METIN" then
                hunter_level_bridge.check_overtake(pid, pname, "total_metins", 1, "METIN")
                -- PERFORMANCE: Accumula invece di UPDATE immediato
                pc.setqf("hq_pending_metins", (pc.getqf("hq_pending_metins") or 0) + 1)
                -- MISSION HOOK: Metin ucciso
                hunter_level_bridge.on_metin_kill(vnum)
            elseif mob_info.type_name == "BAULE" then
                hunter_level_bridge.check_overtake(pid, pname, "total_chests", 1, "BAULI")
                -- PERFORMANCE: Accumula invece di UPDATE immediato
                pc.setqf("hq_pending_chests", (pc.getqf("hq_pending_chests") or 0) + 1)
                hunter_level_bridge.give_chest_reward()
            elseif mob_info.type_name == "BOSS" then
                hunter_level_bridge.on_boss_kill(vnum)
            end
            
            local pending = pc.getqf("hq_pending_elite") or 0
            if pending > 0 then 
                pc.setqf("hq_pending_elite", pending - 1) 
            end
            
            local msg = hunter_level_bridge.get_text("target_eliminated", {NAME = mob_info.name, POINTS = base_pts}) or ("BERSAGLIO ELIMINATO: " .. mob_info.name .. " | +" .. base_pts .. " GLORIA")
            hunter_level_bridge.hunter_speak_color(msg, mob_info.rank_color or "BLUE")
            
            hunter_level_bridge.check_achievements()
            hunter_level_bridge.send_player_data()
        end
        
        function process_normal_kill()
            if pc.getqf("hq_emerg_active") == 1 then
                if get_time() > (pc.getqf("hq_emerg_expire") or 0) then
                    pc.setqf("hq_emerg_active", 0) 
                else
                    return 
                end
            end

            local threshold = hunter_level_bridge.get_config("spawn_threshold_normal")
            if threshold <= 0 then threshold = 1000 end 

            local evt_name, evt_mult, evt_type = hunter_level_bridge.get_active_event()
            if evt_type == "threshold" then 
                threshold = math.floor(threshold * evt_mult)
            elseif evt_type == "chance" then
                threshold = math.floor(threshold * 0.7)
            end
            
            local streak = pc.getqf("hq_login_streak") or 0
            threshold = math.max(50, threshold - (streak * 5))
            
            local kills = (pc.getqf("hq_normal_kills") or 0) + 1
            pc.setqf("hq_normal_kills", kills)
            
            if kills >= threshold then 
                pc.setqf("hq_normal_kills", 0)
                
                local emerg_chance = hunter_level_bridge.get_config("emergency_chance_percent")
                if emerg_chance <= 0 then emerg_chance = 35 end 
                
                local roll = number(1, 100)
                
                if roll <= emerg_chance then
                    hunter_level_bridge.trigger_random_emergency()
                else
                    hunter_level_bridge.spawn_fracture() 
                end
            end
        end

        function trigger_random_emergency()
            if pc.getqf("hq_defense_active") == 1 then return end
            if pc.getqf("hq_emerg_active") == 1 then return end
            if pc.getqf("hq_speedkill_active") == 1 then return end

            local lv = pc.get_level()
            local q = "SELECT id, name, duration_seconds, target_count, target_vnum, reward_points, reward_item_vnum, reward_item_count, difficulty FROM srv1_hunabku.hunter_quest_emergencies WHERE enabled = 1 AND min_level <= " .. lv .. " AND max_level >= " .. lv .. " ORDER BY RAND() LIMIT 1"
            
            local c, d = mysql_direct_query(q)
            
            if c > 0 and d[1] then
                local mission = d[1]
                
                pc.setqf("hq_emerg_id", tonumber(mission.id))
                pc.setqf("hq_emerg_reward_pts", tonumber(mission.reward_points) or 0)
                pc.setqf("hq_emerg_reward_vnum", tonumber(mission.reward_item_vnum) or 0)
                pc.setqf("hq_emerg_reward_count", tonumber(mission.reward_item_count) or 0)
                
                hunter_level_bridge.start_emergency(mission.name, tonumber(mission.duration_seconds), tonumber(mission.target_vnum), tonumber(mission.target_count))
                
                local diff_color = {EASY = "|cff00FF00", MEDIUM = "|cffFFFF00", HARD = "|cffFF8800", EXTREME = "|cffFF0000"}
                local dc = diff_color[mission.difficulty] or "|cffFFFFFF"
                syschat(dc .. "[" .. mission.difficulty .. "]|r Missione: " .. mission.name)
            else
                hunter_level_bridge.start_emergency("Orda Improvvisa", 60, 0, 20)
            end
        end
        
        function give_chest_reward()
            local c, d = mysql_direct_query("SELECT item_vnum, item_quantity, bonus_points FROM srv1_hunabku.hunter_quest_jackpot_rewards WHERE type_name='BAULE' ORDER BY RAND() LIMIT 1")
            if c > 0 and d[1] then
                local v, q, b = tonumber(d[1].item_vnum), tonumber(d[1].item_quantity), tonumber(d[1].bonus_points) or 0
                pc.give_item2(v, q)
                local msg = hunter_level_bridge.get_text("chest_opened", {ITEM = hunter_level_bridge.item_name(v)}) or ("BAULE APERTO: OTTENUTO " .. hunter_level_bridge.item_name(v))
                hunter_level_bridge.hunter_speak(msg)
                if b > 0 then
                    mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET total_points=total_points+"..b..", spendable_points=spendable_points+"..b.." WHERE player_id="..pc.get_player_id())
                    local bonus_msg = hunter_level_bridge.get_text("chest_bonus", {POINTS = b}) or ("Incredibile! Il baule conteneva anche " .. b .. " Gloria!")
                    syschat("|cffFFD700[BONUS]|r " .. bonus_msg)
                end
            end
        end
        
        function check_achievements()
            local k, p = pc.getqf("hq_total_kills") or 0, pc.getqf("hq_total_points") or 0
            local c, d = mysql_direct_query("SELECT id, type, requirement FROM srv1_hunabku.hunter_quest_achievements_config WHERE enabled=1")
            local u = 0
            if c > 0 then
                for i=1,c do
                    local aid, at, req = tonumber(d[i].id), tonumber(d[i].type), tonumber(d[i].requirement)
                    local prg = p
                    if at == 1 then prg = k end
                    if prg >= req and pc.getqf("hq_ach_clm_" .. aid) ~= 1 then 
                        u = u + 1 
                    end
                end
            end
            if u > 0 then 
                local msg = hunter_level_bridge.get_text("achievements_unlocked", {COUNT = u}) or ("TRAGUARDI SBLOCCATI: " .. u)
                hunter_level_bridge.hunter_speak(msg)
            end
        end
        
        function spawn_fracture()
            local c, d = mysql_direct_query("SELECT vnum, rank_label, spawn_chance, color_code FROM srv1_hunabku.hunter_quest_fractures WHERE enabled=1 ORDER BY spawn_chance DESC")
            if c == 0 then return end
            
            local roll = number(1, 100)
            local evt_name = hunter_level_bridge.get_active_event()
            if evt_name == "RED+MOON" then 
                roll = number(50, 100) 
            end
            local sel_vnum, sel_rank, sel_color, cumul = 16060, "E-Rank", "GREEN", 0
            for i = 1, c do 
                cumul = cumul + tonumber(d[i].spawn_chance)
                if roll <= cumul then 
                    sel_vnum = tonumber(d[i].vnum)
                    sel_rank = d[i].rank_label
                    sel_color = d[i].color_code or "PURPLE"
                    break 
                end 
            end
            
            local x, y = pc.get_local_x(), pc.get_local_y()
            mob.spawn(sel_vnum, x + 3, y + 3, 1)
            local msg = hunter_level_bridge.get_text("fracture_detected", {RANK = sel_rank}) or ("ATTENZIONE: FRATTURA " .. sel_rank .. " RILEVATA.")
            hunter_level_bridge.hunter_speak_color(msg, sel_color)
        end

        -- ============================================================
        -- 5. GATE LOGIC & WHAT-IF CON COLORI & LOCK SYSTEM
        -- ============================================================
        
        when 16060.click or 16061.click or 16062.click or 16063.click or 16064.click or 16065.click or 16066.click begin
            local vnum = npc.get_race()
            local vid = npc.get_vid() -- ID Univoco di questa specifica frattura
            local pid = pc.get_player_id()
            
            -- CHECK: FRATTURA CONQUISTATA? (Stato di Vittoria)
            local owner_pid = game.get_event_flag("hq_gate_conq_"..vid)
            if owner_pid > 0 then
                if owner_pid == pid then
                    -- IL VINCITORE LA APRE ORA
                    hunter_level_bridge.finalize_gate_opening(vid)
                else
                    syschat("|cffFF0000[SISTEMA]|r Questa frattura e' stata conquistata da un altro Hunter!")
                end
                return
            end

            -- CHECK: FRATTURA SOTTO ATTACCO? (Stato di Difesa)
            local lock_pid = game.get_event_flag("hq_gate_lock_"..vid)
            local lock_time = game.get_event_flag("hq_gate_time_"..vid)
            
            if lock_pid > 0 then
                -- Controllo timeout (se il server crasha o il player slogga male, il lock scade dopo 90s)
                if get_time() > lock_time then
                    game.set_event_flag("hq_gate_lock_"..vid, 0) -- Sblocca
                elseif lock_pid == pid then
                    syschat("|cffFFFF00[SISTEMA]|r Concentrati sulla difesa! Non distrarti!")
                    return
                else
                    syschat("|cffFF0000[SISTEMA]|r Un altro Hunter sta gia' sfidando questa frattura.")
                    return
                end
            end

            -- === LOGICA NORMALE DI APERTURA ===
            local c, d = mysql_direct_query("SELECT name, rank_label, req_points, color_code FROM srv1_hunabku.hunter_quest_fractures WHERE vnum=" .. vnum)
            if c == 0 or not d[1] then return end
            
            local fname, frank, freq = d[1].name, d[1].rank_label, tonumber(d[1].req_points) or 0
            local fcolor = d[1].color_code or "PURPLE"
            local pc_c, pc_d = mysql_direct_query("SELECT total_points FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            local player_pts = 0
            if pc_c > 0 and pc_d[1] then player_pts = tonumber(pc_d[1].total_points) or 0 end
            
            -- Salva dati gate
            pc.setqf("hq_temp_gate_vnum", vnum)
            pc.setqf("hq_temp_gate_freq", freq)
            pc.setqf("hq_temp_player_pts", player_pts)
            hunter_level_bridge.set_temp_gate_data(pid, {
                fname = fname,
                frank = frank,
                fcolor = fcolor
            })
            
            local whatif_chance = hunter_level_bridge.get_config("whatif_chance_percent") or 50
            if number(1, 100) <= whatif_chance then
                -- === WHAT-IF SCENARIO (90%) ===
                local voice_ok = hunter_level_bridge.get_fracture_voice(fcolor, true)
                local voice_no = hunter_level_bridge.get_fracture_voice(fcolor, false)
                local seal_bonus = hunter_level_bridge.get_config("seal_fracture_bonus") or 200
                local opt1_ok = hunter_level_bridge.get_text("whatif_opt1_ok") or ">> ATTRAVERSA IL PORTALE"
                local opt1_force = hunter_level_bridge.get_text("whatif_opt1_force") or ">> FORZA [Party 4+]"
                local opt2 = hunter_level_bridge.get_text("whatif_opt2_seal", {POINTS = seal_bonus}) or ("|| SIGILLA [+" .. seal_bonus .. " Gloria]")
                local opt3 = hunter_level_bridge.get_text("whatif_opt3_retreat") or "<< INDIETREGGIA"
                
                local question_text = ""
                local opt1 = ""
                
                if player_pts >= freq then
                    question_text = "? " .. string.upper(fname) .. " ?|'" .. voice_ok .. "'"
                    opt1 = opt1_ok
                else
                    local mancano = freq - player_pts
                    question_text = "? " .. string.upper(fname) .. " ?|'" .. voice_no .. "'|[Richiesti: " .. freq .. " | Mancano: " .. mancano .. "]"
                    opt1 = opt1_force
                end
                
                hunter_level_bridge.ask_choice_color("gate_main", question_text, opt1, opt2, opt3, fcolor)
            else
                -- === CLASSIC QUEST SCENARIO (50 pct) ===
                say_title("? " .. fname .. " ?")
                say("")
                say(hunter_level_bridge.get_text("classic_gate_intro") or "Questo portale emana un'energia instabile.")
                say("")
                if player_pts >= freq then
                    say(hunter_level_bridge.get_text("classic_gate_worthy") or "Il tuo Rango Hunter e' sufficiente.")
                    say(hunter_level_bridge.get_text("classic_gate_ask") or "Vuoi spezzare il sigillo ed entrare?")
                    say("")
                    if select("Apri Gate", "Chiudi") == 1 then
                        hunter_level_bridge.open_gate(fname, frank, fcolor, pid)
                    end
                else
                    say(hunter_level_bridge.get_text("classic_gate_not_worthy") or "Non possiedi abbastanza Gloria.")
                    say("Gloria Richiesta: " .. freq)
                    say("")
                    if party.is_party() and party.get_near_count() >= 4 then
                        say_reward("Il tuo Party (4+) puo' forzarlo!")
                        if select("Forza Gate", "Chiudi") == 1 then
                            hunter_level_bridge.open_gate(fname, frank, fcolor, pid)
                        end
                    else
                        select("Chiudi")
                    end
                end
            end
        end
        
        when chat."/hunter_whatif_answer" begin
            local txt = pc.get_chat_msg()
            local space1 = string.find(txt, " ", 1, true) or 0
            local space2 = string.find(txt, " ", space1 + 1, true) or 0
            local qid = ""
            local choice = 0
            if space1 > 0 and space2 > 0 then
                qid = string.sub(txt, space1 + 1, space2 - 1)
                choice = tonumber(string.sub(txt, space2 + 1)) or 0
            end
            
            if qid == "gate_main" then
                local vnum = pc.getqf("hq_temp_gate_vnum")
                local freq = pc.getqf("hq_temp_gate_freq") or 0
                local player_pts = pc.getqf("hq_temp_player_pts") or 0
                local pid = pc.get_player_id()
                
                local temp_data = hunter_level_bridge.get_temp_gate_data(pid)
                local fname = temp_data.fname or "Frattura"
                local frank = temp_data.frank or "E-Rank"
                local fcolor = temp_data.fcolor or "PURPLE"
                
                if choice == 1 then
                    if player_pts >= freq then
                        local msg = hunter_level_bridge.get_text("whatif_seal_break") or "IL SIGILLO SI SPEZZA. PREPARATI."
                        hunter_level_bridge.hunter_speak_color(msg, fcolor)
                        hunter_level_bridge.open_gate(fname, frank, fcolor, pid)
                    else
                        if party.is_party() and party.get_near_count() >= 4 then
                            local msg = hunter_level_bridge.get_text("whatif_party_force") or "IL PARTY FORZA IL SIGILLO!"
                            hunter_level_bridge.hunter_speak_color(msg, fcolor)
                            hunter_level_bridge.open_gate(fname, frank, fcolor, pid)
                            local raid_msg = hunter_level_bridge.get_text("classic_raid_announce", {PLAYER = pc.get_name(), RANK = frank}) or ("|cffFF0000[RAID]|r Il Party di " .. pc.get_name() .. " ha forzato un Gate " .. frank .. "!")
                            notice_all(raid_msg)
                        else
                            local msg = hunter_level_bridge.get_text("whatif_need_party") or "ERRORE: SERVONO 4 MEMBRI VICINI."
                            hunter_level_bridge.hunter_speak_color(msg, fcolor)
                        end
                    end
                elseif choice == 2 then
                    npc.purge()
                    local bonus = hunter_level_bridge.get_config("seal_fracture_bonus") or 200
                    mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET total_points=total_points+" .. bonus .. ", spendable_points=spendable_points+" .. bonus .. " WHERE player_id=" .. pid)
                    local msg = hunter_level_bridge.get_text("whatif_sealed", {POINTS = bonus}) or ("FRATTURA SIGILLATA. +" .. bonus .. " GLORIA")
                    hunter_level_bridge.hunter_speak_color(msg, fcolor)
                    hunter_level_bridge.send_player_data()
                elseif choice == 3 then
                    local msg = hunter_level_bridge.get_text("whatif_retreat") or "TI ALLONTANI DALLA FRATTURA."
                    hunter_level_bridge.hunter_speak_color(msg, fcolor)
                end
                
                pc.setqf("hq_temp_gate_vnum", 0)
                pc.setqf("hq_temp_gate_freq", 0)
                pc.setqf("hq_temp_player_pts", 0)
                hunter_level_bridge.set_temp_gate_data(pid, nil)
            end
        end

        function open_gate(fname, frank, fcolor, pid)
            if pc.getqf("hq_emerg_active") == 1 then
                syschat("|cffFF0000[CONFLITTO]|r Completa prima l'Emergency Quest in corso!")
                return
            end
            if pc.getqf("hq_defense_active") == 1 then
                syschat("|cffFF0000[CONFLITTO]|r Stai gia' difendendo un'altra frattura!")
                return
            end

            -- Salva VID e applica LOCK GLOBALE
            local fracture_vid = npc.get_vid() 
            game.set_event_flag("hq_gate_lock_"..fracture_vid, pid)
            game.set_event_flag("hq_gate_time_"..fracture_vid, get_time() + 90) -- 60s quest + 30s buffer

            -- PERFORMANCE: Carica cache waves per questo rank (1 query invece di 60+!)
            hunter_level_bridge.load_defense_waves_cache(frank)

            -- Salva posizione e VID frattura
            local fx, fy = pc.get_local_x(), pc.get_local_y()

            pc.setqf("hq_defense_x", fx)
            pc.setqf("hq_defense_y", fy)
            pc.setqf("hq_defense_active", 1)
            pc.setqf("hq_defense_start", get_time())
            pc.setqf("hq_defense_wave", 0)
            pc.setqf("hq_defense_last_check", get_time())
            pc.setqf("hq_defense_fracture_vid", fracture_vid)

            if not hunter_defense_data then hunter_defense_data = {} end
            hunter_defense_data[pid] = { rank = frank, fname = fname, color = fcolor }

            pc.setqf("hq_defense_mob_total", 0)
            pc.setqf("hq_defense_mob_killed", 0)

            local defense_title = "DIFESA " .. fname
            cmdchat("HunterEmergency " .. hunter_level_bridge.clean_str(defense_title) .. "|60|0|0")

            local msg = hunter_level_bridge.get_text("defense_start") or "DIFENDI LA FRATTURA! Rimani vicino per 60 secondi!"
            hunter_level_bridge.hunter_speak_color(msg, fcolor)

            cleartimer("hq_defense_timer")
            loop_timer("hq_defense_timer", 1)
        end
        
        function get_defense_config(key, default_val)
            local q = "SELECT config_value FROM srv1_hunabku.hunter_fracture_defense_config WHERE config_key='" .. key .. "'"
            local c, d = mysql_direct_query(q)
            if c > 0 and d[1] then
                return tonumber(d[1].config_value) or default_val
            end
            return default_val
        end

        function check_defense_distance()
            local fx = pc.getqf("hq_defense_x") or 0
            local fy = pc.getqf("hq_defense_y") or 0
            if fx == 0 and fy == 0 then return false end
            local px, py = pc.get_local_x(), pc.get_local_y()
            local dx = px - fx
            local dy = py - fy
            local dist = math.sqrt(dx * dx + dy * dy)
            local max_dist = hunter_level_bridge.get_defense_config("check_distance", 10)
            return dist <= max_dist
        end

        function spawn_defense_wave(wave_num, rank_grade)
            local ok, err = pcall(function()
                -- SECURITY: Valida rank
                rank_grade = hunter_level_bridge.validate_rank(rank_grade)

                -- PERFORMANCE: Leggi dalla cache invece che dal DB!
                if not _G.hunter_defense_waves_cache or not _G.hunter_defense_waves_cache[rank_grade] then
                    syschat("[ERROR] Cache waves non caricata per rank " .. rank_grade)
                    return
                end

                local wave_data = _G.hunter_defense_waves_cache[rank_grade][wave_num]
                if not wave_data or not wave_data.mobs then
                    return  -- Wave non esiste
                end

                local fx = pc.getqf("hq_defense_x") or 0
                local fy = pc.getqf("hq_defense_y") or 0
                local total_spawned = 0

                -- Spawna tutti i tipi di mob per questa wave (dalla cache!)
                for i, mob_info in ipairs(wave_data.mobs) do
                    local vnum = mob_info.vnum or 0
                    local count = mob_info.count or 1
                    local radius = mob_info.radius or 7

                    -- Debug spawn
                    syschat("[DEBUG] Ondata " .. wave_num .. ": spawno " .. count .. " mob (VNUM: " .. vnum .. ")")

                    if count > 0 and vnum > 0 then
                        for j = 1, count do
                            local angle = (360 / count) * j
                            local rad = math.rad(angle)
                            local sx = fx + math.floor(math.cos(rad) * radius)
                            local sy = fy + math.floor(math.sin(rad) * radius)
                            mob.spawn(vnum, sx, sy, 1)
                            total_spawned = total_spawned + 1
                        end
                    end
                end
                local current_total = pc.getqf("hq_defense_mob_total") or 0
                pc.setqf("hq_defense_mob_total", current_total + total_spawned)
                local msg = hunter_level_bridge.get_text("defense_wave_spawn", {WAVE = wave_num}) or ("ONDATA " .. wave_num .. "! DIFENDITI!")
                local fcolor = "RED"
                if hunter_defense_data and hunter_defense_data[pc.get_player_id()] then
                    fcolor = hunter_defense_data[pc.get_player_id()].color
                end
                hunter_level_bridge.hunter_speak_color(msg, fcolor)
            end)
        end

        function complete_defense_success()
            local pid = pc.get_player_id()
            local fracture_vid = pc.getqf("hq_defense_fracture_vid") or 0

            local fname = "Frattura"
            local fcolor = "PURPLE"
            if hunter_defense_data and hunter_defense_data[pid] then
                fname = hunter_defense_data[pid].fname
                fcolor = hunter_defense_data[pid].color
            end

            pc.setqf("hq_defense_active", 0)
            cleartimer("hq_defense_timer")
            cmdchat("HunterEmergencyClose success")

            -- GESTIONE LOCK/CONQUISTA GLOBALE
            if fracture_vid > 0 then
                game.set_event_flag("hq_gate_lock_"..fracture_vid, 0)   -- Rimuovi Lock difesa
                game.set_event_flag("hq_gate_conq_"..fracture_vid, pid) -- Imposta Conquistata
            end

            hunter_level_bridge.check_overtake(pid, pc.get_name(), "total_fractures", 1, "ESPLORATORI")
            -- PERFORMANCE: Accumula invece di UPDATE immediato
            pc.setqf("hq_pending_fractures", (pc.getqf("hq_pending_fractures") or 0) + 1)
            pc.setqf("hq_elite_spawn_time", get_time())
            pc.setqf("hq_pending_elite", (pc.getqf("hq_pending_elite") or 0) + 1)
            hunter_level_bridge.on_fracture_seal()

            local msg = hunter_level_bridge.get_text("defense_success_click") or "FRATTURA CONQUISTATA! Toccala per aprirla!"
            hunter_level_bridge.hunter_speak_color(msg, fcolor)
            cmdchat("HunterSystemSpeak " .. fcolor .. "|TOCCA IL PORTALE!")
        end

        function fail_defense(reason)
            local pid = pc.get_player_id()
            local fracture_vid = pc.getqf("hq_defense_fracture_vid") or 0
            
            local fcolor = "RED"
            if hunter_defense_data and hunter_defense_data[pid] then
                fcolor = hunter_defense_data[pid].color
            end

            pc.setqf("hq_defense_active", 0)
            cleartimer("hq_defense_timer")
            cmdchat("HunterEmergencyClose failed")

            -- RESET LOCK GLOBALE (Libera la frattura per riprovare)
            if fracture_vid > 0 then
                game.set_event_flag("hq_gate_lock_"..fracture_vid, 0)
                game.set_event_flag("hq_gate_conq_"..fracture_vid, 0)
                pc.setqf("hq_defense_fracture_vid", 0)
            end

            if hunter_defense_data and hunter_defense_data[pid] then
                hunter_defense_data[pid] = nil
            end

            local msg = hunter_level_bridge.get_text("defense_failed") or ("DIFESA FALLITA: " .. reason)
            hunter_level_bridge.hunter_speak_color(msg, "RED")
        end

        function spawn_gate_mob_and_alert(rank_label, fcolor)
            local c, d = mysql_direct_query("SELECT type_name, probability FROM srv1_hunabku.hunter_quest_spawn_types WHERE enabled=1")
            if c == 0 then return end
            local roll, cumul, sel_type = number(1, 1000), 0, "BOSS"
            for i = 1, c do 
                cumul = cumul + tonumber(d[i].probability)
                if roll <= cumul then 
                    sel_type = d[i].type_name
                    break 
                end 
            end
            
            local lv = pc.get_level()
            local q = "SELECT vnum, name, rank_color FROM srv1_hunabku.hunter_quest_spawns WHERE type_name='" .. sel_type .. "' AND enabled=1 AND min_level<=" .. lv .. " AND max_level>=" .. lv .. " ORDER BY RAND() LIMIT 1"
            local mc, md = mysql_direct_query(q)
            if mc == 0 then 
                q = "SELECT vnum, name, rank_color FROM srv1_hunabku.hunter_quest_spawns WHERE type_name='" .. sel_type .. "' AND enabled=1 ORDER BY RAND() LIMIT 1"
                mc, md = mysql_direct_query(q) 
            end
            
            if mc > 0 and md[1] then
                local x, y = pc.get_local_x(), pc.get_local_y()
                mob.spawn(tonumber(md[1].vnum), x + 5, y + 5, 1)

                local mob_color = md[1].rank_color or "PURPLE"

                if sel_type == "BAULE" then
                    local msg = hunter_level_bridge.get_text("spawn_chest_detected") or "BAULE DEL TESORO RILEVATO!"
                    hunter_level_bridge.hunter_speak_color(msg, fcolor or "GOLD")
                else
                    local msg = hunter_level_bridge.get_text("spawn_boss_appeared", {NAME = md[1].name}) or ("PERICOLO: " .. md[1].name .. " E' APPARSO!")
                    hunter_level_bridge.hunter_speak_color(msg, mob_color)

                    if sel_type == "BOSS" or sel_type == "METIN" then
                        cmdchat("HunterBossAlert " .. string.gsub(md[1].name, " ", "+"))
                    end

                    if not party.is_party() then
                        local speed_time = 300
                        if sel_type == "BOSS" then
                            speed_time = hunter_level_bridge.get_config("speedkill_boss_seconds") or 60
                        elseif sel_type == "METIN" then
                            speed_time = hunter_level_bridge.get_config("speedkill_metin_seconds") or 300
                        end

                        pc.setqf("hq_speedkill_active", 1)
                        pc.setqf("hq_speedkill_start", get_time())
                        pc.setqf("hq_speedkill_duration", speed_time)
                        pc.setqf("hq_speedkill_vnum", tonumber(md[1].vnum))

                        local timer_msg = sel_type == "BOSS" and "BOSS" or "SUPER METIN"
                        cmdchat("HunterSpeedKillStart " .. timer_msg .. "|" .. speed_time .. "|" .. mob_color)

                        local sk_msg = hunter_level_bridge.get_text("speedkill_challenge") or ("SFIDA SPEED KILL! Uccidi in " .. speed_time .. " secondi per GLORIA x2!")
                        hunter_level_bridge.hunter_speak_color(sk_msg, "GOLD")

                        cleartimer("hq_speedkill_timer")
                        loop_timer("hq_speedkill_timer", 1)
                    end
                    
                    local pname = pc.get_name()
                    local alert_1 = hunter_level_bridge.get_text("spawn_alert_seal_broken", {PLAYER = pname}) or ("|cffFF4444[HUNTER ALERT]|r Il Cacciatore |cffFFD700" .. pname .. "|r ha spezzato il sigillo!")
                    notice_all(alert_1)
                    local alert_2 = hunter_level_bridge.get_text("spawn_alert_location", {NAME = md[1].name, RANK = rank_label, X = x, Y = y}) or ("Un |cffFF0000" .. md[1].name .. "|r (" .. rank_label .. ") e' apparso a (" .. x .. ", " .. y .. ")!")
                    notice_all(alert_2)
                end
            end
        end

        function finalize_gate_opening(vid)
            local pid = pc.get_player_id()
            
            local frank = "E"
            local fcolor = "PURPLE"
            if hunter_defense_data and hunter_defense_data[pid] then
                frank = hunter_defense_data[pid].rank
                fcolor = hunter_defense_data[pid].color
                hunter_defense_data[pid] = nil
            end
            
            game.set_event_flag("hq_gate_lock_"..vid, 0)
            game.set_event_flag("hq_gate_conq_"..vid, 0)
            pc.setqf("hq_defense_fracture_vid", 0)
            
            hunter_level_bridge.spawn_gate_mob_and_alert(frank, fcolor)
            npc.purge() 
            
            pc.setqf("hq_elite_spawn_time", get_time())
        end

        -- ============================================================
        -- 6. INTERFACE & DATA SENDING
        -- ============================================================

        when hq_speedkill_timer.timer begin
            if pc.getqf("hq_speedkill_active") ~= 1 then
                cleartimer("hq_speedkill_timer")
                return
            end
            local start_time = pc.getqf("hq_speedkill_start") or 0
            local duration = pc.getqf("hq_speedkill_duration") or 300
            local elapsed = get_time() - start_time
            local remaining = duration - elapsed
            cmdchat("HunterSpeedKillTimer " .. math.max(0, remaining))
            if remaining <= 0 then
                pc.setqf("hq_speedkill_active", 0)
                cleartimer("hq_speedkill_timer")
                cmdchat("HunterSpeedKillEnd 0")
                local msg = hunter_level_bridge.get_text("speedkill_failed") or "TEMPO SCADUTO! Nessun bonus x2."
                hunter_level_bridge.hunter_speak_color(msg, "ORANGE")
            end
        end

        -- PERFORMANCE: Timer salvataggio periodico ranking (ogni 5 minuti)
        when hq_ranking_flush_timer.timer begin
            -- Flush accumulatori ranking su DB
            hunter_level_bridge.flush_ranking_updates()
        end

        -- Timer difesa frattura
        when hq_defense_timer.timer begin
            if pc.getqf("hq_defense_active") ~= 1 then
                cleartimer("hq_defense_timer")
                return
            end

            local start_time = pc.getqf("hq_defense_start") or 0
            local elapsed = get_time() - start_time
            local duration = hunter_level_bridge.get_defense_config("defense_duration", 60)
            
            local last_check = pc.getqf("hq_defense_last_check") or 0
            local check_interval = hunter_level_bridge.get_defense_config("check_interval", 2)

            if get_time() - last_check >= check_interval then
                pc.setqf("hq_defense_last_check", get_time())
                if not hunter_level_bridge.check_defense_distance() then
                    hunter_level_bridge.fail_defense("Ti sei allontanato!")
                    return
                end
                if party.is_party() then
                    local party_req = hunter_level_bridge.get_defense_config("party_all_required", 1)
                    if party_req == 1 then
                        local total = party.get_member_count()
                        local near = party.get_near_count()
                        if near < total then
                            hunter_level_bridge.fail_defense("Un membro del party si è allontanato!")
                            return
                        end
                    end
                end
            end

            -- Spawn ondate in base al tempo (PERFORMANCE: usa cache!)
            local pid = pc.get_player_id()
            local frank = "E"
            if hunter_defense_data and hunter_defense_data[pid] then
                frank = hunter_defense_data[pid].rank
            end
            frank = hunter_level_bridge.validate_rank(frank)
            local current_wave = pc.getqf("hq_defense_wave") or 0

            -- PERFORMANCE: Leggi dalla cache invece che dal DB (NO QUERY OGNI SECONDO!)
            if _G.hunter_defense_waves_cache and _G.hunter_defense_waves_cache[frank] then
                local waves = _G.hunter_defense_waves_cache[frank]

                -- Itera sulle wave nella cache
                for wave_num, wave_data in pairs(waves) do
                    local spawn_time = wave_data.spawn_time

                    if elapsed >= spawn_time and wave_num > current_wave then
                        hunter_level_bridge.spawn_defense_wave(wave_num, frank)
                        pc.setqf("hq_defense_wave", wave_num)
                    end
                end
            end

            if elapsed >= duration then
                local killed = pc.getqf("hq_defense_mob_killed") or 0
                local total = pc.getqf("hq_defense_mob_total") or 0

                if killed >= total and total > 0 then
                    hunter_level_bridge.complete_defense_success()
                else
                    local remaining_mobs = total - killed
                    hunter_level_bridge.fail_defense("TEMPO SCADUTO! Mob rimasti: " .. remaining_mobs)
                end
            end
        end

        when letter begin
            send_letter("Hunter Terminal")

            -- PERFORMANCE: Carica cache mob elite (una query all'avvio invece di N query ai kill)
            hunter_level_bridge.load_elite_cache()

            -- PERFORMANCE: Avvia timer salvataggio periodico ranking (ogni 5 minuti)
            cleartimer("hq_ranking_flush_timer")
            loop_timer("hq_ranking_flush_timer", 300)  -- 300 secondi = 5 minuti

            -- CLEANUP: Se player riconnette durante difesa attiva, pulisci stato
            if pc.getqf("hq_defense_active") == 1 then
                pc.setqf("hq_defense_active", 0)
                pc.setqf("hq_defense_x", 0)
                pc.setqf("hq_defense_y", 0)
                pc.setqf("hq_defense_mob_total", 0)
                pc.setqf("hq_defense_mob_killed", 0)
                cleartimer("hq_defense_timer")
            end
            if pc.getqf("hq_speedkill_active") == 1 then
                pc.setqf("hq_speedkill_active", 0)
                cleartimer("hq_speedkill_timer")
            end
        end

        when button or info begin
            local pid = pc.get_player_id()
            local buy_id = tonumber(game.get_event_flag("hunter_buy_id_"..pid)) or 0
            if buy_id > 0 then 
                game.set_event_flag("hunter_buy_id_"..pid, 0)
                hunter_level_bridge.shop_buy_confirm(buy_id)
                return 
            end
            local clm_id = tonumber(game.get_event_flag("hunter_claim_id_"..pid)) or 0
            if clm_id > 0 then 
                game.set_event_flag("hunter_claim_id_"..pid, 0)
                hunter_level_bridge.achiev_claim(clm_id)
                return 
            end
            local smart_btn = tonumber(game.get_event_flag("hunter_claim_btn_"..pid)) or 0
            if smart_btn > 0 then 
                game.set_event_flag("hunter_claim_btn_"..pid, 0)
                hunter_level_bridge.smart_claim_reward()
                return 
            end
            cmdchat("HunterOpenWindow")
            hunter_level_bridge.send_all_data()
        end
        
        when chat."/hunter_request_data" begin 
            hunter_level_bridge.send_all_data() 
        end
        
        when chat."/hunter_refresh_rank" begin
            local pid = pc.get_player_id()
            local c, d = mysql_direct_query("SELECT total_points FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            if c > 0 and d[1] then
                local pts = tonumber(d[1].total_points) or 0
                local rank_num = hunter_level_bridge.get_rank_index(pts)
                pc.setqf("hq_rank_num", rank_num)
                local rank_key = hunter_level_bridge.get_rank_letter(rank_num)
                syschat("[HUNTER] Rank aggiornato: " .. rank_key .. " (" .. pts .. " Gloria)")
            end
        end
        
        when chat."/htest_msg" with pc.is_gm() begin 
            hunter_level_bridge.hunter_speak("TEST MESSAGGIO SISTEMA V36") 
        end
        when chat."/htest_emerg" with pc.is_gm() begin 
            hunter_level_bridge.trigger_random_emergency() 
        end
        when chat."/htest_whatif" with pc.is_gm() begin 
            hunter_level_bridge.ask_choice_color("gm_test", "Test GM: Scegli", "Opzione A", "Opzione B", "Opzione C", "GOLD")
        end
        when chat."/htest_rival" with pc.is_gm() begin 
            hunter_level_bridge.notify_rival("TestRival", 99999) 
        end
        when chat."/htest_boss" with pc.is_gm() begin 
            cmdchat("HunterBossAlert Demone+della+Frattura") 
        end
        when chat."/htest_init" with pc.is_gm() begin 
            cmdchat("HunterSystemInit") 
        end
        when chat."/htest_awaken" with pc.is_gm() begin 
            cmdchat("HunterAwakening " .. hunter_level_bridge.clean_str(pc.get_name())) 
        end
        when chat."/htest_activate" with pc.is_gm() begin 
            cmdchat("HunterActivation " .. hunter_level_bridge.clean_str(pc.get_name())) 
        end
        when chat."/htest_rankup" with pc.is_gm() begin 
            cmdchat("HunterRankUp E|D") 
        end
        when chat."/htest_overtake" with pc.is_gm() begin 
            cmdchat("HunterOvertake TestPlayer|3") 
        end

        function send_all_data()
            hunter_level_bridge.send_player_data()
            hunter_level_bridge.send_ranking("daily")
            hunter_level_bridge.send_ranking("weekly")
            hunter_level_bridge.send_ranking("total")
            hunter_level_bridge.send_ranking_kills("daily")
            hunter_level_bridge.send_ranking_kills("weekly")
            hunter_level_bridge.send_ranking_kills("total")
            hunter_level_bridge.send_ranking_special("fractures")
            hunter_level_bridge.send_ranking_special("chests")
            hunter_level_bridge.send_ranking_special("metins")
            hunter_level_bridge.send_shop()
            hunter_level_bridge.send_achievements()
            hunter_level_bridge.send_calendar()
            hunter_level_bridge.send_timers()
            hunter_level_bridge.send_event()
            hunter_level_bridge.send_fractures()
        end
        
        function send_player_data()
            local pid = pc.get_player_id()
            local c, d = mysql_direct_query("SELECT total_points, spendable_points, daily_points, weekly_points, total_kills, daily_kills, weekly_kills, total_fractures, total_chests, total_metins, pending_daily_reward, pending_weekly_reward FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            if c > 0 and d[1] then
                local total_pts = tonumber(d[1].total_points) or 0
                local dp, wp = tonumber(d[1].daily_points) or 0, tonumber(d[1].weekly_points) or 0
                local pos_d, pos_w = 0, 0
                
                local new_rank_num = hunter_level_bridge.get_rank_index(total_pts)
                pc.setqf("hq_rank_num", new_rank_num)
                
                if dp > 0 then
                    local cd, dd = mysql_direct_query("SELECT COUNT(*) as pos FROM srv1_hunabku.hunter_quest_ranking WHERE daily_points > " .. dp)
                    if cd > 0 and dd[1] then pos_d = (tonumber(dd[1].pos) or 0) + 1 end
                end
                if wp > 0 then
                    local cw, dw = mysql_direct_query("SELECT COUNT(*) as pos FROM srv1_hunabku.hunter_quest_ranking WHERE weekly_points > " .. wp)
                    if cw > 0 and dw[1] then pos_w = (tonumber(dw[1].pos) or 0) + 1 end
                end
                
                local pkt = hunter_level_bridge.clean_str(pc.get_name()) .. "|" .. 
                    total_pts .. "|" .. 
                    (tonumber(d[1].spendable_points) or 0) .. "|" ..
                    dp .. "|" .. wp .. "|" .. 
                    (tonumber(d[1].total_kills) or 0) .. "|" ..
                    (tonumber(d[1].daily_kills) or 0) .. "|" .. 
                    (tonumber(d[1].weekly_kills) or 0) .. "|" .. 
                    (pc.getqf("hq_login_streak") or 0) .. "|" ..
                    (pc.getqf("hq_streak_bonus") or 0) .. "|" .. 
                    (tonumber(d[1].total_fractures) or 0) .. "|" .. 
                    (tonumber(d[1].total_chests) or 0) .. "|" ..
                    (tonumber(d[1].total_metins) or 0) .. "|" .. 
                    (tonumber(d[1].pending_daily_reward) or 0) .. "|" .. 
                    (tonumber(d[1].pending_weekly_reward) or 0) .. "|" ..
                    pos_d .. "|" .. pos_w
                cmdchat("HunterPlayerData " .. pkt)
            end
        end
        
        function send_ranking(rtype)
            local col, kcol, cmd = "total_points", "total_kills", "HunterRankingTotal"
            if rtype == "daily" then 
                col, kcol, cmd = "daily_points", "daily_kills", "HunterRankingDaily"
            elseif rtype == "weekly" then 
                col, kcol, cmd = "weekly_points", "weekly_kills", "HunterRankingWeekly" 
            end
            local q = "SELECT player_name, " .. col .. " as pts, " .. kcol .. " as kills FROM srv1_hunabku.hunter_quest_ranking WHERE " .. col .. " > 0 ORDER BY " .. col .. " DESC LIMIT 10"
            local c, d = mysql_direct_query(q)
            local str = ""
            if c > 0 then 
                for i=1,c do 
                    str = str .. hunter_level_bridge.clean_str(d[i].player_name) .. "," .. d[i].pts .. "," .. d[i].kills .. ";" 
                end 
            end
            local result = "EMPTY"
            if str ~= "" then result = str end
            cmdchat(cmd .. " " .. result)
        end
        
        function send_ranking_kills(rtype)
            local col, cmd = "total_kills", "HunterRankingTotalKills"
            if rtype == "daily" then 
                col, cmd = "daily_kills", "HunterRankingDailyKills"
            elseif rtype == "weekly" then 
                col, cmd = "weekly_kills", "HunterRankingWeeklyKills" 
            end
            local q = "SELECT player_name, " .. col .. " as val, total_points FROM srv1_hunabku.hunter_quest_ranking WHERE " .. col .. " > 0 ORDER BY " .. col .. " DESC LIMIT 10"
            local c, d = mysql_direct_query(q)
            local str = ""
            if c > 0 then 
                for i=1,c do 
                    str = str .. hunter_level_bridge.clean_str(d[i].player_name) .. "," .. d[i].val .. "," .. d[i].total_points .. ";" 
                end 
            end
            cmdchat(cmd .. " " .. (str == "" and "EMPTY" or str))
        end
        
        function send_ranking_special(cat)
            local col, cmd = "total_fractures", "HunterRankingFractures"
            if cat == "chests" then 
                col, cmd = "total_chests", "HunterRankingChests"
            elseif cat == "metins" then 
                col, cmd = "total_metins", "HunterRankingMetins" 
            end
            local q = "SELECT player_name, " .. col .. " as val, total_points FROM srv1_hunabku.hunter_quest_ranking WHERE " .. col .. " > 0 ORDER BY " .. col .. " DESC LIMIT 10"
            local c, d = mysql_direct_query(q)
            local str = ""
            if c > 0 then 
                for i=1,c do 
                    str = str .. hunter_level_bridge.clean_str(d[i].player_name) .. "," .. d[i].val .. "," .. d[i].total_points .. ";" 
                end 
            end
            cmdchat(cmd .. " " .. (str == "" and "EMPTY" or str))
        end
        
        function send_shop()
            local c, d = mysql_direct_query("SELECT id, item_vnum, item_count, price_points, description FROM srv1_hunabku.hunter_quest_shop WHERE enabled=1 ORDER BY display_order")
            local str = ""
            if c > 0 then 
                for i=1,c do 
                    str = str .. d[i].id .. "," .. d[i].item_vnum .. "," .. d[i].item_count .. "," .. d[i].price_points .. "," .. hunter_level_bridge.clean_str(d[i].description) .. ";" 
                end 
            end
            local result = "EMPTY"
            if str ~= "" then result = str end
            cmdchat("HunterShopItems " .. result)
        end
        
        function send_achievements()
            local c, d = mysql_direct_query("SELECT id, name, type, requirement FROM srv1_hunabku.hunter_quest_achievements_config WHERE enabled=1 ORDER BY requirement")
            local str = ""
            if c > 0 then
                local k, p = pc.getqf("hq_total_kills") or 0, pc.getqf("hq_total_points") or 0
                for i=1,c do
                    local aid, at, req = tonumber(d[i].id), tonumber(d[i].type), tonumber(d[i].requirement)
                    local prg = k
                    if at ~= 1 then prg = p end
                    local unl = 0
                    if prg >= req then unl = 1 end
                    local clm = pc.getqf("hq_ach_clm_" .. aid) or 0
                    str = str .. aid .. "," .. hunter_level_bridge.clean_str(d[i].name) .. "," .. at .. "," .. req .. "," .. prg .. "," .. unl .. "," .. clm .. ";"
                end
            end
            local result = "EMPTY"
            if str ~= "" then result = str end
            cmdchat("HunterAchievements " .. result)
        end
        
        function send_calendar()
            local c, d = mysql_direct_query("SELECT DISTINCT SUBSTRING_INDEX(days_active, ',', 1) as day_index, event_name, start_hour, (start_hour + FLOOR(duration_minutes/60)) as end_hour FROM srv1_hunabku.hunter_scheduled_events WHERE enabled = 1 ORDER BY start_hour LIMIT 21")
            local str = ""
            if c > 0 then 
                for i=1,c do
                    local day_idx = tonumber(d[i].day_index) or 1
                    day_idx = day_idx - 1
                    str = str .. day_idx .. "," .. hunter_level_bridge.clean_str(d[i].event_name) .. "," .. d[i].start_hour .. "," .. d[i].end_hour .. ";" 
                end 
            end
            local result = "EMPTY"
            if str ~= "" then result = str end
            cmdchat("HunterCalendar " .. result)
        end
        
        function send_timers()
            local ts = get_time()
            local hour = hunter_level_bridge.get_hour_from_ts(ts)
            local min = hunter_level_bridge.get_min_from_ts(ts)
            local sec = hunter_level_bridge.get_sec_from_ts(ts)
            local seconds_today = (hour * 3600) + (min * 60) + sec
            local daily = 86400 - seconds_today
            local wday = hunter_level_bridge.get_day_db_from_ts(ts)
            local days_to_mon = 8 - wday
            if days_to_mon == 8 then days_to_mon = 7 end
            local weekly = (days_to_mon * 86400) - seconds_today
            cmdchat("HunterTimers " .. daily .. "|" .. weekly)
        end
        
        function send_event()
            local event = hunter_level_bridge.get_current_scheduled_event()
            local result = "NONE"
            
            if event then
                local name = event.event_name or "Evento"
                local desc = event.event_desc or ""
                local etype = event.event_type or "glory_rush"
                local reward = tonumber(event.reward_glory_base) or 50
                local winner = tonumber(event.reward_glory_winner) or 200
                
                local t = os.date("*t")
                local current_hour = t.hour
                local current_minute = t.min
                local current_total = current_hour * 60 + current_minute
                
                local start_total = tonumber(event.start_hour) * 60 + tonumber(event.start_minute)
                local duration = tonumber(event.duration_minutes) or 30
                local end_total = start_total + duration
                
                local remaining_minutes = end_total - current_total
                local remaining_seconds = remaining_minutes * 60
                
                result = hunter_level_bridge.clean_str(name) .. "|" .. 
                         hunter_level_bridge.clean_str(desc) .. "|" .. 
                         etype .. "|" .. 
                         math.floor(remaining_seconds) .. "|" .. 
                         reward .. "|" .. 
                         winner
            end
            cmdchat("HunterActiveEvent " .. result)
        end
        
        function send_fractures()
            local c, d = mysql_direct_query("SELECT name, req_points FROM srv1_hunabku.hunter_quest_fractures WHERE enabled=1 ORDER BY req_points")
            local str = ""
            if c > 0 then 
                for i=1,c do 
                    str = str .. hunter_level_bridge.clean_str(d[i].name) .. "," .. d[i].req_points .. ";" 
                end 
            end
            local result = "EMPTY"
            if str ~= "" then result = str end
            cmdchat("HunterFractures " .. result)
        end

        -- ============================================================
        -- 7. SHOPS & REWARDS
        -- ============================================================
        
        function achiev_claim(id)
            local c, d = mysql_direct_query("SELECT name, type, requirement, reward_vnum, reward_count FROM srv1_hunabku.hunter_quest_achievements_config WHERE id="..id)
            if c == 0 or not d[1] then return end
            
            local name, req, vnum, count = d[1].name, tonumber(d[1].requirement), tonumber(d[1].reward_vnum), tonumber(d[1].reward_count)
            local atype = tonumber(d[1].type)
            local prog = pc.getqf("hq_total_points")
            if atype == 1 then prog = pc.getqf("hq_total_kills") end
            local is_claimed = (pc.getqf("hq_ach_clm_"..id) == 1)
            local is_unlocked = (prog >= req)
            
            say_title("|cffFFD700ACHIEVEMENT: " .. name .. "|r")
            say("Requisito: " .. req .. (atype==1 and " Kills" or " Gloria"))
            say("Ricompensa: x" .. count .. " " .. hunter_level_bridge.item_name(vnum))
            say_item_vnum(vnum)
            say("")
            if is_claimed then 
                say("|cffFF0000[!] RICOMPENSA GIA' RISCOSSA|r")
                select("Chiudi")
            elseif not is_unlocked then 
                say("|cff888888[!] BLOCCATO - Impegnati di piu'|r")
                select("Chiudi")
            else
                if select("Riscuoti Premio", "Chiudi") == 1 then
                    pc.setqf("hq_ach_clm_"..id, 1)
                    pc.give_item2(vnum, count)
                    hunter_level_bridge.hunter_speak("OGGETTO RICEVUTO: " .. hunter_level_bridge.item_name(vnum))
                    hunter_level_bridge.send_achievements()
                end
            end
        end

        function smart_claim_reward()
            local pid = pc.get_player_id()
            local c, d = mysql_direct_query("SELECT pending_daily_reward, pending_weekly_reward FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            if c == 0 or not d[1] then return end
            
            local pd, pw = tonumber(d[1].pending_daily_reward) or 0, tonumber(d[1].pending_weekly_reward) or 0
            if pd == 0 and pw == 0 then 
                say_title("RICOMPENSE HUNTER")
                say("Nessun premio in attesa al momento.")
                say("Scala la classifica per ottenere gloria!")
                select("Chiudi")
                return 
            end
            
            say_title("PREMI DISPONIBILI")
            local opts, rdata = {}, {}
            if pd > 0 then
                local rc, rd = mysql_direct_query("SELECT item_vnum, item_quantity FROM srv1_hunabku.hunter_quest_rewards WHERE reward_type='daily' AND rank_position=" .. pd)
                if rc > 0 and rd[1] then
                    say("|cff00FFFF[DAILY RANK]|r Posizione: |cffFFD700" .. pd .. "|r")
                    say_item_vnum(tonumber(rd[1].item_vnum))
                    table.insert(opts, "Riscuoti Premio Giornaliero")
                    table.insert(rdata, {t="daily", p=pd, v=tonumber(rd[1].item_vnum), q=tonumber(rd[1].item_quantity)})
                end
            end
            if pw > 0 then
                local rc, rd = mysql_direct_query("SELECT item_vnum, item_quantity FROM srv1_hunabku.hunter_quest_rewards WHERE reward_type='weekly' AND rank_position=" .. pw)
                if rc > 0 and rd[1] then
                    say("|cffFFD700[WEEKLY RANK]|r Posizione: |cffFFD700" .. pw .. "|r")
                    say_item_vnum(tonumber(rd[1].item_vnum))
                    table.insert(opts, "Riscuoti Premio Settimanale")
                    table.insert(rdata, {t="weekly", p=pw, v=tonumber(rd[1].item_vnum), q=tonumber(rd[1].item_quantity)})
                end
            end
            if pd > 0 and pw > 0 then 
                table.insert(opts, "Riscuoti TUTTO") 
            end
            table.insert(opts, "Annulla")
            local s = select_table(opts)
            if s == table.getn(opts) then return end
            
            if pd > 0 and pw > 0 and s == table.getn(opts)-1 then
                hunter_level_bridge.give_pending_reward("daily", pd)
                hunter_level_bridge.give_pending_reward("weekly", pw)
            elseif rdata[s] then
                hunter_level_bridge.give_pending_reward(rdata[s].t, rdata[s].p)
            end
            hunter_level_bridge.send_player_data()
        end
        
        function give_pending_reward(rtype, pos)
            local pid = pc.get_player_id()
            local rc, rd = mysql_direct_query("SELECT item_vnum, item_quantity FROM srv1_hunabku.hunter_quest_rewards WHERE reward_type='" .. rtype .. "' AND rank_position=" .. pos)
            if rc > 0 and rd[1] then
                pc.give_item2(tonumber(rd[1].item_vnum), tonumber(rd[1].item_quantity))
                mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET " .. (rtype=="weekly" and "pending_weekly_reward" or "pending_daily_reward") .. " = 0 WHERE player_id=" .. pid)
                local pname = pc.get_name()
                local rtype_label = rtype == "daily" and (hunter_level_bridge.get_text("reward_type_daily") or "Giornaliera") or (hunter_level_bridge.get_text("reward_type_weekly") or "Settimanale")
                local msg = hunter_level_bridge.get_text("reward_claimed", {PLAYER = pname, TYPE = rtype_label}) or ("|cffFFD700[HUNTER]|r " .. pname .. " ha riscosso il premio Top Classifica " .. rtype_label .. "!")
                notice_all(msg)
            end
        end
        
        function shop_buy_confirm(id)
            local pid = pc.get_player_id()
            local c, d = mysql_direct_query("SELECT item_vnum, item_count, price_points, description FROM srv1_hunabku.hunter_quest_shop WHERE id=" .. id)
            if c > 0 and d[1] then
                local title = hunter_level_bridge.get_text("shop_title") or "MERCANTE HUNTER"
                local ask = hunter_level_bridge.get_text("shop_ask") or "Vuoi acquistare questo oggetto?"
                local opt_confirm = hunter_level_bridge.get_text("shop_opt_confirm") or "Conferma Acquisto"
                local opt_cancel = hunter_level_bridge.get_text("shop_opt_cancel") or "Annulla"
                
                say_title(title)
                say(ask)
                say_item_vnum(tonumber(d[1].item_vnum))
                say("Costo: |cffFFA500" .. d[1].price_points .. " Crediti|r")
                if select(opt_confirm, opt_cancel) == 1 then
                    local wc, wd = mysql_direct_query("SELECT spendable_points FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
                    local wallet = 0
                    if wc > 0 and wd[1] then wallet = tonumber(wd[1].spendable_points) or 0 end
                    if wallet >= tonumber(d[1].price_points) then
                        mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET spendable_points = spendable_points - " .. d[1].price_points .. " WHERE player_id=" .. pid)
                        pc.give_item2(tonumber(d[1].item_vnum), tonumber(d[1].item_count))
                        local msg = hunter_level_bridge.get_text("shop_success", {POINTS = d[1].price_points}) or ("TRANSAZIONE COMPLETATA. -" .. d[1].price_points .. " CREDITI")
                        hunter_level_bridge.hunter_speak(msg)
                        hunter_level_bridge.send_player_data()
                    else
                        local msg = hunter_level_bridge.get_text("shop_error_funds") or "ERRORE: CREDITI INSUFFICIENTI."
                        hunter_level_bridge.hunter_speak(msg)
                    end
                end
            end
        end
        
        when chat."/hunter_reset_daily" with pc.is_gm() begin 
            hunter_level_bridge.process_daily_reset() 
        end
        when chat."/hunter_reset_weekly" with pc.is_gm() begin 
            hunter_level_bridge.process_weekly_reset() 
        end
        
        function announce_daily_winners()
            local q = "SELECT player_name, daily_points FROM srv1_hunabku.hunter_quest_ranking WHERE daily_points > 0 ORDER BY daily_points DESC LIMIT 3"
            local c, d = mysql_direct_query(q)
            if c > 0 then
                local sep_daily = hunter_level_bridge.get_text("winners_sep_daily") or "|cffFFD700======================================|r"
                local title_daily = hunter_level_bridge.get_text("winners_title_daily") or "|cffFFD700[HUNTER SYSTEM]|r |cff00FFFF* VINCITORI CLASSIFICA GIORNALIERA *|r"
                notice_all("")
                notice_all(sep_daily)
                notice_all(title_daily)
                notice_all(sep_daily)
                for i = 1, c do
                    local medal = ""
                    local color = ""
                    if i == 1 then medal = "[1]" color = "|cffFFD700" end
                    if i == 2 then medal = "[2]" color = "|cffC0C0C0" end
                    if i == 3 then medal = "[3]" color = "|cffCD7F32" end
                    notice_all(medal .. " " .. color .. d[i].player_name .. "|r - |cffFFFFFF" .. d[i].daily_points .. " Gloria|r")
                end
                notice_all(sep_daily)
                notice_all("")
                local msg = "[HUNTER SYSTEM] Vincitori Gloria: "
                for i = 1, c do
                    if i > 1 then msg = msg .. ", " end
                    msg = msg .. d[i].player_name .. " (" .. d[i].daily_points .. ")"
                end
                hunter_level_bridge.hunter_speak(msg)
            end

            local qk = "SELECT player_name, daily_kills FROM srv1_hunabku.hunter_quest_ranking WHERE daily_kills > 0 ORDER BY daily_kills DESC LIMIT 3"
            local ck, dk = mysql_direct_query(qk)
            if ck > 0 then
                local sep_kill = hunter_level_bridge.get_text("winners_sep_kill") or "|cffFF8800======================================|r"
                local title_kill = hunter_level_bridge.get_text("winners_title_kill") or "|cffFF8800[HUNTER SYSTEM]|r |cffFF8800* VINCITORI CLASSIFICA KILL GIORNALIERA *|r"
                notice_all("")
                notice_all(sep_kill)
                notice_all(title_kill)
                notice_all(sep_kill)
                for i = 1, ck do
                    local medal = ""
                    local color = ""
                    if i == 1 then medal = "[1]" color = "|cffFFD700" end
                    if i == 2 then medal = "[2]" color = "|cffC0C0C0" end
                    if i == 3 then medal = "[3]" color = "|cffCD7F32" end
                    notice_all(medal .. " " .. color .. dk[i].player_name .. "|r - |cffFFFFFF" .. dk[i].daily_kills .. " Kill|r")
                end
                notice_all(sep_kill)
                notice_all("")
                local msgk = "[HUNTER SYSTEM] Vincitori Kill: "
                for i = 1, ck do
                    if i > 1 then msgk = msgk .. ", " end
                    msgk = msgk .. dk[i].player_name .. " (" .. dk[i].daily_kills .. ")"
                end
                hunter_level_bridge.hunter_speak(msgk)
            end
        end
        
        function announce_weekly_winners()
            local q = "SELECT player_name, weekly_points FROM srv1_hunabku.hunter_quest_ranking WHERE weekly_points > 0 ORDER BY weekly_points DESC LIMIT 3"
            local c, d = mysql_direct_query(q)
            if c > 0 then
                local sep_weekly = hunter_level_bridge.get_text("winners_sep_weekly") or "|cffFF6600======================================|r"
                local title_weekly = hunter_level_bridge.get_text("winners_title_weekly") or "|cffFF6600[HUNTER SYSTEM]|r |cffFFD700** VINCITORI CLASSIFICA SETTIMANALE **|r"
                notice_all("")
                notice_all(sep_weekly)
                notice_all(title_weekly)
                notice_all(sep_weekly)
                for i = 1, c do
                    local medal = ""
                    local color = ""
                    if i == 1 then medal = "[1]" color = "|cffFFD700" end
                    if i == 2 then medal = "[2]" color = "|cffC0C0C0" end
                    if i == 3 then medal = "[3]" color = "|cffCD7F32" end
                    notice_all(medal .. " " .. color .. d[i].player_name .. "|r - |cffFFFFFF" .. d[i].weekly_points .. " Gloria|r")
                end
                notice_all(sep_weekly)
                notice_all("")
            end
        end
        
        function process_daily_reset()
            hunter_level_bridge.assign_rank_prizes("daily")
            mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET daily_points = 0, daily_kills = 0")
            local msg = hunter_level_bridge.get_text("reset_daily") or "|cffFFD700[HUNTER SYSTEM]|r Classifica Giornaliera Resettata! La corsa al potere ricomincia."
            notice_all(msg)
        end
        
        function process_weekly_reset()
            hunter_level_bridge.assign_rank_prizes("weekly")
            mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET weekly_points = 0, weekly_kills = 0")
            local msg = hunter_level_bridge.get_text("reset_weekly") or "|cffFF6600[HUNTER SYSTEM]|r Classifica Settimanale Resettata! I premi sono stati distribuiti."
            notice_all(msg)
        end
        
        function assign_rank_prizes(rtype)
            local col = rtype == "weekly" and "weekly_points" or "daily_points"
            local pcol = rtype == "weekly" and "pending_weekly_reward" or "pending_daily_reward"
            local q = "SELECT player_id FROM srv1_hunabku.hunter_quest_ranking WHERE " .. col .. " > 0 ORDER BY " .. col .. " DESC LIMIT 3"
            local c, d = mysql_direct_query(q)
            if c > 0 then
                for i=1,c do 
                    mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET " .. pcol .. " = " .. i .. " WHERE player_id = " .. d[i].player_id) 
                end
            end
        end
        
        function assign_daily_missions()
            local pid = pc.get_player_id()
            local pname = pc.get_name()
            local today_query = "SELECT CURDATE() as today"
            local tc, td = mysql_direct_query(today_query)
            local today = td[1].today
            
            local last_assign_day = pc.getqf("hq_last_assign_day") or 0
            local current_day = tonumber(os.date("%j")) or 0
            
            if last_assign_day == current_day then
                local c, d = mysql_direct_query("SELECT COUNT(*) as cnt FROM srv1_hunabku.hunter_player_missions WHERE player_id=" .. pid .. " AND assigned_date='" .. today .. "' AND status='active'")
                if c > 0 and tonumber(d[1].cnt) >= 3 then
                    return false
                end
            end
            
            local c, d = mysql_direct_query("SELECT COUNT(*) as cnt FROM srv1_hunabku.hunter_player_missions WHERE player_id=" .. pid .. " AND assigned_date='" .. today .. "' AND status='active'")
            if c > 0 and tonumber(d[1].cnt) >= 3 then
                pc.setqf("hq_last_assign_day", current_day)
                return false
            end
            
            pc.setqf("hq_last_assign_day", current_day)
            
            local rc, rd = mysql_direct_query("SELECT total_points FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            local pts = 0
            if rc > 0 and rd[1] then pts = tonumber(rd[1].total_points) or 0 end
            local rank_idx = hunter_level_bridge.get_rank_index(pts)
            local rank_letter = hunter_level_bridge.get_rank_letter(rank_idx)
            
            mysql_direct_query("CALL srv1_hunabku.sp_assign_daily_missions(" .. pid .. ", '" .. rank_letter .. "', '" .. pname .. "')")
            
            local vc, vd = mysql_direct_query("SELECT COUNT(*) as cnt FROM srv1_hunabku.hunter_player_missions WHERE player_id=" .. pid .. " AND assigned_date='" .. today .. "' AND status='active'")
            local inserted_count = 0
            if vc > 0 and vd[1] then inserted_count = tonumber(vd[1].cnt) or 0 end
            
            if inserted_count >= 3 then
                hunter_level_bridge.send_daily_missions()
                timer("hq_missions_notify", 6)
                return true
            else
                syschat("|cffFF0000[HUNTER ERROR] Impossibile assegnare missioni. Contatta un GM.|r")
                return false
            end
        end
        
        when hq_missions_notify.timer begin
            local msg1 = hunter_level_bridge.get_text("missions_assigned") or "3 NUOVE MISSIONI GIORNALIERE ASSEGNATE!"
            hunter_level_bridge.hunter_speak_color(msg1, "CYAN")
            syschat("|cff00FFFF>> Apri il Terminale Hunter per vederle <<|r")
            syschat("|cffFFAA00   Completale tutte per bonus Gloria x1.5!|r")
        end
        
        function send_daily_missions()
            local pid = pc.get_player_id()
            local today = hunter_level_bridge.get_today_date()
            local q = "SELECT pm.id, pm.mission_slot, md.mission_name, md.mission_type, pm.current_progress, pm.target_count, pm.status, pm.reward_glory, pm.penalty_glory, md.time_limit_minutes FROM srv1_hunabku.hunter_player_missions pm LEFT JOIN srv1_hunabku.hunter_mission_definitions md ON pm.mission_def_id = md.mission_id WHERE pm.player_id=" .. pid .. " AND pm.assigned_date='" .. today .. "' ORDER BY pm.mission_slot"
            local c, d = mysql_direct_query(q)
            
            cmdchat("HunterMissionsCount " .. c)
            
            if c > 0 then
                for i = 1, c do
                    local m = d[i]
                    local remaining = 0
                    local time_limit = tonumber(m.time_limit_minutes) or 0
                    if time_limit > 0 then
                        remaining = time_limit * 60
                    end
                    local pkt = tostring(tonumber(m.id) or 0) .. "|" ..
                        hunter_level_bridge.clean_str(m.mission_name or "Missione") .. "|" ..
                        (m.mission_type or "kill_mob") .. "|" ..
                        tostring(tonumber(m.current_progress) or 0) .. "|" ..
                        tostring(tonumber(m.target_count) or 10) .. "|" ..
                        tostring(tonumber(m.reward_glory) or 50) .. "|" ..
                        tostring(tonumber(m.penalty_glory) or 25) .. "|" ..
                        (m.status or "active")
                    cmdchat("HunterMissionData " .. pkt)
                end
            end
        end
        
        function update_mission_progress(mission_type, amount, target_vnum)
            local pid = pc.get_player_id()
            target_vnum = target_vnum or 0
            local q = "SELECT pm.id, pm.current_progress, pm.target_count, pm.reward_glory, md.mission_name, md.target_vnum FROM srv1_hunabku.hunter_player_missions pm LEFT JOIN srv1_hunabku.hunter_mission_definitions md ON pm.mission_def_id = md.mission_id WHERE pm.player_id=" .. pid .. " AND pm.assigned_date=CURDATE() AND pm.status='active' AND md.mission_type='" .. mission_type .. "' AND (md.target_vnum = 0 OR md.target_vnum = " .. target_vnum .. ")"
            local c, d = mysql_direct_query(q)
            if c > 0 then
                for i = 1, c do
                    local m = d[i]
                    local mid = tonumber(m.id)
                    local cur = tonumber(m.current_progress) or 0
                    local target = tonumber(m.target_count) or 10
                    local new_progress = math.min(cur + amount, target)
                    mysql_direct_query("UPDATE srv1_hunabku.hunter_player_missions SET current_progress=" .. new_progress .. " WHERE id=" .. mid)
                    cmdchat("HunterMissionProgress " .. mid .. "|" .. new_progress .. "|" .. target)
                    if new_progress >= target then
                        hunter_level_bridge.complete_mission(mid)
                    end
                end
            end
        end
        
        function complete_mission(mission_id)
            local pid = pc.get_player_id()
            local today = hunter_level_bridge.get_today_date()
            local c, d = mysql_direct_query("SELECT pm.reward_glory, pm.status, md.mission_name FROM srv1_hunabku.hunter_player_missions pm LEFT JOIN srv1_hunabku.hunter_mission_definitions md ON pm.mission_def_id = md.mission_id WHERE pm.id=" .. mission_id .. " AND pm.player_id=" .. pid)
            if c == 0 or d[1].status ~= "active" then return end
            
            local reward = tonumber(d[1].reward_glory) or 50
            local name = d[1].mission_name or "Missione"
            
            mysql_direct_query("UPDATE srv1_hunabku.hunter_player_missions SET status='completed', completed_at=NOW() WHERE id=" .. mission_id)
            mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET total_points = total_points + " .. reward .. ", spendable_points = spendable_points + " .. reward .. ", daily_points = daily_points + " .. reward .. ", weekly_points = weekly_points + " .. reward .. " WHERE player_id=" .. pid)
            
            local cc, cd = mysql_direct_query("SELECT COUNT(*) as completed FROM srv1_hunabku.hunter_player_missions WHERE player_id=" .. pid .. " AND assigned_date='" .. today .. "' AND status='completed'")
            local completed_count = 1
            if cc > 0 and cd[1] then completed_count = tonumber(cd[1].completed) or 1 end
            
            syschat("|cff00FF00========================================|r")
            syschat("|cff00FF00  [MISSIONE COMPLETATA]|r |cffFFFFFF" .. name .. "|r")
            syschat("|cffFFD700  +" .. reward .. " Gloria!|r |cffAAAAAA(" .. completed_count .. "/3 complete)|r")
            syschat("|cff00FF00========================================|r")
            
            hunter_level_bridge.hunter_speak("MISSIONE COMPLETATA! +" .. reward .. " GLORIA")
            cmdchat("HunterMissionComplete " .. mission_id .. "|" .. hunter_level_bridge.clean_str(name) .. "|" .. reward)
            
            hunter_level_bridge.check_all_missions_complete()
            hunter_level_bridge.send_player_data()
        end
        
        function check_all_missions_complete()
            local pid = pc.get_player_id()
            local today = hunter_level_bridge.get_today_date()
            local c, d = mysql_direct_query("SELECT COUNT(*) as total, SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) as completed FROM srv1_hunabku.hunter_player_missions WHERE player_id=" .. pid .. " AND assigned_date='" .. today .. "'")
            
            if c > 0 and d[1] then
                local total = tonumber(d[1].total) or 0
                local completed = tonumber(d[1].completed) or 0
                
                if total >= 3 and completed >= 3 then
                    local sc, sd = mysql_direct_query("SELECT SUM(reward_glory) as bonus FROM srv1_hunabku.hunter_player_missions WHERE player_id=" .. pid .. " AND assigned_date='" .. today .. "'")
                    if sc > 0 and sd[1] then
                        local bonus = math.floor((tonumber(sd[1].bonus) or 0) * 0.5)
                        if bonus > 0 then
                            mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET total_points = total_points + " .. bonus .. ", spendable_points = spendable_points + " .. bonus .. " WHERE player_id=" .. pid)
                            
                            local msg = hunter_level_bridge.get_text("mission_all_complete") or "TUTTE LE MISSIONI COMPLETE! BONUS x1.5!"
                            hunter_level_bridge.hunter_speak_color(msg, "GOLD")
                            cmdchat("HunterAllMissionsComplete " .. bonus)
                        end
                    end
                end
            end
        end
        
        function on_mob_kill(mob_vnum)
            hunter_level_bridge.update_mission_progress("kill_mob", 1, mob_vnum)
            hunter_level_bridge.update_mission_progress("kill_boss", 1, mob_vnum)
            hunter_level_bridge.update_mission_progress("kill_metin", 1, mob_vnum)
            hunter_level_bridge.update_mission_progress("speedkill", 1, mob_vnum)
        end
        
        function on_boss_kill(boss_vnum)
            hunter_level_bridge.update_mission_progress("kill_boss", 1, boss_vnum)
        end
        
        function on_metin_kill(metin_vnum)
            hunter_level_bridge.update_mission_progress("kill_metin", 1, metin_vnum)
        end
        
        function on_fracture_seal()
            hunter_level_bridge.update_mission_progress("seal_fracture", 1, 0)
        end
        
        function check_missions_reminder()
            local pid = pc.get_player_id()
            local today = hunter_level_bridge.get_today_date()
            local ts = get_time()
            local current_hour = hunter_level_bridge.get_hour_from_ts(ts)
            
            if current_hour < 22 then return end
            
            local last_reminder = pc.getqf("hq_last_reminder_hour") or 0
            if last_reminder == current_hour then return end
            
            local c, d = mysql_direct_query("SELECT COUNT(*) as total, SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) as completed FROM srv1_hunabku.hunter_player_missions WHERE player_id=" .. pid .. " AND assigned_date='" .. today .. "'")
            
            if c > 0 and d[1] then
                local total = tonumber(d[1].total) or 0
                local completed = tonumber(d[1].completed) or 0
                local incomplete = total - completed
                
                if incomplete > 0 and total >= 3 then
                    pc.setqf("hq_last_reminder_hour", current_hour)
                    local hours_left = 24 - current_hour
                    syschat("|cffFF4444========================================|r")
                    syschat("|cffFF0000  [ATTENZIONE]|r |cffFFFFFFHai " .. incomplete .. " missioni incomplete!|r")
                    syschat("|cffFFAA00  Reset tra " .. hours_left .. " ore|r |cffFF4444- Completa per evitare penalita'!|r")
                    syschat("|cffFF4444========================================|r")
                end
            end
        end
        
        function send_today_events(openWindow)
            local t = os.date("*t")
            local wday = t.wday - 1
            local day_db = wday
            if wday == 0 then day_db = 7 end
            
            local current_hour = t.hour
            local current_minute = t.min
            local current_total = current_hour * 60 + current_minute
            
            local q = "SELECT id, event_name, event_type, event_desc, start_hour, start_minute, duration_minutes, min_rank, reward_glory_base, reward_glory_winner, color_scheme FROM srv1_hunabku.hunter_scheduled_events WHERE enabled=1 AND FIND_IN_SET(" .. day_db .. ", days_active) > 0 ORDER BY start_hour, start_minute"
            local c, d = mysql_direct_query(q)
            local BATCH_SIZE = 5
            local events_sent = 0
            
            cmdchat("HunterEventsCount " .. c)
            
            if c > 0 then
                local batch = ""
                for i = 1, c do
                    local e = d[i]
                    local start_hour = tonumber(e.start_hour) or 0
                    local start_minute = tonumber(e.start_minute) or 0
                    local duration = tonumber(e.duration_minutes) or 30
                    local start_total = start_hour * 60 + start_minute
                    local end_total = start_total + duration
                    local end_hour = math.floor(end_total / 60)
                    local end_minute = end_total - end_hour * 60
                    if end_hour >= 24 then end_hour = end_hour - 24 end
                    
                    local status = "upcoming"
                    if current_total >= start_total and current_total < end_total then
                        status = "active"
                    elseif current_total >= end_total then
                        status = "ended"
                    end
                    
                    local start_time = hunter_level_bridge.format_time(start_hour, start_minute)
                    local end_time = hunter_level_bridge.format_time(end_hour, end_minute)
                    local reward_str = "+" .. (e.reward_glory_base or 50) .. "+Gloria"
                    
                    local pkt = tostring(tonumber(e.id) or 0) .. "~" ..
                        hunter_level_bridge.clean_str(e.event_name or "Evento") .. "~" ..
                        start_time .. "~" ..
                        end_time .. "~" ..
                        (e.event_type or "glory_rush") .. "~" ..
                        reward_str .. "~" ..
                        status .. "~" ..
                        (e.min_rank or "E")
                    
                    if batch ~= "" then batch = batch .. ";" end
                    batch = batch .. pkt
                    events_sent = events_sent + 1
                    
                    if events_sent >= BATCH_SIZE or i == c then
                        cmdchat("HunterEventBatch " .. batch)
                        batch = ""
                        events_sent = 0
                    end
                end
            end
            
            if openWindow then
                cmdchat("HunterEventsOpen")
            end
        end
        
        function check_active_event_notify()
            local event = hunter_level_bridge.get_current_scheduled_event()
            if event then
                local name = event.event_name or "Evento"
                local etype = event.event_type or "glory_rush"
                local desc = event.event_desc or ""
                local reward = tonumber(event.reward_glory_base) or 50
                local winner_reward = tonumber(event.reward_glory_winner) or 200
                local color = event.color_scheme or "GOLD"
                local duration = tonumber(event.duration_minutes) or 30
                
                local ts = get_time()
                local current_hour = hunter_level_bridge.get_hour_from_ts(ts)
                local current_minute = hunter_level_bridge.get_min_from_ts(ts)
                local current_total = current_hour * 60 + current_minute
                local start_total = tonumber(event.start_hour) * 60 + tonumber(event.start_minute)
                local end_total = start_total + duration
                local remaining = end_total - current_total
                
                pc.setqf("hq_event_reward", reward)
                pc.setqf("hq_event_remaining", remaining)
                pc.setqf("hq_event_winner", winner_reward)
                
                timer("hq_event_notify", 8)
                cmdchat("HunterEventStatus " .. hunter_level_bridge.clean_str(name) .. "|" .. remaining * 60 .. "|" .. etype)
            end
        end
        
        when hq_event_notify.timer begin
            local reward = pc.getqf("hq_event_reward") or 50
            local remaining = pc.getqf("hq_event_remaining") or 30
            local winner = pc.getqf("hq_event_winner") or 200
            
            syschat("|cffFFAA00========================================|r")
            syschat("|cffFFD700  [EVENTO IN CORSO]|r")
            syschat("|cff00FF00  Partecipa: +" .. reward .. " Gloria|r")
            syschat("|cffFFD700  Vinci: +" .. winner .. " Gloria!|r")
            syschat("|cffAAAAAA  Tempo rimanente: " .. remaining .. " minuti|r")
            syschat("|cffFFAA00========================================|r")
            hunter_level_bridge.hunter_speak_color("EVENTO ATTIVO! PARTECIPA ORA!", "GOLD")
        end
        
        function join_event(event_id)
            local pid = pc.get_player_id()
            local c, d = mysql_direct_query("SELECT event_name, event_type, reward_glory_base, reward_glory_winner, min_rank, color_scheme FROM srv1_hunabku.hunter_scheduled_events WHERE id=" .. event_id)
            if c == 0 then
                hunter_level_bridge.hunter_speak("Evento non trovato.")
                return
            end
            
            local event_name = d[1].event_name or "Evento"
            local event_type = d[1].event_type or "glory_rush"
            local glory_base = tonumber(d[1].reward_glory_base) or 50
            local glory_winner = tonumber(d[1].reward_glory_winner) or 200
            local min_rank = d[1].min_rank or "E"
            local color = d[1].color_scheme or "GOLD"
            
            local rc, rd = mysql_direct_query("SELECT total_points FROM srv1_hunabku.hunter_quest_ranking WHERE player_id=" .. pid)
            local pts = 0
            if rc > 0 and rd[1] then pts = tonumber(rd[1].total_points) or 0 end
            local player_rank_num = hunter_level_bridge.get_rank_index(pts)
            local required_rank_num = hunter_level_bridge.get_rank_index_by_letter(min_rank)
            
            if player_rank_num < required_rank_num then
                hunter_level_bridge.hunter_speak_color("Rank insufficiente! Richiesto: " .. min_rank .. "-Rank", "RED")
                return
            end
            
            mysql_direct_query("UPDATE srv1_hunabku.hunter_quest_ranking SET total_points = total_points + " .. glory_base .. ", spendable_points = spendable_points + " .. glory_base .. ", daily_points = daily_points + " .. glory_base .. ", weekly_points = weekly_points + " .. glory_base .. " WHERE player_id=" .. pid)
            
            local msg = "Partecipi a " .. event_name .. "! +" .. glory_base .. " Gloria"
            if event_type == "first_rift" or event_type == "first_boss" then
                msg = msg .. " (Se arrivi PRIMO: +" .. glory_winner .. "!)"
            elseif event_type == "glory_rush" then
                msg = msg .. " (Bonus Gloria ATTIVO!)"
            end
            
            hunter_level_bridge.hunter_speak_color(msg, color)
            cmdchat("HunterEventJoined " .. event_id .. "|" .. hunter_level_bridge.clean_str(event_name) .. "|" .. glory_base)
            
            hunter_level_bridge.send_player_data()
        end
        
        function get_rank_index_by_letter(letter)
            local ranks = {E = 0, D = 1, C = 2, B = 3, A = 4, S = 5, N = 6}
            return ranks[letter] or 0
        end
        
        when chat."/hunter_missions" begin
            hunter_level_bridge.assign_daily_missions()
            hunter_level_bridge.send_daily_missions()
            cmdchat("HunterMissionsOpen")
        end
        
        when chat."/hunter_events" begin
            hunter_level_bridge.send_today_events(true)
        end
        
        when chat."/hunter_events_silent" begin
            hunter_level_bridge.send_today_events(false)
        end
        
        when chat."/hunter_join_event" begin
            local event_id = tonumber(string.gsub(input, "/hunter_join_event ", "")) or 0
            if event_id > 0 then
                hunter_level_bridge.join_event(event_id)
            end
        end
        
    end
end
