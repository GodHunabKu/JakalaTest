document.addEventListener('DOMContentLoaded', function() {
    // Mobile Menu Toggle
    const mobileToggle = document.getElementById('mobileMenuToggle');
    const mobileMenu = document.getElementById('mobileMenu');

    if (mobileToggle && mobileMenu) {
        mobileToggle.addEventListener('click', function() {
            mobileMenu.classList.toggle('active');
            this.classList.toggle('active');
        });

        // Close on outside click
        document.addEventListener('click', function(e) {
            if (!mobileMenu.contains(e.target) && !mobileToggle.contains(e.target)) {
                mobileMenu.classList.remove('active');
                mobileToggle.classList.remove('active');
            }
        });
    }

    // =================================
    // COUNTDOWN TIMER
    // =================================
    function updateCountdowns() {
        const timers = document.querySelectorAll('.countdown-timer[data-countdown]');

        timers.forEach(function(timer) {
            const targetDate = new Date(timer.getAttribute('data-countdown')).getTime();
            const now = new Date().getTime();
            const distance = targetDate - now;

            if (distance < 0) {
                timer.textContent = 'SCADUTO';
                timer.style.color = '#999';
                return;
            }

            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

            let timeString = '';
            if (days > 0) {
                timeString = days + 'g ' + hours + 'h';
            } else if (hours > 0) {
                timeString = hours + 'h ' + minutes + 'm';
            } else {
                timeString = minutes + 'm ' + seconds + 's';
            }

            timer.textContent = timeString;
        });
    }

    // Aggiorna countdown ogni secondo se presenti
    if (document.querySelector('.countdown-timer[data-countdown]')) {
        updateCountdowns();
        setInterval(updateCountdowns, 1000);
    }

    // =================================
    // PURCHASE FORM VALIDATION & CONFIRMATION
    // =================================
    const purchaseForm = document.getElementById('buy_item_form');

    if (purchaseForm) {
        purchaseForm.addEventListener('submit', function(e) {
            const buyButton = this.querySelector('button[type="submit"]');

            // Se il pulsante è disabilitato, blocca l'invio
            if (buyButton && buyButton.disabled) {
                e.preventDefault();
                showNotification('Fondi insufficienti!', 'error');
                return false;
            }

            // Validazione bonus selection se presente
            const bonusSelects = this.querySelectorAll('select[name^="bonus_"]');
            let hasUnselectedBonus = false;

            bonusSelects.forEach(function(select) {
                if (!select.value || select.value === '' || select.value === '0') {
                    hasUnselectedBonus = true;
                    select.style.borderColor = '#dc3545';
                    select.style.boxShadow = '0 0 0 3px rgba(220, 53, 69, 0.25)';
                }
            });

            if (hasUnselectedBonus) {
                e.preventDefault();
                showNotification('Seleziona tutti i bonus richiesti!', 'error');

                // Scroll al primo select non selezionato
                const firstUnselected = Array.from(bonusSelects).find(s => !s.value || s.value === '' || s.value === '0');
                if (firstUnselected) {
                    firstUnselected.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                return false;
            }

            // Conferma acquisto
            const itemName = document.querySelector('.item-image-box h3, .item-name, h3');
            const itemNameText = itemName ? itemName.textContent.trim() : 'questo oggetto';

            if (!confirm('Confermi l\'acquisto di:\n\n' + itemNameText + '\n\nL\'acquisto verrà elaborato immediatamente.')) {
                e.preventDefault();
                return false;
            }

            // Mostra feedback visivo SENZA disabilitare il pulsante
            // (il campo hidden 'buy' gestisce l'invio)
            if (buyButton) {
                buyButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>ELABORAZIONE...</span>';
                buyButton.style.opacity = '0.8';
            }

            // Lascia che il form si invii normalmente
            return true;
        });

        // Reset stile quando si seleziona un bonus
        const bonusSelects = purchaseForm.querySelectorAll('select[name^="bonus_"]');
        bonusSelects.forEach(function(select) {
            select.addEventListener('change', function() {
                if (this.value && this.value !== '' && this.value !== '0') {
                    this.style.borderColor = '';
                    this.style.boxShadow = '';
                }
            });
        });
    }

    // =================================
    // NOTIFICATION SYSTEM
    // =================================
    function showNotification(message, type) {
        // Rimuovi notifiche esistenti
        const existingNotif = document.querySelector('.shop-notification');
        if (existingNotif) {
            existingNotif.remove();
        }

        const notification = document.createElement('div');
        notification.className = 'shop-notification shop-notification-' + type;
        notification.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle') + '"></i><span>' + message + '</span>';

        document.body.appendChild(notification);

        // Mostra con animazione
        setTimeout(function() {
            notification.classList.add('show');
        }, 10);

        // Rimuovi dopo 4 secondi
        setTimeout(function() {
            notification.classList.remove('show');
            setTimeout(function() {
                notification.remove();
            }, 300);
        }, 4000);
    }

    // =================================
    // AUTO-DISMISS ALERTS
    // =================================
    const alerts = document.querySelectorAll('.alert-success, .alert-error, .alert-warning, .alert-info, .alert-message, .alert-danger');
    alerts.forEach(function(alert) {
        setTimeout(function() {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-20px)';
            setTimeout(function() {
                alert.remove();
            }, 300);
        }, 5000);
    });

    // =================================
    // SMOOTH SCROLL FOR ANCHORS
    // =================================
    document.querySelectorAll('a[href^="#"]').forEach(function(anchor) {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href !== '#' && href !== '#!') {
                const target = document.querySelector(href);
                if (target) {
                    e.preventDefault();
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            }
        });
    });

    // =================================
    // BONUS SELECTION VALIDATION (se presente)
    // =================================
    const bonusSelects = document.querySelectorAll('.bonus-select-input');
    if (bonusSelects.length > 0 && purchaseForm) {
        purchaseForm.addEventListener('submit', function(e) {
            let allSelected = true;
            bonusSelects.forEach(function(select) {
                if (select.value === '' || select.value === '0') {
                    allSelected = false;
                    select.style.borderColor = '#dc3545';
                }
            });

            if (!allSelected) {
                e.preventDefault();
                showNotification('Seleziona tutti i bonus richiesti!', 'error');
                return false;
            }
        });

        // Reset border on change
        bonusSelects.forEach(function(select) {
            select.addEventListener('change', function() {
                this.style.borderColor = '';
            });
        });
    }

    console.log('%c🛒 ONE SHOP - Ultimate Edition Loaded!', 'color: #DC143C; font-size: 16px; font-weight: bold;');
});