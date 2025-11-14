<div class="admin-content-wrapper">
    <!-- Page Header -->
    <div class="admin-page-header">
        <div class="header-left">
            <a href="<?php print $shop_url.'category/'.$get_category.'/'; ?>" class="btn-back">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Items</span>
            </a>
        </div>
        <div class="header-center">
            <i class="fas fa-plus-circle"></i>
            <h1>Add New Item</h1>
            <p>Category: <strong><?php print is_get_category_name($get_category); ?></strong></p>
        </div>
    </div>

    <?php
    // LOGICA PHP ESISTENTE PER GESTIRE IL SUBMIT DEL MODULO
    $added = false;
    
    if(isset($_POST['add']))
    {
        $time_settings = get_settings_time(1);
        $time2_settings = get_settings_time(2);
        $absorption_settings = get_settings_time(3);
        
        $time = $time2 = 0;
        if($_POST['count']<=0)
            $_POST['count']=1;
        
        for($i=0;$i<=6;$i++) 
            if($_POST['attrtype'.$i]==0)
                $_POST['attrvalue'.$i]=0;
            
        if(check_item_column("applytype0"))
            for($i=0;$i<=7;$i++) 
                if($_POST['applytype'.$i]==0)
                    $_POST['applyvalue'.$i]=0;
                
        $socket0 = !empty($_POST['socket0']) ? $_POST['socket0'] : 0;
        $socket1 = !empty($_POST['socket1']) ? $_POST['socket1'] : 0;
        $socket2 = !empty($_POST['socket2']) ? $_POST['socket2'] : 0;
            
        $item_unique = 0;
                    
        $expire = 0;
        if(!empty($_POST['promotion_months']) || !empty($_POST['promotion_days']) || !empty($_POST['promotion_hours']) || !empty($_POST['promotion_minutes']))
            $expire = strtotime("now +".intval($_POST['promotion_months'])." month +".intval($_POST['promotion_days'])." day +".intval($_POST['promotion_hours'])." hours +".intval($_POST['promotion_minutes'])." minute - 1 hour UTC");
        
        if(!empty($_POST['time_months']) || !empty($_POST['time_days']) || !empty($_POST['time_hours']) || !empty($_POST['time_minutes']))
        {
            $time = intval($_POST['time_minutes']) + (intval($_POST['time_hours'])*60) + (intval($_POST['time_days'])*24*60) + (intval($_POST['time_months'])*30*24*60);
            $item_unique = 1;
        }
        
        if(!empty($_POST['time2_months']) || !empty($_POST['time2_days']) || !empty($_POST['time2_hours']) || !empty($_POST['time2_minutes']))
        {
            $time2 = intval($_POST['time2_minutes']) + (intval($_POST['time2_hours'])*60) + (intval($_POST['time2_days'])*24*60) + (intval($_POST['time2_months'])*30*24*60);
            $item_unique = 2;
        }
            
        if(check_item_column("applytype0") && check_item_sash($_POST['vnum']) && $time2==0)
        {
            $added = true;
            $stmt = $database->runQuerySqlite('INSERT INTO item_shop_items (category, description, pay_type, coins, count, vnum, socket'.$absorption_settings.', socket'.$time_settings.', attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4, applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7, expire, item_unique) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
            $stmt->execute(array($get_category, $_POST['description'], $_POST['method_pay'], $_POST['coins'], $_POST['count'], $_POST['vnum'], $_POST['absorption'], $time,
                                $_POST['attrtype0'], $_POST['attrvalue0'], $_POST['attrtype1'], $_POST['attrvalue1'], $_POST['attrtype2'], $_POST['attrvalue2'], 
                                $_POST['attrtype3'], $_POST['attrvalue3'], $_POST['attrtype4'], $_POST['attrvalue4'], $_POST['attrtype5'], $_POST['attrvalue5'], 
                                $_POST['attrtype6'], $_POST['attrvalue6'], 
                                $_POST['applytype0'], $_POST['applyvalue0'], $_POST['applytype1'], $_POST['applyvalue1'], $_POST['applytype2'], $_POST['applyvalue2'], 
                                $_POST['applytype3'], $_POST['applyvalue3'], $_POST['applytype4'], $_POST['applyvalue4'], $_POST['applytype5'], $_POST['applyvalue5'], 
                                $_POST['applytype6'], $_POST['applyvalue6'], $_POST['applytype7'], $_POST['applyvalue7'], $expire, $item_unique));
        }
        else if(check_item_column("applytype0") && check_item_sash($_POST['vnum']) && $time2)
        {
            $added = true;
            $type = 1;
            $stmt = $database->runQuerySqlite('INSERT INTO item_shop_items (category, description, pay_type, coins, count, vnum, socket'.$absorption_settings.', socket'.$time2_settings.', attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4, applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7, type, expire, item_unique) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
            $stmt->execute(array($get_category, $_POST['description'], $_POST['method_pay'], $_POST['coins'], $_POST['count'], $_POST['vnum'], $_POST['absorption'], $time2,
                                $_POST['attrtype0'], $_POST['attrvalue0'], $_POST['attrtype1'], $_POST['attrvalue1'], $_POST['attrtype2'], $_POST['attrvalue2'], 
                                $_POST['attrtype3'], $_POST['attrvalue3'], $_POST['attrtype4'], $_POST['attrvalue4'], $_POST['attrtype5'], $_POST['attrvalue5'], 
                                $_POST['attrtype6'], $_POST['attrvalue6'], 
                                $_POST['applytype0'], $_POST['applyvalue0'], $_POST['applytype1'], $_POST['applyvalue1'], $_POST['applytype2'], $_POST['applyvalue2'], 
                                $_POST['applytype3'], $_POST['applyvalue3'], $_POST['applytype4'], $_POST['applyvalue4'], $_POST['applytype5'], $_POST['applyvalue5'], 
                                $_POST['applytype6'], $_POST['applyvalue6'], $_POST['applytype7'], $_POST['applyvalue7'], $type, $expire, $item_unique));
        }
        else if(check_item_column("applytype0") && ($socket0 || $socket1 || $socket2))
        {
            $added = true;
            $type = 2;
            $stmt = $database->runQuerySqlite('INSERT INTO item_shop_items (category, description, pay_type, coins, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4, applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7, type, expire, item_unique) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
            $stmt->execute(array($get_category, $_POST['description'], $_POST['method_pay'], $_POST['coins'], $_POST['count'], $_POST['vnum'], $socket0, $socket1, $socket2,
                                $_POST['attrtype0'], $_POST['attrvalue0'], $_POST['attrtype1'], $_POST['attrvalue1'], $_POST['attrtype2'], $_POST['attrvalue2'], 
                                $_POST['attrtype3'], $_POST['attrvalue3'], $_POST['attrtype4'], $_POST['attrvalue4'], $_POST['attrtype5'], $_POST['attrvalue5'], 
                                $_POST['attrtype6'], $_POST['attrvalue6'], 
                                $_POST['applytype0'], $_POST['applyvalue0'], $_POST['applytype1'], $_POST['applyvalue1'], $_POST['applytype2'], $_POST['applyvalue2'], 
                                $_POST['applytype3'], $_POST['applyvalue3'], $_POST['applytype4'], $_POST['applyvalue4'], $_POST['applytype5'], $_POST['applyvalue5'], 
                                $_POST['applytype6'], $_POST['applyvalue6'], $_POST['applytype7'], $_POST['applyvalue7'], $type, $expire, $item_unique));
        }
        else if($socket0 || $socket1 || $socket2)
        {
            $added = true;
            $stmt = $database->runQuerySqlite('INSERT INTO item_shop_items (category, description, pay_type, coins, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, expire, item_unique) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
            $stmt->execute(array($get_category, $_POST['description'], $_POST['method_pay'], $_POST['coins'], $_POST['count'], $_POST['vnum'], $socket0, $socket1, $socket2,
                                $_POST['attrtype0'], $_POST['attrvalue0'], $_POST['attrtype1'], $_POST['attrvalue1'], $_POST['attrtype2'], $_POST['attrvalue2'], 
                                $_POST['attrtype3'], $_POST['attrvalue3'], $_POST['attrtype4'], $_POST['attrvalue4'], $_POST['attrtype5'], $_POST['attrvalue5'], 
                                $_POST['attrtype6'], $_POST['attrvalue6'], $expire, $item_unique));
        }
        else if($time2==0 && $time > 0)
        {
            $added = true;
            $stmt = $database->runQuerySqlite('INSERT INTO item_shop_items (category, description, pay_type, coins, count, vnum, socket'.$time_settings.', attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, expire, item_unique) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
            $stmt->execute(array($get_category, $_POST['description'], $_POST['method_pay'], $_POST['coins'], $_POST['count'], $_POST['vnum'], $time,
                                $_POST['attrtype0'], $_POST['attrvalue0'], $_POST['attrtype1'], $_POST['attrvalue1'], $_POST['attrtype2'], $_POST['attrvalue2'], 
                                $_POST['attrtype3'], $_POST['attrvalue3'], $_POST['attrtype4'], $_POST['attrvalue4'], $_POST['attrtype5'], $_POST['attrvalue5'], 
                                $_POST['attrtype6'], $_POST['attrvalue6'], $expire, $item_unique));
        } else if ($time2 > 0) {
            $added = true;
            $stmt = $database->runQuerySqlite('INSERT INTO item_shop_items (category, description, pay_type, coins, count, vnum, socket'.$time2_settings.', attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, expire, item_unique) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
            $stmt->execute(array($get_category, $_POST['description'], $_POST['method_pay'], $_POST['coins'], $_POST['count'], $_POST['vnum'], $time2,
                                $_POST['attrtype0'], $_POST['attrvalue0'], $_POST['attrtype1'], $_POST['attrvalue1'], $_POST['attrtype2'], $_POST['attrvalue2'], 
                                $_POST['attrtype3'], $_POST['attrvalue3'], $_POST['attrtype4'], $_POST['attrvalue4'], $_POST['attrtype5'], $_POST['attrvalue5'], 
                                $_POST['attrtype6'], $_POST['attrvalue6'], $expire, $item_unique));
        } else {
             $added = true;
             $stmt = $database->runQuerySqlite('INSERT INTO item_shop_items (category, description, pay_type, coins, count, vnum, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, expire, item_unique) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
             $stmt->execute(array($get_category, $_POST['description'], $_POST['method_pay'], $_POST['coins'], $_POST['count'], $_POST['vnum'],
                                 $_POST['attrtype0'], $_POST['attrvalue0'], $_POST['attrtype1'], $_POST['attrvalue1'], $_POST['attrtype2'], $_POST['attrvalue2'],
                                 $_POST['attrtype3'], $_POST['attrvalue3'], $_POST['attrtype4'], $_POST['attrvalue4'], $_POST['attrtype5'], $_POST['attrvalue5'],
                                 $_POST['attrtype6'], $_POST['attrvalue6'], $expire, $item_unique));
        }
    }
    
    if($added) {
        print '<div class="alert alert-success" style="margin-bottom: 20px;">'.$lang_shop['item_added'].'</div>';
    }
    ?>

    <!-- Main Form -->
    <form action="" method="post" class="admin-form-modern">
        <div class="form-grid-single">
            <div class="form-section">
                <div class="section-header">
                    <i class="fas fa-box"></i>
                    <h3>Item Details</h3>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label>
                            <i class="fas fa-hashtag"></i>
                            Item VNUM *
                        </label>
                        <input type="number" class="form-input" name="vnum" id="item-vnum" required placeholder="e.g., 19">
                        <small class="form-hint">Item unique identifier</small>
                    </div>

                    <div class="form-group">
                        <label>
                            <i class="fas fa-eye"></i>
                            Item Preview
                        </label>
                        <div id="item-preview" class="item-preview-box" style="display: none;">
                            <img id="item-icon-preview" src="<?php print $shop_url; ?>images/items/0.png" alt="Icon">
                            <span id="item-name-preview">Nome Oggetto</span>
                        </div>
                         <div id="item-preview-error" class="item-preview-error" style="display: none;">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>Item not found.</span>
                        </div>
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label>
                            <i class="fas fa-layer-group"></i>
                            Quantity *
                        </label>
                        <input type="number" class="form-input" name="count" value="1" required min="1">
                        <small class="form-hint">Items per purchase</small>
                    </div>
                    <div class="form-group">
                        <label>
                            <i class="fas fa-coins"></i>
                            Price *
                        </label>
                        <input type="number" class="form-input" name="coins" required placeholder="500">
                    </div>
                </div>

                <div class="form-row-1">
                     <div class="form-group">
                        <label>
                            <i class="fas fa-money-bill-wave"></i>
                            Currency *
                        </label>
                        <select class="form-select" name="method_pay">
                            <option value="1">?? MD Coins</option>
                            <option value="2">?? JD Premium</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-align-left"></i>
                        Description
                    </label>
                    <textarea class="form-textarea" name="description" rows="4" placeholder="Enter item description (optional)..."></textarea>
                </div>

                <!-- Bonuses Section -->
                <div class="collapsible-section">
                    <button type="button" class="collapsible-header" onclick="toggleSection(this)">
                        <i class="fas fa-magic"></i>
                        <span>Bonuses (Optional)</span>
                        <i class="fas fa-chevron-down toggle-icon"></i>
                    </button>
                    <div class="collapsible-content">
                        <?php for($i=0; $i<=6; $i++) { ?>
                        <div class="form-row-2">
                            <div class="form-group">
                                <label>Bonus Type <?php print $i+1; ?></label>
                                <select class="form-select" name="attrtype<?php print $i; ?>">
                                    <option value="0">None</option>
                                    <?php is_get_bonuses(); ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Bonus Value <?php print $i+1; ?></label>
                                <input type="number" class="form-input" name="attrvalue<?php print $i; ?>" value="0" required>
                            </div>
                        </div>
                        <?php } ?>
                    </div>
                </div>

                <!-- Sockets Section -->
                <div class="collapsible-section">
                    <button type="button" class="collapsible-header" onclick="toggleSection(this)">
                        <i class="fas fa-gem"></i>
                        <span>Sockets (Optional)</span>
                        <i class="fas fa-chevron-down toggle-icon"></i>
                    </button>
                    <div class="collapsible-content">
                        <div class="form-row-3">
                            <div class="form-group">
                                <label>Socket 1</label>
                                <input type="number" class="form-input" name="socket0" value="0">
                            </div>
                            <div class="form-group">
                                <label>Socket 2</label>
                                <input type="number" class="form-input" name="socket1" value="0">
                            </div>
                            <div class="form-group">
                                <label>Socket 3</label>
                                <input type="number" class="form-input" name="socket2" value="0">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Item Duration Section -->
                <div class="collapsible-section">
                    <button type="button" class="collapsible-header" onclick="toggleSection(this)">
                        <i class="fas fa-clock"></i>
                        <span>Item Duration (Optional)</span>
                        <i class="fas fa-chevron-down toggle-icon"></i>
                    </button>
                    <div class="collapsible-content">
                        <div class="form-row-4">
                             <div class="form-group">
                                <label>Months</label>
                                <input type="number" class="form-input" name="time_months" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Days</label>
                                <input type="number" class="form-input" name="time_days" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Hours</label>
                                <input type="number" class="form-input" name="time_hours" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Minutes</label>
                                <input type="number" class="form-input" name="time_minutes" value="0" min="0">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Costume Duration Section -->
                <div class="collapsible-section">
                    <button type="button" class="collapsible-header" onclick="toggleSection(this)">
                        <i class="fas fa-user-clock"></i>
                        <span>Costume Duration (Optional)</span>
                        <i class="fas fa-chevron-down toggle-icon"></i>
                    </button>
                    <div class="collapsible-content">
                        <div class="form-row-4">
                             <div class="form-group">
                                <label>Months</label>
                                <input type="number" class="form-input" name="time2_months" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Days</label>
                                <input type="number" class="form-input" name="time2_days" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Hours</label>
                                <input type="number" class="form-input" name="time2_hours" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Minutes</label>
                                <input type="number" class="form-input" name="time2_minutes" value="0" min="0">
                            </div>
                        </div>
                    </div>
                </div>

                <?php if(check_item_column("applytype0")) { ?>
                <!-- Sash / Advanced Bonuses Section -->
                <div class="collapsible-section">
                    <button type="button" class="collapsible-header" onclick="toggleSection(this)">
                        <i class="fas fa-star"></i>
                        <span>Sash / Advanced Bonuses (Optional)</span>
                        <i class="fas fa-chevron-down toggle-icon"></i>
                    </button>
                    <div class="collapsible-content">
                        <div class="form-group">
                            <label><?php print $lang_shop['bonus_absorption']; ?></label>
                            <input type="number" class="form-input" name="absorption" value="0">
                        </div>
                        <hr style="border-top: 1px solid #eee; margin: 20px 0;">
                        <p style="margin-bottom: 15px; font-weight: bold; color: #333;">Advanced Bonuses</p>
                        <?php for($i=0; $i<=7; $i++) { ?>
                        <div class="form-row-2">
                            <div class="form-group">
                                <label>Bonus Type <?php print $i+1; ?></label>
                                <select class="form-select" name="applytype<?php print $i; ?>">
                                    <option value="0">None</option>
                                    <?php is_get_bonuses(); ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Bonus Value <?php print $i+1; ?></label>
                                <input type="number" class="form-input" name="applyvalue<?php print $i; ?>" value="0" required>
                            </div>
                        </div>
                        <?php } ?>
                    </div>
                </div>
                <?php } ?>

                <!-- Promotion Section -->
                <div class="collapsible-section">
                    <button type="button" class="collapsible-header" onclick="toggleSection(this)">
                        <i class="fas fa-fire"></i>
                        <span>Promotion Duration (Optional)</span>
                        <i class="fas fa-chevron-down toggle-icon"></i>
                    </button>
                    <div class="collapsible-content">
                        <div class="form-row-4">
                            <div class="form-group">
                                <label>Months</label>
                                <input type="number" class="form-input" name="promotion_months" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Days</label>
                                <input type="number" class="form-input" name="promotion_days" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Hours</label>
                                <input type="number" class="form-input" name="promotion_hours" value="0" min="0">
                            </div>
                            <div class="form-group">
                                <label>Minutes</label>
                                <input type="number" class="form-input" name="promotion_minutes" value="0" min="0">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Submit Actions -->
        <div class="form-actions">
            <button type="submit" name="add" class="btn-submit">
                <i class="fas fa-check"></i>
                <span>Add Item to Shop</span>
            </button>
            <a href="<?php print $shop_url.'category/'.$get_category.'/'; ?>" class="btn-cancel">
                <i class="fas fa-times"></i>
                <span>Cancel</span>
            </a>
        </div>
    </form>
</div>

<!-- Stile per l'anteprima -->
<style>
.item-preview-box, .item-preview-error {
    display: flex;
    align-items: center;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background-color: #f9f9f9;
    min-height: 56px;
    box-sizing: border-box;
}
.item-preview-box img {
    width: 32px;
    height: 32px;
    margin-right: 12px;
    object-fit: contain;
    background-color: #eee;
    border-radius: 4px;
    border: 1px solid #ddd;
}
.item-preview-box span {
    font-weight: 600;
    color: #333;
}
.item-preview-error {
    color: #c0392b;
    background-color: #fbeae5;
    border-color: #e74c3c;
}
.item-preview-error i {
    margin-right: 10px;
}
</style>


<!-- SCRIPT JAVASCRIPT PER LE SEZIONI E L'ANTEPRIMA -->
<script>
// Funzione per le sezioni a scomparsa
function toggleSection(btn) {
    const content = btn.nextElementSibling;
    const icon = btn.querySelector('.toggle-icon');
    
    if (content.style.maxHeight) {
        content.style.maxHeight = null;
        icon.style.transform = 'rotate(0deg)';
        content.classList.remove('active');
    } else {
        content.style.maxHeight = content.scrollHeight + "px";
        icon.style.transform = 'rotate(180deg)';
        content.classList.add('active');
    }
}

// Funzione per l'anteprima dell'item
document.addEventListener('DOMContentLoaded', function() {
    const vnumInput = document.getElementById('item-vnum');
    const previewBox = document.getElementById('item-preview');
    const errorBox = document.getElementById('item-preview-error');
    const iconPreview = document.getElementById('item-icon-preview');
    const namePreview = document.getElementById('item-name-preview');
    
    let debounceTimer;

    vnumInput.addEventListener('input', function() {
        clearTimeout(debounceTimer);
        const vnum = this.value.trim();

        if (vnum.length > 0) {
            // Attende 500ms prima di fare la richiesta per non sovraccaricare il server
            debounceTimer = setTimeout(() => {
                fetchItemData(vnum);
            }, 500); 
        } else {
            previewBox.style.display = 'none';
            errorBox.style.display = 'none';
        }
    });

    async function fetchItemData(vnum) {
        try {
            // Assicurati che il percorso a api_getitem.php sia corretto
            const response = await fetch(`<?php print $shop_url; ?>api_getitem2.php?vnum=${vnum}`);
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const data = await response.json();

            if (data.success) {
                // Successo: mostra l'anteprima
                iconPreview.src = `<?php print $shop_url; ?>images/items/${data.icon_vnum}.png`;
                namePreview.textContent = data.name;
                previewBox.style.display = 'flex';
                errorBox.style.display = 'none';
            } else {
                // Errore (item non trovato): mostra messaggio di errore
                previewBox.style.display = 'none';
                errorBox.style.display = 'flex';
            }
        } catch (error) {
            console.error('Errore durante il fetch dell\'item:', error);
            previewBox.style.display = 'none';
            errorBox.style.display = 'flex';
        }
    }
});
</script>