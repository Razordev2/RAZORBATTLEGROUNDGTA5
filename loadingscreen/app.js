const LoadingApp = {
    progress: 0,
    tips: [
        "Tekan tombol [Z] untuk mengaktifkan Tactical Enemy Ping Marker sejauh 300m yang hanya dapat dilihat oleh anggota squad Anda.",
        "Tekan tombol [B] untuk berganti antara Voice Chat Radio Squad dan Voice Chat Proximity Publik.",
        "Tekan tombol [M] untuk membuka dan mengontrol Zoom Peta Taktis Battleground.",
        "Airdrop Supply akan otomatis jatuh 5 detik setelah zona aman mulai menyempit.",
        "Senjata dan amunisi dapat diambil langsung di area darat tanpa jeda delay.",
        "Satu tim yang tereliminasi akan otomatis kembali ke Lobby setelah 4 detik."
    ],
    tipIndex: 0,

    init() {
        this.startTipRotator();
        this.listenFiveMEvents();
        this.simulateSmoothProgress();
    },

    startTipRotator() {
        setInterval(() => {
            this.tipIndex = (this.tipIndex + 1) % this.tips.length;
            const tipEl = document.getElementById('tip-text');
            if (tipEl) {
                tipEl.style.opacity = '0';
                setTimeout(() => {
                    tipEl.innerText = this.tips[this.tipIndex];
                    tipEl.style.opacity = '1';
                }, 300);
            }
        }, 5000);
    },

    updateProgress(percent, statusText) {
        this.progress = Math.min(100, Math.max(this.progress, percent));

        const barFill = document.getElementById('progress-fill-line');
        const percentText = document.getElementById('loading-percent');
        const statusEl = document.getElementById('loading-status');

        if (barFill) barFill.style.width = `${this.progress}%`;
        if (percentText) percentText.innerText = `${Math.round(this.progress)}%`;
        if (statusEl && statusText) statusEl.innerText = statusText;
    },

    simulateSmoothProgress() {
        let current = 0;
        const interval = setInterval(() => {
            current += Math.random() * 6 + 2;
            if (current >= 100) {
                current = 100;
                clearInterval(interval);
            }
            this.updateProgress(current, current < 100 ? "CONNECTING TO ARENA SERVER & LOADING MAP..." : "READY TO ENTER ARENA MATCH!");
        }, 250);
    },

    listenFiveMEvents() {
        const thisObj = this;

        window.addEventListener('message', function(e) {
            if (e.data.eventName === 'loadProgress') {
                const percent = Math.round(e.data.loadFraction * 100);
                thisObj.updateProgress(percent, "LOADING FIVEM GAME ASSETS...");
            } else if (e.data.eventName === 'onLogLine') {
                if (e.data.message) {
                    const statusEl = document.getElementById('loading-status');
                    if (statusEl) statusEl.innerText = e.data.message.toUpperCase();
                }
            }
        });
    }
};

document.addEventListener('DOMContentLoaded', () => LoadingApp.init());
