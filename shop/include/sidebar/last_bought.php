<!-- Widget: Ultimi Acquisti -->
<div class="widget-card">
    <div class="widget-header">
        <i class="fas fa-history"></i>
        <h3><?php print $lang_shop['last_bought']; ?></h3>
    </div>
    <div class="widget-body">
        <?php
        // Recuperiamo i dati una sola volta per pulizia
        $last_bought_items = last_bought();

        // Controlliamo se ci sono acquisti da mostrare
        if (empty($last_bought_items)) {
            echo '<div class="widget-empty-state">
                    <i class="fas fa-shopping-cart"></i>
                    <p>Nessun acquisto recente.</p>
                  </div>';
        } else {
        ?>
            <ul class="widget-list">
                <?php foreach ($last_bought_items as $last) { ?>
                    <li>
                        <a href="<?php print $shop_url.'item/'.$last['id'].'/'; ?>" class="widget-list-item">
                            <!-- Icona dell'oggetto -->
                            <div class="item-icon">
                                <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($last['vnum']); ?>.png" alt="">
                            </div>
                            
                            <!-- Informazioni sull'oggetto -->
                            <div class="item-info">
                                <span class="item-name">
                                    <?php 
                                        if (!$item_name_db) {
                                            print get_item_name($last['vnum']); 
                                        } else {
                                            print get_item_name_locale_name($last['vnum']); 
                                        }
                                    ?>
                                </span>
                                <div class="item-price">
                                    <img src="<?php print $shop_url; ?>images/<?php print ($last['pay_type'] == 1) ? 'md3' : 'jd'; ?>.png" alt="Currency">
                                    <span><?php print number_format($last['coins']); ?></span>
                                </div>
                            </div>
                        </a>
                    </li>
                <?php } ?>
            </ul>
        <?php } ?>
    </div>
</div>