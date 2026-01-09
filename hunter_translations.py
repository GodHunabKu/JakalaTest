# -*- coding: utf-8 -*-
# ============================================================================
#  HUNTER TRANSLATION MANAGER v2.0
#  Sistema multi-lingua LOCALE per Hunter Terminal
#  Tutte le traduzioni sono nei file hunter_translations_XX.py
# ============================================================================

# ============================================================================
#  IMPORT MODULI LINGUA
# ============================================================================

import hunter_translations_it as LANG_IT
import hunter_translations_en as LANG_EN
import hunter_translations_de as LANG_DE
import hunter_translations_es as LANG_ES
import hunter_translations_fr as LANG_FR
import hunter_translations_pt as LANG_PT
import hunter_translations_pl as LANG_PL
import hunter_translations_ru as LANG_RU

# ============================================================================
#  LINGUE DISPONIBILI
# ============================================================================

LANGUAGE_MODULES = {
    "it": LANG_IT,
    "en": LANG_EN,
    "de": LANG_DE,
    "es": LANG_ES,
    "fr": LANG_FR,
    "pt": LANG_PT,
    "pl": LANG_PL,
    "ru": LANG_RU,
}

AVAILABLE_LANGUAGES = [
    {"code": "it", "name": "Italiano", "flag": "IT"},
    {"code": "en", "name": "English", "flag": "EN"},
    {"code": "de", "name": "Deutsch", "flag": "DE"},
    {"code": "es", "name": "Espanol", "flag": "ES"},
    {"code": "fr", "name": "Francais", "flag": "FR"},
    {"code": "pt", "name": "Portugues", "flag": "PT"},
    {"code": "pl", "name": "Polski", "flag": "PL"},
    {"code": "ru", "name": "Russkiy", "flag": "RU"},
]

# ============================================================================
#  STATO GLOBALE
# ============================================================================

_current_language = "it"
_current_module = LANG_IT

# ============================================================================
#  PUBLIC API - FUNZIONI PRINCIPALI
# ============================================================================

def GetText(key, default=None, replacements=None):
    """
    Ottiene un testo tradotto nella lingua corrente.

    Args:
        key: Chiave di traduzione (es. "UI_TAB_SHOP")
        default: Valore di fallback se la chiave non esiste
        replacements: Dict per sostituzioni (es. {"PTS": 100})

    Returns:
        Testo tradotto con eventuali sostituzioni applicate
    """
    global _current_module

    text = None

    # Cerca nella lingua corrente
    if hasattr(_current_module, 'TRANSLATIONS'):
        text = _current_module.TRANSLATIONS.get(key)

    # Fallback all'italiano
    if text is None and _current_module != LANG_IT:
        text = LANG_IT.TRANSLATIONS.get(key)

    # Fallback al default o alla chiave
    if text is None:
        text = default if default is not None else key

    # Applica sostituzioni
    if replacements and isinstance(replacements, dict):
        for k, v in replacements.items():
            text = text.replace("{" + str(k) + "}", str(v))

    return text


def T(key, default=None, replacements=None):
    """Alias breve per GetText"""
    return GetText(key, default, replacements)


def GetTextColored(key, default=None, replacements=None, color=None):
    """
    Ottiene un testo tradotto CON colore applicato.

    Args:
        key: Chiave di traduzione
        default: Valore di fallback
        replacements: Dict per sostituzioni
        color: Colore hex (es. "FFD700") o nome colore (es. "title", "success")

    Returns:
        Testo con tag colore: "|cffFFD700Testo|r"
    """
    text = GetText(key, default, replacements)

    if color:
        # Se e' un nome colore, cercalo nel dizionario COLORS
        if hasattr(_current_module, 'COLORS') and color in _current_module.COLORS:
            color = _current_module.COLORS[color]

        # Applica il colore
        return "|cff" + color + text + "|r"

    return text


def TC(key, color, default=None, replacements=None):
    """Alias breve per GetTextColored"""
    return GetTextColored(key, default, replacements, color)


def GetColor(color_name):
    """
    Ottiene un codice colore dal dizionario COLORS.

    Args:
        color_name: Nome colore (es. "title", "success", "error")

    Returns:
        Codice hex (es. "FFD700") o il nome stesso se non trovato
    """
    global _current_module

    if hasattr(_current_module, 'COLORS'):
        return _current_module.COLORS.get(color_name, color_name)

    return color_name


# ============================================================================
#  GESTIONE LINGUA
# ============================================================================

def GetCurrentLanguage():
    """Ritorna il codice della lingua corrente"""
    global _current_language
    return _current_language


def GetCurrentLanguageName():
    """Ritorna il nome della lingua corrente"""
    global _current_language
    for lang in AVAILABLE_LANGUAGES:
        if lang["code"] == _current_language:
            return lang["name"]
    return "Unknown"


def SetLanguage(lang_code):
    """
    Imposta la lingua corrente.

    Args:
        lang_code: Codice lingua (es. "it", "en", "de")

    Returns:
        True se la lingua e' valida, False altrimenti
    """
    global _current_language, _current_module

    lang_code = str(lang_code).lower()

    if lang_code in LANGUAGE_MODULES:
        _current_language = lang_code
        _current_module = LANGUAGE_MODULES[lang_code]

        # Salva la lingua nel file locale
        _save_language_local(lang_code)

        try:
            import dbg
            dbg.TraceError("[HUNTER LANG] Lingua impostata: " + lang_code)
        except:
            pass

        return True

    return False


def GetAvailableLanguages():
    """Ritorna la lista delle lingue disponibili"""
    return AVAILABLE_LANGUAGES


def GetLanguageCount():
    """Ritorna il numero di lingue disponibili"""
    return len(AVAILABLE_LANGUAGES)


# ============================================================================
#  SALVATAGGIO/CARICAMENTO LINGUA LOCALE
# ============================================================================

def _save_language_local(lang_code):
    """Salva la lingua nel file locale"""
    try:
        with open("hunter_lang.cfg", "w") as f:
            f.write(lang_code)
    except:
        pass


def _load_language_local():
    """Carica la lingua dal file locale"""
    global _current_language, _current_module
    try:
        with open("hunter_lang.cfg", "r") as f:
            lang = f.read().strip().lower()
            if lang in LANGUAGE_MODULES:
                _current_language = lang
                _current_module = LANGUAGE_MODULES[lang]
                return lang
    except:
        pass
    return "it"


# ============================================================================
#  FUNZIONI DI COMPATIBILITA'
# ============================================================================

def IsReady():
    """Sempre True - le traduzioni sono sempre pronte"""
    return True


def IsLoading():
    """Sempre False - nessun caricamento necessario"""
    return False


def OnReady(callback):
    """Esegue immediatamente la callback"""
    try:
        callback()
    except:
        pass


def RequestTranslations():
    """Non necessario - traduzioni locali"""
    pass


def RequestLanguages():
    """Non necessario - traduzioni locali"""
    pass


def ChangeLanguage(lang_code):
    """
    Cambia lingua localmente E notifica il server.
    """
    if SetLanguage(lang_code):
        try:
            import net
            net.SendChatPacket("/hunter_set_language " + str(lang_code), 1)
        except:
            pass
        return True
    return False


def OnReceiveTranslations(category, data):
    """Ignora - usiamo traduzioni locali"""
    pass


def OnTranslationsReady(lang_code):
    """Imposta la lingua dal server"""
    SetLanguage(lang_code)


def OnReceiveLanguages(current_lang, data):
    """Imposta la lingua dal server"""
    SetLanguage(current_lang)


def ClearCache():
    """Non fa nulla - traduzioni statiche"""
    pass


def LoadFallbackTranslations():
    """Non necessario"""
    pass


def Initialize():
    """Non necessario"""
    pass


# ============================================================================
#  HANDLER PER SYSCHAT DAL SERVER
#  Il server invia: HunterSyschat KEY|COLOR|REPLACEMENT1=VAL1|REPLACEMENT2=VAL2
# ============================================================================

def ProcessServerSyschat(args):
    """
    Processa un messaggio syschat dal server.

    Args:
        args: Stringa dal server "KEY|COLOR|REP1=VAL1|REP2=VAL2"

    Returns:
        Tuple (text, color) con testo tradotto e colore
    """
    parts = args.split("|")
    key = parts[0] if len(parts) > 0 else ""
    color = parts[1] if len(parts) > 1 else "FFFFFF"

    # Parse replacements
    replacements = {}
    for i in range(2, len(parts)):
        if "=" in parts[i]:
            k, v = parts[i].split("=", 1)
            replacements[k] = v

    # Ottieni testo tradotto
    text = GetText(key, key, replacements)

    return (text, color)


def FormatSyschat(key, color="FFFFFF", replacements=None):
    """
    Formatta un messaggio syschat con colore.

    Returns:
        Stringa formattata: "|cffCOLORtesto|r"
    """
    text = GetText(key, key, replacements)
    return "|cff" + color + text + "|r"


# ============================================================================
#  INIZIALIZZAZIONE
# ============================================================================

# Carica la lingua salvata all'avvio
_load_language_local()

try:
    import dbg
    dbg.TraceError("[HUNTER LANG] Inizializzato - Lingua: " + _current_language)
except:
    pass
