/* ==========================================
   ONE SHOP - ENHANCED JAVASCRIPT
   Performance & Accessibility Optimizations
   ========================================== */

document.addEventListener('DOMContentLoaded', function() {

    // =================================
    // LAZY LOADING IMAGES
    // =================================
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;

                    if (img.dataset.src) {
                        img.src = img.dataset.src;
                        img.removeAttribute('data-src');
                    }

                    if (img.dataset.srcset) {
                        img.srcset = img.dataset.srcset;
                        img.removeAttribute('data-srcset');
                    }

                    img.classList.add('loaded');
                    observer.unobserve(img);
                }
            });
        }, {
            rootMargin: '50px 0px',
            threshold: 0.01
        });

        // Applica lazy loading a tutte le immagini con data-src
        document.querySelectorAll('img[data-src]').forEach(img => {
            imageObserver.observe(img);
        });

        // Converti immagini esistenti per lazy loading
        document.querySelectorAll('.item-image img, .category-image img, .showcase-image-wrapper img').forEach(img => {
            if (!img.hasAttribute('data-src') && img.src && !img.complete) {
                const src = img.src;
                img.setAttribute('data-src', src);
                img.src = 'data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 1 1\'%3E%3C/svg%3E';
                imageObserver.observe(img);
            }
        });
    }

    // =================================
    // KEYBOARD NAVIGATION DETECTION
    // =================================
    let isUsingKeyboard = false;

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Tab') {
            isUsingKeyboard = true;
            document.body.classList.add('using-keyboard');
        }
    });

    document.addEventListener('mousedown', function() {
        isUsingKeyboard = false;
        document.body.classList.remove('using-keyboard');
    });

    // =================================
    // MOBILE MENU (da shop-one-v222.js)
    // =================================
    const mobileToggle = document.getElementById('mobileMenuToggle');
    const mobileMenu = document.getElementById('mobileMenu');

    if (mobileToggle && mobileMenu) {
        mobileToggle.addEventListener('click', function() {
            const isOpen = mobileMenu.classList.toggle('active');
            this.classList.toggle('active');

            // Accessibilità: aria-expanded
            this.setAttribute('aria-expanded', isOpen);
            mobileMenu.setAttribute('aria-hidden', !isOpen);

            // Trap focus nel menu quando aperto
            if (isOpen) {
                const focusableElements = mobileMenu.querySelectorAll('a, button, [tabindex]:not([tabindex="-1"])');
                if (focusableElements.length > 0) {
                    focusableElements[0].focus();
                }
            }
        });

        // Close on outside click
        document.addEventListener('click', function(e) {
            if (!mobileMenu.contains(e.target) && !mobileToggle.contains(e.target)) {
                mobileMenu.classList.remove('active');
                mobileToggle.classList.remove('active');
                mobileToggle.setAttribute('aria-expanded', 'false');
                mobileMenu.setAttribute('aria-hidden', 'true');
            }
        });

        // Close on ESC key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && mobileMenu.classList.contains('active')) {
                mobileMenu.classList.remove('active');
                mobileToggle.classList.remove('active');
                mobileToggle.setAttribute('aria-expanded', 'false');
                mobileMenu.setAttribute('aria-hidden', 'true');
                mobileToggle.focus();
            }
        });
    }

    // =================================
    // COUNTDOWN TIMER (Ottimizzato)
    // =================================
    function updateCountdowns() {
        const timers = document.querySelectorAll('.countdown-timer[data-countdown]');
        if (timers.length === 0) return;

        timers.forEach(function(timer) {
            const targetDate = new Date(timer.getAttribute('data-countdown')).getTime();
            const now = new Date().getTime();
            const distance = targetDate - now;

            if (distance < 0) {
                timer.textContent = 'SCADUTO';
                timer.style.color = '#999';
                timer.setAttribute('aria-label', 'Timer scaduto');
                return;
            }

            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

            let timeString = '';
            let ariaLabel = '';

            if (days > 0) {
                timeString = days + 'g ' + hours + 'h';
                ariaLabel = days + ' giorni e ' + hours + ' ore rimanenti';
            } else if (hours > 0) {
                timeString = hours + 'h ' + minutes + 'm';
                ariaLabel = hours + ' ore e ' + minutes + ' minuti rimanenti';
            } else {
                timeString = minutes + 'm ' + seconds + 's';
                ariaLabel = minutes + ' minuti e ' + seconds + ' secondi rimanenti';
            }

            timer.textContent = timeString;
            timer.setAttribute('aria-label', ariaLabel);
        });
    }

    if (document.querySelector('.countdown-timer[data-countdown]')) {
        updateCountdowns();
        // Usa requestAnimationFrame per performance migliori
        let lastUpdate = 0;
        function animateCountdown(timestamp) {
            if (timestamp - lastUpdate >= 1000) {
                updateCountdowns();
                lastUpdate = timestamp;
            }
            requestAnimationFrame(animateCountdown);
        }
        requestAnimationFrame(animateCountdown);
    }

    // =================================
    // PURCHASE FORM VALIDATION
    // =================================
    const purchaseForm = document.getElementById('buy_item_form');

    if (purchaseForm) {
        purchaseForm.addEventListener('submit', function(e) {
            const buyButton = this.querySelector('button[type="submit"]');

            if (buyButton && buyButton.disabled) {
                e.preventDefault();
                showNotification('Fondi insufficienti!', 'error');
                return false;
            }

            const bonusSelects = this.querySelectorAll('select[name^="bonus_"]');
            let hasUnselectedBonus = false;

            bonusSelects.forEach(function(select) {
                if (!select.value || select.value === '' || select.value === '0') {
                    hasUnselectedBonus = true;
                    select.style.borderColor = '#dc3545';
                    select.style.boxShadow = '0 0 0 3px rgba(220, 53, 69, 0.25)';
                    select.setAttribute('aria-invalid', 'true');
                }
            });

            if (hasUnselectedBonus) {
                e.preventDefault();
                showNotification('Seleziona tutti i bonus richiesti!', 'error');

                const firstUnselected = Array.from(bonusSelects).find(s => !s.value || s.value === '' || s.value === '0');
                if (firstUnselected) {
                    firstUnselected.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstUnselected.focus();
                }
                return false;
            }

            const itemName = document.querySelector('.item-image-box h3, .item-name, h3');
            const itemNameText = itemName ? itemName.textContent.trim() : 'questo oggetto';

            if (!confirm('Confermi l\'acquisto di:\n\n' + itemNameText + '\n\nL\'acquisto verrà elaborato immediatamente.')) {
                e.preventDefault();
                return false;
            }

            if (buyButton) {
                buyButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>ELABORAZIONE...</span>';
                buyButton.style.opacity = '0.8';
                buyButton.setAttribute('aria-busy', 'true');
            }

            return true;
        });

        // Reset aria-invalid on change
        const bonusSelects = purchaseForm.querySelectorAll('select[name^="bonus_"]');
        bonusSelects.forEach(function(select) {
            select.addEventListener('change', function() {
                if (this.value && this.value !== '' && this.value !== '0') {
                    this.style.borderColor = '';
                    this.style.boxShadow = '';
                    this.removeAttribute('aria-invalid');
                }
            });
        });
    }

    // =================================
    // NOTIFICATION SYSTEM (Migliorato)
    // =================================
    function showNotification(message, type) {
        const existingNotif = document.querySelector('.shop-notification');
        if (existingNotif) {
            existingNotif.remove();
        }

        const notification = document.createElement('div');
        notification.className = 'shop-notification shop-notification-' + type;
        notification.setAttribute('role', 'alert');
        notification.setAttribute('aria-live', 'assertive');

        const iconMap = {
            'success': 'check-circle',
            'error': 'exclamation-circle',
            'warning': 'exclamation-triangle',
            'info': 'info-circle'
        };

        notification.innerHTML = '<i class="fas fa-' + (iconMap[type] || 'info-circle') + '"></i><span>' + message + '</span>';

        document.body.appendChild(notification);

        setTimeout(function() {
            notification.classList.add('show');
        }, 10);

        setTimeout(function() {
            notification.classList.remove('show');
            setTimeout(function() {
                notification.remove();
            }, 300);
        }, 4000);
    }

    // Esponi globalmente
    window.showNotification = showNotification;

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
    // SMOOTH SCROLL
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
                    // Focus management per accessibilità
                    target.setAttribute('tabindex', '-1');
                    target.focus();
                }
            }
        });
    });

    // =================================
    // PERFORMANCE: Reduce Motion
    // =================================
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
        document.documentElement.style.setProperty('--transition', 'none');
        // Disabilita animazioni per utenti con preferenze reduced motion
        const style = document.createElement('style');
        style.textContent = `
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        `;
        document.head.appendChild(style);
    }

    // =================================
    // PERFORMANCE: Debounce Resize
    // =================================
    let resizeTimer;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            // Eventuali operazioni da fare al resize
            document.body.classList.add('resize-animation-stopper');
            setTimeout(function() {
                document.body.classList.remove('resize-animation-stopper');
            }, 400);
        }, 250);
    });

    // =================================
    // ACCESSIBILITY: Skip Links
    // =================================
    const mainContent = document.querySelector('.shop-main, main, .content-area');
    if (mainContent && !mainContent.id) {
        mainContent.id = 'main-content';
    }

    // =================================
    // ACCESSIBILITY: ARIA Labels
    // =================================
    // Aggiungi aria-labels ai pulsanti senza testo
    document.querySelectorAll('button:not([aria-label]):not(:has(span)):not(:has(strong))').forEach(btn => {
        const icon = btn.querySelector('i');
        if (icon && !btn.textContent.trim()) {
            const classes = icon.className;
            let label = 'Pulsante';

            if (classes.includes('fa-search')) label = 'Cerca';
            else if (classes.includes('fa-shopping-cart')) label = 'Carrello';
            else if (classes.includes('fa-user')) label = 'Profilo utente';
            else if (classes.includes('fa-times')) label = 'Chiudi';
            else if (classes.includes('fa-bars')) label = 'Menu';

            btn.setAttribute('aria-label', label);
        }
    });

    // =================================
    // CONTRAST MODE TOGGLE (BONUS)
    // =================================
    const savedContrast = localStorage.getItem('highContrast');
    if (savedContrast === 'true') {
        document.body.classList.add('high-contrast');
    }

    // Aggiungi toggle contrast (opzionale, può essere aggiunto all'header)
    window.toggleHighContrast = function() {
        const isHigh = document.body.classList.toggle('high-contrast');
        localStorage.setItem('highContrast', isHigh);
    };

    console.log('%c✨ ONE SHOP - Enhanced Edition Loaded!', 'color: #DC143C; font-size: 16px; font-weight: bold;');
    console.log('%c🚀 Performance: Lazy Loading Active', 'color: #2ed573; font-size: 12px;');
    console.log('%c♿ Accessibility: ARIA & Keyboard Navigation Active', 'color: #636efa; font-size: 12px;');
});

// =================================
// PERFORMANCE: Prefetch on Hover
// =================================
document.addEventListener('mouseover', function(e) {
    const link = e.target.closest('a[href]');
    if (link && link.hostname === window.location.hostname && !link.dataset.prefetched) {
        const prefetchLink = document.createElement('link');
        prefetchLink.rel = 'prefetch';
        prefetchLink.href = link.href;
        document.head.appendChild(prefetchLink);
        link.dataset.prefetched = 'true';
    }
}, true);

// =================================
// SERVICE WORKER (opzionale, per PWA)
// =================================
if ('serviceWorker' in navigator) {
    // Decommentare se si vuole aggiungere PWA
    // navigator.serviceWorker.register('/sw.js').catch(function(error) {
    //     console.log('Service Worker registration failed:', error);
    // });
}
