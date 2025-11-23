/**
 * ITEMSHOP ONE - Modern JavaScript (ES6+)
 * Ottimizzato per performance e best practices 2025
 * @version 2.0.0
 */

'use strict';

// ============================================
// CONSTANTS & CONFIG
// ============================================
const SHOP_CONFIG = {
    timezone: 'Europe/Bucharest',
    countdownFormat: '%D giorni %H:%M:%S',
    tooltipDelay: 200,
    animationDuration: 300
};

// ============================================
// COUNTDOWN SYSTEM
// ============================================
class CountdownManager {
    constructor() {
        this.counters = new Map();
        this.init();
    }

    init() {
        document.querySelectorAll('[data-countdown]').forEach(element => {
            this.setupCountdown(element);
        });
    }

    setupCountdown(element) {
        const finalDate = element.dataset.countdown;
        if (!finalDate) return;

        try {
            const momentDate = moment.tz(finalDate, SHOP_CONFIG.timezone);
            const $element = $(element);

            $element.countdown(momentDate.toDate(), event => {
                $element.html(event.strftime(SHOP_CONFIG.countdownFormat));
            });

            this.counters.set(element, momentDate);
        } catch (error) {
            console.error('Countdown error:', error);
            element.innerHTML = '<span class="text-danger">Data non valida</span>';
        }
    }

    destroy() {
        this.counters.clear();
    }
}

// ============================================
// BONUS SELECTION SYSTEM
// ============================================
class BonusSelector {
    constructor() {
        this.usedBonuses = new Set();
        this.selects = document.querySelectorAll('select[name^="bonus"]');
        this.init();
    }

    init() {
        if (this.selects.length === 0) return;

        this.selects.forEach(select => {
            select.addEventListener('change', () => this.handleChange(select));
        });

        // Initial state
        this.updateAvailability();
    }

    handleChange(select) {
        this.updateAvailability();
    }

    updateAvailability() {
        // Clear used bonuses
        this.usedBonuses.clear();

        // Collect all selected values
        this.selects.forEach(select => {
            const value = select.value;
            if (value && value !== '0') {
                this.usedBonuses.add(value);
            }
        });

        // Update options visibility
        this.selects.forEach(select => {
            const currentValue = select.value;

            Array.from(select.options).forEach(option => {
                const optionValue = option.value;

                if (optionValue === '0' || optionValue === currentValue) {
                    // Always show empty option and currently selected
                    option.hidden = false;
                    option.disabled = false;
                } else if (this.usedBonuses.has(optionValue)) {
                    // Hide used bonuses
                    option.hidden = true;
                    option.disabled = true;
                } else {
                    // Show available bonuses
                    option.hidden = false;
                    option.disabled = false;
                }
            });
        });
    }

    destroy() {
        this.usedBonuses.clear();
    }
}

// ============================================
// TOOLTIP SYSTEM
// ============================================
class TooltipManager {
    constructor() {
        this.init();
    }

    init() {
        // Bootstrap tooltips
        if (typeof $.fn.tooltip !== 'undefined') {
            $('body').tooltip({
                selector: '[data-toggle="tooltip"]',
                delay: { show: SHOP_CONFIG.tooltipDelay, hide: 100 },
                trigger: 'hover focus'
            });
        }
    }

    destroy() {
        $('[data-toggle="tooltip"]').tooltip('dispose');
    }
}

// ============================================
// IMAGE LAZY LOADING
// ============================================
class LazyImageLoader {
    constructor() {
        this.images = document.querySelectorAll('img[data-src]');
        this.init();
    }

    init() {
        if ('IntersectionObserver' in window) {
            this.observer = new IntersectionObserver(
                entries => this.handleIntersection(entries),
                { rootMargin: '50px' }
            );

            this.images.forEach(img => this.observer.observe(img));
        } else {
            // Fallback for older browsers
            this.images.forEach(img => this.loadImage(img));
        }
    }

    handleIntersection(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                this.loadImage(entry.target);
                this.observer.unobserve(entry.target);
            }
        });
    }

    loadImage(img) {
        const src = img.dataset.src;
        if (!src) return;

        img.src = src;
        img.removeAttribute('data-src');
        img.classList.add('loaded');
    }

    destroy() {
        if (this.observer) {
            this.observer.disconnect();
        }
    }
}

// ============================================
// SMOOTH SCROLL
// ============================================
class SmoothScroller {
    constructor() {
        this.init();
    }

    init() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', e => {
                const href = anchor.getAttribute('href');
                if (href === '#') return;

                const target = document.querySelector(href);
                if (target) {
                    e.preventDefault();
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }
}

// ============================================
// PERFORMANCE MONITOR
// ============================================
class PerformanceMonitor {
    constructor() {
        this.metrics = {};
        this.init();
    }

    init() {
        if ('performance' in window) {
            window.addEventListener('load', () => {
                this.collectMetrics();
            });
        }
    }

    collectMetrics() {
        const perfData = performance.getEntriesByType('navigation')[0];
        if (!perfData) return;

        this.metrics = {
            dns: perfData.domainLookupEnd - perfData.domainLookupStart,
            tcp: perfData.connectEnd - perfData.connectStart,
            request: perfData.responseStart - perfData.requestStart,
            response: perfData.responseEnd - perfData.responseStart,
            dom: perfData.domComplete - perfData.domLoading,
            load: perfData.loadEventEnd - perfData.loadEventStart,
            total: perfData.loadEventEnd - perfData.fetchStart
        };

        // Log only in development
        if (window.location.hostname === 'localhost') {
            console.table(this.metrics);
        }
    }
}

// ============================================
// FORM VALIDATION
// ============================================
class FormValidator {
    constructor() {
        this.forms = document.querySelectorAll('form[data-validate]');
        this.init();
    }

    init() {
        this.forms.forEach(form => {
            form.addEventListener('submit', e => {
                if (!this.validateForm(form)) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                form.classList.add('was-validated');
            });
        });
    }

    validateForm(form) {
        return form.checkValidity();
    }
}

// ============================================
// MODAL MANAGER
// ============================================
class ModalManager {
    constructor() {
        this.init();
    }

    init() {
        // Fix modal backdrop z-index issues
        $(document).on('show.bs.modal', '.modal', function() {
            const zIndex = 1050 + (10 * $('.modal:visible').length);
            $(this).css('z-index', zIndex);
            setTimeout(() => {
                $('.modal-backdrop').not('.modal-stack').css('z-index', zIndex - 1).addClass('modal-stack');
            }, 0);
        });

        // Prevent body scroll when modal is open
        $(document).on('shown.bs.modal', '.modal', function() {
            document.body.style.overflow = 'hidden';
        });

        $(document).on('hidden.bs.modal', '.modal', function() {
            if ($('.modal:visible').length === 0) {
                document.body.style.overflow = '';
            }
        });
    }
}

// ============================================
// MAIN APP INITIALIZATION
// ============================================
class ItemShopApp {
    constructor() {
        this.modules = {};
        this.init();
    }

    init() {
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.start());
        } else {
            this.start();
        }
    }

    start() {
        try {
            // Initialize core modules
            this.modules.tooltips = new TooltipManager();
            this.modules.modals = new ModalManager();
            this.modules.smoothScroll = new SmoothScroller();
            this.modules.lazyLoader = new LazyImageLoader();
            this.modules.formValidator = new FormValidator();

            // Initialize page-specific modules
            if (document.querySelector('[data-countdown]')) {
                this.modules.countdown = new CountdownManager();
            }

            if (document.querySelector('select[name^="bonus"]')) {
                this.modules.bonusSelector = new BonusSelector();
            }

            // Performance monitoring (development only)
            if (window.location.hostname === 'localhost') {
                this.modules.perfMonitor = new PerformanceMonitor();
            }

            // Global event listeners
            this.setupGlobalEvents();

            console.log('ItemShop App initialized successfully');
        } catch (error) {
            console.error('ItemShop initialization error:', error);
        }
    }

    setupGlobalEvents() {
        // Handle AJAX errors globally (modern approach)
        $.ajaxSetup({
            error: function(jqxhr, settings, thrownError) {
                console.error('AJAX Error:', thrownError);
            }
        });

        // Handle window resize with debounce
        let resizeTimeout;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(() => {
                this.handleResize();
            }, 250);
        });
    }

    handleResize() {
        // Responsive adjustments
        const width = window.innerWidth;
        document.body.classList.toggle('mobile', width < 768);
        document.body.classList.toggle('tablet', width >= 768 && width < 992);
        document.body.classList.toggle('desktop', width >= 992);
    }

    destroy() {
        Object.values(this.modules).forEach(module => {
            if (module && typeof module.destroy === 'function') {
                module.destroy();
            }
        });
    }
}

// ============================================
// UTILITY FUNCTIONS
// ============================================
const Utils = {
    // Debounce function
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    // Throttle function
    throttle(func, limit) {
        let inThrottle;
        return function(...args) {
            if (!inThrottle) {
                func.apply(this, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    },

    // Format number with thousand separator
    formatNumber(num) {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    },

    // Copy to clipboard
    async copyToClipboard(text) {
        try {
            await navigator.clipboard.writeText(text);
            return true;
        } catch (err) {
            console.error('Failed to copy:', err);
            return false;
        }
    }
};

// ============================================
// INITIALIZE APP
// ============================================
window.ItemShop = new ItemShopApp();

// Export for global access
window.ItemShopUtils = Utils;
