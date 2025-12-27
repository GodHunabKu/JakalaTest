# -*- coding: utf-8 -*-
import ui
import wndMgr
import app

AWAKENING_CONFIG = {
    5: {"name": "RISVEGLIO INIZIALE", "color": 0xFF808080, "duration": 4.0},
    10: {"name": "PRIMA SCINTILLA", "color": 0xFF00FF00, "duration": 4.0},
    15: {"name": "AURA NASCENTE", "color": 0xFF00FF00, "duration": 4.0},
    20: {"name": "SECONDO RISVEGLIO", "color": 0xFF00FFFF, "duration": 5.0},
    25: {"name": "POTERE CRESCENTE", "color": 0xFF00FFFF, "duration": 5.0},
    30: {"name": "RISVEGLIO HUNTER", "color": 0xFF0066FF, "duration": 8.0},
    40: {"name": "CONSOLIDAMENTO", "color": 0xFF0066FF, "duration": 5.0},
    50: {"name": "META DEL CAMMINO", "color": 0xFFAA00FF, "duration": 6.0},
    60: {"name": "POTERE MATURO", "color": 0xFFAA00FF, "duration": 5.0},
    70: {"name": "RISVEGLIO AVANZATO", "color": 0xFFFF6600, "duration": 6.0},
    80: {"name": "MAESTRIA NASCENTE", "color": 0xFFFF6600, "duration": 5.0},
    90: {"name": "SOGLIA DELLA LEGGENDA", "color": 0xFFFF0000, "duration": 6.0},
    100: {"name": "CENTENARIO", "color": 0xFFFFD700, "duration": 8.0},
    110: {"name": "OLTRE IL LIMITE", "color": 0xFFFFD700, "duration": 6.0},
    120: {"name": "ASCENSIONE", "color": 0xFFFF00FF, "duration": 8.0},
    130: {"name": "LEGGENDA VIVENTE", "color": 0xFFFF0000, "duration": 8.0},
}

RANK_COLORS = {
    "E": 0xFF808080, "D": 0xFF00FF00, "C": 0xFF00FFFF,
    "B": 0xFF0066FF, "A": 0xFFAA00FF, "S": 0xFFFF6600, "N": 0xFFFF0000,
}

RANK_MESSAGES = {
    "D": "Hai superato la mediocrità",
    "C": "Il tuo potere cresce",
    "B": "Sei degno di rispetto",
    "A": "I deboli ti temono",
    "S": "Sei tra i migliori",
    "N": "SEI UN MONARCA!",
}

class AwakeningEffect(ui.Window):
    def __init__(self):
        ui.Window.__init__(self)
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.startTime = 0
        self.duration = 5.0
        self.level = 5
        self.config = None
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
            ring.SetColor(0x00FFFFFF)
            ring.AddFlag("not_pick")
            ring.Show()
            self.rings.append(ring)

        self.levelText = ui.TextLine()
        self.levelText.SetParent(self)
        self.levelText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 - 80)
        self.levelText.SetHorizontalAlignCenter()
        self.levelText.SetText("")
        self.levelText.SetPackedFontColor(0x00FFFFFF)
        self.levelText.SetOutline()
        self.levelText.Show()

        self.nameText = ui.TextLine()
        self.nameText.SetParent(self)
        self.nameText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 - 40)
        self.nameText.SetHorizontalAlignCenter()
        self.nameText.SetText("")
        self.nameText.SetPackedFontColor(0x00FFFFFF)
        self.nameText.SetOutline()
        self.nameText.Show()

        self.msgText = ui.TextLine()
        self.msgText.SetParent(self)
        self.msgText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 + 20)
        self.msgText.SetHorizontalAlignCenter()
        self.msgText.SetText("")
        self.msgText.SetPackedFontColor(0x00FFFFFF)
        self.msgText.SetOutline()
        self.msgText.Show()

    def Start(self, level):
        self.level = level
        self.config = AWAKENING_CONFIG.get(level, {"name": "LEVEL UP", "color": 0xFFFFFFFF, "duration": 4.0})
        self.duration = self.config["duration"]
        self.startTime = app.GetTime()
        self.levelText.SetText("LEVEL " + str(level))
        self.nameText.SetText(self.config["name"])
        self.msgText.SetText("Il tuo potere si risveglia!")
        self.Show()
        self.SetTop()

    def OnUpdate(self):
        if not self.IsShow():
            return
        elapsed = app.GetTime() - self.startTime
        color = self.config["color"]

        if elapsed < 0.3:
            self.flash.SetColor((int((1 - elapsed / 0.3) * 150) << 24) | (color & 0xFFFFFF))
        else:
            self.flash.SetColor(0x00FFFFFF)

        if elapsed < 0.5:
            self.bg.SetColor((int(elapsed / 0.5 * 200) << 24) | 0x000000)
        elif elapsed < self.duration - 1.0:
            self.bg.SetColor(0xC8000000)
        else:
            fadeOut = (elapsed - (self.duration - 1.0)) / 1.0
            self.bg.SetColor((int((1 - fadeOut) * 200) << 24) | 0x000000)

        if elapsed >= 0.5 and elapsed < 2.0:
            for i, ring in enumerate(self.rings):
                ringStart = 0.5 + i * 0.3
                if elapsed >= ringStart:
                    ringProgress = min(1.0, (elapsed - ringStart) / 1.0)
                    ringSize = int(50 + ringProgress * 250)
                    ring.SetSize(ringSize, ringSize)
                    ring.SetPosition(self.screenWidth // 2 - ringSize // 2, self.screenHeight // 2 - ringSize // 2)
                    ring.SetColor((int((1 - ringProgress) * 150) << 24) | (color & 0xFFFFFF))

        if elapsed >= 0.8 and elapsed < 2.0:
            textAlpha = int(min(1.0, (elapsed - 0.8) / 0.5) * 255)
            self.levelText.SetPackedFontColor((textAlpha << 24) | 0xFFFFFF)
            self.nameText.SetPackedFontColor((textAlpha << 24) | (color & 0xFFFFFF))
            self.msgText.SetPackedFontColor((textAlpha << 24) | 0xAAAAAA)
        elif elapsed >= self.duration - 1.0:
            fadeOut = (elapsed - (self.duration - 1.0)) / 1.0
            alpha = int((1 - fadeOut) * 255)
            self.levelText.SetPackedFontColor((alpha << 24) | 0xFFFFFF)
            self.nameText.SetPackedFontColor((alpha << 24) | (color & 0xFFFFFF))
            self.msgText.SetPackedFontColor((alpha << 24) | 0xAAAAAA)

        if elapsed >= self.duration:
            self.Hide()

class RankUpEffect(ui.Window):
    def __init__(self):
        ui.Window.__init__(self)
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.startTime = 0
        self.oldRank = "E"
        self.newRank = "D"
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

        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 - 80)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("")
        self.titleText.SetPackedFontColor(0x00FFD700)
        self.titleText.SetOutline()
        self.titleText.Show()

        self.oldRankText = ui.TextLine()
        self.oldRankText.SetParent(self)
        self.oldRankText.SetPosition(self.screenWidth // 2 - 80, self.screenHeight // 2)
        self.oldRankText.SetHorizontalAlignCenter()
        self.oldRankText.SetText("")
        self.oldRankText.SetPackedFontColor(0x00FFFFFF)
        self.oldRankText.SetOutline()
        self.oldRankText.Show()

        self.arrowText = ui.TextLine()
        self.arrowText.SetParent(self)
        self.arrowText.SetPosition(self.screenWidth // 2, self.screenHeight // 2)
        self.arrowText.SetHorizontalAlignCenter()
        self.arrowText.SetText("")
        self.arrowText.SetPackedFontColor(0x00FFD700)
        self.arrowText.SetOutline()
        self.arrowText.Show()

        self.newRankText = ui.TextLine()
        self.newRankText.SetParent(self)
        self.newRankText.SetPosition(self.screenWidth // 2 + 80, self.screenHeight // 2)
        self.newRankText.SetHorizontalAlignCenter()
        self.newRankText.SetText("")
        self.newRankText.SetPackedFontColor(0x00FFFFFF)
        self.newRankText.SetOutline()
        self.newRankText.Show()

        self.msgText = ui.TextLine()
        self.msgText.SetParent(self)
        self.msgText.SetPosition(self.screenWidth // 2, self.screenHeight // 2 + 60)
        self.msgText.SetHorizontalAlignCenter()
        self.msgText.SetText("")
        self.msgText.SetPackedFontColor(0x00FFFFFF)
        self.msgText.SetOutline()
        self.msgText.Show()

    def Start(self, oldRank, newRank):
        self.oldRank = oldRank
        self.newRank = newRank
        self.startTime = app.GetTime()
        self.titleText.SetText("R A N K   U P")
        self.oldRankText.SetText(oldRank + "-RANK")
        self.arrowText.SetText(">>>")
        self.newRankText.SetText(newRank + "-RANK")
        self.msgText.SetText(RANK_MESSAGES.get(newRank, "Congratulazioni!"))
        self.Show()
        self.SetTop()

    def OnUpdate(self):
        if not self.IsShow():
            return
        elapsed = app.GetTime() - self.startTime
        newColor = RANK_COLORS.get(self.newRank, 0xFFFFFFFF)
        oldColor = RANK_COLORS.get(self.oldRank, 0xFF808080)

        if elapsed < 0.5:
            self.flash.SetColor((int((1 - elapsed / 0.5) * 200) << 24) | 0xFFFFFF)
            self.bg.SetColor((int(elapsed / 0.5 * 220) << 24) | 0x000000)
        else:
            self.flash.SetColor(0x00FFFFFF)
            self.bg.SetColor(0xDC000000)

        if elapsed >= 1.0 and elapsed < 2.5:
            textAlpha = int(min(1.0, (elapsed - 1.0) / 0.5) * 255)
            self.titleText.SetPackedFontColor((textAlpha << 24) | 0xFFD700)
            self.oldRankText.SetPackedFontColor((textAlpha << 24) | (oldColor & 0xFFFFFF))
            self.arrowText.SetPackedFontColor((textAlpha << 24) | 0xFFD700)
            self.newRankText.SetPackedFontColor((textAlpha << 24) | (newColor & 0xFFFFFF))
            self.msgText.SetPackedFontColor((textAlpha << 24) | 0xFFFFFF)

        if elapsed >= 5.5:
            fadeOut = (elapsed - 5.5) / 1.5
            alpha = int((1 - fadeOut) * 255)
            self.bg.SetColor((int((1 - fadeOut) * 220) << 24) | 0x000000)
            self.titleText.SetPackedFontColor((alpha << 24) | 0xFFD700)
            self.oldRankText.SetPackedFontColor((alpha << 24) | (oldColor & 0xFFFFFF))
            self.arrowText.SetPackedFontColor((alpha << 24) | 0xFFD700)
            self.newRankText.SetPackedFontColor((alpha << 24) | (newColor & 0xFFFFFF))
            self.msgText.SetPackedFontColor((alpha << 24) | 0xFFFFFF)

        if elapsed >= 7.0:
            self.Hide()

# GLOBAL INSTANCES
g_awakeningEffect = None
g_rankUpEffect = None

# PUBLIC API
def ShowAwakening(level):
    global g_awakeningEffect
    if g_awakeningEffect is None:
        g_awakeningEffect = AwakeningEffect()
    g_awakeningEffect.Start(level)

def ShowRankUp(oldRank, newRank):
    global g_rankUpEffect
    if g_rankUpEffect is None:
        g_rankUpEffect = RankUpEffect()
    g_rankUpEffect.Start(oldRank, newRank)

def CheckAndShowAwakening(level):
    if level in AWAKENING_CONFIG:
        ShowAwakening(level)
        return True
    return False
