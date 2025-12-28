# ============================================================
# GATE/TRIAL UI OPEN HANDLER
# ============================================================
def __HunterGateTrialOpen(self, args):
    """
    Apre la finestra principale del sistema Hunter Gate/Trial
    """
    try:
        if self.interface and hasattr(self.interface, "HunterGateTrialOpen"):
            self.interface.HunterGateTrialOpen()
    except Exception as e:
        import dbg
        dbg.TraceError("HunterGateTrialOpen error: " + str(e))
# ============================================================
# HUNTER SYSTEM - GATE & TRIAL COMMAND HANDLERS
# Da aggiungere a game.py nella sezione serverCommandList
# ============================================================

# In __init__ o dove definisci serverCommandList, aggiungi:
#
# serverCommandList["HunterGateStatus"]    = self.__HunterGateStatus
# serverCommandList["HunterGateEnter"]     = self.__HunterGateEnter
# serverCommandList["HunterGateComplete"]  = self.__HunterGateComplete
# serverCommandList["HunterTrialStart"]    = self.__HunterTrialStart
# serverCommandList["HunterTrialStatus"]   = self.__HunterTrialStatus
# serverCommandList["HunterTrialProgress"] = self.__HunterTrialProgress
# serverCommandList["HunterTrialComplete"] = self.__HunterTrialComplete

# ============================================================
# GATE DUNGEON HANDLERS
# ============================================================

def __HunterGateStatus(self, args):
    """
    Riceve: gate_id|gate_name|remaining_seconds|color_code
    Esempio: 3|Gate+Abissale|7200|ORANGE
    """
    try:
        parts = args.split("|")
        if len(parts) >= 4:
            gateId = int(parts[0])
            gateName = parts[1]
            remainingSeconds = int(parts[2])
            colorCode = parts[3]
            
            if self.interface:
                self.interface.HunterGateStatus(gateId, gateName, remainingSeconds, colorCode)
    except Exception as e:
        import dbg
        dbg.TraceError("HunterGateStatus error: " + str(e))

def __HunterGateEnter(self, args):
    """
    Riceve: gate_id|duration_minutes
    Esempio: 3|25
    """
    try:
        parts = args.split("|")
        if len(parts) >= 2:
            gateId = int(parts[0])
            duration = int(parts[1])
            
            if self.interface:
                self.interface.HunterGateEnter(gateId, duration)
    except Exception as e:
        import dbg
        dbg.TraceError("HunterGateEnter error: " + str(e))

def __HunterGateComplete(self, args):
    """
    Riceve: success(0/1)|gloria_change
    Esempio: 1|800 (completato, +800 gloria)
    Esempio: 0|400 (fallito, -400 gloria)
    """
    try:
        parts = args.split("|")
        if len(parts) >= 2:
            success = int(parts[0]) == 1
            gloriaChange = int(parts[1])
            
            if self.interface:
                self.interface.HunterGateComplete(success, gloriaChange)
    except Exception as e:
        import dbg
        dbg.TraceError("HunterGateComplete error: " + str(e))


# ============================================================
# TRIAL (JOB CHANGE) HANDLERS
# ============================================================

def __HunterTrialStart(self, args):
    """
    Riceve: trial_id|trial_name|to_rank|color_code
    Esempio: 2|Prova+del+Cacciatore|C|BLUE
    """
    try:
        parts = args.split("|")
        if len(parts) >= 4:
            trialId = int(parts[0])
            trialName = parts[1]
            toRank = parts[2]
            colorCode = parts[3]
            
            if self.interface:
                self.interface.HunterTrialStart(trialId, trialName, toRank, colorCode)
    except Exception as e:
        import dbg
        dbg.TraceError("HunterTrialStart error: " + str(e))

def __HunterTrialStatus(self, args):
    """
    Riceve: trial_id|trial_name|to_rank|color_code|remaining_seconds|
            boss_cur|boss_req|metin_cur|metin_req|fracture_cur|fracture_req|
            chest_cur|chest_req|daily_cur|daily_req
    Esempio: 2|Prova+del+Cacciatore|C|BLUE|259200|3|5|7|10|2|5|3|5|10|15
    """
    try:
        parts = args.split("|")
        if len(parts) >= 15:
            trialId = int(parts[0])
            trialName = parts[1]
            toRank = parts[2]
            colorCode = parts[3]
            remainingSeconds = int(parts[4]) if parts[4] != "-1" else -1
            
            bossKills = int(parts[5])
            bossReq = int(parts[6])
            metinKills = int(parts[7])
            metinReq = int(parts[8])
            fractureSeals = int(parts[9])
            fractureReq = int(parts[10])
            chestOpens = int(parts[11])
            chestReq = int(parts[12])
            dailyMissions = int(parts[13])
            dailyReq = int(parts[14])
            
            if self.interface:
                self.interface.HunterTrialStatus(
                    trialId, trialName, toRank, colorCode, remainingSeconds,
                    bossKills, bossReq, metinKills, metinReq,
                    fractureSeals, fractureReq, chestOpens, chestReq,
                    dailyMissions, dailyReq
                )
    except Exception as e:
        import dbg
        dbg.TraceError("HunterTrialStatus error: " + str(e))

def __HunterTrialProgress(self, args):
    """
    Riceve: trial_id|boss_cur/boss_req|metin_cur/metin_req|fracture_cur/fracture_req|
            chest_cur/chest_req|daily_cur/daily_req
    Esempio: 2|4/5|8/10|3/5|4/5|12/15
    """
    try:
        parts = args.split("|")
        if len(parts) >= 6:
            trialId = int(parts[0])
            
            def parseProg(s):
                if "/" in s:
                    a, b = s.split("/")
                    return int(a), int(b)
                return 0, 0
            
            bossKills, bossReq = parseProg(parts[1])
            metinKills, metinReq = parseProg(parts[2])
            fractureSeals, fractureReq = parseProg(parts[3])
            chestOpens, chestReq = parseProg(parts[4])
            dailyMissions, dailyReq = parseProg(parts[5])
            
            if self.interface:
                self.interface.HunterTrialProgress(
                    trialId, bossKills, metinKills, fractureSeals, chestOpens, dailyMissions
                )
    except Exception as e:
        import dbg
        dbg.TraceError("HunterTrialProgress error: " + str(e))

def __HunterTrialComplete(self, args):
    """
    Riceve: new_rank|gloria_reward|trial_name
    Esempio: C|1000|Prova+del+Cacciatore
    """
    try:
        parts = args.split("|")
        if len(parts) >= 3:
            newRank = parts[0]
            gloriaReward = int(parts[1])
            trialName = parts[2]
            
            if self.interface:
                self.interface.HunterTrialComplete(newRank, gloriaReward, trialName)
    except Exception as e:
        import dbg
        dbg.TraceError("HunterTrialComplete error: " + str(e))


# ============================================================
# INTERFACEMODULE.PY - Aggiungi questi metodi
# ============================================================
"""
def HunterGateStatus(self, gateId, gateName, remainingSeconds, colorCode):
    if self.wndHunterLevel:
        self.wndHunterLevel.UpdateGateStatus(gateId, gateName, remainingSeconds, colorCode)

def HunterGateEnter(self, gateId, duration):
    # Chiudi il timer Gate quando entri
    if self.wndHunterLevel:
        self.wndHunterLevel.HideGateTimer()
    chat.AppendChat(chat.CHAT_TYPE_INFO, "[GATE] Sei entrato! Hai %d minuti per completare." % duration)

def HunterGateComplete(self, success, gloriaChange):
    if success:
        chat.AppendChat(chat.CHAT_TYPE_INFO, "[GATE] COMPLETATO! +%d Gloria" % gloriaChange)
    else:
        chat.AppendChat(chat.CHAT_TYPE_INFO, "[GATE] FALLITO! -%d Gloria" % gloriaChange)

def HunterTrialStart(self, trialId, trialName, toRank, colorCode):
    if self.wndHunterLevel:
        self.wndHunterLevel.ShowTrialStarted(trialId, trialName, toRank, colorCode)

def HunterTrialStatus(self, trialId, trialName, toRank, colorCode, remainingSeconds,
                      bossKills, bossReq, metinKills, metinReq,
                      fractureSeals, fractureReq, chestOpens, chestReq,
                      dailyMissions, dailyReq):
    if self.wndHunterLevel:
        self.wndHunterLevel.UpdateTrialStatus(
            trialId, trialName, toRank, colorCode, remainingSeconds,
            bossKills, bossReq, metinKills, metinReq,
            fractureSeals, fractureReq, chestOpens, chestReq,
            dailyMissions, dailyReq
        )

def HunterTrialProgress(self, trialId, bossKills, metinKills, fractureSeals, chestOpens, dailyMissions):
    if self.wndHunterLevel:
        self.wndHunterLevel.UpdateTrialProgress(trialId, bossKills, metinKills, fractureSeals, chestOpens, dailyMissions)

def HunterTrialComplete(self, newRank, gloriaReward, trialName):
    if self.wndHunterLevel:
        self.wndHunterLevel.ShowTrialComplete(newRank, gloriaReward, trialName)
"""


# ============================================================
# UIHUNTERLEVEL.PY - Aggiungi questi metodi alla classe principale
# ============================================================
"""
# In __init__, aggiungi:
self.gateTimerWnd = uihunterlevel_whatif.GetGateTimerWindow()
self.trialStatusWnd = uihunterlevel_whatif.GetTrialStatusWindow()
self.trialCompleteWnd = uihunterlevel_whatif.GetTrialCompleteWindow()

# Metodi da aggiungere:

def UpdateGateStatus(self, gateId, gateName, remainingSeconds, colorCode):
    if self.gateTimerWnd:
        self.gateTimerWnd.SetGateData(gateId, gateName, remainingSeconds, colorCode)

def HideGateTimer(self):
    if self.gateTimerWnd:
        self.gateTimerWnd.Hide()

def ShowTrialStarted(self, trialId, trialName, toRank, colorCode):
    # Mostra notifica
    self.ShowSystemMessage("PROVA INIZIATA: " + trialName.replace("+", " "), colorCode)
    # Richiedi status completo
    # net.SendChatPacket("/hunter_trial_status")

def UpdateTrialStatus(self, trialId, trialName, toRank, colorCode, remainingSeconds,
                      bossKills, bossReq, metinKills, metinReq,
                      fractureSeals, fractureReq, chestOpens, chestReq,
                      dailyMissions, dailyReq):
    if self.trialStatusWnd:
        self.trialStatusWnd.SetTrialData(
            trialId, trialName, toRank, colorCode, remainingSeconds,
            bossKills, bossReq, metinKills, metinReq,
            fractureSeals, fractureReq, chestOpens, chestReq,
            dailyMissions, dailyReq
        )

def UpdateTrialProgress(self, trialId, bossKills, metinKills, fractureSeals, chestOpens, dailyMissions):
    if self.trialStatusWnd and self.trialStatusWnd.IsShow():
        self.trialStatusWnd.UpdateProgress(bossKills, metinKills, fractureSeals, chestOpens, dailyMissions)

def ShowTrialComplete(self, newRank, gloriaReward, trialName):
    # Nascondi finestra status
    if self.trialStatusWnd:
        self.trialStatusWnd.Hide()
    # Mostra effetto epico
    if self.trialCompleteWnd:
        self.trialCompleteWnd.Show(newRank, gloriaReward, trialName)
"""
