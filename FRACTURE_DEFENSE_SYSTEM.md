# 🔥 HUNTER SYSTEM - FRACTURE DEFENSE & SPEED KILL SYSTEM

**Data:** 27 Dicembre 2025
**Branch:** `claude/dungeon-selection-analysis-qyraV`
**Ispirato a:** Solo Leveling, Lost Ark, Diablo

---

## 📋 NUOVE FEATURES IMPLEMENTATE

### 🛡️ 1. SISTEMA DIFESA FRATTURA (Fracture Defense)

Quando apri una frattura, NON spawna immediatamente il premio. Invece:

1. **Parte una Quest di Difesa** (60 secondi di default)
2. **Devi stare vicino alla frattura** o la difesa fallisce
3. **Spawnano ondate di mostri** (configurabili nel DB)
4. **Se in party di 4**, tutti devono stare vicini
5. **Dopo 60 secondi** → Frattura si apre e spawna il premio (Boss/Metin/Baule)

#### Come Funziona

**Configurazione:**
```sql
-- Tabella per le ondate
CREATE TABLE hunter_fracture_defense_waves (
  wave_id INT AUTO_INCREMENT PRIMARY KEY,
  rank_grade VARCHAR(2),  -- E,D,C,B,A,S,N
  wave_number INT,         -- Numero ondata (1,2,3,4)
  spawn_time INT,          -- Quando spawna (secondi dall'inizio)
  mob_vnum INT,            -- VNUM mob da spawnare
  mob_count INT,           -- Quanti mob
  spawn_radius INT,        -- Raggio di spawn
  enabled TINYINT(1)
);

-- Tabella configurazione globale
CREATE TABLE hunter_fracture_defense_config (
  config_key VARCHAR(64) PRIMARY KEY,
  config_value INT,
  description VARCHAR(255)
);
```

**Parametri Configurabili:**
- `defense_duration`: 60 secondi (durata difesa)
- `check_distance`: 10 metri (distanza massima dalla frattura)
- `check_interval`: 2 secondi (ogni quanto controlla la posizione)
- `party_all_required`: 1 (se 1, tutti i membri devono stare vicini)

#### Esempio Ondate per Rank E:
```sql
-- Ondata 1: dopo 5 secondi spawna 3 Lupi
-- Ondata 2: dopo 15 secondi spawna 5 Orsi
-- Ondata 3: dopo 30 secondi spawna 4 Tigri
-- Ondata 4: dopo 45 secondi spawna 2 Orsi Capo (finale)
```

### ⚡ 2. SISTEMA SPEED KILL (Timer Visivo)

Quando spawna un **Boss** o **Super Metin** e sei **SOLO** (no party):

1. **Parte un timer speed kill** (configurabile: 60s boss, 300s metin)
2. **Timer visivo a schermo** con countdown
3. **Se uccidi entro il tempo** → **GLORIA x2!**
4. **Se fallisci** → Gloria normale (nessuna penalità)

#### Caratteristiche:
- ✅ **Solo per player soli** (no party)
- ✅ **Timer visivo in UI** (popup/event window)
- ✅ **Bonus x2 gloria** solo se uccidi in tempo
- ✅ **Nessuna penalità** se fallisci
- ✅ **Configurabile da DB** (tabella `hunter_config`)

---

## 🎮 ESPERIENZA GIOCATORE

### Scenario 1: Apertura Frattura Solo
```
Player clicca frattura E-Rank
→ "DIFENDI LA FRATTURA! Rimani vicino per 60 secondi!"
→ Timer countdown inizia
→ Ondata 1 (5s): Spawna 3 Lupi
→ Player li uccide
→ Ondata 2 (15s): Spawna 5 Orsi
→ Player resta vicino alla frattura
→ Ondata 3 (30s): Spawna 4 Tigri
→ Ondata 4 (45s): Spawna 2 Orsi Capo
→ 60 secondi completati!
→ "DIFESA COMPLETATA! La frattura si apre..."
→ Spawna Boss E-Rank
→ "SFIDA SPEED KILL! Uccidi in 60 secondi per GLORIA x2!"
→ Player uccide boss in 45 secondi
→ "SPEED KILL! GLORIA x2!"
→ Ottenuto 200 gloria invece di 100
```

### Scenario 2: Apertura Frattura in Party (4 player)
```
Party di 4 player clicca frattura C-Rank
→ "DIFENDI LA FRATTURA! Tutti rimanete vicini per 60 secondi!"
→ Timer countdown inizia
→ Ondate di mob spawnano (più forte per Rank C)
→ Un player si allontana troppo
→ "DIFESA FALLITA: Un membro del party si è allontanato!"
→ Frattura NON si apre, nessun premio
```

### Scenario 3: Speed Kill Fallito
```
Player solo spawna Super Metin
→ "SFIDA SPEED KILL! Uccidi in 5 minuti per GLORIA x2!"
→ Timer countdown
→ Player impiega 6 minuti per uccidere
→ "TEMPO SCADUTO! Nessun bonus x2."
→ Ottenuto 150 gloria (normale)
→ Nessuna penalità
```

---

## 🛠️ FILE MODIFICATI

### 1. hunter_level_bridge.lua

**Funzioni aggiunte:**
```lua
-- FRACTURE DEFENSE
function open_gate(fname, frank, fcolor, pid)
  -- Inizia difesa invece di spawnare subito

function get_defense_config(key, default_val)
function check_defense_distance()
function spawn_defense_wave(wave_num, rank_grade)
function complete_defense_success()
function fail_defense(reason)

-- SPEED KILL
when hq_speedkill_timer.timer begin
  -- Aggiorna timer speed kill UI

-- DEFENSE TIMER
when hq_defense_timer.timer begin
  -- Gestisce difesa frattura, spawn ondate, check distanza
```

**Modifiche alla gloria:**
```lua
-- Nuovo sistema speed kill (sostituisce vecchio sistema)
if speedkill_active == 1 and speedkill_vnum == vnum then
  if elapsed <= duration then
    base_pts = base_pts * 2  -- x2 GLORIA!
    cmdchat("HunterSpeedKillEnd 1")
```

### 2. game.py

**Comandi aggiunti (linea 2407-2413):**
```python
# Fracture Defense & Speed Kill System
serverCommandList["HunterFractureDefenseStart"]    = self.__HunterFractureDefenseStart
serverCommandList["HunterFractureDefenseTimer"]    = self.__HunterFractureDefenseTimer
serverCommandList["HunterFractureDefenseComplete"] = self.__HunterFractureDefenseComplete
serverCommandList["HunterSpeedKillStart"]          = self.__HunterSpeedKillStart
serverCommandList["HunterSpeedKillTimer"]          = self.__HunterSpeedKillTimer
serverCommandList["HunterSpeedKillEnd"]            = self.__HunterSpeedKillEnd
```

**Handler implementati (linea 3779-3852):**
- `__HunterFractureDefenseStart(args)` → fracture_name|duration|color
- `__HunterFractureDefenseTimer(remaining)` → aggiorna countdown
- `__HunterFractureDefenseComplete(args)` → success|message
- `__HunterSpeedKillStart(args)` → mob_type|duration|color
- `__HunterSpeedKillTimer(remaining)` → aggiorna countdown
- `__HunterSpeedKillEnd(success)` → 1=successo, 0=fallito

### 3. interfacemodule.py

**Handler aggiunti (linea 3619-3655):**
```python
# FRACTURE DEFENSE SYSTEM
def HunterFractureDefenseStart(self, fractureName, duration, color)
def HunterFractureDefenseTimer(self, remainingSeconds)
def HunterFractureDefenseComplete(self, success, message)

# SPEED KILL SYSTEM
def HunterSpeedKillStart(self, mobType, duration, color)
def HunterSpeedKillTimer(self, remainingSeconds)
def HunterSpeedKillEnd(self, isSuccess)
```

### 4. fracture_defense_system.sql (NUOVO)

Script completo per creare tabelle:
- `hunter_fracture_defense_waves`
- `hunter_fracture_defense_config`
- Esempi ondate per Rank E, D, C

---

## 🚀 COME APPLICARE

### 1. Database
```bash
mysql -u root -p < fracture_defense_system.sql
```

**⚠️ IMPORTANTE:** Personalizza i VNUM mob nelle ondate!

### 2. Configurazione Ondate

Modifica i VNUM mob in base al tuo server:
```sql
-- Esempio: Ondata 1 per Rank E
UPDATE hunter_fracture_defense_waves
SET mob_vnum = 101  -- Cambia con VNUM Lupo del tuo server
WHERE rank_grade = 'E' AND wave_number = 1;
```

Puoi aggiungere infinite ondate:
```sql
INSERT INTO hunter_fracture_defense_waves
(rank_grade, wave_number, spawn_time, mob_vnum, mob_count, spawn_radius)
VALUES
('S', 5, 55, 9999, 10, 10);  -- Ondata 5 per Rank S
```

### 3. Configurazione Globale

Modifica i parametri:
```sql
-- Aumenta durata difesa a 90 secondi
UPDATE hunter_fracture_defense_config
SET config_value = 90
WHERE config_key = 'defense_duration';

-- Aumenta distanza max a 15 metri
UPDATE hunter_fracture_defense_config
SET config_value = 15
WHERE config_key = 'check_distance';
```

---

## 🎨 UI/UX (TODO per il Frontend)

Devi implementare nel client (Python UI):

### 1. Timer Difesa Frattura
```python
def StartFractureDefense(self, fractureName, duration, color):
    # Mostra popup con:
    # - Nome frattura
    # - Timer countdown (60s)
    # - Messaggio "RIMANI VICINO!"

def UpdateFractureDefenseTimer(self, remainingSeconds):
    # Aggiorna countdown ogni secondo

def CompleteFractureDefense(self, success, message):
    # success=1 → Effetto successo + spawna premio
    # success=0 → Effetto fallimento + messaggio errore
```

### 2. Timer Speed Kill
```python
def StartSpeedKill(self, mobType, duration, color):
    # Mostra timer laterale:
    # "SPEED KILL: [BOSS/SUPER METIN]"
    # Countdown con barra colorata

def UpdateSpeedKillTimer(self, remainingSeconds):
    # Aggiorna barra/timer
    # Cambia colore se < 30s (giallo)
    # Cambia colore se < 10s (rosso)

def EndSpeedKill(self, isSuccess):
    # isSuccess=1 → "SPEED KILL! x2 GLORIA!"
    # isSuccess=0 → "TEMPO SCADUTO"
```

### Suggerimenti UI:
- **Difesa Frattura**: Popup centrale come quello dell'emergenza
- **Speed Kill**: Timer laterale tipo event timer
- **Effetti**: Particelle, suoni, animazioni
- **Colori**: Usa i colori passati dal server (GREEN, BLUE, ORANGE, RED, GOLD, PURPLE)

---

## 🧪 TESTING

### Test 1: Difesa Frattura Successo
1. Trova frattura E-Rank
2. Aprila
3. Resta vicino per 60 secondi
4. Uccidi tutti i mob delle ondate
5. ✅ Frattura si apre, spawna boss

### Test 2: Difesa Frattura Fallimento (Distanza)
1. Apri frattura
2. Allontanati oltre 10 metri
3. ✅ Difesa fallisce con messaggio

### Test 3: Difesa Frattura Fallimento (Party)
1. Party di 4 player
2. Apri frattura
3. Un player si allontana
4. ✅ Difesa fallisce

### Test 4: Speed Kill Successo
1. Apri frattura SOLO (no party)
2. Spawna boss
3. Uccidi entro 60 secondi
4. ✅ Ottieni x2 gloria

### Test 5: Speed Kill Fallimento
1. Apri frattura solo
2. Spawna boss
3. Impieghi >60 secondi
4. ✅ Gloria normale, nessuna penalità

---

## 🔧 PERSONALIZZAZIONE

### Ondate più Difficili
```sql
-- Rank S: ondate devastanti
INSERT INTO hunter_fracture_defense_waves
(rank_grade, wave_number, spawn_time, mob_vnum, mob_count, spawn_radius)
VALUES
('S', 1, 5, 6666, 10, 8),   -- 10 Elite dopo 5s
('S', 2, 15, 6667, 15, 8),  -- 15 Elite dopo 15s
('S', 3, 30, 6668, 20, 10), -- 20 Elite dopo 30s
('S', 4, 45, 6669, 5, 5);   -- 5 Boss finali dopo 45s
```

### Difesa più Lunga
```sql
UPDATE hunter_fracture_defense_config
SET config_value = 120  -- 2 minuti
WHERE config_key = 'defense_duration';
```

### Party Opzionale
```sql
-- Se vuoi che anche 1 solo membro possa difendere in party
UPDATE hunter_fracture_defense_config
SET config_value = 0  -- 0 = almeno 1 vicino
WHERE config_key = 'party_all_required';
```

---

## 📊 STATISTICHE & BILANCIAMENTO

### Gloria Media per Frattura
**Prima (vecchio sistema):**
- Solo player: 100-500 gloria (base)
- Con party: 100-500 gloria (divisa)

**Dopo (nuovo sistema):**
- Solo player: 200-1000 gloria (se speed kill)
- Con party: 100-500 gloria (no speed kill)

**Bilanciamento:** Il sistema premia i player soli con speed kill x2!

### Difficoltà Ondate
- **Rank E**: 4 ondate, mob facili (Lupi, Orsi)
- **Rank D**: 4 ondate, mob medi (Soldati)
- **Rank C**: 4 ondate, mob difficili
- **Rank B-S**: Personalizza con mob endgame

---

## 🐛 DEBUG

### Comando GM per testare difesa:
```lua
when chat."/test_defense" with pc.is_gm() begin
    pc.setqf("hq_defense_active", 1)
    pc.setqf("hq_defense_start", get_time())
    pc.setqf("hq_defense_rank", "E")
    loop_timer("hq_defense_timer", 1)
end
```

### Comando GM per testare speed kill:
```lua
when chat."/test_speedkill" with pc.is_gm() begin
    pc.setqf("hq_speedkill_active", 1)
    pc.setqf("hq_speedkill_start", get_time())
    pc.setqf("hq_speedkill_duration", 60)
    pc.setqf("hq_speedkill_vnum", 4035)
    loop_timer("hq_speedkill_timer", 1)
end
```

---

## 💡 IDEE FUTURE

- ⭐ Boss finale dopo difesa (sempre)
- ⭐ Reward migliore per difesa perfetta (0 morti)
- ⭐ Leaderboard speed kill (miglior tempo)
- ⭐ Ondate random (non predefinite)
- ⭐ Difficoltà dinamica (più player = più mob)

---

**Developed by:** Claude Code
**Status:** ✅ Ready for Testing
**Next Steps:** Implementare UI timer nel client Python
