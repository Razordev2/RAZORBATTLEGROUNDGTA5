const KillfeedUI = {
    fxTimer: null,

    init() {},

    playKillAudio(isHeadshot) {
        try {
            const AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (!AudioCtx) return;
            const ctx = new AudioCtx();

            const osc = ctx.createOscillator();
            const gain = ctx.createGain();

            osc.type = isHeadshot ? 'sawtooth' : 'triangle';
            osc.frequency.setValueAtTime(isHeadshot ? 880 : 520, ctx.currentTime);
            osc.frequency.exponentialRampToValueAtTime(isHeadshot ? 1760 : 880, ctx.currentTime + 0.18);

            gain.gain.setValueAtTime(0.3, ctx.currentTime);
            gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.22);

            osc.connect(gain);
            gain.connect(ctx.destination);

            osc.start(ctx.currentTime);
            osc.stop(ctx.currentTime + 0.22);
        } catch (e) {
            console.log("Kill FX Audio error:", e);
        }
    },

    triggerKillFX(data) {
        const fxOverlay = document.getElementById('kill-fx-overlay');
        if (!fxOverlay) return;

        if (this.fxTimer) clearTimeout(this.fxTimer);

        const titleEl = document.getElementById('kill-fx-title');
        const victimEl = document.getElementById('kill-fx-victim');
        const weaponEl = document.getElementById('kill-fx-weapon');
        const streakEl = document.getElementById('kill-fx-streak');

        if (titleEl) titleEl.innerText = data.isHeadshot ? "HEADSHOT ELIMINATION" : "TARGET ELIMINATED";
        if (victimEl) victimEl.innerText = (data.victim || "SHADOW").toUpperCase();
        if (weaponEl) weaponEl.innerText = (data.weaponName || "WEAPON").toUpperCase();
        if (streakEl) streakEl.innerText = data.streakText || (data.isHeadshot ? "🎯 PRECISION SHOT" : "💀 ELIMINATED");

        fxOverlay.classList.remove('hidden');
        this.playKillAudio(data.isHeadshot);

        // Auto hide after 3 seconds
        this.fxTimer = setTimeout(() => {
            fxOverlay.classList.add('hidden');
        }, 3000);
    },

    push(data) {
        if (!data) return;
        const container = document.getElementById('killfeed-container');
        if (container) {
            const item = document.createElement('div');
            item.className = `killfeed-item ${data.isHeadshot ? 'kf-headshot' : ''}`;

            item.innerHTML = `
                <img src="gif/ACADEMIPGCE.gif" alt="GIF" class="kf-badge-gif">
                <span class="kf-killer-name">${data.killer || 'Player'}</span>
                <div class="kf-weapon-box">
                    <img src="${data.weaponIcon || 'icon/Vector.png'}" alt="Weapon" class="kf-weapon-icon" onerror="this.src='icon/Vector.png'">
                </div>
                ${data.isHeadshot ? '<div class="kf-hs-tag"><span class="skull-icon">💀</span> HEADSHOT</div>' : ''}
                <span class="kf-victim-name">${data.victim || 'Target'}</span>
            `;

            container.appendChild(item);

            // Auto dissolve after 4.5s
            setTimeout(() => {
                item.style.opacity = '0';
                item.style.transform = 'translateX(30px) scale(0.9)';
                item.style.transition = 'all 0.4s cubic-bezier(0.4, 0, 1, 1)';
                setTimeout(() => item.remove(), 400);
            }, 4500);
        }

        // If local player scored the kill, trigger center Kill FX banner!
        if (data.isLocalKiller || data.isLocal) {
            this.triggerKillFX(data);
        }
    }
};

document.addEventListener('DOMContentLoaded', () => KillfeedUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'pushKillFeed') {
        KillfeedUI.push(event.data);
    } else if (event.data.action === 'triggerKillFX') {
        KillfeedUI.triggerKillFX(event.data);
    }
});
