/**
 * Shop AJAX Features: Gift System, Purchase History
 * @version 2.0.0 - Cleaned (Removed Quick View)
 */

class ShopAJAXFeatures {
    constructor() {
        // Usa path assoluto definito in js.php, con fallback sicuro
        if (typeof window.SHOP_API_URL !== 'undefined' && window.SHOP_API_URL) {
            this.apiUrl = window.SHOP_API_URL;
        } else if (typeof window.SHOP_BASE_URL !== 'undefined' && window.SHOP_BASE_URL) {
            this.apiUrl = window.SHOP_BASE_URL + 'api/shop_api.php';
        } else {
            // Fallback: usa il path relativo dal dominio corrente
            const currentPath = window.location.pathname;
            const shopPath = currentPath.substring(0, currentPath.indexOf('/shop2/') + 7);
            this.apiUrl = window.location.origin + shopPath + 'api/shop_api.php';
        }
        this.init();
    }

    init() {
        // Aspetta che il DOM sia completamente caricato
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                this.setupGiftSystem();
            });
        } else {
            this.setupGiftSystem();
        }
    }

    // Gift System
    setupGiftSystem() {
        // Gift modal gestito da bottoni specifici
    }

    showGiftModal(itemId) {
        const modalHTML = `
            <div class="modal fade" id="giftModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-primary">
                            <h4 class="modal-title"><i class="fa fa-gift"></i> Regala Item</h4>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <form id="giftForm">
                                <div class="form-group">
                                    <label>Nome Giocatore:</label>
                                    <input type="text" class="form-control" id="giftRecipient" required placeholder="Inserisci nome account">
                                </div>
                                <div class="form-group">
                                    <label>Messaggio (opzionale):</label>
                                    <textarea class="form-control" id="giftMessage" rows="3" maxlength="100" placeholder="Aggiungi un messaggio..."></textarea>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success" onclick="ShopAJAX.sendGift(${itemId})">
                                <i class="fa fa-paper-plane"></i> Invia Regalo
                            </button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Annulla</button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        const existing = document.getElementById('giftModal');
        if (existing) existing.remove();

        document.body.insertAdjacentHTML('beforeend', modalHTML);
        $('#giftModal').modal('show');
    }

    async sendGift(itemId) {
        const recipient = document.getElementById('giftRecipient').value.trim();
        const message = document.getElementById('giftMessage').value.trim();

        if (!recipient) {
            window.Toast.error('Inserisci il nome del destinatario');
            return;
        }

        try {
            const response = await fetch(this.apiUrl, {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: `action=send_gift&item_id=${itemId}&recipient=${encodeURIComponent(recipient)}&message=${encodeURIComponent(message)}`
            });

            const data = await response.json();

            if (data.success) {
                window.Toast.success(data.message || 'Regalo inviato con successo!');
                $('#giftModal').modal('hide');
            } else {
                window.Toast.error(data.error || 'Errore invio regalo');
            }
        } catch (error) {
            window.Toast.error('Errore di rete');
            console.error('Gift error:', error);
        }
    }
}

// Inizializza quando il DOM è pronto
if (typeof window.ShopAJAX === 'undefined') {
    window.ShopAJAX = new ShopAJAXFeatures();
}
