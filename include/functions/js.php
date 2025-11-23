<?php
	if(($current_page=='item' && isset($item[0]) && ($item[0]['expire']>0 || $item[0]['discount']>0)) || $current_page=='items')
	{
?>
    <script src="<?php print $shop_url; ?>assets/js/jquery.countdown.min.js"></script>
    <script src="<?php print $shop_url; ?>assets/js/moment-with-locales.min.js"></script>
    <script src="<?php print $shop_url; ?>assets/js/moment-timezone-with-data.js"></script>
<?php } ?>

<!-- Modern JavaScript (ES6+) -->
<script src="<?php print $shop_url; ?>assets/js/shop-modern.js?v=2.0.0"></script>

<!-- Toast Notifications System -->
<script src="<?php print $shop_url; ?>assets/js/toast-notifications.js?v=1.0.0"></script>

<!-- AJAX Features: Quick View, Gift, History -->
<script src="<?php print $shop_url; ?>assets/js/shop-ajax-features.js?v=1.0.0"></script>



<!-- Real-time Filters -->
<?php if($current_page == 'items') { ?>
<script src="<?php print $shop_url; ?>assets/js/filters-realtime.js?v=1.0.0"></script>
<?php } ?>

<!-- Configurazione dinamica -->
<script>
// Shop base URL for AJAX calls (assoluto)
window.SHOP_BASE_URL = '<?php echo rtrim($shop_url, '/') . '/'; ?>';
window.SHOP_API_URL = '<?php echo rtrim($shop_url, '/') . '/api/shop_api.php'; ?>';

if (typeof SHOP_CONFIG !== 'undefined') {
    SHOP_CONFIG.countdownFormat = '%D <?php print $lang_shop['days']; ?> %H:%M:%S';
}
</script>
