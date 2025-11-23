<?php
	/*
		Basic Functions Loader
		This file now serves as a loader for the modularized function files.
		Refactored for better maintenance and security.
	*/

	// Load Utils (Helper functions)
	require_once __DIR__ . '/shop_utils.php';

	// Load Account Functions (Login, Coins, Security)
	require_once __DIR__ . '/shop_account.php';

	// Load Item Functions (Search, Display, Management)
	require_once __DIR__ . '/shop_items.php';

	// Load Admin Functions (Settings, Paypal, Categories)
	require_once __DIR__ . '/shop_admin.php';

