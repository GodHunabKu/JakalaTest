# -*- coding: utf-8 -*-
"""
================================================================================
HUNTER SYSTEM v2.0 - MODULO PYTHON CLIENT
================================================================================
Gestisce comunicazione Server->Client per Hunter System v2.0
Compatibile con uihunterlevel.py esistente
================================================================================
"""

import app
import net
import chat
import player
import chr
import constInfo
import localeInfo

# ============================================================================
# COSTANTI
# ============================================================================

RANK_COLORS = {
    "E": "GREEN",
    "D": "BLUE",
    "C": "PURPLE", 
    "B": "ORANGE",
    "A": "RED",
    "S": "GOLD",
    "N": "BLACKWHITE"
}

RANK_COLOR_CODES = {
    "GREEN": 0xFF00FF00,
    "BLUE": 0xFF0080FF,
    "PURPLE": 0xFFAA00FF,
    "ORANGE": 0xFFFF8000,
    "RED": 0xFFFF0000,
    "GOLD": 0xFFFFD700,
    "BLACKWHITE": 0xFFFFFFFF,
    "WHITE": 0xFFFFFFFF,
}

RANK_THRESHOLDS = [
    ("N", 1500000),
    ("S", 500000),
    ("A", 150000),
    ("B", 50000),
    ("C", 10000),
    ("D", 2000),
    ("E", 0),
]

# ============================================================================
# DATI PLAYER
# ============================================================================

class HunterPlayerData:
    """Contiene tutti i dati Hunter del player locale"""
    
    def __init__(self):
        self.Reset()
    
    def Reset(self):
        # Gloria
        self.name = ""
        self.total_glory = 0
        self.daily_glory = 0
        self.weekly_glory = 0
        self.spendable_credits = 0
        
        # Kills
        self.total_kills = 0
        self.daily_kills = 0
        self.weekly_kills = 0
        
        # Stats
        self.login_streak = 0
        self.streak_bonus = 0
        self.total_fractures = 0
        self.total_chests = 0
        self.total_metins = 0
        self.total_bosses = 0
        
        # Rank
        self.current_rank = "E"
        
        # Posizioni classifica
        self.daily_position = 0
        self.weekly_position = 0
        self.total_position = 0
        
        # Trial
        self.trial_id = 0
        self.trial_name = ""
        self.trial_to_rank = ""
        self.trial_progress = {}
        self.trial_requirements = {}
        self.trial_expires = 0
        
        # Gate
        self.gate_id = 0
        self.gate_name = ""
        self.gate_expires = 0
        
        # Missioni
        self.missions = []
        
        # Events
        self.active_event = None
        self.event_multiplier = 1.0
        
        # UI State
        self.is_loaded = False

# Istanza globale
g_playerData = HunterPlayerData()

# ============================================================================
# FUNZIONI UTILITA'
# ============================================================================

def GetRankColor(rank):
    """Ritorna colore esadecimale per rank"""
    color_name = RANK_COLORS.get(rank, "GREEN")
    return RANK_COLOR_CODES.get(color_name, 0xFFFFFFFF)

def GetRankColorName(rank):
    """Ritorna nome colore per rank"""
    return RANK_COLORS.get(rank, "GREEN")

def GetRankFromGlory(glory):
    """Calcola rank basato su gloria totale"""
    for rank, threshold in RANK_THRESHOLDS:
        if glory >= threshold:
            return rank
    return "E"

def GetNextRankThreshold(current_rank):
    """Ritorna soglia per prossimo rank"""
    for i, (rank, threshold) in enumerate(RANK_THRESHOLDS):
        if rank == current_rank and i > 0:
            return RANK_THRESHOLDS[i-1][1]
    return 0

def GetStreakBonus(streak):
    """Calcola bonus percentuale per login streak"""
    if streak >= 30:
        return 20
    elif streak >= 14:
        return 15
    elif streak >= 7:
        return 10
    elif streak >= 3:
        return 5
    return 0

def FormatGlory(glory):
    """Formatta gloria con separatori migliaia"""
    return "{:,}".format(glory).replace(",", ".")

# ============================================================================
# PARSER COMANDI SERVER
# ============================================================================

def ParseHunterCommand(cmd, args):
    """
    Parser principale per comandi Hunter dal server.
    Chiamato da game.py quando riceve cmdchat con prefisso 'Hunter'
    """
    global g_playerData
    
    if cmd == "HunterPlayerData":
        _ParsePlayerData(args)
    
    elif cmd == "HunterWelcome":
        _ParseWelcome(args)
    
    elif cmd == "HunterSystemSpeak":
        _ParseSystemSpeak(args)
    
    elif cmd == "HunterSysMsg":
        _ParseSysMsg(args)
    
    elif cmd == "HunterRankingDaily":
        _ParseRanking(args, "daily")
    
    elif cmd == "HunterRankingWeekly":
        _ParseRanking(args, "weekly")
    
    elif cmd == "HunterRankingTotal":
        _ParseRanking(args, "total")
    
    elif cmd == "HunterMissionData":
        _ParseMissionData(args)
    
    elif cmd == "HunterMissionProgress":
        _ParseMissionProgress(args)
    
    elif cmd == "HunterMissionComplete":
        _ParseMissionComplete(args)
    
    elif cmd == "HunterTrialStart":
        _ParseTrialStart(args)
    
    elif cmd == "HunterTrialComplete":
        _ParseTrialComplete(args)
    
    elif cmd == "HunterRankUp":
        _ParseRankUp(args)
    
    elif cmd == "HunterGateEntry":
        _ParseGateEntry(args)
    
    elif cmd == "HunterGateVictory":
        _ParseGateVictory(args)
    
    elif cmd == "HunterGateDefeat":
        _ParseGateDefeat(args)
    
    elif cmd == "HunterSpeedKillStart":
        _ParseSpeedKillStart(args)
    
    elif cmd == "HunterSpeedKillEnd":
        _ParseSpeedKillEnd(args)
    
    elif cmd == "HunterEmergency":
        _ParseEmergency(args)
    
    elif cmd == "HunterEmergencyUpdate":
        _ParseEmergencyUpdate(args)
    
    elif cmd == "HunterEmergencyClose":
        _ParseEmergencyClose(args)
    
    elif cmd == "HunterShopItems":
        _ParseShopItems(args)
    
    elif cmd == "HunterEventActive":
        _ParseEventActive(args)

# ============================================================================
# PARSER SPECIFICI
# ============================================================================

def _ParsePlayerData(args):
    """
    Formato: name|total|spendable|daily|weekly|totalkills|dailykills|weeklykills|
             streak|bonus|fractures|chests|metins|pendingDaily|pendingWeekly|dailyPos|weeklyPos
    """
    global g_playerData
    
    parts = args.split("|")
    if len(parts) < 17:
        return
    
    g_playerData.name = parts[0]
    g_playerData.total_glory = int(parts[1])
    g_playerData.spendable_credits = int(parts[2])
    g_playerData.daily_glory = int(parts[3])
    g_playerData.weekly_glory = int(parts[4])
    g_playerData.total_kills = int(parts[5])
    g_playerData.daily_kills = int(parts[6])
    g_playerData.weekly_kills = int(parts[7])
    g_playerData.login_streak = int(parts[8])
    g_playerData.streak_bonus = int(parts[9])
    g_playerData.total_fractures = int(parts[10])
    g_playerData.total_chests = int(parts[11])
    g_playerData.total_metins = int(parts[12])
    # parts[13], parts[14] = pending (non usati client-side)
    g_playerData.daily_position = int(parts[15])
    g_playerData.weekly_position = int(parts[16])
    
    # Calcola rank
    g_playerData.current_rank = GetRankFromGlory(g_playerData.total_glory)
    g_playerData.streak_bonus = GetStreakBonus(g_playerData.login_streak)
    
    g_playerData.is_loaded = True
    
    # Notifica UI
    _NotifyUIUpdate("player_data")

def _ParseWelcome(args):
    """Formato: rank|name|glory"""
    parts = args.split("|")
    if len(parts) < 3:
        return
    
    rank = parts[0]
    name = parts[1]
    glory = parts[2]
    
    color = GetRankColor(rank)
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[Hunter] Bentornato %s-Rank %s! Gloria: %s" % (rank, name, FormatGlory(int(glory))))

def _ParseSystemSpeak(args):
    """Formato: color|message"""
    parts = args.split("|", 1)
    if len(parts) < 2:
        return
    
    color_name = parts[0]
    message = parts[1]
    
    color = RANK_COLOR_CODES.get(color_name, 0xFFFFFFFF)
    
    # Mostra notifica flottante
    _ShowFloatingNotification(message, color)

def _ParseSysMsg(args):
    """Formato: message|color"""
    parts = args.split("|")
    message = parts[0].replace("+", " ")
    color_name = parts[1] if len(parts) > 1 else "WHITE"
    
    color = RANK_COLOR_CODES.get(color_name, 0xFFFFFFFF)
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[Hunter] " + message)

def _ParseRanking(args, ranking_type):
    """Formato: name,glory,kills;name,glory,kills;..."""
    global g_rankingData
    
    if args == "EMPTY":
        g_rankingData[ranking_type] = []
        _NotifyUIUpdate("ranking_" + ranking_type)
        return
    
    entries = []
    for entry in args.split(";"):
        parts = entry.split(",")
        if len(parts) >= 3:
            entries.append({
                "name": parts[0],
                "glory": int(parts[1]),
                "kills": int(parts[2])
            })
    
    g_rankingData[ranking_type] = entries
    _NotifyUIUpdate("ranking_" + ranking_type)

def _ParseMissionData(args):
    """Formato: slot|name|type|progress|target|reward|penalty|status"""
    global g_playerData
    
    parts = args.split("|")
    if len(parts) < 8:
        return
    
    mission = {
        "slot": int(parts[0]),
        "name": parts[1],
        "type": parts[2],
        "progress": int(parts[3]),
        "target": int(parts[4]),
        "reward": int(parts[5]),
        "penalty": int(parts[6]),
        "status": parts[7]
    }
    
    # Aggiorna o aggiungi
    found = False
    for i, m in enumerate(g_playerData.missions):
        if m["slot"] == mission["slot"]:
            g_playerData.missions[i] = mission
            found = True
            break
    
    if not found:
        g_playerData.missions.append(mission)
    
    g_playerData.missions.sort(key=lambda x: x["slot"])
    _NotifyUIUpdate("missions")

def _ParseMissionProgress(args):
    """Formato: mission_id|current|target"""
    parts = args.split("|")
    if len(parts) < 3:
        return
    
    mission_id = int(parts[0])
    current = int(parts[1])
    target = int(parts[2])
    
    # Trova e aggiorna missione
    for m in g_playerData.missions:
        if m.get("mission_id") == mission_id or m["slot"] == mission_id:
            m["progress"] = current
            break
    
    _NotifyUIUpdate("mission_progress")

def _ParseMissionComplete(args):
    """Formato: mission_id|name|reward"""
    parts = args.split("|")
    if len(parts) < 3:
        return
    
    name = parts[1]
    reward = int(parts[2])
    
    # Notifica
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[Hunter] Missione completata: %s (+%d Gloria)" % (name, reward))
    _ShowFloatingNotification("Missione Completata! +%d Gloria" % reward, 0xFFFFD700)
    
    _NotifyUIUpdate("mission_complete")

def _ParseTrialStart(args):
    """Formato: trial_id|name|to_rank|color"""
    global g_playerData
    
    parts = args.split("|")
    if len(parts) < 4:
        return
    
    g_playerData.trial_id = int(parts[0])
    g_playerData.trial_name = parts[1]
    g_playerData.trial_to_rank = parts[2]
    
    color = RANK_COLOR_CODES.get(parts[3], 0xFFFFFFFF)
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[Hunter] Prova iniziata: %s" % parts[1])
    
    _NotifyUIUpdate("trial_start")

def _ParseTrialComplete(args):
    """Formato: new_rank|reward|trial_name"""
    parts = args.split("|")
    if len(parts) < 3:
        return
    
    new_rank = parts[0]
    reward = int(parts[1])
    trial_name = parts[2]
    
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[Hunter] PROVA COMPLETATA: %s! Nuovo Rank: %s (+%d Gloria)" % (trial_name, new_rank, reward))
    _ShowFloatingNotification("RANK UP! %s-Rank" % new_rank, GetRankColor(new_rank))
    
    g_playerData.trial_id = 0
    g_playerData.current_rank = new_rank
    
    _NotifyUIUpdate("trial_complete")

def _ParseRankUp(args):
    """Formato: old_rank|new_rank"""
    parts = args.split("|")
    if len(parts) < 2:
        return
    
    old_rank = parts[0]
    new_rank = parts[1]
    
    g_playerData.current_rank = new_rank
    
    # Effetto speciale
    _PlayRankUpEffect(new_rank)
    _NotifyUIUpdate("rank_up")

def _ParseGateEntry(args):
    """Formato: gate_name|color"""
    parts = args.split("|")
    if len(parts) < 2:
        return
    
    gate_name = parts[0]
    color = RANK_COLOR_CODES.get(parts[1], 0xFFFF0000)
    
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[Hunter] Entrato nel Gate: %s" % gate_name)
    _NotifyUIUpdate("gate_entry")

def _ParseGateVictory(args):
    """Formato: gate_name|reward"""
    parts = args.split("|")
    if len(parts) < 2:
        return
    
    gate_name = parts[0]
    reward = int(parts[1])
    
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[Hunter] GATE COMPLETATO: %s (+%d Gloria)" % (gate_name, reward))
    _ShowFloatingNotification("GATE COMPLETATO! +%d Gloria" % reward, 0xFFFFD700)
    
    g_playerData.gate_id = 0
    _NotifyUIUpdate("gate_victory")

def _ParseGateDefeat(args):
    """Formato: penalty"""
    penalty = int(args)
    
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[Hunter] Gate fallito! (-%d Gloria)" % penalty)
    _ShowFloatingNotification("GATE FALLITO! -%d Gloria" % penalty, 0xFFFF0000)
    
    g_playerData.gate_id = 0
    _NotifyUIUpdate("gate_defeat")

def _ParseSpeedKillStart(args):
    """Formato: mob_type|duration|color"""
    parts = args.split("|")
    if len(parts) < 3:
        return
    
    mob_type = parts[0]
    duration = int(parts[1])
    color = parts[2]
    
    # Avvia timer UI speed kill
    _StartSpeedKillTimer(mob_type, duration, color)
    _NotifyUIUpdate("speed_kill_start")

def _ParseSpeedKillEnd(args):
    """Formato: success (1/0)"""
    success = args == "1"
    
    if success:
        _ShowFloatingNotification("SPEED KILL! Gloria x2!", 0xFFFFD700)
    
    _StopSpeedKillTimer()
    _NotifyUIUpdate("speed_kill_end")

def _ParseEmergency(args):
    """Formato: title|duration|vnum|count"""
    parts = args.split("|")
    if len(parts) < 4:
        return
    
    title = parts[0]
    duration = int(parts[1])
    vnum = int(parts[2])
    count = int(parts[3])
    
    # Mostra UI Emergency
    _ShowEmergencyQuest(title, duration, vnum, count)
    _NotifyUIUpdate("emergency_start")

def _ParseEmergencyUpdate(args):
    """Formato: current_count"""
    current = int(args)
    _UpdateEmergencyProgress(current)

def _ParseEmergencyClose(args):
    """Formato: SUCCESS/FAIL"""
    success = args == "SUCCESS"
    _CloseEmergencyQuest(success)
    _NotifyUIUpdate("emergency_end")

def _ParseShopItems(args):
    """Formato: id,vnum,count,price,name;..."""
    global g_shopItems
    
    g_shopItems = []
    for entry in args.split(";"):
        parts = entry.split(",")
        if len(parts) >= 5:
            g_shopItems.append({
                "id": int(parts[0]),
                "vnum": int(parts[1]),
                "count": int(parts[2]),
                "price": int(parts[3]),
                "name": parts[4]
            })
    
    _NotifyUIUpdate("shop_items")

def _ParseEventActive(args):
    """Formato: event_name|multiplier|color|minutes_remaining"""
    global g_playerData
    
    parts = args.split("|")
    if len(parts) < 4:
        return
    
    g_playerData.active_event = {
        "name": parts[0],
        "multiplier": float(parts[1]),
        "color": parts[2],
        "remaining": int(parts[3])
    }
    g_playerData.event_multiplier = float(parts[1])
    
    _NotifyUIUpdate("event_active")

# ============================================================================
# RICHIESTE AL SERVER
# ============================================================================

def RequestPlayerData():
    """Richiede dati player aggiornati"""
    net.SendChatPacket("/hunter_data")

def RequestRanking(ranking_type="daily"):
    """Richiede classifica (daily/weekly/total)"""
    net.SendChatPacket("/hunter_ranking " + ranking_type)

def RequestMissions():
    """Richiede missioni giornaliere"""
    net.SendChatPacket("/hunter_missions")

def RequestStartTrial():
    """Richiede inizio prova di rango"""
    net.SendChatPacket("/hunter_trial_start")

def RequestEnterGate(gate_id):
    """Richiede entrata in Gate"""
    net.SendChatPacket("/hunter_gate " + str(gate_id))

def RequestConvertCredits(amount):
    """Richiede conversione gloria->crediti"""
    net.SendChatPacket("/hunter_convert " + str(amount))

def RequestShopItems():
    """Richiede lista shop"""
    net.SendChatPacket("/hunter_shop")

def RequestBuyItem(item_id):
    """Richiede acquisto item"""
    net.SendChatPacket("/hunter_buy " + str(item_id))

# ============================================================================
# UI HELPERS
# ============================================================================

# Callbacks UI registrati
g_uiCallbacks = {}
g_rankingData = {"daily": [], "weekly": [], "total": []}
g_shopItems = []
g_speedKillTimer = None
g_emergencyData = None

def RegisterUICallback(event_type, callback):
    """Registra callback per aggiornamenti UI"""
    if event_type not in g_uiCallbacks:
        g_uiCallbacks[event_type] = []
    g_uiCallbacks[event_type].append(callback)

def _NotifyUIUpdate(event_type):
    """Notifica tutte le UI registrate"""
    if event_type in g_uiCallbacks:
        for callback in g_uiCallbacks[event_type]:
            try:
                callback()
            except:
                pass

def _ShowFloatingNotification(text, color):
    """Mostra notifica flottante sopra personaggio"""
    try:
        # Usa sistema chat flottante se disponibile
        import uiChat
        if hasattr(uiChat, "AppendChatWithColor"):
            uiChat.AppendChatWithColor(chat.CHAT_TYPE_INFO, text, color)
    except:
        chat.AppendChat(chat.CHAT_TYPE_INFO, text)

def _PlayRankUpEffect(new_rank):
    """Riproduce effetto rank up"""
    try:
        # Effetto particellare
        vid = player.GetMainCharacterIndex()
        if new_rank in ("S", "N"):
            chr.AttachEffect(vid, "d:/ymir work/effect/etc/levelup/level_up.mse")
    except:
        pass

def _StartSpeedKillTimer(mob_type, duration, color):
    """Avvia timer UI speed kill"""
    global g_speedKillTimer
    g_speedKillTimer = {
        "mob_type": mob_type,
        "duration": duration,
        "color": color,
        "start": app.GetTime()
    }

def _StopSpeedKillTimer():
    """Ferma timer speed kill"""
    global g_speedKillTimer
    g_speedKillTimer = None

def _ShowEmergencyQuest(title, duration, vnum, count):
    """Mostra UI Emergency Quest"""
    global g_emergencyData
    g_emergencyData = {
        "title": title,
        "duration": duration,
        "vnum": vnum,
        "required": count,
        "current": 0,
        "start": app.GetTime()
    }

def _UpdateEmergencyProgress(current):
    """Aggiorna progresso Emergency"""
    global g_emergencyData
    if g_emergencyData:
        g_emergencyData["current"] = current

def _CloseEmergencyQuest(success):
    """Chiude Emergency Quest"""
    global g_emergencyData
    g_emergencyData = None

# ============================================================================
# GETTER PER UI
# ============================================================================

def GetPlayerData():
    """Ritorna dati player correnti"""
    return g_playerData

def GetRankingData(ranking_type):
    """Ritorna dati classifica"""
    return g_rankingData.get(ranking_type, [])

def GetShopItems():
    """Ritorna lista shop"""
    return g_shopItems

def GetSpeedKillTimer():
    """Ritorna stato timer speed kill"""
    return g_speedKillTimer

def GetEmergencyData():
    """Ritorna stato emergency quest"""
    return g_emergencyData

def IsHunterSystemLoaded():
    """Verifica se dati hunter sono caricati"""
    return g_playerData.is_loaded

# ============================================================================
# INIZIALIZZAZIONE
# ============================================================================

def Initialize():
    """Inizializza modulo Hunter"""
    global g_playerData, g_rankingData, g_shopItems
    g_playerData = HunterPlayerData()
    g_rankingData = {"daily": [], "weekly": [], "total": []}
    g_shopItems = []

# Auto-init
Initialize()

# ============================================================================
# FINE MODULO HUNTER v2.0
# ============================================================================
