/* 
   SCARLET WARLORD UI - INTERACTIVITY 
   Version: Definitive 10/10
*/

document.addEventListener('DOMContentLoaded', function() {
    
    // 1. Sticky Header Effect
    const header = document.querySelector('.header');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.style.background = 'rgba(0, 0, 0, 0.95)';
            // header.style.padding = '5px 0'; // Removed to prevent jitter
            header.style.boxShadow = '0 5px 20px rgba(255, 0, 0, 0.3)';
        } else {
            header.style.background = 'rgba(0, 0, 0, 0.8)';
            // header.style.padding = '10px 0'; // Removed to prevent jitter
            header.style.boxShadow = '0 5px 20px rgba(255, 0, 0, 0.1)';
        }
    });

    // 2. 3D Tilt Effect for Cards (Lightweight)
    const cards = document.querySelectorAll('.card, .category-card, .wallet-balance-card');
    
    cards.forEach(card => {
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            
            const rotateX = ((y - centerY) / centerY) * -5; // Max rotation deg
            const rotateY = ((x - centerX) / centerX) * 5;

            card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.02)`;
        });

        card.addEventListener('mouseleave', () => {
            card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) scale(1)';
        });
    });

    // 3. Scarlet Sparkles (Mouse Trail) - Optional but cool
    /*
    document.addEventListener('mousemove', function(e) {
        if(Math.random() > 0.9) { // Only sometimes to save performance
            const spark = document.createElement('div');
            spark.classList.add('scarlet-spark');
            spark.style.left = e.pageX + 'px';
            spark.style.top = e.pageY + 'px';
            document.body.appendChild(spark);
            
            setTimeout(() => {
                spark.remove();
            }, 1000);
        }
    });
    */

    // 4. Add to Cart Animation
    const cartButtons = document.querySelectorAll('.btn-add-to-cart');
    cartButtons.forEach(btn => {
        btn.addEventListener('click', function(e) {
            // Create ripple effect
            let ripple = document.createElement('span');
            ripple.classList.add('ripple');
            this.appendChild(ripple);
            
            let x = e.clientX - e.target.offsetLeft;
            let y = e.clientY - e.target.offsetTop;
            
            ripple.style.left = `${x}px`;
            ripple.style.top = `${y}px`;
            
            setTimeout(() => {
                ripple.remove();
            }, 300);

            // Show Toast
            showScarletToast('Item aggiunto al carrello!', 'success');
        });
    });
});

// Custom Toast Notification
function showScarletToast(message, type = 'info') {
    // Check if container exists
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.style.position = 'fixed';
        container.style.bottom = '20px';
        container.style.right = '20px';
        container.style.zIndex = '9999';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.style.background = 'rgba(10, 10, 10, 0.95)';
    toast.style.border = '1px solid #ff0000';
    toast.style.borderLeft = '5px solid #ff0000';
    toast.style.color = '#fff';
    toast.style.padding = '15px 25px';
    toast.style.marginTop = '10px';
    toast.style.borderRadius = '5px';
    toast.style.boxShadow = '0 5px 15px rgba(0,0,0,0.5)';
    toast.style.fontFamily = "'Inter', sans-serif";
    toast.style.display = 'flex';
    toast.style.alignItems = 'center';
    toast.style.animation = 'slideInRight 0.3s ease forwards';
    
    toast.innerHTML = `<i class="fa fa-check-circle" style="color: #ff0000; margin-right: 10px;"></i> ${message}`;

    container.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'fadeOut 0.5s ease forwards';
        setTimeout(() => {
            toast.remove();
        }, 500);
    }, 3000);
}

// Add CSS for animations dynamically
const styleSheet = document.createElement("style");
styleSheet.innerText = `
    @keyframes slideInRight {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes fadeOut {
        from { opacity: 1; }
        to { opacity: 0; }
    }
    .ripple {
        position: absolute;
        background: rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        transform: scale(0);
        animation: ripple 0.6s linear;
        pointer-events: none;
    }
    @keyframes ripple {
        to { transform: scale(4); opacity: 0; }
    }
`;
document.head.appendChild(styleSheet);
