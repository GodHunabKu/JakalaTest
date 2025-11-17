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
        let purchaseConfirmed = false;

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

            // Se già confermato, lascia procedere normalmente
            if (purchaseConfirmed) {
                if (buyButton) {
                    buyButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>ELABORAZIONE...</span>';
                    buyButton.style.opacity = '0.8';
                }
                return true; // Procedi con submit normale
            }

            // Altrimenti blocca e mostra modale
            e.preventDefault();
            
            const itemName = document.querySelector('.item-image-box h3, .item-name, h3');
            const itemNameText = itemName ? itemName.textContent.trim() : 'questo oggetto';
            
            showConfirmModal(itemNameText, function() {
                // Setta il flag
                purchaseConfirmed = true;
                
                // Usa requestSubmit per includere i dati del pulsante
                if (purchaseForm.requestSubmit) {
                    purchaseForm.requestSubmit(buyButton);
                } else {
                    // Fallback per browser vecchi
                    purchaseForm.submit();
                }
            });
            
            return false;
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

    // Esponi globalmente per uso esterno
    window.showNotification = showNotification;

    // =================================
    // CONFIRM MODAL SYSTEM
    // =================================
    function showConfirmModal(itemName, onConfirm) {
        // Rimuovi modale esistente se presente
        const existingModal = document.querySelector('.confirm-modal-overlay');
        if (existingModal) {
            existingModal.remove();
        }

        // Crea overlay
        const overlay = document.createElement('div');
        overlay.className = 'confirm-modal-overlay';
        
        // Crea modale
        const modal = document.createElement('div');
        modal.className = 'confirm-modal';
        modal.innerHTML = `
            <div class="confirm-modal-header">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>Conferma Acquisto</h3>
            </div>
            <div class="confirm-modal-body">
                <p class="confirm-item-name">${itemName}</p>
                <p class="confirm-message">Sei sicuro di voler acquistare questo oggetto?<br>L'acquisto verrà elaborato immediatamente.</p>
            </div>
            <div class="confirm-modal-footer">
                <button class="btn-modal-cancel" type="button">
                    <i class="fas fa-times"></i>
                    <span>Annulla</span>
                </button>
                <button class="btn-modal-confirm" type="button">
                    <i class="fas fa-check"></i>
                    <span>Conferma Acquisto</span>
                </button>
            </div>
        `;

        overlay.appendChild(modal);
        document.body.appendChild(overlay);

        // Animazione apertura
        setTimeout(function() {
            overlay.classList.add('show');
        }, 10);

        // Event listeners
        const btnCancel = modal.querySelector('.btn-modal-cancel');
        const btnConfirm = modal.querySelector('.btn-modal-confirm');

        function closeModal() {
            overlay.classList.remove('show');
            setTimeout(function() {
                overlay.remove();
            }, 300);
        }

        btnCancel.addEventListener('click', closeModal);
        overlay.addEventListener('click', function(e) {
            if (e.target === overlay) {
                closeModal();
            }
        });

        btnConfirm.addEventListener('click', function() {
            closeModal();
            if (typeof onConfirm === 'function') {
                onConfirm();
            }
        });

        // ESC key per chiudere
        function handleEscape(e) {
            if (e.key === 'Escape') {
                closeModal();
                document.removeEventListener('keydown', handleEscape);
            }
        }
        document.addEventListener('keydown', handleEscape);
    }

    // Esponi globalmente
    window.showConfirmModal = showConfirmModal;

    // =================================
    // AUTO-DISMISS ALERTS
    // =================================
    const alerts = document.querySelectorAll('.alert-success, .alert-error, .alert-warning, .alert-info, .alert-message, .alert-danger, .alert-inventory-full');
    
    alerts.forEach(function(alert) {
        // Aggiungi icona se non presente
        if (!alert.querySelector('i')) {
            const icon = document.createElement('i');
            
            if (alert.classList.contains('alert-success')) {
                icon.className = 'fas fa-check-circle';
            } else if (alert.classList.contains('alert-error') || alert.classList.contains('alert-danger')) {
                icon.className = 'fas fa-exclamation-circle';
            } else if (alert.classList.contains('alert-warning')) {
                icon.className = 'fas fa-exclamation-triangle';
            } else if (alert.classList.contains('alert-info')) {
                icon.className = 'fas fa-info-circle';
            } else if (alert.classList.contains('alert-inventory-full')) {
                icon.className = 'fas fa-box-open';
            } else {
                icon.className = 'fas fa-bell';
            }
            
            alert.insertBefore(icon, alert.firstChild);
        }

        // Aggiungi close button
        const closeBtn = document.createElement('button');
        closeBtn.className = 'alert-close';
        closeBtn.innerHTML = '<i class="fas fa-times"></i>';
        closeBtn.setAttribute('aria-label', 'Chiudi');
        alert.appendChild(closeBtn);

        // Close button click
        closeBtn.addEventListener('click', function() {
            alert.classList.add('alert-fadeout');
            setTimeout(function() {
                alert.remove();
            }, 300);
        });

        // Auto-dismiss dopo 8 secondi (più lungo per dare tempo di leggere)
        setTimeout(function() {
            if (alert && alert.parentElement) {
                alert.classList.add('alert-fadeout');
                setTimeout(function() {
                    if (alert && alert.parentElement) {
                        alert.remove();
                    }
                }, 300);
            }
        }, 8000);
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
});