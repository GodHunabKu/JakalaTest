                    <div class="list-table">
                        <h3 class="title"><?php print $lang_shop['last_bought']; ?></h3>
                        <table>
							<?php
								foreach(last_bought() as $last) {
							?>
                            <tr>
                                <td class="border-right">
                                    <a href="<?php print $shop_url.'item/'.$last['id'].'/'; ?>" class="text-white-link" style="display: flex; align-items: center;">
                                        <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($last['vnum']); ?>.png" 
                                             style="width: 32px; height: 32px; margin-right: 8px; object-fit: contain;" 
                                             onerror="this.src='<?php print $shop_url; ?>images/items/default.png'">
                                        <?php if(!$item_name_db) print get_item_name($last['vnum']); else print get_item_name_locale_name($last['vnum']); ?>
                                    </a>
                                </td>
                                <td><a href="<?php print $shop_url.'item/'.$last['id'].'/'; ?>" class="text-white-link"><?php print $last['coins'].' MD'; ?></a></td>
                            </tr>
								<?php } ?>
                        </table>
                    </div>