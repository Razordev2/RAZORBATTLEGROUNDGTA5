const WinnerUI = {
    timer1: null,
    timer2: null,

    init() {
        this.hide();
    },

    show(teamData) {
        if (!teamData) return;

        // Clear existing timers
        if (this.timer1) clearTimeout(this.timer1);
        if (this.timer2) clearTimeout(this.timer2);

        const cardContainer = document.getElementById('winner-container');
        const textOverlay = document.getElementById('victory-text-overlay');
        const resultsContainer = document.getElementById('results-container');

        // Update card data
        const teamNameEl = document.getElementById('winner-team-name');
        const logoEl = document.getElementById('winner-logo');
        const killsEl = document.getElementById('winner-total-kills');

        if (teamNameEl) teamNameEl.innerText = teamData.teamName || "NAMA TIM";
        if (logoEl) logoEl.src = teamData.logo || "assets/images/default_team.png";
        if (killsEl) killsEl.innerText = teamData.kills !== undefined ? teamData.kills : 0;

        // STEP 1: Show Tactical Winner Card Popup ONLY (Ensure text and leaderboard are hidden)
        if (textOverlay) textOverlay.classList.add('hidden');
        if (resultsContainer) resultsContainer.classList.add('hidden');
        if (cardContainer) cardContainer.classList.remove('hidden');

        // STEP 2: After 3.5 seconds, hide Popup Card completely and show Kinetic Fullscreen Text
        this.timer1 = setTimeout(() => {
            if (cardContainer) cardContainer.classList.add('hidden');
            if (resultsContainer) resultsContainer.classList.add('hidden');
            if (textOverlay) textOverlay.classList.remove('hidden');

            // STEP 3: After 3.5 seconds, hide Kinetic Fullscreen Text completely and show Arena Leaderboards
            this.timer2 = setTimeout(() => {
                if (cardContainer) cardContainer.classList.add('hidden');
                if (textOverlay) textOverlay.classList.add('hidden');
                if (resultsContainer) resultsContainer.classList.remove('hidden');
            }, 3500);
        }, 3500);
    },

    hide() {
        if (this.timer1) clearTimeout(this.timer1);
        if (this.timer2) clearTimeout(this.timer2);

        const cardContainer = document.getElementById('winner-container');
        const textOverlay = document.getElementById('victory-text-overlay');
        const resultsContainer = document.getElementById('results-container');

        if (cardContainer) cardContainer.classList.add('hidden');
        if (textOverlay) textOverlay.classList.add('hidden');
        if (resultsContainer) resultsContainer.classList.add('hidden');
    }
};

document.addEventListener('DOMContentLoaded', () => WinnerUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'showWinner') {
        WinnerUI.show(event.data.winner);
    } else if (event.data.action === 'hideAllOverlays') {
        WinnerUI.hide();
    }
});
