/**
 * Toast Notification System
 * Sostituisce alert() con notifiche moderne
 * @version 1.0.0
 */

class ToastNotification {
    constructor() {
        this.container = null;
        this.init();
    }

    init() {
        // Crea container per toast
        this.container = document.createElement('div');
        this.container.className = 'toast-container';
        this.container.id = 'toast-container';
        document.body.appendChild(this.container);
    }

    show(message, type = 'info', duration = 4000) {
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;

        // Icona basata sul tipo
        const icons = {
            success: 'fa-check-circle',
            error: 'fa-times-circle',
            warning: 'fa-exclamation-triangle',
            info: 'fa-info-circle'
        };

        toast.innerHTML = `
            <div class="toast-icon">
                <i class="fa ${icons[type] || icons.info}"></i>
            </div>
            <div class="toast-content">
                <div class="toast-message">${message}</div>
            </div>
            <button class="toast-close" onclick="this.parentElement.remove()">
                <i class="fa fa-times"></i>
            </button>
        `;

        this.container.appendChild(toast);

        // Animazione entrata
        setTimeout(() => toast.classList.add('toast-show'), 10);

        // Auto-rimozione
        if (duration > 0) {
            setTimeout(() => {
                toast.classList.remove('toast-show');
                setTimeout(() => toast.remove(), 300);
            }, duration);
        }

        return toast;
    }

    success(message, duration = 4000) {
        return this.show(message, 'success', duration);
    }

    error(message, duration = 5000) {
        return this.show(message, 'error', duration);
    }

    warning(message, duration = 4500) {
        return this.show(message, 'warning', duration);
    }

    info(message, duration = 4000) {
        return this.show(message, 'info', duration);
    }

    confirm(message, onConfirm, onCancel) {
        const toast = document.createElement('div');
        toast.className = 'toast toast-confirm';

        toast.innerHTML = `
            <div class="toast-icon">
                <i class="fa fa-question-circle"></i>
            </div>
            <div class="toast-content">
                <div class="toast-message">${message}</div>
                <div class="toast-actions">
                    <button class="toast-btn toast-btn-confirm">
                        <i class="fa fa-check"></i> Conferma
                    </button>
                    <button class="toast-btn toast-btn-cancel">
                        <i class="fa fa-times"></i> Annulla
                    </button>
                </div>
            </div>
        `;

        this.container.appendChild(toast);
        setTimeout(() => toast.classList.add('toast-show'), 10);

        // Event listeners
        toast.querySelector('.toast-btn-confirm').addEventListener('click', () => {
            toast.remove();
            if (onConfirm) onConfirm();
        });

        toast.querySelector('.toast-btn-cancel').addEventListener('click', () => {
            toast.remove();
            if (onCancel) onCancel();
        });

        return toast;
    }
}

// Inizializza globalmente
window.Toast = new ToastNotification();

// Shorthand globale
window.toast = (message, type) => window.Toast.show(message, type);
