<?php
    // ============================================
    // ONE SERVER - SEARCH PAGE (REDESIGNED)
    // ============================================

    $search_term = isset($_GET['q']) ? trim($_GET['q']) : '';

    if(empty($search_term)) {
        print '<script>window.location.href = "'.$shop_url.'";</script>';
        exit;
    }

    // Paginazione
    $current_page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
    $per_page = 12;

    // Esegui ricerca
    $results = is_search_items_global($search_term, $current_page, $per_page);
    $total_items = is_search_items_count($search_term);
    $total_pages = ceil($total_items / $per_page);

    // Default category image for search
    $icon_path = $shop_url . "images/categories/default.png";
?>

<!-- SEARCH HERO -->
<div class="one-search-hero">
    <div class="one-search-hero-bg"></div>
    
    <div class="one-search-hero-content">
        
        <!-- Icona Grande -->
        <div class="one-search-icon-large">
            <img src="<?php echo $icon_path; ?>" 
                 class="search-icon-img" 
                 alt="Search"
                 onerror="this.style.display='none';">
        </div>

        <h1 class="one-search-title">
            RISULTATI RICERCA
        </h1>
        <p class="one-search-subtitle">
            Hai cercato: <span class="highlight">"<?php echo htmlspecialchars($search_term); ?>"</span>
        </p>
        <div class="one-search-stats">
            <span class="badge badge-danger"><?php echo $total_items; ?> ITEM TROVATI</span>
        </div>
    </div>
</div>

<!-- RESULTS SECTION -->
<div class="one-items-section-search" style="--search-bg: url('<?php echo $icon_path; ?>');">
    <div class="one-items-container">
        
        <?php if($total_items == 0) { ?>
            <div class="one-no-results">
                <div class="icon-wrapper">
                    <i class="fa fa-search-minus"></i>
                </div>
                <h3>Nessun risultato trovato</h3>
                <p>Non abbiamo trovato oggetti che corrispondono alla tua ricerca.</p>
                <div class="suggestions">
                    <p>Suggerimenti:</p>
                    <ul>
                        <li>Controlla di aver scritto correttamente</li>
                        <li>Prova con parole chiave più semplici</li>
                        <li>Cerca per VNUM se conosci l'ID dell'item</li>
                    </ul>
                </div>
                <a href="<?php print $shop_url; ?>" class="one-btn-back">
                    <i class="fa fa-home"></i> Torna alla Home
                </a>
            </div>
        <?php } else { ?>

        <!-- Items Grid -->
        <div class="one-items-grid-search">
            <?php foreach($results as $row) {
                $original_price = $row['coins'];
                $final_price = $row['discount'] > 0 ? $row['coins'] - ($row['coins'] * $row['discount'] / 100) : $row['coins'];
                
                // Wishlist check
                require_once __DIR__ . '/../../include/functions/wishlist.php';
                $account_id = get_account_id();
                $in_wishlist = wishlist_has($account_id, $row['id']);
                $item_name = !$item_name_db ? get_item_name($row['vnum']) : get_item_name_locale_name($row['vnum']);
            ?>
            
            <!-- Item Card (Consistent Style) -->
            <div class="one-item-card-search">
                
                <!-- Badges -->
                <?php if(is_item_new($row['id'])) { ?>
                <div class="item-badge-new">NUOVO</div>
                <?php } ?>
                
                <?php if($row['discount'] > 0) { ?>
                <div class="item-badge-discount">-<?php echo $row['discount']; ?>%</div>
                <?php } ?>
                
                <!-- Wishlist Button -->
                <button class="one-wishlist-btn-search <?php echo $in_wishlist ? 'active' : ''; ?>" 
                        onclick="toggleWishlistSearch(<?php echo $row['id']; ?>, this); return false;">
                    <i class="fa fa-heart"></i>
                </button>
                
                <!-- Link -->
                <a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" class="one-item-link-search">
                    
                    <!-- Image -->
                    <div class="one-item-image-search">
                        <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['vnum']); ?>.png" 
                             alt="<?php echo $item_name; ?>"
                             onerror="this.src='<?php print $shop_url; ?>images/items/default.png'">
                    </div>
                    
                    <!-- Info -->
                    <div class="one-item-info-search">
                        <div class="item-category-tag">
                            <i class="fa fa-tag"></i> <?php echo is_get_category_name($row['category']); ?>
                        </div>
                        
                        <h3 class="one-item-title-search"><?php echo $item_name; ?></h3>
                        
                        <!-- Price -->
                        <div class="one-item-price-search">
                            <img src="<?php print $shop_url; ?>images/md.png" style="width: 20px; height: 20px;">
                            
                            <?php if($row['discount'] > 0) { ?>
                            <span class="price-old-search"><?php echo $row['coins']; ?></span>
                            <span class="price-new-search"><?php echo round($final_price); ?></span>
                            <?php } else { ?>
                            <span class="price-single-search"><?php echo $row['coins']; ?></span>
                            <?php } ?>
                        </div>
                    </div>
                </a>
            </div>
            <?php } ?>
        </div>

        <!-- Pagination -->
        <?php if($total_pages > 1) { ?>
        <div class="one-pagination">
            <?php
                // Prev
                if($current_page > 1) {
                    echo '<a href="?p=search&q='.urlencode($search_term).'&page='.($current_page-1).'" class="page-btn"><i class="fa fa-angle-left"></i></a>';
                }
                
                // Pages
                $start = max(1, $current_page - 2);
                $end = min($total_pages, $current_page + 2);
                
                for($i = $start; $i <= $end; $i++) {
                    $active = $i == $current_page ? 'active' : '';
                    echo '<a href="?p=search&q='.urlencode($search_term).'&page='.$i.'" class="page-btn '.$active.'">'.$i.'</a>';
                }
                
                // Next
                if($current_page < $total_pages) {
                    echo '<a href="?p=search&q='.urlencode($search_term).'&page='.($current_page+1).'" class="page-btn"><i class="fa fa-angle-right"></i></a>';
                }
            ?>
        </div>
        <?php } ?>

        <?php } ?>
    </div>
</div>

<style>
/* Search Page Styles */
.one-search-hero {
    position: relative;
    background: linear-gradient(180deg, #1a0000 0%, #0a0a0a 100%);
    padding: 60px 20px;
    text-align: center;
    margin-bottom: 40px;
    border-bottom: 1px solid rgba(255,0,0,0.2);
    overflow: hidden;
}

.one-search-hero-bg {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 50% 30%, rgba(255,0,0,0.15) 0%, transparent 60%);
    opacity: 0.5;
}

.one-search-hero-content {
    position: relative;
    z-index: 2;
}

.one-search-icon-large {
    width: 150px;
    height: 150px;
    margin: 0 auto 20px auto;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: icon-entrance 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.search-icon-img {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
    filter: drop-shadow(0 0 20px rgba(255,0,0,0.4));
}

.one-search-title {
    font-size: 2.5rem;
    color: #fff;
    margin: 0 0 15px 0;
    text-transform: uppercase;
    letter-spacing: 3px;
    text-shadow: 0 0 20px rgba(255,0,0,0.5);
}

.one-search-subtitle {
    font-size: 1.2rem;
    color: rgba(255,255,255,0.7);
    margin: 0 0 20px 0;
}

.one-search-subtitle .highlight {
    color: #ffd700;
    font-weight: 700;
}

/* Items Section Background */
.one-items-section-search {
    position: relative;
    overflow: hidden;
}

.one-items-section-search::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image: var(--search-bg);
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
    position: relative;
    z-index: 1;
}

/* Grid */
.one-items-grid-search {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 25px;
    margin-bottom: 40px;
}

/* Item Card */
.one-item-card-search {
    position: relative;
    background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);
    border: 2px solid rgba(255,255,255,0.1);
    border-radius: 15px;
    padding: 20px;
    transition: all 0.3s;
    overflow: hidden;
}

/* Category Background in Card */
.one-item-card-search::after {
    content: '';
    position: absolute;
    inset: 0;
    background-image: var(--search-bg);
    background-repeat: no-repeat;
    background-position: center;
    background-size: 120%;
    opacity: 0.15;
    pointer-events: none;
    z-index: 0;
}

.one-item-card-search:hover {
    transform: translateY(-5px);
    border-color: #ff0000;
    box-shadow: 0 15px 40px rgba(255,0,0,0.3);
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

/* Wishlist Btn */
.one-wishlist-btn-search {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 35px;
    height: 35px;
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
}
.one-wishlist-btn-search:hover, .one-wishlist-btn-search.active {
    background: #ff0000;
    color: #fff;
    border-color: #ff0000;
}

/* Image */
.one-item-image-search {
    height: 180px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255,255,255,0.03);
    border-radius: 10px;
    margin-bottom: 15px;
}
.one-item-image-search img {
    max-width: 120px;
    max-height: 120px;
    transition: transform 0.3s;
}
.one-item-card-search:hover .one-item-image-search img {
    transform: scale(1.1);
}

/* Info */
.one-item-info-search { text-align: center; }

.item-category-tag {
    font-size: 0.75rem;
    color: rgba(255,255,255,0.5);
    margin-bottom: 5px;
    text-transform: uppercase;
}

.one-item-title-search {
    font-size: 1rem;
    color: #fff;
    margin: 0 0 10px 0;
    min-height: 2.4em;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.one-item-price-search {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.price-old-search { text-decoration: line-through; color: #666; font-size: 0.9rem; }
.price-new-search, .price-single-search { color: #ff0000; font-weight: 800; font-size: 1.2rem; }

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
.suggestions {
    text-align: left;
    max-width: 400px;
    margin: 30px auto;
    background: rgba(0,0,0,0.3);
    padding: 20px;
    border-radius: 10px;
}
.suggestions ul { color: rgba(255,255,255,0.6); margin-bottom: 0; }
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

/* Pagination */
.one-pagination {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 40px;
}
.page-btn {
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255,255,255,0.05);
    color: #fff;
    border-radius: 50%;
    text-decoration: none;
    transition: all 0.3s;
}
.page-btn:hover, .page-btn.active {
    background: #ff0000;
    color: #fff;
}
</style>

<script>
function toggleWishlistSearch(itemId, button) {
    const isActive = button.classList.contains('active');
    fetch('<?php print $shop_url; ?>api/wishlist_toggle.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ item_id: itemId, action: isActive ? 'remove' : 'add' })
    })
    .then(response => response.json())
    .then(data => { if(data.success) button.classList.toggle('active'); })
    .catch(error => console.error('Error:', error));
}
</script>
