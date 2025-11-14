-- Migrazione Database Items Table
-- Aggiunta campi custom_image e sort_order

-- 1. Aggiungi campo per nome immagine custom
ALTER TABLE item_shop_items ADD COLUMN custom_image TEXT DEFAULT NULL;

-- 2. Aggiungi campo per ordinamento personalizzato
ALTER TABLE item_shop_items ADD COLUMN sort_order INTEGER DEFAULT 0;

-- 3. Inizializza sort_order con ID per item esistenti
UPDATE item_shop_items SET sort_order = id WHERE sort_order = 0 OR sort_order IS NULL;
