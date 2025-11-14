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
     * Export funzioni globali se necessario
     */
    window.ONESHOP = {
        formatNumber: formatNumber,
        closeMobileMenu: closeMobileMenu,
        toggleMobileMenu: toggleMobileMenu
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
