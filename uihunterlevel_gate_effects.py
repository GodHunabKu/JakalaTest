# -*- coding: utf-8 -*-
import ui
import wndMgr
import app

COLOR_CODES = {
    "E": 0xFF808080, "D": 0xFF00FF00, "C": 0xFF00FFFF, "B": 0xFF0066FF,
    "A": 0xFFAA00FF, "S": 0xFFFF6600, "N": 0xFFFF0000, "GREEN": 0xFF00FF00,
    "BLUE": 0xFF0099FF, "CYAN": 0xFF00FFFF, "ORANGE": 0xFFFF6600,
    "RED": 0xFFFF0000, "GOLD": 0xFFFFD700, "PURPLE": 0xFF9900FF,
}

def GetColor(code):
    return COLOR_CODES.get(code, 0xFFFFFFFF)

class GateEntryEffect(ui.Window):
    def __init__(self):
        ui.Window.__init__(self)
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.startTime = 0
        self.gateName = "Gate"
        self.color = 0xFFFF0000
        self.__BuildUI()
        self.Hide()

    def __BuildUI(self):
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(self.screenWidth, self.screenHeight)
        self.bg.SetColor(0x00000000)
        self.bg.AddFlag("not_pick")
        self.bg.Show()

        self.leftEye = ui.Bar()
        self.leftEye.SetParent(self)
        self.leftEye.SetSize(80, 40)
        self.leftEye.SetPosition(self.screenWidth // 2 - 120, self.screenHeight // 2 - 20)
        self.leftEye.SetColor(0x00FF0000)
        self.leftEye.AddFlag("not_pick")
        self.leftEye.Show()

        self.leftPupil = ui.Bar()
        self.leftPupil.SetParent(self)
        self.leftPupil.SetSize(20, 20)
        self.leftPupil.SetPosition(self.screenWidth // 2 - 90, self.screenHeight // 2 - 10)
        self.leftPupil.SetColor(0x00000000)
        self.leftPupil.AddFlag("not_pick")
        self.leftPupil.Show()

        self.rightEye = ui.Bar()
        self.rightEye.SetParent(self)
        self.rightEye.SetSize(80, 40)
        self.rightEye.SetPosition(self.screenWidth // 2 + 40, self.screenHeight // 2 - 20)
        self.rightEye.SetColor(0x00FF0000)
        self.rightEye.AddFlag("not_pick")
        self.rightEye.Show()

        self.rightPupil = ui.Bar()
        self.rightPupil.SetParent(self)
        self.rightPupil.SetSize(20, 20)
        self.rightPupil.SetPosition(self.screenWidth // 2 + 70, self.screenHeight // 2 - 10)
        self.rightPupil.SetColor(0x00000000)
        self.rightPupil.AddFlag("not_pick")
        self.rightPupil.Show()

        self.text1 = ui.TextLine()
        self.text1.SetParent(self)
        self.text1.SetPosition(self.screenWidth // 2, self.screenHeight // 2 + 80)
        self.text1.SetHorizontalAlignCenter()
        self.text1.SetText("")
        self.text1.SetPackedFontColor(0x00FFFFFF)
        self.text1.SetOutline()
        self.text1.Show()

        self.text2 = ui.TextLine()
        self.text2.SetParent(self)
        self.text2.SetPosition(self.screenWidth // 2, self.screenHeight // 2 + 110)
        self.text2.SetHorizontalAlignCenter()
        self.text2.SetText("")
        self.text2.SetPackedFontColor(0x00FFFFFF)
        self.text2.SetOutline()
        self.text2.Show()

    def Start(self, gateName, colorCode):
        self.gateName = gateName.replace("+", " ")
        self.color = GetColor(colorCode)
        self.startTime = app.GetTime()
        self.text1.SetText("VARCHI LA SOGLIA...")
        self.text2.SetText(self.gateName)
        self.Show()
        self.SetTop()

    def OnUpdate(self):
        if not self.IsShow():
            return
        elapsed = app.GetTime() - self.startTime
        if elapsed < 0.5:
            alpha = int(elapsed / 0.5 * 255)
            self.bg.SetColor((alpha << 24) | 0x000000)
        elif elapsed < 1.5:
            self.bg.SetColor(0xFF000000)
            eyeAlpha = int((elapsed - 0.5) / 1.0 * 255)
            self.leftEye.SetColor((eyeAlpha << 24) | (self.color & 0xFFFFFF))
            self.rightEye.SetColor((eyeAlpha << 24) | (self.color & 0xFFFFFF))
            self.leftPupil.SetColor((eyeAlpha << 24) | 0x000000)
            self.rightPupil.SetColor((eyeAlpha << 24) | 0x000000)
        elif elapsed < 2.5:
            self.leftEye.SetColor(self.color)
            self.rightEye.SetColor(self.color)
            self.leftPupil.SetColor(0xFF000000)
            self.rightPupil.SetColor(0xFF000000)
            textAlpha = int((elapsed - 1.5) / 1.0 * 255)
            self.text1.SetPackedFontColor((textAlpha << 24) | 0xFFFFFF)
            self.text2.SetPackedFontColor((textAlpha << 24) | (self.color & 0xFFFFFF))
        elif elapsed < 4.0:
            alpha = int((1 - (elapsed - 2.5) / 1.5) * 255)
            self.bg.SetColor((alpha << 24) | 0x000000)
            self.leftEye.SetColor((alpha << 24) | (self.color & 0xFFFFFF))
            self.rightEye.SetColor((alpha << 24) | (self.color & 0xFFFFFF))
            self.leftPupil.SetColor((alpha << 24) | 0x000000)
            self.rightPupil.SetColor((alpha << 24) | 0x000000)
            self.text1.SetPackedFontColor((alpha << 24) | 0xFFFFFF)
            self.text2.SetPackedFontColor((alpha << 24) | (self.color & 0xFFFFFF))
        else:
            self.Hide()

class GateVictoryEffect(ui.Window):
    def __init__(self):
        ui.Window.__init__(self)
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.startTime = 0
        self.gateName = "Gate"
        self.gloria = 500
        self.__BuildUI()
        self.Hide()

    def __BuildUI(self):
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(self.screenWidth, self.screenHeight)
        self.bg.SetColor(0x00000000)
        self.bg.AddFlag("not_pick")
        self.bg.Show()

        self.flash = ui.Bar()
        self.flash.SetParent(self)
        self.flash.SetPosition(0, 0)
        self.flash.SetSize(self.screenWidth, self.screenHeight)
        self.flash.SetColor(0x00FFFFFF)
        self.flash.AddFlag("not_pick")
        self.flash.Show()

        self.rings = []
        for i in range(3):
            ring = ui.Bar()
            ring.SetParent(self)
            ring.SetSize(10, 10)
            ring.SetPosition(self.screenWidth // 2 - 5, self.screenHeight // 2 - 5)
            ring.SetColor(0x00FFD700)
            ring.AddFlag("not_pick")
            ring.Show()
            self.rings.append(ring)

        self.victoryText = ui.TextLine()
        self.victoryText.SetParent(self)
        self.victoryText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 - 50)
        self.victoryText.SetHorizontalAlignCenter()
        self.victoryText.SetText("")
        self.victoryText.SetPackedFontColor(0x00FFD700)
        self.victoryText.SetOutline()
        self.victoryText.Show()

        self.gloriaText = ui.TextLine()
        self.gloriaText.SetParent(self)
        self.gloriaText.SetPosition(self.screenWidth // 2, self.screenHeight // 2)
        self.gloriaText.SetHorizontalAlignCenter()
        self.gloriaText.SetText("")
        self.gloriaText.SetPackedFontColor(0x00FFFFFF)
        self.gloriaText.SetOutline()
        self.gloriaText.Show()

        self.gateText = ui.TextLine()
        self.gateText.SetParent(self)
        self.gateText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 + 50)
        self.gateText.SetHorizontalAlignCenter()
        self.gateText.SetText("")
        self.gateText.SetPackedFontColor(0x00FFFFFF)
        self.gateText.SetOutline()
        self.gateText.Show()

    def Start(self, gateName, gloria):
        self.gateName = gateName.replace("+", " ")
        self.gloria = gloria
        self.startTime = app.GetTime()
        self.victoryText.SetText("V I T T O R I A")
        self.gloriaText.SetText("+" + str(gloria) + " GLORIA")
        self.gateText.SetText(self.gateName + " COMPLETATO")
        self.Show()
        self.SetTop()

    def OnUpdate(self):
        if not self.IsShow():
            return
        elapsed = app.GetTime() - self.startTime
        if elapsed < 0.3:
            self.flash.SetColor((int((1 - elapsed / 0.3) * 200) << 24) | 0xFFFFFF)
        else:
            self.flash.SetColor(0x00FFFFFF)
        if elapsed >= 0.3 and elapsed < 1.0:
            self.bg.SetColor((int((elapsed - 0.3) / 0.7 * 100) << 24) | 0x1a1500)
        if elapsed >= 0.5 and elapsed < 2.0:
            for i, ring in enumerate(self.rings):
                ringStart = 0.5 + i * 0.3
                if elapsed >= ringStart:
                    ringProgress = min(1.0, (elapsed - ringStart) / 1.0)
                    ringSize = int(50 + ringProgress * 300)
                    ring.SetSize(ringSize, ringSize)
                    ring.SetPosition(self.screenWidth // 2 - ringSize // 2, self.screenHeight // 2 - ringSize // 2)
                    ring.SetColor((int((1 - ringProgress) * 150) << 24) | 0xFFD700)
        if elapsed >= 1.0 and elapsed < 2.0:
            textAlpha = int((elapsed - 1.0) / 1.0 * 255)
            self.victoryText.SetPackedFontColor((textAlpha << 24) | 0xFFD700)
            self.gloriaText.SetPackedFontColor((textAlpha << 24) | 0x00FF00)
            self.gateText.SetPackedFontColor((textAlpha << 24) | 0xFFFFFF)
        if elapsed >= 4.0:
            alpha = int((1 - (elapsed - 4.0) / 1.0) * 255)
            self.bg.SetColor((int((1 - (elapsed - 4.0) / 1.0) * 100) << 24) | 0x1a1500)
            self.victoryText.SetPackedFontColor((alpha << 24) | 0xFFD700)
            self.gloriaText.SetPackedFontColor((alpha << 24) | 0x00FF00)
            self.gateText.SetPackedFontColor((alpha << 24) | 0xFFFFFF)
        if elapsed >= 5.0:
            self.Hide()

class GateDefeatEffect(ui.Window):
    def __init__(self):
        ui.Window.__init__(self)
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.startTime = 0
        self.penalty = 250
        self.__BuildUI()
        self.Hide()

    def __BuildUI(self):
        self.flash = ui.Bar()
        self.flash.SetParent(self)
        self.flash.SetPosition(0, 0)
        self.flash.SetSize(self.screenWidth, self.screenHeight)
        self.flash.SetColor(0x00FF0000)
        self.flash.AddFlag("not_pick")
        self.flash.Show()

        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(self.screenWidth, self.screenHeight)
        self.bg.SetColor(0x00000000)
        self.bg.AddFlag("not_pick")
        self.bg.Show()

        self.cracks = []
        for i in range(6):
            crack = ui.Bar()
            crack.SetParent(self)
            crack.SetSize(3, 100)
            crack.SetPosition(int(self.screenWidth * 0.5), int(self.screenHeight * 0.5))
            crack.SetColor(0x00000000)
            crack.AddFlag("not_pick")
            crack.Show()
            self.cracks.append(crack)

        self.defeatText = ui.TextLine()
        self.defeatText.SetParent(self)
        self.defeatText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 - 30)
        self.defeatText.SetHorizontalAlignCenter()
        self.defeatText.SetText("")
        self.defeatText.SetPackedFontColor(0x00FF0000)
        self.defeatText.SetOutline()
        self.defeatText.Show()

        self.penaltyText = ui.TextLine()
        self.penaltyText.SetParent(self)
        self.penaltyText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 + 20)
        self.penaltyText.SetHorizontalAlignCenter()
        self.penaltyText.SetText("")
        self.penaltyText.SetPackedFontColor(0x00FFFFFF)
        self.penaltyText.SetOutline()
        self.penaltyText.Show()

    def Start(self, penalty):
        self.penalty = penalty
        self.startTime = app.GetTime()
        self.defeatText.SetText("S E I   C A D U T O")
        self.penaltyText.SetText("-" + str(penalty) + " GLORIA")
        self.Show()
        self.SetTop()

    def OnUpdate(self):
        if not self.IsShow():
            return
        elapsed = app.GetTime() - self.startTime
        if elapsed < 0.2:
            self.flash.SetColor((int((1 - elapsed / 0.2) * 200) << 24) | 0xFF0000)
        else:
            self.flash.SetColor(0x00FF0000)
        if elapsed >= 0.2 and elapsed < 1.0:
            bgProgress = (elapsed - 0.2) / 0.8
            self.bg.SetColor((int(bgProgress * 180) << 24) | 0x0a0000)
            crackAlpha = int(bgProgress * 255)
            for i, crack in enumerate(self.cracks):
                crack.SetPosition(int(self.screenWidth * (0.2 + i * 0.12)), int(self.screenHeight * 0.1))
                crack.SetSize(2, int(self.screenHeight * bgProgress * 0.8))
                crack.SetColor((crackAlpha << 24) | 0x1a0000)
        if elapsed >= 1.5 and elapsed < 2.5:
            textAlpha = int((elapsed - 1.5) / 1.0 * 255)
            self.defeatText.SetPackedFontColor((textAlpha << 24) | 0xFF0000)
            self.penaltyText.SetPackedFontColor((textAlpha << 24) | 0xFF4444)
        if elapsed >= 3.5:
            alpha = int((1 - (elapsed - 3.5) / 1.0) * 255)
            self.bg.SetColor((int((1 - (elapsed - 3.5) / 1.0) * 180) << 24) | 0x0a0000)
            self.defeatText.SetPackedFontColor((alpha << 24) | 0xFF0000)
            self.penaltyText.SetPackedFontColor((alpha << 24) | 0xFF4444)
            for crack in self.cracks:
                crack.SetColor((alpha << 24) | 0x1a0000)
        if elapsed >= 4.5:
            self.Hide()

class TrialProgressPopup(ui.Window):
    def __init__(self):
        ui.Window.__init__(self)
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.boxWidth = 280
        self.boxHeight = 70
        self.SetSize(self.boxWidth, self.boxHeight)
        self.SetPosition(self.screenWidth - self.boxWidth - 20, 150)
        self.AddFlag("not_pick")
        self.startTime = 0
        self.queue = []
        self.currentPopup = None
        self.__BuildUI()
        self.Hide()

    def __BuildUI(self):
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(self.boxWidth, self.boxHeight)
        self.bg.SetColor(0xDD1a1a1a)
        self.bg.AddFlag("not_pick")
        self.bg.Show()

        self.border = ui.Bar()
        self.border.SetParent(self)
        self.border.SetPosition(0, 0)
        self.border.SetSize(self.boxWidth, 3)
        self.border.SetColor(0xFFFFD700)
        self.border.AddFlag("not_pick")
        self.border.Show()

        self.iconText = ui.TextLine()
        self.iconText.SetParent(self)
        self.iconText.SetPosition(15, 25)
        self.iconText.SetText("")
        self.iconText.SetPackedFontColor(0xFFFFFFFF)
        self.iconText.SetOutline()
        self.iconText.Show()

        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(50, 15)
        self.titleText.SetText("")
        self.titleText.SetPackedFontColor(0xFFFFFFFF)
        self.titleText.SetOutline()
        self.titleText.Show()

        self.progressText = ui.TextLine()
        self.progressText.SetParent(self)
        self.progressText.SetPosition(50, 40)
        self.progressText.SetText("")
        self.progressText.SetPackedFontColor(0xFFFFD700)
        self.progressText.SetOutline()
        self.progressText.Show()

    def AddPopup(self, progressType, current, required):
        self.queue.append({"type": progressType, "current": current, "required": required})
        if not self.IsShow():
            self.__ShowNext()

    def __ShowNext(self):
        if not self.queue:
            self.Hide()
            return
        self.currentPopup = self.queue.pop(0)
        self.startTime = app.GetTime()
        pType = self.currentPopup["type"]
        current = self.currentPopup["current"]
        required = self.currentPopup["required"]
        configs = {
            "boss": {"icon": "[B]", "title": "BOSS UCCISO", "color": 0xFFFF0000},
            "metin": {"icon": "[M]", "title": "METIN DISTRUTTO", "color": 0xFF00FFFF},
            "fracture": {"icon": "[F]", "title": "FRATTURA SIGILLATA", "color": 0xFF9900FF},
            "chest": {"icon": "[C]", "title": "BAULE APERTO", "color": 0xFFFFD700},
            "mission": {"icon": "[Q]", "title": "MISSIONE COMPLETATA", "color": 0xFF00FF00},
        }
        config = configs.get(pType, {"icon": "[?]", "title": "PROGRESSO", "color": 0xFFFFFFFF})
        self.iconText.SetText(config["icon"])
        self.iconText.SetPackedFontColor(config["color"])
        self.titleText.SetText(config["title"])
        self.titleText.SetPackedFontColor(config["color"])
        self.border.SetColor(config["color"])
        self.progressText.SetText(str(current) + " / " + str(required))
        self.SetPosition(self.screenWidth, 150)
        self.Show()
        self.SetTop()

    def OnUpdate(self):
        if not self.IsShow():
            return
        elapsed = app.GetTime() - self.startTime
        if elapsed < 0.3:
            xPos = int(self.screenWidth - (self.boxWidth + 20) * (elapsed / 0.3))
            self.SetPosition(xPos, 150)
        elif elapsed < 2.0:
            self.SetPosition(self.screenWidth - self.boxWidth - 20, 150)
        elif elapsed < 2.5:
            xPos = int(self.screenWidth - self.boxWidth - 20 + (self.boxWidth + 40) * ((elapsed - 2.0) / 0.5))
            self.SetPosition(xPos, 150)
        else:
            self.__ShowNext()

# GLOBAL INSTANCES
g_gateEntryEffect = None
g_gateVictoryEffect = None
g_gateDefeatEffect = None
g_trialProgressPopup = None

# PUBLIC API
def ShowGateEntry(gateName, colorCode):
    global g_gateEntryEffect
    if g_gateEntryEffect is None:
        g_gateEntryEffect = GateEntryEffect()
    g_gateEntryEffect.Start(gateName, colorCode)

def ShowGateVictory(gateName, gloria):
    global g_gateVictoryEffect
    if g_gateVictoryEffect is None:
        g_gateVictoryEffect = GateVictoryEffect()
    g_gateVictoryEffect.Start(gateName, gloria)

def ShowGateDefeat(penalty):
    global g_gateDefeatEffect
    if g_gateDefeatEffect is None:
        g_gateDefeatEffect = GateDefeatEffect()
    g_gateDefeatEffect.Start(penalty)

def ShowTrialProgress(progressType, current, required):
    global g_trialProgressPopup
    if g_trialProgressPopup is None:
        g_trialProgressPopup = TrialProgressPopup()
    g_trialProgressPopup.AddPopup(progressType, current, required)
