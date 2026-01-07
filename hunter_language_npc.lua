-- ============================================================================
--  HUNTER LANGUAGE NPC QUEST
--  NPC per il cambio lingua del Hunter Terminal
--  VNUM: 20100 (da configurare nel mob_proto)
-- ============================================================================

quest hunter_language_npc begin
    state start begin

        -- ============================================================
        -- NPC TRADUTTORE - Cambio Lingua Hunter Terminal
        -- NOTA: Sostituisci 20100 con il VNUM del tuo NPC nel mob_proto
        -- ============================================================
        when 20100.click begin
            local pid = pc.get_player_id()
            local current_lang = hg_lib.get_player_language(pid)

            -- Titolo con lingua corrente
            local lang_names = {
                it = "Italiano",
                en = "English",
                de = "Deutsch",
                es = "Espanol",
                fr = "Francais",
                pt = "Portugues",
                ru = "Russkiy",
                pl = "Polski"
            }

            local current_name = lang_names[current_lang] or "Italiano"

            say_title("Traduttore del Sistema")
            say("")
            say("Salve, Cacciatore.")
            say("")
            say("Posso tradurre il Sistema Hunter")
            say("nella lingua che preferisci.")
            say("")
            say("Lingua attuale: " .. current_name)
            say("")

            local choice = select("Italiano", "English", "Deutsch", "Espanol", "Francais", "Portugues", "Chiudi")

            if choice == 7 then
                return
            end

            local lang_codes = {"it", "en", "de", "es", "fr", "pt"}
            local selected_lang = lang_codes[choice]

            if selected_lang == current_lang then
                say_title("Traduttore del Sistema")
                say("")
                say("Il Sistema e' gia' impostato")
                say("in questa lingua.")
                return
            end

            -- Cambia lingua nel database
            hg_lib.set_player_language(pid, selected_lang)

            -- Notifica il client
            cmdchat("HunterLanguageChanged " .. selected_lang)

            -- Messaggio di conferma
            local new_name = lang_names[selected_lang] or selected_lang
            say_title("Traduttore del Sistema")
            say("")
            say("Fatto!")
            say("")
            say("Il Sistema Hunter e' stato")
            say("tradotto in: " .. new_name)
            say("")
            say("Riapri il Terminale per vedere")
            say("i testi nella nuova lingua.")

            syschat("|cff00AAFF[HUNTER]|r Lingua cambiata in: " .. string.upper(selected_lang))
        end

    end
end
