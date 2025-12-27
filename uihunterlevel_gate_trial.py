# -*- coding: utf-8 -*-
# ============================================================
# HUNTER SYSTEM - GATE/TRIAL STATUS WINDOW
# ============================================================
# Finestra principale per visualizzare:
# - Stato Gate Dungeon (accesso, timer, info)
# - Stato Trial (progresso, obiettivi, tempo)
# - Barre di progresso animate
# - Colori per rank
# ============================================================

import ui
import wndMgr
import app
import math

# ============================================================
# COLORI
# ============================================================
RANK_COLORS = {
    "E": 0xFF808080,
    "D": 0xFF00FF00,
    "C": 0xFF00FFFF,
    "B": 0xFF0066FF,
    "A": 0xFFAA00FF,
    "S": 0xFFFF6600,
    "N": 0xFFFF0000,
}

COLOR_CODES = {
    "GREEN": 0xFF00FF00,
    "BLUE": 0xFF0099FF,
    "CYAN": 0xFF00FFFF,
    "ORANGE": 0xFFFF6600,
    "RED": 0xFFFF0000,
    "GOLD": 0xFFFFD700,
    "PURPLE": 0xFF9900FF,
    "WHITE": 0xFFFFFFFF,
    "GRAY": 0xFF808080,
}

def GetRankColor(rank):
    return RANK_COLORS.get(rank, 0xFFFFFFFF)

def GetColorCode(code):
    return COLOR_CODES.get(code, RANK_COLORS.get(code, 0xFFFFFFFF))


# ============================================================
# ANIMATED PROGRESS BAR
# ============================================================
class AnimatedProgressBar(ui.Window):
    """Barra di progresso animata con effetto glow"""
    
    def __init__(self):
        ui.Window.__init__(self)
        
        self.width = 200
        self.height = 20
        self.progress = 0.0
        self.targetProgress = 0.0
        self.color = 0xFF00FF00
        self.glowPhase = 0
        
        self.__BuildUI()
    
    def __BuildUI(self):
        # Background
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(self.width, self.height)
        self.bg.SetColor(0xFF1a1a1a)
        self.bg.AddFlag("not_pick")
        self.bg.Show()
        
        # Border
        self.border = ui.Bar()
        self.border.SetParent(self)
        self.border.SetPosition(0, 0)
        self.border.SetSize(self.width, 2)
        self.border.SetColor(0xFF333333)
        self.border.AddFlag("not_pick")
        self.border.Show()
        
        # Progress fill
        self.fill = ui.Bar()
        self.fill.SetParent(self)
        self.fill.SetPosition(2, 2)
        self.fill.SetSize(0, self.height - 4)
        self.fill.SetColor(self.color)
        self.fill.AddFlag("not_pick")
        self.fill.Show()
        
        # Glow overlay
        self.glow = ui.Bar()
        self.glow.SetParent(self)
        self.glow.SetPosition(2, 2)
        self.glow.SetSize(0, self.height - 4)
        self.glow.SetColor(0x00FFFFFF)
        self.glow.AddFlag("not_pick")
        self.glow.Show()
        
        # Text
        self.text = ui.TextLine()
        self.text.SetParent(self)
        self.text.SetPosition(self.width // 2, 2)
        self.text.SetHorizontalAlignCenter()
        self.text.SetText("")
        self.text.SetPackedFontColor(0xFFFFFFFF)
        self.text.SetOutline()
        self.text.Show()
    
    def SetSize(self, w, h):
        ui.Window.SetSize(self, w, h)
        self.width = w
        self.height = h
        self.bg.SetSize(w, h)
        self.border.SetSize(w, 2)
        self.text.SetPosition(w // 2, 2)
        self.__UpdateFill()
    
    def SetProgress(self, current, maximum):
        if maximum > 0:
            self.targetProgress = min(1.0, float(current) / float(maximum))
        else:
            self.targetProgress = 0.0
        self.text.SetText(str(int(current)) + " / " + str(int(maximum)))
    
    def SetColor(self, color):
        self.color = color
        self.fill.SetColor(color)
    
    def __UpdateFill(self):
        fillWidth = int((self.width - 4) * self.progress)
        self.fill.SetSize(max(0, fillWidth), self.height - 4)
        self.glow.SetSize(max(0, fillWidth), self.height - 4)
    
    def OnUpdate(self):
        # Smooth animation
        if abs(self.progress - self.targetProgress) > 0.001:
            self.progress += (self.targetProgress - self.progress) * 0.1
            self.__UpdateFill()
        
        # Glow effect
        self.glowPhase += 0.05
        glowAlpha = int((math.sin(self.glowPhase) * 0.5 + 0.5) * 50)
        self.glow.SetColor((glowAlpha << 24) | 0xFFFFFF)


# ============================================================
# TRIAL STATUS WINDOW - Finestra Stato Trial
# ============================================================
class TrialStatusWindow(ui.Window):
    """Finestra principale per visualizzare lo stato della Trial"""
    
    def __init__(self):
        ui.Window.__init__(self)
        
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        
        self.windowWidth = 400
        self.windowHeight = 500
        
        self.SetSize(self.windowWidth, self.windowHeight)
        self.SetPosition(
            (self.screenWidth - self.windowWidth) // 2,
            (self.screenHeight - self.windowHeight) // 2
        )
        
        # Flag per drag
        self.AddFlag("movable")
        self.AddFlag("float")
        
        # Variabili per drag manuale (fallback)
        self.isDragging = False
        self.dragStartX = 0
        self.dragStartY = 0
        
        # Dati
        self.gateData = None
        self.trialData = None
        self.updateTimer = 0
        
        self.__BuildUI()
        self.Hide()
    
    def OnMouseLeftButtonDown(self):
        self.isDragging = True
        self.dragStartX, self.dragStartY = wndMgr.GetMousePosition()
        return True
    
    def OnMouseLeftButtonUp(self):
        self.isDragging = False
        return True
    
    def OnMouseDrag(self, x, y):
        if self.isDragging:
            currentX, currentY = wndMgr.GetMousePosition()
            deltaX = currentX - self.dragStartX
            deltaY = currentY - self.dragStartY
            
            windowX, windowY = self.GetLocalPosition()
            newX = windowX + deltaX
            newY = windowY + deltaY
            
            # Limita alla schermata
            newX = max(0, min(newX, self.screenWidth - self.windowWidth))
            newY = max(0, min(newY, self.screenHeight - self.windowHeight))
            
            self.SetPosition(newX, newY)
            self.dragStartX = currentX
            self.dragStartY = currentY
        return True
    
    def __BuildUI(self):
        # ===== BACKGROUND =====
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(self.windowWidth, self.windowHeight)
        self.bg.SetColor(0xEE0a0a0a)
        self.bg.Show()
        
        # Border top
        self.borderTop = ui.Bar()
        self.borderTop.SetParent(self)
        self.borderTop.SetPosition(0, 0)
        self.borderTop.SetSize(self.windowWidth, 3)
        self.borderTop.SetColor(0xFFFFD700)
        self.borderTop.Show()
        
        # Border bottom
        self.borderBot = ui.Bar()
        self.borderBot.SetParent(self)
        self.borderBot.SetPosition(0, self.windowHeight - 3)
        self.borderBot.SetSize(self.windowWidth, 3)
        self.borderBot.SetColor(0xFFFFD700)
        self.borderBot.Show()
        
        # ===== HEADER =====
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(self.windowWidth // 2, 15)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("HUNTER SYSTEM")
        self.titleText.SetPackedFontColor(0xFFFFD700)
        self.titleText.SetOutline()
        self.titleText.Show()
        
        self.subtitleText = ui.TextLine()
        self.subtitleText.SetParent(self)
        self.subtitleText.SetPosition(self.windowWidth // 2, 35)
        self.subtitleText.SetHorizontalAlignCenter()
        self.subtitleText.SetText("Gate Dungeon & Rank Trial")
        self.subtitleText.SetPackedFontColor(0xFF808080)
        self.subtitleText.SetOutline()
        self.subtitleText.Show()
        
        # Divider
        self.divider1 = ui.Bar()
        self.divider1.SetParent(self)
        self.divider1.SetPosition(20, 55)
        self.divider1.SetSize(self.windowWidth - 40, 1)
        self.divider1.SetColor(0xFF333333)
        self.divider1.Show()
        
        # ===== GATE SECTION =====
        self.gateSectionTitle = ui.TextLine()
        self.gateSectionTitle.SetParent(self)
        self.gateSectionTitle.SetPosition(20, 65)
        self.gateSectionTitle.SetText("[ GATE DUNGEON ]")
        self.gateSectionTitle.SetPackedFontColor(0xFFFF6600)
        self.gateSectionTitle.SetOutline()
        self.gateSectionTitle.Show()
        
        self.gateStatusText = ui.TextLine()
        self.gateStatusText.SetParent(self)
        self.gateStatusText.SetPosition(30, 90)
        self.gateStatusText.SetText("Stato: Nessun accesso")
        self.gateStatusText.SetPackedFontColor(0xFF808080)
        self.gateStatusText.Show()
        
        self.gateNameText = ui.TextLine()
        self.gateNameText.SetParent(self)
        self.gateNameText.SetPosition(30, 110)
        self.gateNameText.SetText("")
        self.gateNameText.SetPackedFontColor(0xFFFFFFFF)
        self.gateNameText.Show()
        
        self.gateTimerLabel = ui.TextLine()
        self.gateTimerLabel.SetParent(self)
        self.gateTimerLabel.SetPosition(30, 130)
        self.gateTimerLabel.SetText("Tempo rimasto:")
        self.gateTimerLabel.SetPackedFontColor(0xFF808080)
        self.gateTimerLabel.Show()
        
        self.gateTimerText = ui.TextLine()
        self.gateTimerText.SetParent(self)
        self.gateTimerText.SetPosition(130, 130)
        self.gateTimerText.SetText("--:--:--")
        self.gateTimerText.SetPackedFontColor(0xFFFFD700)
        self.gateTimerText.SetOutline()
        self.gateTimerText.Show()
        
        # Gate progress bar (tempo)
        self.gateProgressBar = AnimatedProgressBar()
        self.gateProgressBar.SetParent(self)
        self.gateProgressBar.SetPosition(30, 155)
        self.gateProgressBar.SetSize(340, 20)
        self.gateProgressBar.SetColor(0xFFFF6600)
        self.gateProgressBar.Show()
        
        # Divider
        self.divider2 = ui.Bar()
        self.divider2.SetParent(self)
        self.divider2.SetPosition(20, 185)
        self.divider2.SetSize(self.windowWidth - 40, 1)
        self.divider2.SetColor(0xFF333333)
        self.divider2.Show()
        
        # ===== TRIAL SECTION =====
        self.trialSectionTitle = ui.TextLine()
        self.trialSectionTitle.SetParent(self)
        self.trialSectionTitle.SetPosition(20, 195)
        self.trialSectionTitle.SetText("[ RANK TRIAL ]")
        self.trialSectionTitle.SetPackedFontColor(0xFFAA00FF)
        self.trialSectionTitle.SetOutline()
        self.trialSectionTitle.Show()
        
        self.trialStatusText = ui.TextLine()
        self.trialStatusText.SetParent(self)
        self.trialStatusText.SetPosition(30, 220)
        self.trialStatusText.SetText("Stato: Nessuna prova attiva")
        self.trialStatusText.SetPackedFontColor(0xFF808080)
        self.trialStatusText.Show()
        
        self.trialNameText = ui.TextLine()
        self.trialNameText.SetParent(self)
        self.trialNameText.SetPosition(30, 240)
        self.trialNameText.SetText("")
        self.trialNameText.SetPackedFontColor(0xFFFFFFFF)
        self.trialNameText.Show()
        
        self.trialRankText = ui.TextLine()
        self.trialRankText.SetParent(self)
        self.trialRankText.SetPosition(30, 260)
        self.trialRankText.SetText("")
        self.trialRankText.SetPackedFontColor(0xFFFFD700)
        self.trialRankText.Show()
        
        self.trialTimerText = ui.TextLine()
        self.trialTimerText.SetParent(self)
        self.trialTimerText.SetPosition(30, 280)
        self.trialTimerText.SetText("")
        self.trialTimerText.SetPackedFontColor(0xFFFF8800)
        self.trialTimerText.Show()
        
        # ===== PROGRESS BARS =====
        self.progressBars = {}
        self.progressLabels = {}
        
        progressTypes = [
            ("boss", "Boss", 0xFFFF0000),
            ("metin", "Metin", 0xFF00FFFF),
            ("fracture", "Fratture", 0xFF9900FF),
            ("chest", "Bauli", 0xFFFFD700),
            ("mission", "Missioni", 0xFF00FF00),
        ]
        
        yOffset = 305
        for pType, pName, pColor in progressTypes:
            # Label
            label = ui.TextLine()
            label.SetParent(self)
            label.SetPosition(30, yOffset)
            label.SetText(pName + ":")
            label.SetPackedFontColor(0xFFAAAAAA)
            label.Show()
            self.progressLabels[pType] = label
            
            # Progress bar
            bar = AnimatedProgressBar()
            bar.SetParent(self)
            bar.SetPosition(100, yOffset - 2)
            bar.SetSize(270, 18)
            bar.SetColor(pColor)
            bar.SetProgress(0, 0)
            bar.Show()
            self.progressBars[pType] = bar
            
            yOffset += 30
        
        # ===== CLOSE BUTTON =====
        self.closeBtn = ui.Button()
        self.closeBtn.SetParent(self)
        self.closeBtn.SetPosition(self.windowWidth - 30, 10)
        self.closeBtn.SetText("X")
        self.closeBtn.SetEvent(self.Close)
        self.closeBtn.Show()
        
        # ===== FOOTER =====
        self.footerText = ui.TextLine()
        self.footerText.SetParent(self)
        self.footerText.SetPosition(self.windowWidth // 2, self.windowHeight - 25)
        self.footerText.SetHorizontalAlignCenter()
        self.footerText.SetText("Solo Leveling Hunter System")
        self.footerText.SetPackedFontColor(0xFF555555)
        self.footerText.Show()
    
    def Show(self):
        ui.Window.Show(self)
        self.SetTop()
    
    def Close(self):
        self.Hide()
    
    def OnPressEscapeKey(self):
        self.Close()
        return True
    
    def UpdateGateStatus(self, gateId, gateName, remainingSeconds, colorCode):
        """Aggiorna lo stato del Gate"""
        self.gateData = {
            "id": gateId,
            "name": gateName.replace("+", " "),
            "remaining": remainingSeconds,
            "color": colorCode,
            "startRemaining": remainingSeconds
        }
        
        if gateId > 0 and remainingSeconds > 0:
            self.gateStatusText.SetText("Stato: ACCESSO DISPONIBILE")
            self.gateStatusText.SetPackedFontColor(0xFF00FF00)
            self.gateNameText.SetText("Gate: " + self.gateData["name"])
            self.gateNameText.SetPackedFontColor(GetColorCode(colorCode))
            self.gateProgressBar.SetProgress(remainingSeconds, 7200)  # 2 ore max
            self.gateProgressBar.SetColor(GetColorCode(colorCode))
        else:
            self.gateStatusText.SetText("Stato: Nessun accesso")
            self.gateStatusText.SetPackedFontColor(0xFF808080)
            self.gateNameText.SetText("")
            self.gateTimerText.SetText("--:--:--")
            self.gateProgressBar.SetProgress(0, 1)
    
    def UpdateTrialStatus(self, trialId, trialName, toRank, colorCode, remaining,
                          bossKills, reqBoss, metinKills, reqMetin,
                          fractureSeals, reqFracture, chestOpens, reqChest,
                          dailyMissions, reqMissions):
        """Aggiorna lo stato della Trial"""
        
        trialName = trialName.replace("+", " ") if trialName else ""
        
        self.trialData = {
            "id": trialId,
            "name": trialName,
            "toRank": toRank,
            "color": colorCode,
            "remaining": remaining,
            "progress": {
                "boss": (bossKills, reqBoss),
                "metin": (metinKills, reqMetin),
                "fracture": (fractureSeals, reqFracture),
                "chest": (chestOpens, reqChest),
                "mission": (dailyMissions, reqMissions),
            }
        }
        
        if trialId > 0:
            self.trialStatusText.SetText("Stato: PROVA IN CORSO")
            self.trialStatusText.SetPackedFontColor(0xFF00FFFF)
            self.trialNameText.SetText("Prova: " + trialName)
            self.trialNameText.SetPackedFontColor(GetColorCode(colorCode))
            self.trialRankText.SetText("Obiettivo: " + toRank + "-RANK")
            self.trialRankText.SetPackedFontColor(GetRankColor(toRank))
            
            if remaining and remaining > 0:
                self.trialTimerText.SetText("Tempo: " + self.__FormatTime(remaining))
            else:
                self.trialTimerText.SetText("Tempo: Illimitato")
            
            # Aggiorna barre
            self.progressBars["boss"].SetProgress(bossKills, reqBoss)
            self.progressBars["metin"].SetProgress(metinKills, reqMetin)
            self.progressBars["fracture"].SetProgress(fractureSeals, reqFracture)
            self.progressBars["chest"].SetProgress(chestOpens, reqChest)
            self.progressBars["mission"].SetProgress(dailyMissions, reqMissions)
        else:
            self.trialStatusText.SetText("Stato: Nessuna prova attiva")
            self.trialStatusText.SetPackedFontColor(0xFF808080)
            self.trialNameText.SetText("")
            self.trialRankText.SetText("")
            self.trialTimerText.SetText("")
            
            for bar in self.progressBars.values():
                bar.SetProgress(0, 0)
    
    def __FormatTime(self, seconds):
        if not seconds or seconds <= 0:
            return "Scaduto"
        
        if seconds >= 86400:
            d = seconds // 86400
            h = (seconds % 86400) // 3600
            return str(d) + "g " + str(h) + "h"
        
        h = seconds // 3600
        m = (seconds % 3600) // 60
        s = seconds % 60
        return "%02d:%02d:%02d" % (h, m, s)
    
    def OnUpdate(self):
        self.updateTimer += 1
        
        # Aggiorna timer ogni secondo circa (30 frame)
        if self.updateTimer >= 30:
            self.updateTimer = 0
            
            if self.gateData and self.gateData.get("remaining", 0) > 0:
                self.gateData["remaining"] -= 1
                self.gateTimerText.SetText(self.__FormatTime(self.gateData["remaining"]))
                self.gateProgressBar.SetProgress(self.gateData["remaining"], 7200)
            
            if self.trialData and self.trialData.get("remaining") and self.trialData["remaining"] > 0:
                self.trialData["remaining"] -= 1
                self.trialTimerText.SetText("Tempo: " + self.__FormatTime(self.trialData["remaining"]))


# ============================================================
# SYSTEM SPEAK WINDOW - Messaggi Sistema Animati
# ============================================================
class SystemSpeakWindow(ui.Window):
    """Finestra per messaggi del Sistema Hunter con animazione"""
    
    def __init__(self):
        ui.Window.__init__(self)
        
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        
        self.SetSize(600, 80)
        self.SetPosition(
            (self.screenWidth - 600) // 2,
            150
        )
        self.AddFlag("not_pick")
        
        self.messageQueue = []
        self.currentMessage = None
        self.startTime = 0
        self.duration = 3.0
        
        self.__BuildUI()
        self.Hide()
    
    def __BuildUI(self):
        # Background con gradiente
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(600, 80)
        self.bg.SetColor(0xDD000000)
        self.bg.AddFlag("not_pick")
        self.bg.Show()
        
        # Border superiore
        self.borderTop = ui.Bar()
        self.borderTop.SetParent(self)
        self.borderTop.SetPosition(0, 0)
        self.borderTop.SetSize(600, 3)
        self.borderTop.SetColor(0xFFFFD700)
        self.borderTop.AddFlag("not_pick")
        self.borderTop.Show()
        
        # Border inferiore
        self.borderBot = ui.Bar()
        self.borderBot.SetParent(self)
        self.borderBot.SetPosition(0, 77)
        self.borderBot.SetSize(600, 3)
        self.borderBot.SetColor(0xFFFFD700)
        self.borderBot.AddFlag("not_pick")
        self.borderBot.Show()
        
        # Icona Sistema
        self.iconText = ui.TextLine()
        self.iconText.SetParent(self)
        self.iconText.SetPosition(20, 25)
        self.iconText.SetText("[SISTEMA]")
        self.iconText.SetPackedFontColor(0xFFFFD700)
        self.iconText.SetOutline()
        self.iconText.Show()
        
        # Messaggio principale
        self.messageText = ui.TextLine()
        self.messageText.SetParent(self)
        self.messageText.SetPosition(300, 35)
        self.messageText.SetHorizontalAlignCenter()
        self.messageText.SetText("")
        self.messageText.SetPackedFontColor(0xFFFFFFFF)
        self.messageText.SetOutline()
        self.messageText.Show()
    
    def AddMessage(self, colorCode, message):
        """Aggiunge un messaggio alla coda"""
        message = message.replace("+", " ")
        color = GetColorCode(colorCode) if colorCode else 0xFFFFFFFF
        
        self.messageQueue.append({
            "color": color,
            "colorCode": colorCode,
            "message": message
        })
        
        if not self.IsShow():
            self.__ShowNext()
    
    def __ShowNext(self):
        if not self.messageQueue:
            self.Hide()
            return
        
        self.currentMessage = self.messageQueue.pop(0)
        self.startTime = app.GetTime()
        
        self.messageText.SetText(self.currentMessage["message"])
        self.messageText.SetPackedFontColor(self.currentMessage["color"])
        self.borderTop.SetColor(self.currentMessage["color"])
        self.borderBot.SetColor(self.currentMessage["color"])
        
        self.Show()
        self.SetTop()
    
    def OnUpdate(self):
        if not self.IsShow():
            return
        
        elapsed = app.GetTime() - self.startTime
        
        # Fade in (0-0.3s)
        if elapsed < 0.3:
            alpha = int(elapsed / 0.3 * 0xDD)
            self.bg.SetColor((alpha << 24) | 0x000000)
        
        # Fade out (2.5-3s)
        elif elapsed > 2.5:
            fadeProgress = (elapsed - 2.5) / 0.5
            alpha = int((1 - fadeProgress) * 0xDD)
            self.bg.SetColor((alpha << 24) | 0x000000)
            
            textAlpha = int((1 - fadeProgress) * 255)
            self.messageText.SetPackedFontColor((textAlpha << 24) | (self.currentMessage["color"] & 0xFFFFFF))
        
        if elapsed >= self.duration:
            self.__ShowNext()


# ============================================================
# GLOBAL INSTANCES
# ============================================================
g_trialStatusWindow = None
g_systemSpeakWindow = None

def GetTrialStatusWindow():
    global g_trialStatusWindow
    if g_trialStatusWindow is None:
        g_trialStatusWindow = TrialStatusWindow()
    return g_trialStatusWindow

def GetSystemSpeakWindow():
    global g_systemSpeakWindow
    if g_systemSpeakWindow is None:
        g_systemSpeakWindow = SystemSpeakWindow()
    return g_systemSpeakWindow

# ============================================================
# API FUNCTIONS
# ============================================================

def OpenGateTrialWindow():
    """Apre la finestra Gate/Trial"""
    wnd = GetTrialStatusWindow()
    wnd.Show()

def CloseGateTrialWindow():
    """Chiude la finestra Gate/Trial"""
    wnd = GetTrialStatusWindow()
    wnd.Close()

def UpdateGateStatus(gateId, gateName, remainingSeconds, colorCode):
    """Aggiorna lo stato del Gate"""
    wnd = GetTrialStatusWindow()
    wnd.UpdateGateStatus(gateId, gateName, remainingSeconds, colorCode)

def UpdateTrialStatus(trialId, trialName, toRank, colorCode, remaining,
                      bossKills, reqBoss, metinKills, reqMetin,
                      fractureSeals, reqFracture, chestOpens, reqChest,
                      dailyMissions, reqMissions):
    """Aggiorna lo stato della Trial"""
    wnd = GetTrialStatusWindow()
    wnd.UpdateTrialStatus(trialId, trialName, toRank, colorCode, remaining,
                          bossKills, reqBoss, metinKills, reqMetin,
                          fractureSeals, reqFracture, chestOpens, reqChest,
                          dailyMissions, reqMissions)

def ShowSystemMessage(colorCode, message):
    """Mostra un messaggio del Sistema"""
    wnd = GetSystemSpeakWindow()
    wnd.AddMessage(colorCode, message)
