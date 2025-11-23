/**
 * Lazy Loading Images 2025
 * Performance optimization per caricamento immagini
 */

(function() {
    'use strict';

    // Lazy Loading DISABILITATO per user feedback - preferisce caricamento diretto
    // (codice commentato ma lasciato per reference futura)

    // Smooth scroll per paginazione
    document.addEventListener('DOMContentLoaded', () => {
        const paginationLinks = document.querySelectorAll('.pagination a');
        paginationLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                // Scroll smooth alla top della griglia item
                setTimeout(() => {
                    const itemsGrid = document.querySelector('.items-grid');
                    if (itemsGrid) {
                        itemsGrid.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                }, 100);
            });
        });
    });

    // Auto-submit form filtri con debounce
    document.addEventListener('DOMContentLoaded', () => {
        const filterInputs = document.querySelectorAll('.filters-form input[type="number"], .filters-form select');
        let timeout = null;

        filterInputs.forEach(input => {
            input.addEventListener('change', () => {
                clearTimeout(timeout);
                timeout = setTimeout(() => {
                    const form = input.closest('form');
                    if (form) {
                        // Auto-submit dopo 500ms (opzionale, commentato per sicurezza)
                        // form.submit();
                    }
                }, 500);
            });
        });
    });

    // Animazione count badge (numeri che cambiano)
    function animateValue(element, start, end, duration) {
        const range = end - start;
        const increment = end > start ? 1 : -1;
        const stepTime = Math.abs(Math.floor(duration / range));
        let current = start;

        const timer = setInterval(() => {
            current += increment;
            element.textContent = current;
            if (current === end) {
                clearInterval(timer);
            }
        }, stepTime);
    }

    // Inizializza animazioni count badge
    document.addEventListener('DOMContentLoaded', () => {
        const countBadges = document.querySelectorAll('.count-badge i');
        countBadges.forEach(badge => {
            const parent = badge.closest('.count-badge');
            if (parent) {
                const text = parent.textContent.trim();
                const match = text.match(/\d+/);
                if (match) {
                    const count = parseInt(match[0]);
                    const textNode = Array.from(parent.childNodes).find(node => node.nodeType === 3);
                    if (textNode && count > 0) {
                        // Animazione opzionale al caricamento
                        // animateValue(textNode, 0, count, 1000);
                    }
                }
            }
        });
    });

    // Gestione errori immagini
    document.addEventListener('DOMContentLoaded', () => {
        const images = document.querySelectorAll('.image-item, .image-item-small, .popular-item-icon');
        images.forEach(img => {
            img.addEventListener('error', function() {
                // Fallback a placeholder se immagine non esiste
                if (this.src.indexOf('loading-placeholder') === -1) {
                    this.src = this.src.replace(/\/images\/items\/.*\.png/, '/images/loading-placeholder.svg');
                }
            });
        });
    });

})();
