/**
 * ========================================
 * ONE SERVER SHOP - ULTRA GASATO JS
 * Animazioni, Toast, Pop-up, Effetti WOW!
 * ========================================
 */

(function() {
    'use strict';

    /* ============= CONFIGURAZIONE ============= */
    const CONFIG = {
        TOAST_DURATION: 3000,
        POPUP_DELAY: 5000,
        PARTICLES_COUNT: 50,
        ANIMATION_SPEED: 1000
    };

    /* ============= TOAST NOTIFICATIONS ============= */
    const Toast = {
        container: null,

        init() {
            this.container = document.createElement('div');
            this.container.id = 'toast-container';
            this.container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 99999;
                pointer-events: none;
            `;
            document.body.appendChild(this.container);
        },

        show(message, type = 'success') {
            if (!this.container) this.init();

            const toast = document.createElement('div');
            toast.className = `toast toast-${type}`;
            toast.style.cssText = `
                background: ${type === 'success' ? 'linear-gradient(135deg, #00ff00, #00cc00)' : 'linear-gradient(135deg, #ff0000, #cc0000)'};
                color: #fff;
                padding: 20px 30px;
                margin-bottom: 15px;
                border-radius: 10px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5), 0 0 20px ${type === 'success' ? 'rgba(0, 255, 0, 0.5)' : 'rgba(255, 0, 0, 0.5)'};
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1px;
                animation: slideInRight 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
                pointer-events: all;
                position: relative;
                overflow: hidden;
            `;

            const icon = type === 'success' ? '✓' : '✗';
            toast.innerHTML = `<span style="font-size: 1.5em; margin-right: 10px;">${icon}</span>${message}`;

            this.container.appendChild(toast);

            // Auto-remove
            setTimeout(() => {
                toast.style.animation = 'slideOutRight 0.5s ease';
                setTimeout(() => toast.remove(), 500);
            }, CONFIG.TOAST_DURATION);

            return toast;
        },

        success(message) {
            return this.show(message, 'success');
        },

        error(message) {
            return this.show(message, 'error');
        }
    };

    /* ============= POP-UP MOTIVAZIONALE ============= */
    const MotivationalPopup = {
        messages: [
            { title: '🔥 SUPER OFFERTA!', text: 'Sconto -50% su TUTTI gli item! Solo per OGGI!', cta: 'VEDI ORA' },
            { title: '⚔️ DIVENTA LEGGENDA!', text: 'Equipaggiamenti EPICI ti aspettano!', cta: 'POTENZIATI' },
            { title: '💎 MONETE GRATIS!', text: 'Primi acquisto del giorno: +20% MD BONUS!', cta: 'OTTIENI BONUS' },
            { title: '🎁 REGALO SPECIALE!', text: 'Item RARO in regalo per te! Limitato!', cta: 'RISCATTA' },
            { title: '⏰ ULTIMA CHANCE!', text: 'Item in scadenza tra 2 ORE! Non perdere!', cta: 'AFFRETTATI' }
        ],

        shown: false,

        show() {
            if (this.shown) return;
            this.shown = true;

            const msg = this.messages[Math.floor(Math.random() * this.messages.length)];

            const overlay = document.createElement('div');
            overlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.8);
                z-index: 999999;
                display: flex;
                align-items: center;
                justify-content: center;
                animation: fadeIn 0.3s ease;
            `;

            const popup = document.createElement('div');
            popup.style.cssText = `
                background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);
                border: 3px solid #ffd700;
                border-radius: 20px;
                padding: 40px;
                max-width: 500px;
                text-align: center;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.9), 0 0 50px rgba(255, 215, 0, 0.5);
                animation: rotateIn 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
                position: relative;
            `;

            popup.innerHTML = `
                <h2 style="
                    font-size: 2.5rem;
                    margin: 0 0 20px 0;
                    background: linear-gradient(135deg, #ffd700, #fff, #ffd700);
                    background-size: 200% 200%;
                    -webkit-background-clip: text;
                    background-clip: text;
                    -webkit-text-fill-color: transparent;
                    animation: gradient-shift 3s ease infinite;
                    font-weight: 900;
                ">${msg.title}</h2>
                <p style="
                    font-size: 1.3rem;
                    color: #fff;
                    margin: 0 0 30px 0;
                    font-weight: 600;
                ">${msg.text}</p>
                <button class="gasato-btn" style="
                    background: linear-gradient(135deg, #ff0000 0%, #8a0000 100%);
                    color: #fff;
                    font-weight: 900;
                    text-transform: uppercase;
                    letter-spacing: 2px;
                    padding: 18px 50px;
                    border: 3px solid #ffd700;
                    border-radius: 50px;
                    box-shadow: 0 10px 30px rgba(255, 0, 0, 0.6);
                    cursor: pointer;
                    font-size: 1.2rem;
                    transition: all 0.3s;
                ">${msg.cta}</button>
                <button style="
                    position: absolute;
                    top: 15px;
                    right: 15px;
                    background: none;
                    border: none;
                    color: #888;
                    font-size: 2rem;
                    cursor: pointer;
                    transition: color 0.3s;
                " class="close-popup">×</button>
            `;

            overlay.appendChild(popup);
            document.body.appendChild(overlay);

            // Close handlers
            const closeBtn = popup.querySelector('.close-popup');
            const ctaBtn = popup.querySelector('.gasato-btn');

            const close = () => {
                overlay.style.animation = 'fadeOut 0.3s ease';
                setTimeout(() => overlay.remove(), 300);
            };

            closeBtn.addEventListener('click', close);
            ctaBtn.addEventListener('click', () => {
                close();
                Toast.success('🎉 Offerta attivata! Vai allo shop!');
            });

            overlay.addEventListener('click', (e) => {
                if (e.target === overlay) close();
            });
        }
    };

    /* ============= PARTICLES BACKGROUND ============= */
    const Particles = {
        container: null,

        init() {
            this.container = document.createElement('div');
            this.container.className = 'particles-container';
            document.body.appendChild(this.container);

            for (let i = 0; i < CONFIG.PARTICLES_COUNT; i++) {
                this.createParticle();
            }
        },

        createParticle() {
            const particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = Math.random() * 100 + '%';
            particle.style.animationDelay = Math.random() * 20 + 's';
            particle.style.animationDuration = (15 + Math.random() * 10) + 's';
            this.container.appendChild(particle);
        }
    };

    /* ============= CARD HOVER EFFECTS ============= */
    const CardEffects = {
        init() {
            document.addEventListener('DOMContentLoaded', () => {
                const cards = document.querySelectorAll('.item-card-gasato, .card');

                cards.forEach(card => {
                    card.addEventListener('mouseenter', function() {
                        this.style.zIndex = '100';
                    });

                    card.addEventListener('mouseleave', function() {
                        this.style.zIndex = '1';
                    });
                });
            });
        }
    };

    /* ============= SCROLL ANIMATIONS ============= */
    const ScrollAnimations = {
        init() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animation = 'slideInUp 0.6s ease forwards';
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });

            document.addEventListener('DOMContentLoaded', () => {
                const elements = document.querySelectorAll('.animate-on-scroll');
                elements.forEach(el => {
                    el.style.opacity = '0';
                    observer.observe(el);
                });
            });
        }
    };

    /* ============= COUNTDOWN TIMER ============= */
    const Countdown = {
        init() {
            document.addEventListener('DOMContentLoaded', () => {
                const countdowns = document.querySelectorAll('[data-countdown]');

                countdowns.forEach(el => {
                    const endDate = new Date(el.getAttribute('data-countdown')).getTime();

                    const update = () => {
                        const now = new Date().getTime();
                        const distance = endDate - now;

                        if (distance < 0) {
                            el.innerHTML = 'SCADUTO';
                            return;
                        }

                        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                        const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                        el.innerHTML = `${days}d ${hours}h ${minutes}m ${seconds}s`;
                    };

                    update();
                    setInterval(update, 1000);
                });
            });
        }
    };

    /* ============= INIT ALL ============= */
    function init() {
        Toast.init();
        Particles.init();
        CardEffects.init();
        ScrollAnimations.init();
        Countdown.init();

        // Show motivational popup after delay
        setTimeout(() => {
            MotivationalPopup.show();
        }, CONFIG.POPUP_DELAY);

        // Welcome message
        setTimeout(() => {
            Toast.success('🎮 Benvenuto! Esplora lo shop epico!');
        }, 1000);
    }

    /* ============= AUTO-START ============= */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    // Expose global API
    window.ShopGasato = {
        Toast,
        Popup: MotivationalPopup,
        showSuccessToast: (msg) => Toast.success(msg),
        showErrorToast: (msg) => Toast.error(msg)
    };
})();

/* ============= ANIMATIONS CSS (injected) ============= */
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    @keyframes fadeOut {
        from { opacity: 1; }
        to { opacity: 0; }
    }
`;
document.head.appendChild(style);
