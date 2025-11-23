<div class="media-section">
    <div class="images">
        <h3 class="section-title"><i class="fa fa-list-ul"></i> <a href="<?php print $shop_url; ?>"><?php print $lang_shop['site_title']; ?></a> / <?php print ucfirst($current_page); ?></h3>
		<?php
			$remove = isset($_GET['remove']) ? $_GET['remove'] : null;
			if($remove)
				is_delete_category($remove);
			
			if(isset($_POST['edit'])) {
                $id = $_POST['id'];
                // Handle File Upload
                if(isset($_FILES['img_file'.$id]) && $_FILES['img_file'.$id]['error'] == 0) {
                    $target_dir = "images/categories/";
                    if (!file_exists($target_dir)) {
                        mkdir($target_dir, 0777, true);
                    }
                    $target_file = $target_dir . $id . ".png";
                    
                    // Check if image file is a actual image or fake image
                    $check = getimagesize($_FILES['img_file'.$id]["tmp_name"]);
                    if($check !== false) {
                        if(move_uploaded_file($_FILES['img_file'.$id]["tmp_name"], $target_file)) {
                            // Success
                        }
                    }
                }
                
				is_edit_category($_POST['id'], $_POST['name'.$_POST['id']], $_POST['img'.$_POST['id']]);
            }
				
			if(isset($_POST['add']))
			{
				is_add_category($_POST['name'], $_POST['img']);
                
                // Get the ID of the newly created category
                $new_id = $database->getSqliteBonuslastInsertId();
                
                // Handle File Upload for New Category
                if(isset($_FILES['img_file_new']) && $_FILES['img_file_new']['error'] == 0) {
                    $target_dir = "images/categories/";
                    if (!file_exists($target_dir)) {
                        mkdir($target_dir, 0777, true);
                    }
                    $target_file = $target_dir . $new_id . ".png";
                    
                    $check = getimagesize($_FILES['img_file_new']["tmp_name"]);
                    if($check !== false) {
                        move_uploaded_file($_FILES['img_file_new']["tmp_name"], $target_file);
                    }
                }
                
				print '<div class="alert alert-dismissible alert-success">
						<button type="button" class="close" data-dismiss="alert">×</button>
						'.$lang_shop['category_added'].'
					</div>';
			}
		?>
        <div class="panel panel-info">
            <div class="panel-heading">
                <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#active" role="tab">
                            <?php print $lang_shop['is_tab1']; ?>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-toggle="tab" href="#add" role="tab">
                            <?php print $lang_shop['is_tab2']; ?>
                        </a>
                    </li>
                </ul>

            </div>
            <div class="panel-body">

                <div class="tab-content">
                    <div class="tab-pane active" id="active" role="tabpanel">

                        <table class="table table-striped table-hover ">
                            <thead>
                                <tr>
                                    <th>img</th>
                                    <th>
                                        <?php print $lang_shop['name']; ?>
                                    </th>
                                    <th>#</th>
                                    <th>#</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php $stmt=$database->runQuerySqlite("SELECT id, name, img FROM item_shop_categories ORDER BY id ASC"); $stmt->execute(); $result = $stmt->fetchAll(); if($result && count($result) > 0) { foreach($result as $key => $row) { ?>
                                <form action="" method="post" class="form-horizontal" enctype="multipart/form-data">
                                    <tr>
                                        <input type="hidden" name="id" value="<?php print $row['id']; ?>">
                                        <td>
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <!-- FIX: Image path updated to use ID with cache busting -->
                                                    <img src="<?php print $shop_url; ?>images/categories/<?php print $row['id']; ?>.png?v=<?php echo time(); ?>" style="max-width: 50px; max-height: 50px;" onerror="this.style.display='none'">
                                                </div>
                                                <div class="col-md-9">
                                                    <!-- Hidden input to preserve old img value logic if needed -->
                                                    <input type="hidden" name="img<?php print $row['id']; ?>" value="<?php print $row['img']; ?>">
                                                    
                                                    <label class="btn btn-outline-primary btn-sm" style="cursor: pointer; margin-bottom: 0;">
                                                        <i class="fa fa-upload"></i> Scegli File
                                                        <input type="file" name="img_file<?php print $row['id']; ?>" style="display: none;" onchange="$(this).next('.file-name').text(this.files[0].name)">
                                                        <span class="file-name" style="margin-left: 5px; font-size: 11px; color: #666;"></span>
                                                    </label>
                                                    
                                                    <div class="text-muted" style="font-size: 10px; margin-top: 2px;">
                                                        Verrà salvato come: <?php print $row['id']; ?>.png
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <input class="admin-input-width form-control" name="name<?php print $row['id']; ?>" type="text" value="<?php print $row['name']; ?>">
                                        </td>
                                        <td>
                                            <input class="btn btn-primary btn-sm" name="edit" value="<?php print $lang_shop['edit']; ?>" type="submit">
                                        </td>
                                        <td>
                                            <a href="<?php print $shop_url.'remove/category/'.$row['id'].'/'; ?>" class="btn btn-danger btn-sm">
                                                <?php print $lang_shop['item_remove']; ?>
                                            </a>
                                        </td>
                                    </tr>
                                </form>
                                <?php } } else print 'Nothing found'; ?>
                            </tbody>
                        </table>

                    </div>
                    <div class="tab-pane" id="add" role="tabpanel">
                        </br>
                        <form action="" method="post" class="form-horizontal" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-3"></div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label" for="focusedInput">
                                            <?php print $lang_shop['category_name']; ?>
                                        </label>
                                        <input class="form-control" name="name" type="text" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="control-label">Immagine Categoria</label>
                                        <div class="input-group" style="width: 100%;">
                                            <label class="btn btn-info btn-block" style="cursor: pointer; color: white;">
                                                <i class="fa fa-upload"></i> Seleziona Immagine dal PC
                                                <input type="file" name="img_file_new" style="display: none;" onchange="$(this).next('.file-name-new').text(' - ' + this.files[0].name)">
                                                <span class="file-name-new"></span>
                                            </label>
                                        </div>
                                        <small class="form-text text-muted">Non devi rinominare nulla! Carica l'immagine e il sistema farà il resto.</small>
                                    </div>

                                    <!-- Legacy img field, hidden or auto-filled -->
                                    <input type="hidden" name="img" value="">

                                    <div class="form-group">
                                        <input class="btn btn-success btn-block" name="add" value="<?php print $lang_shop['add_category']; ?>" type="submit">
                                    </div>
                                </div>
                                <div class="col-md-3"></div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>