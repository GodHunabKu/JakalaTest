<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<div class="admin-actions-bar">
    <a href="<?php print $shop_url.'admin/paypal'; ?>" class="btn-admin btn-admin-info">
        <i class="fab fa-paypal"></i>
        <span><?php print $lang_shop['administration_pp']; ?></span>
    </a>
</div>
<?php } 
$paypal_paid = isset($_GET['m']) ? $_GET['m'] : null;
?>

<div class="shop-content-wrapper">
    <!-- Page Header -->
    <div class="page-header">
        <div class="page-title">
            <i class="fas fa-coins"></i>
            <h1><?php print $lang_shop['pay']; ?></h1>
        </div>
        <div class="page-breadcrumb">
            <a href="<?php print $shop_url; ?>">Home</a>
            <i class="fas fa-chevron-right"></i>
            <span><?php print $lang_shop['pay']; ?></span>
        </div>
    </div>

    <!-- Success Message -->
    <?php if($paypal_paid=='success') { ?>
    <div class="alert-message alert-success">
        <i class="fas fa-check-circle"></i>
        <span><?php print $lang_shop['paypal_wait']; ?></span>
    </div>
    <?php } ?>

    <!-- Coins Packages Grid -->
    <div class="coins-grid">
        <?php
        if(!count($list)) {
            echo '<div class="empty-state">
                    <i class="fas fa-coins"></i>
                    <h3>No packages available</h3>
                    <p>Check back soon!</p>
                  </div>';
        } else {
            $i = 0;
            foreach($list as $row) {
                $i++;
        ?>
        <form action="" method="post" id="paypal<?php print $i; ?>" style="display: none;">
            <input type="hidden" name="id" value="<?php print $row['id']; ?>">
        </form>
        
        <div class="coin-package" onclick="document.getElementById('paypal<?php print $i; ?>').submit();">
            <div class="coin-package-inner">
                <div class="package-icon">
                    <i class="fab fa-paypal"></i>
                </div>
                <div class="package-coins">
                    <span class="coins-amount"><?php print $row['coins']; ?></span>
                    <span class="coins-label">MD Coins</span>
                </div>
                <div class="package-price">
                    <span class="price-amount"><?php print $row['price']; ?> €</span>
                </div>
                <button type="button" class="btn-package">
                    <i class="fab fa-paypal"></i>
                    <span>Purchase with PayPal</span>
                </button>
            </div>
        </div>
        <?php } } ?>
    </div>
</div>