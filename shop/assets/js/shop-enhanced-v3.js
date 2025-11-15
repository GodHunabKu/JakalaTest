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
    // PURCHASE FORM - Gestito da shop-one-v222.js
    // =================================
    // NOTA: Il form di acquisto è già gestito in shop-one-v222.js
    // con validazione completa, conferma acquisto e feedback visivo.
    // NON duplicare i listener per evitare conflitti!

    // =================================
    // NOTIFICATION SYSTEM - Gestito da shop-one-v222.js
    // =================================
    // NOTA: La funzione showNotification è già definita in shop-one-v222.js
    // e viene usata per le notifiche del form di acquisto.
    // Non ridefinirla per evitare conflitti!

    // =================================
    // AUTO-DISMISS ALERTS - Gestito da shop-one-v222.js
    // =================================
    // NOTA: Gli alert vengono già auto-dismessi in shop-one-v222.js
    // dopo 5 secondi. Non duplicare il codice!

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
