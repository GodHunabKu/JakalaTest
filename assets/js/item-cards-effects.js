/* ============================================
   ITEM CARDS INTERACTIVE EFFECTS
   ============================================ */

document.addEventListener('DOMContentLoaded', function() {
    
    // ==========================================
    // WISHLIST TOGGLE
    // ==========================================
    window.toggleWishlist = function(itemId, button) {
        const isActive = button.classList.contains('active');
        
        // AJAX call to add/remove from wishlist
        fetch(`${shopUrl}api/wishlist_toggle.php`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                item_id: itemId,
                action: isActive ? 'remove' : 'add'
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                button.classList.toggle('active');
                
                // Show notification
                showNotification(
                    isActive ? 'Rimosso dai preferiti' : 'Aggiunto ai preferiti',
                    'success'
                );
            } else {
                showNotification('Errore nell\'operazione', 'error');
            }
        })
        .catch(error => {
            console.error('Wishlist error:', error);
            showNotification('Errore di connessione', 'error');
        });
    };
    
    // ==========================================
    // QUICK ADD TO CART
    // ==========================================
    window.quickAddToCart = function(itemId) {
        const button = event.target.closest('.btn-quick-add');
        
        // Disable button temporarily
        button.disabled = true;
        button.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Aggiunta...';
        
        fetch(`${shopUrl}api/cart_add.php`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                item_id: itemId,
                quantity: 1
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Success animation
                button.innerHTML = '<i class="fa fa-check"></i> Aggiunto!';
                button.style.background = 'linear-gradient(135deg, #00ff00, #008800)';
                
                // Update cart count
                updateCartCount();
                
                // Show notification
                showNotification('Item aggiunto al carrello', 'success');
                
                // Reset button after 2 seconds
                setTimeout(() => {
                    button.disabled = false;
                    button.innerHTML = '<i class="fa fa-shopping-cart"></i> Aggiungi';
                    button.style.background = '';
                }, 2000);
            } else {
                button.innerHTML = '<i class="fa fa-times"></i> Errore';
                button.style.background = 'linear-gradient(135deg, #ff0000, #880000)';
                showNotification(data.message || 'Errore nell\'aggiunta', 'error');
                
                setTimeout(() => {
                    button.disabled = false;
                    button.innerHTML = '<i class="fa fa-shopping-cart"></i> Aggiungi';
                    button.style.background = '';
                }, 2000);
            }
        })
        .catch(error => {
            console.error('Cart error:', error);
            button.disabled = false;
            button.innerHTML = '<i class="fa fa-shopping-cart"></i> Aggiungi';
            showNotification('Errore di connessione', 'error');
        });
    };
    
    // ==========================================
    // QUICK VIEW MODAL
    // ==========================================
    window.quickView = function(itemId) {
        // Fetch item details
        fetch(`${shopUrl}api/item_details.php?id=${itemId}`)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showQuickViewModal(data.item);
                }
            })
            .catch(error => {
                console.error('Quick view error:', error);
            });
    };
    
    function showQuickViewModal(item) {
        // Create modal HTML
        const modalHTML = `
            <div class="quick-view-modal" id="quickViewModal">
                <div class="modal-overlay" onclick="closeQuickView()"></div>
                <div class="modal-content">
                    <button class="modal-close" onclick="closeQuickView()">
                        <i class="fa fa-times"></i>
                    </button>
                    
                    <div class="modal-grid">
                        <div class="modal-image">
                            <img src="${shopUrl}images/items/${item.image}.png" alt="${item.name}">
                        </div>
                        
                        <div class="modal-info">
                            <span class="modal-rarity rarity-${item.rarity}">${item.rarity}</span>
                            <h3>${item.name}</h3>
                            
                            <div class="modal-stats">
                                ${item.stats.map(stat => `
                                    <div class="stat-row">
                                        <span>${stat.name}:</span>
                                        <strong>${stat.value}</strong>
                                    </div>
                                `).join('')}
                            </div>
                            
                            <div class="modal-price">
                                <span class="price">${item.price} MD</span>
                            </div>
                            
                            <div class="modal-actions">
                                <button onclick="quickAddToCart(${item.id})" class="btn-add">
                                    <i class="fa fa-shopping-cart"></i>
                                    Aggiungi al Carrello
                                </button>
                                <a href="${shopUrl}item/${item.id}/" class="btn-details">
                                    Vedi Dettagli Completi
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Append to body
        document.body.insertAdjacentHTML('beforeend', modalHTML);
        
        // Animate entrance
        setTimeout(() => {
            document.getElementById('quickViewModal').classList.add('active');
        }, 10);
    }
    
    window.closeQuickView = function() {
        const modal = document.getElementById('quickViewModal');
        if (modal) {
            modal.classList.remove('active');
            setTimeout(() => {
                modal.remove();
            }, 300);
        }
    };
    
    // ==========================================
    // 3D TILT EFFECT ON HOVER
    // ==========================================
    const itemCards = document.querySelectorAll('.item-card-modern');
    
    itemCards.forEach(card => {
        card.addEventListener('mousemove', handleTilt);
        card.addEventListener('mouseleave', resetTilt);
    });
    
    function handleTilt(e) {
        const card = e.currentTarget;
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        const centerX = rect.width / 2;
        const centerY = rect.height / 2;
        
        const rotateX = (y - centerY) / 20;
        const rotateY = (centerX - x) / 20;
        
        card.style.transform = `
            perspective(1000px)
            rotateX(${rotateX}deg)
            rotateY(${rotateY}deg)
            translateY(-10px)
            scale(1.02)
        `;
    }
    
    function resetTilt(e) {
        const card = e.currentTarget;
        card.style.transform = '';
    }
    
    // ==========================================
    // NOTIFICATION SYSTEM
    // ==========================================
    function showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.innerHTML = `
            <i class="fa fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
            <span>${message}</span>
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.classList.add('show');
        }, 10);
        
        setTimeout(() => {
            notification.classList.remove('show');
            setTimeout(() => {
                notification.remove();
            }, 300);
        }, 3000);
    }
    
    // ==========================================
    // CART COUNT UPDATE
    // ==========================================
    function updateCartCount() {
        fetch(`${shopUrl}api/cart_count.php`)
            .then(response => response.json())
            .then(data => {
                const cartBadge = document.querySelector('.cart-count-badge');
                if (cartBadge) {
                    cartBadge.textContent = data.count;
                    cartBadge.classList.add('bounce');
                    setTimeout(() => {
                        cartBadge.classList.remove('bounce');
                    }, 500);
                }
            });
    }
});

/* ============================================
   COUNTDOWN TIMER FOR DEALS
   ============================================ */

function initCountdownTimers() {
    const timers = document.querySelectorAll('[data-expire]');
    
    timers.forEach(timer => {
        const expireDate = new Date(timer.getAttribute('data-expire')).getTime();
        
        const updateTimer = () => {
            const now = new Date().getTime();
            const distance = expireDate - now;
            
            if (distance < 0) {
                timer.textContent = 'SCADUTO';
                return;
            }
            
            const hours = Math.floor(distance / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);
            
            const timerElement = timer.querySelector('.countdown-timer');
            if (timerElement) {
                timerElement.textContent = `${hours}h ${minutes}m ${seconds}s`;
            }
        };
        
        updateTimer();
        setInterval(updateTimer, 1000);
    });
}

document.addEventListener('DOMContentLoaded', initCountdownTimers);