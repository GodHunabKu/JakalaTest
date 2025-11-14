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
            <i class="fas fa-star"></i>
            <h1>Add Item with Bonus Selection</h1>
            <p>Category: <strong><?php print is_get_category_name($get_category); ?></strong></p>
        </div>
    </div>

    <?php
    $added = false;
    $bonus_value = is_get_bonuses_values_used();
    if(isset($_POST['add']))
    {
        $bonuses1 = $bonuses2 = array();
        $bonuses3 = array(0, $_POST['count']);
        $bonuses_count = 0;
        
        for($i=1; $i<=96; $i++)
            if(isset($_POST['bonus_'.$i]))
            {
                $bonuses1[] = 'bonus'.$i.' ';
                $bonuses2[] = '? ';
                $bonuses3[] = $_POST['bonus_value_'.$i];
                $bonuses_count++;
            }
        
        if($bonuses_count>=$_POST['count'])
        {
            $expire = 0;
            if($_POST['promotion_months']>0 || $_POST['promotion_days']>0 || $_POST['promotion_hours']>0 || $_POST['promotion_minutes']>0)
                $expire = strtotime("now +".intval($_POST['promotion_months'])." month +".intval($_POST['promotion_days'])." day +".intval($_POST['promotion_hours'])." hours +".intval($_POST['promotion_minutes'])." minute - 1 hour UTC");
            
            if($_POST['socket0']!="")
                $socket0 = $_POST['socket0'];
            else
                $socket0 = 0;
            if($_POST['socket1']!="")
                $socket1 = $_POST['socket1'];
            else
                $socket1 = 0;
            if($_POST['socket2']!="")
                $socket2 = $_POST['socket2'];
            else
                $socket2 = 0;
            
            $stmt = $database->runQuerySqlite('INSERT INTO item_shop_items (category, type, description, pay_type, coins, count, vnum, socket0, socket1, socket2, expire) VALUES (?,?,?,?,?,?,?,?,?,?,?)');
            $stmt->execute(array($get_category, 3, $_POST['description'], $_POST['method_pay'], $_POST['coins'], 1, $_POST['vnum'], $socket0, $socket1, $socket2, $expire));
            $bonuses3[0] = $database->getSqliteBonuslastInsertId();
            
            $query1 = join(',',$bonuses1);
            $query2 = join(',',$bonuses2);
            $bonuses3[] = $expire;
            
            $stmt = $database->runQuerySqlite('INSERT INTO item_shop_bonuses (id, count, '.$query1.', expire) VALUES (?,?,?,'.$query2.')');
            $stmt->execute($bonuses3);
            
            $added = true;
        } else {
            echo '<div class="alert-message alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>You need to select more bonuses than the number of slots!</span>
                    <button onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
                  </div>';
        }
    }
    
    if($added) {
        echo '<div class="alert-message alert-success">
                <i class="fas fa-check-circle"></i>
                <span>'.$lang_shop['item_added'].'</span>
                <button onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
              </div>';
    }
    ?>

    <!-- Main Form -->
    <form action="" method="post" class="admin-form-modern">
        <div class="form-grid-2col">
            <!-- LEFT COLUMN: Basic Info -->
            <div class="form-section">
                <div class="section-header">
                    <i class="fas fa-box"></i>
                    <h3>Item Information</h3>
                </div>
                
                <div class="form-group">
                    <label>
                        <i class="fas fa-hashtag"></i>
                        Item VNUM *
                    </label>
                    <input type="number" class="form-input" name="vnum" required placeholder="e.g., 19">
                    <small class="form-hint">The item's unique identifier</small>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-coins"></i>
                        Price & Currency *
                    </label>
                    <div class="input-group">
                        <select class="form-select" name="method_pay" style="max-width: 120px;">
                            <option value="1">?? MD</option>
                            <option value="2">?? JD</option>
                        </select>
                        <input type="number" class="form-input" name="coins" value="10" required placeholder="500">
                    </div>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-star"></i>
                        Number of Bonus Slots *
                    </label>
                    <select class="form-select" name="count">
                        <?php for($i=1;$i<=7;$i++) { ?>
                        <option value="<?php print $i; ?>" <?php if($i==4) print 'selected'; ?>>
                            <?php print $i; ?> Bonus Slot<?php if($i>1) print 's'; ?>
                        </option>
                        <?php } ?>
                    </select>
                    <small class="form-hint">How many bonuses users can select</small>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-align-left"></i>
                        Description
                    </label>
                    <textarea class="form-textarea" name="description" rows="4" placeholder="Enter item description..."></textarea>
                </div>

                <!-- Collapsible Sections -->
                <div class="collapsible-section">
                    <button type="button" class="collapsible-header" onclick="toggleSection(this)">
                        <i class="fas fa-fire"></i>
                        <span>Promotion (Optional)</span>
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

                <div class="collapsible-section">
                    <button type="button" class="collapsible-header" onclick="toggleSection(this)">
                        <i class="fas fa-gem"></i>
                        <span>Sockets (Optional)</span>
                        <i class="fas fa-chevron-down toggle-icon"></i>
                    </button>
                    <div class="collapsible-content">
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

            <!-- RIGHT COLUMN: Bonuses -->
            <div class="form-section">
                <div class="section-header">
                    <i class="fas fa-magic"></i>
                    <h3>Available Bonuses</h3>
                    <button type="button" class="btn-toggle-all" onclick="toggleAllBonuses()">
                        <i class="fas fa-check-double"></i>
                        Toggle All
                    </button>
                </div>

                <div class="bonus-info-card">
                    <i class="fas fa-info-circle"></i>
                    <p>Select bonuses that users can choose from. Make sure to select MORE bonuses than the number of slots!</p>
                </div>

                <div class="bonus-list">
                    <?php 
                    $bonuses = is_get_bonuses_new();
                    foreach($bonuses as $row) { 
                    ?>
                    <div class="bonus-item">
                        <label class="bonus-checkbox">
                            <input type="checkbox" name="bonus_<?php print $row['id']; ?>">
                            <span class="checkmark"></span>
                            <span class="bonus-label"><?php print str_replace("[n]", 'XXX', $row[$language_code]); ?></span>
                        </label>
                        <div class="bonus-value">
                            <input type="number" class="bonus-input" name="bonus_value_<?php print $row['id']; ?>" value="<?php print $bonus_value[$row['id']]; ?>" placeholder="Value">
                        </div>
                    </div>
                    <?php } ?>
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

<script>
function toggleSection(btn) {
    const content = btn.nextElementSibling;
    const icon = btn.querySelector('.toggle-icon');
    content.classList.toggle('active');
    icon.style.transform = content.classList.contains('active') ? 'rotate(180deg)' : 'rotate(0deg)';
}

function toggleAllBonuses() {
    const checkboxes = document.querySelectorAll('.bonus-checkbox input[type="checkbox"]');
    const allChecked = Array.from(checkboxes).every(cb => cb.checked);
    checkboxes.forEach(cb => cb.checked = !allChecked);
}
</script>