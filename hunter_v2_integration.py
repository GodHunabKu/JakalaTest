# -*- coding: utf-8 -*-
"""
================================================================================
HUNTER SYSTEM v2.0 - INTEGRAZIONE GAME.PY
================================================================================
File da importare in game.py per aggiungere i nuovi handler v2.0
Compatibile con il sistema esistente (hunterlevel.py/uihunterlevel.py)

ISTRUZIONI:
1. Aggiungi in game.py nella sezione imports:
   import hunter_v2_integration
   
2. In GameWindow.__ServerCommand_Build(), aggiungi DOPO gli altri handler Hunter:
   hunter_v2_integration.RegisterV2Commands(serverCommandList, self)
   
3. In interfaceModule.py, aggiungi metodo per forward al nuovo sistema:
   def ProcessHunterV2Command(self, cmd, args):
       import hunterlevel_v2
       hunterlevel_v2.ParseHunterCommand(cmd, args)
================================================================================
"""

import hunterlevel_v2

def RegisterV2Commands(serverCommandList, gameInstance):
    """
    Registra i nuovi comandi Hunter v2.0 nel sistema di comandi server.
    I comandi v2.0 usano il nuovo modulo hunterlevel_v2.py.
    """
    
    # =========================================================================
    # COMANDI V2.0 - Mappati al nuovo parser unificato
    # =========================================================================
    
    v2_commands = [
        # Dati Player
        "HunterPlayerData",
        "HunterWelcome",
        
        # Sistema Messaggi
        "HunterSystemSpeak",
        "HunterSysMsg",
        
        # Classifiche
        "HunterRankingDaily",
        "HunterRankingWeekly", 
        "HunterRankingTotal",
        
        # Missioni
        "HunterMissionData",
        "HunterMissionProgress",
        "HunterMissionComplete",
        
        # Trial
        "HunterTrialStart",
        "HunterTrialComplete",
        
        # Rank
        "HunterRankUp",
        
        # Gate
        "HunterGateEntry",
        "HunterGateVictory",
        "HunterGateDefeat",
        
        # Speed Kill
        "HunterSpeedKillStart",
        "HunterSpeedKillEnd",
        
        # Emergency Quest
        "HunterEmergency",
        "HunterEmergencyUpdate",
        "HunterEmergencyClose",
        
        # Shop
        "HunterShopItems",
        
        # Eventi
        "HunterEventActive",

        # UI
        "HunterOpenUI",
    ]
    
    # Registra ogni comando per usare il parser unificato v2.0
    for cmd in v2_commands:
        # Crea handler che chiama il parser v2.0
        handler = _create_v2_handler(cmd)
        
        # Solo se non già registrato (priorità al sistema v1)
        if cmd not in serverCommandList:
            serverCommandList[cmd] = handler

def _create_v2_handler(cmd_name):
    """Crea un handler che forwarda al parser v2.0"""
    def handler(args):
        hunterlevel_v2.ParseHunterCommand(cmd_name, args)
    return handler


# ============================================================================
# FUNZIONI DI UTILITA' PER INTERFACE MODULE
# ============================================================================

def ForwardToHunterV2(cmd, args):
    """
    Chiamare questo metodo da interfaceModule per processare comandi Hunter v2.0
    
    Esempio in interfaceModule.py:
        import hunter_v2_integration
        hunter_v2_integration.ForwardToHunterV2("HunterPlayerData", dataStr)
    """
    hunterlevel_v2.ParseHunterCommand(cmd, args)


def GetHunterV2PlayerData():
    """Ritorna i dati player dal sistema v2.0"""
    return hunterlevel_v2.GetPlayerData()


def GetHunterV2RankingData(ranking_type):
    """Ritorna dati classifica dal sistema v2.0"""
    return hunterlevel_v2.GetRankingData(ranking_type)


def RequestHunterV2Data():
    """Richiede aggiornamento dati al server"""
    hunterlevel_v2.RequestPlayerData()


def RequestHunterV2Ranking(ranking_type="daily"):
    """Richiede classifica al server"""
    hunterlevel_v2.RequestRanking(ranking_type)


def RequestHunterV2Missions():
    """Richiede missioni giornaliere al server"""
    hunterlevel_v2.RequestMissions()


def HunterV2BuyItem(item_id):
    """Acquista item dallo shop Hunter"""
    hunterlevel_v2.RequestBuyItem(item_id)


def HunterV2ConvertCredits(amount):
    """Converte gloria in crediti"""
    hunterlevel_v2.RequestConvertCredits(amount)


# ============================================================================
# CALLBACK REGISTRATION
# ============================================================================

def RegisterUICallback(event_type, callback):
    """
    Registra callback per ricevere aggiornamenti UI dal sistema v2.0
    
    Eventi disponibili:
    - "player_data": quando arrivano dati player
    - "ranking_daily", "ranking_weekly", "ranking_total": classifiche
    - "missions": quando arrivano missioni
    - "mission_progress": progresso missione
    - "mission_complete": missione completata
    - "trial_start", "trial_complete": eventi trial
    - "rank_up": promozione rank
    - "gate_entry", "gate_victory", "gate_defeat": eventi gate
    - "speed_kill_start", "speed_kill_end": speed kill
    - "emergency_start", "emergency_end": emergency quest
    - "shop_items": lista shop
    - "event_active": evento attivo
    
    Esempio:
        def on_player_data():
            data = hunter_v2_integration.GetHunterV2PlayerData()
            print "Gloria:", data.total_glory
        
        hunter_v2_integration.RegisterUICallback("player_data", on_player_data)
    """
    hunterlevel_v2.RegisterUICallback(event_type, callback)


# ============================================================================
# COMPATIBILITA' CON SISTEMA V1
# ============================================================================

def IsV2SystemActive():
    """Verifica se il sistema v2.0 è attivo"""
    return hunterlevel_v2.IsHunterSystemLoaded()


def GetPlayerGlory():
    """Ritorna gloria totale (compatibilità v1)"""
    data = hunterlevel_v2.GetPlayerData()
    return data.total_glory if data else 0


def GetPlayerRank():
    """Ritorna rank corrente (compatibilità v1)"""
    data = hunterlevel_v2.GetPlayerData()
    return data.current_rank if data else "E"


def GetPlayerCredits():
    """Ritorna crediti spendibili"""
    data = hunterlevel_v2.GetPlayerData()
    return data.spendable_credits if data else 0


def GetRankColorCode(rank):
    """Ritorna codice colore per rank"""
    return hunterlevel_v2.GetRankColor(rank)


def GetRankColorName(rank):
    """Ritorna nome colore per rank"""
    return hunterlevel_v2.GetRankColorName(rank)


def FormatGlory(glory):
    """Formatta gloria con separatori"""
    return hunterlevel_v2.FormatGlory(glory)


# ============================================================================
# INIZIALIZZAZIONE
# ============================================================================

def Initialize():
    """Inizializza il sistema v2.0 (chiamare al login)"""
    hunterlevel_v2.Initialize()


# ============================================================================
# FINE INTEGRAZIONE v2.0
# ============================================================================
