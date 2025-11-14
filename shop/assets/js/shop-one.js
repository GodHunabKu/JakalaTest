/**
 * ONE SHOP - JavaScript Unificato e Ottimizzato
 * Gestisce tutte le funzionalità interattive dello shop
 */

(function() {
    'use strict';

    // Configurazione
    const CONFIG = {
        mobileBreakpoint: 992,
        animationDuration: 300,
        countdownInterval: 1000
    };

    // Stato applicazione
    const state = {
        isMobile: window.innerWidth <= CONFIG.mobileBreakpoint,
        activeCountdowns: new Map()
    };

    /**
     * Inizializzazione al caricamento del DOM
     */
    document.addEventListener('DOMContentLoaded', function() {
        initMobileMenu();
        initCountdownTimers();
        initImageLazyLoading();
        initSmoothScrolling();
        initFormValidation();
        initTooltips();
        initToggleAllBonuses();
        initButtonAnimations();
        initTableInteractions();
        initPackageCards();

        console.log('%c⚔️ ONE SHOP - Ultimate Edition Loaded!',
            'color: #DC143C; font-size: 16px; font-weight: bold; text-shadow: 0 0 10px rgba(220, 20, 60, 0.5);');
    });

    /**
     * Gestione resize finestra
     */
    let resizeTimeout;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimeout);
        resizeTimeout = setTimeout(function() {
            const wasMobile = state.isMobile;
            state.isMobile = window.innerWidth <= CONFIG.mobileBreakpoint;

            if (wasMobile !== state.isMobile) {
                handleResponsiveChange();
            }
        }, 250);
    });

    /**
     * Mobile Menu Toggle
     */
    function initMobileMenu() {
        const mobileToggle = document.getElementById('mobileMenuToggle');
        const mobileMenu = document.getElementById('mobileMenu');

        if (!mobileToggle || !mobileMenu) return;

        mobileToggle.addEventListener('click', function(e) {
            e.stopPropagation();
            toggleMobileMenu();
        });

        // Chiudi menu cliccando fuori
        document.addEventListener('click', function(e) {
            if (mobileMenu.classList.contains('active') &&
                !mobileMenu.contains(e.target) &&
                !mobileToggle.contains(e.target)) {
                closeMobileMenu();
            }
        });

        // Chiudi menu su link click
        const menuLinks = mobileMenu.querySelectorAll('a');
        menuLinks.forEach(link => {
            link.addEventListener('click', function() {
                closeMobileMenu();
            });
        });
    }

    function toggleMobileMenu() {
        const mobileToggle = document.getElementById('mobileMenuToggle');
        const mobileMenu = document.getElementById('mobileMenu');

        mobileMenu.classList.toggle('active');
        mobileToggle.classList.toggle('active');
        document.body.classList.toggle('menu-open');
    }

    function closeMobileMenu() {
        const mobileToggle = document.getElementById('mobileMenuToggle');
        const mobileMenu = document.getElementById('mobileMenu');

        mobileMenu.classList.remove('active');
        mobileToggle.classList.remove('active');
        document.body.classList.remove('menu-open');
    }

    /**
     * Countdown Timers per offerte a tempo
     */
    function initCountdownTimers() {
        const countdownElements = document.querySelectorAll('.countdown-timer[data-countdown]');

        countdownElements.forEach(element => {
            const targetDate = new Date(element.dataset.countdown).getTime();

            if (isNaN(targetDate)) {
                console.warn('Invalid countdown date:', element.dataset.countdown);
                return;
            }

            // Avvia countdown
            const countdownId = startCountdown(element, targetDate);
            state.activeCountdowns.set(element, countdownId);
        });
    }

    function startCountdown(element, targetDate) {
        const updateCountdown = () => {
            const now = new Date().getTime();
            const distance = targetDate - now;

            if (distance < 0) {
                element.textContent = 'SCADUTO';
                element.classList.add('expired');
                clearInterval(intervalId);
                state.activeCountdowns.delete(element);
                return;
            }

            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);

            let timeString = '';
            if (days > 0) {
                timeString = `${days}g ${hours}h ${minutes}m`;
            } else if (hours > 0) {
                timeString = `${hours}h ${minutes}m ${seconds}s`;
            } else {
                timeString = `${minutes}m ${seconds}s`;
            }

            element.textContent = timeString;
        };

        // Update immediato
        updateCountdown();

        // Update ogni secondo
        const intervalId = setInterval(updateCountdown, CONFIG.countdownInterval);
        return intervalId;
    }

    /**
     * Lazy Loading Immagini
     */
    function initImageLazyLoading() {
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        if (img.dataset.src) {
                            img.src = img.dataset.src;
                            img.removeAttribute('data-src');
                            img.classList.add('loaded');
                            observer.unobserve(img);
                        }
                    }
                });
            }, {
                rootMargin: '50px 0px',
                threshold: 0.01
            });

            const lazyImages = document.querySelectorAll('img[data-src]');
            lazyImages.forEach(img => imageObserver.observe(img));
        } else {
            // Fallback per browser vecchi
            const lazyImages = document.querySelectorAll('img[data-src]');
            lazyImages.forEach(img => {
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
            });
        }
    }

    /**
     * Smooth Scrolling per anchor links
     */
    function initSmoothScrolling() {
        const anchorLinks = document.querySelectorAll('a[href^="#"]:not([href="#"])');

        anchorLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                const targetId = this.getAttribute('href').substring(1);
                const targetElement = document.getElementById(targetId);

                if (targetElement) {
                    e.preventDefault();

                    const offsetTop = targetElement.getBoundingClientRect().top + window.pageYOffset - 100;

                    window.scrollTo({
                        top: offsetTop,
                        behavior: 'smooth'
                    });
                }
            });
        });
    }

    /**
     * Form Validation Base
     */
    function initFormValidation() {
        const forms = document.querySelectorAll('form[data-validate]');

        forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                if (!validateForm(this)) {
                    e.preventDefault();
                    return false;
                }
            });
        });
    }

    function validateForm(form) {
        let isValid = true;
        const requiredFields = form.querySelectorAll('[required]');

        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                showFieldError(field, 'Questo campo è obbligatorio');
                isValid = false;
            } else {
                clearFieldError(field);
            }
        });

        return isValid;
    }

    function showFieldError(field, message) {
        field.classList.add('error');

        let errorElement = field.parentElement.querySelector('.field-error');
        if (!errorElement) {
            errorElement = document.createElement('span');
            errorElement.className = 'field-error';
            field.parentElement.appendChild(errorElement);
        }
        errorElement.textContent = message;
    }

    function clearFieldError(field) {
        field.classList.remove('error');

        const errorElement = field.parentElement.querySelector('.field-error');
        if (errorElement) {
            errorElement.remove();
        }
    }

    /**
     * Tooltips
     */
    function initTooltips() {
        const tooltipElements = document.querySelectorAll('[data-tooltip]');

        tooltipElements.forEach(element => {
            element.addEventListener('mouseenter', function() {
                showTooltip(this);
            });

            element.addEventListener('mouseleave', function() {
                hideTooltip(this);
            });
        });
    }

    function showTooltip(element) {
        const tooltipText = element.dataset.tooltip;
        if (!tooltipText) return;

        const tooltip = document.createElement('div');
        tooltip.className = 'tooltip';
        tooltip.textContent = tooltipText;
        tooltip.style.position = 'absolute';
        tooltip.style.zIndex = '10000';

        document.body.appendChild(tooltip);

        const rect = element.getBoundingClientRect();
        tooltip.style.left = rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2) + 'px';
        tooltip.style.top = (rect.top - tooltip.offsetHeight - 10) + 'px';

        element._tooltip = tooltip;

        setTimeout(() => tooltip.classList.add('show'), 10);
    }

    function hideTooltip(element) {
        if (element._tooltip) {
            element._tooltip.classList.remove('show');
            setTimeout(() => {
                if (element._tooltip && element._tooltip.parentElement) {
                    element._tooltip.remove();
                }
                delete element._tooltip;
            }, 200);
        }
    }

    /**
     * Gestione cambio responsive
     */
    function handleResponsiveChange() {
        if (!state.isMobile) {
            closeMobileMenu();
        }
    }

    /**
     * Utility: Debounce
     */
    function debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    /**
     * Utility: Format Number
     */
    function formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    /**
     * Toggle All Bonuses (per pagina add_items_bonus)
     */
    function initToggleAllBonuses() {
        const toggleBtn = document.querySelector('.btn-toggle-all');
        if (!toggleBtn) return;

        toggleBtn.addEventListener('click', function() {
            const checkboxes = document.querySelectorAll('input[type="checkbox"][name^="bonus"]');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);

            checkboxes.forEach(checkbox => {
                checkbox.checked = !allChecked;

                // Trigger change event per eventuali listener
                const event = new Event('change', { bubbles: true });
                checkbox.dispatchEvent(event);
            });

            // Update button text
            this.innerHTML = allChecked
                ? '<i class="fas fa-check-square"></i> Seleziona Tutti'
                : '<i class="fas fa-square"></i> Deseleziona Tutti';
        });
    }

    /**
     * Button Animations - Effetti click per tutti i pulsanti
     */
    function initButtonAnimations() {
        const buttons = document.querySelectorAll('.btn-submit, .btn-package, .btn-purchase-main, .btn-admin');

        buttons.forEach(button => {
            button.addEventListener('click', function(e) {
                // Ripple effect
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;

                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = x + 'px';
                ripple.style.top = y + 'px';
                ripple.className = 'ripple-effect';

                this.appendChild(ripple);

                setTimeout(() => ripple.remove(), 600);
            });
        });

        // Add ripple CSS dynamically if not present
        if (!document.getElementById('ripple-styles')) {
            const style = document.createElement('style');
            style.id = 'ripple-styles';
            style.textContent = `
                .ripple-effect {
                    position: absolute;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.6);
                    transform: scale(0);
                    animation: ripple-animation 0.6s ease-out;
                    pointer-events: none;
                }
                @keyframes ripple-animation {
                    to {
                        transform: scale(2);
                        opacity: 0;
                    }
                }
            `;
            document.head.appendChild(style);
        }
    }

    /**
     * Table Interactions (per tabelle admin)
     */
    function initTableInteractions() {
        const tables = document.querySelectorAll('.admin-table');
        if (tables.length === 0) return;

        tables.forEach(table => {
            const rows = table.querySelectorAll('tbody tr');

            rows.forEach(row => {
                // Highlight row on hover
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.01)';
                });

                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
                });

                // Confirm delete actions
                const deleteButtons = row.querySelectorAll('.btn-danger, .btn-admin-danger');
                deleteButtons.forEach(btn => {
                    if (!btn.hasAttribute('onclick')) {
                        btn.addEventListener('click', function(e) {
                            if (!confirm('Sei sicuro di voler eliminare questo elemento?')) {
                                e.preventDefault();
                                return false;
                            }
                        });
                    }
                });
            });
        });
    }

    /**
     * Package Cards (per coins page)
     */
    function initPackageCards() {
        const packageCards = document.querySelectorAll('.package-card');
        if (packageCards.length === 0) return;

        packageCards.forEach(card => {
            // Add hover parallax effect
            card.addEventListener('mousemove', function(e) {
                const rect = this.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;

                const centerX = rect.width / 2;
                const centerY = rect.height / 2;

                const rotateX = (y - centerY) / 10;
                const rotateY = (centerX - x) / 10;

                this.style.transform = `translateY(-10px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
            });

            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) rotateX(0) rotateY(0)';
            });
        });

        // Handle package button clicks
        const packageButtons = document.querySelectorAll('.btn-package');
        packageButtons.forEach(button => {
            button.addEventListener('click', function() {
                if (this.disabled) return;

                // Add loading state
                const originalText = this.innerHTML;
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Elaborazione...';
                this.disabled = true;

                // Simulate processing (remove in production, handle via form submit)
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.disabled = false;
                }, 2000);
            });
        });
    }

    /**
     * Form Enhancement - Real-time validation feedback
     */
    function enhanceFormInputs() {
        const inputs = document.querySelectorAll('.form-input, .form-select, input[type="text"], input[type="number"], input[type="email"]');

        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.hasAttribute('required') && !this.value.trim()) {
                    this.style.borderColor = '#dc3545';
                } else {
                    this.style.borderColor = '';
                }
            });

            input.addEventListener('input', function() {
                this.style.borderColor = '';
            });
        });
    }

    /**
     * Toggle All Bonuses - Funzione globale per onclick HTML
     */
    window.toggleAllBonuses = function() {
        const checkboxes = document.querySelectorAll('input[type="checkbox"][name^="bonus"]');
        const allChecked = Array.from(checkboxes).every(cb => cb.checked);

        checkboxes.forEach(checkbox => {
            checkbox.checked = !allChecked;
        });

        // Update button text if exists
        const btn = document.querySelector('.btn-toggle-all');
        if (btn) {
            btn.innerHTML = allChecked
                ? '<i class="fas fa-check-square"></i> Seleziona Tutti'
                : '<i class="fas fa-square"></i> Deseleziona Tutti';
        }
    };

    /**
     * Export funzioni globali se necessario
     */
    window.ONESHOP = {
        formatNumber: formatNumber,
        closeMobileMenu: closeMobileMenu,
        toggleMobileMenu: toggleMobileMenu,
        enhanceFormInputs: enhanceFormInputs,
        toggleAllBonuses: window.toggleAllBonuses
    };

    /**
     * Cleanup al unload
     */
    window.addEventListener('beforeunload', function() {
        // Clear tutti i countdown
        state.activeCountdowns.forEach((intervalId, element) => {
            clearInterval(intervalId);
        });
        state.activeCountdowns.clear();
    });

})();
