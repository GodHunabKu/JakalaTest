<?php
if(isset($_POST['time']) && isset($_POST['time2']) && isset($_POST['absorption']))
    update_settings($_POST['time'], $_POST['time2'], $_POST['absorption'], $_POST['name']);

$time = get_settings_time(1);
$time2 = get_settings_time(2);
$absorption = get_settings_time(3);
$item_name_db = get_settings_time(4);
?>

<div class="admin-content-wrapper">
    <!-- Page Header -->
    <div class="admin-page-header">
        <div class="header-center">
            <i class="fas fa-cog"></i>
            <h1>Shop Settings</h1>
            <p>Configure global shop parameters</p>
        </div>
    </div>

    <form action="" method="post" class="admin-form-centered">
        <div class="form-section">
            <div class="section-header">
                <i class="fas fa-sliders-h"></i>
                <h3>Socket Configuration</h3>
            </div>

            <div class="form-row-2">
                <div class="form-group">
                    <label>
                        <i class="fas fa-clock"></i>
                        Item Time Socket
                    </label>
                    <select class="form-select" name="time">
                        <option value="0" <?php if($time==0) print 'selected'; ?>>Socket 0</option>
                        <option value="1" <?php if($time==1) print 'selected'; ?>>Socket 1</option>
                        <option value="2" <?php if($time==2) print 'selected'; ?>>Socket 2</option>
                    </select>
                    <small class="form-hint">Which socket stores item duration</small>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-tshirt"></i>
                        Costume Time Socket
                    </label>
                    <select class="form-select" name="time2">
                        <option value="0" <?php if($time2==0) print 'selected'; ?>>Socket 0</option>
                        <option value="1" <?php if($time2==1) print 'selected'; ?>>Socket 1</option>
                        <option value="2" <?php if($time2==2) print 'selected'; ?>>Socket 2</option>
                    </select>
                    <small class="form-hint">Which socket stores costume duration</small>
                </div>
            </div>

            <div class="form-row-2">
                <div class="form-group">
                    <label>
                        <i class="fas fa-shield-alt"></i>
                        Absorption Bonus Socket
                    </label>
                    <select class="form-select" name="absorption">
                        <option value="0" <?php if($absorption==0) print 'selected'; ?>>Socket 0</option>
                        <option value="1" <?php if($absorption==1) print 'selected'; ?>>Socket 1</option>
                        <option value="2" <?php if($absorption==2) print 'selected'; ?>>Socket 2</option>
                    </select>
                    <small class="form-hint">Which socket stores absorption</small>
                </div>

                <div class="form-group">
                    <label>
                        <i class="fas fa-database"></i>
                        Item Names Source
                    </label>
                    <select class="form-select" name="name">
                        <option value="0" <?php if($item_name_db==0) print 'selected'; ?>>site.db</option>
                        <option value="1" <?php if($item_name_db==1) print 'selected'; ?>>item_proto</option>
                    </select>
                    <small class="form-hint">Where to fetch item names from</small>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" name="set" class="btn-submit">
                    <i class="fas fa-save"></i>
                    <span>Save Settings</span>
                </button>
            </div>
        </div>
    </form>
</div>