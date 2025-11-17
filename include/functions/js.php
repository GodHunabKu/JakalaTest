<?php
	// Countdown timers - ora gestiti da shop-one.js
	// Non serve più jQuery o librerie esterne!

	if($current_page=='item' && $item[0]['type']==3)
	{
?>
	<script>
		// Sistema di selezione bonus (vanilla JavaScript)
		var used = [];

		function isset(variable) {
			return typeof variable !== typeof undefined;
		}

		function use(select) {
			var parent = select.parentNode;

			// Marca i bonus usati
			for (var i = 0; i < parent.children.length; ++i) {
				if (parent.children[i].value != '') {
					used[parent.children[i].value] = 0;
				}
			}

			// Ottieni tutti i select (vanilla JS)
			var selects = document.querySelectorAll('select');

			// Aggiorna visibilità opzioni
			for (var i = 0; i < selects.length; ++i) {
				for (var j = 0; j < selects[i].options.length; ++j) {
					if(selects[i].options[j].selected) {
						selects[i].options[j].hidden = false;
						selects[i].options[j].disabled = false;
					}
					else if(isset(used[selects[i].options[j].value])) {
						selects[i].options[j].hidden = true;
						selects[i].options[j].disabled = true;
					}
					else {
						selects[i].options[j].hidden = false;
						selects[i].options[j].disabled = false;
					}
				}
			}
			used = [];
		}
	</script>
<?php } ?>
