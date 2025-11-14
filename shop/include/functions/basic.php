<?php

	function redirect($url) {

		if(!headers_sent()) {

			header('Location: '.$url);

			exit;

		} else {

			echo '<script type="text/javascript">';

			echo 'window.location.href="'.$url.'";';

			echo '</script>';

			echo '<noscript>';

			echo '<meta http-equiv="refresh" content="0;url='.$url.'" />';

			echo '</noscript>';

			exit;

		}

	}



	function login($uname,$upass,$shop=0)

	{

		global $database, $lang_shop, $shop_url;

		// Input validation
		if (!validate_username($uname)) {
			secure_log("Login attempt with invalid username format", "WARNING");
			return false;
		}

		if (!validate_password($upass)) {
			secure_log("Login attempt with invalid password format", "WARNING");
			return false;
		}

		// Rate limiting - 5 attempts per 5 minutes
		$rate_key = 'login_' . $_SERVER['REMOTE_ADDR'];
		if (!check_rate_limit($rate_key, 5, 300)) {
			secure_log("Rate limit exceeded for login from " . safe_output($uname), "WARNING");
			print '<div class="alert alert-dismissible alert-warning">
					<button type="button" class="close" data-dismiss="alert">×</button>
					Too many login attempts. Please try again in 5 minutes.
				</div>';
			return false;
		}

		// Query for user (using legacy hash for compatibility)
		$stmt = $database->runQueryAccount("SELECT id, login, password, status FROM account WHERE login=:uname LIMIT 1");
		$stmt->execute(array(':uname'=>$uname));

		$userRow=$stmt->fetch(PDO::FETCH_ASSOC);

		if($stmt->rowCount() > 0)

		{
			// Verify password using legacy method
			$password_hash = strtoupper("*".sha1(sha1($upass, true)));

			if(!hash_equals($userRow['password'], $password_hash)) {
				secure_log("Failed login attempt for user: " . safe_output($uname), "WARNING");
				return false;
			}

			if($userRow['status']=='OK')

			{
				// Clear rate limit on successful login
				clear_rate_limit($rate_key);

				$_SESSION['id'] = $userRow['id'];
				$_SESSION['fingerprint'] = get_session_fingerprint();

				// Regenerate session ID to prevent fixation
				regenerate_session();

				secure_log("Successful login for user: " . safe_output($uname), "INFO");

				redirect($shop_url);

				return true;

			} else {

				secure_log("Login attempt for blocked account: " . safe_output($uname), "WARNING");

				print '<div class="alert alert-dismissible alert-warning">

						<button type="button" class="close" data-dismiss="alert">×</button>

						'.$lang_shop['blocked_account'].'

					</div>';

				return false;

			}

		}

		else

		{
			secure_log("Login attempt for non-existent user: " . safe_output($uname), "WARNING");
			return false;

		}

	}



	function is_loggedin()

	{

		if(isset($_SESSION['id']))

			return true;

	}



	function fingerprint()

	{

		if(is_loggedin())

			if (!validate_session_fingerprint())

				session_destroy();

	}



	function redirect_shop($url)

	{

		global $shop_url;



		if ($url=='coins' && !is_loggedin())

			redirect($shop_url.'login');

		if($url=='login' && is_loggedin())

			redirect($shop_url);

		

		if(($url=='categories' || $url=='add_items' || $url=='add_items_bonus' || $url=='settings' || $url=='paypal') && (!is_loggedin() || web_admin_level()<9))

			redirect($shop_url);

	}



	function logout_shop()

	{

		global $shop_url;

		
		session_destroy();

		unset($_SESSION['id']);

		redirect($shop_url.'login');

	}



	function get_account_name()

	{

		

		global $database;

		

		$sth = $database->runQueryAccount('SELECT login

			FROM account

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result[0]['login'];

	}



	function check_item_column($name)

	{

		

		global $database;

		

		$sth = $database->runQueryPlayer("DESCRIBE item");

		$sth->execute();

		$columns = $sth->fetchAll(PDO::FETCH_COLUMN);

		

		if(in_array($name, $columns))

			return true;

		else return false;

	}



	function char_big_lvl()

	{

		global $database;

		

		$sth = $database->runQueryPlayer('SELECT name, job, level, exp

			FROM player

			WHERE account_id = ? ORDER BY level DESC, exp DESC LIMIT 1');

		$sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(isset($result[0]['job']))

			print $result[0]['job'];

		else print 0;

	}



	function getItemSize($code) {

		global $database;



		$sth = $database->runQuerySqlite('SELECT size

			FROM items_details

			WHERE id = ?');

		$sth->bindParam(1, $code, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		if(isset($result[0]['size']))

			return $result[0]['size'];

		else return 3;

	}



	function new_item_position($new_item)

	{

		global $database;

			

		$sth = $database->runQueryPlayer('SELECT pos, vnum

			FROM item

			WHERE owner_id=? AND window="MALL" ORDER by pos ASC');

		$sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		$used = $items_used = $used_check = array();

		

		foreach( $result as $row ) {

			$used_check[] = $row['pos'];

			$used[$row['pos']] = 1;

			$items_used[$row['pos']] = $row['vnum'];

		}

		$used_check = array_unique($used_check);



		$free = -1;

		

		for($i=0; $i<45; $i++){

			if(!in_array($i,$used_check)){

				$ok = true;

				

				if($i>4 && $i<10)

				{

					if(array_key_exists($i-5, $used) && getItemSize($items_used[$i-5])>1)

						$ok = false;

				}

				else if($i>9 && $i<40)

				{

					if(array_key_exists($i-5, $used) && getItemSize($items_used[$i-5])>1)

						$ok = false;

					

					if(array_key_exists($i-10, $used) && getItemSize($items_used[$i-10])>2)

						$ok = false;

				}

				else if($i>39 && $i<45 && getItemSize($new_item)>1)

						$ok = false;

				

				if($ok)

					return $i;

			}

		}

		

		return $free;

	}



	function check_item_sash($id)

	{

		if($id > 85000 && $id < 90000)

			return true;

		else return false;

	}



	function check_item_stone($id)

	{

		if($id >= 28000 && $id <= 28960)

			return true;

		else return false;

	}



	function get_item_name_locale_name($id)

	{

		global $database;

		

		$stmt = $database->runQueryPlayer('SELECT locale_name

			FROM item_proto

			WHERE vnum = ?');

		$stmt->bindParam(1, $id, PDO::PARAM_INT);

		$stmt->execute();

		$result = $stmt->fetch(PDO::FETCH_ASSOC);

		

		return utf8_encode($result['locale_name']);

	}



	function get_item_name($id)

	{

		global $database;

		global $language_code;

		

		$sth = $database->runQuerySqlite('SELECT '.$language_code.'

			FROM items_names

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(isset($result[0][$language_code]))

			return $result[0][$language_code];

		else return 'No name';

	}



	function return_item_name($id)

	{

		global $database;

		global $language_code;

		

		$sth = $database->runQuerySqlite('SELECT '.$language_code.'

			FROM items_names

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result[0][$language_code];

	}



	function get_bonus_name($id, $value)

	{

		global $database;

		global $language_code;

		

		$sth = $database->runQuerySqlite('SELECT '.$language_code.'

			FROM items_bonuses

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return str_replace("[n]", '<font color="red"><b>'.$value.'</b></font>', $result[0][$language_code]);

	}



	function get_item_type($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT type

			FROM items_details

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(isset($result[0]['type']))

			return $result[0]['type'];

		else return 'NOT_FOUND';

	}



	function get_item_lvl($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT lvl

			FROM items_details

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		if(isset($result[0]['lvl']) && $result[0]['lvl']<=105)

			return $result[0]['lvl'];

		else return 0;

	}



	function web_admin_level()

	{

		global $database;

		

		$sth = $database->runQueryAccount('SELECT web_admin

			FROM account

			WHERE id = ?');

		$sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result[0]['web_admin'];

	}



	//Functions for item-shop



	function get_item_stones_market($id)

	{

		global $database, $shop_url, $item_name_db;

		

		$sth = $database->runQuerySqlite('SELECT socket0, socket1, socket2

			FROM item_shop_items

			WHERE id = ?');

		

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();



		if((check_item_stone($result[0]['socket0'])))

		{

			print '<div class="alert alert-info" style="border-radius: 0!important; margin-bottom: 0!important;">

						<div class="row">';

						

			for($i=0;$i<=2;$i++)

				if((check_item_stone($result[0]['socket'.$i])))

				{

					if(!$item_name_db)

						$item_name = get_item_name($result[0]['socket'.$i]);

					else 

						$item_name = get_item_name_locale_name($result[0]['socket'.$i]);

					print '<div class="col-md-4">

								<img src="'.$shop_url.'images/items/'. get_item_image($result[0]['socket'.$i]) .'.png">

								<p>'. $item_name .'</p>

							</div>';

				}

			print '</div>

			</div>';

		}

	}



	function is_categories_list()

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT *

			FROM item_shop_categories

			ORDER BY id ASC');

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result;

	}



	function is_coins($type=0)

	{

		global $database;

		

		$sth = $database->runQueryAccount('SELECT coins, jcoins

			FROM account

			WHERE id = ?');

		$sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(!$type)

			return $result[0]['coins'];

		else

			return $result[0]['jcoins'];

	}



	function is_get_category_name($category)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT name

			FROM item_shop_categories

			WHERE id = ?');

		$sth->bindParam(1, $category, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result[0]['name'];

	}



	function is_check_category($category)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT id

			FROM item_shop_categories

			WHERE id = ?');

		$sth->bindParam(1, $category, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(count($result))

			return 1;

		else return 0;

	}



	function is_check_item($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT id

			FROM item_shop_items

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(count($result))

			return 1;

		else return 0;

	}



	function is_item_select($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT id, category, type, description, pay_type, coins, count, vnum, socket0, socket1, socket2, expire, item_unique, discount, discount_expire

			FROM item_shop_items

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result;

	}



	function is_items_list($category)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT id, type, pay_type, coins, vnum, expire, discount

			FROM item_shop_items

			WHERE category = ? ORDER BY id ASC');

		$sth->bindParam(1, $category, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result;

	}



	function is_edit_category($id, $name, $img)

	{

		global $database;

		

		$stmt = $database->runQuerySqlite("UPDATE item_shop_categories set name = ?, img = ? WHERE id=?");

		$stmt->bindParam(1, $name, PDO::PARAM_STR);

		$stmt->bindParam(2, $img, PDO::PARAM_INT);

		$stmt->bindParam(3, $id, PDO::PARAM_INT);

		$stmt->execute();

	}



	function is_add_category($name, $img)

	{

		global $database;

		

		$stmt = $database->runQuerySqlite("INSERT INTO item_shop_categories (name, img) VALUES (?, ?)");

		$stmt->bindParam(1, $name, PDO::PARAM_STR);

		$stmt->bindParam(2, $img, PDO::PARAM_INT);

		$stmt->execute();

	}



	function is_delete_category($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite("DELETE FROM item_shop_categories WHERE id = ?");

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		

		$sth = $database->runQuerySqlite("DELETE FROM item_shop_items WHERE category = ?");

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

	}



	function is_get_bonuses()

	{

		global $database;

		global $language_code;

		

		$sth = $database->runQuerySqlite('SELECT '.$language_code.', id

			FROM items_bonuses');

		$sth->execute();

		$result = $sth->fetchAll();

		

		foreach( $result as $row ) {

			print '<option value='.$row['id'].'>'.str_replace("[n]", 'XXX', $row[$language_code]).'</option>';

		}

	}



	function is_get_item($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT attrtype0, attrvalue0, attrtype1, attrvalue1,

			attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4,

			attrtype5, attrvalue5, attrtype6, attrvalue6

			FROM item_shop_items

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		for($i=0;$i<=6;$i++)

			if($result[0]['attrtype'.$i])

			{

				print '<li class="list-group-item"><center>';

				print get_bonus_name($result[0]['attrtype'.$i], $result[0]['attrvalue'.$i]);

				print '</center></li>';

			}

	}



	function is_get_sash_bonuses($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT applytype0, applyvalue0, applytype1, applyvalue1,

			applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4,

			applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7

			FROM item_shop_items

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();



		$a=$m=0;

		

		for($i=0;$i<=7;$i++)

			if($result[0]['applytype'.$i])

			{

				if($result[0]['applytype'.$i]==53 && !$a)

				{

					print '<li class="list-group-item"><center>';

					print str_replace('+', '', get_bonus_name($result[0]['applytype'.$i], $result[0]['applyvalue'.$i]));

					$a++;

				}

				else if($result[0]['applytype'.$i]==53 && $a)

				{

					print ' - <font color="red"><b>'.$result[0]['applyvalue'.$i].'</b></font>';

					print '<li class="list-group-item"><center>';

				}

				else if($result[0]['applytype'.$i]==55 && !$m)

				{

					print '<li class="list-group-item"><center>';

					print str_replace('+', '', get_bonus_name($result[0]['applytype'.$i], $result[0]['applyvalue'.$i]));

					$m++;

				}

				else if($result[0]['applytype'.$i]==55 && $m)

				{

					print ' - <font color="red"><b>'.$result[0]['applyvalue'.$i].'</b></font>';

					print '<li class="list-group-item"><center>';

				}

				else

				{

					print '<li class="list-group-item"><center>';

					print get_bonus_name($result[0]['applytype'.$i], $result[0]['applyvalue'.$i]);

					print '</center></li>';

				}

			}

	}



	function is_get_sash_absorption($id)

	{

		global $database;

		

		$absorption_settings = get_settings_time(3);

		

		$sth = $database->runQuerySqlite('SELECT socket1

			FROM item_shop_items

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();



		return $result[0]['socket'.$absorption_settings];

	}



	function is_get_item_time($id)

	{

		global $database, $lang_shop;

		

		$sth = $database->runQuerySqlite('SELECT socket0, socket1, socket2

			FROM item_shop_items

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();



		for($i=0;$i<=2;$i++)

			if($result[0]['socket'.$i])

				{

					$minutes = $result[0]['socket'.$i];

					$d = floor($minutes / 1440);

					$h = floor(($minutes - $d * 1440) / 60);

					$m = $minutes - ($d * 1440) - ($h * 60);

					if($d)

						print $d.' '.$lang_shop['days'].' ';

					if($h)

						print $h.' '.$lang_shop['hours'].' ';

					if($m)

						print $m.' '.$lang_shop['minutes'].' ';

				}

	}



	function is_buy_item($id, $buy_bonuses)

	{

		global $database;

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT *

			FROM item_shop_items

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		$item_position = new_item_position($result[0]['vnum']);

		

		if($item_position == -1)

			return false;

		

		$success = false;

		if($result[0]['type']==3)

		{

			$bonuses = is_get_bonus_selection($id);

			

			$final_bonuses = array();

			for($i=0;$i<7;$i++)

				$final_bonuses['attrtype'.$i]=$final_bonuses['attrvalue'.$i] = 0;

			

			foreach($buy_bonuses as $key => $bonus)

			{

				$final_bonuses['attrtype'.$key] = $bonus;

				$final_bonuses['attrvalue'.$key] = $bonuses['bonus'.$bonus];

			}

			

			$stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');

			if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, 1, $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],

								$final_bonuses['attrtype0'], $final_bonuses['attrvalue0'], $final_bonuses['attrtype1'], $final_bonuses['attrvalue1'], $final_bonuses['attrtype2'], $final_bonuses['attrvalue2'], 

								$final_bonuses['attrtype3'], $final_bonuses['attrvalue3'], $final_bonuses['attrtype4'], $final_bonuses['attrvalue4'], $final_bonuses['attrtype5'], $final_bonuses['attrvalue5'], 

								$final_bonuses['attrtype6'], $final_bonuses['attrvalue6'])))

			$success = true;

		} else

		{

			$time2_settings = get_settings_time(2);

			

			if(check_item_column("applytype0"))

			{

				if($result[0]['type']==1)

				{

					$result[0]['socket'.$time2_settings] = time() + 60 * intval($result[0]['socket'.$time2_settings]);



					$stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4, applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');

					if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, $result[0]['count'], $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],

										$result[0]['attrtype0'], $result[0]['attrvalue0'], $result[0]['attrtype1'], $result[0]['attrvalue1'], $result[0]['attrtype2'], $result[0]['attrvalue2'], 

										$result[0]['attrtype3'], $result[0]['attrvalue3'], $result[0]['attrtype4'], $result[0]['attrvalue4'], $result[0]['attrtype5'], $result[0]['attrvalue5'], 

										$result[0]['attrtype6'], $result[0]['attrvalue6'], 

										$result[0]['applytype0'], $result[0]['applyvalue0'], $result[0]['applytype1'], $result[0]['applyvalue1'], $result[0]['applytype2'], $result[0]['applyvalue2'], 

										$result[0]['applytype3'], $result[0]['applyvalue3'], $result[0]['applytype4'], $result[0]['applyvalue4'], $result[0]['applytype5'], $result[0]['applyvalue5'], 

										$result[0]['applytype6'], $result[0]['applyvalue6'], $result[0]['applytype7'], $result[0]['applyvalue7'])))

										$success = true;

				} else {

					$stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4, applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');

					if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, $result[0]['count'], $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],

										$result[0]['attrtype0'], $result[0]['attrvalue0'], $result[0]['attrtype1'], $result[0]['attrvalue1'], $result[0]['attrtype2'], $result[0]['attrvalue2'], 

										$result[0]['attrtype3'], $result[0]['attrvalue3'], $result[0]['attrtype4'], $result[0]['attrvalue4'], $result[0]['attrtype5'], $result[0]['attrvalue5'], 

										$result[0]['attrtype6'], $result[0]['attrvalue6'], 

										$result[0]['applytype0'], $result[0]['applyvalue0'], $result[0]['applytype1'], $result[0]['applyvalue1'], $result[0]['applytype2'], $result[0]['applyvalue2'], 

										$result[0]['applytype3'], $result[0]['applyvalue3'], $result[0]['applytype4'], $result[0]['applyvalue4'], $result[0]['applytype5'], $result[0]['applyvalue5'], 

										$result[0]['applytype6'], $result[0]['applyvalue6'], $result[0]['applytype7'], $result[0]['applyvalue7'])))

										$success = true;

				}

			}

			else

			{

				if($result[0]['type']==1)

				{

					$result[0]['socket'.$time2_settings] = time() + 60 * intval($result[0]['socket'.$time2_settings]);

					

					$stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');

					if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, $result[0]['count'], $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],

										$result[0]['attrtype0'], $result[0]['attrvalue0'], $result[0]['attrtype1'], $result[0]['attrvalue1'], $result[0]['attrtype2'], $result[0]['attrvalue2'], 

										$result[0]['attrtype3'], $result[0]['attrvalue3'], $result[0]['attrtype4'], $result[0]['attrvalue4'], $result[0]['attrtype5'], $result[0]['attrvalue5'], 

										$result[0]['attrtype6'], $result[0]['attrvalue6'])))

										$success = true;

				} else {

					$stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');

					if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, $result[0]['count'], $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],

										$result[0]['attrtype0'], $result[0]['attrvalue0'], $result[0]['attrtype1'], $result[0]['attrvalue1'], $result[0]['attrtype2'], $result[0]['attrvalue2'], 

										$result[0]['attrtype3'], $result[0]['attrvalue3'], $result[0]['attrtype4'], $result[0]['attrvalue4'], $result[0]['attrtype5'], $result[0]['attrvalue5'], 

										$result[0]['attrtype6'], $result[0]['attrvalue6'])))

										$success = true;

				}



			}

		}



		if($success)

		{

			is_update_last_bought($id);

			is_insert_log($id);

			return true;

		}

		return false;

	}



	function is_pay_coins($type, $coins)

	{

		global $database;

		

		$sth = $database->runQueryAccount('SELECT coins, jcoins

			FROM account

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(!$type)

			$stmt = $database->runQueryAccount("UPDATE account set coins = coins - ? WHERE id = ?");

		else

			$stmt = $database->runQueryAccount("UPDATE account set jcoins = jcoins - ? WHERE id = ?");

			

		$stmt->bindParam(1, $coins, PDO::PARAM_INT);

		$stmt->bindParam(2, $_SESSION['id'], PDO::PARAM_INT);

		$stmt->execute();

		

		if(!$type)

			get_js_back(intval($coins/2));

	}



	function get_js_back($jcoins)

	{

		global $database;

		

		$stmt = $database->runQueryAccount("UPDATE account set jcoins = jcoins + ? WHERE id = ?");

		

		$stmt->bindParam(1, $jcoins, PDO::PARAM_INT);

		$stmt->bindParam(2, $_SESSION['id'], PDO::PARAM_INT);

		$stmt->execute();

	}



	function is_delete_item($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('DELETE

			FROM item_shop_items

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();



		$sth = $database->runQuerySqlite("DELETE FROM item_shop_bonuses WHERE id = ?");

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

	}



	function autoDeletePromotions()

	{

		global $database;

		

		$expire = strtotime("now - 1 hour UTC");



		$sth = $database->runQuerySqlite("DELETE FROM item_shop_items WHERE expire != 0 AND expire < ?");

		$sth->bindParam(1, $expire, PDO::PARAM_INT);

		$sth->execute();

		

		$sth = $database->runQuerySqlite("DELETE FROM item_shop_bonuses WHERE expire != 0 AND expire < ?");

		$sth->bindParam(1, $expire, PDO::PARAM_INT);

		$sth->execute();

		

		$sth = $database->runQuerySqlite("UPDATE item_shop_items SET discount = 0, discount_expire = 0 WHERE discount_expire != 0 AND discount_expire < ?");

		$sth->bindParam(1, $expire, PDO::PARAM_STR);

		$sth->execute();

	}



	function checkForPromotions($category)

	{

		global $database;

		

		$stmt = $database->runQuerySqlite("SELECT id FROM item_shop_items WHERE expire > 0 AND category = ? ORDER BY id DESC LIMIT 1");

		$stmt->bindParam(1, $category, PDO::PARAM_INT);

		$stmt->execute();

		$result=$stmt->fetch(PDO::FETCH_ASSOC);

		

		if($result)

			return 1;

		else return 0;

	}



	function is_update_last_bought($id)

	{

		global $database;

		

		$now = strtotime("now - 1 hour UTC");

		

		$stmt = $database->runQuerySqlite("UPDATE item_shop_items SET last_bought = ?, bought_count = bought_count + 1 WHERE id=?");

		$stmt->bindParam(1, $now, PDO::PARAM_INT);

		$stmt->bindParam(2, $id, PDO::PARAM_INT);

		$stmt->execute();

	}

	

	function is_insert_log($id)//update log 03.10.2017

	{

		global $database;

		

		$now = strtotime("now - 1 hour UTC");

		

		$stmt = $database->runQuerySqlite("INSERT INTO log (account, item, date) VALUES (?, ?, ?)");

		$stmt->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);

		$stmt->bindParam(2, $id, PDO::PARAM_INT);

		$stmt->bindParam(3, $now, PDO::PARAM_INT);

		$stmt->execute();

	}



	function is_get_bonuses_new()

	{

		global $database;

		global $language_code;

		

		$sth = $database->runQuerySqlite('SELECT '.$language_code.', id

			FROM items_bonuses');

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result;

	}



	function is_get_bonuses_new_name()

	{

		global $database;

		global $language_code;

		

		$sth = $database->runQuerySqlite('SELECT '.$language_code.', id

			FROM items_bonuses');

		$sth->execute();

		$result = $sth->fetchAll();

		

		$bonuses = array();

		

		foreach($result as $bonus)

			$bonuses[$bonus['id']] = $bonus[$language_code];

		

		return $bonuses;

	}



	function is_get_bonus_selection($id)

	{

		global $database;

		global $language_code;

		

		$stmt = $database->runQuerySqlite('SELECT *

			FROM item_shop_bonuses WHERE id = ?');

		$stmt->bindParam(1, $id, PDO::PARAM_INT);

		$stmt->execute();

		$result=$stmt->fetch(PDO::FETCH_ASSOC);

		

		return $result;

	}



	function last_bought()

	{

		global $database;

		global $language_code;

		

		$sth = $database->runQuerySqlite('SELECT id, vnum, pay_type, coins FROM item_shop_items WHERE last_bought != 0 ORDER BY last_bought DESC LIMIT 5');

		$sth->execute();

		$result = $sth->fetchAll();



		return $result;

	}



	function is_get_bonuses_values_used()

	{

		global $database;

		global $language_code;

		

		$stmt = $database->runQuerySqlite('SELECT *

			FROM item_shop_bonuses');

		$stmt->execute();

		$result=$stmt->fetchAll();

		

		$bonus_value = array();

		

		for($i=1; $i<=96; $i++)

			$bonus_value[$i] = 0;

		

		foreach($result as $item)

			foreach($item as $key => $bonus)

				if($key[0]=='b' && $bonus>0)

					$bonus_value[intval(str_replace("bonus","", $key))] = $bonus;

				

		return $bonus_value;

	}



	function is_set_item_discount($id, $discount, $expire)

	{

		global $database;

		

		$stmt = $database->runQuerySqlite("UPDATE item_shop_items set discount = ?, discount_expire = ? WHERE id=?");

		$stmt->bindParam(1, $discount, PDO::PARAM_STR);

		$stmt->bindParam(2, $expire, PDO::PARAM_INT);

		$stmt->bindParam(3, $id, PDO::PARAM_INT);

		$stmt->execute();

	}



	function update_settings($time, $time2, $absorption, $name)

	{

		global $database;

		

		$stmt = $database->runQuerySqlite("UPDATE settings SET value = ? WHERE id=1");

		$stmt->bindParam(1, $time, PDO::PARAM_INT);

		$stmt->execute();

		

		$stmt = $database->runQuerySqlite("UPDATE settings SET value = ? WHERE id=2");

		$stmt->bindParam(1, $time2, PDO::PARAM_INT);

		$stmt->execute();

		

		$stmt = $database->runQuerySqlite("UPDATE settings SET value = ? WHERE id=3");

		$stmt->bindParam(1, $absorption, PDO::PARAM_INT);

		$stmt->execute();

		

		$stmt = $database->runQuerySqlite("UPDATE settings SET value = ? WHERE id=4");

		$stmt->bindParam(1, $name, PDO::PARAM_INT);

		$stmt->execute();

	}



	function get_settings_time($id)

	{

		global $database;

		

		$stmt = $database->runQuerySqlite('SELECT *

			FROM settings WHERE id = ?');

		$stmt->bindParam(1, $id, PDO::PARAM_INT);

		$stmt->execute();

		$result=$stmt->fetch(PDO::FETCH_ASSOC);

		

		return $result['value'];

	}

	

	//Update 04.10.2017

	function get_all_paypal()

	{

		global $database;

		

		$stmt = $database->runQuerySqlite("SELECT * FROM paypal ORDER BY id ASC");

		$stmt->execute();

		

		$result = $stmt->fetchAll();

		

		return $result;

	}

	

	function is_edit_paypal($id, $price, $coins)

	{

		global $database;

		

		$stmt = $database->runQuerySqlite("UPDATE paypal set price = ?, coins = ? WHERE id=?");

		$stmt->bindParam(1, $price, PDO::PARAM_STR);

		$stmt->bindParam(2, $coins, PDO::PARAM_INT);

		$stmt->bindParam(3, $id, PDO::PARAM_INT);

		$stmt->execute();

	}



	function is_delete_paypal($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite("DELETE FROM paypal WHERE id = ?");

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

	}



	function is_add_paypal($price, $coins)

	{

		global $database;

		

		$stmt = $database->runQuerySqlite("INSERT INTO paypal (price, coins) VALUES (?, ?)");

		$stmt->bindParam(1, $price, PDO::PARAM_STR);

		$stmt->bindParam(2, $coins, PDO::PARAM_INT);

		$stmt->execute();

	}



	function is_paypal_list()

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT *

			FROM paypal

			ORDER BY id ASC');

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result;

	}



	function is_check_paypal($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT id

			FROM paypal

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(count($result))

			return 1;

		else return 0;

	}



	function is_get_price($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT price

			FROM paypal

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result[0]['price'];

	}



	function is_get_coins($id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT coins

			FROM paypal

			WHERE id = ?');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		return $result[0]['coins'];

	}



	function check_txnid_paypal($tnxid)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT id

			FROM payments

			WHERE txnid = ?');

		$sth->bindParam(1, $tnxid, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		

		if(count($result))

			return 0;

		else return 1;

	}



	function check_price_paypal($price, $id)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT price

			FROM paypal

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $id, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();

		if(count($result))

			if(floatval($price)==$result[0]['price'])

				return 1;

		return 0;

	}



	function updatePayments($data){

		global $database;

		

		if (is_array($data)) {

			$stmt = $database->runQuerySqlite('INSERT INTO payments (txnid, payment_amount, payment_status, itemid, createdtime) VALUES (?,?,?,?,?)');

			$stmt->execute(array($data['txn_id'], $data['payment_amount'], $data['payment_status'], $data['item_number'], date("Y-m-d H:i:s")));

		}

	}



	function get_coins_paypal($id_account, $id_paypal)

	{

		global $database;

		

		$sth = $database->runQuerySqlite('SELECT coins

			FROM paypal

			WHERE id = ? LIMIT 1');

		$sth->bindParam(1, $id_paypal, PDO::PARAM_INT);

		$sth->execute();

		$result = $sth->fetchAll();



		$stmt = $database->runQueryAccount("UPDATE account SET coins = coins + ? WHERE id = ?");

		$stmt->bindParam(1, $result[0]['coins'], PDO::PARAM_INT);

		$stmt->bindParam(2, $id_account, PDO::PARAM_INT);

		$stmt->execute();

	}


	function get_item_details_from_proto($vnum) {
    global $database; 
    static $cached_items = []; 

    if (isset($cached_items[$vnum])) {
        return $cached_items[$vnum];
    }
    
    // Mappa bonus completa e corretta
    $bonus_map = [
        1=>"Max. HP +[n]", 2=>"Max. MP +[n]", 3=>"Vitalit� +[n]", 4=>"Intelligenza +[n]", 5=>"Forza +[n]", 6=>"Destrezza +[n]", 7=>"Velocit� Attacco +[n]%", 8=>"Velocit� Movimento +[n]%", 9=>"Velocit� Magia +[n]%", 10=>"Rigenerazione HP +[n]%", 11=>"Rigenerazione MP +[n]%", 12=>"Forte c. Mezziuomini +[n]%", 13=>"Forte c. Animali +[n]%", 14=>"Forte c. Orchi +[n]%", 15=>"Forte c. Esoterici +[n]%", 16=>"Forte c. Zombie +[n]%", 17=>"Forte c. Diavoli +[n]%", 19=>"Difesa Spada [n]%", 20=>"Difesa Pugnale [n]%", 21=>"Difesa Freccia [n]%", 22=>"Difesa Campana [n]%", 23=>"Difesa Ventaglio [n]%", 24=>"Resistenza Magia +[n]%", 25=>"Resistenza Fuoco +[n]%", 27=>"Resistenza Magia +[n]%", 28=>"Resistenza Veleno +[n]%", 29=>"Poss. di bloccare un att. corporeo [n]%", 30=>"Poss. di schivare frecce [n]%", 37=>"Bonus EXP +[n]%", 38=>"Poss. di far cadere il doppio di Yang [n]%", 39=>"Poss. di far cadere il doppio di oggetti [n]%", 41=>"Poss. su colpi critici +[n]%", 42=>"Poss. su trafiggenti +[n]%", 45=>"Poss. di Stun [n]%", 47=>"Poss. di rallentare [n]%", 53=>"Resistenza Danni Abilit� [n]%", 54=>"Resistenza Danni Medi [n]%", 71=>"Danni Medi [n]%", 72=>"Danni Abilit� [n]%"
    ];

    try {
        $stmt = $database->runQueryPlayer("SELECT vnum, locale_name, type, subtype, size, limittype0, limitvalue0, limittype1, limitvalue1, applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2, value0, value1, value2, value3, value4, value5 FROM item_proto WHERE vnum = ? LIMIT 1");
        $stmt->bindParam(1, $vnum, PDO::PARAM_INT);
        $stmt->execute();
        $item_data = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$item_data) {
            $cached_items[$vnum] = null;
            return null;
        }

        $details = [
            'vnum' => $item_data['vnum'], 'name' => $item_data['locale_name'], 'level' => 0, 'bonuses' => [], 
            'attack_value' => null, 'magic_attack' => null
        ];

        if ($item_data['limittype0'] == 1) {
            $details['level'] = $item_data['limitvalue0'];
        } elseif ($item_data['limittype1'] == 1) {
            $details['level'] = $item_data['limitvalue1'];
        }

        for ($i = 0; $i < 3; $i++) {
            $apply_type = $item_data['applytype' . $i];
            $apply_value = $item_data['applyvalue' . $i];
            if ($apply_type > 0 && isset($bonus_map[$apply_type])) {
                $bonus_text = str_replace('[n]', "<b>{$apply_value}</b>", $bonus_map[$apply_type]);
                $details['bonuses'][] = $bonus_text;
            }
        }

        if ($item_data['type'] == 1) { // Solo per le armi
            if ($item_data['value3'] > 0 || $item_data['value4'] > 0) {
                $details['attack_value'] = "{$item_data['value3']} - {$item_data['value4']}";
            }
            if ($item_data['value5'] > 0) {
                $details['magic_attack'] = "{$item_data['value5']}";
            }
        }
        
        $cached_items[$vnum] = $details;
        return $details;

    } catch (PDOException $e) {
        return null;
    }
}