<?php
/**
 * get_item_image() - Versione migliorata con supporto custom_image
 *
 * Ottiene il nome del file immagine per un item.
 * Supporta sia immagini basate su VNUM che nomi custom (es: "incantamedi.png")
 *
 * @param int $vnum - VNUM dell'item
 * @param int|null $item_id - ID dell'item nella tabella shop (opzionale)
 * @return string - Nome del file immagine (senza estensione .png)
 */
function get_item_image($vnum, $item_id = null)
{
    global $db;

    // Se è fornito item_id, controlla se esiste un'immagine custom
    if ($item_id !== null) {
        try {
            $stmt = $db->prepare("SELECT custom_image FROM items WHERE id = ?");
            $stmt->execute([$item_id]);
            $result = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($result && !empty($result['custom_image'])) {
                $custom = $result['custom_image'];

                // Rimuovi .png se presente nel nome salvato
                $custom = str_replace('.png', '', $custom);

                // Controlla se il file esiste
                if (file_exists("images/items/" . $custom . ".png")) {
                    return $custom;
                }
            }
        } catch (Exception $e) {
            // Se c'è un errore (es. colonna non esiste ancora), continua con logica vnum
            error_log("get_item_image error: " . $e->getMessage());
        }
    }

    // Fallback alla logica originale basata su VNUM

    // Controlla file con vnum esatto
    if (file_exists("images/items/" . $vnum . ".png"))
        return $vnum;

    // Arrotonda al decimo inferiore
    $new_id = $vnum - $vnum % 10;

    if (strlen($new_id) < 10000) {
        switch (strlen($new_id)) {
            case 2:
                if (file_exists("images/items/000" . $new_id . ".png"))
                    return '000' . $new_id;
                else return 404;
                break;
            case 3:
                if (file_exists("images/items/00" . $new_id . ".png"))
                    return '00' . $new_id;
                else return 404;
                break;
            case 4:
                if (file_exists("images/items/0" . $new_id . ".png"))
                    return '0' . $new_id;
                else return 404;
                break;
        }
    }

    // Mapping specifici per pozioni/oggetti comuni (da 10 a 80)
    $vnum_map = [
        10 => "00010", 11 => "00010", 12 => "00010", 13 => "00010", 14 => "00010",
        15 => "00010", 16 => "00010", 17 => "00010", 18 => "00010", 19 => "00010",
        20 => "00020", 21 => "00020", 22 => "00020", 23 => "00020", 24 => "00020",
        25 => "00020", 26 => "00020", 27 => "00020", 28 => "00020", 29 => "00020",
        30 => "00030", 31 => "00030", 32 => "00030", 33 => "00030", 34 => "00030",
        35 => "00030", 36 => "00030", 37 => "00030", 38 => "00030", 39 => "00030",
        40 => "00040", 41 => "00040", 42 => "00040", 43 => "00040", 44 => "00040",
        45 => "00040", 46 => "00040", 47 => "00040", 48 => "00040", 49 => "00040",
        50 => "00050", 51 => "00050", 52 => "00050", 53 => "00050", 54 => "00050",
        55 => "00050", 56 => "00050", 57 => "00050", 58 => "00050", 59 => "00050",
        60 => "00060", 61 => "00060", 62 => "00060", 63 => "00060", 64 => "00060",
        65 => "00060", 66 => "00060", 67 => "00060", 68 => "00060", 69 => "00060",
        70 => "00070", 71 => "00070", 72 => "00070", 73 => "00070", 74 => "00070",
        75 => "00070", 76 => "00070", 77 => "00070", 78 => "00070", 79 => "00070",
        80 => "00080"
    ];

    if (isset($vnum_map[$vnum])) {
        return $vnum_map[$vnum];
    }

    // Default fallback
    return 404;
}
?>
