--[[
================================================================================
HUNTER SYSTEM v2.0 - LUA CORE (FINAL FIX)
================================================================================
Fix: Sostituito pc.get_pid() con pc.get_player_id()
Fix: Gestione query che ritornano numeri
================================================================================
]]--

HUNTER = HUNTER or {}

-- ============================================================================
-- CONFIGURAZIONI E COSTANTI
-- ============================================================================

HUNTER.CONFIG = {
    MIN_LEVEL = 30,
    FLUSH_INTERVAL = 30,
    EMERGENCY_CHANCE = 40,
    EMERGENCY_THRESHOLD = 2000,
    EMERGENCY_DURATION = 180,
    SPEED_KILL_BOSS_SEC = 60,
    SPEED_KILL_METIN_SEC = 300,
    CREDITS_RATIO = 10,
}

HUNTER.RANK_COLORS = {
    E = "GREEN", D = "BLUE", C = "PURPLE", B = "ORANGE", A = "RED", S = "GOLD", N = "BLACKWHITE"
}

HUNTER.CACHE = {
    vnum_registry = {},
    config = {},
    player_data = {},
    active_events = {},
    speed_kills = {},
    emergencies = {},
    initialized = false
}

-- ============================================================================
-- HELPER DATABASE
-- ============================================================================

function HUNTER.Query(query)
    local ok, ret = pcall(function()
        return mysql_direct_query(query) 
    end)
    
    if not ok then
        syserr("HUNTER.Query Exception: " .. tostring(ret))
        return nil
    end

    -- Fix per query che ritornano numeri (es. 0 rows affected)
    if type(ret) == "number" then
        return nil
    end

    if type(ret) == "table" then
        return ret
    end

    return nil
end

function HUNTER.QuerySingle(query)
    local result = HUNTER.Query(query)
    if result and result[1] then
        return result[1]
    end
    return nil
end

function HUNTER.Escape(str)
    if str == nil then return "" end
    if mysql_escape_string then
        return mysql_escape_string(tostring(str))
    end
    return tostring(str):gsub("'", "''"):gsub("\\", "\\\\")
end

-- ============================================================================
-- INIZIALIZZAZIONE
-- ============================================================================

function HUNTER.Init()
    if HUNTER.CACHE.initialized then return end
    
    syschat("[HUNTER] Caricamento sistema...")
    HUNTER.LoadVnumRegistry()
    HUNTER.LoadConfig()
    HUNTER.CACHE.initialized = true
    
    if not game.get_event_flag("hunter_sys_loaded") then
        syschat("[HUNTER v2.0] Sistema inizializzato correttamente.")
        game.set_event_flag("hunter_sys_loaded", 1)
    end
end

function HUNTER.LoadVnumRegistry()
    local result = HUNTER.Query("SELECT vnum, vnum_type, base_points, rank_required, speed_kill_bonus, speed_kill_seconds, event_multiplier FROM hunter_vnum_registry")
    if result and result[1] then
        for _, row in ipairs(result) do
            HUNTER.CACHE.vnum_registry[tonumber(row.vnum)] = {
                vnum_type = row.vnum_type,
                base_points = tonumber(row.base_points) or 0,
                rank_required = row.rank_required or "E",
                speed_kill_bonus = tonumber(row.speed_kill_bonus) == 1,
                speed_kill_seconds = tonumber(row.speed_kill_seconds) or 0,
                event_multiplier = tonumber(row.event_multiplier) or 1.0
            }
        end
    end
end

function HUNTER.LoadConfig()
    local result = HUNTER.Query("SELECT config_key, config_value, config_type FROM hunter_config")
    if result and result[1] then
        for _, row in ipairs(result) do
            local val = row.config_value
            if row.config_type == "int" then val = tonumber(val) or 0
            elseif row.config_type == "float" then val = tonumber(val) or 0.0 end
            HUNTER.CONFIG[row.config_key] = val
        end
    end
end

-- ============================================================================
-- CORE: PROCESSO ATTIVITA'
-- ============================================================================

function HUNTER.ProcessActivity(pid, activity_type, vnum, amount, metadata)
    if not pid or pid == 0 then return 0 end
    
    local player_name = pc.get_name() or "Unknown"
    local meta_str = "NULL" 
    
    local query = string.format(
        "CALL sp_hunter_activity(%d, '%s', '%s', %d, %d, %s)",
        pid, HUNTER.Escape(player_name), activity_type, 
        vnum or 0, amount or 0, meta_str
    )
    
    local result = HUNTER.QuerySingle(query)
    
    if result then
        local glory = tonumber(result.glory_earned) or 0
        if glory > 0 then
            HUNTER.NotifyGlory(glory, activity_type)
        end
        return glory
    end
    return 0
end

-- ============================================================================
-- KILL HANDLER
-- ============================================================================

function HUNTER.OnKill(pid, victim_vnum)
    if not pid or pid == 0 or not HUNTER.CACHE.initialized then return end
    if pc.get_level() < (HUNTER.CONFIG.MIN_LEVEL or 30) then return end
    
    local vnum_data = HUNTER.CACHE.vnum_registry[victim_vnum]
    
    if not vnum_data then
        return
    end
    
    local activity_type = "kill_mob"
    if vnum_data.vnum_type == "boss" or vnum_data.vnum_type == "super_boss" then
        activity_type = "kill_boss"
        HUNTER.CheckSpeedKill(pid, victim_vnum, "boss")
    elseif vnum_data.vnum_type == "metin" or vnum_data.vnum_type == "super_metin" then
        activity_type = "kill_metin"
        HUNTER.CheckSpeedKill(pid, victim_vnum, "metin")
    end
    
    local speed_bonus = HUNTER.IsSpeedKillActive(pid) and 1 or 0
    HUNTER.ProcessActivity(pid, activity_type, victim_vnum, speed_bonus, nil)
    HUNTER.CheckEmergency(pid)
    
    HUNTER.UpdateMissionProgress(pid, activity_type, victim_vnum, 1)
end

function HUNTER.UpdateMissionProgress(pid, type, vnum, amount)
    local query = string.format("CALL sp_hunter_update_mission(%d, '%s', %d, %d)", pid, type, vnum, amount)
    local result = HUNTER.Query(query)
    
    if result and result[1] then
        for _, row in ipairs(result) do
            if row.status == "completed" then
                cmdchat("HunterMissionUpdate " .. row.mission_id .. "|COMPLETED")
                syschat("Missione completata: " .. row.mission_name)
            else
                cmdchat("HunterMissionUpdate " .. row.mission_id .. "|" .. row.current_progress .. "|" .. row.target_count)
            end
        end
    end
end

-- ============================================================================
-- SPEED KILL
-- ============================================================================

function HUNTER.CheckSpeedKill(pid, vnum, mob_type)
    local vnum_data = HUNTER.CACHE.vnum_registry[vnum]
    if not vnum_data or not vnum_data.speed_kill_bonus then return end
    
    local duration = (mob_type == "boss" and HUNTER.CONFIG.SPEED_KILL_BOSS_SEC or HUNTER.CONFIG.SPEED_KILL_METIN_SEC) or 60
    
    HUNTER.CACHE.speed_kills[pid] = {
        start_time = get_time(),
        duration = duration
    }
    
    cmdchat("HunterSpeedKillStart " .. mob_type .. "|" .. duration .. "|" .. HUNTER.GetRankColor(pid))
end

function HUNTER.IsSpeedKillActive(pid)
    local sk = HUNTER.CACHE.speed_kills[pid]
    if not sk then return false end
    
    local elapsed = get_time() - sk.start_time
    HUNTER.CACHE.speed_kills[pid] = nil 
    
    if elapsed <= sk.duration then
        cmdchat("HunterSpeedKillEnd 1") 
        return true
    else
        cmdchat("HunterSpeedKillEnd 0") 
        return false
    end
end

-- ============================================================================
-- EMERGENCY QUEST
-- ============================================================================

function HUNTER.CheckEmergency(pid)
    if HUNTER.CACHE.emergencies[pid] then return end
    
    local data = HUNTER.GetPlayerData(pid)
    if not data then return end
    
    local daily_kills = tonumber(data.daily_kills) or 0
    if daily_kills < (HUNTER.CONFIG.EMERGENCY_THRESHOLD or 2000) then return end
    if math.random(100) > (HUNTER.CONFIG.EMERGENCY_CHANCE or 40) then return end
    
    HUNTER.StartEmergency(pid)
end

function HUNTER.StartEmergency(pid)
    local mobs = {}
    local mob_count = 0 
    for vnum, data in pairs(HUNTER.CACHE.vnum_registry) do
        if data.vnum_type == "mob" and data.base_points >= 5 then
            mob_count = mob_count + 1
            mobs[mob_count] = vnum
        end
    end
    if mob_count == 0 then return end
    
    local target_vnum = mobs[math.random(mob_count)]
    local target_count = math.random(10, 30)
    local duration = (HUNTER.CONFIG.EMERGENCY_DURATION or 180)
    
    HUNTER.CACHE.emergencies[pid] = {
        vnum = target_vnum, required = target_count, current = 0,
        start_time = get_time(), duration = duration
    }
    
    cmdchat("HunterEmergency Emergenza!|" .. duration .. "|" .. target_vnum .. "|" .. target_count)
end

function HUNTER.UpdateEmergency(pid, vnum)
    local em = HUNTER.CACHE.emergencies[pid]
    if not em or em.vnum ~= vnum then return end
    
    local elapsed = get_time() - em.start_time
    if elapsed > em.duration then
        HUNTER.CACHE.emergencies[pid] = nil
        cmdchat("HunterEmergencyClose FAIL")
        return
    end
    
    em.current = em.current + 1
    cmdchat("HunterEmergencyUpdate " .. em.current)
    
    if em.current >= em.required then
        local bonus = em.required * 10
        HUNTER.ProcessActivity(pid, "emergency_complete", vnum, bonus, nil)
        HUNTER.CACHE.emergencies[pid] = nil
        cmdchat("HunterEmergencyClose SUCCESS")
    end
end

-- ============================================================================
-- GESTIONE DATI GIOCATORE
-- ============================================================================

function HUNTER.GetPlayerData(pid)
    return HUNTER.QuerySingle("CALL sp_hunter_get_player(" .. pid .. ")")
end

function HUNTER.GetRankColor(pid)
    local data = HUNTER.GetPlayerData(pid)
    if data and data.current_rank then return HUNTER.RANK_COLORS[data.current_rank] or "GREEN" end
    return "GREEN"
end

function HUNTER.CompareRanks(rank1, rank2)
    local order = {E=1, D=2, C=3, B=4, A=5, S=6, N=7}
    return (order[rank1] or 0) - (order[rank2] or 0)
end

function HUNTER.NotifyGlory(glory, source)
    -- [[ FIX: Sostituito pc.get_pid() con pc.get_player_id() ]]
    local color = HUNTER.GetRankColor(pc.get_player_id())
    cmdchat("HunterSystemSpeak " .. color .. "|+" .. glory .. " Gloria (" .. source:gsub("_", " ") .. ")")
end

-- ============================================================================
-- INVIO DATI AL CLIENT
-- ============================================================================

function HUNTER.SendPlayerData(pid)
    local data = HUNTER.GetPlayerData(pid)
    if not data then return end
    
    local str = string.format("%s|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d",
        data.player_name or "Unknown",
        tonumber(data.total_glory) or 0,
        tonumber(data.spendable_credits) or 0,
        tonumber(data.daily_glory) or 0,
        tonumber(data.weekly_glory) or 0,
        tonumber(data.total_kills) or 0,
        tonumber(data.daily_kills) or 0,
        tonumber(data.weekly_kills) or 0,
        tonumber(data.login_streak) or 0,
        tonumber(data.total_bosses) or 0,
        tonumber(data.total_fractures) or 0,
        tonumber(data.total_chests) or 0,
        tonumber(data.total_metins) or 0,
        tonumber(data.daily_position) or 0,
        tonumber(data.weekly_position) or 0
    )
    cmdchat("HunterPlayerData " .. str)
end

function HUNTER.SendRanking(pid, ranking_type)
    local result = HUNTER.Query("CALL sp_hunter_get_ranking('" .. ranking_type .. "', 20)")
    
    if result and result[1] then
        local entries = {}
        for _, row in ipairs(result) do
            table.insert(entries, string.format("%s,%d,%d", row.player_name, row.glory, row.kills))
        end
        local cmd_name = "HunterRanking" .. ranking_type:sub(1,1):upper() .. ranking_type:sub(2)
        cmdchat(cmd_name .. " " .. table.concat(entries, ";"))
    else
        local cmd_name = "HunterRanking" .. ranking_type:sub(1,1):upper() .. ranking_type:sub(2)
        cmdchat(cmd_name .. " EMPTY")
    end
end

-- ============================================================================
-- LOGIN / LOGOUT / FLUSH
-- ============================================================================

function HUNTER.OnLogin(pid)
    HUNTER.Init()
    if pc.get_level() < (HUNTER.CONFIG.MIN_LEVEL or 30) then return end
    
    HUNTER.ProcessActivity(pid, "login_bonus", 0, 0, nil)
    HUNTER.SendPlayerData(pid)
    
    local data = HUNTER.GetPlayerData(pid)
    if data then
        cmdchat("HunterWelcome " .. (data.current_rank or "E") .. "|" .. (data.player_name or "Hunter") .. "|" .. (data.total_glory or 0))
    end
    
    HUNTER.GetMissions(pid)
end

function HUNTER.OnLogout(pid)
    HUNTER.Query("CALL sp_hunter_flush_pending()")
    HUNTER.CACHE.player_data[pid] = nil
    HUNTER.CACHE.speed_kills[pid] = nil
    HUNTER.CACHE.emergencies[pid] = nil
end

function HUNTER.OnFlushTimer()
    HUNTER.Query("CALL sp_hunter_flush_pending()")
end

-- ============================================================================
-- GESTIONE MISSIONI, PROVE, GATE, SHOP
-- ============================================================================

function HUNTER.GetMissions(pid)
    local result = HUNTER.Query("CALL sp_hunter_assign_missions(" .. pid .. ")")
    return result or {}
end

function HUNTER.StartTrial(pid)
    local result = HUNTER.QuerySingle("CALL sp_hunter_start_trial(" .. pid .. ")")
    
    if result and result.trial_id then
        cmdchat("HunterTrialStart " .. result.trial_id .. "|" .. (result.trial_name or "Trial") .. "|" .. (result.to_rank or "D") .. "|" .. (result.color_code or "BLUE"))
        syschat("Prova di Rango iniziata: " .. (result.trial_name or "Trial"))
        return true
    else
        syschat("Nessuna Prova di Rango disponibile o requisiti non soddisfatti.")
        return false
    end
end

function HUNTER.EnterGate(pid, gate_id)
    local gate = HUNTER.QuerySingle("SELECT * FROM hunter_gates WHERE gate_id = " .. gate_id)
    if not gate then return false end
    
    local data = HUNTER.GetPlayerData(pid)
    if not data then return false end
    
    if HUNTER.CompareRanks(data.current_rank, gate.min_rank) < 0 then
        syschat("Rank insufficiente per questo Gate!")
        return false
    end
    
    HUNTER.ProcessActivity(pid, "enter_gate", gate_id, tonumber(gate.duration_minutes), nil)
    cmdchat("HunterGateEntry " .. (gate.gate_name or "Gate") .. "|" .. (gate.color_code or "RED"))
    
    return true
end

function HUNTER.ShopBuy(pid, item_id)
    local item = HUNTER.QuerySingle("SELECT * FROM hunter_shop WHERE item_id = " .. item_id .. " AND is_active = 1")
    if not item then
        syschat("Oggetto non disponibile!")
        return
    end
    
    local data = HUNTER.GetPlayerData(pid)
    if not data or tonumber(data.spendable_credits) < tonumber(item.price_credits) then
        syschat("Crediti insufficienti!")
        return
    end
    
    if HUNTER.CompareRanks(data.current_rank, item.min_rank or "E") < 0 then
        syschat("Rank insufficiente per acquistare questo oggetto!")
        return
    end
    
    HUNTER.ProcessActivity(pid, "shop_purchase", tonumber(item.item_vnum), tonumber(item.price_credits), nil)
    pc.give_item2(tonumber(item.item_vnum), tonumber(item.item_count))
    syschat("Acquisto completato con successo!")
    HUNTER.SendPlayerData(pid) 
end