# 🧪 CHECKLIST TEST FINALE - HUNTER FRACTURE DEFENSE SYSTEM

**Data Check:** 27 Dicembre 2025
**Branch:** `claude/dungeon-selection-analysis-qyraV`
**Ultimo Commit:** `20d9835` (Merge main)

---

## 📋 PREREQUISITI

### Database
- [ ] Importato `fracture_defense_system.sql` nel database `srv1_hunabku`
- [ ] Verificato esistenza tabella `hunter_fracture_defense_waves`
- [ ] Verificato esistenza tabella `hunter_fracture_defense_config`
- [ ] Verificato configurazioni: `speedkill_boss_seconds=60`, `speedkill_metin_seconds=300`

### Quest Lua
- [ ] File `hunter_level_bridge.lua` caricato sul server
- [ ] File `hunter_gate_trial.lua` caricato sul server
- [ ] Riavviato server dopo caricamento quest

### Client Python
- [ ] File `game.py` aggiornato sul client
- [ ] File `interfacemodule.py` aggiornato sul client
- [ ] File `uihunterlevel.py` aggiornato sul client (versione 2558 righe - SOLO LEVELING EDITION)
- [ ] Riavviato client dopo aggiornamento

---

## 🧪 TEST 1: DIFESA FRATTURA BASE

### Setup
- [ ] Spawn frattura E-Rank (VNUM 16060)
- [ ] Player livello ≥ 5
- [ ] Player NON in party

### Test Steps
1. [ ] **Click frattura** → Verifica popup What-If o dialog classico appare
2. [ ] **Scegli "Apri Gate"** → Verifica:
   - [ ] Emergency popup appare con timer 60s
   - [ ] Messaggio "DIFENDI LA FRATTURA!" in chat
   - [ ] Frattura rimane visibile

3. [ ] **Dopo 5 secondi** → Verifica:
   - [ ] Ondata 1 spawna (3 mob VNUM 101)
   - [ ] Messaggio in chat: `[DEBUG] Ondata 1: spawno 3 mob (VNUM: 101)`
   - [ ] Messaggio: `[DEBUG] Totale mob spawnati: 3`

4. [ ] **Dopo 15 secondi** → Verifica:
   - [ ] Ondata 2 spawna (5 mob VNUM 103)
   - [ ] Messaggio: `[DEBUG] Ondata 2: spawno 5 mob (VNUM: 103)`
   - [ ] Messaggio: `[DEBUG] Totale mob spawnati: 8`

5. [ ] **Dopo 30 secondi** → Verifica:
   - [ ] Ondata 3 spawna (4 mob VNUM 105)
   - [ ] Messaggio: `[DEBUG] Ondata 3: spawno 4 mob (VNUM: 105)`

6. [ ] **Dopo 45 secondi** → Verifica:
   - [ ] Ondata 4 spawna (2 mob VNUM 191)
   - [ ] Messaggio: `[DEBUG] Ondata 4: spawno 2 mob (VNUM: 191)`
   - [ ] Totale mob: 3+5+4+2 = 14 mob

7. [ ] **Uccidi tutti i 14 mob entro 60 secondi** → Verifica:
   - [ ] Emergency popup si chiude automaticamente
   - [ ] Messaggio: "DIFESA COMPLETATA! La frattura si apre..."
   - [ ] **Frattura NPC sparisce**
   - [ ] Boss o Super Metin spawna vicino a te

### Expected Result
✅ Difesa completata con successo
✅ Popup chiuso
✅ Frattura rimossa
✅ Boss/Metin spawnato

---

## 🧪 TEST 2: SPEED KILL - BOSS (60 secondi)

### Setup (dopo aver completato Test 1)
- [ ] Boss spawnato dalla difesa frattura
- [ ] Player SOLO (non in party)

### Test Steps
1. [ ] **Boss spawna** → Verifica:
   - [ ] Messaggio in chat: `[SPEED KILL] BOSS - Uccidi entro 1:00 per GLORIA x2!`
   - [ ] Timer interno inizia (60 secondi)

2. [ ] **Uccidi boss ENTRO 60 secondi** → Verifica:
   - [ ] Messaggio: `[SPEED KILL SUCCESS] GLORIA x2!`
   - [ ] Gloria raddoppiata nel reward

### Expected Result
✅ Speed Kill SUCCESS
✅ Gloria x2

---

## 🧪 TEST 3: SPEED KILL - SUPER METIN (300 secondi)

### Setup
- [ ] Completa difesa frattura che spawna Super Metin
- [ ] Player SOLO

### Test Steps
1. [ ] **Super Metin spawna** → Verifica:
   - [ ] Messaggio: `[SPEED KILL] SUPER METIN - Uccidi entro 5:00 per GLORIA x2!`
   - [ ] Timer 300 secondi (5 minuti)

2. [ ] **Uccidi ENTRO 5 minuti** → Verifica:
   - [ ] Messaggio: `[SPEED KILL SUCCESS] GLORIA x2!`
   - [ ] Gloria raddoppiata

3. [ ] **Uccidi DOPO 5 minuti** → Verifica:
   - [ ] Messaggio: `[SPEED KILL FAILED] Gloria normale`
   - [ ] Gloria normale (no bonus)

### Expected Result
✅ Timer corretto (5 minuti)
✅ Messaggi corretti SUCCESS/FAILED

---

## 🧪 TEST 4: DIFESA FALLITA - TIMEOUT

### Test Steps
1. [ ] Click frattura e avvia difesa
2. [ ] **NON uccidere tutti i mob**
3. [ ] **Lascia scadere i 60 secondi** → Verifica:
   - [ ] Emergency popup si chiude
   - [ ] Messaggio: "DIFESA FALLITA: TEMPO SCADUTO! Mob rimasti: X"
   - [ ] **Frattura NPC sparisce**
   - [ ] Nessun boss spawna

### Expected Result
✅ Difesa fallita correttamente
✅ Popup chiuso
✅ Frattura rimossa
✅ Nessun spawn

---

## 🧪 TEST 5: DIFESA FALLITA - DISTANZA

### Test Steps
1. [ ] Click frattura e avvia difesa
2. [ ] **Allontanati dalla frattura** (oltre 10 metri)
3. [ ] Verifica:
   - [ ] Messaggio: "DIFESA FALLITA: Ti sei allontanato!"
   - [ ] Emergency popup si chiude
   - [ ] **Frattura NPC sparisce**

### Expected Result
✅ Check distanza funziona
✅ Fallimento immediato se allontani

---

## 🧪 TEST 6: CONFLICT PREVENTION - Emergency vs Difesa

### Test 6A: Emergency blocca apertura frattura
1. [ ] Spawna emergency quest manualmente
2. [ ] Prova a cliccare frattura → Verifica:
   - [ ] Messaggio: `[CONFLITTO] Completa prima l'Emergency Quest in corso!`
   - [ ] Frattura NON si apre

### Test 6B: Difesa blocca spawn emergency
1. [ ] Avvia difesa frattura
2. [ ] Durante i 60 secondi, emergency NON deve spawnare
3. [ ] Verifica nessuna emergency appare durante difesa

### Test 6C: Speed Kill blocca spawn emergency
1. [ ] Avvia speed kill (uccidi boss dopo difesa)
2. [ ] Durante speed kill, emergency NON deve spawnare
3. [ ] Verifica nessuna emergency appare

### Expected Result
✅ Nessun conflitto popup
✅ Una attività alla volta

---

## 🧪 TEST 7: PARTY MODE

### Setup
- [ ] Crea party con 2+ membri
- [ ] Tutti i membri vicini alla frattura

### Test Steps
1. [ ] Click frattura in party
2. [ ] Avvia difesa
3. [ ] **Un membro si allontana** → Verifica:
   - [ ] Messaggio: "DIFESA FALLITA: Un membro del party si è allontanato!"
   - [ ] Difesa fallisce immediatamente

### Expected Result
✅ Party check funziona
✅ Tutti devono stare vicini

---

## 🧪 TEST 8: MULTIPLE RANKS

### Test D-Rank
- [ ] Spawn frattura D-Rank (VNUM 16061)
- [ ] Verifica ondate diverse (VNUM 301, 303, 305, 391)

### Test C-Rank
- [ ] Spawn frattura C-Rank (VNUM 16062)
- [ ] Verifica ondate diverse (VNUM 501, 503, 505, 591)

### Expected Result
✅ Ogni rank ha le sue ondate
✅ Mob corrispondono al database

---

## 🧪 TEST 9: DATABASE CUSTOMIZATION

### Test Modifica Count
1. [ ] Cambia `mob_count` in database per rank E, wave 1:
   ```sql
   UPDATE hunter_fracture_defense_waves
   SET mob_count = 10
   WHERE rank_grade='E' AND wave_number=1;
   ```
2. [ ] Riavvia server
3. [ ] Testa frattura E → Verifica 10 mob spawnano nella wave 1

### Test Modifica VNUM
1. [ ] Cambia `mob_vnum` in database
2. [ ] Riavvia server
3. [ ] Verifica mob corretto spawna

### Expected Result
✅ Database modifiche funzionano
✅ Spawn riflette configurazione DB

---

## 🧪 TEST 10: ERROR HANDLING

### Test string.gmatch fix
- [ ] Verifica NESSUN errore nel syserr:
  - [ ] NO errore "attempt to call field 'gmatch'"
  - [ ] NO errore "QUEST wrong set flag"
  - [ ] NO errore "npc.get_x() nil value"

### Test Python UI
- [ ] Verifica NESSUN errore:
  - [ ] NO errore "'HunterLevelWindow' object has no attribute 'UpdateSpeedKillTimer'"
  - [ ] NO errore "'HunterLevelWindow' object has no attribute 'EndSpeedKill'"

### Expected Result
✅ ZERO errori in syserr
✅ ZERO errori in syslog

---

## 📊 RIEPILOGO FINALE

### ✅ Checklist Completamento
- [ ] Tutti i 10 test passati
- [ ] Nessun errore in syserr
- [ ] Popup funzionano correttamente
- [ ] Timer corretti (60s difesa, 60s boss, 300s metin)
- [ ] Conflict prevention funziona
- [ ] Frattura sparisce dopo successo/fallimento
- [ ] Speed Kill messaggi corretti
- [ ] Database configurabile

### 🐛 Bug Trovati
_(Annota qui eventuali bug trovati durante i test)_

---

### 🎯 Note Finali
- Se tutto passa → Sistema PRONTO per produzione ✅
- Se ci sono bug → Segnala e fixiamo 🔧
- Ricorda di personalizzare i VNUM mob nel database per il tuo server!

**BUON TEST!** 🚀
