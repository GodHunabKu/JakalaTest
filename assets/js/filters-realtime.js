/**
 * Real-time AJAX Filters
 * Aggiorna risultati senza reload pagina
 */

class RealTimeFilters {
    constructor() {
        this.form = document.querySelector('.filters-form');
        if (!this.form) return;

        this.init();
    }

    init() {
        // Intercetta form submit
        this.form.addEventListener('submit', (e) => {
            e.preventDefault();
            this.applyFilters();
        });

        // Trigger su change select/checkbox
        this.form.querySelectorAll('select, input[type="checkbox"]').forEach(input => {
            input.addEventListener('change', () => this.applyFilters());
        });
    }

    async applyFilters() {
        const formData = new FormData(this.form);
        const params = new URLSearchParams(formData).toString();

        // Mostra skeleton loader
        this.showLoader();

        try {
            const response = await fetch(window.location.href.split('?')[0] + '?' + params, {
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            });

            const html = await response.text();

            // Estrai solo la griglia items dal HTML
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            const newGrid = doc.querySelector('.items-grid');
            const newPagination = doc.querySelector('.pagination-modern');

            if (newGrid) {
                document.querySelector('.items-grid').innerHTML = newGrid.innerHTML;
            }

            if (newPagination) {
                const currentPagination = document.querySelector('.pagination-modern');
                if (currentPagination) {
                    currentPagination.parentElement.innerHTML = newPagination.parentElement.innerHTML;
                }
            }

            this.hideLoader();

            // Update URL senza reload
            window.history.pushState({}, '', window.location.pathname + '?' + params);

        } catch (error) {
            this.hideLoader();
            Toast.error('Errore caricamento risultati');
        }
    }

    showLoader() {
        document.querySelector('.skeleton-loader')?.style.setProperty('display', 'block');
        document.querySelector('.items-grid')?.style.setProperty('opacity', '0.5');
    }

    hideLoader() {
        document.querySelector('.skeleton-loader')?.style.setProperty('display', 'none');
        document.querySelector('.items-grid')?.style.setProperty('opacity', '1');
    }
}

// Inizializza
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => new RealTimeFilters());
} else {
    new RealTimeFilters();
}
