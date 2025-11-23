<?php
    // ============================================
    // ONE SERVER - WISHLIST PAGE (REDESIGNED)
    // ============================================

    require_once __DIR__ . '/../../include/functions/wishlist.php';

    if(!is_loggedin()) {
        print '<script>window.location.href = "'.$shop_url.'login";</script>';
        exit;
    }

    $account_id = get_account_id();

    // Gestione add/remove
    if(isset($_GET['action']) && isset($_GET['item_id'])) {
        $item_id = intval($_GET['item_id']);

        if($_GET['action'] == 'add' && isset($_GET['vnum']) && isset($_GET['name']) && isset($_GET['price'])) {
            $vnum = intval($_GET['vnum']);
            $name = $_GET['name'];
            $price = intval($_GET['price']);
            wishlist_add($account_id, $item_id, $vnum, $name, $price);
            print '<script>window.location.href = "'.$shop_url.'wishlist";</script>';
        } elseif($_GET['action'] == 'remove') {
            wishlist_remove($account_id, $item_id);
            print '<script>window.location.href = "'.$shop_url.'wishlist";</script>';
        }
    }

    $wishlist = wishlist_get($account_id);
    
    // Pre-calcolo totale e preparazione dati
    $display_items = [];
    $total_price = 0;

    foreach($wishlist as $item) {
        $sth = $database->runQuerySqlite('SELECT * FROM item_shop_items WHERE id = ?');
        $sth->bindParam(1, $item['item_id'], PDO::PARAM_INT);
        $sth->execute();
        $row = $sth->fetch();

        if($row) {
            $final_price = $row['discount'] > 0 ? $row['coins'] - ($row['coins'] * $row['discount'] / 100) : $row['coins'];
            $total_price += round($final_price);
            
            $item['db_row'] = $row;
            $item['final_price'] = round($final_price);
            $item['item_name'] = !$item_name_db ? get_item_name($row['vnum']) : get_item_name_locale_name($row['vnum']);
            $display_items[] = $item;
        }
    }
?>

<!-- WISHLIST HERO -->
<div class="one-wishlist-hero">
    <div class="one-wishlist-hero-content">
        <h1 class="one-wishlist-title">
            <i class="fa fa-heart"></i> I MIEI PREFERITI
        </h1>
        <p class="one-wishlist-subtitle">
            Gestisci la tua lista dei desideri e tieni d'occhio i tuoi item preferiti.
        </p>
        <div class="one-wishlist-stats">
            <span class="badge badge-danger mr-2"><?php echo count($display_items); ?> ITEM SALVATI</span>
            <?php if($total_price > 0) { ?>
            <span class="badge badge-warning" style="background-color: #ffd700; color: #000;">
                TOTALE: <?php echo number_format($total_price, 0, '', '.'); ?> MD
            </span>
            <?php } ?>
        </div>
    </div>
</div>

<!-- WISHLIST GRID -->
<div class="one-items-section-wishlist">
    <div class="one-items-container">
        
        <?php if(count($display_items) == 0) { ?>
            <div class="one-no-results">
                <div class="icon-wrapper">
                    <i class="fa fa-heart-o"></i>
                </div>
                <h3>La tua wishlist è vuota</h3>
                <p>Non hai ancora aggiunto nessun oggetto ai preferiti.</p>
                <a href="<?php print $shop_url; ?>" class="one-btn-back">
                    <i class="fa fa-arrow-left"></i> Inizia lo Shopping
                </a>
            </div>
        <?php } else { ?>

        <div class="one-items-grid-wishlist">
            <?php foreach($display_items as $item) {
                $row = $item['db_row'];
                $item_name = $item['item_name'];
                $final_price = $item['final_price'];
            ?>
            
            <!-- Item Card (Consistent Style) -->
            <div class="one-item-card-wishlist">
                
                <!-- Remove Button -->
                <a href="<?php print $shop_url.'wishlist?action=remove&item_id='.$row['id']; ?>" 
                   class="one-remove-btn"
                   onclick="return confirm('Rimuovere dai preferiti?')">
                    <i class="fa fa-times"></i>
                </a>
                
                <!-- Badges -->
                <?php if(is_item_new($row['id'])) { ?>
                <div class="item-badge-new">NUOVO</div>
                <?php } ?>
                
                <?php if($row['discount'] > 0) { ?>
                <div class="item-badge-discount">-<?php echo $row['discount']; ?>%</div>
                <?php } ?>
                
                <!-- Link -->
                <a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" class="one-item-link-wishlist">
                    
                    <!-- Image -->
                    <div class="one-item-image-wishlist">
                        <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['vnum']); ?>.png" 
                             alt="<?php echo $item_name; ?>"
                             onerror="this.src='<?php print $shop_url; ?>images/items/default.png'">
                    </div>
                    
                    <!-- Info -->
                    <div class="one-item-info-wishlist">
                        <h3 class="one-item-title-wishlist"><?php echo $item_name; ?></h3>
                        
                        <!-- Price -->
                        <div class="one-item-price-wishlist">
                            <img src="<?php print $shop_url; ?>images/md.png" style="width: 20px; height: 20px;">
                            
                            <?php if($row['discount'] > 0) { ?>
                            <span class="price-old-wishlist"><?php echo $row['coins']; ?></span>
                            <span class="price-new-wishlist"><?php echo $final_price; ?></span>
                            <?php } else { ?>
                            <span class="price-single-wishlist"><?php echo $row['coins']; ?></span>
                            <?php } ?>
                        </div>
                    </div>
                </a>
                
                <!-- Quick Buy Button -->
                <a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" class="one-btn-quick-buy">
                    <i class="fa fa-shopping-cart"></i> ACQUISTA
                </a>
                
            </div>
            <?php 
            } ?>
        </div>
        <?php } ?>
    </div>
</div>

<style>
/* Wishlist Page Styles */
.one-wishlist-hero {
    background: linear-gradient(180deg, #1a0000 0%, #0a0a0a 100%);
    padding: 60px 20px;
    text-align: center;
    margin-bottom: 40px;
    border-bottom: 1px solid rgba(255,0,0,0.2);
}

.one-wishlist-title {
    font-size: 2.5rem;
    color: #fff;
    margin: 0 0 15px 0;
    text-transform: uppercase;
    letter-spacing: 3px;
}

.one-wishlist-title i {
    color: #ff0000;
}

.one-wishlist-subtitle {
    font-size: 1.2rem;
    color: rgba(255,255,255,0.7);
    margin: 0 0 20px 0;
}

/* Grid */
.one-items-grid-wishlist {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 25px;
    margin-bottom: 40px;
}

/* Item Card */
.one-item-card-wishlist {
    position: relative;
    background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);
    border: 2px solid rgba(255,255,255,0.1);
    border-radius: 15px;
    padding: 20px;
    transition: all 0.3s;
    overflow: hidden;
    display: flex;
    flex-direction: column;
}

.one-item-card-wishlist:hover {
    transform: translateY(-5px);
    border-color: #ff0000;
    box-shadow: 0 15px 40px rgba(255,0,0,0.3);
}

/* Remove Btn */
.one-remove-btn {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 30px;
    height: 30px;
    background: rgba(0,0,0,0.6);
    border: 1px solid rgba(255,255,255,0.2);
    border-radius: 50%;
    color: #999;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s;
    z-index: 5;
    text-decoration: none;
}
.one-remove-btn:hover {
    background: #ff0000;
    color: #fff;
    border-color: #ff0000;
}

/* Badges */
.item-badge-new, .item-badge-discount {
    position: absolute;
    top: 10px;
    left: 10px;
    padding: 5px 10px;
    border-radius: 5px;
    font-size: 0.7rem;
    font-weight: 800;
    color: #fff;
    z-index: 2;
}
.item-badge-new { background: #ff0000; }
.item-badge-discount { background: #ffd700; color: #000; left: auto; right: 50px; }

/* Image */
.one-item-image-wishlist {
    height: 160px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255,255,255,0.03);
    border-radius: 10px;
    margin-bottom: 15px;
}
.one-item-image-wishlist img {
    max-width: 100px;
    max-height: 100px;
    transition: transform 0.3s;
}
.one-item-card-wishlist:hover .one-item-image-wishlist img {
    transform: scale(1.1);
}

/* Info */
.one-item-info-wishlist { text-align: center; margin-bottom: 15px; flex-grow: 1; }

.one-item-title-wishlist {
    font-size: 1rem;
    color: #fff;
    margin: 0 0 10px 0;
    min-height: 2.4em;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.one-item-price-wishlist {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.price-old-wishlist { text-decoration: line-through; color: #666; font-size: 0.9rem; }
.price-new-wishlist, .price-single-wishlist { color: #ff0000; font-weight: 800; font-size: 1.2rem; }

/* Quick Buy Btn */
.one-btn-quick-buy {
    display: block;
    width: 100%;
    padding: 10px;
    background: rgba(255,255,255,0.1);
    color: #fff;
    text-align: center;
    border-radius: 50px;
    text-decoration: none;
    font-weight: 700;
    font-size: 0.9rem;
    transition: all 0.3s;
    border: 1px solid rgba(255,255,255,0.1);
}
.one-btn-quick-buy:hover {
    background: #27ae60;
    border-color: #27ae60;
    transform: translateY(-2px);
}

/* No Results */
.one-no-results {
    text-align: center;
    padding: 60px 20px;
    background: rgba(255,255,255,0.02);
    border-radius: 20px;
    border: 1px solid rgba(255,255,255,0.05);
}
.one-no-results .icon-wrapper {
    font-size: 4rem;
    color: rgba(255,255,255,0.1);
    margin-bottom: 20px;
}
.one-no-results h3 { color: #fff; margin-bottom: 10px; }
.one-no-results p { color: rgba(255,255,255,0.6); }
.one-btn-back {
    display: inline-block;
    padding: 12px 30px;
    background: #ff0000;
    color: #fff;
    border-radius: 50px;
    text-decoration: none;
    font-weight: 700;
    margin-top: 20px;
}
</style>
