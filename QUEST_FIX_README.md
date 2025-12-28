# Fix per Crash Sistema Quest - Hunter System v2.0

## 🐛 Problema Risolto

Questo fix risolve l'errore critico che si verificava quando si cliccava sulle categorie delle quest:

```
IndexError: string index out of range
File "uiCharacter.py", line 1678, in GetQuestProperties
```

## 📋 Cosa Fa il Fix

Il file `uiCharacter_quest_fix.py` fornisce:

1. **Protezione IndexError**: Previene il crash quando le quest properties sono vuote o malformate
2. **Integrazione Hunter System**: Supporto completo per le missioni del sistema Hunter
3. **Monkey Patching**: Sostituisce automaticamente le funzioni problematiche del modulo `quest`
4. **Backward Compatibility**: Mantiene la compatibilità con le quest standard di Metin2

## ✅ Installazione Automatica

Il fix è già stato integrato in `game.py` e si applica automaticamente all'avvio del client.

Quando il gioco viene avviato, vedrai nel log:
```
Quest module patched successfully for Hunter System compatibility
```

## 🔧 Come Funziona

### 1. Import Automatico
In `game.py` (linea 73):
```python
import uiCharacter_quest_fix  # FIX per crash quest system
```

### 2. Applicazione Patch
In `game.py` (linea 120):
```python
# Applica patch per fix crash quest system
uiCharacter_quest_fix.PatchQuestModule()
```

### 3. Protezione Automatica
Il modulo sostituisce `quest.GetQuestProperties` con una versione safe che:
- Controlla se la stringa è vuota prima di accedervi
- Gestisce correttamente il formato "type:value"
- Ritorna stringhe vuote invece di andare in crash
- Integra le missioni Hunter con il sistema quest standard

## 📦 File Modificati

1. **uiCharacter_quest_fix.py** (NUOVO)
   - Contiene tutte le funzioni di fix e protezione
   - Supporto per missioni Hunter
   - Funzioni di debug

2. **game.py** (MODIFICATO)
   - Aggiunto import di `uiCharacter_quest_fix`
   - Aggiunta chiamata a `PatchQuestModule()`

## 🎮 Compatibilità con Sistema Hunter

Il fix riconosce automaticamente le missioni Hunter e mostra:

- **Nome Missione**: Nome della missione dal database
- **Tipo**: kill_mob, kill_boss, kill_metin, seal_fracture, etc.
- **Progresso**: Formato "corrente/totale" (es. "5/10")
- **Stato**: active, completed, failed, claimed
- **Ricompense**: Gloria e penalità

### Tipi di Missione Supportati

```python
HUNTER_MISSION_TYPES = {
    "kill_mob": "Elimina Mostri",
    "kill_boss": "Uccidi Boss",
    "kill_metin": "Distruggi Metin",
    "kill_any": "Caccia Libera",
    "seal_fracture": "Sigilla Fratture",
    "open_chest": "Apri Bauli",
    "kill_vnum": "Caccia Speciale",
    "emergency_complete": "Emergenza",
    "complete_mission": "Completa Missione",
}
```

## 🛠️ Opzioni Avanzate

### Modifica Manuale di uiCharacter.py (Opzionale)

Se hai accesso al file `uiCharacter.py` originale e vuoi applicare il fix manualmente:

#### Passo 1: Import
All'inizio di `uiCharacter.py`, aggiungi:
```python
import uiCharacter_quest_fix
```

#### Passo 2: Fix nel metodo GetQuestProperties
Sostituisci il metodo problematico (circa linea 1678):

**PRIMA** (causava crash):
```python
def GetQuestProperties(self, questIndex):
    properties = quest.GetQuestProperties(questIndex)
    return properties[0]  # <-- IndexError qui!
```

**DOPO** (safe):
```python
def GetQuestProperties(self, questIndex):
    return uiCharacter_quest_fix.GetQuestProperties_Safe(questIndex)
```

#### Passo 3: Fix nel metodo SetQuest
Nel metodo `SetQuest`, sostituisci:
```python
# PRIMA
questType = self.GetQuestProperties(questIndex)

# DOPO
questType = uiCharacter_quest_fix.GetQuestPropertyType_Safe(questIndex)
questValue = uiCharacter_quest_fix.GetQuestPropertyValue_Safe(questIndex)
```

#### Passo 4: Fix nel metodo LoadCategory
Nel metodo `LoadCategory`, aggiungi controlli:

**PRIMA**:
```python
for i in xrange(quest.GetQuestCount(category)):
    questIndex = quest.GetQuestIndex(category, i)
    self.SetQuest(questIndex)
```

**DOPO**:
```python
questCount = quest.GetQuestCount(category)
if questCount > 0:
    for i in xrange(questCount):
        questIndex = quest.GetQuestIndex(category, i)
        if questIndex >= 0:
            self.SetQuest(questIndex)
```

## 🐞 Debug

### Testare una Quest Specifica

Per debuggare una quest, apri la console in-game e usa:
```python
import uiCharacter_quest_fix
uiCharacter_quest_fix.DebugPrintQuestInfo(questIndex)
```

Output esempio:
```
[Quest Debug] Index: 5
[Quest Debug] Name: Caccia ai Lupi
[Quest Debug] Is Hunter: YES
[Quest Debug] Type: Elimina Mostri
[Quest Debug] Progress: 3/10
[Quest Debug] Status: active
```

## 📊 Database Quest Hunter

Il sistema è completamente integrato con le tabelle del database:

- `hunter_mission_definitions`: Definizioni missioni (49 missioni predefinite)
- `hunter_missions`: Missioni generiche (13 tipi)
- `hunter_player_missions`: Missioni assegnate ai giocatori

### Esempio Query Database

```sql
-- Visualizza missioni attive di un player
SELECT
    pm.slot,
    md.mission_name,
    md.mission_type,
    pm.current_progress,
    md.target_count,
    md.gloria_reward,
    pm.status
FROM hunter_player_missions pm
JOIN hunter_mission_definitions md ON pm.mission_id = md.mission_id
WHERE pm.player_id = YOUR_PLAYER_ID
  AND pm.status = 'active';
```

## 🔍 Risoluzione Problemi

### Il fix non si applica
1. Verifica che `uiCharacter_quest_fix.py` sia nella stessa directory di `game.py`
2. Controlla il log del client per messaggi di errore
3. Assicurati che il file non abbia errori di sintassi

### Le quest Hunter non appaiono
1. Verifica che le missioni siano nel database (`hunter_player_missions`)
2. Controlla che il player abbia livello >= 30 (requisito minimo)
3. Usa la funzione debug per verificare lo stato

### Ancora crash su alcune quest
1. Abilita il debug mode e identifica la quest problematica
2. Controlla che la quest abbia dati validi nel database
3. Verifica che il formato delle quest properties sia corretto

## 📝 Log delle Modifiche

### Versione 1.0 (2025-12-28)
- ✅ Fix iniziale per IndexError in GetQuestProperties
- ✅ Integrazione completa con Hunter System v2.0
- ✅ Monkey patch automatico del modulo quest
- ✅ Supporto per 9 tipi di missione Hunter
- ✅ Funzioni di debug e testing
- ✅ Backward compatibility con quest standard

## 🎯 Compatibilità

- ✅ **Hunter System v2.0**: Completamente compatibile
- ✅ **Quest Standard Metin2**: Completamente compatibile
- ✅ **Database**: Richiede tabelle Hunter System (già presenti)
- ✅ **Python 2.7**: Testato e funzionante
- ✅ **Lua**: Integrato con `hunter_system_v2.lua`

## 📞 Supporto

Se riscontri problemi:
1. Controlla i log del client per messaggi di errore
2. Verifica che tutti i file siano presenti
3. Usa le funzioni di debug per identificare il problema
4. Controlla la compatibilità del database

## ⚠️ Note Importanti

1. **Backup**: Fai sempre un backup di `game.py` prima di modificare
2. **Compilazione**: Ricompila i file `.pyc` dopo le modifiche
3. **Server**: Assicurati che il database sia aggiornato con le tabelle Hunter
4. **Testing**: Testa il fix su un server di test prima del deploy in produzione

## 🚀 Deploy in Produzione

1. Copia `uiCharacter_quest_fix.py` nella directory client
2. Il fix in `game.py` è già presente e pronto
3. Ricompila tutti i file Python
4. Riavvia il client
5. Verifica il log per conferma applicazione patch
6. Testa cliccando sulle categorie quest

---

**Fix Creato da**: Claude Code
**Data**: 2025-12-28
**Versione**: 1.0
**Sistema**: Hunter System v2.0
