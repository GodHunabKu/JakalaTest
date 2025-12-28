# -*- coding: utf-8 -*-
# ============================================================
# HUNTER SYSTEM - SOLO LEVELING UI REDESIGN
# Design Epico stile Solo Leveling (System Interface)
# ============================================================

import ui
import net
import chat
import app
import wndMgr
import grp

# ============================================================
# CONFIGURAZIONE COLORI & STILE
# ============================================================

# Colori base del sistema (ARGB)
COLOR_BG_DARK = 0xCC000000          # Sfondo nero 80% opacità
COLOR_BG_HOVER = 0x44FFFFFF         # Hover leggero
COLOR_TEXT_NORMAL = 0xFFFFFFFF
COLOR_TEXT_MUTED = 0xFFAAAAAA

# Schemi colori per Fratture (Corretti e Vibranti)
# Usiamo .upper() nel codice per evitare problemi di case-sensitivity
FRACTURE_SCHEMES = {
    "GREEN": {
        "border": 0xFF00FF00,       # Verde Neon
        "glow": 0x4400FF00,
        "title": 0xFF55FF55,
        "text": 0xFFDDFFDD
    },
    "BLUE": {
        "border": 0xFF0099FF,       # Blu System
        "glow": 0x440099FF,
        "title": 0xFF00CCFF,
        "text": 0xFFDDFFFF
    },
    "ORANGE": {
        "border": 0xFFFF6600,       # Arancione Fuoco
        "glow": 0x44FF6600,
        "title": 0xFFFFAA00,
        "text": 0xFFFFDDBB
    },
    "RED": {
        "border": 0xFFFF0000,       # Rosso Sangue
        "glow": 0x44FF0000,
        "title": 0xFFFF4444,
        "text": 0xFFFFDDDD
    },
    "GOLD": {
        "border": 0xFFFFD700,       # Oro
        "glow": 0x44FFD700,
        "title": 0xFFFFEE55,
        "text": 0xFFFFFFDD
    },
    "PURPLE": {
        "border": 0xFF9900FF,       # Viola Ombra
        "glow": 0x449900FF,
        "title": 0xFFCC55FF,
        "text": 0xFFEEDDFF
    },
    "BLACKWHITE": {
        "border": 0xFFFFFFFF,       # Bianco Puro
        "glow": 0x44FFFFFF,
        "title": 0xFFEEEEEE,
        "text": 0xFFCCCCCC
    },
}

# Mappatura ID Frattura -> Colore (Per sicurezza)
FRACTURE_ID_MAP = {
    # VNUM Fratture (Se il server invia il VNUM)
    "16060": "GREEN",       # Frattura Primordiale
    "16061": "BLUE",        # Frattura Astrale
    "16062": "ORANGE",      # Frattura Abissale
    "16063": "RED",         # Frattura Cremisi
    "16064": "GOLD",        # Frattura Aurea
    "16065": "PURPLE",      # Frattura Infausta
    "16066": "BLACKWHITE",  # Frattura del Giudizio
    
    # ID Domande dal DB (Se il server invia l'ID domanda)
    "power_offer": "PURPLE",
    "save_npc": "BLUE",
    "dark_pact": "RED",
    "rival_mercy": "ORANGE",
    "treasure_split": "GOLD",
}

# Fallback se il colore non viene trovato
DEFAULT_SCHEME = FRACTURE_SCHEMES["PURPLE"]

# ============================================================
# COMPONENTI UI CUSTOM (SOLO LEVELING STYLE)
# ============================================================

class SoloLevelingWindow(ui.ScriptWindow):
    """Finestra base con stile System (Sfondo scuro + Bordi colorati)"""
    def __init__(self, width, height, color_scheme=None):
        ui.ScriptWindow.__init__(self)
        self.color_scheme = color_scheme if color_scheme else DEFAULT_SCHEME
        self.SetSize(width, height)
        self.__BuildInterface(width, height)
        
    def __BuildInterface(self, w, h):
        # Sfondo
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(w, h)
        self.bg.SetColor(COLOR_BG_DARK)
        self.bg.Show()
        
        # Bordi (Top, Bottom, Left, Right)
        self.borders = []
        # Top
        b1 = ui.Bar(); b1.SetParent(self); b1.SetPosition(0, 0); b1.SetSize(w, 2); b1.Show()
        # Bottom
        b2 = ui.Bar(); b2.SetParent(self); b2.SetPosition(0, h-2); b2.SetSize(w, 2); b2.Show()
        # Left
        b3 = ui.Bar(); b3.SetParent(self); b3.SetPosition(0, 0); b3.SetSize(2, h); b3.Show()
        # Right
        b4 = ui.Bar(); b4.SetParent(self); b4.SetPosition(w-2, 0); b4.SetSize(2, h); b4.Show()
        
        self.borders = [b1, b2, b3, b4]
        self.UpdateColors()
            
    def SetColorScheme(self, scheme):
        self.color_scheme = scheme
        self.UpdateColors()
        
    def UpdateColors(self):
        for bar in self.borders:
            bar.SetColor(self.color_scheme["border"])

class SystemButton(ui.Window):
    """Bottone stile System (Flat con hover glow)"""
    def __init__(self, parent, x, y, width, text, color_scheme, event):
        ui.Window.__init__(self)
        self.SetParent(parent)
        self.SetPosition(x, y)
        self.SetSize(width, 30)
        
        self.color_scheme = color_scheme
        self.event = event
        
        # Sfondo bottone
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetSize(width, 30)
        self.bg.SetColor(0x66000000)
        self.bg.AddFlag("not_pick")
        self.bg.Show()
        
        # Bordo inferiore
        self.border = ui.Bar()
        self.border.SetParent(self)
        self.border.SetPosition(0, 29)
        self.border.SetSize(width, 1)
        self.border.SetColor(color_scheme["border"])
        self.border.AddFlag("not_pick")
        self.border.Show()
        
        # Testo
        self.textLine = ui.TextLine()
        self.textLine.SetParent(self)
        self.textLine.SetPosition(width/2, 8)
        self.textLine.SetHorizontalAlignCenter()
        self.textLine.SetText(text)
        self.textLine.SetPackedFontColor(color_scheme["title"])
        self.textLine.Show()
        
        self.Show()
        
    def OnMouseOverIn(self):
        self.bg.SetColor(self.color_scheme["glow"])
        
    def OnMouseOverOut(self):
        self.bg.SetColor(0x66000000)
        
    def OnMouseLeftButtonUp(self):
        if self.event:
            self.event()


# ============================================================
# FINESTRE PRINCIPALI
# ============================================================

class WhatIfChoiceWindow(SoloLevelingWindow):
    """Finestra di scelta What-If"""
    def __init__(self):
        # Dimensione iniziale placeholder
        SoloLevelingWindow.__init__(self, 400, 300)
        self.questionId = ""
        self.buttons = []
        self.textLines = []
        self.AddFlag("float")
        self.AddFlag("movable")
        
        # Header "SYSTEM"
        self.headerText = ui.TextLine()
        self.headerText.SetParent(self)
        self.headerText.SetPosition(200, 10)
        self.headerText.SetHorizontalAlignCenter()
        self.headerText.SetText("SYSTEM")
        self.headerText.SetOutline()
        self.headerText.Show()
        
        self.subHeaderText = ui.TextLine()
        self.subHeaderText.SetParent(self)
        self.subHeaderText.SetPosition(200, 30)
        self.subHeaderText.SetHorizontalAlignCenter()
        self.subHeaderText.SetText("Una scelta è richiesta.")
        self.subHeaderText.SetPackedFontColor(COLOR_TEXT_MUTED)
        self.subHeaderText.Show()

    def Create(self, qid, text, options, colorCode="PURPLE"):
        self.questionId = qid
        
        # DEBUG: Mostra in chat ID e Colore ricevuto
        chat.AppendChat(chat.CHAT_TYPE_INFO, "[DEBUG] ID: %s | Color: %s" % (str(qid), str(colorCode)))
        
        # Pulizia input
        if colorCode:
            colorCode = colorCode.strip()
        
        # 1. Tenta di mappare l'ID al colore (Priorità assoluta)
        mappedColor = FRACTURE_ID_MAP.get(str(qid), None)
        if mappedColor:
            colorCode = mappedColor
            
        # 2. AUTO-DETECT: Se il colore non è valido, indovinalo dal testo (Safety Net)
        if not colorCode or colorCode not in FRACTURE_SCHEMES:
            upperText = text.upper()
            if "PRIMORDIALE" in upperText: colorCode = "GREEN"
            elif "ASTRALE" in upperText: colorCode = "BLUE"
            elif "ABISSALE" in upperText: colorCode = "ORANGE"
            elif "CREMISI" in upperText: colorCode = "RED"
            elif "AUREA" in upperText: colorCode = "GOLD"
            elif "INFAUSTA" in upperText: colorCode = "PURPLE"
            elif "GIUDIZIO" in upperText: colorCode = "BLACKWHITE"
        
        # 3. Applica schema colori
        scheme = FRACTURE_SCHEMES.get(colorCode.upper(), DEFAULT_SCHEME)
        self.SetColorScheme(scheme)
        self.headerText.SetPackedFontColor(scheme["title"])
        
        # Reset UI
        self.buttons = []
        self.textLines = []
        
        # Parsa testo
        lines = text.replace("+", " ").split("|")
        
        # Calcola layout
        baseY = 60
        lineHeight = 20
        windowWidth = 400
        
        # Crea righe testo
        for line in lines:
            t = ui.TextLine()
            t.SetParent(self)
            t.SetPosition(windowWidth/2, baseY)
            t.SetHorizontalAlignCenter()
            t.SetText(line)
            t.SetPackedFontColor(COLOR_TEXT_NORMAL)
            t.Show()
            self.textLines.append(t)
            baseY += lineHeight
            
        baseY += 15
        
        # Crea bottoni
        for i, opt in enumerate(options):
            if not opt: continue

            # FIX: Usa closure che non cattura self direttamente per evitare memory leak
            # Invece di lambda che cattura self, usiamo una funzione wrapper
            def make_event(idx, callback):
                def _wrapper():
                    callback(idx)
                return _wrapper

            btn = SystemButton(self, 20, baseY, windowWidth-40, opt.replace("+", " "), scheme,
                             make_event(i+1, ui.__mem_func__(self.__OnClickOption)))
            self.buttons.append(btn)
            baseY += 40
            
        # Ridimensiona finestra
        totalHeight = baseY + 10
        self.SetSize(windowWidth, totalHeight)
        self.bg.SetSize(windowWidth, totalHeight)
        
        # Aggiorna bordi
        self.borders[1].SetPosition(0, totalHeight-2) # Bottom
        self.borders[2].SetSize(2, totalHeight)       # Left
        self.borders[3].SetSize(2, totalHeight)       # Right
        self.borders[3].SetPosition(windowWidth-2, 0)
        
        # Centra nello schermo
        screenWidth = wndMgr.GetScreenWidth()
        screenHeight = wndMgr.GetScreenHeight()
        self.SetPosition((screenWidth - windowWidth) / 2, (screenHeight - totalHeight) / 3)
        
        self.Show()
        self.SetTop()
        
    def __OnClickOption(self, val):
        net.SendChatPacket("/hunter_whatif_answer %s %d" % (self.questionId, val))
        self.Close()
        
    def Close(self):
        self.Hide()

    def Destroy(self):
        """Cleanup completo per evitare memory leak"""
        # Pulisci event handler dai button
        for btn in self.buttons:
            if hasattr(btn, 'event'):
                btn.event = None
        self.buttons = []
        self.textLines = []
        self.Hide()

    def OnKeyDown(self, key):
        if key == app.DIK_ESCAPE:
            # Opzionale: Se vuoi che ESC chiuda o selezioni l'ultima opzione
            if len(self.buttons) >= 3:
                self.__OnClickOption(3)
            else:
                self.Close()
            return True
        return False  # Passa gli altri tasti al gioco


class SystemMessageWindow(ui.Window):
    """Messaggio di sistema con colori dinamici basati sul rank + CODA MESSAGGI"""
    def __init__(self):
        ui.Window.__init__(self)
        self.SetSize(500, 60)
        screenWidth = wndMgr.GetScreenWidth()
        self.SetPosition((screenWidth - 500) / 2, 280)  # Più in basso per non coprire i messaggi
        self.AddFlag("not_pick")
        self.AddFlag("float")

        self.currentColor = 0xFF0099FF  # Default blu

        # FIX: Sistema coda messaggi per evitare sovrapposizioni
        self.messageQueue = []
        self.currentMessage = None
        self.messageDelay = 4.0  # 4 secondi per messaggio

        # Sfondo
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(500, 60)
        self.bg.SetColor(COLOR_BG_DARK)
        self.bg.Show()

        # Bordi (salvati per aggiornamento colori)
        self.borders = []
        color = FRACTURE_SCHEMES["BLUE"]["border"]
        # Top
        b1 = ui.Bar(); b1.SetParent(self); b1.SetPosition(0, 0); b1.SetSize(500, 2); b1.SetColor(color); b1.Show()
        self.borders.append(b1)
        # Bottom
        b2 = ui.Bar(); b2.SetParent(self); b2.SetPosition(0, 58); b2.SetSize(500, 2); b2.SetColor(color); b2.Show()
        self.borders.append(b2)
        # Left
        b3 = ui.Bar(); b3.SetParent(self); b3.SetPosition(0, 0); b3.SetSize(2, 60); b3.SetColor(color); b3.Show()
        self.borders.append(b3)
        # Right
        b4 = ui.Bar(); b4.SetParent(self); b4.SetPosition(498, 0); b4.SetSize(2, 60); b4.SetColor(color); b4.Show()
        self.borders.append(b4)

        self.text = ui.TextLine()
        self.text.SetParent(self)
        self.text.SetPosition(250, 20)
        self.text.SetHorizontalAlignCenter()
        self.text.SetPackedFontColor(FRACTURE_SCHEMES["BLUE"]["title"])
        self.text.SetOutline()
        self.text.Show()

        self.endTime = 0

    def __UpdateColors(self, color):
        """Aggiorna i colori dei bordi e del testo"""
        self.currentColor = color
        for b in self.borders:
            b.SetColor(color)
        self.text.SetPackedFontColor(color)

    def __GetColorFromKey(self, colorKey):
        """Converte chiave colore (E,D,C,BLUE,GREEN...) in intero"""
        # Colori per rank giocatore
        RANK_COLORS = {
            "E": 0xFF808080,  # Grigio
            "D": 0xFF00FF00,  # Verde
            "C": 0xFF00FFFF,  # Cyan
            "B": 0xFF0066FF,  # Blu
            "A": 0xFFAA00FF,  # Viola
            "S": 0xFFFF6600,  # Arancione
            "N": 0xFFFF0000,  # Rosso
        }
        # Colori per fratture
        FRACTURE_COLORS = {
            "GREEN": 0xFF00FF00,       # Verde Neon
            "BLUE": 0xFF0099FF,        # Blu System
            "ORANGE": 0xFFFF6600,      # Arancione Fuoco
            "RED": 0xFFFF0000,         # Rosso Sangue
            "GOLD": 0xFFFFD700,        # Oro
            "PURPLE": 0xFF9900FF,      # Viola Ombra
            "BLACKWHITE": 0xFFFFFFFF,  # Bianco
        }
        # Prova prima i colori frattura, poi i rank
        return FRACTURE_COLORS.get(colorKey, RANK_COLORS.get(colorKey, 0xFF808080))

    def ShowMessage(self, msg, color=None):
        """
        FIX: Aggiungi messaggio alla CODA invece di mostrare subito
        Questo previene che i messaggi si sovrascrivano
        """
        # Ricalcola posizione per sicurezza
        screenWidth = wndMgr.GetScreenWidth()
        self.SetPosition((screenWidth - 500) / 2, 280)  # Più in basso

        # Determina colore
        finalColor = self.currentColor
        if color:
            # FIX: In Python 2, numeri grandi sono 'long', non 'int'
            if isinstance(color, (int, long)):
                finalColor = color
            else:
                finalColor = self.__GetColorFromKey(color)

        # DEBUG: Log final color
        import dbg
        dbg.TraceError("[PY-DEBUG] SystemMessageWindow.ShowMessage: color=%s, finalColor=0x%X" % (str(color), finalColor))

        # Aggiungi alla coda
        self.messageQueue.append((msg.replace("+", " "), finalColor))

        # Se non c'è messaggio corrente, mostra subito il prossimo
        if not self.currentMessage:
            self.ShowNextMessage()

    def ShowNextMessage(self):
        """Mostra il prossimo messaggio in coda"""
        if len(self.messageQueue) > 0:
            msg, color = self.messageQueue.pop(0)

            # Aggiorna visuale
            self.__UpdateColors(color)
            self.text.SetText(msg)

            # Salva messaggio corrente
            self.currentMessage = msg
            self.endTime = app.GetTime() + self.messageDelay

            # Mostra finestra
            self.Show()
            self.SetTop()
        else:
            self.currentMessage = None

    def SetRankColor(self, colorKey):
        """Imposta il colore e aggiorna visivamente - supporta sia rank (E,D,C...) che fratture (GREEN,BLUE...)"""
        color = self.__GetColorFromKey(colorKey)
        self.__UpdateColors(color)

    def OnUpdate(self):
        """FIX: Quando il messaggio scade, mostra il prossimo in coda"""
        if self.endTime > 0 and app.GetTime() > self.endTime:
            self.Hide()
            self.endTime = 0
            self.currentMessage = None
            # Mostra il prossimo messaggio se ce ne sono
            self.ShowNextMessage()

    def GetQueueLength(self):
        """Ritorna il numero di messaggi in coda (per debug)"""
        return len(self.messageQueue)

    def ClearQueue(self):
        """Svuota la coda messaggi (per situazioni speciali)"""
        self.messageQueue = []
        self.Hide()
        self.currentMessage = None
        self.endTime = 0


class EmergencyQuestWindow(ui.Window):
    """Emergency Quest (Red Box)"""
    def __init__(self):
        ui.Window.__init__(self)
        self.SetSize(300, 100)
        screenWidth = wndMgr.GetScreenWidth()
        # Posizionato sotto il messaggio di sistema (Y=150 + 60 + 10 padding = 220)
        self.SetPosition((screenWidth - 300) / 2, 220)
        self.AddFlag("float")
        
        # Sfondo Rosso Scuro
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(300, 100)
        self.bg.SetColor(0xCC330000) 
        self.bg.Show()
        
        # Bordi Rossi
        color = FRACTURE_SCHEMES["RED"]["border"]
        # Top/Bottom
        for y in [0, 98]:
            b = ui.Bar(); b.SetParent(self); b.SetPosition(0, y); b.SetSize(300, 2); b.SetColor(color); b.Show()
        # Left/Right
        for x in [0, 298]:
            b = ui.Bar(); b.SetParent(self); b.SetPosition(x, 0); b.SetSize(2, 100); b.SetColor(color); b.Show()
        
        self.title = ui.TextLine()
        self.title.SetParent(self)
        self.title.SetPosition(150, 10)
        self.title.SetHorizontalAlignCenter()
        self.title.SetText("! EMERGENCY QUEST !")
        self.title.SetPackedFontColor(FRACTURE_SCHEMES["RED"]["title"])
        self.title.SetOutline()
        self.title.Show()
        
        self.questName = ui.TextLine()
        self.questName.SetParent(self)
        self.questName.SetPosition(150, 35)
        self.questName.SetHorizontalAlignCenter()
        self.questName.SetText("")
        self.questName.SetPackedFontColor(COLOR_TEXT_NORMAL)
        self.questName.Show()
        
        self.timer = ui.TextLine()
        self.timer.SetParent(self)
        self.timer.SetPosition(150, 60)
        self.timer.SetHorizontalAlignCenter()
        self.timer.SetPackedFontColor(FRACTURE_SCHEMES["GOLD"]["title"])
        self.timer.SetOutline()
        self.timer.Show()
        
        self.endTime = 0
        self.currentTitle = ""
        self.targetCount = 0
        
    def StartMission(self, title, seconds, mobVnum, count):
        self.currentTitle = title.replace("+", " ")
        self.targetCount = count
        self.UpdateProgress(0)
        self.endTime = app.GetTime() + seconds
        self.Show()
        self.SetTop()
        
    def UpdateProgress(self, current):
        if self.targetCount > 0:
            self.questName.SetText("%s [%d/%d]" % (self.currentTitle, current, self.targetCount))
        else:
            self.questName.SetText(self.currentTitle)
        
    def EndMission(self, status):
        if status == "SUCCESS":
            self.title.SetText("MISSION COMPLETE")
            self.title.SetPackedFontColor(FRACTURE_SCHEMES["GREEN"]["title"])
        else:
            self.title.SetText("MISSION FAILED")
            self.title.SetPackedFontColor(FRACTURE_SCHEMES["RED"]["title"])
        self.endTime = app.GetTime() + 3.0

    def OnUpdate(self):
        if self.endTime > 0:
            left = self.endTime - app.GetTime()
            if left <= 0:
                self.Hide()
                self.endTime = 0
            else:
                m = int(left / 60)
                s = int(left % 60)
                self.timer.SetText("%02d:%02d" % (m, s))


class RivalTrackerWindow(ui.Window):
    """Tracker Rivale (Red Box - Hostile)"""
    def __init__(self):
        ui.Window.__init__(self)
        self.SetSize(200, 80)
        self.screenWidth = wndMgr.GetScreenWidth()

        # FIX: Posizioni dinamiche corrette per evitare sovrapposizioni
        self.defaultY = 80  # Posizione senza evento (top-right, sotto AUTO CACCIA)
        self.eventActiveY = 210  # Sotto EventStatusWindow (Y=140 + 60 + 10 padding = 210)
        self.SetPosition(self.screenWidth - 210, self.defaultY)
        self.AddFlag("float")
        
        # Riferimento opzionale a EventStatusWindow
        self.eventWndRef = None
        
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(200, 80)
        self.bg.SetColor(COLOR_BG_DARK)
        self.bg.Show()
        
        # Bordi Rossi (Per indicare pericolo/ostilità)
        color = FRACTURE_SCHEMES["RED"]["border"]
        # Top/Bottom
        for y in [0, 78]:
            b = ui.Bar(); b.SetParent(self); b.SetPosition(0, y); b.SetSize(200, 2); b.SetColor(color); b.Show()
        # Left/Right
        for x in [0, 198]:
            b = ui.Bar(); b.SetParent(self); b.SetPosition(x, 0); b.SetSize(2, 80); b.SetColor(color); b.Show()
        
        self.text = ui.TextLine()
        self.text.SetParent(self)
        self.text.SetPosition(100, 10)
        self.text.SetHorizontalAlignCenter()
        self.text.SetText("⚠️ RIVALE DI CLASSIFICA")
        self.text.SetPackedFontColor(FRACTURE_SCHEMES["RED"]["title"])
        self.text.SetOutline()
        self.text.Show()
        
        self.nameText = ui.TextLine()
        self.nameText.SetParent(self)
        self.nameText.SetPosition(100, 30)
        self.nameText.SetHorizontalAlignCenter()
        self.nameText.SetText("")
        self.nameText.SetPackedFontColor(COLOR_TEXT_NORMAL)
        self.nameText.Show()

        self.descText = ui.TextLine()
        self.descText.SetParent(self)
        self.descText.SetPosition(100, 50)
        self.descText.SetHorizontalAlignCenter()
        self.descText.SetText("Nuovo bersaglio attivo.")
        self.descText.SetPackedFontColor(COLOR_TEXT_MUTED)
        self.descText.Show()
        
        self.endTime = 0
    
    def SetEventWindowRef(self, eventWnd):
        """Imposta il riferimento a EventStatusWindow per controllo posizione"""
        self.eventWndRef = eventWnd
        
    def ShowRival(self, name, diff, label="Gloria", mode="VICINO"):
        # FIX: Calcola posizione dinamica basata su EventStatusWindow
        yPos = self.defaultY
        if self.eventWndRef and self.eventWndRef.IsShow():
            yPos = self.eventActiveY  # Posiziona sotto l'evento (Y=270 = 200+60+10)

        # Ricalcola screen width per risoluzioni diverse
        self.screenWidth = wndMgr.GetScreenWidth()
        self.SetPosition(self.screenWidth - 210, yPos)
        
        self.nameText.SetText(name.replace("+", " "))
        
        # Modalità SUPERATO: qualcuno ti ha superato
        if mode == "SUPERATO":
            self.text.SetText("⚠️ SEI STATO SUPERATO!")
            self.text.SetPackedFontColor(FRACTURE_SCHEMES["RED"]["title"])
            self.descText.SetText("%s ti ha superato di %s pt!" % (name.replace("+", " "), str(diff)))
            self.descText.SetPackedFontColor(FRACTURE_SCHEMES["RED"]["title"])
        else:
            # Modalità normale: mostra il rivale davanti a te
            self.text.SetText("⚠️ RIVALE DI CLASSIFICA")
            self.text.SetPackedFontColor(FRACTURE_SCHEMES["RED"]["title"])
            self.descText.SetText("Distacco %s: %s pt" % (label, str(diff)))
            self.descText.SetPackedFontColor(FRACTURE_SCHEMES["ORANGE"]["title"])
        
        # Dura 30 secondi
        self.endTime = app.GetTime() + 30.0
        self.Show()
        self.SetTop()
        
    def OnUpdate(self):
        if self.endTime > 0 and app.GetTime() > self.endTime:
            self.Hide()
            self.endTime = 0


# ============================================================
# EVENT STATUS WINDOW - Popup Evento Attivo (Sempre Visibile)
# ============================================================
class EventStatusWindow(ui.ScriptWindow):
    """Mostra un popup sempre visibile quando c'è un evento attivo"""

    def __init__(self):
        ui.ScriptWindow.__init__(self)
        self.SetSize(220, 60)

        screenWidth = wndMgr.GetScreenWidth()
        # FIX: Posizione sotto pulsante AUTO CACCIA (Y=140)
        # Ottimizzato per non sovrapporsi ad altri elementi UI
        self.SetPosition(screenWidth - 230, 140)
        self.AddFlag("float")
        self.endTime = 0
        self.parentWindow = None  # Per aprire la guida
        
        # Background scuro
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(220, 60)
        self.bg.SetColor(0xDD000000)
        self.bg.Show()
        
        # Bordo colorato (Verde per evento attivo)
        self.borders = []
        eventColor = 0xFF00FF88  # Verde brillante
        
        # Top
        b = ui.Bar(); b.SetParent(self); b.SetPosition(0, 0); b.SetSize(220, 2); b.SetColor(eventColor); b.Show()
        self.borders.append(b)
        # Bottom
        b = ui.Bar(); b.SetParent(self); b.SetPosition(0, 58); b.SetSize(220, 2); b.SetColor(eventColor); b.Show()
        self.borders.append(b)
        # Left
        b = ui.Bar(); b.SetParent(self); b.SetPosition(0, 0); b.SetSize(2, 60); b.SetColor(eventColor); b.Show()
        self.borders.append(b)
        # Right
        b = ui.Bar(); b.SetParent(self); b.SetPosition(218, 0); b.SetSize(2, 60); b.SetColor(eventColor); b.Show()
        self.borders.append(b)
        
        # Glow effect (barra laterale)
        self.glowBar = ui.Bar()
        self.glowBar.SetParent(self)
        self.glowBar.SetPosition(2, 2)
        self.glowBar.SetSize(4, 56)
        self.glowBar.SetColor(0x6600FF88)
        self.glowBar.Show()
        
        # Icona/Label "EVENTO"
        self.labelText = ui.TextLine()
        self.labelText.SetParent(self)
        self.labelText.SetPosition(110, 8)
        self.labelText.SetHorizontalAlignCenter()
        self.labelText.SetText("⚡ EVENTO IN CORSO")
        self.labelText.SetPackedFontColor(0xFF00FF88)
        self.labelText.SetOutline()
        self.labelText.Show()
        
        # Nome evento
        self.eventNameText = ui.TextLine()
        self.eventNameText.SetParent(self)
        self.eventNameText.SetPosition(110, 28)
        self.eventNameText.SetHorizontalAlignCenter()
        self.eventNameText.SetText("")
        self.eventNameText.SetPackedFontColor(0xFFFFD700)  # Gold
        self.eventNameText.SetOutline()
        self.eventNameText.Show()
        
        # Orario
        self.timeText = ui.TextLine()
        self.timeText.SetParent(self)
        self.timeText.SetPosition(110, 44)
        self.timeText.SetHorizontalAlignCenter()
        self.timeText.SetText("")
        self.timeText.SetPackedFontColor(0xFFAAAAAA)
        self.timeText.Show()
        
        self.currentEvent = ""
        self.pulseTime = 0
        self.pulseDir = 1
        self.Hide()
    
    def SetEvent(self, eventName, timeInfo=""):
        """Mostra o nasconde il popup evento"""
        if not eventName or eventName == "Nessuno" or eventName == "":
            self.currentEvent = ""
            self.Hide()
            return
        
        self.currentEvent = eventName.replace("+", " ")
        self.eventNameText.SetText(self.currentEvent[:25])  # Max 25 chars
        
        if timeInfo:
            self.timeText.SetText(timeInfo)
        else:
            self.timeText.SetText("")
        
        # FIX: Ricalcola posizione (sotto pulsante AUTO CACCIA)
        screenWidth = wndMgr.GetScreenWidth()
        self.SetPosition(screenWidth - 230, 140)

        self.Show()
        self.SetTop()
    
    def ShowEvent(self, eventName, duration=0, eventType="default"):
        """Mostra evento con countdown opzionale"""
        if not eventName or eventName == "Nessuno" or eventName == "":
            self.currentEvent = ""
            self.Hide()
            return
        
        self.currentEvent = eventName.replace("+", " ")
        self.eventNameText.SetText(self.currentEvent[:25])
        
        # Timer countdown
        if duration > 0:
            self.endTime = app.GetTime() + duration
            mins = duration / 60
            secs = duration % 60
            self.timeText.SetText("Tempo: %d:%02d" % (mins, secs))
        else:
            self.endTime = 0
            self.timeText.SetText("")
        
        # Colore basato sul tipo
        eventColors = {
            "default": 0xFF00FF88,     # Verde
            "boss_hunt": 0xFFFF0000,   # Rosso
            "fracture": 0xFF9900FF,    # Viola
            "time_trial": 0xFFFFD700,  # Oro
            "custom": 0xFF00FFFF       # Cyan
        }
        color = eventColors.get(eventType, 0xFF00FF88)
        self.SetEventColor(color)

        # FIX: Ricalcola posizione (sotto pulsante AUTO CACCIA)
        screenWidth = wndMgr.GetScreenWidth()
        self.SetPosition(screenWidth - 230, 140)

        self.Show()
        self.SetTop()
    
    def SetEventColor(self, color):
        """Cambia il colore del bordo in base al tipo di evento"""
        for b in self.borders:
            b.SetColor(color)
        self.glowBar.SetColor((color & 0x00FFFFFF) | 0x66000000)
        self.labelText.SetPackedFontColor(color)
    
    def OnUpdate(self):
        """Effetto pulsante sul glow + countdown"""
        if not self.IsShow():
            return
        
        ct = app.GetTime()
        
        # Countdown timer
        if hasattr(self, 'endTime') and self.endTime > 0:
            remaining = self.endTime - ct
            if remaining <= 0:
                self.Hide()
                self.endTime = 0
                return
            mins = int(remaining) / 60
            secs = int(remaining) % 60
            self.timeText.SetText("Tempo: %d:%02d" % (mins, secs))
        
        # Pulse ogni 0.5 secondi
        alpha = int(abs((ct * 2) % 2 - 1) * 60) + 40  # 40-100
        glowColor = 0x00FF88 | (alpha << 24)
        self.glowBar.SetColor(glowColor)

    def SetParentWindow(self, parent):
        """Salva riferimento al terminale Hunter per aprire la guida"""
        self.parentWindow = parent

    def OnMouseOverIn(self):
        """Mostra tooltip esplicativo quando passi il mouse sopra"""
        import uiToolTip
        if not hasattr(self, "toolTip"):
            self.toolTip = uiToolTip.ToolTip()
            self.toolTip.ClearToolTip()

        # Tooltip completo stile Solo Leveling
        self.toolTip.ClearToolTip()
        self.toolTip.SetTitle("⚡ EVENTO HUNTER IN CORSO")
        self.toolTip.AppendSpace(5)

        if self.currentEvent:
            self.toolTip.AppendTextLine("Nome: %s" % self.currentEvent, 0xFFFFD700)

        self.toolTip.AppendSpace(5)
        self.toolTip.AppendTextLine("━━━━━━━━━━━━━━━━━━━━━━━━━━━━", 0xFF00CCFF)
        self.toolTip.AppendSpace(5)
        self.toolTip.AppendTextLine("Durante questo evento ottieni bonus speciali:", 0xFFFFFFFF)
        self.toolTip.AppendSpace(3)
        self.toolTip.AppendTextLine("✓ Gloria x2 per ogni kill", 0xFF00FF00)
        self.toolTip.AppendTextLine("✓ Spawn Elite aumentato", 0xFF00FF00)
        self.toolTip.AppendTextLine("✓ Ricompense maggiorate", 0xFF00FF00)
        self.toolTip.AppendSpace(5)
        self.toolTip.AppendTextLine("━━━━━━━━━━━━━━━━━━━━━━━━━━━━", 0xFF00CCFF)
        self.toolTip.AppendSpace(5)
        self.toolTip.AppendTextLine("CLICCA per aprire la Guida Eventi", 0xFFFFAA00)
        self.toolTip.AppendSpace(5)

        self.toolTip.Show()

    def OnMouseOverOut(self):
        """Nasconde tooltip quando rimuovi il mouse"""
        if hasattr(self, "toolTip"):
            self.toolTip.Hide()

    def OnMouseLeftButtonDown(self):
        """Click apre direttamente la Guida nella sezione Eventi"""
        if self.parentWindow:
            # Apri terminale se chiuso
            if not self.parentWindow.IsShow():
                self.parentWindow.Open()
            # Vai direttamente al tab Guida (indice 5)
            self.parentWindow._HunterLevelWindow__OnClickTab(5)
            # TODO: Scroll automatico alla sezione eventi se possibile


# ============================================================
# BOSS ALERT - SOLO LEVELING STYLE (Full Screen Effect)
# ============================================================

class BossAlertWindow(ui.Window):
    """
    ALERT A SCHERMO INTERO stile Solo Leveling
    Barra centrale rossa con effetto NEON che lampeggia per 5 secondi
    Appare quando spawna un BOSS dalla frattura
    """
    def __init__(self):
        ui.Window.__init__(self)
        
        # Full screen
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.AddFlag("float")
        self.AddFlag("attach")
        
        # ========================================
        # EFFETTO NEON - Strati sovrapposti
        # ========================================
        
        # Altezza barra centrale
        self.barHeight = 120
        self.barY = (self.screenHeight - self.barHeight) / 2
        
        # Layer 1: Glow esterno (più grande, molto trasparente)
        self.glowOuter = ui.Bar()
        self.glowOuter.SetParent(self)
        self.glowOuter.SetPosition(0, self.barY - 30)
        self.glowOuter.SetSize(self.screenWidth, self.barHeight + 60)
        self.glowOuter.SetColor(0x15FF0000)  # Rosso molto trasparente
        self.glowOuter.AddFlag("not_pick")
        self.glowOuter.Show()
        
        # Layer 2: Glow medio
        self.glowMiddle = ui.Bar()
        self.glowMiddle.SetParent(self)
        self.glowMiddle.SetPosition(0, self.barY - 15)
        self.glowMiddle.SetSize(self.screenWidth, self.barHeight + 30)
        self.glowMiddle.SetColor(0x25FF0000)  # Rosso trasparente
        self.glowMiddle.AddFlag("not_pick")
        self.glowMiddle.Show()
        
        # Layer 3: Barra principale
        self.mainBar = ui.Bar()
        self.mainBar.SetParent(self)
        self.mainBar.SetPosition(0, self.barY)
        self.mainBar.SetSize(self.screenWidth, self.barHeight)
        self.mainBar.SetColor(0x88FF0000)  # Rosso semi-trasparente
        self.mainBar.AddFlag("not_pick")
        self.mainBar.Show()
        
        # Layer 4: Linea NEON superiore
        self.neonTop = ui.Bar()
        self.neonTop.SetParent(self)
        self.neonTop.SetPosition(0, self.barY - 3)
        self.neonTop.SetSize(self.screenWidth, 6)
        self.neonTop.SetColor(0xFFFF0000)  # Rosso pieno
        self.neonTop.AddFlag("not_pick")
        self.neonTop.Show()
        
        # Linea NEON superiore - glow
        self.neonTopGlow = ui.Bar()
        self.neonTopGlow.SetParent(self)
        self.neonTopGlow.SetPosition(0, self.barY - 8)
        self.neonTopGlow.SetSize(self.screenWidth, 5)
        self.neonTopGlow.SetColor(0x66FF4444)
        self.neonTopGlow.AddFlag("not_pick")
        self.neonTopGlow.Show()
        
        # Layer 5: Linea NEON inferiore
        self.neonBottom = ui.Bar()
        self.neonBottom.SetParent(self)
        self.neonBottom.SetPosition(0, self.barY + self.barHeight - 3)
        self.neonBottom.SetSize(self.screenWidth, 6)
        self.neonBottom.SetColor(0xFFFF0000)  # Rosso pieno
        self.neonBottom.AddFlag("not_pick")
        self.neonBottom.Show()
        
        # Linea NEON inferiore - glow
        self.neonBottomGlow = ui.Bar()
        self.neonBottomGlow.SetParent(self)
        self.neonBottomGlow.SetPosition(0, self.barY + self.barHeight + 3)
        self.neonBottomGlow.SetSize(self.screenWidth, 5)
        self.neonBottomGlow.SetColor(0x66FF4444)
        self.neonBottomGlow.AddFlag("not_pick")
        self.neonBottomGlow.Show()
        
        # ========================================
        # TESTO "A L E R T"
        # ========================================
        
        # Testo principale ALERT
        self.alertText = ui.TextLine()
        self.alertText.SetParent(self)
        self.alertText.SetPosition(self.screenWidth / 2, self.barY + 25)
        self.alertText.SetHorizontalAlignCenter()
        self.alertText.SetText("! ! !  A L E R T  ! ! !")
        self.alertText.SetPackedFontColor(0xFFFFFFFF)
        self.alertText.SetOutline()
        self.alertText.Show()
        
        # Testo secondario "BOSS DETECTED"
        self.subText = ui.TextLine()
        self.subText.SetParent(self)
        self.subText.SetPosition(self.screenWidth / 2, self.barY + 55)
        self.subText.SetHorizontalAlignCenter()
        self.subText.SetText("B O S S   D E T E C T E D")
        self.subText.SetPackedFontColor(0xFFFF4444)
        self.subText.SetOutline()
        self.subText.Show()
        
        # Nome del Boss
        self.bossName = ui.TextLine()
        self.bossName.SetParent(self)
        self.bossName.SetPosition(self.screenWidth / 2, self.barY + 80)
        self.bossName.SetHorizontalAlignCenter()
        self.bossName.SetText("")
        self.bossName.SetPackedFontColor(0xFFFFD700)  # Oro
        self.bossName.SetOutline()
        self.bossName.Show()
        
        # ========================================
        # ANGOLI DECORATIVI (Solo Leveling style)
        # ========================================
        
        # Angoli sinistri
        self.cornerTL = ui.Bar()
        self.cornerTL.SetParent(self)
        self.cornerTL.SetPosition(50, self.barY - 3)
        self.cornerTL.SetSize(80, 6)
        self.cornerTL.SetColor(0xFFFFD700)  # Oro
        self.cornerTL.AddFlag("not_pick")
        self.cornerTL.Show()
        
        self.cornerTLv = ui.Bar()
        self.cornerTLv.SetParent(self)
        self.cornerTLv.SetPosition(50, self.barY - 3)
        self.cornerTLv.SetSize(6, 40)
        self.cornerTLv.SetColor(0xFFFFD700)
        self.cornerTLv.AddFlag("not_pick")
        self.cornerTLv.Show()
        
        # Angoli destri
        self.cornerTR = ui.Bar()
        self.cornerTR.SetParent(self)
        self.cornerTR.SetPosition(self.screenWidth - 130, self.barY - 3)
        self.cornerTR.SetSize(80, 6)
        self.cornerTR.SetColor(0xFFFFD700)
        self.cornerTR.AddFlag("not_pick")
        self.cornerTR.Show()
        
        self.cornerTRv = ui.Bar()
        self.cornerTRv.SetParent(self)
        self.cornerTRv.SetPosition(self.screenWidth - 56, self.barY - 3)
        self.cornerTRv.SetSize(6, 40)
        self.cornerTRv.SetColor(0xFFFFD700)
        self.cornerTRv.AddFlag("not_pick")
        self.cornerTRv.Show()
        
        # Angoli inferiori sinistri
        self.cornerBL = ui.Bar()
        self.cornerBL.SetParent(self)
        self.cornerBL.SetPosition(50, self.barY + self.barHeight - 3)
        self.cornerBL.SetSize(80, 6)
        self.cornerBL.SetColor(0xFFFFD700)
        self.cornerBL.AddFlag("not_pick")
        self.cornerBL.Show()
        
        self.cornerBLv = ui.Bar()
        self.cornerBLv.SetParent(self)
        self.cornerBLv.SetPosition(50, self.barY + self.barHeight - 37)
        self.cornerBLv.SetSize(6, 40)
        self.cornerBLv.SetColor(0xFFFFD700)
        self.cornerBLv.AddFlag("not_pick")
        self.cornerBLv.Show()
        
        # Angoli inferiori destri
        self.cornerBR = ui.Bar()
        self.cornerBR.SetParent(self)
        self.cornerBR.SetPosition(self.screenWidth - 130, self.barY + self.barHeight - 3)
        self.cornerBR.SetSize(80, 6)
        self.cornerBR.SetColor(0xFFFFD700)
        self.cornerBR.AddFlag("not_pick")
        self.cornerBR.Show()
        
        self.cornerBRv = ui.Bar()
        self.cornerBRv.SetParent(self)
        self.cornerBRv.SetPosition(self.screenWidth - 56, self.barY + self.barHeight - 37)
        self.cornerBRv.SetSize(6, 40)
        self.cornerBRv.SetColor(0xFFFFD700)
        self.cornerBRv.AddFlag("not_pick")
        self.cornerBRv.Show()
        
        # ========================================
        # TIMING & STATE
        # ========================================
        self.endTime = 0
        self.flashPhase = 0
        self.isFlashing = False
        
        self.Hide()
    
    def ShowAlert(self, bossName=""):
        """Mostra l'alert per 5 secondi con animazione lampeggiante"""
        if bossName:
            self.bossName.SetText("[ " + bossName.replace("+", " ") + " ]")
        else:
            self.bossName.SetText("")
        
        self.endTime = app.GetTime() + 5.0  # 5 secondi
        self.isFlashing = True
        self.flashPhase = 0
        
        self.Show()
        self.SetTop()
    
    def OnUpdate(self):
        """Effetto lampeggiante NEON"""
        if not self.isFlashing:
            return
        
        currentTime = app.GetTime()
        
        # Controlla fine animazione
        if currentTime > self.endTime:
            self.Hide()
            self.isFlashing = False
            return
        
        # ========================================
        # ANIMAZIONE FLASH (veloce, tipo allarme)
        # ========================================
        
        # Ciclo ogni 0.15 secondi (circa 6-7 flash al secondo)
        cycle = (currentTime * 7) % 2
        
        if cycle < 1:
            # FASE ACCESA - Colori intensi
            self.mainBar.SetColor(0xAAFF0000)
            self.glowOuter.SetColor(0x30FF0000)
            self.glowMiddle.SetColor(0x50FF0000)
            self.neonTop.SetColor(0xFFFF0000)
            self.neonBottom.SetColor(0xFFFF0000)
            self.neonTopGlow.SetColor(0xAAFF4444)
            self.neonBottomGlow.SetColor(0xAAFF4444)
            self.alertText.SetPackedFontColor(0xFFFFFFFF)
            self.subText.SetPackedFontColor(0xFFFF0000)
        else:
            # FASE SPENTA - Colori attenuati
            self.mainBar.SetColor(0x55880000)
            self.glowOuter.SetColor(0x10880000)
            self.glowMiddle.SetColor(0x20880000)
            self.neonTop.SetColor(0xAACC0000)
            self.neonBottom.SetColor(0xAACC0000)
            self.neonTopGlow.SetColor(0x55882222)
            self.neonBottomGlow.SetColor(0x55882222)
            self.alertText.SetPackedFontColor(0xAAFFAAAA)
            self.subText.SetPackedFontColor(0xAABB0000)
        
        # Effetto pulsante sugli angoli (più lento)
        goldPulse = int(abs((currentTime * 3) % 2 - 1) * 100) + 155  # 155-255
        goldColor = 0x00FFD700 | (goldPulse << 24)
        
        self.cornerTL.SetColor(goldColor)
        self.cornerTLv.SetColor(goldColor)
        self.cornerTR.SetColor(goldColor)
        self.cornerTRv.SetColor(goldColor)
        self.cornerBL.SetColor(goldColor)
        self.cornerBLv.SetColor(goldColor)
        self.cornerBR.SetColor(goldColor)
        self.cornerBRv.SetColor(goldColor)
    
    def OnPressEscapeKey(self):
        return False
    
    def OnKeyDown(self, key):
        return False


# ============================================================
# SYSTEM INITIALIZING - Effetto Caricamento al Login
# ============================================================

class SystemInitWindow(ui.Window):
    """
    Effetto di inizializzazione sistema stile Solo Leveling
    Mostra "SYSTEM INITIALIZING..." con barra di caricamento
    """
    def __init__(self):
        ui.Window.__init__(self)
        
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.AddFlag("float")
        self.AddFlag("attach")
        
        # Sfondo semi-trasparente
        self.bgOverlay = ui.Bar()
        self.bgOverlay.SetParent(self)
        self.bgOverlay.SetPosition(0, 0)
        self.bgOverlay.SetSize(self.screenWidth, self.screenHeight)
        self.bgOverlay.SetColor(0x99000000)
        self.bgOverlay.AddFlag("not_pick")
        self.bgOverlay.Show()
        
        # Box centrale
        boxWidth = 500
        boxHeight = 150
        boxX = (self.screenWidth - boxWidth) / 2
        boxY = (self.screenHeight - boxHeight) / 2
        
        # Bordo box
        self.boxBorder = ui.Bar()
        self.boxBorder.SetParent(self)
        self.boxBorder.SetPosition(boxX - 2, boxY - 2)
        self.boxBorder.SetSize(boxWidth + 4, boxHeight + 4)
        self.boxBorder.SetColor(0xFF0099FF)
        self.boxBorder.AddFlag("not_pick")
        self.boxBorder.Show()
        
        # Box interno
        self.boxBg = ui.Bar()
        self.boxBg.SetParent(self)
        self.boxBg.SetPosition(boxX, boxY)
        self.boxBg.SetSize(boxWidth, boxHeight)
        self.boxBg.SetColor(0xEE111111)
        self.boxBg.AddFlag("not_pick")
        self.boxBg.Show()
        
        # Titolo "SYSTEM"
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(self.screenWidth / 2, boxY + 20)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("[ S Y S T E M ]")
        self.titleText.SetPackedFontColor(0xFF0099FF)
        self.titleText.SetOutline()
        self.titleText.Show()
        
        # Messaggio "INITIALIZING..."
        self.msgText = ui.TextLine()
        self.msgText.SetParent(self)
        self.msgText.SetPosition(self.screenWidth / 2, boxY + 50)
        self.msgText.SetHorizontalAlignCenter()
        self.msgText.SetText("I N I T I A L I Z I N G . . .")
        self.msgText.SetPackedFontColor(0xFFFFFFFF)
        self.msgText.SetOutline()
        self.msgText.Show()
        
        # Barra di caricamento - sfondo
        barWidth = 400
        barHeight = 20
        barX = (self.screenWidth - barWidth) / 2
        barY = boxY + 85
        
        self.barBg = ui.Bar()
        self.barBg.SetParent(self)
        self.barBg.SetPosition(barX, barY)
        self.barBg.SetSize(barWidth, barHeight)
        self.barBg.SetColor(0xFF222222)
        self.barBg.AddFlag("not_pick")
        self.barBg.Show()
        
        # Barra di caricamento - progress
        self.barProgress = ui.Bar()
        self.barProgress.SetParent(self)
        self.barProgress.SetPosition(barX + 2, barY + 2)
        self.barProgress.SetSize(0, barHeight - 4)
        self.barProgress.SetColor(0xFF0099FF)
        self.barProgress.AddFlag("not_pick")
        self.barProgress.Show()
        
        # Percentuale
        self.percentText = ui.TextLine()
        self.percentText.SetParent(self)
        self.percentText.SetPosition(self.screenWidth / 2, barY + 25)
        self.percentText.SetHorizontalAlignCenter()
        self.percentText.SetText("0%")
        self.percentText.SetPackedFontColor(0xFF00FFFF)
        self.percentText.Show()
        
        # Sottotitolo
        self.subText = ui.TextLine()
        self.subText.SetParent(self)
        self.subText.SetPosition(self.screenWidth / 2, boxY + 120)
        self.subText.SetHorizontalAlignCenter()
        self.subText.SetText("Hunter Terminal is loading...")
        self.subText.SetPackedFontColor(0xFF888888)
        self.subText.Show()
        
        self.barMaxWidth = barWidth - 4
        self.startTime = 0
        self.duration = 3.0  # 3 secondi di caricamento
        self.endTime = 0
        self.onComplete = None
        self.completed = False
        
        self.Hide()
    
    def StartLoading(self, callback=None):
        """Avvia l'animazione di caricamento"""
        self.startTime = app.GetTime()
        self.endTime = self.startTime + self.duration + 1.5  # Chiude 1.5s dopo il 100%
        self.onComplete = callback
        self.completed = False
        self.msgText.SetText("I N I T I A L I Z I N G . . .")
        self.msgText.SetPackedFontColor(0xFFFFFFFF)
        self.barProgress.SetSize(0, 16)
        self.percentText.SetText("0%")
        self.Show()
        self.SetTop()
    
    def OnUpdate(self):
        if self.endTime == 0:
            return
        
        currentTime = app.GetTime()
        
        # Tempo scaduto - chiudi
        if currentTime > self.endTime:
            self.Hide()
            self.endTime = 0
            if self.onComplete:
                self.onComplete()
            return
        
        elapsed = currentTime - self.startTime
        progress = min(elapsed / self.duration, 1.0)
        
        # Aggiorna barra
        newWidth = int(self.barMaxWidth * progress)
        self.barProgress.SetSize(newWidth, 16)
        
        # Aggiorna percentuale
        percent = int(progress * 100)
        self.percentText.SetText("%d%%" % percent)
        
        # Effetto lampeggio sul bordo
        cycle = (currentTime * 4) % 2
        if cycle < 1:
            self.boxBorder.SetColor(0xFF0099FF)
        else:
            self.boxBorder.SetColor(0xFF00CCFF)
        
        # Mostra "READY" quando completato
        if progress >= 1.0 and not self.completed:
            self.completed = True
            self.msgText.SetText("S Y S T E M   R E A D Y")
            self.msgText.SetPackedFontColor(0xFF00FF00)
            self.boxBorder.SetColor(0xFF00FF00)
    
    def OnPressEscapeKey(self):
        return False
    
    def OnKeyDown(self, key):
        return False


# ============================================================
# AWAKENING WINDOW - Risveglio al Lv 5 (Misterioso/Spaventoso)
# ============================================================

class AwakeningWindow(ui.Window):
    """
    Effetto di risveglio al Lv 5 - Misterioso e inquietante
    Simula un "glitch" del sistema con messaggi criptici
    """
    def __init__(self):
        ui.Window.__init__(self)
        
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.AddFlag("float")
        self.AddFlag("attach")
        
        # Sfondo che si oscura progressivamente
        self.bgOverlay = ui.Bar()
        self.bgOverlay.SetParent(self)
        self.bgOverlay.SetPosition(0, 0)
        self.bgOverlay.SetSize(self.screenWidth, self.screenHeight)
        self.bgOverlay.SetColor(0x00000000)
        self.bgOverlay.AddFlag("not_pick")
        self.bgOverlay.Show()
        
        # Linee di "glitch" orizzontali
        self.glitchLines = []
        for i in range(5):
            line = ui.Bar()
            line.SetParent(self)
            line.SetSize(self.screenWidth, 3)
            line.SetColor(0x00FF0000)
            line.AddFlag("not_pick")
            line.Hide()
            self.glitchLines.append(line)
        
        # Testo principale (cambia durante l'animazione)
        self.mainText = ui.TextLine()
        self.mainText.SetParent(self)
        self.mainText.SetPosition(self.screenWidth / 2, self.screenHeight / 2 - 40)
        self.mainText.SetHorizontalAlignCenter()
        self.mainText.SetText("")
        self.mainText.SetPackedFontColor(0xFFFF0000)
        self.mainText.SetOutline()
        self.mainText.Show()
        
        # Testo secondario
        self.subText = ui.TextLine()
        self.subText.SetParent(self)
        self.subText.SetPosition(self.screenWidth / 2, self.screenHeight / 2)
        self.subText.SetHorizontalAlignCenter()
        self.subText.SetText("")
        self.subText.SetPackedFontColor(0xFFAA0000)
        self.subText.Show()
        
        # Testo criptico in basso
        self.crypticText = ui.TextLine()
        self.crypticText.SetParent(self)
        self.crypticText.SetPosition(self.screenWidth / 2, self.screenHeight / 2 + 40)
        self.crypticText.SetHorizontalAlignCenter()
        self.crypticText.SetText("")
        self.crypticText.SetPackedFontColor(0xFF666666)
        self.crypticText.Show()
        
        self.startTime = 0
        self.endTime = 0
        self.phase = 0
        self.playerName = ""
        
        # Messaggi per ogni fase
        self.messages = [
            ("? ? ?", "Anomalia rilevata...", ""),
            ("[ WARNING ]", "Sistema instabile", "0x7F3A...ERROR"),
            ("! ! !", "Qualcosa si sta risvegliando...", "UNKNOWN_ENTITY"),
            ("S Y S T E M", "Ti stiamo osservando...", "LEVEL_5_DETECTED"),
            ("A T T E N Z I O N E", "Sei stato notato.", "HUNTER_POTENTIAL: ???"),
            ("...", "Preparati.", "LV.30 = RISVEGLIO"),
        ]
        
        self.Hide()
    
    def StartAwakening(self, playerName="Hunter"):
        """Avvia la sequenza di risveglio"""
        self.playerName = playerName
        self.startTime = app.GetTime()
        self.endTime = self.startTime + 9.5  # 9 secondi + margine
        self.phase = -1
        self.mainText.SetText("")
        self.subText.SetText("")
        self.crypticText.SetText("")
        self.bgOverlay.SetColor(0x00000000)
        self.Show()
        self.SetTop()
    
    def OnUpdate(self):
        if self.endTime == 0:
            return
        
        currentTime = app.GetTime()
        
        # Tempo scaduto - chiudi
        if currentTime > self.endTime:
            for line in self.glitchLines:
                line.Hide()
            self.Hide()
            self.endTime = 0
            return
        
        elapsed = currentTime - self.startTime
        
        # Ogni fase dura 1.5 secondi
        newPhase = int(elapsed / 1.5)
        
        if newPhase != self.phase and newPhase < len(self.messages):
            self.phase = newPhase
            msg = self.messages[self.phase]
            self.mainText.SetText(msg[0])
            self.subText.SetText(msg[1])
            self.crypticText.SetText(msg[2])
        
        # Effetto oscuramento progressivo
        alpha = min(int(elapsed * 30), 180)
        self.bgOverlay.SetColor(alpha << 24)
        
        # Effetto glitch pseudo-casuale (basato su tempo)
        timeMs = int(app.GetTime() * 1000)
        if timeMs % 3 == 0:
            for idx, line in enumerate(self.glitchLines):
                seed = (timeMs + idx * 137) % 10
                if seed < 4:
                    yPos = ((timeMs * (idx + 1) * 7) % self.screenHeight)
                    line.SetPosition(0, yPos)
                    line.SetColor(0x66FF0000)
                    line.Show()
                else:
                    line.Hide()
        
        # Effetto tremito del testo
        if int(elapsed * 10) % 3 == 0:
            seed = int(app.GetTime() * 100) % 5
            offset = seed - 2  # Range -2 to +2
            self.mainText.SetPosition(self.screenWidth / 2 + offset, self.screenHeight / 2 - 40)
    
    def OnPressEscapeKey(self):
        return False
    
    def OnKeyDown(self, key):
        return False


# ============================================================
# HUNTER ACTIVATION - Attivazione al Lv 30 (Epico!)
# ============================================================

class HunterActivationWindow(ui.Window):
    """
    Attivazione del Sistema Hunter al Lv 30
    Effetto epico con messaggio di benvenuto
    """
    def __init__(self):
        ui.Window.__init__(self)
        
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.AddFlag("float")
        self.AddFlag("attach")
        
        # Sfondo scuro
        self.bgOverlay = ui.Bar()
        self.bgOverlay.SetParent(self)
        self.bgOverlay.SetPosition(0, 0)
        self.bgOverlay.SetSize(self.screenWidth, self.screenHeight)
        self.bgOverlay.SetColor(0xDD000000)
        self.bgOverlay.AddFlag("not_pick")
        self.bgOverlay.Show()
        
        # Linee decorative laterali
        self.lineLeft = ui.Bar()
        self.lineLeft.SetParent(self)
        self.lineLeft.SetPosition(50, 0)
        self.lineLeft.SetSize(3, self.screenHeight)
        self.lineLeft.SetColor(0xFF0099FF)
        self.lineLeft.AddFlag("not_pick")
        self.lineLeft.Show()
        
        self.lineRight = ui.Bar()
        self.lineRight.SetParent(self)
        self.lineRight.SetPosition(self.screenWidth - 53, 0)
        self.lineRight.SetSize(3, self.screenHeight)
        self.lineRight.SetColor(0xFF0099FF)
        self.lineRight.AddFlag("not_pick")
        self.lineRight.Show()
        
        # Barra centrale superiore
        self.topBar = ui.Bar()
        self.topBar.SetParent(self)
        self.topBar.SetPosition(0, self.screenHeight / 2 - 100)
        self.topBar.SetSize(self.screenWidth, 4)
        self.topBar.SetColor(0xFFFFD700)
        self.topBar.AddFlag("not_pick")
        self.topBar.Show()
        
        # Barra centrale inferiore
        self.bottomBar = ui.Bar()
        self.bottomBar.SetParent(self)
        self.bottomBar.SetPosition(0, self.screenHeight / 2 + 100)
        self.bottomBar.SetSize(self.screenWidth, 4)
        self.bottomBar.SetColor(0xFFFFD700)
        self.bottomBar.AddFlag("not_pick")
        self.bottomBar.Show()
        
        centerY = self.screenHeight / 2
        
        # "SYSTEM" in alto
        self.systemText = ui.TextLine()
        self.systemText.SetParent(self)
        self.systemText.SetPosition(self.screenWidth / 2, centerY - 70)
        self.systemText.SetHorizontalAlignCenter()
        self.systemText.SetText("[ S Y S T E M ]")
        self.systemText.SetPackedFontColor(0xFF0099FF)
        self.systemText.SetOutline()
        self.systemText.Show()
        
        # Messaggio principale
        self.mainText = ui.TextLine()
        self.mainText.SetParent(self)
        self.mainText.SetPosition(self.screenWidth / 2, centerY - 35)
        self.mainText.SetHorizontalAlignCenter()
        self.mainText.SetText("")
        self.mainText.SetPackedFontColor(0xFFFFD700)
        self.mainText.SetOutline()
        self.mainText.Show()
        
        # Nome giocatore
        self.nameText = ui.TextLine()
        self.nameText.SetParent(self)
        self.nameText.SetPosition(self.screenWidth / 2, centerY)
        self.nameText.SetHorizontalAlignCenter()
        self.nameText.SetText("")
        self.nameText.SetPackedFontColor(0xFFFFFFFF)
        self.nameText.SetOutline()
        self.nameText.Show()
        
        # Sottotitolo
        self.subText = ui.TextLine()
        self.subText.SetParent(self)
        self.subText.SetPosition(self.screenWidth / 2, centerY + 35)
        self.subText.SetHorizontalAlignCenter()
        self.subText.SetText("")
        self.subText.SetPackedFontColor(0xFF00FFFF)
        self.subText.Show()
        
        # Messaggio finale
        self.finalText = ui.TextLine()
        self.finalText.SetParent(self)
        self.finalText.SetPosition(self.screenWidth / 2, centerY + 70)
        self.finalText.SetHorizontalAlignCenter()
        self.finalText.SetText("")
        self.finalText.SetPackedFontColor(0xFF888888)
        self.finalText.Show()
        
        self.startTime = 0
        self.endTime = 0
        self.phase = -1
        self.playerName = ""
        
        self.Hide()
    
    def StartActivation(self, playerName="Hunter"):
        """Avvia la sequenza di attivazione"""
        self.playerName = playerName
        self.startTime = app.GetTime()
        self.endTime = self.startTime + 10.5  # 10 secondi + margine
        self.phase = -1
        # Reset testi
        self.mainText.SetText("")
        self.mainText.SetPackedFontColor(0xFFFFD700)
        self.nameText.SetText("")
        self.subText.SetText("")
        self.finalText.SetText("")
        self.Show()
        self.SetTop()
    
    def OnUpdate(self):
        if self.endTime == 0:
            return
        
        currentTime = app.GetTime()
        
        # Tempo scaduto - chiudi
        if currentTime > self.endTime:
            self.Hide()
            self.endTime = 0
            return
        
        elapsed = currentTime - self.startTime
        currentPhase = int(elapsed / 2.0)  # Ogni fase 2 secondi
        
        if currentPhase != self.phase:
            self.phase = currentPhase
            
            if self.phase == 1:
                self.mainText.SetText("H U N T E R   S Y S T E M")
                self.subText.SetText("A C T I V A T E D")
            elif self.phase == 2:
                self.nameText.SetText("Benvenuto, " + self.playerName)
                self.finalText.SetText("Sei stato scelto.")
            elif self.phase == 3:
                self.subText.SetText("Da oggi lotterai per la Gloria!")
                self.finalText.SetText("Fratture, Classifiche, Tesori... ti attendono.")
            elif self.phase == 4:
                self.mainText.SetText("A R I S E")
                self.mainText.SetPackedFontColor(0xFFFF6600)
                self.subText.SetText("Il tuo viaggio come Hunter inizia ORA.")
                self.finalText.SetText("")
        
        # Effetto pulsante sulle barre
        pulse = int(abs((elapsed * 3) % 2 - 1) * 100) + 155
        goldColor = 0x00FFD700 | (pulse << 24)
        self.topBar.SetColor(goldColor)
        self.bottomBar.SetColor(goldColor)
        
        # Effetto lampeggio linee laterali
        cycle = (elapsed * 4) % 2
        if cycle < 1:
            self.lineLeft.SetColor(0xFF0099FF)
            self.lineRight.SetColor(0xFF0099FF)
        else:
            self.lineLeft.SetColor(0xFF00CCFF)
            self.lineRight.SetColor(0xFF00CCFF)
    
    def OnPressEscapeKey(self):
        return False
    
    def OnKeyDown(self, key):
        return False


# ============================================================
# RANK UP WINDOW - Salita di Grado
# ============================================================

class RankUpWindow(ui.Window):
    """
    Effetto quando il giocatore sale di rank (E->D, D->C, etc.)
    """
    def __init__(self):
        ui.Window.__init__(self)
        
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(self.screenWidth, self.screenHeight)
        self.SetPosition(0, 0)
        self.AddFlag("not_pick")
        self.AddFlag("float")
        self.AddFlag("attach")
        
        # Sfondo flash
        self.bgFlash = ui.Bar()
        self.bgFlash.SetParent(self)
        self.bgFlash.SetPosition(0, 0)
        self.bgFlash.SetSize(self.screenWidth, self.screenHeight)
        self.bgFlash.SetColor(0x00000000)
        self.bgFlash.AddFlag("not_pick")
        self.bgFlash.Show()
        
        # Box centrale
        centerY = self.screenHeight / 2
        boxWidth = 450
        boxHeight = 180
        boxX = (self.screenWidth - boxWidth) / 2
        boxY = centerY - boxHeight / 2
        
        # Glow esterno
        self.glowOuter = ui.Bar()
        self.glowOuter.SetParent(self)
        self.glowOuter.SetPosition(boxX - 10, boxY - 10)
        self.glowOuter.SetSize(boxWidth + 20, boxHeight + 20)
        self.glowOuter.SetColor(0x44FFD700)
        self.glowOuter.AddFlag("not_pick")
        self.glowOuter.Show()
        
        # Box
        self.box = ui.Bar()
        self.box.SetParent(self)
        self.box.SetPosition(boxX, boxY)
        self.box.SetSize(boxWidth, boxHeight)
        self.box.SetColor(0xEE111111)
        self.box.AddFlag("not_pick")
        self.box.Show()
        
        # Bordo
        self.border = ui.Bar()
        self.border.SetParent(self)
        self.border.SetPosition(boxX - 2, boxY - 2)
        self.border.SetSize(boxWidth + 4, boxHeight + 4)
        self.border.SetColor(0xFFFFD700)
        self.border.AddFlag("not_pick")
        self.border.Show()
        # Riporta box sopra
        self.box.SetPosition(boxX, boxY)
        
        # "RANK UP!"
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(self.screenWidth / 2, boxY + 20)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("R A N K   U P !")
        self.titleText.SetPackedFontColor(0xFFFFD700)
        self.titleText.SetOutline()
        self.titleText.Show()
        
        # Rank precedente -> nuovo
        self.rankText = ui.TextLine()
        self.rankText.SetParent(self)
        self.rankText.SetPosition(self.screenWidth / 2, boxY + 60)
        self.rankText.SetHorizontalAlignCenter()
        self.rankText.SetText("")
        self.rankText.SetPackedFontColor(0xFFFFFFFF)
        self.rankText.SetOutline()
        self.rankText.Show()
        
        # Nome rank
        self.rankNameText = ui.TextLine()
        self.rankNameText.SetParent(self)
        self.rankNameText.SetPosition(self.screenWidth / 2, boxY + 95)
        self.rankNameText.SetHorizontalAlignCenter()
        self.rankNameText.SetText("")
        self.rankNameText.SetPackedFontColor(0xFF00FFFF)
        self.rankNameText.Show()
        
        # Messaggio
        self.msgText = ui.TextLine()
        self.msgText.SetParent(self)
        self.msgText.SetPosition(self.screenWidth / 2, boxY + 130)
        self.msgText.SetHorizontalAlignCenter()
        self.msgText.SetText("")
        self.msgText.SetPackedFontColor(0xFF888888)
        self.msgText.Show()
        
        self.startTime = 0
        self.endTime = 0
        self.rankColor = 0xFFFFD700
        
        # Colori per rank
        self.RANK_COLORS = {
            "E": 0xFF808080,  # Grigio
            "D": 0xFF00FF00,  # Verde
            "C": 0xFF00FFFF,  # Cyan
            "B": 0xFF0066FF,  # Blu
            "A": 0xFFAA00FF,  # Viola
            "S": 0xFFFF6600,  # Arancione
            "N": 0xFFFF0000,  # Rosso
        }
        
        self.RANK_NAMES = {
            "E": "Iniziato",
            "D": "Apprendista",
            "C": "Cacciatore",
            "B": "Veterano",
            "A": "Elite",
            "S": "Campione",
            "N": "Nazionale",
        }
        
        self.Hide()
    
    def ShowRankUp(self, oldRank, newRank):
        """Mostra l'effetto rank up"""
        self.rankColor = self.RANK_COLORS.get(newRank, 0xFFFFD700)
        rankName = self.RANK_NAMES.get(newRank, "???")
        
        self.rankText.SetText("[ %s ]  >>>  [ %s ]" % (oldRank, newRank))
        self.rankNameText.SetText(rankName.upper() + " RANK")
        self.rankNameText.SetPackedFontColor(self.rankColor)
        self.msgText.SetText("Il tuo potere cresce!")
        
        self.border.SetColor(self.rankColor)
        self.glowOuter.SetColor((self.rankColor & 0x00FFFFFF) | 0x44000000)
        
        self.startTime = app.GetTime()
        self.endTime = self.startTime + 5.5  # 5 secondi + margine
        self.Show()
        self.SetTop()
    
    def OnUpdate(self):
        if self.endTime == 0:
            return
        
        currentTime = app.GetTime()
        
        # Tempo scaduto - chiudi
        if currentTime > self.endTime:
            self.Hide()
            self.endTime = 0
            return
        
        elapsed = currentTime - self.startTime
        
        # Flash iniziale
        if elapsed < 0.5:
            alpha = int((1 - elapsed * 2) * 100)
            self.bgFlash.SetColor((self.rankColor & 0x00FFFFFF) | (alpha << 24))
        else:
            self.bgFlash.SetColor(0x00000000)
        
        # Effetto pulsante
        pulse = int(abs((elapsed * 3) % 2 - 1) * 60) + 195
        borderColor = (self.rankColor & 0x00FFFFFF) | (pulse << 24)
        self.border.SetColor(borderColor)
    
    def OnPressEscapeKey(self):
        return False
    
    def OnKeyDown(self, key):
        return False


# ============================================================
# OVERTAKE WINDOW - Sorpasso in Classifica
# ============================================================

class OvertakeWindow(ui.Window):
    """
    Effetto quando sorpassi qualcuno in classifica
    """
    def __init__(self):
        ui.Window.__init__(self)
        
        self.screenWidth = wndMgr.GetScreenWidth()
        self.screenHeight = wndMgr.GetScreenHeight()
        self.SetSize(400, 80)
        
        # Posizione di default: in alto a destra (sotto AUTO CACCIA)
        self.defaultY = 80
        self.eventActiveY = 210  # Sotto EventStatusWindow (Y=140 + 60 altezza + 10 margine = 210)
        self.SetPosition(self.screenWidth - 410, self.defaultY)
        
        self.AddFlag("not_pick")
        self.AddFlag("float")
        self.AddFlag("attach")
        
        # Riferimento opzionale a EventStatusWindow per controllo posizione
        self.eventWndRef = None
        
        # Sfondo
        self.bg = ui.Bar()
        self.bg.SetParent(self)
        self.bg.SetPosition(0, 0)
        self.bg.SetSize(400, 80)
        self.bg.SetColor(0xDD111111)
        self.bg.AddFlag("not_pick")
        self.bg.Show()
        
        # Bordo superiore
        self.borderTop = ui.Bar()
        self.borderTop.SetParent(self)
        self.borderTop.SetPosition(0, 0)
        self.borderTop.SetSize(400, 3)
        self.borderTop.SetColor(0xFF00FF00)
        self.borderTop.AddFlag("not_pick")
        self.borderTop.Show()
        
        # Bordo inferiore
        self.borderBottom = ui.Bar()
        self.borderBottom.SetParent(self)
        self.borderBottom.SetPosition(0, 77)
        self.borderBottom.SetSize(400, 3)
        self.borderBottom.SetColor(0xFF00FF00)
        self.borderBottom.AddFlag("not_pick")
        self.borderBottom.Show()
        
        # Icona freccia su (simbolo)
        self.arrowText = ui.TextLine()
        self.arrowText.SetParent(self)
        self.arrowText.SetPosition(200, 10)
        self.arrowText.SetHorizontalAlignCenter()
        self.arrowText.SetText("^ ^ ^")
        self.arrowText.SetPackedFontColor(0xFF00FF00)
        self.arrowText.SetOutline()
        self.arrowText.Show()
        
        # Testo principale
        self.mainText = ui.TextLine()
        self.mainText.SetParent(self)
        self.mainText.SetPosition(200, 30)
        self.mainText.SetHorizontalAlignCenter()
        self.mainText.SetText("")
        self.mainText.SetPackedFontColor(0xFFFFFFFF)
        self.mainText.SetOutline()
        self.mainText.Show()
        
        # Posizione
        self.posText = ui.TextLine()
        self.posText.SetParent(self)
        self.posText.SetPosition(200, 55)
        self.posText.SetHorizontalAlignCenter()
        self.posText.SetText("")
        self.posText.SetPackedFontColor(0xFFFFD700)
        self.posText.Show()
        
        self.startTime = 0
        self.endTime = 0  # Quando chiudere
        
        self.Hide()
    
    def SetEventWindowRef(self, eventWnd):
        """Imposta il riferimento a EventStatusWindow per controllo posizione"""
        self.eventWndRef = eventWnd
    
    def ShowOvertake(self, overtakenName, newPosition):
        """Mostra il sorpasso"""
        self.mainText.SetText("Hai superato %s!" % overtakenName)
        self.posText.SetText("Nuova Posizione: #%d" % newPosition)
        
        # Controlla se EventStatusWindow è visibile e adatta la posizione
        yPos = self.defaultY
        if self.eventWndRef and self.eventWndRef.IsShow():
            yPos = self.eventActiveY  # Posiziona sotto l'evento
        
        self.SetPosition(self.screenWidth - 410, yPos)
        
        self.startTime = app.GetTime()
        self.endTime = self.startTime + 4.5  # 4s animazione + 0.5s margine
        self.Show()
        self.SetTop()
    
    def OnUpdate(self):
        if self.endTime == 0:
            return
        
        currentTime = app.GetTime()
        
        # Controlla se deve chiudersi
        if currentTime > self.endTime:
            self.Hide()
            self.endTime = 0
            return
        
        elapsed = currentTime - self.startTime
        
        # Effetto lampeggio verde
        cycle = (elapsed * 4) % 2
        if cycle < 1:
            self.borderTop.SetColor(0xFF00FF00)
            self.borderBottom.SetColor(0xFF00FF00)
            self.arrowText.SetPackedFontColor(0xFF00FF00)
        else:
            self.borderTop.SetColor(0xFF00CC00)
            self.borderBottom.SetColor(0xFF00CC00)
            self.arrowText.SetPackedFontColor(0xFF88FF88)
    
    def OnPressEscapeKey(self):
        return False
    
    def OnKeyDown(self, key):
        return False


# ============================================================
# DAILY MISSIONS WINDOW - Finestra Missioni Giornaliere
# Trascinabile, con info bonus x1.5, penalità e orario reset
# ============================================================
class DailyMissionsWindow(ui.Window):
    """Finestra per visualizzare le 3 missioni giornaliere"""
    
    def __init__(self):
        ui.Window.__init__(self)
        
        self.SetSize(360, 380)  # Aumentata per info aggiuntive
        self.SetPosition(50, 100)
        self.AddFlag("movable")  # TRASCINABILE
        
        self.missions = []
        self.missionSlots = []
        self.progressBars = []
        self.theme = None
        self.isDragging = False
        self.dragStartX = 0
        self.dragStartY = 0
        self.autoCloseTimer = 0.0  # Timer per auto-chiusura
        self.lastUpdateTime = app.GetTime()
        
        self.__BuildUI()
    
    def __BuildUI(self):
        # Background principale
        self.bgMain = ui.Bar()
        self.bgMain.SetParent(self)
        self.bgMain.SetPosition(0, 0)
        self.bgMain.SetSize(360, 380)
        self.bgMain.SetColor(0xEE0A0A0A)
        self.bgMain.AddFlag("not_pick")
        self.bgMain.Show()
        
        # Bordi
        self.borders = []
        for i, (x, y, w, h) in enumerate([
            (0, 0, 360, 2),   # top
            (0, 378, 360, 2), # bottom
            (0, 0, 2, 380),   # left
            (358, 0, 2, 380)  # right
        ]):
            b = ui.Bar()
            b.SetParent(self)
            b.SetPosition(x, y)
            b.SetSize(w, h)
            b.SetColor(0xFF00CCFF)
            b.AddFlag("not_pick")
            b.Show()
            self.borders.append(b)
        
        # Titolo
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(180, 12)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("< MISSIONI GIORNALIERE >")
        self.titleText.SetPackedFontColor(0xFF00FFFF)
        self.titleText.Show()
        
        # Linea separatore
        self.sepLine = ui.Bar()
        self.sepLine.SetParent(self)
        self.sepLine.SetPosition(10, 35)
        self.sepLine.SetSize(340, 1)
        self.sepLine.SetColor(0xFF00CCFF)
        self.sepLine.AddFlag("not_pick")
        self.sepLine.Show()
        
        # Crea 3 slot missioni
        for i in range(3):
            slot = self.__CreateMissionSlot(i)
            self.missionSlots.append(slot)
        
        # ============================================================
        # SEZIONE INFO - Bonus, Penalità, Reset
        # ============================================================
        infoY = 275
        
        # Linea separatore info
        self.sepInfo = ui.Bar()
        self.sepInfo.SetParent(self)
        self.sepInfo.SetPosition(10, infoY)
        self.sepInfo.SetSize(340, 1)
        self.sepInfo.SetColor(0xFF00CCFF)
        self.sepInfo.AddFlag("not_pick")
        self.sepInfo.Show()
        
        # Box BONUS x1.5
        self.bonusBox = ui.Bar()
        self.bonusBox.SetParent(self)
        self.bonusBox.SetPosition(10, infoY + 8)
        self.bonusBox.SetSize(165, 40)
        self.bonusBox.SetColor(0x3300FF00)
        self.bonusBox.AddFlag("not_pick")
        self.bonusBox.Show()
        
        self.bonusTitle = ui.TextLine()
        self.bonusTitle.SetParent(self)
        self.bonusTitle.SetPosition(92, infoY + 12)
        self.bonusTitle.SetHorizontalAlignCenter()
        self.bonusTitle.SetText("BONUS x1.5")
        self.bonusTitle.SetPackedFontColor(0xFF00FF00)
        self.bonusTitle.Show()
        
        self.bonusDesc = ui.TextLine()
        self.bonusDesc.SetParent(self)
        self.bonusDesc.SetPosition(92, infoY + 28)
        self.bonusDesc.SetHorizontalAlignCenter()
        self.bonusDesc.SetText("Completa tutte e 3!")
        self.bonusDesc.SetPackedFontColor(0xFF88FF88)
        self.bonusDesc.Show()
        
        # Box PENALITA'
        self.penaltyBox = ui.Bar()
        self.penaltyBox.SetParent(self)
        self.penaltyBox.SetPosition(185, infoY + 8)
        self.penaltyBox.SetSize(165, 40)
        self.penaltyBox.SetColor(0x33FF0000)
        self.penaltyBox.AddFlag("not_pick")
        self.penaltyBox.Show()
        
        self.penaltyTitle = ui.TextLine()
        self.penaltyTitle.SetParent(self)
        self.penaltyTitle.SetPosition(267, infoY + 12)
        self.penaltyTitle.SetHorizontalAlignCenter()
        self.penaltyTitle.SetText("PENALITA'")
        self.penaltyTitle.SetPackedFontColor(0xFFFF4444)
        self.penaltyTitle.Show()
        
        self.penaltyDesc = ui.TextLine()
        self.penaltyDesc.SetParent(self)
        self.penaltyDesc.SetPosition(267, infoY + 28)
        self.penaltyDesc.SetHorizontalAlignCenter()
        self.penaltyDesc.SetText("Non completare = -Gloria")
        self.penaltyDesc.SetPackedFontColor(0xFFFF8888)
        self.penaltyDesc.Show()
        
        # Box RESET TIMER
        self.resetBox = ui.Bar()
        self.resetBox.SetParent(self)
        self.resetBox.SetPosition(10, infoY + 55)
        self.resetBox.SetSize(340, 25)
        self.resetBox.SetColor(0x44000000)
        self.resetBox.AddFlag("not_pick")
        self.resetBox.Show()
        
        self.resetLabel = ui.TextLine()
        self.resetLabel.SetParent(self)
        self.resetLabel.SetPosition(180, infoY + 60)
        self.resetLabel.SetHorizontalAlignCenter()
        self.resetLabel.SetText("Reset Missioni ogni giorno alle 00:05")
        self.resetLabel.SetPackedFontColor(0xFFAAAAAA)
        self.resetLabel.Show()
        
        # Pulsante chiudi
        self.closeBtn = ui.Button()
        self.closeBtn.SetParent(self)
        self.closeBtn.SetPosition(320, 8)
        self.closeBtn.SetUpVisual("d:/ymir work/ui/public/close_button_01.sub")
        self.closeBtn.SetOverVisual("d:/ymir work/ui/public/close_button_02.sub")
        self.closeBtn.SetDownVisual("d:/ymir work/ui/public/close_button_03.sub")
        # FIX: Usa ui.__mem_func__ per evitare memory leak
        self.closeBtn.SetEvent(ui.__mem_func__(self.Hide))
        self.closeBtn.Show()
        
        self.Hide()
    
    def OnMouseLeftButtonDown(self):
        self.isDragging = True
        self.dragStartX, self.dragStartY = wndMgr.GetMousePosition()
        return True
    
    def OnMouseLeftButtonUp(self):
        self.isDragging = False
        return True
    
    def OnUpdate(self):
        # Update time tracking
        ct = app.GetTime()
        dt = ct - self.lastUpdateTime
        self.lastUpdateTime = ct
        
        # Gestione drag
        if self.isDragging:
            mouseX, mouseY = wndMgr.GetMousePosition()
            x, y = self.GetGlobalPosition()
            newX = x + (mouseX - self.dragStartX)
            newY = y + (mouseY - self.dragStartY)
            self.SetPosition(newX, newY)
            self.dragStartX = mouseX
            self.dragStartY = mouseY
        
        # Auto-close timer
        if self.autoCloseTimer > 0.0:
            self.autoCloseTimer -= dt
            if self.autoCloseTimer <= 0.0:
                self.autoCloseTimer = 0.0
                self.Close()
    
    def __CreateMissionSlot(self, index):
        """Crea uno slot missione (y: 45 + index*75)"""
        yBase = 45 + index * 75
        slot = {}
        
        # Background slot
        bg = ui.Bar()
        bg.SetParent(self)
        bg.SetPosition(10, yBase)
        bg.SetSize(340, 68)
        bg.SetColor(0x44000000)
        bg.AddFlag("not_pick")
        bg.Show()
        slot["bg"] = bg
        
        # Icona missione (placeholder)
        iconBg = ui.Bar()
        iconBg.SetParent(self)
        iconBg.SetPosition(15, yBase + 5)
        iconBg.SetSize(50, 58)
        iconBg.SetColor(0x66000000)
        iconBg.AddFlag("not_pick")
        iconBg.Show()
        slot["iconBg"] = iconBg
        
        # Numero missione
        numText = ui.TextLine()
        numText.SetParent(self)
        numText.SetPosition(40, yBase + 20)
        numText.SetHorizontalAlignCenter()
        numText.SetText("#%d" % (index + 1))
        numText.SetPackedFontColor(0xFFAAAAAA)
        numText.Show()
        slot["numText"] = numText
        
        # Nome missione
        nameText = ui.TextLine()
        nameText.SetParent(self)
        nameText.SetPosition(75, yBase + 8)
        nameText.SetText("In attesa...")
        nameText.SetPackedFontColor(0xFFFFFFFF)
        nameText.Show()
        slot["nameText"] = nameText
        
        # Progresso text
        progressText = ui.TextLine()
        progressText.SetParent(self)
        progressText.SetPosition(75, yBase + 28)
        progressText.SetText("0 / 0")
        progressText.SetPackedFontColor(0xFFAAAAAA)
        progressText.Show()
        slot["progressText"] = progressText
        
        # Progress bar background
        barBg = ui.Bar()
        barBg.SetParent(self)
        barBg.SetPosition(75, yBase + 48)
        barBg.SetSize(200, 12)
        barBg.SetColor(0x44000000)
        barBg.AddFlag("not_pick")
        barBg.Show()
        slot["barBg"] = barBg
        
        # Progress bar fill
        barFill = ui.Bar()
        barFill.SetParent(self)
        barFill.SetPosition(75, yBase + 48)
        barFill.SetSize(0, 12)
        barFill.SetColor(0xFF00CCFF)
        barFill.AddFlag("not_pick")
        barFill.Show()
        slot["barFill"] = barFill
        self.progressBars.append(barFill)
        
        # Reward text
        rewardText = ui.TextLine()
        rewardText.SetParent(self)
        rewardText.SetPosition(285, yBase + 20)
        rewardText.SetText("+0")
        rewardText.SetPackedFontColor(0xFFFFD700)
        rewardText.Show()
        slot["rewardText"] = rewardText
        
        # Status icon/text
        statusText = ui.TextLine()
        statusText.SetParent(self)
        statusText.SetPosition(285, yBase + 40)
        statusText.SetText("")
        statusText.SetPackedFontColor(0xFF00FF00)
        statusText.Show()
        slot["statusText"] = statusText
        
        return slot
    
    def SetMissions(self, missions, theme):
        """Imposta i dati delle missioni"""
        self.missions = missions
        self.theme = theme
        self.__UpdateSlots()
    
    def __UpdateSlots(self):
        """Aggiorna gli slot con i dati delle missioni"""
        for i, slot in enumerate(self.missionSlots):
            if i < len(self.missions):
                m = self.missions[i]
                slot["nameText"].SetText(m["name"][:35])
                slot["progressText"].SetText("%d / %d" % (m["current"], m["target"]))
                slot["rewardText"].SetText("+%d" % m["reward"])
                
                # Progress bar
                pct = float(m["current"]) / float(m["target"]) if m["target"] > 0 else 0
                pct = min(1.0, pct)
                slot["barFill"].SetSize(int(200 * pct), 12)
                
                # Status
                if m["status"] == "completed":
                    slot["statusText"].SetText("[OK]")
                    slot["statusText"].SetPackedFontColor(0xFF00FF00)
                    slot["barFill"].SetColor(0xFF00FF00)
                elif m["status"] == "failed":
                    slot["statusText"].SetText("[X]")
                    slot["statusText"].SetPackedFontColor(0xFFFF0000)
                    slot["barFill"].SetColor(0xFFFF0000)
                else:
                    slot["statusText"].SetText("")
                    slot["barFill"].SetColor(self.theme["accent"] if self.theme else 0xFF00CCFF)
            else:
                slot["nameText"].SetText("Nessuna missione")
                slot["progressText"].SetText("")
                slot["rewardText"].SetText("")
                slot["statusText"].SetText("")
                slot["barFill"].SetSize(0, 12)
    
    def UpdateProgress(self, missionId, current, target):
        """Aggiorna progresso di una missione"""
        for i, m in enumerate(self.missions):
            if m["id"] == missionId:
                m["current"] = current
                m["target"] = target
                if i < len(self.missionSlots):
                    slot = self.missionSlots[i]
                    slot["progressText"].SetText("%d / %d" % (current, target))
                    pct = float(current) / float(target) if target > 0 else 0
                    pct = min(1.0, pct)
                    slot["barFill"].SetSize(int(200 * pct), 12)
                break
    
    def SetMissionComplete(self, missionId):
        """Marca una missione come completata"""
        for i, m in enumerate(self.missions):
            if m["id"] == missionId:
                m["status"] = "completed"
                if i < len(self.missionSlots):
                    slot = self.missionSlots[i]
                    slot["statusText"].SetText("[OK]")
                    slot["statusText"].SetPackedFontColor(0xFF00FF00)
                    slot["barFill"].SetColor(0xFF00FF00)
                    slot["barFill"].SetSize(200, 12)
                break
    
    def Open(self, missions=None, theme=None):
        """Apre la finestra, opzionalmente con nuovi dati"""
        if missions is not None:
            self.SetMissions(missions, theme)
        self.lastUpdateTime = app.GetTime()  # Reset timer tracking
        self.SetTop()
        self.Show()
    
    def OnPressEscapeKey(self):
        self.autoCloseTimer = 0.0  # Cancella auto-close quando l'utente chiude
        self.Hide()
        return True
    
    def Close(self):
        self.autoCloseTimer = 0.0
        self.Hide()


# ============================================================
# MISSION PROGRESS POPUP - Popup Progresso (3 secondi)
# ============================================================
class MissionProgressPopup(ui.Window):
    """Popup che appare per 3 sec quando si fa progresso"""
    
    def __init__(self):
        ui.Window.__init__(self)
        
        self.SetSize(250, 50)
        
        self.endTime = 0
        self.theme = None
        
        self.__BuildUI()
    
    def __BuildUI(self):
        screenWidth = wndMgr.GetScreenWidth()
        self.SetPosition(screenWidth // 2 - 125, 350)  # Sotto SystemMessageWindow (che è a 280)
        
        # Background
        self.bgBar = ui.Bar()
        self.bgBar.SetParent(self)
        self.bgBar.SetPosition(0, 0)
        self.bgBar.SetSize(250, 50)
        self.bgBar.SetColor(0xDD0A0A0A)
        self.bgBar.AddFlag("not_pick")
        self.bgBar.Show()
        
        # Bordi
        self.borderTop = ui.Bar()
        self.borderTop.SetParent(self)
        self.borderTop.SetPosition(0, 0)
        self.borderTop.SetSize(250, 2)
        self.borderTop.SetColor(0xFF00CCFF)
        self.borderTop.AddFlag("not_pick")
        self.borderTop.Show()
        
        self.borderBot = ui.Bar()
        self.borderBot.SetParent(self)
        self.borderBot.SetPosition(0, 48)
        self.borderBot.SetSize(250, 2)
        self.borderBot.SetColor(0xFF00CCFF)
        self.borderBot.AddFlag("not_pick")
        self.borderBot.Show()
        
        # Titolo
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(125, 8)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("MISSIONE")
        self.titleText.SetPackedFontColor(0xFF00FFFF)
        self.titleText.Show()
        
        # Progresso
        self.progressText = ui.TextLine()
        self.progressText.SetParent(self)
        self.progressText.SetPosition(125, 28)
        self.progressText.SetHorizontalAlignCenter()
        self.progressText.SetText("0 / 0")
        self.progressText.SetPackedFontColor(0xFFFFFFFF)
        self.progressText.Show()
        
        self.Hide()
    
    def ShowProgress(self, missionName, current, target, theme):
        """Mostra popup con progresso"""
        self.theme = theme
        
        # Nome troncato
        name = missionName[:25] + "..." if len(missionName) > 25 else missionName
        self.titleText.SetText(name)
        self.progressText.SetText("%d / %d" % (current, target))
        
        # Colori tema
        if theme:
            self.borderTop.SetColor(theme["accent"])
            self.borderBot.SetColor(theme["accent"])
            self.titleText.SetPackedFontColor(theme["text_title"])
        
        self.endTime = app.GetTime() + 3.0
        self.SetTop()
        self.Show()
    
    def OnUpdate(self):
        if self.endTime > 0 and app.GetTime() > self.endTime:
            self.Hide()
            self.endTime = 0


# ============================================================
# MISSION COMPLETE WINDOW - Effetto Completamento
# ============================================================
class MissionCompleteWindow(ui.Window):
    """Finestra effetto completamento missione"""
    
    def __init__(self):
        ui.Window.__init__(self)
        
        screenWidth = wndMgr.GetScreenWidth()
        screenHeight = wndMgr.GetScreenHeight()
        
        self.SetSize(screenWidth, screenHeight)
        self.SetPosition(0, 0)
        
        self.endTime = 0
        self.startTime = 0
        self.theme = None
        
        self.__BuildUI()
    
    def __BuildUI(self):
        screenWidth = wndMgr.GetScreenWidth()
        screenHeight = wndMgr.GetScreenHeight()
        
        # Flash overlay
        self.flashOverlay = ui.Bar()
        self.flashOverlay.SetParent(self)
        self.flashOverlay.SetPosition(0, 0)
        self.flashOverlay.SetSize(screenWidth, screenHeight)
        self.flashOverlay.SetColor(0x0000FF00)
        self.flashOverlay.AddFlag("not_pick")
        self.flashOverlay.Show()
        
        # Box centrale
        boxWidth = 400
        boxHeight = 120
        boxX = (screenWidth - boxWidth) // 2
        boxY = (screenHeight - boxHeight) // 2 - 50
        
        self.boxBg = ui.Bar()
        self.boxBg.SetParent(self)
        self.boxBg.SetPosition(boxX, boxY)
        self.boxBg.SetSize(boxWidth, boxHeight)
        self.boxBg.SetColor(0xEE0A0A0A)
        self.boxBg.AddFlag("not_pick")
        self.boxBg.Show()
        
        # Bordi box
        self.boxBorderTop = ui.Bar()
        self.boxBorderTop.SetParent(self)
        self.boxBorderTop.SetPosition(boxX, boxY)
        self.boxBorderTop.SetSize(boxWidth, 3)
        self.boxBorderTop.SetColor(0xFF00FF00)
        self.boxBorderTop.AddFlag("not_pick")
        self.boxBorderTop.Show()
        
        self.boxBorderBot = ui.Bar()
        self.boxBorderBot.SetParent(self)
        self.boxBorderBot.SetPosition(boxX, boxY + boxHeight - 3)
        self.boxBorderBot.SetSize(boxWidth, 3)
        self.boxBorderBot.SetColor(0xFF00FF00)
        self.boxBorderBot.AddFlag("not_pick")
        self.boxBorderBot.Show()
        
        # Titolo
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(screenWidth // 2, boxY + 20)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("< MISSIONE COMPLETATA >")
        self.titleText.SetPackedFontColor(0xFF00FF00)
        self.titleText.Show()
        
        # Nome missione
        self.nameText = ui.TextLine()
        self.nameText.SetParent(self)
        self.nameText.SetPosition(screenWidth // 2, boxY + 50)
        self.nameText.SetHorizontalAlignCenter()
        self.nameText.SetText("")
        self.nameText.SetPackedFontColor(0xFFFFFFFF)
        self.nameText.Show()
        
        # Reward
        self.rewardText = ui.TextLine()
        self.rewardText.SetParent(self)
        self.rewardText.SetPosition(screenWidth // 2, boxY + 80)
        self.rewardText.SetHorizontalAlignCenter()
        self.rewardText.SetText("")
        self.rewardText.SetPackedFontColor(0xFFFFD700)
        self.rewardText.Show()
        
        self.Hide()
    
    def ShowComplete(self, missionName, reward, theme):
        """Mostra effetto completamento"""
        self.theme = theme
        self.nameText.SetText(missionName)
        self.rewardText.SetText("+%d GLORIA" % reward)
        
        if theme:
            self.boxBorderTop.SetColor(theme["accent"])
            self.boxBorderBot.SetColor(theme["accent"])
            self.titleText.SetPackedFontColor(theme["text_title"])
        
        self.startTime = app.GetTime()
        self.endTime = self.startTime + 3.5
        self.SetTop()
        self.Show()
    
    def OnUpdate(self):
        if self.endTime == 0:
            return
        
        currentTime = app.GetTime()
        
        if currentTime > self.endTime:
            self.Hide()
            self.endTime = 0
            return
        
        elapsed = currentTime - self.startTime
        
        # Flash iniziale (0.5 sec)
        if elapsed < 0.5:
            alpha = int((1.0 - elapsed / 0.5) * 80)
            self.flashOverlay.SetColor((alpha << 24) | 0x00FF00)
        else:
            self.flashOverlay.SetColor(0x00000000)
        
        # Lampeggio bordi
        cycle = (elapsed * 3) % 2
        if cycle < 1:
            c = 0xFF00FF00
        else:
            c = 0xFF00CC00
        self.boxBorderTop.SetColor(c)
        self.boxBorderBot.SetColor(c)


# ============================================================
# ALL MISSIONS COMPLETE WINDOW - Bonus x1.5
# ============================================================
class AllMissionsCompleteWindow(ui.Window):
    """Effetto speciale quando si completano tutte e 3 le missioni"""
    
    def __init__(self):
        ui.Window.__init__(self)
        
        screenWidth = wndMgr.GetScreenWidth()
        screenHeight = wndMgr.GetScreenHeight()
        
        self.SetSize(screenWidth, screenHeight)
        self.SetPosition(0, 0)
        
        self.endTime = 0
        self.startTime = 0
        
        self.__BuildUI()
    
    def __BuildUI(self):
        screenWidth = wndMgr.GetScreenWidth()
        screenHeight = wndMgr.GetScreenHeight()
        
        # Flash overlay dorato
        self.flashOverlay = ui.Bar()
        self.flashOverlay.SetParent(self)
        self.flashOverlay.SetPosition(0, 0)
        self.flashOverlay.SetSize(screenWidth, screenHeight)
        self.flashOverlay.SetColor(0x00FFD700)
        self.flashOverlay.AddFlag("not_pick")
        self.flashOverlay.Show()
        
        # Box centrale grande
        boxWidth = 450
        boxHeight = 150
        boxX = (screenWidth - boxWidth) // 2
        boxY = (screenHeight - boxHeight) // 2 - 50
        
        self.boxBg = ui.Bar()
        self.boxBg.SetParent(self)
        self.boxBg.SetPosition(boxX, boxY)
        self.boxBg.SetSize(boxWidth, boxHeight)
        self.boxBg.SetColor(0xEE0A0A0A)
        self.boxBg.AddFlag("not_pick")
        self.boxBg.Show()
        
        # Bordi oro
        self.boxBorderTop = ui.Bar()
        self.boxBorderTop.SetParent(self)
        self.boxBorderTop.SetPosition(boxX, boxY)
        self.boxBorderTop.SetSize(boxWidth, 4)
        self.boxBorderTop.SetColor(0xFFFFD700)
        self.boxBorderTop.AddFlag("not_pick")
        self.boxBorderTop.Show()
        
        self.boxBorderBot = ui.Bar()
        self.boxBorderBot.SetParent(self)
        self.boxBorderBot.SetPosition(boxX, boxY + boxHeight - 4)
        self.boxBorderBot.SetSize(boxWidth, 4)
        self.boxBorderBot.SetColor(0xFFFFD700)
        self.boxBorderBot.AddFlag("not_pick")
        self.boxBorderBot.Show()
        
        # Titolo speciale
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(screenWidth // 2, boxY + 20)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("=== TUTTE LE MISSIONI COMPLETE ===")
        self.titleText.SetPackedFontColor(0xFFFFD700)
        self.titleText.Show()
        
        # Bonus text
        self.bonusText = ui.TextLine()
        self.bonusText.SetParent(self)
        self.bonusText.SetPosition(screenWidth // 2, boxY + 55)
        self.bonusText.SetHorizontalAlignCenter()
        self.bonusText.SetText("BONUS COMPLETAMENTO x1.5")
        self.bonusText.SetPackedFontColor(0xFFFFAA00)
        self.bonusText.Show()
        
        # Reward
        self.rewardText = ui.TextLine()
        self.rewardText.SetParent(self)
        self.rewardText.SetPosition(screenWidth // 2, boxY + 90)
        self.rewardText.SetHorizontalAlignCenter()
        self.rewardText.SetText("")
        self.rewardText.SetPackedFontColor(0xFFFFFFFF)
        self.rewardText.Show()
        
        # Sub text
        self.subText = ui.TextLine()
        self.subText.SetParent(self)
        self.subText.SetPosition(screenWidth // 2, boxY + 115)
        self.subText.SetHorizontalAlignCenter()
        self.subText.SetText("Ottimo lavoro, Cacciatore!")
        self.subText.SetPackedFontColor(0xFFAAAAAA)
        self.subText.Show()
        
        self.Hide()
    
    def ShowBonus(self, bonusGlory, theme):
        """Mostra effetto bonus completamento totale"""
        self.rewardText.SetText("+%d GLORIA BONUS" % bonusGlory)
        
        self.startTime = app.GetTime()
        self.endTime = self.startTime + 5.0
        self.SetTop()
        self.Show()
    
    def OnUpdate(self):
        if self.endTime == 0:
            return
        
        currentTime = app.GetTime()
        
        if currentTime > self.endTime:
            self.Hide()
            self.endTime = 0
            return
        
        elapsed = currentTime - self.startTime
        
        # Flash iniziale dorato (0.8 sec)
        if elapsed < 0.8:
            alpha = int((1.0 - elapsed / 0.8) * 100)
            self.flashOverlay.SetColor((alpha << 24) | 0xFFD700)
        else:
            self.flashOverlay.SetColor(0x00000000)
        
        # Lampeggio bordi oro
        cycle = (elapsed * 2.5) % 2
        if cycle < 1:
            self.boxBorderTop.SetColor(0xFFFFD700)
            self.boxBorderBot.SetColor(0xFFFFD700)
            self.titleText.SetPackedFontColor(0xFFFFD700)
        else:
            self.boxBorderTop.SetColor(0xFFFFAA00)
            self.boxBorderBot.SetColor(0xFFFFAA00)
            self.titleText.SetPackedFontColor(0xFFFFEE55)


# ============================================================
# EVENTS SCHEDULE WINDOW - Finestra Eventi Programmati
# Trascinabile, con spiegazioni su come partecipare
# ============================================================
class EventsScheduleWindow(ui.Window):
    """Finestra per visualizzare gli eventi del giorno con scroll"""
    
    SLOT_HEIGHT = 58
    VISIBLE_SLOTS = 6
    MAX_SLOTS = 50  # Aumentato per supportare tutti gli eventi del giorno (42-49)
    
    def __init__(self):
        ui.Window.__init__(self)
        
        self.SetSize(420, 480)  # Piu larga per scrollbar
        self.SetPosition(100, 80)
        self.AddFlag("movable")
        
        self.events = []
        self.eventSlots = []
        self.theme = None
        self.isDragging = False
        self.dragStartX = 0
        self.dragStartY = 0
        self.scrollPos = 0
        
        self.__BuildUI()
    
    def __BuildUI(self):
        # Background principale
        self.bgMain = ui.Bar()
        self.bgMain.SetParent(self)
        self.bgMain.SetPosition(0, 0)
        self.bgMain.SetSize(420, 480)
        self.bgMain.SetColor(0xEE0A0A0A)
        self.bgMain.AddFlag("not_pick")
        self.bgMain.Show()
        
        # Bordi arancioni
        self.borders = []
        for i, (x, y, w, h) in enumerate([
            (0, 0, 420, 2),   # top
            (0, 478, 420, 2), # bottom
            (0, 0, 2, 480),   # left
            (418, 0, 2, 480)  # right
        ]):
            b = ui.Bar()
            b.SetParent(self)
            b.SetPosition(x, y)
            b.SetSize(w, h)
            b.SetColor(0xFFFF6600)
            b.AddFlag("not_pick")
            b.Show()
            self.borders.append(b)
        
        # Titolo
        self.titleText = ui.TextLine()
        self.titleText.SetParent(self)
        self.titleText.SetPosition(200, 12)
        self.titleText.SetHorizontalAlignCenter()
        self.titleText.SetText("< EVENTI DI OGGI >")
        self.titleText.SetPackedFontColor(0xFFFFAA00)
        self.titleText.Show()
        
        # Linea separatore titolo
        self.sepLine = ui.Bar()
        self.sepLine.SetParent(self)
        self.sepLine.SetPosition(10, 38)
        self.sepLine.SetSize(398, 1)
        self.sepLine.SetColor(0xFFFF6600)
        self.sepLine.AddFlag("not_pick")
        self.sepLine.Show()
        
        # Messaggio se non ci sono eventi
        self.noEventsText = ui.TextLine()
        self.noEventsText.SetParent(self)
        self.noEventsText.SetPosition(200, 180)
        self.noEventsText.SetHorizontalAlignCenter()
        self.noEventsText.SetText("Nessun evento programmato oggi")
        self.noEventsText.SetPackedFontColor(0xFF888888)
        self.noEventsText.Hide()
        
        # ============================================================
        # AREA SCROLLABILE
        # ============================================================
        listAreaHeight = self.VISIBLE_SLOTS * self.SLOT_HEIGHT  # 6 * 58 = 348
        
        # Background area lista
        self.listBg = ui.Bar()
        self.listBg.SetParent(self)
        self.listBg.SetPosition(8, 45)
        self.listBg.SetSize(385, listAreaHeight)
        self.listBg.SetColor(0x22000000)
        self.listBg.AddFlag("not_pick")
        self.listBg.Show()
        
        # ScrollBar
        self.scrollBar = ui.ScrollBar()
        self.scrollBar.SetParent(self)
        self.scrollBar.SetPosition(395, 45)
        self.scrollBar.SetScrollBarSize(listAreaHeight)
        self.scrollBar.SetScrollEvent(self.__OnScroll)
        self.scrollBar.Hide()  # Nascosta se pochi eventi
        
        # Crea solo gli slot visibili (6) - i dati vengono aggiornati dallo scroll
        for i in range(self.VISIBLE_SLOTS):
            slot = self.__CreateEventSlot(i)
            self.eventSlots.append(slot)
        
        # ============================================================
        # SEZIONE INFO - Come partecipare
        # ============================================================
        infoY = 400
        
        # Linea separatore info
        self.sepInfo = ui.Bar()
        self.sepInfo.SetParent(self)
        self.sepInfo.SetPosition(10, infoY)
        self.sepInfo.SetSize(398, 1)
        self.sepInfo.SetColor(0xFFFF6600)
        self.sepInfo.AddFlag("not_pick")
        self.sepInfo.Show()
        
        # Box INFO
        self.infoBox = ui.Bar()
        self.infoBox.SetParent(self)
        self.infoBox.SetPosition(10, infoY + 8)
        self.infoBox.SetSize(398, 62)
        self.infoBox.SetColor(0x33FF6600)
        self.infoBox.AddFlag("not_pick")
        self.infoBox.Show()
        
        self.infoTitle = ui.TextLine()
        self.infoTitle.SetParent(self)
        self.infoTitle.SetPosition(210, infoY + 12)
        self.infoTitle.SetHorizontalAlignCenter()
        self.infoTitle.SetText("COME PARTECIPARE")
        self.infoTitle.SetPackedFontColor(0xFFFFAA00)
        self.infoTitle.Show()
        
        self.infoLine1 = ui.TextLine()
        self.infoLine1.SetParent(self)
        self.infoLine1.SetPosition(210, infoY + 28)
        self.infoLine1.SetHorizontalAlignCenter()
        self.infoLine1.SetText("Quando un evento e' [IN CORSO], clicca 'Partecipa'")
        self.infoLine1.SetPackedFontColor(0xFFCCCCCC)
        self.infoLine1.Show()
        
        self.infoLine2 = ui.TextLine()
        self.infoLine2.SetParent(self)
        self.infoLine2.SetPosition(210, infoY + 44)
        self.infoLine2.SetHorizontalAlignCenter()
        self.infoLine2.SetText("Bonus Gloria attivo per tutta la durata dell'evento!")
        self.infoLine2.SetPackedFontColor(0xFF88FF88)
        self.infoLine2.Show()
        
        # Pulsante chiudi
        self.closeBtn = ui.Button()
        self.closeBtn.SetParent(self)
        self.closeBtn.SetPosition(380, 8)
        self.closeBtn.SetUpVisual("d:/ymir work/ui/public/close_button_01.sub")
        self.closeBtn.SetOverVisual("d:/ymir work/ui/public/close_button_02.sub")
        self.closeBtn.SetDownVisual("d:/ymir work/ui/public/close_button_03.sub")
        # FIX: Usa ui.__mem_func__ per evitare memory leak
        self.closeBtn.SetEvent(ui.__mem_func__(self.Hide))
        self.closeBtn.Show()
        
        self.Hide()
    
    def __OnScroll(self):
        """Callback quando si scrolla"""
        scrollPos = self.scrollBar.GetPos()
        maxScroll = max(0, len(self.events) - self.VISIBLE_SLOTS)
        self.scrollPos = int(scrollPos * maxScroll + 0.5)
        self.__UpdateSlotPositions()
    
    def __UpdateSlotPositions(self):
        """Aggiorna posizione e visibilita degli slot in base allo scroll"""
        for slotIdx, slot in enumerate(self.eventSlots):
            # slotIdx = posizione visiva (0-5), eventIdx = quale evento mostrare
            eventIdx = slotIdx + self.scrollPos
            
            if slotIdx < self.VISIBLE_SLOTS and eventIdx < len(self.events):
                # Slot visibile - mostra evento eventIdx nella posizione slotIdx
                yPos = 48 + slotIdx * self.SLOT_HEIGHT
                slot["bg"].SetPosition(10, yPos)
                slot["timeText"].SetPosition(20, yPos + 8)
                slot["nameText"].SetPosition(80, yPos + 8)
                slot["rewardText"].SetPosition(80, yPos + 28)
                slot["statusText"].SetPosition(320, yPos + 18)
                slot["joinBtn"].SetPosition(300, yPos + 12)
                
                # Aggiorna dati slot con evento corretto
                e = self.events[eventIdx]
                etype = e.get("type", "glory_rush")
                ecolor = getattr(self, 'TYPE_COLORS', {}).get(etype, 0xFFFFFFFF)
                
                slot["timeText"].SetText(e.get("start_time", "--:--"))
                slot["nameText"].SetText(e.get("name", "Evento")[:28])
                slot["nameText"].SetPackedFontColor(ecolor)
                slot["rewardText"].SetText("%s [%s+]" % (e.get("reward", ""), e.get("min_rank", "E")))
                slot["eventId"] = e.get("id", 0)
                
                slot["bg"].Show()
                slot["timeText"].Show()
                slot["nameText"].Show()
                slot["rewardText"].Show()
                
                status = e.get("status", "pending")
                if status == "active" and status != "joined":
                    # FIX: Usa ui.__mem_func__ invece di lambda per evitare memory leak
                    slot["joinBtn"].SetEvent(ui.__mem_func__(self.__OnJoinEvent), e.get("id", 0))
                    slot["joinBtn"].Show()
                    slot["statusText"].Hide()
                else:
                    if status == "joined":
                        slot["statusText"].SetText("[ISCRITTO]")
                        slot["statusText"].SetPackedFontColor(0xFF00FF00)
                    elif status == "active":
                        slot["statusText"].SetText("[IN CORSO]")
                        slot["statusText"].SetPackedFontColor(0xFF00FF00)
                    elif status == "ended":
                        slot["statusText"].SetText("[TERMINATO]")
                        slot["statusText"].SetPackedFontColor(0xFF888888)
                    else:
                        slot["statusText"].SetText("[%s]" % e.get("end_time", "--:--"))
                        slot["statusText"].SetPackedFontColor(0xFFAAAAAA)
                    slot["statusText"].Show()
                    slot["joinBtn"].Hide()
            else:
                # Slot nascosto
                slot["bg"].Hide()
                slot["timeText"].Hide()
                slot["nameText"].Hide()
                slot["rewardText"].Hide()
                slot["statusText"].Hide()
                slot["joinBtn"].Hide()
    
    def OnMouseLeftButtonDown(self):
        self.isDragging = True
        self.dragStartX, self.dragStartY = wndMgr.GetMousePosition()
        return True
    
    def OnMouseLeftButtonUp(self):
        self.isDragging = False
        return True
    
    def OnUpdate(self):
        if self.isDragging:
            mouseX, mouseY = wndMgr.GetMousePosition()
            x, y = self.GetGlobalPosition()
            newX = x + (mouseX - self.dragStartX)
            newY = y + (mouseY - self.dragStartY)
            self.SetPosition(newX, newY)
            self.dragStartX = mouseX
            self.dragStartY = mouseY
    
    def __CreateEventSlot(self, index):
        """Crea uno slot evento"""
        yBase = 48 + index * self.SLOT_HEIGHT
        slot = {}
        
        # Background slot
        bg = ui.Bar()
        bg.SetParent(self)
        bg.SetPosition(10, yBase)
        bg.SetSize(380, 52)
        bg.SetColor(0x33000000)
        bg.AddFlag("not_pick")
        bg.Hide()
        slot["bg"] = bg
        
        # Orario
        timeText = ui.TextLine()
        timeText.SetParent(self)
        timeText.SetPosition(20, yBase + 8)
        timeText.SetText("--:--")
        timeText.SetPackedFontColor(0xFFFFAA00)
        timeText.Hide()
        slot["timeText"] = timeText
        
        # Nome evento
        nameText = ui.TextLine()
        nameText.SetParent(self)
        nameText.SetPosition(80, yBase + 8)
        nameText.SetText("Evento")
        nameText.SetPackedFontColor(0xFFFFFFFF)
        nameText.Hide()
        slot["nameText"] = nameText
        
        # Reward
        rewardText = ui.TextLine()
        rewardText.SetParent(self)
        rewardText.SetPosition(80, yBase + 28)
        rewardText.SetText("")
        rewardText.SetPackedFontColor(0xFFAAAAAA)
        rewardText.Hide()
        slot["rewardText"] = rewardText
        
        # Status
        statusText = ui.TextLine()
        statusText.SetParent(self)
        statusText.SetPosition(320, yBase + 18)
        statusText.SetText("")
        statusText.SetPackedFontColor(0xFF00FF00)
        statusText.Hide()
        slot["statusText"] = statusText
        
        # Pulsante partecipa
        joinBtn = ui.Button()
        joinBtn.SetParent(self)
        joinBtn.SetPosition(300, yBase + 12)
        joinBtn.SetUpVisual("d:/ymir work/ui/public/small_button_01.sub")
        joinBtn.SetOverVisual("d:/ymir work/ui/public/small_button_02.sub")
        joinBtn.SetDownVisual("d:/ymir work/ui/public/small_button_03.sub")
        joinBtn.SetText("Partecipa")
        joinBtn.Hide()
        slot["joinBtn"] = joinBtn
        slot["eventId"] = 0
        
        return slot
    
    def SetEvents(self, events, theme):
        """Imposta i dati degli eventi"""
        self.events = events
        self.theme = theme
        self.scrollPos = 0
        
        # Mostra/nascondi scrollbar e messaggio vuoto
        if len(events) == 0:
            self.noEventsText.Show()
            self.scrollBar.Hide()
        else:
            self.noEventsText.Hide()
            if len(events) > self.VISIBLE_SLOTS:
                self.scrollBar.SetPos(0)
                self.scrollBar.Show()
            else:
                self.scrollBar.Hide()
        
        # Salva i colori per tipo evento
        self.TYPE_COLORS = {
            "glory_rush": 0xFFFFD700,
            "first_rift": 0xFF9932CC,
            "first_boss": 0xFFFF4444,
            "boss_massacre": 0xFFFF6600,
            "rift_hunt": 0xFF9932CC,
            "super_metin": 0xFFFF8800,
            "treasure_race": 0xFFFFD700,
            "pvp_tournament": 0xFFFF0000,
            "survival": 0xFF00CCFF,
            "double_spawn": 0xFFFF4444,
            "metin_frenzy": 0xFFFF8800,
        }
        
        self.__UpdateSlotPositions()
    
    def __OnJoinEvent(self, eventId):
        """Invia richiesta partecipazione evento"""
        net.SendChatPacket("/hunter_join_event %d" % eventId)
    
    def SetEventJoined(self, eventId):
        """Aggiorna slot quando ci si iscrive"""
        for i, e in enumerate(self.events):
            if e["id"] == eventId:
                e["status"] = "joined"
                if i < len(self.eventSlots):
                    slot = self.eventSlots[i]
                    slot["statusText"].SetText("[ISCRITTO]")
                    slot["statusText"].SetPackedFontColor(0xFF00FF00)
                    slot["joinBtn"].Hide()
                break
    
    def Open(self, events, theme):
        """Apre la finestra con i dati"""
        import dbg
        dbg.TraceError("EventsScheduleWindow.Open called with " + str(len(events)) + " events")
        self.SetEvents(events, theme)
        self.SetTop()
        self.Show()
        dbg.TraceError("EventsScheduleWindow.Show() called")
    
    def OnPressEscapeKey(self):
        self.Hide()
        return True


# ============================================================
# GLOBAL INSTANCES (usate da game.py)
# ============================================================
g_whatIfWindow = None
g_bossAlertWindow = None
g_systemMsgWindow = None
g_emergencyWindow = None
g_eventWindow = None
g_rivalWindow = None
g_systemInitWindow = None
g_awakeningWindow = None
g_hunterActivationWindow = None
g_rankUpWindow = None
g_overtakeWindow = None

def GetWhatIfWindow():
    global g_whatIfWindow
    if g_whatIfWindow is None:
        g_whatIfWindow = WhatIfChoiceWindow()
    return g_whatIfWindow

def GetSystemMessageWindow():
    global g_systemMsgWindow
    if g_systemMsgWindow is None:
        g_systemMsgWindow = SystemMessageWindow()
    return g_systemMsgWindow

def GetEmergencyWindow():
    global g_emergencyWindow
    if g_emergencyWindow is None:
        g_emergencyWindow = EmergencyQuestWindow()
    return g_emergencyWindow
def GetEventWindow():
    global g_eventWindow
    if g_eventWindow is None:
        g_eventWindow = EventStatusWindow()
    return g_eventWindow

def GetRivalWindow():
    global g_rivalWindow
    if g_rivalWindow is None:
        g_rivalWindow = RivalTrackerWindow()
    return g_rivalWindow

def GetBossAlertWindow():
    global g_bossAlertWindow
    if g_bossAlertWindow is None:
        g_bossAlertWindow = BossAlertWindow()
    return g_bossAlertWindow

def GetSystemInitWindow():
    global g_systemInitWindow
    if g_systemInitWindow is None:
        g_systemInitWindow = SystemInitWindow()
    return g_systemInitWindow

def GetAwakeningWindow():
    global g_awakeningWindow
    if g_awakeningWindow is None:
        g_awakeningWindow = AwakeningWindow()
    return g_awakeningWindow

def GetHunterActivationWindow():
    global g_hunterActivationWindow
    if g_hunterActivationWindow is None:
        g_hunterActivationWindow = HunterActivationWindow()
    return g_hunterActivationWindow

def GetRankUpWindow():
    global g_rankUpWindow
    if g_rankUpWindow is None:
        g_rankUpWindow = RankUpWindow()
    return g_rankUpWindow

def GetOvertakeWindow():
    global g_overtakeWindow
    if g_overtakeWindow is None:
        g_overtakeWindow = OvertakeWindow()
    return g_overtakeWindow
# ============================================================
# DAILY MISSIONS GLOBAL INSTANCES
# ============================================================
g_dailyMissionsWindow = None
g_eventsScheduleWindow = None
g_missionProgressPopup = None
g_missionCompleteWindow = None
g_allMissionsCompleteWindow = None

def GetDailyMissionsWindow():
    global g_dailyMissionsWindow
    if g_dailyMissionsWindow is None:
        g_dailyMissionsWindow = DailyMissionsWindow()
    return g_dailyMissionsWindow

def GetEventsScheduleWindow():
    global g_eventsScheduleWindow
    if g_eventsScheduleWindow is None:
        g_eventsScheduleWindow = EventsScheduleWindow()
    return g_eventsScheduleWindow

def GetMissionProgressPopup():
    global g_missionProgressPopup
    if g_missionProgressPopup is None:
        g_missionProgressPopup = MissionProgressPopup()
    return g_missionProgressPopup

def GetMissionCompleteWindow():
    global g_missionCompleteWindow
    if g_missionCompleteWindow is None:
        g_missionCompleteWindow = MissionCompleteWindow()
    return g_missionCompleteWindow

def GetAllMissionsCompleteWindow():
    global g_allMissionsCompleteWindow
    if g_allMissionsCompleteWindow is None:
        g_allMissionsCompleteWindow = AllMissionsCompleteWindow()
    return g_allMissionsCompleteWindow