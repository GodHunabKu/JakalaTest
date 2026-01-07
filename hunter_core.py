# -*- coding: utf-8 -*-
# ═══════════════════════════════════════════════════════════════════════════════
#  HUNTER SYSTEM - CORE MODULE
#  Configurazioni, costanti, colori, mixin e utility condivise
#  "I alone level up." - Solo Leveling Style
# ═══════════════════════════════════════════════════════════════════════════════

import ui
import wndMgr
import app
import os

# ═══════════════════════════════════════════════════════════════════════════════
#  CONFIG FILE PATH - Per persistenza posizioni finestre
# ═══════════════════════════════════════════════════════════════════════════════
HUNTER_CONFIG_FILE = "hunter_config.cfg"

# ═══════════════════════════════════════════════════════════════════════════════
#  MEMORIA POSIZIONI FINESTRE (Session-based + File Persistence)
# ═══════════════════════════════════════════════════════════════════════════════
# Dizionario globale per memorizzare le posizioni delle finestre durante la sessione
WINDOW_POSITIONS = {}
_configLoaded = False

def _LoadConfigFile():
    """Carica le posizioni salvate dal file di configurazione"""
    global WINDOW_POSITIONS, _configLoaded
    if _configLoaded:
        return
    _configLoaded = True
    
    try:
        if os.path.exists(HUNTER_CONFIG_FILE):
            with open(HUNTER_CONFIG_FILE, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line and '=' in line:
                        parts = line.split('=', 1)
                        if len(parts) == 2:
                            key = parts[0].strip()
                            value = parts[1].strip()
                            # Formato: windowName_pos=x,y
                            if key.endswith('_pos') and ',' in value:
                                windowName = key[:-4]  # Rimuove "_pos"
                                coords = value.split(',')
                                if len(coords) == 2:
                                    try:
                                        x = int(coords[0])
                                        y = int(coords[1])
                                        WINDOW_POSITIONS[windowName] = (x, y)
                                    except ValueError:
                                        pass
    except Exception as e:
        pass  # Ignora errori di lettura

def _SaveConfigFile():
    """Salva tutte le posizioni nel file di configurazione"""
    try:
        with open(HUNTER_CONFIG_FILE, 'w') as f:
            f.write("# Hunter System Configuration\n")
            f.write("# Window positions (do not edit manually)\n\n")
            for windowName, (x, y) in WINDOW_POSITIONS.items():
                f.write("%s_pos=%d,%d\n" % (windowName, x, y))
    except Exception as e:
        pass  # Ignora errori di scrittura

def SaveWindowPosition(windowName, x, y):
    """Salva la posizione di una finestra (RAM + File)"""
    _LoadConfigFile()  # Assicura che il config sia caricato
    WINDOW_POSITIONS[windowName] = (x, y)
    _SaveConfigFile()  # Persiste su file

def GetWindowPosition(windowName, defaultX, defaultY):
    """Recupera la posizione salvata o ritorna il default"""
    _LoadConfigFile()  # Assicura che il config sia caricato
    return WINDOW_POSITIONS.get(windowName, (defaultX, defaultY))

def HasSavedPosition(windowName):
    """Verifica se esiste una posizione salvata"""
    _LoadConfigFile()  # Assicura che il config sia caricato
    return windowName in WINDOW_POSITIONS


# ═══════════════════════════════════════════════════════════════════════════════
#  COLORI BASE DEL SISTEMA
# ═══════════════════════════════════════════════════════════════════════════════
COLOR_BG_DARK = 0xCC000000          # Sfondo nero 80% opacità
COLOR_BG_HOVER = 0x44FFFFFF         # Hover leggero
COLOR_TEXT_NORMAL = 0xFFFFFFFF
COLOR_TEXT_MUTED = 0xFFAAAAAA

# Colori per Rank Hunter
RANK_COLORS = {
    "E": 0xFF808080,  # Grigio - Iniziato
    "D": 0xFF00FF00,  # Verde - Apprendista
    "C": 0xFF00FFFF,  # Ciano - Cacciatore
    "B": 0xFF0066FF,  # Blu - Veterano
    "A": 0xFFAA00FF,  # Viola - Elite
    "S": 0xFFFF6600,  # Arancione - Leggenda
    "N": 0xFFFF0000,  # Rosso - Monarca Nazionale
}

RANK_NAMES = {
    "E": "Iniziato",
    "D": "Apprendista", 
    "C": "Cacciatore",
    "B": "Veterano",
    "A": "Elite",
    "S": "Campione",
    "N": "Nazionale",
}

RANK_TITLES = {
    "E": "Il Risvegliato",
    "D": "Il Sopravvissuto",
    "C": "Il Cacciatore",
    "B": "L'Elite",
    "A": "Il Predatore",
    "S": "La Leggenda",
    "N": "Il Monarca delle Ombre",
}

RANK_QUOTES = {
    "E": '"Ogni viaggio inizia con un passo."',
    "D": '"Hai superato i più deboli."',
    "C": '"Il tuo nome inizia a farsi conoscere."',
    "B": '"I Gate tremano al tuo arrivo."',
    "A": '"Solo i folli osano sfidarti."',
    "S": '"Sei tra i più forti dell\'umanità."',
    "N": '"IO SONO IL MONARCA."',
}

# Schemi colori per Fratture e Codici Colore
COLOR_SCHEMES = {
    "GREEN": {
        "border": 0xFF00FF00,       # Verde Neon
        "glow": 0x4400FF00,
        "title": 0xFF55FF55,
        "text": 0xFFDDFFDD,
        "accent": 0xFF00FF00,
    },
    "BLUE": {
        "border": 0xFF0099FF,       # Blu System
        "glow": 0x440099FF,
        "title": 0xFF00CCFF,
        "text": 0xFFDDFFFF,
        "accent": 0xFF0099FF,
    },
    "ORANGE": {
        "border": 0xFFFF6600,       # Arancione Fuoco
        "glow": 0x44FF6600,
        "title": 0xFFFFAA00,
        "text": 0xFFFFDDBB,
        "accent": 0xFFFF6600,
    },
    "RED": {
        "border": 0xFFFF0000,       # Rosso Sangue
        "glow": 0x44FF0000,
        "title": 0xFFFF4444,
        "text": 0xFFFFDDDD,
        "accent": 0xFFFF0000,
    },
    "GOLD": {
        "border": 0xFFFFD700,       # Oro
        "glow": 0x44FFD700,
        "title": 0xFFFFEE55,
        "text": 0xFFFFFFDD,
        "accent": 0xFFFFD700,
    },
    "PURPLE": {
        "border": 0xFF9900FF,       # Viola Ombra
        "glow": 0x449900FF,
        "title": 0xFFCC55FF,
        "text": 0xFFEEDDFF,
        "accent": 0xFF9900FF,
    },
    "CYAN": {
        "border": 0xFF00FFFF,       # Ciano
        "glow": 0x4400FFFF,
        "title": 0xFF44FFFF,
        "text": 0xFFDDFFFF,
        "accent": 0xFF00FFFF,
    },
    "BLACKWHITE": {
        "border": 0xFFFFFFFF,       # Bianco Puro
        "glow": 0x44FFFFFF,
        "title": 0xFFEEEEEE,
        "text": 0xFFCCCCCC,
        "accent": 0xFFFFFFFF,
    },
    "SYSTEM": {
        "border": 0xFF00A8FF,       # Azzurro Sistema
        "glow": 0x4400A8FF,
        "title": 0xFF00CCFF,
        "text": 0xFFDDFFFF,
        "accent": 0xFF00A8FF,
    },
}

# Schema default
DEFAULT_SCHEME = COLOR_SCHEMES["PURPLE"]

# Mappatura ID Frattura -> Colore
FRACTURE_ID_MAP = {
    "16060": "GREEN",       # Frattura Primordiale
    "16061": "BLUE",        # Frattura Astrale
    "16062": "ORANGE",      # Frattura Abissale
    "16063": "RED",         # Frattura Cremisi
    "16064": "GOLD",        # Frattura Aurea
    "16065": "PURPLE",      # Frattura Infausta
    "16066": "BLACKWHITE",  # Frattura del Giudizio
    "power_offer": "PURPLE",
    "save_npc": "BLUE",
    "dark_pact": "RED",
    "rival_mercy": "ORANGE",
    "treasure_split": "GOLD",
}


# ═══════════════════════════════════════════════════════════════════════════════
#  FUNZIONI UTILITY
# ═══════════════════════════════════════════════════════════════════════════════

def GetRankColor(rank):
    """Ritorna il colore per un rank specifico"""
    return RANK_COLORS.get(rank, 0xFFFFFFFF)

def GetColorScheme(colorCode):
    """Ritorna lo schema colori per un codice (GREEN, BLUE, etc.)"""
    if colorCode:
        return COLOR_SCHEMES.get(colorCode.upper(), DEFAULT_SCHEME)
    return DEFAULT_SCHEME

def GetColorFromKey(colorKey):
    """Converte chiave colore (E,D,C,BLUE,GREEN...) in intero"""
    # Prova prima i colori scheme
    scheme = COLOR_SCHEMES.get(colorKey.upper() if colorKey else "", None)
    if scheme:
        return scheme["border"]
    # Prova i rank
    return RANK_COLORS.get(colorKey, 0xFF808080)

def DetectColorFromText(text, defaultColor="PURPLE"):
    """Auto-detect colore dal testo (per fratture)"""
    if not text:
        return defaultColor
    upperText = text.upper()
    if "PRIMORDIALE" in upperText: return "GREEN"
    if "ASTRALE" in upperText: return "BLUE"
    if "ABISSALE" in upperText: return "ORANGE"
    if "CREMISI" in upperText: return "RED"
    if "AUREA" in upperText: return "GOLD"
    if "INFAUSTA" in upperText: return "PURPLE"
    if "GIUDIZIO" in upperText or "INSTABILE" in upperText: return "BLACKWHITE"
    return defaultColor

def FormatNumber(num):
    """Formatta un numero con separatori migliaia"""
    s = str(int(num))
    r = ""
    while len(s) > 3:
        r = "." + s[-3:] + r
        s = s[:-3]
    return s + r

def FormatTime(seconds):
    """Formatta secondi in MM:SS o HH:MM:SS"""
    if seconds < 0:
        return "00:00"
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = int(seconds % 60)
    if h > 0:
        return "%02d:%02d:%02d" % (h, m, s)
    return "%02d:%02d" % (m, s)


# ═══════════════════════════════════════════════════════════════════════════════
#  MIXIN PER FINESTRE MOVIBILI
# ═══════════════════════════════════════════════════════════════════════════════
class DraggableMixin:
    """
    Mixin che aggiunge funzionalità di drag a qualsiasi finestra.
    Memorizza automaticamente la posizione durante la sessione.
    
    Uso:
        class MyWindow(ui.Window, DraggableMixin):
            def __init__(self):
                ui.Window.__init__(self)
                self.InitDraggable("MyWindow", defaultX, defaultY)
    """
    
    def InitDraggable(self, windowName, defaultX=None, defaultY=None):
        """Inizializza il sistema di drag per questa finestra"""
        self.windowName = windowName
        self.isDragging = False
        self.dragOffsetX = 0
        self.dragOffsetY = 0
        
        # Imposta flag movable e float
        if hasattr(self, 'AddFlag'):
            self.AddFlag("movable")
            self.AddFlag("float")
        
        # Recupera posizione salvata o usa default
        if defaultX is not None and defaultY is not None:
            savedX, savedY = GetWindowPosition(windowName, defaultX, defaultY)
            self.SetPosition(savedX, savedY)
    
    def OnMouseLeftButtonDown(self):
        """Inizia il drag"""
        self.isDragging = True
        mouseX, mouseY = wndMgr.GetMousePosition()
        winX, winY = self.GetGlobalPosition()
        self.dragOffsetX = mouseX - winX
        self.dragOffsetY = mouseY - winY
        return True
    
    def OnMouseLeftButtonUp(self):
        """Termina il drag e salva la posizione"""
        if self.isDragging:
            self.isDragging = False
            x, y = self.GetGlobalPosition()
            SaveWindowPosition(self.windowName, x, y)
        return True
    
    def OnMouseDrag(self, x, y):
        """Gestisce il movimento durante il drag"""
        if self.isDragging:
            mouseX, mouseY = wndMgr.GetMousePosition()
            newX = mouseX - self.dragOffsetX
            newY = mouseY - self.dragOffsetY
            
            # Limita alla schermata
            screenW = wndMgr.GetScreenWidth()
            screenH = wndMgr.GetScreenHeight()
            winW, winH = self.GetWidth(), self.GetHeight()
            
            newX = max(0, min(newX, screenW - winW))
            newY = max(0, min(newY, screenH - winH))
            
            self.SetPosition(newX, newY)
        return True
    
    def RestorePosition(self):
        """Ripristina la posizione salvata"""
        if hasattr(self, 'windowName'):
            pos = WINDOW_POSITIONS.get(self.windowName)
            if pos:
                self.SetPosition(pos[0], pos[1])


# ═══════════════════════════════════════════════════════════════════════════════
#  RANK THEMES - Schema colori completo per rank (usato dal Terminale)
# ═══════════════════════════════════════════════════════════════════════════════
RANK_THEMES = {
    "E": {
        "name": "E-Rank",
        "title": "Risvegliato",
        "min": 0,
        "max": 2000,
        "bg_dark": 0xEE0D0D0D,
        "bg_medium": 0xEE1A1A1A,
        "bg_light": 0xEE2A2A2A,
        "border": 0xFF555555,
        "accent": 0xFF808080,
        "text_title": 0xFF999999,
        "text_value": 0xFFCCCCCC,
        "text_muted": 0xFF666666,
        "bar_fill": 0xFF808080,
        "glow": 0x33808080,
        "btn_normal": 0xFF333333,
        "btn_hover": 0xFF444444,
        "btn_down": 0xFF555555,
    },
    "D": {
        "name": "D-Rank",
        "title": "Apprendista",
        "min": 2000,
        "max": 10000,
        "bg_dark": 0xEE0A1A0A,
        "bg_medium": 0xEE0F2A0F,
        "bg_light": 0xEE153A15,
        "border": 0xFF00AA00,
        "accent": 0xFF00FF00,
        "text_title": 0xFF44FF44,
        "text_value": 0xFFAAFFAA,
        "text_muted": 0xFF337733,
        "bar_fill": 0xFF00DD00,
        "glow": 0x3300FF00,
        "btn_normal": 0xFF0A2A0A,
        "btn_hover": 0xFF0F3F0F,
        "btn_down": 0xFF155515,
    },
    "C": {
        "name": "C-Rank",
        "title": "Cacciatore",
        "min": 10000,
        "max": 50000,
        "bg_dark": 0xEE0A1A2A,
        "bg_medium": 0xEE0F2A3A,
        "bg_light": 0xEE153A4A,
        "border": 0xFF00CCFF,
        "accent": 0xFF00FFFF,
        "text_title": 0xFF44DDFF,
        "text_value": 0xFFAAEEFF,
        "text_muted": 0xFF337799,
        "bar_fill": 0xFF00CCFF,
        "glow": 0x3300FFFF,
        "btn_normal": 0xFF0A2A3A,
        "btn_hover": 0xFF0F3A4A,
        "btn_down": 0xFF154A5A,
    },
    "B": {
        "name": "B-Rank",
        "title": "Veterano",
        "min": 50000,
        "max": 150000,
        "bg_dark": 0xEE0A0A2A,
        "bg_medium": 0xEE0F0F3A,
        "bg_light": 0xEE15154A,
        "border": 0xFF0066FF,
        "accent": 0xFF4488FF,
        "text_title": 0xFF6699FF,
        "text_value": 0xFFAABBFF,
        "text_muted": 0xFF334477,
        "bar_fill": 0xFF0066FF,
        "glow": 0x330066FF,
        "btn_normal": 0xFF0A0A3A,
        "btn_hover": 0xFF0F0F4A,
        "btn_down": 0xFF15155A,
    },
    "A": {
        "name": "A-Rank",
        "title": "Maestro",
        "min": 150000,
        "max": 500000,
        "bg_dark": 0xEE1A0A2A,
        "bg_medium": 0xEE2A0F3A,
        "bg_light": 0xEE3A154A,
        "border": 0xFFAA00FF,
        "accent": 0xFFCC66FF,
        "text_title": 0xFFDD88FF,
        "text_value": 0xFFEEBBFF,
        "text_muted": 0xFF773399,
        "bar_fill": 0xFFAA00FF,
        "glow": 0x33AA00FF,
        "btn_normal": 0xFF2A0A3A,
        "btn_hover": 0xFF3A0F4A,
        "btn_down": 0xFF4A155A,
    },
    "S": {
        "name": "S-Rank",
        "title": "Leggenda",
        "min": 500000,
        "max": 1500000,
        "bg_dark": 0xEE2A1A0A,
        "bg_medium": 0xEE3A2A0F,
        "bg_light": 0xEE4A3A15,
        "border": 0xFFFF6600,
        "accent": 0xFFFFAA00,
        "text_title": 0xFFFFBB44,
        "text_value": 0xFFFFDDAA,
        "text_muted": 0xFF996633,
        "bar_fill": 0xFFFF6600,
        "glow": 0x33FF6600,
        "btn_normal": 0xFF3A2A0A,
        "btn_hover": 0xFF4A3A0F,
        "btn_down": 0xFF5A4A15,
    },
    "N": {
        "name": "NATIONAL",
        "title": "Monarca Nazionale",
        "min": 1500000,
        "max": 5000000,
        "bg_dark": 0xEE2A0A0A,
        "bg_medium": 0xEE3A0F0F,
        "bg_light": 0xEE4A1515,
        "border": 0xFFFF0000,
        "accent": 0xFFFF4444,
        "text_title": 0xFFFF6666,
        "text_value": 0xFFFFAAAA,
        "text_muted": 0xFF993333,
        "bar_fill": 0xFFFF0000,
        "glow": 0x33FF0000,
        "btn_normal": 0xFF3A0A0A,
        "btn_hover": 0xFF4A0F0F,
        "btn_down": 0xFF5A1515,
    },
}

def GetRankKey(points):
    """Determina il rank basato sui punti gloria"""
    if points >= 1500000:
        return "N"
    elif points >= 500000:
        return "S"
    elif points >= 150000:
        return "A"
    elif points >= 50000:
        return "B"
    elif points >= 10000:
        return "C"
    elif points >= 2000:
        return "D"
    return "E"

def GetRankTheme(points):
    """Ritorna il tema completo per un dato punteggio"""
    key = GetRankKey(points)
    return RANK_THEMES[key]

def GetRankProgress(points):
    """Calcola la percentuale di progresso verso il prossimo rank"""
    key = GetRankKey(points)
    theme = RANK_THEMES[key]
    if points >= theme["max"]:
        return 100.0
    progress = float(points - theme["min"]) / float(theme["max"] - theme["min"]) * 100
    return min(100, max(0, progress))


# ═══════════════════════════════════════════════════════════════════════════════
#  AWAKENING CONFIGURATION - Livelli speciali con effetti epici
# ═══════════════════════════════════════════════════════════════════════════════
AWAKENING_CONFIG = {
    5: {
        "name": "RISVEGLIO",
        "subtitle": "Il Sistema ti ha scelto",
        "quote": '"Benvenuto, Cacciatore."',
        "color": 0xFF4A90D9,
        "duration": 6.0,
        "effect": "system_boot",
        "tip": "Premi [N] per scegliere le tue abilità",
        "sound_intensity": 1,
    },
    10: {
        "name": "PRIMA EVOLUZIONE",
        "subtitle": "Il tuo potere si manifesta",
        "quote": '"Stai diventando più forte."',
        "color": 0xFF00FF88,
        "duration": 5.0,
        "effect": "power_surge",
        "sound_intensity": 1,
    },
    15: {
        "name": "ADATTAMENTO",
        "subtitle": "Il corpo si adatta al potere",
        "quote": '"Il dolore forgia la forza."',
        "color": 0xFF00FFAA,
        "duration": 5.0,
        "effect": "adaptation",
        "sound_intensity": 1,
    },
    20: {
        "name": "RISONANZA",
        "subtitle": "L'energia fluisce liberamente",
        "quote": '"Senti il potere dentro di te?"',
        "color": 0xFF00FFFF,
        "duration": 5.5,
        "effect": "resonance",
        "sound_intensity": 2,
    },
    25: {
        "name": "MANIFESTAZIONE",
        "subtitle": "Il tuo potere prende forma",
        "quote": '"Non sei più un novizio."',
        "color": 0xFF00DDFF,
        "duration": 5.5,
        "effect": "manifestation",
        "sound_intensity": 2,
    },
    30: {
        "name": "SISTEMA ATTIVATO",
        "subtitle": "Accesso al Terminale Hunter",
        "quote": '"Il Sistema si espande per te."',
        "color": 0xFF0088FF,
        "duration": 8.0,
        "effect": "terminal_unlock",
        "tip": "Il [TERMINALE] è ora disponibile",
        "sound_intensity": 3,
    },
    40: {
        "name": "CONSOLIDAMENTO",
        "subtitle": "Il potere si stabilizza",
        "quote": '"La crescita non si ferma mai."',
        "color": 0xFF0066FF,
        "duration": 5.0,
        "effect": "consolidation",
        "sound_intensity": 2,
    },
    50: {
        "name": "METÀ DEL CAMMINO",
        "subtitle": "Hai percorso metà della via",
        "quote": '"Ma il vero viaggio inizia ora."',
        "color": 0xFFAA00FF,
        "duration": 6.0,
        "effect": "halfway",
        "sound_intensity": 2,
    },
    60: {
        "name": "MATURAZIONE",
        "subtitle": "Il tuo potere matura",
        "quote": '"I deboli iniziano a temerti."',
        "color": 0xFFBB00FF,
        "duration": 5.5,
        "effect": "maturation",
        "sound_intensity": 2,
    },
    70: {
        "name": "RISVEGLIO AVANZATO",
        "subtitle": "Oltre i limiti ordinari",
        "quote": '"Vedi cose che altri non possono vedere."',
        "color": 0xFFFF6600,
        "duration": 6.0,
        "effect": "advanced_awakening",
        "sound_intensity": 3,
    },
    80: {
        "name": "MAESTRIA",
        "subtitle": "Il controllo è assoluto",
        "quote": '"Il potere è nulla senza controllo."',
        "color": 0xFFFF8800,
        "duration": 5.5,
        "effect": "mastery",
        "sound_intensity": 3,
    },
    90: {
        "name": "SOGLIA LEGGENDARIA",
        "subtitle": "Pochi arrivano fin qui",
        "quote": '"Sei degno del tuo titolo."',
        "color": 0xFFFF0000,
        "duration": 7.0,
        "effect": "legendary_threshold",
        "sound_intensity": 3,
    },
    100: {
        "name": "CENTENARIO",
        "subtitle": "Un secolo di potere",
        "quote": '"ARISE."',
        "color": 0xFFFFD700,
        "duration": 9.0,
        "effect": "centennial",
        "sound_intensity": 4,
    },
    110: {
        "name": "TRASCENDENZA",
        "subtitle": "Oltre ogni limite conosciuto",
        "quote": '"I limiti esistono solo per essere infranti."',
        "color": 0xFFFFE066,
        "duration": 7.0,
        "effect": "transcendence",
        "sound_intensity": 4,
    },
    120: {
        "name": "ASCENSIONE",
        "subtitle": "Non sei più umano",
        "quote": '"Io solo... avanzo."',
        "color": 0xFFFF00FF,
        "duration": 9.0,
        "effect": "ascension",
        "sound_intensity": 5,
    },
    130: {
        "name": "MONARCA",
        "subtitle": "Il Re delle Ombre",
        "quote": '"I ALONE LEVEL UP."',
        "color": 0xFF000000,
        "secondary_color": 0xFFFF0000,
        "duration": 12.0,
        "effect": "monarch",
        "sound_intensity": 5,
    },
}

def IsAwakeningLevel(level):
    """Controlla se un livello ha un awakening speciale"""
    return level in AWAKENING_CONFIG

def GetAwakeningConfig(level):
    """Ritorna la configurazione awakening per un livello"""
    return AWAKENING_CONFIG.get(level, None)
