# -*- coding: utf-8 -*-
# ============================================================================
#  HUNTER TRANSLATION MANAGER
#  Sistema multi-lingua per Hunter Terminal
#  Riceve traduzioni dal server e le gestisce con cache lato client
# ============================================================================

import net

# ============================================================================
#  TRANSLATION CACHE
# ============================================================================

# Cache globale delle traduzioni
_translations = {}

# Lingua corrente del giocatore
_current_language = "it"

# Stato di caricamento
_is_loading = False
_is_ready = False

# Callbacks da chiamare quando le traduzioni sono pronte
_ready_callbacks = []


# ============================================================================
#  PUBLIC API
# ============================================================================

def GetText(key, default=None):
    """
    Ottiene un testo tradotto dalla cache.
    Se non trovato, ritorna il default o la chiave stessa.

    Uso:
        from hunter_translations import GetText as T
        label.SetText(T("UI_TAB_STATUS"))
    """
    global _translations, _current_language

    if key in _translations:
        return _translations[key]

    if default is not None:
        return default

    # Ritorna la chiave come fallback
    return key


def T(key, default=None):
    """Alias breve per GetText"""
    return GetText(key, default)


def GetCurrentLanguage():
    """Ritorna il codice della lingua corrente"""
    global _current_language
    return _current_language


def IsReady():
    """Verifica se le traduzioni sono caricate e pronte"""
    global _is_ready
    return _is_ready


def IsLoading():
    """Verifica se le traduzioni sono in fase di caricamento"""
    global _is_loading
    return _is_loading


def OnReady(callback):
    """
    Registra una callback da chiamare quando le traduzioni sono pronte.
    Se le traduzioni sono gia' pronte, la callback viene chiamata immediatamente.
    """
    global _is_ready, _ready_callbacks

    if _is_ready:
        try:
            callback()
        except:
            pass
    else:
        _ready_callbacks.append(callback)


def RequestTranslations():
    """
    Richiede al server di inviare le traduzioni.
    Chiamato automaticamente all'apertura del terminale.
    """
    global _is_loading
    _is_loading = True
    net.SendChatPacket("/hunter_request_translations", 1)


def RequestLanguages():
    """
    Richiede al server la lista delle lingue disponibili.
    """
    net.SendChatPacket("/hunter_request_languages", 1)


def ChangeLanguage(lang_code):
    """
    Richiede al server di cambiare lingua.
    Le nuove traduzioni verranno inviate automaticamente.
    """
    global _is_loading, _is_ready
    _is_loading = True
    _is_ready = False
    net.SendChatPacket("/hunter_change_language " + str(lang_code), 1)


# ============================================================================
#  SERVER MESSAGE HANDLERS
# ============================================================================

def OnReceiveTranslations(category, data):
    """
    Riceve un blocco di traduzioni dal server.
    Formato data: key1=value1|key2=value2|...

    Chiamato da: cmdchat("HunterTranslations category data")
    """
    global _translations

    if not data:
        return

    try:
        pairs = data.split("|")
        for pair in pairs:
            if "=" in pair:
                idx = pair.index("=")
                key = pair[:idx]
                value = pair[idx + 1:]
                # Ripristina spazi (erano convertiti in +)
                value = value.replace("+", " ")
                _translations[key] = value
    except:
        import dbg
        dbg.TraceError("OnReceiveTranslations parse error")


def OnTranslationsReady(lang_code):
    """
    Notifica che tutte le traduzioni sono state caricate.

    Chiamato da: cmdchat("HunterTranslationsReady lang_code")
    """
    global _current_language, _is_loading, _is_ready, _ready_callbacks

    _current_language = lang_code
    _is_loading = False
    _is_ready = True

    # Chiama tutte le callbacks registrate
    for callback in _ready_callbacks:
        try:
            callback()
        except:
            pass

    # Pulisci lista callbacks
    _ready_callbacks = []


# ============================================================================
#  LANGUAGE SELECTOR DATA
# ============================================================================

# Lista lingue disponibili (ricevute dal server)
_available_languages = []


def GetAvailableLanguages():
    """
    Ritorna la lista delle lingue disponibili.
    Formato: [{"code": "it", "name": "Italiano", "name_en": "Italian"}, ...]
    """
    global _available_languages
    return _available_languages


def OnReceiveLanguages(current_lang, data):
    """
    Riceve la lista delle lingue disponibili dal server.
    Formato data: code1:name1:name_en1|code2:name2:name_en2|...

    Chiamato da: cmdchat("HunterLanguages current_lang data")
    """
    global _available_languages, _current_language

    _current_language = current_lang
    _available_languages = []

    if not data:
        return

    try:
        entries = data.split("|")
        for entry in entries:
            parts = entry.split(":")
            if len(parts) >= 3:
                _available_languages.append({
                    "code": parts[0],
                    "name": parts[1].replace("+", " "),
                    "name_en": parts[2].replace("+", " ")
                })
    except:
        import dbg
        dbg.TraceError("OnReceiveLanguages parse error")


# ============================================================================
#  FALLBACK TRANSLATIONS (usate se il server non risponde)
# ============================================================================

_fallback_translations = {
    # UI
    "UI_TERMINAL_TITLE": "HUNTER TERMINAL",
    "UI_TAB_STATUS": "STATUS",
    "UI_TAB_RANKING": "RANKING",
    "UI_TAB_SHOP": "NEGOZIO",
    "UI_TAB_ACHIEVEMENTS": "OBIETTIVI",
    "UI_TAB_EVENTS": "EVENTI",
    "UI_TAB_MISSIONS": "MISSIONI",
    "UI_TAB_SETTINGS": "IMPOSTAZIONI",
    "UI_CLOSE": "CHIUDI",
    "UI_CONFIRM": "CONFERMA",
    "UI_CANCEL": "ANNULLA",
    "UI_LOADING": "Caricamento...",
    "UI_LANGUAGE": "Lingua",
    "UI_LANGUAGE_SELECT": "Seleziona Lingua",

    # Rank
    "RANK_E_NAME": "NOVIZIO",
    "RANK_D_NAME": "APPRENDISTA",
    "RANK_C_NAME": "GUERRIERO",
    "RANK_B_NAME": "VETERANO",
    "RANK_A_NAME": "ELITE",
    "RANK_S_NAME": "LEGGENDA",
    "RANK_N_NAME": "MONARCA",

    # Stats
    "STAT_GLORY": "Gloria",
    "STAT_GLORY_TOTAL": "Gloria Totale",
    "STAT_GLORY_SPENDABLE": "Gloria Spendibile",
    "STAT_KILLS": "Uccisioni",
    "STAT_RANK_POS": "Posizione Classifica",

    # System
    "SYS_JACKPOT": "JACKPOT!",
    "SYS_DANGER": "PERICOLO",
}


def LoadFallbackTranslations():
    """
    Carica le traduzioni di fallback nella cache.
    Usato se il server non risponde o come valori iniziali.
    """
    global _translations, _fallback_translations

    for key, value in _fallback_translations.items():
        if key not in _translations:
            _translations[key] = value


def ClearCache():
    """
    Pulisce la cache delle traduzioni.
    Usato quando si cambia lingua.
    """
    global _translations, _is_ready
    _translations = {}
    _is_ready = False
    LoadFallbackTranslations()


# ============================================================================
#  INITIALIZATION
# ============================================================================

def Initialize():
    """
    Inizializza il sistema di traduzioni.
    Chiamato all'avvio del client.
    """
    LoadFallbackTranslations()


# Auto-init
Initialize()
