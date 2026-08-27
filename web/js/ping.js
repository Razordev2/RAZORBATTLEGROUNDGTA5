const EnemyPingUI = {
    timer: null,

    init() {},

    playPingSound() {
        try {
            const AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (!AudioCtx) return;
            const ctx = new AudioCtx();

            const osc = ctx.createOscillator();
            const gain = ctx.createGain();

            osc.type = 'sine';
            osc.frequency.setValueAtTime(1200, ctx.currentTime);
            osc.frequency.exponentialRampToValueAtTime(1800, ctx.currentTime + 0.12);

            gain.gain.setValueAtTime(0.2, ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.15);

            osc.connect(gain);
            gain.connect(ctx.destination);

            osc.start(ctx.currentTime);
            osc.stop(ctx.currentTime + 0.15);
        } catch (e) {
            console.log("Ping audio exception:", e);
        }
    },

    show(data) {
        const container = document.getElementById('enemy-ping-container');
        if (!container) return;

        if (this.timer) clearTimeout(this.timer);

        const distEl = document.getElementById('ping-distance-text');
        const authorEl = document.getElementById('ping-author-text');

        if (distEl) {
            distEl.innerText = (data && data.distance) ? `${Math.round(data.distance)}M` : "145M";
        }

        if (authorEl) {
            authorEl.innerText = (data && data.author) ? `PINGED BY ${data.author.toUpperCase()}` : "PINGED BY REXY";
        }

        container.classList.remove('hidden');
        this.playPingSound();

        // Auto dissolve after 5 seconds
        this.timer = setTimeout(() => {
            this.hide();
        }, 5000);
    },

    hide() {
        if (this.timer) clearTimeout(this.timer);
        const container = document.getElementById('enemy-ping-container');
        if (container) {
            container.classList.add('hidden');
        }
    }
};

document.addEventListener('DOMContentLoaded', () => EnemyPingUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'showEnemyPing') {
        EnemyPingUI.show(event.data);
    } else if (event.data.action === 'hideAllOverlays') {
        EnemyPingUI.hide();
    }
});
