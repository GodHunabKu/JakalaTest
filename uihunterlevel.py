# -*- coding: utf-8 -*-
# ============================================================
# HUNTER SYSTEM - MAIN WINDOW
# ============================================================
import ui
import wndMgr
import app
import localeInfo
import chat
import player

# Import sub-windows
import uihunterlevel_gate_trial
import uihunterlevel_gate_effects
import uihunterlevel_awakening

# Global window manager reference
g_windowManager = None

def SetWindowManager(wnd):
    global g_windowManager
    g_windowManager = wnd

def GetWindowManager():
    global g_windowManager
    return g_windowManager

# ============================================================
# HUNTER LEVEL WINDOW - MAIN CLASS
# ============================================================

class HunterLevelWindow(ui.ScriptWindow):
    """
    Main Hunter Level Window
    Manages all Hunter System UI components including:
    - Gate/Trial windows
    - Effects (rank up, awakening, etc.)
    - Fracture Defense System
    - Speed Kill Timer System
    - Emergency quests
    - System messages
    """

    def __init__(self):
        ui.ScriptWindow.__init__(self)

        # Sub-windows
        self.gateTrialWindow = None
        self.systemSpeakWindow = None
        self.emergencyWindow = None
        self.missionsWindow = None
        self.eventsWindow = None

        # Fracture Defense System
        self.fractureDefenseWindow = None
        self.fractureDefenseActive = False

        # Speed Kill System
        self.speedKillWindow = None
        self.speedKillActive = False

        # Effects
        self.awakeningEffect = None
        self.rankUpEffect = None
        self.gateEntryEffect = None
        self.gateVictoryEffect = None
        self.gateDefeatEffect = None

        # Data
        self.isLoaded = False

    def LoadWindow(self):
        """Initialize all sub-windows and UI components"""
        if self.isLoaded:
            return

        try:
            # Gate/Trial Window
            self.gateTrialWindow = uihunterlevel_gate_trial.TrialStatusWindow()

            # System Speak Window
            self.systemSpeakWindow = uihunterlevel_gate_trial.SystemSpeakWindow()

            # Effects
            self.awakeningEffect = uihunterlevel_awakening.AwakeningEffect()
            self.rankUpEffect = uihunterlevel_awakening.RankUpEffect()
            self.gateEntryEffect = uihunterlevel_gate_effects.GateEntryEffect()
            self.gateVictoryEffect = uihunterlevel_gate_effects.GateVictoryEffect()
            self.gateDefeatEffect = uihunterlevel_gate_effects.GateDefeatEffect()

            # Fracture Defense Window (NEW)
            self.fractureDefenseWindow = FractureDefensePopup()

            # Speed Kill Window (NEW)
            self.speedKillWindow = SpeedKillTimerWindow()

            self.isLoaded = True

        except Exception as e:
            import dbg
            dbg.TraceError("HunterLevelWindow.LoadWindow error: " + str(e))

    def Destroy(self):
        """Clean up all resources"""
        if self.gateTrialWindow:
            self.gateTrialWindow.Destroy()
            self.gateTrialWindow = None

        if self.systemSpeakWindow:
            self.systemSpeakWindow.Destroy()
            self.systemSpeakWindow = None

        if self.fractureDefenseWindow:
            self.fractureDefenseWindow.Destroy()
            self.fractureDefenseWindow = None

        if self.speedKillWindow:
            self.speedKillWindow.Destroy()
            self.speedKillWindow = None

        self.isLoaded = False

    def IsShow(self):
        """Check if main window is visible"""
        if self.gateTrialWindow:
            return self.gateTrialWindow.IsShow()
        return False

    def Open(self):
        """Open the main hunter window"""
        if self.gateTrialWindow:
            self.gateTrialWindow.Show()

    def Close(self):
        """Close the main hunter window"""
        if self.gateTrialWindow:
            self.gateTrialWindow.Hide()

    # ============================================================
    # GATE/TRIAL SYSTEM
    # ============================================================

    def OpenGateTrialWindow(self):
        """Open Gate/Trial status window"""
        if self.gateTrialWindow:
            self.gateTrialWindow.Show()

    def UpdateGateStatus(self, gateId, gateName, remainingSeconds, colorCode):
        """Update gate timer status"""
        if self.gateTrialWindow:
            self.gateTrialWindow.UpdateGateStatus(gateId, gateName, remainingSeconds, colorCode)

    def HideGateTimer(self):
        """Hide gate timer"""
        if self.gateTrialWindow:
            self.gateTrialWindow.HideGateTimer()

    def OnGateComplete(self, success, gloriaChange):
        """Gate completion callback"""
        if success == 1 or success == "1":
            if self.gateVictoryEffect:
                self.gateVictoryEffect.Show(int(gloriaChange))
        else:
            if self.gateDefeatEffect:
                self.gateDefeatEffect.Show(int(gloriaChange))

    def OnTrialStart(self, trialId, trialName, toRank, colorCode):
        """Trial start callback"""
        if self.gateTrialWindow:
            self.gateTrialWindow.OnTrialStart(trialId, trialName, toRank, colorCode)

    def OnTrialStatus(self, trialId, trialName, toRank, remainingTime, colorCode, status):
        """Update trial status"""
        if self.gateTrialWindow:
            self.gateTrialWindow.OnTrialStatus(trialId, trialName, toRank, remainingTime, colorCode, status)

    def OnTrialProgress(self, trialId, bossKills, metinKills, fractureSeals, chestOpens, dailyMissions):
        """Update trial progress"""
        if self.gateTrialWindow:
            self.gateTrialWindow.OnTrialProgress(trialId, bossKills, metinKills, fractureSeals, chestOpens, dailyMissions)

    def OnTrialComplete(self, newRank, gloriaReward, trialName):
        """Trial completion callback"""
        if self.rankUpEffect:
            # Determine old rank (one below new rank)
            ranks = ["E", "D", "C", "B", "A", "S", "N"]
            newRankIdx = ranks.index(newRank) if newRank in ranks else 0
            oldRank = ranks[max(0, newRankIdx - 1)]
            self.rankUpEffect.Show(oldRank, newRank)

    # ============================================================
    # SYSTEM MESSAGES
    # ============================================================

    def ShowSystemMessage(self, msg, color):
        """Show system message"""
        if self.systemSpeakWindow:
            self.systemSpeakWindow.Speak(msg, color)

    def ShowWelcomeMessage(self, rankKey, name, points):
        """Show welcome message"""
        msg = "Welcome, %s! Rank: %s | Points: %d" % (name, rankKey, points)
        self.ShowSystemMessage(msg, rankKey)

    def ShowBossAlert(self, bossName):
        """Show boss alert"""
        msg = "[BOSS SPAWN] %s appeared!" % bossName
        self.ShowSystemMessage(msg, "RED")

    def ShowSystemInit(self):
        """Show system initialization"""
        self.ShowSystemMessage("Hunter System Initialized", "GOLD")

    def ShowAwakening(self, playerName):
        """Show awakening effect"""
        if self.awakeningEffect:
            level = player.GetStatus(player.LEVEL)
            self.awakeningEffect.Show(level)

    def ShowHunterActivation(self, playerName):
        """Show hunter activation"""
        self.ShowSystemMessage("Hunter System Activated!", "GOLD")

    def ShowRankUp(self, oldRank, newRank):
        """Show rank up effect"""
        if self.rankUpEffect:
            self.rankUpEffect.Show(oldRank, newRank)

    def ShowOvertake(self, overtakenName, newPosition):
        """Show overtake notification"""
        msg = "You overtook %s! New Position: #%d" % (overtakenName, newPosition)
        self.ShowSystemMessage(msg, "GOLD")

    def ShowEventStatus(self, eventName, duration, eventType):
        """Show event status"""
        msg = "[EVENT] %s started!" % eventName
        self.ShowSystemMessage(msg, "PURPLE")

    def CloseEventStatus(self):
        """Close event status"""
        pass

    # ============================================================
    # EMERGENCY QUEST
    # ============================================================

    def StartEmergencyQuest(self, title, seconds, vnum, count):
        """Start emergency quest"""
        # Similar to daily mission popup
        msg = "[EMERGENCY] %s - Kill %d mobs in %d seconds!" % (title, count, seconds)
        self.ShowSystemMessage(msg, "RED")

    def UpdateEmergencyCount(self, current):
        """Update emergency quest count"""
        pass

    def EndEmergencyQuest(self, success):
        """End emergency quest"""
        if success:
            self.ShowSystemMessage("Emergency Quest Completed!", "GOLD")
        else:
            self.ShowSystemMessage("Emergency Quest Failed", "RED")

    # ============================================================
    # WHATIF / RIVAL
    # ============================================================

    def UpdateRival(self, name, points, label, mode):
        """Update rival information"""
        pass

    def OpenWhatIf(self, qid, text, opt1, opt2, opt3, colorCode):
        """Open whatif question dialog"""
        pass

    # ============================================================
    # MISSIONS & EVENTS
    # ============================================================

    def SetMissionsCount(self, count):
        """Set missions count"""
        pass

    def AddMissionData(self, missionData):
        """Add mission data"""
        pass

    def UpdateMissionProgress(self, missionId, current, target):
        """Update mission progress"""
        pass

    def OnMissionComplete(self, missionId, name, reward):
        """Mission complete callback"""
        msg = "[MISSION COMPLETE] %s - Reward: %d" % (name, reward)
        self.ShowSystemMessage(msg, "GOLD")

    def OnAllMissionsComplete(self, bonus):
        """All missions complete callback"""
        msg = "[ALL MISSIONS COMPLETE] Bonus: %d" % bonus
        self.ShowSystemMessage(msg, "PURPLE")

    def OpenMissionsPanel(self):
        """Open missions panel"""
        pass

    def SetEventsCount(self, count):
        """Set events count"""
        pass

    def AddEventData(self, eventData):
        """Add event data"""
        pass

    def OnEventJoined(self, eventId, name, glory):
        """Event joined callback"""
        msg = "[EVENT JOINED] %s" % name
        self.ShowSystemMessage(msg, "PURPLE")

    def OpenEventsPanel(self):
        """Open events panel"""
        pass

    # ============================================================
    # FRACTURE DEFENSE SYSTEM (NEW)
    # ============================================================

    def StartFractureDefense(self, fractureName, duration, color):
        """
        Start fracture defense popup with timer
        @param fractureName: Name of the fracture (e.g., "Frattura E-Rank")
        @param duration: Defense duration in seconds (e.g., 60)
        @param color: Color code (e.g., "PURPLE", "BLUE")
        """
        if self.fractureDefenseWindow:
            self.fractureDefenseWindow.Start(fractureName, duration, color)
            self.fractureDefenseActive = True

    def UpdateFractureDefenseTimer(self, remainingSeconds):
        """
        Update fracture defense countdown timer
        @param remainingSeconds: Seconds remaining
        """
        if self.fractureDefenseWindow and self.fractureDefenseActive:
            self.fractureDefenseWindow.UpdateTimer(remainingSeconds)

    def CompleteFractureDefense(self, success, message):
        """
        Complete fracture defense (success or failure)
        @param success: 1 if successful, 0 if failed
        @param message: Completion message
        """
        if self.fractureDefenseWindow:
            isSuccess = (success == 1 or success == "1")
            self.fractureDefenseWindow.Complete(isSuccess, message)
            self.fractureDefenseActive = False

    # ============================================================
    # SPEED KILL SYSTEM (NEW)
    # ============================================================

    def StartSpeedKill(self, mobType, duration, color):
        """
        Start speed kill challenge timer
        @param mobType: Type of mob (e.g., "BOSS", "SUPER METIN")
        @param duration: Time limit in seconds (e.g., 60 for boss, 300 for metin)
        @param color: Color code (e.g., "GOLD", "RED")
        """
        if self.speedKillWindow:
            self.speedKillWindow.Start(mobType, duration, color)
            self.speedKillActive = True

    def UpdateSpeedKillTimer(self, remainingSeconds):
        """
        Update speed kill countdown timer
        @param remainingSeconds: Seconds remaining
        """
        if self.speedKillWindow and self.speedKillActive:
            self.speedKillWindow.UpdateTimer(remainingSeconds)

    def EndSpeedKill(self, isSuccess):
        """
        End speed kill challenge
        @param isSuccess: 1 if completed in time (2x gloria), 0 if failed
        """
        if self.speedKillWindow:
            success = (isSuccess == 1 or isSuccess == "1")
            self.speedKillWindow.End(success)
            self.speedKillActive = False


# ============================================================
# FRACTURE DEFENSE POPUP WINDOW
# ============================================================

class FractureDefensePopup(ui.Window):
    """
    Popup window for Fracture Defense quest
    Shows countdown timer and defense status
    """

    def __init__(self):
        ui.Window.__init__(self)

        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()

        self.fractureName = ""
        self.duration = 60
        self.remaining = 60
        self.color = 0xFFAA00FF

        self.__BuildUI()
        self.Hide()

    def __BuildUI(self):
        """Build popup UI"""
        # Window size
        width = 400
        height = 150

        self.SetSize(width, height)
        self.SetPosition((self.screenWidth - width) // 2, 100)

        # Background
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(width, height)
        self.bg.SetColor(0xAA000000)
        self.bg.AddFlag("not_pick")
        self.bg.Show()

        # Border
        self.border = ui.Bar()
        self.border.SetParent(self)
        self.border.SetPosition(0, 0)
        self.border.SetSize(width, 2)
        self.border.SetColor(0xFFAA00FF)
        self.border.AddFlag("not_pick")
        self.border.Show()

        # Title
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(width // 2, 15)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("DEFEND THE FRACTURE!")
        self.titleText.SetPackedFontColor(0xFFFFFFFF)
        self.titleText.SetOutline()
        self.titleText.Show()

        # Fracture name
        self.nameText = ui.TextLine()
        self.nameText.SetParent(self)
        self.nameText.SetPosition(width // 2, 45)
        self.nameText.SetHorizontalAlignCenter()
        self.nameText.SetText("")
        self.nameText.SetPackedFontColor(0xFFFFFFFF)
        self.nameText.SetOutline()
        self.nameText.Show()

        # Timer text
        self.timerText = ui.TextLine()
        self.timerText.SetParent(self)
        self.timerText.SetPosition(width // 2, 75)
        self.timerText.SetHorizontalAlignCenter()
        self.timerText.SetText("60")
        self.timerText.SetPackedFontColor(0xFFFFD700)
        self.timerText.SetOutline()
        self.timerText.Show()

        # Instructions
        self.instructionText = ui.TextLine()
        self.instructionText.SetParent(self)
        self.instructionText.SetPosition(width // 2, 110)
        self.instructionText.SetHorizontalAlignCenter()
        self.instructionText.SetText("Stay near the fracture!")
        self.instructionText.SetPackedFontColor(0xFFFF6600)
        self.instructionText.SetOutline()
        self.instructionText.Show()

    def Start(self, fractureName, duration, colorCode):
        """Start defense timer"""
        self.fractureName = fractureName
        self.duration = duration
        self.remaining = duration

        # Get color
        self.color = uihunterlevel_gate_trial.GetColorCode(colorCode)
        self.border.SetColor(self.color)

        self.nameText.SetText(fractureName)
        self.timerText.SetText(str(duration))

        self.Show()

    def UpdateTimer(self, remainingSeconds):
        """Update countdown timer"""
        self.remaining = remainingSeconds
        self.timerText.SetText(str(max(0, remainingSeconds)))

        # Change color if time is running out
        if remainingSeconds <= 10:
            self.timerText.SetPackedFontColor(0xFFFF0000)  # Red
        elif remainingSeconds <= 30:
            self.timerText.SetPackedFontColor(0xFFFF6600)  # Orange
        else:
            self.timerText.SetPackedFontColor(0xFFFFD700)  # Gold

    def Complete(self, success, message):
        """Complete defense"""
        if success:
            self.titleText.SetText("DEFENSE SUCCESSFUL!")
            self.titleText.SetPackedFontColor(0xFF00FF00)
        else:
            self.titleText.SetText("DEFENSE FAILED!")
            self.titleText.SetPackedFontColor(0xFFFF0000)

        self.instructionText.SetText(message)

        # Auto-hide after 3 seconds
        import event
        event.QueueEvent(lambda: self.Hide(), 3.0)

    def Destroy(self):
        """Clean up"""
        self.Hide()


# ============================================================
# SPEED KILL TIMER WINDOW
# ============================================================

class SpeedKillTimerWindow(ui.Window):
    """
    Side timer window for Speed Kill challenges
    Shows countdown and mob type
    """

    def __init__(self):
        ui.Window.__init__(self)

        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()

        self.mobType = ""
        self.duration = 60
        self.remaining = 60
        self.color = 0xFFFFD700

        self.__BuildUI()
        self.Hide()

    def __BuildUI(self):
        """Build timer UI"""
        # Window size (side panel)
        width = 250
        height = 100

        self.SetSize(width, height)
        self.SetPosition(self.screenWidth - width - 20, 200)

        # Background
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(width, height)
        self.bg.SetColor(0xAA000000)
        self.bg.AddFlag("not_pick")
        self.bg.Show()

        # Border
        self.border = ui.Bar()
        self.border.SetParent(self)
        self.border.SetPosition(0, 0)
        self.border.SetSize(width, 3)
        self.border.SetColor(0xFFFFD700)
        self.border.AddFlag("not_pick")
        self.border.Show()

        # Title
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(width // 2, 10)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("SPEED KILL CHALLENGE")
        self.titleText.SetPackedFontColor(0xFFFFD700)
        self.titleText.SetOutline()
        self.titleText.Show()

        # Mob type
        self.mobText = ui.TextLine()
        self.mobText.SetParent(self)
        self.mobText.SetPosition(width // 2, 35)
        self.mobText.SetHorizontalAlignCenter()
        self.mobText.SetText("")
        self.mobText.SetPackedFontColor(0xFFFFFFFF)
        self.mobText.SetOutline()
        self.mobText.Show()

        # Timer
        self.timerText = ui.TextLine()
        self.timerText.SetParent(self)
        self.timerText.SetPosition(width // 2, 60)
        self.timerText.SetHorizontalAlignCenter()
        self.timerText.SetText("0:00")
        self.timerText.SetPackedFontColor(0xFFFFD700)
        self.timerText.SetOutline()
        self.timerText.Show()

    def Start(self, mobType, duration, colorCode):
        """Start speed kill timer"""
        self.mobType = mobType
        self.duration = duration
        self.remaining = duration

        # Get color
        self.color = uihunterlevel_gate_trial.GetColorCode(colorCode)
        self.border.SetColor(self.color)

        self.mobText.SetText(mobType)
        self.timerText.SetText(self._FormatTime(duration))

        self.Show()

    def UpdateTimer(self, remainingSeconds):
        """Update countdown"""
        self.remaining = remainingSeconds
        self.timerText.SetText(self._FormatTime(max(0, remainingSeconds)))

        # Change color based on time
        if remainingSeconds <= 10:
            self.timerText.SetPackedFontColor(0xFFFF0000)  # Red
            self.border.SetColor(0xFFFF0000)
        elif remainingSeconds <= 30:
            self.timerText.SetPackedFontColor(0xFFFF6600)  # Orange
            self.border.SetColor(0xFFFF6600)
        else:
            self.timerText.SetPackedFontColor(self.color)

    def End(self, success):
        """End speed kill"""
        if success:
            self.titleText.SetText("SPEED KILL SUCCESS!")
            self.titleText.SetPackedFontColor(0xFF00FF00)
            self.mobText.SetText("GLORIA x2!")
        else:
            self.titleText.SetText("TIME EXPIRED")
            self.titleText.SetPackedFontColor(0xFFFF0000)
            self.mobText.SetText("Normal gloria")

        # Auto-hide after 3 seconds
        import event
        event.QueueEvent(lambda: self.Hide(), 3.0)

    def _FormatTime(self, seconds):
        """Format seconds as MM:SS"""
        minutes = seconds // 60
        secs = seconds % 60
        return "%d:%02d" % (minutes, secs)

    def Destroy(self):
        """Clean up"""
        self.Hide()
