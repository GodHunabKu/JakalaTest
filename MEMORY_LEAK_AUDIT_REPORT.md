# 🔍 Memory Leak Audit Report - Hunter System UI
**Data**: 2025-12-28
**Auditor**: Claude Code
**Scope**: Audit completo dei file UI Python per potenziali memory leak
**Metodologia**: Basata su "Definitive UI Programming Guideline (Lua/Python Bridge Edition)"

---

## 📊 Executive Summary

**File Analizzati**: 4
**Classi UI Analizzate**: 17
**Memory Leak Trovati**: 4 (3 critici, 1 medio)
**Severità Complessiva**: 🔴 **ALTA**

### Stato per File

| File | Classi | Leak | Severità | Destroy() | Stato |
|------|--------|------|----------|-----------|-------|
| `uihunterlevel.py` | 2 | 0 | ✅ OK | ✅ Sì | BUONO |
| `uihunterlevel_whatif.py` | 13 | 3 | 🔴 Critica | ❌ No | PROBLEMATICO |
| `uihunterlevel_gate_trial.py` | 1 | 1 | 🟡 Media | ❌ Parziale | DA FIXARE |
| `interfacemodule.py` | 1 | 0 | ✅ OK | ✅ Sì | BUONO |

---

## 🐛 Memory Leak Identificati

### 1. 🔴 **CRITICO** - Lambda Closure in EventsScheduleWindow
**File**: `uihunterlevel_whatif.py`
**Linea**: 2992
**Classe**: `EventsScheduleWindow`

```python
# PROBLEMATICO ❌
slot["joinBtn"].SetEvent(lambda eid=e.get("id", 0): self.__OnJoinEvent(eid))
```

**Problema**:
- La lambda cattura implicitamente `self` quando chiama `self.__OnJoinEvent()`
- Crea un ciclo: C++ Button → Lambda (Lua registry) → Python self → Button Python object → C++ Button
- La classe NON ha metodo `Destroy()` per pulire gli event handler
- Il GC di Python non può rilevare questo ciclo cross-boundary

**Impatto**:
- ❌ La finestra Eventi non viene mai deallocata
- ❌ Ogni apertura della finestra crea una nuova istanza leaked
- ❌ Dopo warp, tutte le istanze rimangono in memoria
- ❌ Accumulo progressivo di memoria ad ogni apertura

**Fix Raccomandato**:
```python
# CORRETTO ✅
slot["joinBtn"].SetEvent(ui.__mem_func__(self.__OnJoinEvent), e.get("id", 0))
```

---

### 2. 🔴 **CRITICO** - Lambda Closure Factory in WhatIfChoiceWindow
**File**: `uihunterlevel_whatif.py`
**Linea**: 280-281
**Classe**: `WhatIfChoiceWindow`

```python
# PROBLEMATICO ❌
def make_event(idx):
    return lambda: self.__OnClickOption(idx)

btn = SystemButton(self, 20, baseY, windowWidth-40, opt.replace("+", " "), scheme, make_event(i+1))
```

**Problema**:
- La closure factory crea una lambda che cattura `self`
- Stesso ciclo del problema #1
- La classe ha `Close()` ma fa solo `self.Hide()`, non pulisce event handler

**Impatto**:
- ❌ Finestre di scelta "What If" non vengono deallocate
- ❌ Leak su ogni dialogo di scelta mostrato
- ❌ Bottoni rimangono in memoria con i loro callback

**Fix Raccomandato**:
```python
# CORRETTO ✅
btn = SystemButton(self, 20, baseY, windowWidth-40, opt.replace("+", " "),
                   scheme, ui.__mem_func__(self.__OnClickOption), i+1)
```

O ancora meglio, se SystemButton supporta args:
```python
# MIGLIORE ✅
def make_event(idx):
    return ui.__mem_func__(self.__OnClickOption), idx
```

---

### 3. 🟡 **MEDIO** - Bound Method in DailyMissionsWindow
**File**: `uihunterlevel_whatif.py`
**Linea**: 2194
**Classe**: `DailyMissionsWindow`

```python
# PROBLEMATICO ❌
self.closeBtn.SetEvent(self.Hide)
```

**Problema**:
- Passa un metodo bound (`self.Hide`) senza weak reference
- Crea riferimento forte: C++ Button → self.Hide (bound method) → self
- Classe NON ha metodo `Destroy()`

**Impatto**:
- ⚠️ Finestra Missioni Giornaliere potrebbe non essere deallocata
- ⚠️ Severità media perché `Hide` è un metodo built-in, ma comunque problematico

**Fix Raccomandato**:
```python
# CORRETTO ✅
self.closeBtn.SetEvent(ui.__mem_func__(self.Hide))
```

---

### 4. 🟡 **MEDIO** - Bound Method in GateTrialWindow
**File**: `uihunterlevel_gate_trial.py`
**Linea**: 400
**Classe**: `GateTrialWindow`

```python
# PROBLEMATICO ❌
self.closeBtn.SetEvent(self.Close)
```

**Problema**:
- Stesso problema del #3
- `Close()` esiste ma fa solo `self.Hide()`, non pulisce event handler

**Impatto**:
- ⚠️ Finestra Gate Trial potrebbe rimanere in memoria

**Fix Raccomandato**:
```python
# CORRETTO ✅
self.closeBtn.SetEvent(ui.__mem_func__(self.Close))
```

---

## ✅ Codice Buono (Best Practices)

### uihunterlevel.py - ESEMPIO DA SEGUIRE

Questo file implementa correttamente il pattern di cleanup:

```python
class HunterLevelWindow(ui.ScriptWindow):
    def __init__(self):
        # ... setup ...
        self.isDestroyed = False

    def Destroy(self):
        """✅ CORRETTO - Cleanup completo"""
        if self.isDestroyed:
            return
        self.isDestroyed = True
        self.Hide()
        self.__ClearAll()

    def __ClearAll(self):
        """✅ CORRETTO - Pulisce tutti gli event handler"""
        for e in self.bgElements + self.headerElements + self.contentElements + self.footerElements:
            try:
                if hasattr(e, 'SetEvent'):
                    e.SetEvent(None)  # 🎯 Rompe il ciclo!
                e.Hide()
            except:
                pass

        # Pulisce anche i tab button
        for btn in self.tabButtons:
            try:
                btn.SetEvent(None)  # 🎯 Rompe il ciclo!
                btn.Hide()
            except:
                pass

    # Tutti i callback usano ui.__mem_func__()
    closeBtn.SetEvent(ui.__mem_func__(self.Close))  # ✅ CORRETTO
    btn.SetEvent(ui.__mem_func__(self.__OnClickTab), i)  # ✅ CORRETTO
```

**Perché funziona**:
1. ✅ Metodo `Destroy()` esplicito chiamato da `interfacemodule.py`
2. ✅ `__ClearAll()` rompe tutti i cicli con `SetEvent(None)`
3. ✅ Tutti i callback wrappati con `ui.__mem_func__()`
4. ✅ Flag `isDestroyed` previene double-destroy

---

## 📋 Classi Senza Metodo Destroy()

Le seguenti classi **non hanno** un metodo `Destroy()` e sono a rischio di leak:

### uihunterlevel_whatif.py (13 classi)
1. ❌ `SystemButton` - Ha event handler, nessun Destroy
2. ❌ `WhatIfChoiceWindow` - Ha Close() ma non pulisce eventi (linea 310)
3. ❌ `SystemMessageWindow` - Nessun cleanup
4. ❌ `EmergencyQuestWindow` - Nessun cleanup
5. ❌ `RivalTrackerWindow` - Nessun cleanup
6. ❌ `EventStatusWindow` - Nessun cleanup
7. ❌ `BossAlertWindow` - Nessun cleanup
8. ❌ `SystemInitWindow` - Nessun cleanup
9. ❌ `AwakeningWindow` - Nessun cleanup
10. ❌ `HunterActivationWindow` - Nessun cleanup
11. ❌ `RankUpWindow` - Nessun cleanup
12. ❌ `OvertakeWindow` - Nessun cleanup
13. ❌ `DailyMissionsWindow` - Ha Close() ma non pulisce eventi (linea 2404)
14. ❌ `MissionProgressPopup` - Nessun cleanup
15. ❌ `MissionCompleteWindow` - Nessun cleanup
16. ❌ `AllMissionsCompleteWindow` - Nessun cleanup
17. ❌ `EventsScheduleWindow` - Nessun cleanup

**Nota**: Non tutte creano leak se non usano event handler, ma è una bad practice.

---

## 🧪 Test per Verificare Memory Leak

### Warp Test (Metodo della Guida)

```python
# Prima del warp
import sys
import gc

# Conta istanze prima
before = len([obj for obj in gc.get_objects() if isinstance(obj, EventsScheduleWindow)])
print("EventsScheduleWindow instances BEFORE warp: %d" % before)

# 1. Apri finestra Eventi
# 2. Chiudi finestra Eventi
# 3. Warp a un'altra mappa
# 4. Torna indietro

# Dopo il warp
gc.collect()  # Forza garbage collection
after = len([obj for obj in gc.get_objects() if isinstance(obj, EventsScheduleWindow)])
print("EventsScheduleWindow instances AFTER warp: %d" % after)

# Se after > before, c'è un leak!
if after > before:
    print("❌ MEMORY LEAK DETECTED: %d leaked instances" % (after - before))
else:
    print("✅ OK: No leak")
```

### Debug Counter Pattern

```python
# Aggiungi a ogni classe UI
class EventsScheduleWindow(ui.Window):
    _instance_count = 0  # Contatore di classe

    def __init__(self):
        ui.Window.__init__(self)
        EventsScheduleWindow._instance_count += 1
        print("[DEBUG] EventsScheduleWindow created. Total: %d" % EventsScheduleWindow._instance_count)

    def Destroy(self):
        if self.is_destroyed:
            return
        self.is_destroyed = True

        # Cleanup...

        EventsScheduleWindow._instance_count -= 1
        print("[DEBUG] EventsScheduleWindow destroyed. Total: %d" % EventsScheduleWindow._instance_count)

    def __del__(self):
        # Questo dovrebbe stampare quando l'oggetto è effettivamente deallocato
        print("[DEBUG] EventsScheduleWindow.__del__ called")
```

---

## 🛠️ Soluzioni Raccomandate

### Soluzione 1: Fix Immediati (Quick Win)

**File**: `uihunterlevel_whatif.py` e `uihunterlevel_gate_trial.py`

Sostituisci tutti i callback problematici:

```python
# PRIMA ❌
self.closeBtn.SetEvent(self.Hide)
slot["joinBtn"].SetEvent(lambda eid=e.get("id", 0): self.__OnJoinEvent(eid))

# DOPO ✅
self.closeBtn.SetEvent(ui.__mem_func__(self.Hide))
slot["joinBtn"].SetEvent(ui.__mem_func__(self.__OnJoinEvent), e.get("id", 0))
```

**Tempo stimato**: 30 minuti
**Impatto**: Risolve 3 dei 4 leak

---

### Soluzione 2: Aggiungere Metodi Destroy()

Per ogni classe UI in `uihunterlevel_whatif.py`, aggiungere:

```python
class EventsScheduleWindow(ui.Window):
    def __init__(self):
        ui.Window.__init__(self)
        self.is_destroyed = False
        self.slots = []  # Lista di tutti gli slot con button

    def Destroy(self):
        """Cleanup completo"""
        if self.is_destroyed:
            return
        self.is_destroyed = True

        # Pulisci tutti gli event handler
        for slot in self.slots:
            if "joinBtn" in slot and hasattr(slot["joinBtn"], 'SetEvent'):
                slot["joinBtn"].SetEvent(None)  # Rompi il ciclo!

        self.slots = []

        if hasattr(self, 'closeBtn'):
            self.closeBtn.SetEvent(None)

        self.Hide()

    def __del__(self):
        if not self.is_destroyed:
            print("WARNING: EventsScheduleWindow destroyed without calling Destroy()!")
```

**Tempo stimato**: 2-3 ore (per tutte le 17 classi)
**Impatto**: Risolve tutti i leak + previene leak futuri

---

### Soluzione 3: Pattern WeakMethod Helper (Avanzato)

Creare un helper simile a `ui.__mem_func__()` ma più robusto:

```python
# File: ui_helpers.py
class WeakMethod:
    """Weak reference wrapper per metodi"""
    def __init__(self, method):
        try:
            if method.im_self is not None:
                # Metodo bound
                self.obj_ref = weakref.ref(method.im_self)
                self.func = method.im_func
            else:
                # Funzione normale
                self.obj_ref = None
                self.func = method
        except AttributeError:
            # Callable generico
            self.obj_ref = None
            self.func = method

    def __call__(self, *args, **kwargs):
        if self.obj_ref is not None:
            obj = self.obj_ref()
            if obj is not None:
                return self.func(obj, *args, **kwargs)
        else:
            return self.func(*args, **kwargs)

# Uso
slot["joinBtn"].SetEvent(WeakMethod(self.__OnJoinEvent), eid)
```

**Tempo stimato**: 1 ora implementazione + 2 ore refactoring
**Impatto**: Soluzione robusta e riutilizzabile

---

## 📈 Priorità delle Fix

### 🔴 Priorità ALTA (Immediate)
1. **Lambda in EventsScheduleWindow** (linea 2992) - CRITICO
2. **Lambda in WhatIfChoiceWindow** (linea 280-281) - CRITICO

### 🟡 Priorità MEDIA (Questa settimana)
3. **Bound methods** in DailyMissionsWindow e GateTrialWindow

### 🟢 Priorità BASSA (Prossimo sprint)
4. Aggiungere `Destroy()` a tutte le classi UI
5. Implementare debug counters
6. Creare test di memoria automatici

---

## 📚 Best Practices da Seguire

### ✅ DO (Fare Sempre)

```python
# 1. Usare ui.__mem_func__() per tutti i callback
btn.SetEvent(ui.__mem_func__(self.OnClick))

# 2. Implementare Destroy() in ogni window
def Destroy(self):
    if self.is_destroyed: return
    self.is_destroyed = True
    # Pulisci event handlers
    for elem in self.elements:
        if hasattr(elem, 'SetEvent'):
            elem.SetEvent(None)
    self.Hide()

# 3. Chiamare Destroy() prima di rimuovere riferimenti
window.Destroy()
window = None

# 4. Usare flag is_destroyed
def SomeMethod(self):
    if self.is_destroyed: return
    # ... logic ...
```

### ❌ DON'T (Non Fare Mai)

```python
# ❌ NON usare lambda che catturano self
btn.SetEvent(lambda: self.DoSomething())

# ❌ NON passare metodi bound direttamente
btn.SetEvent(self.OnClick)

# ❌ NON dimenticare di pulire event handler in Destroy()
def Destroy(self):
    self.Hide()  # ❌ Non basta!

# ❌ NON creare closure factory senza weak ref
def make_callback(idx):
    return lambda: self.OnClick(idx)  # ❌ Cattura self!
```

---

## 🎯 Checklist Pre-Commit

Prima di committare nuovo codice UI, verifica:

- [ ] Ogni classe con event handler ha metodo `Destroy()`?
- [ ] `Destroy()` chiama `SetEvent(None)` su tutti i callback?
- [ ] Tutti i `SetEvent()` usano `ui.__mem_func__()`?
- [ ] Nessuna lambda che cattura `self` direttamente?
- [ ] Testato con warp test per verificare no leak?
- [ ] Aggiunto `__del__` per debug se necessario?

---

## 📞 Prossimi Passi

1. ✅ **Review questo report** con il team
2. 🔧 **Applicare fix immediati** per i 2 leak critici
3. 🧪 **Implementare warp test** per validazione
4. 📝 **Refactoring** di tutte le classi UI con Destroy()
5. 📚 **Documentare** il pattern corretto per nuovo codice
6. 🤖 **Creare linter** per rilevare pattern problematici

---

**Report generato da**: Claude Code Memory Leak Auditor
**Metodologia**: Based on "Definitive UI Programming Guideline"
**Confidenza**: Alta (analisi statica del codice)

