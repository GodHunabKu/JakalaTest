<?php
// ============================================
// ONE SERVER - HOMEPAGE "BENTO" REDESIGN
// ============================================
?>

<!-- HERO SECTION (Immersive) -->
<div class="one-hero-bento">
    <div class="one-hero-bg-anim"></div>
    <div class="one-hero-content">
        <span class="hero-tag">METIN2 ITEM SHOP</span>
        <h1 class="one-hero-title">
            DOMINA IL <span class="text-gradient">SERVER</span>
        </h1>
        <p class="one-hero-subtitle">
            Scopri gli item più rari, i costumi più esclusivi e i potenziamenti definitivi.
        </p>
        <div class="one-hero-buttons">
            <a href="#shop-categories" class="one-btn-primary">
                <i class="fa fa-th-large"></i> ESPLORA CATEGORIE
            </a>
            <a href="<?php print $shop_url; ?>donations" class="one-btn-secondary">
                <i class="fa fa-coins"></i> RICARICA MONETE
            </a>
        </div>
    </div>
</div>

<!-- BENTO GRID CATEGORIES -->
<div id="shop-categories" class="one-section-container">
    <div class="one-section-header">
        <h2><i class="fa fa-layer-group"></i> COLLEZIONI IN EVIDENZA</h2>
        <p>Scegli la categoria e inizia a potenziare il tuo personaggio</p>
    </div>

    <div class="one-bento-grid">
        <?php
        $categories = is_categories_list();
        $count = 0;
        
        foreach($categories as $cat) {
            $count++;
            $icon_path = "images/categories/" . $cat['id'] . ".png";
            $has_icon = file_exists(__DIR__ . '/../../' . $icon_path);
            
            // Determine class based on index for Bento Layout
            $bento_class = "bento-item";
            if($count == 1) $bento_class .= " bento-large"; // First item big
            elseif($count == 2) $bento_class .= " bento-wide"; // Second item wide
            elseif($count == 6) $bento_class .= " bento-tall"; // Sixth item tall (optional)
        ?>
        
        <a href="<?php print $shop_url.'category/'.$cat['id'].'/'; ?>" class="<?php echo $bento_class; ?>">
            <div class="bento-bg" style="background-image: url('<?php echo $shop_url . $icon_path; ?>');"></div>
            <div class="bento-content">
                <div class="bento-icon">
                    <?php if($has_icon) { ?>
                        <img src="<?php print $shop_url . $icon_path; ?>?v=<?php echo time(); ?>" 
                             alt="<?php echo $cat['name']; ?>"
                             onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                        <i class="fa fa-tag fallback-icon" style="display: none;"></i>
                    <?php } else { ?>
                        <i class="fa fa-tag"></i>
                    <?php } ?>
                </div>
                <div class="bento-info">
                    <h3><?php echo strtoupper($cat['name']); ?></h3>
                    <span>Esplora &rarr;</span>
                </div>
            </div>
        </a>
        
        <?php } ?>
    </div>
</div>

<!-- NEW ARRIVALS SECTION -->
<div class="one-section-container">
    <div class="one-section-header">
        <h2><i class="fa fa-bolt" style="color: #ffd700;"></i> NUOVI ARRIVI</h2>
        <a href="<?php print $shop_url; ?>search?q=new" class="view-all-link">Vedi tutti <i class="fa fa-arrow-right"></i></a>
    </div>
    
    <div class="one-items-grid">
        <?php
        try {
            $newest_items = is_get_newest_items(8); // Limit to 8 for cleaner look
            
            if(is_array($newest_items) && count($newest_items) > 0) {
                require_once __DIR__ . '/../../include/functions/wishlist.php';
                $account_id = get_account_id();
                
                foreach($newest_items as $row) {
                    $in_wishlist = wishlist_has($account_id, $row['id']);
                    $item_name = !$item_name_db ? get_item_name($row['vnum']) : get_item_name_locale_name($row['vnum']);
                    $final_price = $row['discount'] > 0 ? round($row['coins'] - ($row['coins'] * $row['discount'] / 100)) : $row['coins'];
        ?>
        
        <div class="one-item-card-premium">
            <div class="card-glow"></div>
            
            <?php if($row['discount'] > 0) { ?>
                <div class="badge-discount">-<?php echo $row['discount']; ?>%</div>
            <?php } ?>
            
            <div class="badge-new">NEW</div>

            <button class="one-wishlist-btn <?php echo $in_wishlist ? 'active' : ''; ?>" 
                    onclick="toggleWishlist(<?php echo $row['id']; ?>, this); return false;">
                <i class="fa fa-heart"></i>
            </button>
            
            <a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" class="one-item-link">
                <div class="one-item-image-premium">
                    <div class="img-glow"></div>
                    <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['vnum']); ?>.png" 
                         alt="<?php echo $item_name; ?>"
                         onerror="this.src='<?php print $shop_url; ?>images/items/default.png'">
                </div>
                <div class="one-item-info-premium">
                    <h3 class="one-item-title"><?php echo $item_name; ?></h3>
                    <div class="one-item-meta">
                        <div class="one-item-price">
                            <img src="<?php print $shop_url; ?>images/md.png" width="18">
                            <?php if($row['discount'] > 0) { ?>
                                <span class="price-old"><?php echo $row['coins']; ?></span>
                                <span class="price-new"><?php echo $final_price; ?></span>
                            <?php } else { ?>
                                <span class="price-single"><?php echo $row['coins']; ?></span>
                            <?php } ?>
                        </div>
                        <span class="btn-view"><i class="fa fa-eye"></i></span>
                    </div>
                </div>
            </a>
        </div>
        
        <?php 
                }
            }
        } catch (Exception $e) {}
        ?>
    </div>
</div>

<!-- PROMO BANNER (Modern) -->
<div class="one-promo-modern">
    <div class="promo-content">
        <h2>OFFERTE SPECIALI</h2>
        <p>Non perdere gli sconti a tempo limitato su costumi e cavalcature.</p>
    </div>
    <div class="promo-action">
        <a href="#" class="btn-promo">SCOPRI ORA</a>
    </div>
</div>

<style>
/* GLOBAL LAYOUT */
.one-section-container {
    max-width: 1400px;
    margin: 0 auto 60px auto;
    padding: 0 20px;
}

.one-section-header {
    margin-bottom: 30px;
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    padding-bottom: 15px;
}

.one-section-header h2 {
    font-size: 1.8rem;
    color: #fff;
    margin: 0;
    font-weight: 800;
    letter-spacing: 1px;
}

.one-section-header p {
    color: rgba(255,255,255,0.5);
    margin: 5px 0 0 0;
    font-size: 0.9rem;
}

.view-all-link {
    color: #ffd700;
    text-decoration: none;
    font-weight: 700;
    font-size: 0.9rem;
    transition: 0.3s;
}
.view-all-link:hover { color: #fff; }

/* HERO BENTO STYLE */
.one-hero-bento {
    position: relative;
    height: 500px;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    background: #0a0a0a;
    overflow: hidden;
    margin-bottom: 60px;
    border-bottom: 1px solid rgba(255,255,255,0.05);
}

.one-hero-bg-anim {
    position: absolute;
    inset: 0;
    background: 
        radial-gradient(circle at 20% 30%, rgba(255,0,0,0.15) 0%, transparent 50%),
        radial-gradient(circle at 80% 70%, rgba(255,215,0,0.1) 0%, transparent 50%);
    filter: blur(60px);
    animation: pulse-bg 10s infinite alternate;
}

@keyframes pulse-bg {
    0% { transform: scale(1); opacity: 0.5; }
    100% { transform: scale(1.2); opacity: 0.8; }
}

.one-hero-content {
    position: relative;
    z-index: 2;
    max-width: 800px;
    padding: 20px;
}

.hero-tag {
    display: inline-block;
    background: rgba(255,255,255,0.1);
    color: #ffd700;
    padding: 5px 15px;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 800;
    margin-bottom: 20px;
    backdrop-filter: blur(5px);
    border: 1px solid rgba(255,215,0,0.3);
}

.one-hero-title {
    font-size: 4rem;
    font-weight: 900;
    color: #fff;
    line-height: 1.1;
    margin-bottom: 20px;
    letter-spacing: -1px;
}

.text-gradient {
    background: linear-gradient(135deg, #ff0000 0%, #ff6b6b 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.one-hero-subtitle {
    font-size: 1.2rem;
    color: rgba(255,255,255,0.7);
    margin-bottom: 40px;
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
}

.one-hero-buttons {
    display: flex;
    gap: 15px;
    justify-content: center;
}

.one-btn-primary {
    background: #ff0000;
    color: #fff;
    padding: 15px 35px;
    border-radius: 8px;
    font-weight: 800;
    text-decoration: none;
    transition: 0.3s;
    box-shadow: 0 10px 25px rgba(255,0,0,0.3);
}
.one-btn-primary:hover { transform: translateY(-3px); box-shadow: 0 15px 35px rgba(255,0,0,0.5); }

.one-btn-secondary {
    background: rgba(255,255,255,0.05);
    color: #fff;
    padding: 15px 35px;
    border-radius: 8px;
    font-weight: 800;
    text-decoration: none;
    transition: 0.3s;
    border: 1px solid rgba(255,255,255,0.1);
}
.one-btn-secondary:hover { background: rgba(255,255,255,0.1); border-color: #fff; }

/* BENTO GRID SYSTEM */
.one-bento-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    grid-auto-rows: 200px;
    gap: 20px;
}

.bento-item {
    position: relative;
    background: #151515;
    border-radius: 20px;
    overflow: hidden;
    text-decoration: none;
    transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
    border: 1px solid rgba(255,255,255,0.05);
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    padding: 20px;
}

/* Grid Spans */
.bento-large { grid-column: span 2; grid-row: span 2; }
.bento-wide { grid-column: span 2; }
.bento-tall { grid-row: span 2; }

.bento-bg {
    position: absolute;
    inset: 0;
    background-size: cover;
    background-position: center;
    opacity: 0.1;
    transition: 0.5s;
    filter: grayscale(100%);
}

.bento-item:hover .bento-bg {
    opacity: 0.2;
    transform: scale(1.1);
    filter: grayscale(0%);
}

.bento-content {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: center;
    gap: 15px;
}

.bento-large .bento-content {
    flex-direction: column;
    align-items: flex-start;
    gap: 20px;
}

.bento-icon {
    width: 50px;
    height: 50px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255,255,255,0.05);
    border-radius: 12px;
    font-size: 1.5rem;
    color: #fff;
    backdrop-filter: blur(5px);
}

.bento-icon img {
    width: 30px;
    height: 30px;
    object-fit: contain;
}

.bento-large .bento-icon {
    width: 80px;
    height: 80px;
}
.bento-large .bento-icon img {
    width: 50px;
    height: 50px;
}

.bento-info h3 {
    margin: 0;
    color: #fff;
    font-size: 1.1rem;
    font-weight: 800;
    letter-spacing: 0.5px;
}

.bento-large .bento-info h3 { font-size: 2rem; }

.bento-info span {
    font-size: 0.8rem;
    color: #ffd700;
    opacity: 0;
    transform: translateX(-10px);
    transition: 0.3s;
    display: inline-block;
}

.bento-item:hover .bento-info span {
    opacity: 1;
    transform: translateX(0);
}

.bento-item:hover {
    border-color: rgba(255,0,0,0.5);
    box-shadow: 0 10px 30px rgba(0,0,0,0.5);
    transform: translateY(-5px);
}

/* ITEM CARDS (Premium) */
.one-item-card-premium {
    position: relative;
    /* Dark gradient overlay to make text readable */
    background: linear-gradient(180deg, rgba(20,20,20,0.3) 0%, #0a0a0a 100%), 
                url('<?php echo $shop_url; ?>assets/img/nuoviarrivi.png') no-repeat center center;
    background-size: cover;
    border-radius: 20px;
    padding: 20px;
    transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
    border: 1px solid rgba(255,255,255,0.1);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    box-shadow: 0 10px 30px rgba(0,0,0,0.4);
}

.one-item-card-premium:hover {
    transform: translateY(-10px);
    border-color: rgba(255, 255, 255, 0.3);
    box-shadow: 0 20px 50px rgba(0,0,0,0.6), 0 0 30px rgba(255,0,0,0.1);
}

.one-item-card-premium::before {
    content: '';
    position: absolute;
    inset: 0;
    background: rgba(0,0,0,0.2);
    transition: 0.4s;
    z-index: 0;
}

.one-item-card-premium:hover::before {
    background: rgba(0,0,0,0);
}

.card-glow {
    position: absolute;
    top: 0; left: 0; right: 0; height: 100px;
    background: linear-gradient(180deg, rgba(255,0,0,0.1) 0%, transparent 100%);
    opacity: 0;
    transition: 0.4s;
}
.one-item-card-premium:hover .card-glow { opacity: 1; }

.one-item-image-premium {
    height: 180px;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    margin-bottom: 20px;
    z-index: 2;
}

.one-item-image-premium img {
    max-width: 120px;
    max-height: 120px;
    transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    filter: drop-shadow(0 10px 20px rgba(0,0,0,0.5));
}

.one-item-card-premium:hover .one-item-image-premium img {
    transform: scale(1.2) translateY(-10px);
    filter: drop-shadow(0 20px 30px rgba(255,0,0,0.3));
}

.img-glow {
    position: absolute;
    width: 100px;
    height: 100px;
    background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
    top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    opacity: 0;
    transition: 0.4s;
}
.one-item-card-premium:hover .img-glow { opacity: 1; width: 150px; height: 150px; }

.one-item-info-premium {
    text-align: center;
    z-index: 2;
}

.one-item-title {
    font-size: 1.1rem;
    font-weight: 700;
    color: #fff;
    margin-bottom: 15px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.one-item-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: rgba(0,0,0,0.6);
    backdrop-filter: blur(10px);
    padding: 10px 15px;
    border-radius: 50px;
    border: 1px solid rgba(255,255,255,0.1);
    position: relative;
    z-index: 2;
}

.btn-view {
    width: 30px;
    height: 30px;
    background: #fff;
    color: #000;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.8rem;
    opacity: 0;
    transform: translateX(-10px);
    transition: 0.3s;
}

.one-item-card-premium:hover .btn-view {
    opacity: 1;
    transform: translateX(0);
}

.badge-new {
    position: absolute;
    top: 15px;
    left: 15px;
    background: linear-gradient(45deg, #ff0000, #ff4d4d);
    color: white;
    font-size: 0.7rem;
    font-weight: 800;
    padding: 4px 10px;
    border-radius: 4px;
    box-shadow: 0 5px 15px rgba(255,0,0,0.4);
    z-index: 5;
}

.badge-discount {
    position: absolute;
    top: 15px;
    right: 50px; /* Adjusted to not overlap wishlist */
    background: #ffd700;
    color: #000;
    font-weight: 800;
    font-size: 0.7rem;
    padding: 3px 8px;
    border-radius: 4px;
    z-index: 5;
}

.one-item-price {
    display: flex;
    align-items: center;
    gap: 8px;
}

.price-single, .price-new { color: #ff0000; font-weight: 800; font-size: 1.1rem; }
.price-old { color: #666; text-decoration: line-through; font-size: 0.8rem; }

/* PROMO MODERN */
.one-promo-modern {
    background: linear-gradient(90deg, #ff0000 0%, #8a0000 100%);
    border-radius: 20px;
    padding: 40px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: 0 20px 40px 20px;
    position: relative;
    overflow: hidden;
}

.one-promo-modern::after {
    content: '';
    position: absolute;
    top: 0; right: 0; bottom: 0; width: 50%;
    background: url('<?php echo $shop_url; ?>assets/img/pattern.png'); /* Optional pattern */
    opacity: 0.1;
    mask-image: linear-gradient(to left, black, transparent);
}

.promo-content h2 { margin: 0 0 10px 0; color: #fff; font-size: 2rem; font-weight: 900; }
.promo-content p { margin: 0; color: rgba(255,255,255,0.9); }

.btn-promo {
    background: #fff;
    color: #ff0000;
    padding: 15px 30px;
    border-radius: 50px;
    font-weight: 800;
    text-decoration: none;
    box-shadow: 0 10px 20px rgba(0,0,0,0.2);
    transition: 0.3s;
    display: inline-block;
}
.btn-promo:hover { transform: scale(1.05); box-shadow: 0 15px 30px rgba(0,0,0,0.3); }

/* RESPONSIVE */
@media (max-width: 992px) {
    .one-bento-grid { grid-template-columns: repeat(2, 1fr); }
    .bento-large { grid-column: span 2; }
    .bento-wide { grid-column: span 2; }
    .one-promo-modern { flex-direction: column; text-align: center; gap: 20px; }
}

@media (max-width: 576px) {
    .one-hero-title { font-size: 2.5rem; }
    .one-bento-grid { grid-template-columns: 1fr; }
    .bento-large, .bento-wide { grid-column: span 1; }
    .one-items-grid { grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); }
}
</style>

<script>
function toggleWishlist(itemId, button) {
    const isActive = button.classList.contains('active');
    fetch('<?php print $shop_url; ?>api/wishlist_toggle.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ item_id: itemId, action: isActive ? 'remove' : 'add' })
    })
    .then(response => response.json())
    .then(data => { if(data.success) button.classList.toggle('active'); })
    .catch(error => console.error('Wishlist error:', error));
}
</script>