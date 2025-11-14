<div class="admin-content-wrapper">
    <!-- Page Header -->
    <div class="admin-page-header">
        <div class="header-center">
            <i class="fas fa-folder-open"></i>
            <h1>Categories Management</h1>
            <p>Manage shop categories and their display</p>
        </div>
    </div>

    <?php
    $remove = isset($_GET['remove']) ? $_GET['remove'] : null;
    if($remove)
        is_delete_category($remove);
    
    if(isset($_POST['edit']))
        is_edit_category($_POST['id'], $_POST['name'.$_POST['id']], $_POST['img'.$_POST['id']]);
        
    if(isset($_POST['add']))
    {
        is_add_category($_POST['name'], $_POST['img']);
        echo '<div class="alert-message alert-success">
                <i class="fas fa-check-circle"></i>
                <span>'.$lang_shop['category_added'].'</span>
                <button onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
              </div>';
    }
    ?>

    <!-- Tabs -->
    <div class="admin-tabs">
        <button class="tab-btn active" onclick="switchTab(event, 'list')">
            <i class="fas fa-list"></i>
            <span>Active Categories</span>
        </button>
        <button class="tab-btn" onclick="switchTab(event, 'add')">
            <i class="fas fa-plus"></i>
            <span>Add New</span>
        </button>
    </div>

    <!-- Tab Content: List -->
    <div id="list" class="tab-content active">
        <div class="table-wrapper">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th style="width: 120px;">Image</th>
                        <th>Category Name</th>
                        <th style="width: 150px;">VNUM</th>
                        <th style="width: 200px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php 
                    $stmt=$database->runQuerySqlite("SELECT id, name, img FROM item_shop_categories ORDER BY id ASC"); 
                    $stmt->execute(); 
                    $result = $stmt->fetchAll(); 
                    
                    if($result && count($result) > 0) { 
                        foreach($result as $key => $row) { 
                    ?>
                    <tr>
                        <form action="" method="post" style="display: contents;">
                            <input type="hidden" name="id" value="<?php print $row['id']; ?>">
                            <td>
                                <div class="category-image-preview">
                                    <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['img']); ?>.png">
                                </div>
                            </td>
                            <td>
                                <input type="text" class="form-input-inline" name="name<?php print $row['id']; ?>" value="<?php print $row['name']; ?>">
                            </td>
                            <td>
                                <input type="number" class="form-input-inline" name="img<?php print $row['id']; ?>" value="<?php print $row['img']; ?>" style="max-width: 120px;">
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <button type="submit" name="edit" class="btn-action btn-primary">
                                        <i class="fas fa-save"></i>
                                        <span>Save</span>
                                    </button>
                                    <a href="<?php print $shop_url.'remove/category/'.$row['id'].'/'; ?>" class="btn-action btn-danger" onclick="return confirm('Delete this category?')">
                                        <i class="fas fa-trash"></i>
                                        <span>Delete</span>
                                    </a>
                                </div>
                            </td>
                        </form>
                    </tr>
                    <?php 
                        } 
                    } else { 
                        echo '<tr><td colspan="4" class="empty-row">No categories found. Add one using the "Add New" tab.</td></tr>';
                    } 
                    ?>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Tab Content: Add -->
    <div id="add" class="tab-content">
        <form action="" method="post" class="admin-form-centered">
            <div class="form-section">
                <div class="section-header">
                    <i class="fas fa-plus-circle"></i>
                    <h3>Add New Category</h3>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-tag"></i>
                        Category Name *
                    </label>
                    <input type="text" class="form-input" name="name" required placeholder="e.g., Weapons, Armor">
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-image"></i>
                        Representative Image VNUM *
                    </label>
                    <input type="number" class="form-input" name="img" required placeholder="e.g., 19">
                    <small class="form-hint">The VNUM of the item to display as category icon</small>
                </div>

                <div class="form-actions">
                    <button type="submit" name="add" class="btn-submit">
                        <i class="fas fa-check"></i>
                        <span>Add Category</span>
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
function switchTab(event, tabName) {
    const tabs = document.querySelectorAll('.tab-content');
    const btns = document.querySelectorAll('.tab-btn');
    
    tabs.forEach(tab => tab.classList.remove('active'));
    btns.forEach(btn => btn.classList.remove('active'));
    
    document.getElementById(tabName).classList.add('active');
    event.currentTarget.classList.add('active');
}
</script>