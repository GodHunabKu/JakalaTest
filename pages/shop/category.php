<?php
// ============================================
// ONE SERVER - PAGINA CATEGORIA COMPLETA
// File standalone pronto per copia-incolla
// Con icona grande, breadcrumb, grid items
// ============================================

// Ottieni ID categoria dall'URL
$category_id = isset($_GET['category']) ? (int)$_GET['category'] : 0;

// Ottieni info categoria
$category_info = null;
$categories = is_categories_list();
foreach($categories as $cat) {
    if($cat['id'] == $category_id) {
        $category_info = $cat;
        break;
    }
}

// Se categoria non esiste, redirect home
if(!$category_info) {
    header("Location: " . $shop_url);
    exit;
}

$cat_name = $category_info['name'];
// FIX: Use ID for image path instead of 'img' column
$cat_id = $category_info['id'];
$icon_path = $shop_url . "images/categories/{$cat_id}.png?v=" . time();
?>

<!-- CATEGORY HERO CON ICONA GRANDE -->
<div class="one-category-hero">
    <div class="one-category-hero-bg"></div>
    
    <div class="one-category-hero-content">
        
        <!-- Breadcrumb -->
        <div class="one-breadcrumb">
            <a href="<?php print $shop_url; ?>">
                <i class="fa fa-home"></i> Home
            </a>
            <span class="separator">/</span>
            <span class="current">Categorie</span>
            <span class="separator">/</span>
            <span class="current"><?php echo $cat_name; ?></span>
        </div>
        
        <!-- Icona Grande -->
        <div class="one-category-icon-large">
            <!-- Always try to show image, fallback handled by onerror -->
            <img src="<?php echo $icon_path; ?>" 
                 alt="<?php echo $cat_name; ?>"
                 class="category-icon-img"
                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            <div class="category-icon-fallback" style="display: none;">
                <i class="fa fa-tag"></i>
            </div>
        </div>
        
        <!-- Titolo -->
        <h1 class="one-category-title">
            <?php echo strtoupper($cat_name); ?>
        </h1>
        
        <!-- Descrizione -->
        <p class="one-category-description">
            Esplora tutti gli item della categoria <strong><?php echo $cat_name; ?></strong>
        </p>
        
    </div>
</div>

<!-- ADMIN TOOLBAR (Added for Admin Functionality) -->
<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<div class="container mb-4">
    <div class="card border-info" style="background: rgba(0,0,0,0.8);">
        <div class="card-body text-center">
            <h5 class="text-info mb-3"><i class="fa fa-cogs"></i> Pannello Amministrazione Categoria</h5>
            <a href="<?php print $shop_url.'add/item/'.$category_id.'/'; ?>" class="btn btn-info mr-2">
                <i class="fa fa-plus"></i> <?php print $lang_shop['is_add_items']; ?>
            </a>
            <a href="<?php print $shop_url.'add/bonus/item/'.$category_id.'/'; ?>" class="btn btn-danger">
                <i class="fa fa-star"></i> <?php print $lang_shop['is_add_items'].' ['.$lang_shop['bonus_selection'].']'; ?>
            </a>
        </div>
    </div>
</div>
<?php } ?>

<!-- ITEMS SECTION -->
<div class="one-items-section-category" style="--cat-bg: url('<?php echo $icon_path; ?>');">
    <div class="one-items-container">
        
        <!-- Header con count -->
        <div class="one-items-header">
            <h2>
                <i class="fa fa-list"></i>
                <?php echo strtoupper($cat_name); ?>
            </h2>
        </div>
        
        <!-- Items Grid -->
        <div class="one-items-grid-category">
            
            <?php
            // Ottieni item della categoria
            $category_items = is_items_list($category_id);
            
            if(is_array($category_items) && count($category_items) > 0) {
                require_once __DIR__ . '/../../include/functions/wishlist.php';
                $account_id = get_account_id();
                
                foreach($category_items as $row) {
                    $in_wishlist = wishlist_has($account_id, $row['id']);
                    $item_name = !$item_name_db ? 
                        get_item_name($row['vnum']) : 
                        get_item_name_locale_name($row['vnum']);
                    
                    $final_price = $row['coins'];
                    if($row['discount'] > 0) {
                        $final_price = round($row['coins'] - ($row['coins'] * $row['discount'] / 100));
                    }
                    
                    // Fetch Bonuses for Hover Effect
                    $item_bonuses = get_item_bonuses($row['id']);
                    $proto_bonuses = get_item_proto_bonuses($row['vnum']);
                    $all_bonuses = array_merge($proto_bonuses, $item_bonuses);
                    
                    $item_desc = isset($row['description']) ? trim($row['description']) : '';
                    
                    // Determine if overlay should be shown
                    $show_overlay = !empty($all_bonuses) || !empty($item_desc);
            ?>
            
            <!-- Item Card -->
            <div class="one-item-card-cat">
                
                <!-- HOVER BONUSES/DESC OVERLAY -->
                <?php if($show_overlay) { ?>
                <div class="one-item-bonuses-overlay">
                    <div class="bonuses-content">
                        <?php if(!empty($all_bonuses)) { ?>
                            <div class="bonuses-title"><i class="fa fa-star"></i> BONUS</div>
                            <ul class="bonuses-list">
                                <?php foreach($all_bonuses as $bonus) { ?>
                                    <li>
                                        <span class="bonus-name"><?php echo $bonus['name']; ?></span>
                                        <span class="bonus-val"><?php echo $bonus['formatted_value']; ?></span>
                                    </li>
                                <?php } ?>
                            </ul>
                        <?php } elseif(!empty($item_desc)) { ?>
                            <div class="bonuses-title"><i class="fa fa-info-circle"></i> INFO</div>
                            <div class="item-description-preview">
                                <?php 
                                    // Strip HTML tags to prevent raw HTML display
                                    $clean_desc = strip_tags($item_desc);
                                    echo nl2br(htmlspecialchars($clean_desc)); 
                                ?>
                            </div>
                        <?php } ?>
                    </div>
                </div>
                <?php } ?>
                
                <!-- Badge Nuovo -->
                <?php if(is_item_new($row['id'])) { ?>
                <div class="item-badge-new">NUOVO</div>
                <?php } ?>
                
                <!-- Badge Sconto -->
                <?php if($row['discount'] > 0) { ?>
                <div class="item-badge-discount">-<?php echo $row['discount']; ?>%</div>
                <?php } ?>
                
                <!-- Wishlist Heart -->
                <button class="one-wishlist-btn-cat <?php echo $in_wishlist ? 'active' : ''; ?>" 
                        onclick="toggleWishlistCat(<?php echo $row['id']; ?>, this); return false;">
                    <i class="fa fa-heart"></i>
                </button>
                
                <!-- Item Link -->
                <a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" class="one-item-link-cat">
                    
                    <!-- Image -->
                    <div class="one-item-image-cat">
                        <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['vnum']); ?>.png" 
                             alt="<?php echo $item_name; ?>"
                             onerror="this.src='<?php print $shop_url; ?>images/items/default.png'">
                    </div>
                    
                    <!-- Info -->
                    <div class="one-item-info-cat">
                        <h3 class="one-item-title-cat"><?php echo $item_name; ?></h3>
                        
                        <!-- Price -->
                        <div class="one-item-price-cat">
                            <img src="<?php print $shop_url; ?>images/md.png" style="width: 24px; height: 24px;">
                            
                            <?php if($row['discount'] > 0) { ?>
                            <span class="price-old-cat"><?php echo $row['coins']; ?></span>
                            <span class="price-new-cat"><?php echo $final_price; ?></span>
                            <?php } else { ?>
                            <span class="price-single-cat"><?php echo $row['coins']; ?></span>
                            <?php } ?>
                        </div>
                    </div>
                    
                </a>
                
            </div>
            
            <?php 
                }
            } else {
                // Nessun item nella categoria
            ?>
            
            <div class="one-no-items">
                <i class="fa fa-inbox"></i>
                <h3>Nessun item trovato</h3>
                <p>Non ci sono item in questa categoria al momento.</p>
                <a href="<?php print $shop_url; ?>" class="btn-back-home">
                    <i class="fa fa-home"></i>
                    Torna alla Home
                </a>
            </div>
            
            <?php
            }
            ?>
            
        </div>
        
    </div>
</div>

<!-- CSS INLINE COMPLETO -->
<style>
/* Reset */
.one-category-hero,
.one-category-hero *,
.one-items-section-category,
.one-items-section-category * {
    box-sizing: border-box;
}

/* ========== CATEGORY HERO ========== */
.one-category-hero {
    position: relative;
    padding: 60px 20px 50px 20px;
    background: linear-gradient(180deg, #1a0000 0%, #0a0a0a 100%);
    margin: 0 0 40px 0;
    overflow: hidden;
}

.one-category-hero-bg {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 50% 30%, rgba(255,0,0,0.15) 0%, transparent 60%);
    opacity: 0.5;
}

.one-category-hero-content {
    position: relative;
    z-index: 2;
    max-width: 800px;
    margin: 0 auto;
    text-align: center;
}

/* Breadcrumb */
.one-breadcrumb {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    margin-bottom: 30px;
    font-size: 0.9rem;
    flex-wrap: wrap;
}

.one-breadcrumb a {
    color: rgba(255,255,255,0.6);
    text-decoration: none;
    transition: color 0.3s;
}

.one-breadcrumb a:hover {
    color: #ff0000;
}

.one-breadcrumb .separator {
    color: rgba(255,255,255,0.3);
}

.one-breadcrumb .current {
    color: #ffd700;
    font-weight: 700;
}

/* Icona Grande */
.one-category-icon-large {
    width: 250px;
    height: 250px;
    margin: 0 auto 30px auto;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    animation: icon-entrance 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes icon-entrance {
    0% {
        opacity: 0;
        transform: scale(0.5);
    }
    100% {
        opacity: 1;
        transform: scale(1);
    }
}

.category-icon-img {
    max-width: 250px;
    max-height: 250px;
    object-fit: contain;
    filter: 
        brightness(1.1) 
        drop-shadow(0 0 30px rgba(255,0,0,0.6))
        drop-shadow(0 10px 40px rgba(0,0,0,0.8));
    
    /* Fading Edges Mask */
    -webkit-mask-image: radial-gradient(circle at center, black 40%, transparent 100%);
    mask-image: radial-gradient(circle at center, black 40%, transparent 100%);
}

.category-icon-fallback {
    width: 250px;
    height: 250px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 8rem;
    color: rgba(255,255,255,0.3);
    filter: drop-shadow(0 5px 20px rgba(0,0,0,0.5));
}

/* Titolo */
.one-category-title {
    font-size: 3rem;
    color: #ffffff;
    text-transform: uppercase;
    letter-spacing: 5px;
    margin: 0 0 20px 0;
    font-weight: 900;
    text-shadow: 
        0 0 30px rgba(255,0,0,0.8),
        0 5px 20px rgba(0,0,0,1);
    line-height: 1.2;
    animation: title-entrance 1s cubic-bezier(0.34, 1.56, 0.64, 1) 0.3s backwards;
}

@keyframes title-entrance {
    0% {
        opacity: 0;
        transform: translateY(30px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Descrizione */
.one-category-description {
    font-size: 1.1rem;
    color: rgba(255,255,255,0.7);
    margin: 0;
    line-height: 1.6;
}

.one-category-description strong {
    color: #ffd700;
    font-weight: 800;
}

/* ========== ITEMS SECTION ========== */
.one-items-section-category {
    padding: 20px;
    position: relative;
    overflow: hidden;
}

.one-items-section-category::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image: var(--cat-bg);
    background-repeat: no-repeat;
    background-position: center;
    background-size: contain;
    opacity: 0.15;
    filter: grayscale(100%);
    pointer-events: none;
    z-index: 0;
    transform: scale(1.5);
}

.one-items-container {
    max-width: 1400px;
    margin: 0 auto;
    position: relative;
    z-index: 1;
}

.one-items-header {
    margin-bottom: 30px;
    text-align: center;
}

.one-items-header h2 {
    font-size: 2rem;
    color: #ffd700;
    text-transform: uppercase;
    letter-spacing: 3px;
    margin: 0;
    display: inline-flex;
    align-items: center;
    gap: 15px;
}

.one-items-header h2 i {
    color: #ff0000;
}

/* Items Grid */
.one-items-grid-category {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 25px;
}

/* Item Card */
.one-item-card-cat {
    position: relative;
    background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);
    border: 2px solid rgba(255,255,255,0.1);
    border-radius: 15px;
    padding: 20px;
    transition: all 0.3s;
    overflow: hidden;
}

/* Hover Effect Overlay */
.one-item-card-cat::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(135deg, rgba(255,0,0,0.05) 0%, transparent 100%);
    opacity: 0;
    transition: opacity 0.3s;
    z-index: 1;
}

/* Category Background in Card */
.one-item-card-cat::after {
    content: '';
    position: absolute;
    inset: 0;
    background-image: var(--cat-bg);
    background-repeat: no-repeat;
    background-position: center;
    background-size: 120%;
    opacity: 0.15;
    pointer-events: none;
    z-index: 0;
}

/* BONUSES OVERLAY STYLES */
.one-item-bonuses-overlay {
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.9);
    backdrop-filter: blur(5px);
    z-index: 10;
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    transform: translateY(10px);
    pointer-events: none; /* Allows clicking through to the item link */
    padding: 20px;
    text-align: center;
}

.one-item-card-cat:hover .one-item-bonuses-overlay {
    opacity: 1;
    transform: translateY(0);
}

.bonuses-content {
    width: 100%;
}

.bonuses-title {
    color: #ffd700;
    font-weight: 800;
    text-transform: uppercase;
    margin-bottom: 15px;
    font-size: 0.9rem;
    letter-spacing: 2px;
    border-bottom: 1px solid rgba(255, 215, 0, 0.3);
    padding-bottom: 5px;
    display: inline-block;
}

.bonuses-list {
    list-style: none;
    padding: 0;
    margin: 0;
    text-align: left;
}

.bonuses-list li {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    font-size: 0.85rem;
    color: #fff;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    padding-bottom: 4px;
}

.bonuses-list li:last-child {
    border-bottom: none;
    margin-bottom: 0;
}

.item-description-preview {
    color: rgba(255,255,255,0.9);
    font-size: 0.85rem;
    line-height: 1.4;
    text-align: center;
    max-height: 150px;
    overflow-y: auto;
    overflow-x: hidden; /* Nasconde scrollbar orizzontale */
    word-wrap: break-word; /* Spezza le parole lunghe */
    padding: 0 5px;
}

/* Custom scrollbar for description */
.item-description-preview::-webkit-scrollbar {
    width: 4px;
}
.item-description-preview::-webkit-scrollbar-track {
    background: rgba(255,255,255,0.1);
}
.item-description-preview::-webkit-scrollbar-thumb {
    background: #ffd700;
    border-radius: 2px;
}

.bonus-name {
    color: rgba(255,255,255,0.8);
}

.bonus-val {
    color: #00ff00;
    font-weight: 700;
}

.no-bonus-info {
    color: rgba(255,255,255,0.5);
    font-size: 0.9rem;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
}

.no-bonus-info i {
    font-size: 2rem;
    margin-bottom: 5px;
}

.one-item-card-cat:hover {
    transform: translateY(-5px);
    border-color: #ff0000;
    box-shadow: 0 15px 40px rgba(255,0,0,0.3);
}

.one-item-card-cat:hover::before {
    opacity: 1;
}

/* Badges */
.item-badge-new,
.item-badge-discount {
    position: absolute;
    top: 10px;
    left: 10px;
    padding: 5px 12px;
    border-radius: 5px;
    font-size: 0.75rem;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 1px;
    z-index: 20;
}

.item-badge-new {
    background: linear-gradient(135deg, #ff0000 0%, #8a0000 100%);
    color: #fff;
}

.item-badge-discount {
    background: linear-gradient(135deg, #ffd700 0%, #b8860b 100%);
    color: #000;
    left: auto;
    right: 50px;
}

/* Wishlist Button */
.one-wishlist-btn-cat {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 40px;
    height: 40px;
    background: rgba(0,0,0,0.7);
    border: 2px solid rgba(255,255,255,0.2);
    border-radius: 50%;
    color: #999;
    font-size: 1.1rem;
    cursor: pointer;
    transition: all 0.3s;
    z-index: 20;
    display: flex;
    align-items: center;
    justify-content: center;
}

.one-wishlist-btn-cat:hover {
    background: rgba(255,0,0,0.2);
    color: #ff0000;
    border-color: #ff0000;
}

.one-wishlist-btn-cat.active {
    background: #ff0000;
    color: #fff;
    border-color: #ff0000;
}

.one-wishlist-btn-cat.active i {
    animation: heart-beat 0.5s;
}

@keyframes heart-beat {
    0%, 100% { transform: scale(1); }
    25% { transform: scale(1.3); }
    50% { transform: scale(1); }
    75% { transform: scale(1.2); }
}

/* Item Link */
.one-item-link-cat {
    text-decoration: none;
    display: block;
    position: relative;
    z-index: 2;
}

/* Item Image */
.one-item-image-cat {
    width: 100%;
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255,255,255,0.03);
    border-radius: 10px;
    margin-bottom: 15px;
    overflow: hidden;
}

.one-item-image-cat img {
    max-width: 150px;
    max-height: 150px;
    filter: drop-shadow(0 5px 15px rgba(0,0,0,0.5));
    transition: transform 0.3s;
}

.one-item-card-cat:hover .one-item-image-cat img {
    transform: scale(1.1);
}

/* Item Info */
.one-item-info-cat {
    text-align: center;
}

.one-item-title-cat {
    font-size: 1.1rem;
    color: #ffffff;
    margin: 0 0 15px 0;
    font-weight: 700;
    min-height: 2.4em;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* Item Price */
.one-item-price-cat {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    flex-wrap: wrap;
}

.price-old-cat {
    font-size: 0.9rem;
    color: #666;
    text-decoration: line-through;
}

.price-new-cat,
.price-single-cat {
    font-size: 1.5rem;
    font-weight: 900;
    color: #ff0000;
}

/* No Items */
.one-no-items {
    grid-column: 1 / -1;
    text-align: center;
    padding: 80px 20px;
}

.one-no-items i {
    font-size: 5rem;
    color: rgba(255,255,255,0.2);
    margin-bottom: 20px;
}

.one-no-items h3 {
    font-size: 2rem;
    color: #ffffff;
    margin: 0 0 15px 0;
}

.one-no-items p {
    font-size: 1.1rem;
    color: rgba(255,255,255,0.6);
    margin: 0 0 30px 0;
}

.btn-back-home {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 15px 40px;
    background: linear-gradient(135deg, #ff0000 0%, #8a0000 100%);
    color: #fff;
    text-decoration: none;
    border-radius: 50px;
    font-size: 1rem;
    font-weight: 800;
    text-transform: uppercase;
    transition: all 0.3s;
}

.btn-back-home:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 30px rgba(255,0,0,0.5);
}

/* ========== RESPONSIVE ========== */
@media (max-width: 1200px) {
    .one-items-grid-category {
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    }
}

@media (max-width: 768px) {
    .one-category-hero {
        padding: 40px 20px 30px 20px;
    }
    
    .one-category-icon-large {
        width: 100px;
        height: 100px;
    }
    
    .category-icon-img {
        max-width: 100px;
        max-height: 100px;
    }
    
    .category-icon-fallback {
        width: 100px;
        height: 100px;
        font-size: 3.5rem;
    }
    
    .one-category-title {
        font-size: 2rem;
        letter-spacing: 3px;
    }
    
    .one-category-description {
        font-size: 1rem;
    }
    
    .one-items-header h2 {
        font-size: 1.5rem;
    }
    
    .one-items-grid-category {
        grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
        gap: 15px;
    }
}

@media (max-width: 480px) {
    .one-items-grid-category {
        grid-template-columns: 1fr;
    }
    
    .one-category-title {
        font-size: 1.5rem;
    }
}
</style>

<!-- JAVASCRIPT WISHLIST -->
<script>
function toggleWishlistCat(itemId, button) {
    const isActive = button.classList.contains('active');
    
    fetch('<?php print $shop_url; ?>api/wishlist_toggle.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            item_id: itemId,
            action: isActive ? 'remove' : 'add'
        })
    })
    .then(response => response.json())
    .then(data => {
        if(data.success) {
            button.classList.toggle('active');
        }
    })
    .catch(error => console.error('Wishlist error:', error));
}
</script>