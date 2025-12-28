# -*- coding: utf-8 -*-
"""
================================================================================
FIX per uiCharacter.py - Quest System Crash Fix
================================================================================
Risolve l'errore: IndexError: string index out of range
Nella funzione GetQuestProperties quando si clicca sulle categorie quest

Compatibile con Hunter System v2.0
================================================================================
"""

import quest
import player
import localeInfo

# ============================================================================
# CONFIGURAZIONE QUEST HUNTER
# ============================================================================

QUEST_CATEGORY_NAMES = {
    0: "Missioni Hunter",
    1: "Prove di Rango",
    2: "Emergenze",
    3: "Quest Giornaliere",
    4: "Quest Evento",
    5: "Quest Storia",
}

# Mapping dei tipi di missione Hunter
HUNTER_MISSION_TYPES = {
    "kill_mob": "Elimina Mostri",
    "kill_boss": "Uccidi Boss",
    "kill_metin": "Distruggi Metin",
    "kill_any": "Caccia Libera",
    "seal_fracture": "Sigilla Fratture",
    "open_chest": "Apri Bauli",
    "kill_vnum": "Caccia Speciale",
    "emergency_complete": "Emergenza",
    "complete_mission": "Completa Missione",
}

# ============================================================================
# FIX PER GetQuestProperties
# ============================================================================

def SafeGetQuestProperties(questIndex, propertyIndex=0):
    """
    Versione safe di GetQuestProperties che previene IndexError.

    Args:
        questIndex: Indice della quest
        propertyIndex: Indice della proprietà da recuperare

    Returns:
        str: Proprietà della quest o stringa vuota se non trovata
    """
    try:
        # Verifica che questIndex sia valido
        if questIndex < 0:
            return ""

        # Ottieni le proprietà della quest
        questName = quest.GetQuestName(questIndex)
        if not questName:
            return ""

        # Le quest properties sono spesso in formato "type:value" o "property"
        questData = quest.GetQuestData(questIndex)
        if not questData:
            return ""

        # Se questData è una stringa, parsala
        if isinstance(questData, str):
            # Controlla se è vuota
            if len(questData) == 0:
                return ""

            # Se ha il formato "type:value", splittala
            if ":" in questData:
                parts = questData.split(":")
                if propertyIndex < len(parts):
                    return parts[propertyIndex]
                else:
                    return ""
            else:
                # Se non ha ":", ritorna la stringa intera per il primo indice
                if propertyIndex == 0:
                    return questData
                else:
                    return ""

        return str(questData)

    except (IndexError, ValueError, AttributeError) as e:
        # Log dell'errore senza crashare
        import dbg
        dbg.TraceError("SafeGetQuestProperties error for quest %d, property %d: %s" % (questIndex, propertyIndex, str(e)))
        return ""

# ============================================================================
# FIX PER HUNTER QUEST INTEGRATION
# ============================================================================

def GetHunterQuestInfo(questIndex):
    """
    Recupera informazioni specifiche per le quest Hunter.

    Returns:
        dict: Dizionario con info quest o None
    """
    try:
        # Prova a recuperare dati dal sistema Hunter
        import hunterlevel_v2

        # Verifica se è una missione Hunter
        questName = quest.GetQuestName(questIndex)
        if not questName:
            return None

        # Cerca tra le missioni attive del player
        playerData = hunterlevel_v2.GetPlayerData()
        if not playerData or not hasattr(playerData, 'missions'):
            return None

        # Cerca la missione corrispondente
        for mission in playerData.missions:
            if mission.get("slot") == questIndex or mission.get("name") == questName:
                return {
                    "name": mission.get("name", "Missione Sconosciuta"),
                    "type": mission.get("type", "kill_mob"),
                    "type_name": HUNTER_MISSION_TYPES.get(mission.get("type", ""), "Caccia"),
                    "progress": mission.get("progress", 0),
                    "target": mission.get("target", 1),
                    "reward": mission.get("reward", 0),
                    "penalty": mission.get("penalty", 0),
                    "status": mission.get("status", "active"),
                }

        return None

    except Exception as e:
        import dbg
        dbg.TraceError("GetHunterQuestInfo error: %s" % str(e))
        return None

def IsHunterQuest(questIndex):
    """
    Verifica se una quest appartiene al sistema Hunter.

    Returns:
        bool: True se è una quest Hunter, False altrimenti
    """
    try:
        questName = quest.GetQuestName(questIndex)
        if not questName:
            return False

        # Lista di parole chiave per identificare quest Hunter
        hunterKeywords = [
            "hunter", "caccia", "missione", "prova", "emergenza",
            "boss", "metin", "frattura", "gloria", "rank"
        ]

        questNameLower = questName.lower()
        for keyword in hunterKeywords:
            if keyword in questNameLower:
                return True

        # Verifica anche tramite il sistema Hunter
        return GetHunterQuestInfo(questIndex) is not None

    except Exception:
        return False

# ============================================================================
# WRAPPER FUNCTIONS per compatibilità con uiCharacter.py originale
# ============================================================================

def GetQuestProperties_Safe(questIndex):
    """
    Wrapper safe per GetQuestProperties che ritorna sempre una stringa valida.
    Usa questo al posto di quest.GetQuestProperties() diretto.
    """
    return SafeGetQuestProperties(questIndex, 0)

def GetQuestPropertyType_Safe(questIndex):
    """
    Ritorna il tipo di quest in modo safe.
    """
    # Prima controlla se è una quest Hunter
    if IsHunterQuest(questIndex):
        hunterInfo = GetHunterQuestInfo(questIndex)
        if hunterInfo:
            return hunterInfo["type_name"]

    # Altrimenti usa il metodo standard
    return SafeGetQuestProperties(questIndex, 0)

def GetQuestPropertyValue_Safe(questIndex):
    """
    Ritorna il valore della quest in modo safe.
    """
    # Prima controlla se è una quest Hunter
    if IsHunterQuest(questIndex):
        hunterInfo = GetHunterQuestInfo(questIndex)
        if hunterInfo:
            return "%d/%d" % (hunterInfo["progress"], hunterInfo["target"])

    # Altrimenti usa il metodo standard
    return SafeGetQuestProperties(questIndex, 1)

# ============================================================================
# MONKEY PATCH per quest module (opzionale, se necessario)
# ============================================================================

def PatchQuestModule():
    """
    Applica monkey patch al modulo quest per prevenire crash.
    Chiamare questa funzione all'inizio del gioco.
    """
    try:
        # Salva la funzione originale se esiste
        if hasattr(quest, 'GetQuestProperties_ORIGINAL'):
            return  # Patch già applicata

        # Backup della funzione originale
        if hasattr(quest, 'GetQuestProperties'):
            quest.GetQuestProperties_ORIGINAL = quest.GetQuestProperties

        # Sostituisci con versione safe
        quest.GetQuestProperties = SafeGetQuestProperties

        import dbg
        dbg.LogBox("Quest module patched successfully for Hunter System compatibility")

    except Exception as e:
        import dbg
        dbg.TraceError("Failed to patch quest module: %s" % str(e))

# ============================================================================
# PATCH SPECIFICO PER uiCharacter.py
# ============================================================================

"""
Per applicare questo fix a uiCharacter.py esistente:

1. Importa questo modulo all'inizio di uiCharacter.py:
   import uiCharacter_quest_fix

2. Nel metodo __init__ della classe CharacterWindow:
   uiCharacter_quest_fix.PatchQuestModule()

3. Nel metodo GetQuestProperties (linea ~1678), sostituisci:

   PRIMA (causava crash):
   def GetQuestProperties(self, questIndex):
       properties = quest.GetQuestProperties(questIndex)
       return properties[0]  # <-- IndexError qui se properties è vuoto!

   DOPO (safe):
   def GetQuestProperties(self, questIndex):
       return uiCharacter_quest_fix.GetQuestProperties_Safe(questIndex)

4. Nel metodo SetQuest, sostituisci le chiamate a GetQuestProperties con:
   questType = uiCharacter_quest_fix.GetQuestPropertyType_Safe(questIndex)
   questValue = uiCharacter_quest_fix.GetQuestPropertyValue_Safe(questIndex)

5. Nel metodo LoadCategory, aggiungi controllo vuoto:

   PRIMA:
   for i in xrange(quest.GetQuestCount(category)):
       questIndex = quest.GetQuestIndex(category, i)
       self.SetQuest(questIndex)

   DOPO:
   questCount = quest.GetQuestCount(category)
   if questCount > 0:
       for i in xrange(questCount):
           questIndex = quest.GetQuestIndex(category, i)
           if questIndex >= 0:
               self.SetQuest(questIndex)
"""

# ============================================================================
# ALTERNATIVE: Patch completo per il metodo problematico
# ============================================================================

def FixedGetQuestProperties(self, questIndex):
    """
    Versione fixata del metodo GetQuestProperties da uiCharacter.py.
    Questa è la versione COMPLETA che sostituisce quella originale.

    Usa questo se non puoi modificare uiCharacter.py direttamente.
    """
    try:
        # Controlla se è una quest Hunter
        if IsHunterQuest(questIndex):
            hunterInfo = GetHunterQuestInfo(questIndex)
            if hunterInfo:
                return hunterInfo["type_name"]

        # Altrimenti usa il metodo standard con protezione
        properties = SafeGetQuestProperties(questIndex, 0)

        # Gestisci caso vuoto
        if not properties or len(properties) == 0:
            return "Quest"  # Valore di default

        # Se è una stringa con ":", prendi solo la parte prima
        if ":" in properties:
            return properties.split(":")[0]

        return properties

    except Exception as e:
        import dbg
        dbg.TraceError("FixedGetQuestProperties error for quest %d: %s" % (questIndex, str(e)))
        return "Quest"

# ============================================================================
# UTILITY per DEBUG
# ============================================================================

def DebugPrintQuestInfo(questIndex):
    """
    Stampa informazioni di debug per una quest specifica.
    """
    import chat

    try:
        chat.AppendChat(1, "[Quest Debug] Index: %d" % questIndex)

        questName = quest.GetQuestName(questIndex)
        chat.AppendChat(1, "[Quest Debug] Name: %s" % (questName if questName else "NONE"))

        isHunter = IsHunterQuest(questIndex)
        chat.AppendChat(1, "[Quest Debug] Is Hunter: %s" % ("YES" if isHunter else "NO"))

        if isHunter:
            hunterInfo = GetHunterQuestInfo(questIndex)
            if hunterInfo:
                chat.AppendChat(1, "[Quest Debug] Type: %s" % hunterInfo["type_name"])
                chat.AppendChat(1, "[Quest Debug] Progress: %d/%d" % (hunterInfo["progress"], hunterInfo["target"]))
                chat.AppendChat(1, "[Quest Debug] Status: %s" % hunterInfo["status"])

        props = SafeGetQuestProperties(questIndex, 0)
        chat.AppendChat(1, "[Quest Debug] Properties: '%s'" % props)

    except Exception as e:
        chat.AppendChat(1, "[Quest Debug] ERROR: %s" % str(e))

# ============================================================================
# FINE FIX
# ============================================================================
