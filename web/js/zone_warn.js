const ZoneWarnUI = {
    timer1: null,
    timer2: null,

    init() {},

    playWarningSound() {
        try {
            const AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (!AudioCtx) return;
            const ctx = new AudioCtx();

            const playBeep = (freq, startTime, duration) => {
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();

                osc.type = 'sawtooth';
                osc.frequency.setValueAtTime(freq, startTime);

                gain.gain.setValueAtTime(0.18, startTime);
                gain.gain.exponentialRampToValueAtTime(0.001, startTime + duration);

                osc.connect(gain);
                gain.connect(ctx.destination);

                osc.start(startTime);
                osc.stop(startTime + duration);
            };

            const now = ctx.currentTime;
            playBeep(880, now, 0.16);         // Beep 1 (High A5)
            playBeep(660, now + 0.20, 0.16);  // Beep 2 (E5)
            playBeep(880, now + 0.40, 0.25);  // Beep 3 (High A5 Accent)
        } catch (e) {
            console.log("Audio play exception:", e);
        }
    },

    show(data) {
        const container = document.getElementById('zone-warn-container');
        if (!container) return;

        const card = container.querySelector('.zone-warn-card-glass');

        if (this.timer1) clearTimeout(this.timer1);
        if (this.timer2) clearTimeout(this.timer2);

        const titleEl = document.getElementById('zone-warn-title-text');
        const subEl = document.getElementById('zone-warn-sub-text');

        if (titleEl) {
            titleEl.innerText = (data && data.title) ? data.title : "ZONA MULAI BERGERAK!";
        }
        if (subEl) {
            subEl.innerText = (data && data.message) ? data.message : "SEGERA MASUK KE DALAM LINGKARAN AMAN ZONA!";
        }

        if (card) {
            card.classList.remove('animate-out');
        }
        container.classList.remove('hidden');

        // Play tactical warning audio siren
        this.playWarningSound();

        // After 4.0s, trigger smooth exit animation
        this.timer1 = setTimeout(() => {
            if (card) {
                card.classList.add('animate-out');
            }
            // After exit animation finishes (450ms), hide container completely
            this.timer2 = setTimeout(() => {
                this.hide();
            }, 450);
        }, 4000);
    },

    hide() {
        if (this.timer1) clearTimeout(this.timer1);
        if (this.timer2) clearTimeout(this.timer2);
        const container = document.getElementById('zone-warn-container');
        if (container) {
            container.classList.add('hidden');
            const card = container.querySelector('.zone-warn-card-glass');
            if (card) card.classList.remove('animate-out');
        }
    }
};

document.addEventListener('DOMContentLoaded', () => ZoneWarnUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'showZoneWarn') {
        ZoneWarnUI.show(event.data);
    } else if (event.data.action === 'hideAllOverlays') {
        ZoneWarnUI.hide();
    }
});
