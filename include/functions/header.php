<?php
	// Set secure session parameters BEFORE session_start()
	ini_set('session.cookie_httponly', 1);
	ini_set('session.use_only_cookies', 1);
	ini_set('session.cookie_secure', isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 1 : 0);
	ini_set('session.cookie_samesite', 'Lax');

	session_start();
	header('Cache-control: private');
	include 'config.php';
	
	if (substr($shop_url, -1)!='/')
		$shop_url.='/';
	
	include 'include/functions/language.php';
	include 'include/functions/security.php'; // Security functions

	$offline = 0;
	require_once("include/classes/user.php");
	$database = new USER($host, $user, $password);

	include 'include/functions/get_item_image.php';
	include 'include/functions/basic.php';
	include 'include/functions/auto_migrate.php';

	if($offline)
		die("The Connection to the database of game is not available.");
		
	$item_name_db = get_settings_time(4);

	// Validate page parameter with whitelist
	$current_page = isset($_GET['p']) ? validate_page($_GET['p']) : 'home';

	if($current_page=='items' || $current_page=='add_items' || $current_page=='add_items_bonus') {
		// Se non c'è parametro category, mostra tutti gli oggetti (0)
		// Se c'è parametro category, validalo (min 1, max 999)
		if(isset($_GET['category'])) {
			$validated = validate_id($_GET['category'], 1, 999);
			$get_category = ($validated !== false) ? $validated : 0;
		} else {
			$get_category = 0; // 0 = tutti gli oggetti
		}
	}

	// Auto-migrazione per pagine admin che usano custom_image/sort_order
	if($current_page=='add_items' || $current_page=='add_items_bonus' || $current_page=='edit_item')
		ensure_database_schema();

	if($current_page=='edit_item')
	{
		$get_edit = isset($_GET['id']) ? validate_id($_GET['id'], 1, 999999) : 0;

		// Verifica che sia admin
		if(!is_loggedin() || web_admin_level() < 9)
			redirect($shop_url);

		// Verifica che l'item esista
		if($get_edit > 0 && !is_check_item($get_edit))
			redirect($shop_url);
	}

	if($current_page=='item' || $current_page=='buy')
	{
		$get_item = isset($_GET['id']) ? validate_id($_GET['id'], 1, 999999) : 1;

		$item = array();
		$item = is_item_select($get_item);

		// Define item_name for use in sidebar and templates
		if(!$item_name_db)
			$item_name = get_item_name($item[0]['vnum']);
		else
			$item_name = get_item_name_locale_name($item[0]['vnum']);

		if($item[0]['type']==3) {
			$bonuses_name = is_get_bonuses_new_name();
			$bonuses = is_get_bonus_selection($get_item);
			
			$count = $bonuses['count'];

			$available_bonuses = array();
			foreach($bonuses as $key => $bonus)
				if($key[0]=='b' && $bonus!=0)
					$available_bonuses[intval(str_replace("bonus","", $key))] = $bonus;
		}
			
		if(is_loggedin() && web_admin_level()>=9 && isset($_POST['add_discount']))
		{
			$discount_expire = 0;
			// ✅ FIX: Rimosso "- 1 hour UTC" che causava timestamp negativi
			if($_POST['discount_months']>0 || $_POST['discount_days']>0 || $_POST['discount_hours']>0 || $_POST['discount_minutes']>0)
				$discount_expire = strtotime("+".intval($_POST['discount_months'])." month +".intval($_POST['discount_days'])." day +".intval($_POST['discount_hours'])." hours +".intval($_POST['discount_minutes'])." minute");
			is_set_item_discount($get_item, intval($_POST['discount_value']), $discount_expire);
			redirect($shop_url.'item/'.$get_item.'/');
		}
	
		if($current_page=='buy' && is_coins($item[0]['pay_type']-1)<$item[0]['coins'])
			redirect($shop_url.'category/'.$item[0]['category']);
		else {
			$price1 = $total = $item[0]['coins'];
			if($item[0]['discount']>0)
			{
				$x = $item[0]['discount'] * $total / 100;
				$total-=$x;
				$total = round($total);
			}
		}
	}
	
	if($current_page=='items' && is_loggedin() && web_admin_level()>=9) // minim_web_admin_level = 9
	{
		$remove = isset($_GET['remove']) ? validate_id($_GET['remove'], 0, 999999) : 0;
		$remove_category = isset($_GET['category']) ? validate_id($_GET['category'], 0, 999) : 0;
		if($remove)
		{
			is_delete_item($remove);
			if($remove_category)
				redirect($shop_url.'category/'.$remove_category.'/');
		}
	}
	
	// Permetti category=0 per "Tutti gli Oggetti", valida solo se > 0
	if(($current_page=='items' || $current_page=='add_items' || $current_page=='add_items_bonus') && $get_category > 0 && !is_check_category($get_category))
		redirect($shop_url);

	if(($current_page=='item' || $current_page=='buy') && !is_check_item($get_item))
		redirect($shop_url);
	
	redirect_shop($current_page);
	
	autoDeletePromotions();
	
	if($current_page=='coins')
	{	
		$list = array();
		$list = is_paypal_list();
		
		if(isset($_POST["id"]))
		{
			// Validate PayPal ID
			$paypal_id = validate_id($_POST["id"], 1, 999);
			if($paypal_id && is_check_paypal($paypal_id))
			{
				$return_url = $shop_url."buy/coins/success";
				$cancel_url = $shop_url."buy/coins/cancelled";
				$notify_url = $shop_url."index.php?p=pay";

				$querystring = '';
				$querystring .= "?business=".urlencode($paypal_email)."&";
				
				$item_name = is_get_coins($paypal_id). ' MD';
				$querystring .= "item_name=".urlencode($item_name)."&";
				$querystring .= "amount=".urlencode(is_get_price($paypal_id))."&";
				
				$querystring .= "cmd=".urlencode(stripslashes("_xclick"))."&";
				$querystring .= "no_note=".urlencode(stripslashes("1"))."&";
				$querystring .= "currency_code=".urlencode(stripslashes("EUR"))."&";
				$querystring .= "bn=".urlencode(stripslashes("PP-BuyNowBF:btn_buynow_LG.gif:NonHostedGuest"))."&";
				$querystring .= "first_name=".urlencode(stripslashes(get_account_name()))."&";
				
				$querystring .= "return=".urlencode(stripslashes($return_url))."&";
				$querystring .= "cancel_return=".urlencode(stripslashes($cancel_url))."&";
				$querystring .= "notify_url=".urlencode($notify_url)."&";
				$querystring .= "item_number=".urlencode($paypal_id)."&";
				$querystring .= "custom=".urlencode($_SESSION['id']);
				
				//redirect('https://www.sandbox.paypal.com/cgi-bin/webscr'.$querystring);
				redirect('https://www.paypal.com/cgi-bin/webscr'.$querystring);
				exit();
			}
		}
	}
?>