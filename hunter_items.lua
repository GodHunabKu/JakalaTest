-- =================================================================
-- HUNTER ITEMS HANDLER (Versione Creativa)
--
-- Ogni oggetto ora ha un feedback testuale pi� ricco e immersivo,
-- in linea con il tema del sistema Hunter.
-- =================================================================

quest hunter_items begin
    state start begin

        -- Item: Scanner di Fratture (Evoca Subito)
        when 50160.use begin
            hg_lib.hunter_speak_color("Scanner in funzione... Frattura rilevata!", "BLUE")
            hg_lib.spawn_fracture()
            item.remove()
        end

        -- Item: Stabilizzatore di Rango (Scegli Rank)
        when 50161.use begin
            say_title("STABILIZZATORE DI RANGO")
            say("")
            say("L'artefatto risuona, pronto a piegare la realta'.")
            say("Focalizzati sull'energia che desideri richiamare.")
            say("")
            
            -- PERFORMANCE: Usa la cache invece di query
            local cached = hg_lib.get_fractures_cached()
            if not cached or cached.count == 0 then 
                syschat("[HUNTER] Nessuna frattura disponibile nei registri.")
                return 
            end
            
            local options, data = {}, {}
            for i = 1, cached.count do
                local f = cached.data[i]
                table.insert(options, "Rango " .. f.rank_label)
                table.insert(data, {vnum = tonumber(f.vnum), rank = f.rank_label, color = f.color_code})
            end
            table.insert(options, "Annulla")
            
            local s = select_table(options)
            if s <= table.getn(data) then
                local choice = data[s]
                local x, y = pc.get_local_x(), pc.get_local_y()
                mob.spawn(choice.vnum, x + 3, y + 3, 1)
                hg_lib.add_fracture_ping(x + 3, y + 3)
                syschat("[HUNTER] Frattura " .. choice.rank .. " evocata!")
                item.remove()
            end
        end

        -- Item: Focus del Cacciatore (+20% Gloria)
        when 50162.use begin
            local pid = pc.get_player_id()
            game.set_event_flag("hq_hunter_focus_"..pid, 1)
            hg_lib.hunter_speak_color("I tuoi sensi si acuiscono. Il flusso di Gloria dalla prossima minaccia sara' amplificato.", "GOLD")
            syschat("[HUNTER] Effetto Focus attivo: la tua percezione delle ricompense e' aumentata.")
            item.remove()
        end

        -- Item: Chiave Dimensionale (Forza Baule)
        when 50163.use begin
            local pid = pc.get_player_id()
            game.set_event_flag("hq_force_chest_"..pid, 1)
            hg_lib.hunter_speak_color("La Chiave Dimensionale si attiva... Il prossimo baule rivelera' i suoi tesori nascosti!", "GOLD")
            syschat("[HUNTER] Il prossimo baule garantira' un bonus Gloria extra!")
            item.remove()
        end

        -- Item: Sigillo di Conquista (Salta Difesa)
        when 50164.use begin
            local pid = pc.get_player_id()
            game.set_event_flag("hq_force_conquest_"..pid, 1)
            hg_lib.hunter_speak_color("Il Sigillo pulsa con potere... La prossima Frattura che toccherai verra' immediatamente soggiogata.", "PURPLE")
            syschat("[HUNTER] L'energia del Sigillo ti permettera' di saltare la fase di difesa.")
            item.remove()
        end

        -- Item: Segnale d'Emergenza (Forza Speed Kill)
        when 50165.use begin
            local pid = pc.get_player_id()
            game.set_event_flag("hq_force_speedkill_"..pid, 1)
            hg_lib.hunter_speak_color("Il segnale inviato al Sistema. La prossima minaccia sara' designata come bersaglio ad alta priorita'.", "RED")
            syschat("[HUNTER] Una Missione d'Emergenza verra' attivata contro il prossimo bersaglio Elite.")
            item.remove()
        end

        -- Item: Risonatore di Gruppo (Party Focus)
        when 50166.use begin
            if not party.is_party() then
                syschat("[HUNTER] Devi essere in un party per usare questo oggetto!")
                return
            end
            
            -- Applica focus usando il PID del LEADER (cosi' tutti nel party ne beneficiano)
            local leader_pid = party.get_leader_pid()
            game.set_event_flag("hq_party_focus_"..leader_pid, 1)
            
            hg_lib.hunter_speak_color("RISONANZA DI GRUPPO ATTIVATA! +20% Gloria per il party sulla prossima kill elite!", "CYAN")
            syschat("[HUNTER] Risonatore attivato! Il party riceve +20% Gloria sulla prossima kill elite!")
            item.remove()
        end

        -- Item: Calibratore di Probabilita' (Garantisce Rango C+)
        when 50167.use begin
            local pid = pc.get_player_id()
            game.set_event_flag("hq_fracture_rank_"..pid, 1)
            hg_lib.hunter_speak_color("Il Calibratore altera le costanti. Le anomalie di basso livello verranno filtrate dal prossimo scan.", "ORANGE")
            syschat("[HUNTER] Il Calibratore e' attivo: la prossima frattura casuale sara' di Rango C o superiore.")
            item.remove()
        end
        
        -- Item: Frammento di Monarca (S-Rank + Focus)
        when 50168.use begin
            -- PERFORMANCE: Usa la cache invece di query
            local cached = hg_lib.get_fractures_cached()
            local s_rank_fractures = {}
            
            if cached and cached.count > 0 then
                for i = 1, cached.count do
                    local f = cached.data[i]
                    if string.find(f.rank_label, "S-Rank") then
                        table.insert(s_rank_fractures, f)
                    end
                end
            end
            
            if table.getn(s_rank_fractures) > 0 then
                -- Seleziona casualmente una S-Rank
                local choice = s_rank_fractures[number(1, table.getn(s_rank_fractures))]
                local x, y = pc.get_local_x(), pc.get_local_y()
                
                mob.spawn(tonumber(choice.vnum), x + 3, y + 3, 1)
                hg_lib.add_fracture_ping(x + 3, y + 3)
                
                local msg = hg_lib.get_text("fracture_detected", {RANK = choice.rank_label}) or "Potere assoluto. Una Frattura "..choice.rank_label.." squarcia la realta'."
                hg_lib.hunter_speak_color(msg, choice.color_code or "PURPLE")
                
                -- Applica anche il focus
                local pid = pc.get_player_id()
                game.set_event_flag("hq_hunter_focus_"..pid, 1)
                hg_lib.hunter_speak_color("FOCUS ATTIVO.", "GOLD")
                
                item.remove()
            else
                hg_lib.hunter_speak("Nessuna Frattura di Rango S trovata nei registri del Sistema.")
            end
        end
    end
end