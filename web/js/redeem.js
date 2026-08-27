const RedeemUI = {
    init() {
        document.getElementById('btn-close-redeem').addEventListener('click', () => {
            sendNuiCallback('closeRedeemUI');
        });

        document.getElementById('btn-submit-redeem').addEventListener('click', () => {
            const code = document.getElementById('input-redeem-code').value;
            if (code) {
                sendNuiCallback('submitRedeemCode', { code });
                document.getElementById('input-redeem-code').value = '';
            }
        });
    },

    toggle(show) {
        const container = document.getElementById('redeem-container');
        if (show) {
            container.classList.remove('hidden');
        } else {
            container.classList.add('hidden');
        }
    }
};

document.addEventListener('DOMContentLoaded', () => RedeemUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'toggleRedeemUI') {
        RedeemUI.toggle(event.data.show);
    }
});
