-- FIX STORED PROCEDURE: Non cancella più le missioni esistenti!
-- ESEGUI QUESTA QUERY NEL DATABASE

DROP PROCEDURE IF EXISTS srv1_hunabku.sp_assign_daily_missions;

DELIMITER ;;
CREATE PROCEDURE srv1_hunabku.sp_assign_daily_missions(
    IN p_player_id INT, 
    IN p_rank VARCHAR(2), 
    IN p_player_name VARCHAR(64)
)
BEGIN
    DECLARE v_today DATE;
    DECLARE v_existing INT DEFAULT 0;
    DECLARE v_player_rank_num INT;
    DECLARE v_mission1_id INT DEFAULT NULL;
    DECLARE v_mission2_id INT DEFAULT NULL;
    DECLARE v_mission3_id INT DEFAULT NULL;
    DECLARE v_mission1_target INT;
    DECLARE v_mission2_target INT;
    DECLARE v_mission3_target INT;
    DECLARE v_mission1_reward INT;
    DECLARE v_mission2_reward INT;
    DECLARE v_mission3_reward INT;
    DECLARE v_mission1_penalty INT;
    DECLARE v_mission2_penalty INT;
    DECLARE v_mission3_penalty INT;

    SET v_today = CURDATE();
    SET v_player_rank_num = fn_rank_to_num(p_rank);
    
    -- FIX CRITICO: Conta TUTTE le missioni di oggi (active + completed), non solo active!
    SELECT COUNT(*) INTO v_existing FROM hunter_player_missions 
    WHERE player_id = p_player_id AND assigned_date = v_today;

    -- Se ne ha meno di 3, genera solo le mancanti (NON cancellare quelle esistenti!)
    IF v_existing < 3 THEN
        -- NON PIU' DELETE! Inserisce solo gli slot mancanti
        
        -- Slot 1 (solo se non esiste)
        IF NOT EXISTS (SELECT 1 FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_date = v_today AND mission_slot = 1) THEN
            SELECT mission_id, target_count, gloria_reward, gloria_penalty
            INTO v_mission1_id, v_mission1_target, v_mission1_reward, v_mission1_penalty
            FROM hunter_mission_definitions 
            WHERE enabled = 1 AND fn_rank_to_num(min_rank) <= v_player_rank_num
            ORDER BY RAND() LIMIT 1;
            
            IF v_mission1_id IS NOT NULL THEN
                INSERT INTO hunter_player_missions (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
                VALUES (p_player_id, 1, v_mission1_id, v_today, 0, v_mission1_target, 'active', v_mission1_reward, v_mission1_penalty);
            END IF;
        END IF;

        -- Slot 2 (solo se non esiste)
        IF NOT EXISTS (SELECT 1 FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_date = v_today AND mission_slot = 2) THEN
            SELECT mission_id, target_count, gloria_reward, gloria_penalty
            INTO v_mission2_id, v_mission2_target, v_mission2_reward, v_mission2_penalty
            FROM hunter_mission_definitions 
            WHERE enabled = 1 AND fn_rank_to_num(min_rank) <= v_player_rank_num
            AND mission_id NOT IN (SELECT mission_def_id FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_date = v_today)
            ORDER BY RAND() LIMIT 1;
            
            IF v_mission2_id IS NOT NULL THEN
                INSERT INTO hunter_player_missions (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
                VALUES (p_player_id, 2, v_mission2_id, v_today, 0, v_mission2_target, 'active', v_mission2_reward, v_mission2_penalty);
            END IF;
        END IF;

        -- Slot 3 (solo se non esiste)
        IF NOT EXISTS (SELECT 1 FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_date = v_today AND mission_slot = 3) THEN
            SELECT mission_id, target_count, gloria_reward, gloria_penalty
            INTO v_mission3_id, v_mission3_target, v_mission3_reward, v_mission3_penalty
            FROM hunter_mission_definitions 
            WHERE enabled = 1 AND fn_rank_to_num(min_rank) <= v_player_rank_num
            AND mission_id NOT IN (SELECT mission_def_id FROM hunter_player_missions WHERE player_id = p_player_id AND assigned_date = v_today)
            ORDER BY RAND() LIMIT 1;
            
            IF v_mission3_id IS NOT NULL THEN
                INSERT INTO hunter_player_missions (player_id, mission_slot, mission_def_id, assigned_date, current_progress, target_count, status, reward_glory, penalty_glory)
                VALUES (p_player_id, 3, v_mission3_id, v_today, 0, v_mission3_target, 'active', v_mission3_reward, v_mission3_penalty);
            END IF;
        END IF;
    END IF;
END;;
DELIMITER ;
