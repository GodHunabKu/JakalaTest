<?php
    // ============================================
    // ONE SERVER - LOGIN PAGE (REDESIGNED)
    // ============================================

    if(isset($_POST['username'], $_POST['password'])) {
        if(login($_POST['username'], $_POST['password'], 1)) {
            print '<div class="alert alert-dismissible alert-success">
                    <button type="button" class="close" data-dismiss="alert">×</button>
                    '.$lang_shop['login_success'].'
                </div>';
            // Refresh automatico per aggiornare la sessione
            print '<script>setTimeout(function(){ window.location.href = "'.$shop_url.'"; }, 1000);</script>';
        }
        else {
            print '<div class="alert alert-dismissible alert-danger">
                    <button type="button" class="close" data-dismiss="alert">×</button>
                    '.$lang_shop['login_fail'].'
                </div>';
        }
    }
?>

<div class="one-login-container">
    <div class="one-login-card">
        <div class="one-login-header">
            <div class="icon-circle">
                <i class="fa fa-user"></i>
            </div>
            <h2><?php print $lang_shop['login']; ?></h2>
            <p>Accedi al pannello utente</p>
        </div>

        <form id="login-form" action="" method="post" role="form">
            <div class="one-input-group">
                <div class="input-icon"><i class="fa fa-user"></i></div>
                <input name="username" id="username" tabindex="1" class="one-form-control" 
                       pattern=".{5,64}" maxlength="64" 
                       placeholder="<?php print $lang_shop['name_login']; ?>" 
                       required="" type="text" autocomplete="off">
            </div>

            <div class="one-input-group">
                <div class="input-icon"><i class="fa fa-lock"></i></div>
                <input name="password" id="password" tabindex="2" class="one-form-control" 
                       pattern=".{5,16}" maxlength="16" 
                       placeholder="<?php print $lang_shop['password']; ?>" 
                       required="" type="password">
            </div>

            <button type="submit" name="login" id="login" class="one-btn-login">
                <i class="fa fa-sign-in"></i> <?php print $lang_shop['login']; ?>
            </button>
        </form>
        
        <div class="one-login-footer">
            <p>Non hai un account? <a href="<?php print $shop_url; ?>register">Registrati ora</a></p>
        </div>
    </div>
</div>

<style>
/* Login Page Styles */
.one-login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 60vh;
    padding: 40px 20px;
}

.one-login-card {
    background: linear-gradient(145deg, #1a1a1a, #0a0a0a);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 20px;
    padding: 40px;
    width: 100%;
    max-width: 450px;
    box-shadow: 0 20px 50px rgba(0,0,0,0.5);
    position: relative;
    overflow: hidden;
    animation: fadeInUp 0.5s ease-out;
}

.one-login-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background: linear-gradient(90deg, #ff0000, #8a0000);
}

.one-login-header {
    text-align: center;
    margin-bottom: 35px;
}

.icon-circle {
    width: 80px;
    height: 80px;
    background: rgba(255,0,0,0.1);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 20px auto;
    border: 2px solid rgba(255,0,0,0.2);
}

.one-login-header i {
    font-size: 2.5rem;
    color: #ff0000;
    text-shadow: 0 0 20px rgba(255,0,0,0.5);
}

.one-login-header h2 {
    color: #fff;
    font-size: 2rem;
    margin: 0 0 5px 0;
    text-transform: uppercase;
    letter-spacing: 2px;
    font-weight: 700;
}

.one-login-header p {
    color: rgba(255,255,255,0.5);
    margin: 0;
    font-size: 0.95rem;
}

.one-input-group {
    position: relative;
    margin-bottom: 20px;
}

.input-icon {
    position: absolute;
    left: 20px;
    top: 50%;
    transform: translateY(-50%);
    color: #666;
    font-size: 1.1rem;
    transition: color 0.3s;
    z-index: 2;
}

.one-form-control {
    width: 100%;
    background: rgba(0,0,0,0.3);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 50px;
    padding: 15px 20px 15px 55px;
    color: #fff;
    font-size: 1rem;
    transition: all 0.3s;
}

.one-form-control:focus {
    outline: none;
    border-color: #ff0000;
    background: rgba(0,0,0,0.5);
    box-shadow: 0 0 15px rgba(255,0,0,0.2);
}

.one-form-control:focus + .input-icon,
.one-input-group:focus-within .input-icon {
    color: #ff0000;
}

.one-btn-login {
    width: 100%;
    padding: 16px;
    background: linear-gradient(135deg, #ff0000 0%, #8a0000 100%);
    color: #fff;
    border: none;
    border-radius: 50px;
    font-size: 1.1rem;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 1px;
    cursor: pointer;
    transition: all 0.3s;
    margin-top: 15px;
    box-shadow: 0 10px 20px rgba(255,0,0,0.2);
}

.one-btn-login:hover {
    transform: translateY(-2px);
    box-shadow: 0 15px 30px rgba(255,0,0,0.4);
    background: linear-gradient(135deg, #ff1a1a 0%, #a30000 100%);
}

.one-login-footer {
    text-align: center;
    margin-top: 25px;
    padding-top: 20px;
    border-top: 1px solid rgba(255,255,255,0.05);
}

.one-login-footer p {
    color: rgba(255,255,255,0.5);
    margin: 0;
}

.one-login-footer a {
    color: #fff;
    text-decoration: none;
    font-weight: 600;
    transition: color 0.3s;
    margin-left: 5px;
}

.one-login-footer a:hover {
    color: #ff0000;
    text-decoration: underline;
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
