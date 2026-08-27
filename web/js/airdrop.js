const AirdropUI = {
    timer: null,

    init() {},

    show(data) {
        const container = document.getElementById('airdrop-container');
        if (!container) return;

        if (this.timer) clearTimeout(this.timer);

        const subText = document.getElementById('airdrop-coords-text');
        if (subText && data && data.message) {
            subText.innerText = data.message;
        }

        container.classList.remove('hidden');

        // Auto dissolve after 6 seconds
        this.timer = setTimeout(() => {
            this.hide();
        }, 6000);
    },

    hide() {
        if (this.timer) clearTimeout(this.timer);
        const container = document.getElementById('airdrop-container');
        if (container) {
            container.classList.add('hidden');
        }
    }
};

document.addEventListener('DOMContentLoaded', () => AirdropUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'showAirdrop') {
        AirdropUI.show(event.data);
    } else if (event.data.action === 'hideAllOverlays') {
        AirdropUI.hide();
    }
});
