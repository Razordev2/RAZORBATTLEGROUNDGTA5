const SpectateUI = {
    init() {},

    update(data) {
        const container = document.getElementById('spectate-container');
        if (!container) return;

        if (!data || data.show === false) {
            container.classList.add('hidden');
            return;
        }

        const nameEl = document.getElementById('spectate-player-name');
        const teamEl = document.getElementById('spectate-team-name');
        const killsEl = document.getElementById('spectate-player-kills');
        const hpFill = document.getElementById('spectate-hp-fill');

        if (nameEl) nameEl.innerText = (data.targetName || "REXY").toUpperCase();
        if (teamEl) teamEl.innerText = (data.teamName || "SQUAD TEAMMATE").toUpperCase();

        if (killsEl) {
            killsEl.innerHTML = `<span class="skull-icon">☠️</span> ${data.kills || 0} KILLS`;
        }

        if (hpFill) {
            const hp = data.health !== undefined ? data.health : 100;
            hpFill.style.width = `${hp}%`;
        }

        container.classList.remove('hidden');
    },

    hide() {
        const container = document.getElementById('spectate-container');
        if (container) {
            container.classList.add('hidden');
        }
    }
};

document.addEventListener('DOMContentLoaded', () => SpectateUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'updateSpectateHUD') {
        SpectateUI.update(event.data);
    } else if (event.data.action === 'hideAllOverlays') {
        SpectateUI.hide();
    }
});
