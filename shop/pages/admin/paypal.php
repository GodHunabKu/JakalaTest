<div class="admin-content-wrapper">
    <!-- Page Header -->
    <div class="admin-page-header">
        <div class="header-center">
            <i class="fab fa-paypal"></i>
            <h1>PayPal Packages</h1>
            <p>Manage coin packages for PayPal purchases</p>
        </div>
    </div>

    <?php
    $remove = isset($_GET['remove']) ? $_GET['remove'] : null;
    if($remove)
        is_delete_paypal($remove);
    
    if(isset($_POST['edit']))
        is_edit_paypal($_POST['id'], $_POST['price'.$_POST['id']], $_POST['coins'.$_POST['id']]);
        
    if(isset($_POST['add']))
        is_add_paypal($_POST['price'], $_POST['coins']);
    ?>

    <!-- Tabs -->
    <div class="admin-tabs">
        <button class="tab-btn active" onclick="switchTab(event, 'list')">
            <i class="fas fa-list"></i>
            <span>Active Packages</span>
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
                        <th>Price (€)</th>
                        <th>MD Coins</th>
                        <th style="width: 200px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $paypal_list = get_all_paypal();
                    
                    if($paypal_list && count($paypal_list) > 0) {
                        foreach($paypal_list as $key => $row) {
                    ?>
                    <tr>
                        <form action="" method="post" style="display: contents;">
                            <input type="hidden" name="id" value="<?php print $row['id']; ?>">
                            <td>
                                <div class="price-input-group">
                                    <span class="input-prefix">€</span>
                                    <input type="text" class="form-input-inline" name="price<?php print $row['id']; ?>" value="<?php print $row['price']; ?>">
                                </div>
                            </td>
                            <td>
                                <div class="coins-input-group">
                                    <input type="text" class="form-input-inline" name="coins<?php print $row['id']; ?>" value="<?php print $row['coins']; ?>">
                                    <span class="input-suffix">MD</span>
                                </div>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <button type="submit" name="edit" class="btn-action btn-primary">
                                        <i class="fas fa-save"></i>
                                        <span>Save</span>
                                    </button>
                                    <a href="<?php print $shop_url; ?>admin/paypal/<?php print $row['id']; ?>" class="btn-action btn-danger" onclick="return confirm('Delete this package?')">
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
                        echo '<tr><td colspan="3" class="empty-row">No packages found. Add one using the "Add New" tab.</td></tr>';
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
                    <h3>Add New Package</h3>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-euro-sign"></i>
                        Price (EUR) *
                    </label>
                    <input type="number" class="form-input" name="price" required placeholder="10.00" step="0.01">
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-coins"></i>
                        MD Coins Amount *
                    </label>
                    <input type="number" class="form-input" name="coins" required placeholder="1000">
                </div>

                <div class="form-actions">
                    <button type="submit" name="add" class="btn-submit">
                        <i class="fas fa-check"></i>
                        <span>Add Package</span>
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